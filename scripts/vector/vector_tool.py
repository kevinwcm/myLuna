#!/usr/bin/env python3

import json
import pickle
import sys
from pathlib import Path

import numpy as np

try:
    from sentence_transformers import SentenceTransformer
except ImportError:
    print("Missing dependency: sentence-transformers")
    print("Run: python3 -m pip install --user sentence-transformers numpy --break-system-packages")
    sys.exit(1)


MODEL_NAME = "sentence-transformers/all-MiniLM-L6-v2"


def client_paths(client):
    root = Path(f"/opt/myLuna/clients/{client}")
    memory = root / "memory"
    vectors = memory / "vectors"
    index_file = vectors / "index.pkl"
    metadata_file = vectors / "metadata.json"
    model_file = vectors / "model.txt"
    return root, memory, vectors, index_file, metadata_file, model_file


class LocalEmbeddingProvider:
    def __init__(self):
        self.model = SentenceTransformer(MODEL_NAME)

    def embed(self, texts):
        return self.model.encode(texts, normalize_embeddings=True)


def load_provider():
    return LocalEmbeddingProvider()


def collect_markdown(memory):
    files = []

    for folder in ["core", "style", "formats", "projects", "knowledge"]:
        target = memory / folder
        if not target.exists():
            continue

        for file in target.rglob("*.md"):
            content = file.read_text(encoding="utf-8", errors="ignore").strip()

            if not content:
                continue

            files.append({
                "path": str(file.relative_to(memory)),
                "title": file.stem.replace("_", " ").replace("-", " ").title(),
                "content": content,
            })

    return files


def vector_index(client):
    root, memory, vectors, index_file, metadata_file, model_file = client_paths(client)

    if not root.exists():
        print(f"Client not found: {client}")
        sys.exit(1)

    vectors.mkdir(parents=True, exist_ok=True)

    docs = collect_markdown(memory)

    if not docs:
        print(f"No markdown documents found for client: {client}")
        return

    provider = load_provider()

    texts = [doc["content"] for doc in docs]
    embeddings = provider.embed(texts)

    with index_file.open("wb") as f:
        pickle.dump(embeddings, f)

    metadata = {
        "model": MODEL_NAME,
        "documents": docs,
    }

    metadata_file.write_text(json.dumps(metadata, indent=2), encoding="utf-8")
    model_file.write_text(MODEL_NAME, encoding="utf-8")

    print(f"Vector index created for client: {client}")
    print(f"Documents indexed: {len(docs)}")
    print(f"Index: {index_file}")


def semantic_search(client, query, top_k=5):
    root, memory, vectors, index_file, metadata_file, model_file = client_paths(client)

    if not index_file.exists() or not metadata_file.exists():
        print("Vector index not found.")
        print(f"Run: myluna vector-index {client}")
        sys.exit(1)

    with index_file.open("rb") as f:
        embeddings = pickle.load(f)

    metadata = json.loads(metadata_file.read_text(encoding="utf-8"))
    docs = metadata["documents"]

    provider = load_provider()
    query_embedding = provider.embed([query])[0]

    scores = np.dot(embeddings, query_embedding)

    ranked = np.argsort(scores)[::-1][:top_k]

    print("")
    print(f"Semantic search results for: {query}")
    print("========================================")
    print("")

    for rank, idx in enumerate(ranked, start=1):
        doc = docs[int(idx)]
        score = float(scores[int(idx)])
        print(f"{rank}. {doc['title']} ({doc['path']})")
        print(f"   score: {score:.4f}")
        print("")


def main():
    if len(sys.argv) < 3:
        print("Usage:")
        print("  vector_tool.py index CLIENT")
        print("  vector_tool.py search CLIENT QUERY")
        sys.exit(1)

    command = sys.argv[1]
    client = sys.argv[2]

    if command == "index":
        vector_index(client)

    elif command == "search":
        if len(sys.argv) < 4:
            print("Usage: vector_tool.py search CLIENT QUERY")
            sys.exit(1)

        query = " ".join(sys.argv[3:])
        semantic_search(client, query)

    else:
        print(f"Unknown command: {command}")
        sys.exit(1)


if __name__ == "__main__":
    main()