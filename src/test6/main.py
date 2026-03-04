"""FastAPI application entry point for the bank API."""

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from .database import Base, engine
from .routers import accounts, auth, transactions

Base.metadata.create_all(bind=engine)

app = FastAPI(title="Bank API", version="1.0.0", docs_url="/api/docs")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:5173"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth.router)
app.include_router(accounts.router)
app.include_router(transactions.router)


@app.get("/")
def root() -> dict[str, str]:
    """Return a health-check message."""
    return {"message": "Bank API is running"}
