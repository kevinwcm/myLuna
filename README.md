# myLuna

Kevin's AI Agent Deployment Platform

## Overview

myLuna is a lightweight deployment platform for managing multiple Hermes AI agents across different clients.

The goal is to make agent deployment simple, repeatable, and scalable.

## Phase 1 Goal

Deploy a fresh Ubuntu server and get a client agent running quickly.

Example workflow:

```bash
./install.sh

myluna create-client syspex

myluna list-clients

myluna health-check
```

## Current Features

* Hermes profile management
* Client creation
* Client deletion
* Client listing
* Health checks
* Standardized client structure

## Future Roadmap

### Phase 2

* Vault
* Secret management
* Environment generation

### Phase 3

* Hybrid memory
* Markdown knowledge base
* SQLite indexing
* Relationship memory

### Phase 4

* Review queue
* Folder proposal approval
* Memory proposal approval

### Phase 5

* Dashboard
* Client monitoring
* Backup monitoring

## Project Structure

```text
/opt/myLuna

├── clients
├── shared
├── runtime
├── dashboard
└── logs
```

