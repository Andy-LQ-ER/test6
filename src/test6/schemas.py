"""Pydantic request/response schemas for the bank API."""

from datetime import datetime

from pydantic import BaseModel, EmailStr


class UserRegister(BaseModel):
    """Schema for user registration requests."""

    email: EmailStr
    full_name: str
    password: str


class Token(BaseModel):
    """Schema for JWT token responses."""

    access_token: str
    token_type: str


class UserOut(BaseModel):
    """Schema for user data returned in responses."""

    id: int
    email: str
    full_name: str
    created_at: datetime

    model_config = {"from_attributes": True}


class AccountOut(BaseModel):
    """Schema for account data returned in responses."""

    id: int
    account_number: str
    balance: float
    created_at: datetime

    model_config = {"from_attributes": True}


class DepositRequest(BaseModel):
    """Schema for deposit requests."""

    amount: float


class WithdrawRequest(BaseModel):
    """Schema for withdrawal requests."""

    amount: float


class TransferRequest(BaseModel):
    """Schema for transfer requests."""

    to_account_number: str
    amount: float
    description: str | None = None


class TransactionOut(BaseModel):
    """Schema for transaction data returned in responses."""

    id: int
    type: str
    amount: float
    description: str | None
    created_at: datetime

    model_config = {"from_attributes": True}
