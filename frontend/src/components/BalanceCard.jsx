import './BalanceCard.css';

export default function BalanceCard({ account, onDeposit, onWithdraw, onTransfer }) {
  const fmt = (n) =>
    new Intl.NumberFormat('en-AU', { style: 'currency', currency: 'AUD' }).format(n);

  return (
    <div className="balance-card">
      <div className="balance-label">Available Balance</div>
      <div className="balance-amount">{fmt(account.balance)}</div>
      <div className="balance-meta">
        <span>Account No.</span>
        <strong>{account.account_number}</strong>
      </div>
      <div className="balance-actions">
        <button className="action-btn deposit" onClick={onDeposit}>
          ↓ Deposit
        </button>
        <button className="action-btn withdraw" onClick={onWithdraw}>
          ↑ Withdraw
        </button>
        <button className="action-btn transfer" onClick={onTransfer}>
          ⇄ Transfer
        </button>
      </div>
    </div>
  );
}
