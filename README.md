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
```

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
* myLuna v0.4.0-alpha

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
