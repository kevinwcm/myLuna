#!/usr/bin/env python3

import sqlite3
import sys
from pathlib import Path


def client_paths(client):
    root = Path(f"/opt/myLuna/clients/{client}")
    memory = root / "memory"
    db = memory / "db" / "memory_index.sqlite"
    return root, memory, db


def init_db(db):
    db.parent.mkdir(parents=True, exist_ok=True)

    conn = sqlite3.connect(db)
    cur = conn.cursor()

    cur.execute("""
        CREATE TABLE IF NOT EXISTS documents (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            path TEXT UNIQUE NOT NULL,
            title TEXT,
            content TEXT,
            updated_at TEXT DEFAULT CURRENT_TIMESTAMP
        )
    """)

    conn.commit()
    conn.close()


def index_memory(client):
    root, memory, db = client_paths(client)

    if not root.exists():
        print(f"Client not found: {client}")
        sys.exit(1)

    init_db(db)

    md_files = list(memory.rglob("*.md"))

    conn = sqlite3.connect(db)
    cur = conn.cursor()

    for file in md_files:
        content = file.read_text(encoding="utf-8", errors="ignore")
        title = file.stem.replace("_", " ").replace("-", " ").title()
        relative_path = str(file.relative_to(memory))

        cur.execute("""
            INSERT INTO documents (path, title, content, updated_at)
            VALUES (?, ?, ?, CURRENT_TIMESTAMP)
            ON CONFLICT(path)
            DO UPDATE SET
                title=excluded.title,
                content=excluded.content,
                updated_at=CURRENT_TIMESTAMP
        """, (relative_path, title, content))

    conn.commit()
    conn.close()

    print(f"Indexed {len(md_files)} markdown files for client: {client}")
    print(f"Database: {db}")


def search_memory(client, query):
    root, memory, db = client_paths(client)

    if not db.exists():
        print("Memory index not found.")
        print(f"Run: myluna memory-index {client}")
        sys.exit(1)

    conn = sqlite3.connect(db)
    cur = conn.cursor()

    pattern = f"%{query}%"

    cur.execute("""
        SELECT path, title
        FROM documents
        WHERE content LIKE ? OR title LIKE ? OR path LIKE ?
        ORDER BY updated_at DESC
        LIMIT 20
    """, (pattern, pattern, pattern))

    rows = cur.fetchall()
    conn.close()

    if not rows:
        print(f"No memory found for: {query}")
        return

    print("")
    print(f"Memory search results for: {query}")
    print("====================================")
    print("")

    for path, title in rows:
        print(f"- {title} ({path})")

    print("")


def main():
    if len(sys.argv) < 3:
        print("Usage:")
        print("  memory_tool.py index CLIENT")
        print("  memory_tool.py search CLIENT QUERY")
        sys.exit(1)

    command = sys.argv[1]
    client = sys.argv[2]

    if command == "index":
        index_memory(client)

    elif command == "search":
        if len(sys.argv) < 4:
            print("Usage: memory_tool.py search CLIENT QUERY")
            sys.exit(1)
        search_memory(client, sys.argv[3])

    else:
        print(f"Unknown command: {command}")
        sys.exit(1)


if __name__ == "__main__":
    main()