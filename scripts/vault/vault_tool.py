#!/usr/bin/env python3

import base64
import getpass
import hashlib
import secrets
import sqlite3
import sys
from pathlib import Path

try:
    from cryptography.fernet import Fernet
except ImportError:
    print("Missing dependency: cryptography")
    print("Run: python3 -m pip install --user cryptography")
    sys.exit(1)


def client_paths(client: str):
    root = Path(f"/opt/myLuna/clients/{client}")
    vault = root / "vault"
    return root, vault, vault / "vault.db", vault / "vault.key"


def get_fernet(key_path: Path):
    raw = key_path.read_text().strip().encode()
    digest = hashlib.sha256(raw).digest()
    return Fernet(base64.urlsafe_b64encode(digest))


def init(client: str):
    root, vault, db, key = client_paths(client)

    if not root.exists():
        print(f"Client not found: {client}")
        sys.exit(1)

    vault.mkdir(parents=True, exist_ok=True)
    (vault / "exports").mkdir(exist_ok=True)

    if not key.exists():
        key.write_text(secrets.token_urlsafe(64))
        key.chmod(0o600)
        print(f"Created vault key: {key}")

    conn = sqlite3.connect(db)
    cur = conn.cursor()
    cur.execute("""
        CREATE TABLE IF NOT EXISTS secrets (
            key_name TEXT PRIMARY KEY,
            encrypted_value TEXT NOT NULL,
            updated_at TEXT DEFAULT CURRENT_TIMESTAMP
        )
    """)
    conn.commit()
    conn.close()
    db.chmod(0o600)

    print(f"Vault ready: {db}")


def add(client: str, key_name: str):
    root, vault, db, key = client_paths(client)

    if not db.exists() or not key.exists():
        init(client)

    value = getpass.getpass(f"Enter value for {key_name}: ")
    if not value:
        print("Secret value cannot be empty.")
        sys.exit(1)

    f = get_fernet(key)
    encrypted = f.encrypt(value.encode()).decode()

    conn = sqlite3.connect(db)
    cur = conn.cursor()
    cur.execute("""
        INSERT INTO secrets (key_name, encrypted_value, updated_at)
        VALUES (?, ?, CURRENT_TIMESTAMP)
        ON CONFLICT(key_name)
        DO UPDATE SET
            encrypted_value=excluded.encrypted_value,
            updated_at=CURRENT_TIMESTAMP
    """, (key_name, encrypted))
    conn.commit()
    conn.close()

    print(f"Secret saved: {key_name}")
    print("Value was not printed.")


def list_keys(client: str):
    root, vault, db, key = client_paths(client)

    if not db.exists():
        print(f"No encrypted vault found for client: {client}")
        return

    conn = sqlite3.connect(db)
    cur = conn.cursor()
    cur.execute("SELECT key_name, updated_at FROM secrets ORDER BY key_name")
    rows = cur.fetchall()
    conn.close()

    if not rows:
        print(f"No secrets found for client: {client}")
        return

    print("")
    print(f"Secrets for client: {client}")
    print("==========================")
    print("")
    for key_name, updated_at in rows:
        print(f"{key_name}    updated: {updated_at}")
    print("")
    print("Values are hidden.")


def export_env(client: str):
    root, vault, db, key = client_paths(client)

    if not db.exists() or not key.exists():
        print(f"No encrypted vault found for client: {client}")
        sys.exit(1)

    f = get_fernet(key)

    conn = sqlite3.connect(db)
    cur = conn.cursor()
    cur.execute("SELECT key_name, encrypted_value FROM secrets ORDER BY key_name")
    rows = cur.fetchall()
    conn.close()

    export_dir = vault / "exports"
    export_dir.mkdir(exist_ok=True)
    export_file = export_dir / "hermes.env"

    lines = []
    for key_name, encrypted_value in rows:
        value = f.decrypt(encrypted_value.encode()).decode()
        lines.append(f"{key_name}={value}")

    export_file.write_text("\n".join(lines) + "\n")
    export_file.chmod(0o600)

    print(f"Exported Hermes env: {export_file}")
    print("Do not share this file publicly.")


def main():
    if len(sys.argv) < 3:
        print("Usage:")
        print("  vault_tool.py init CLIENT")
        print("  vault_tool.py add CLIENT KEY")
        print("  vault_tool.py list CLIENT")
        print("  vault_tool.py export CLIENT")
        sys.exit(1)

    command = sys.argv[1]
    client = sys.argv[2]

    if command == "init":
        init(client)
    elif command == "add":
        if len(sys.argv) < 4:
            print("Usage: vault_tool.py add CLIENT KEY")
            sys.exit(1)
        add(client, sys.argv[3])
    elif command == "list":
        list_keys(client)
    elif command == "export":
        export_env(client)
    else:
        print(f"Unknown command: {command}")
        sys.exit(1)


if __name__ == "__main__":
    main()