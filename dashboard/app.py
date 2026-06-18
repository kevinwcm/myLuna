from pathlib import Path

from fastapi import FastAPI
from fastapi.responses import HTMLResponse
from fastapi.templating import Jinja2Templates
from fastapi import Request

app = FastAPI(title="myLuna Dashboard")

templates = Jinja2Templates(directory="dashboard/templates")

CLIENTS_ROOT = Path("/opt/myLuna/clients")


@app.get("/", response_class=HTMLResponse)
async def home(request: Request):

    client_count = 0

    if CLIENTS_ROOT.exists():
        client_count = len(
            [p for p in CLIENTS_ROOT.iterdir() if p.is_dir()]
        )

    return templates.TemplateResponse(
        "index.html",
        {
            "request": request,
            "client_count": client_count,
        },
    )


@app.get("/clients", response_class=HTMLResponse)
async def clients(request: Request):

    clients = []

    if CLIENTS_ROOT.exists():
        clients = sorted(
            [
                p.name
                for p in CLIENTS_ROOT.iterdir()
                if p.is_dir()
            ]
        )

    return templates.TemplateResponse(
        "clients.html",
        {
            "request": request,
            "clients": clients,
        },
    )