#!/usr/bin/env python3

import csv
import sqlite3
import sys
from pathlib import Path


def paths(client):
    root = Path(f"/opt/myLuna/clients/{client}")
    graph = root / "memory" / "graph"
    csv_file = graph / "relationships.csv"
    db_file = graph / "graph.db"
    return root, graph, csv_file, db_file


def init_graph(client):
    root, graph, csv_file, db_file = paths(client)

    if not root.exists():
        print(f"Client not found: {client}")
        sys.exit(1)

    graph.mkdir(parents=True, exist_ok=True)

    if not csv_file.exists():
        with csv_file.open("w", newline="", encoding="utf-8") as f:
            writer = csv.writer(f)
            writer.writerow(["source", "type", "target"])

    conn = sqlite3.connect(db_file)
    cur = conn.cursor()
    cur.execute("""
        CREATE TABLE IF NOT EXISTS relationships (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            source TEXT NOT NULL,
            type TEXT NOT NULL,
            target TEXT NOT NULL,
            created_at TEXT DEFAULT CURRENT_TIMESTAMP
        )
    """)
    conn.commit()
    conn.close()


def add(client, source, rel_type, target):
    root, graph, csv_file, db_file = paths(client)
    init_graph(client)

    with csv_file.open("a", newline="", encoding="utf-8") as f:
        writer = csv.writer(f)
        writer.writerow([source, rel_type, target])

    conn = sqlite3.connect(db_file)
    cur = conn.cursor()
    cur.execute("""
        INSERT INTO relationships (source, type, target)
        VALUES (?, ?, ?)
    """, (source, rel_type, target))
    conn.commit()
    conn.close()

    print(f"Relationship added: {source} {rel_type} {target}")


def list_all(client):
    root, graph, csv_file, db_file = paths(client)
    init_graph(client)

    conn = sqlite3.connect(db_file)
    cur = conn.cursor()
    cur.execute("""
        SELECT source, type, target
        FROM relationships
        ORDER BY created_at DESC
    """)
    rows = cur.fetchall()
    conn.close()

    if not rows:
        print(f"No relationships found for client: {client}")
        return

    print("")
    print(f"Relationships for client: {client}")
    print("================================")
    print("")

    for source, rel_type, target in rows:
        print(f"- {source} {rel_type} {target}")

    print("")


def search(client, entity):
    root, graph, csv_file, db_file = paths(client)
    init_graph(client)

    conn = sqlite3.connect(db_file)
    cur = conn.cursor()
    pattern = f"%{entity}%"

    cur.execute("""
        SELECT source, type, target
        FROM relationships
        WHERE source LIKE ? OR type LIKE ? OR target LIKE ?
        ORDER BY created_at DESC
    """, (pattern, pattern, pattern))

    rows = cur.fetchall()
    conn.close()

    if not rows:
        print(f"No relationships found for: {entity}")
        return

    print("")
    print(f"Relationship search for: {entity}")
    print("================================")
    print("")

    for source, rel_type, target in rows:
        print(f"- {source} {rel_type} {target}")

    print("")

def explore(client, entity):
    root, graph, csv_file, db_file = paths(client)
    init_graph(client)

    conn = sqlite3.connect(db_file)
    cur = conn.cursor()

    cur.execute("""
        SELECT source, type, target
        FROM relationships
        WHERE target = ?
        ORDER BY created_at DESC
    """, (entity,))

    incoming = cur.fetchall()

    cur.execute("""
        SELECT source, type, target
        FROM relationships
        WHERE source = ?
        ORDER BY created_at DESC
    """, (entity,))

    outgoing = cur.fetchall()

    conn.close()

    print("")
    print(f"Entity: {entity}")
    print("")

    print("Incoming Relationships")
    print("----------------------")
    print("")

    if not incoming:
        print("None")
    else:
        for source, rel_type, target in incoming:
            print(f"- {source} {rel_type} {target}")

    print("")
    print("Outgoing Relationships")
    print("----------------------")
    print("")

    if not outgoing:
        print("None")
    else:
        for source, rel_type, target in outgoing:
            print(f"- {source} {rel_type} {target}")

    print("")

def trace(client, entity, max_depth=3):
    root, graph, csv_file, db_file = paths(client)
    init_graph(client)

    conn = sqlite3.connect(db_file)
    cur = conn.cursor()

    cur.execute("""
        SELECT source, type, target
        FROM relationships
    """)

    rows = cur.fetchall()
    conn.close()

    graph_map = {}

    for source, rel_type, target in rows:
        graph_map.setdefault(source, []).append((rel_type, target))

    print("")
    print(f"Trace from: {entity}")
    print("====================")
    print("")

    visited = set()

    def walk(node, depth):
        if depth > max_depth:
            return

        if node in visited:
            print("    " * depth + f"↳ {node} (already visited)")
            return

        visited.add(node)

        if depth == 0:
            print(node)

        children = graph_map.get(node, [])

        for rel_type, target in children:
            indent = "    " * depth
            print(f"{indent}└── {rel_type} → {target}")
            walk(target, depth + 1)

    walk(entity, 0)

    print("")    


def main():
    if len(sys.argv) < 3:
        print("Usage:")
        print("  graph_tool.py add CLIENT SOURCE TYPE TARGET")
        print("  graph_tool.py list CLIENT")
        print("  graph_tool.py search CLIENT ENTITY")
        print("  graph_tool.py explore CLIENT ENTITY")
        print("  graph_tool.py trace CLIENT ENTITY")
        sys.exit(1)

    command = sys.argv[1]
    client = sys.argv[2]

    if command == "add":
        if len(sys.argv) < 6:
            print("Usage: graph_tool.py add CLIENT SOURCE TYPE TARGET")
            sys.exit(1)
        add(client, sys.argv[3], sys.argv[4], sys.argv[5])

    elif command == "list":
        list_all(client)

    elif command == "search":
        if len(sys.argv) < 4:
            print("Usage: graph_tool.py search CLIENT ENTITY")
            sys.exit(1)
        search(client, sys.argv[3])

    elif command == "explore":
        if len(sys.argv) < 4:
            print("Usage: graph_tool.py explore CLIENT ENTITY")
            sys.exit(1)
        explore(client, sys.argv[3])
        
    elif command == "trace":
        if len(sys.argv) < 4:
            print("Usage: graph_tool.py trace CLIENT ENTITY")
            sys.exit(1)
        trace(client, sys.argv[3])    

    else:
        print(f"Unknown command: {command}")
        sys.exit(1)
    
    


if __name__ == "__main__":
    main()