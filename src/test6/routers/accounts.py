"""Accounts router: view account details and balance."""

from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from ..database import get_db
from ..models import Account, User
from ..schemas import AccountOut
from .auth import get_current_user

router = APIRouter(prefix="/api/accounts", tags=["accounts"])


@router.get("/me", response_model=AccountOut)
def get_my_account(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
) -> Account:
    """Return the bank account of the currently authenticated user."""
    return current_user.account
