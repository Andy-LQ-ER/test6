"""Transactions router: deposit, withdraw, transfer, and history endpoints."""

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from ..database import get_db
from ..models import Account, Transaction, TransactionType, User
from ..schemas import DepositRequest, TransactionOut, TransferRequest, WithdrawRequest
from .auth import get_current_user

router = APIRouter(prefix="/api/transactions", tags=["transactions"])


@router.post("/deposit", response_model=TransactionOut)
def deposit(
    data: DepositRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
) -> Transaction:
    """Deposit funds into the current user's account."""
    if data.amount <= 0:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Amount must be positive")

    account = current_user.account
    account.balance += data.amount

    tx = Transaction(
        account_id=account.id,
        type=TransactionType.deposit,
        amount=data.amount,
        description="Deposit",
    )
    db.add(tx)
    db.commit()
    db.refresh(tx)
    return tx


@router.post("/withdraw", response_model=TransactionOut)
def withdraw(
    data: WithdrawRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
) -> Transaction:
    """Withdraw funds from the current user's account."""
    if data.amount <= 0:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Amount must be positive")

    account = current_user.account
    if account.balance < data.amount:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Insufficient funds")

    account.balance -= data.amount

    tx = Transaction(
        account_id=account.id,
        type=TransactionType.withdrawal,
        amount=data.amount,
        description="Withdrawal",
    )
    db.add(tx)
    db.commit()
    db.refresh(tx)
    return tx


@router.post("/transfer", response_model=TransactionOut)
def transfer(
    data: TransferRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
) -> Transaction:
    """Transfer funds from the current user's account to another account."""
    if data.amount <= 0:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Amount must be positive")

    from_account = current_user.account
    to_account = db.query(Account).filter(Account.account_number == data.to_account_number).first()

    if not to_account:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Destination account not found")
    if to_account.id == from_account.id:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Cannot transfer to your own account")
    if from_account.balance < data.amount:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Insufficient funds")

    from_account.balance -= data.amount
    to_account.balance += data.amount

    desc = data.description or f"Transfer to {to_account.account_number}"
    out_tx = Transaction(
        account_id=from_account.id,
        to_account_id=to_account.id,
        type=TransactionType.transfer_out,
        amount=data.amount,
        description=desc,
    )
    in_tx = Transaction(
        account_id=to_account.id,
        to_account_id=from_account.id,
        type=TransactionType.transfer_in,
        amount=data.amount,
        description=f"Transfer from {from_account.account_number}",
    )
    db.add(out_tx)
    db.add(in_tx)
    db.commit()
    db.refresh(out_tx)
    return out_tx


@router.get("/history", response_model=list[TransactionOut])
def get_history(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
) -> list[Transaction]:
    """Return the transaction history for the current user's account."""
    return (
        db.query(Transaction)
        .filter(Transaction.account_id == current_user.account.id)
        .order_by(Transaction.created_at.desc())
        .all()
    )
