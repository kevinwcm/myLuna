# myLuna

Kevin's AI Agent Deployment Platform

---

## Overview

myLuna is a lightweight deployment platform for managing multiple Hermes AI agents across different clients.

The goal is to make agent deployment simple, repeatable, and scalable.

---

## Current Features

* Multi-Client Hermes Deployment
* Client Lifecycle Management
* Encrypted Vault Storage
* Secret Export for Hermes
* Backup & Restore
* Hybrid Memory (Markdown + SQLite)
* Relationship Graph
* Local Vector Search
* Health Checks
* Standardized Client Structure
* AWS Tested Deployment

---

## Quick Start

### 1. Clone Repository

```bash
git clone https://github.com/kevinwcm/myLuna.git

cd myLuna
```

### 2. Run Installer

```bash
chmod +x install.sh

./install.sh
```

### 3. Reconnect To Server

Docker permissions require a new login session.

```bash
exit
```

Reconnect to the server.

### 4. Verify Installation

```bash
myluna health-check
```

Expected:

```text
PASS: 4
FAIL: 0
```

### 5. Create Your First Client

```bash
myluna create-client syspex
```

### 6. Verify Client

```bash
myluna list-clients
```

Expected:

```text
syspex
```

### 7. Configure Hermes

```bash
syspex setup
```

Configure:

* Provider
* Model
* API Key

### 8. Start Using Hermes

```bash
syspex chat
```

or

```bash
syspex gateway start
```

---

## Commands

```bash
# Client

myluna create-client CLIENT_NAME

myluna delete-client CLIENT_NAME

myluna list-clients


# Vault

myluna secret-add CLIENT KEY_NAME

myluna secret-list CLIENT

myluna secret-export CLIENT


# Backup

myluna backup CLIENT

myluna restore CLIENT BACKUP_FILE


# Memory

myluna memory-init CLIENT

myluna memory-index CLIENT

myluna memory-search CLIENT QUERY


# System

myluna health-check


# Graph

myluna graph-add CLIENT SOURCE TYPE TARGET

myluna graph-list CLIENT

myluna graph-search CLIENT ENTITY

myluna graph-explore CLIENT ENTITY

myluna graph-trace CLIENT ENTITY


# Vector

myluna vector-index CLIENT

myluna semantic-search CLIENT QUERY

```

---

## Vector Search

Build vector index:

```bash
myluna vector-index CLIENT
```

Search semantically:

```bash
myluna semantic-search CLIENT QUERY
```

Example:

```bash
myluna semantic-search syspex forklift collision prevention
```

Returns semantically related knowledge even when exact keywords do not exist.

Index knowledge after adding or updating markdown files:

```bash
myluna vector-index CLIENT
```

Then search:

```bash
myluna semantic-search CLIENT QUERY
```

---

## Memory + Graph Search

`myluna memory-search` searches both:

- Markdown memory index
- Relationship graph

Example:

```bash
myluna memory-search syspex ProxiAlert
```

This can return both memory documents and related graph relationships.

---

## Multi-Hop Graph Trace

Trace relationships outward from an entity:

```bash
myluna graph-trace CLIENT ENTITY
```

Example:

```bash
myluna graph-trace syspex Kevin
```

Example output:

```text
Kevin
└── works_for → Syspex
    └── sells → ProxiAlert
```

This can show indirect relationships across the knowledge graph.

---


## Client Structure

```text
/opt/myLuna/clients/CLIENT_NAME

├── memory
├── vault
├── prompts
├── knowledge
├── backups
├── logs
└── metadata
```

---

## Tested Environment

Successfully tested on:

* Ubuntu 24.04 AWS EC2
* Hermes Official Installer
* Docker Backend
* myLuna v0.4.7-alpha

Development machine:

* macOS
* Windows

Deployment target:

* Ubuntu Server

---

## Roadmap

### v0.2.0

* Vault
* Secret Management
* Environment Generation

### v0.3.0

* Hybrid Memory
* Markdown Knowledge Base
* SQLite Index

### v0.4.0

* Review Queue
* Structure Approval Workflow

### v0.5.0

* Relationship Graph
* Memory Relationships

### v0.6.0

* Review Queue
* Structure Approval Workflow

### v0.7.0

* Dashboard
* Client Monitoring
* Backup Monitoring

### v1.0.0

* Production Ready Release
