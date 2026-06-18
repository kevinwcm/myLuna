#!/bin/bash

cd /opt/myLuna

python3 -m uvicorn dashboard.app:app --host 0.0.0.0 --port 8080