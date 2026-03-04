import './TransactionList.css';

const TYPE_META = {
  deposit:      { label: 'Deposit',      sign: '+', cls: 'positive' },
  withdrawal:   { label: 'Withdrawal',   sign: '-', cls: 'negative' },
  transfer_out: { label: 'Transfer out', sign: '-', cls: 'negative' },
  transfer_in:  { label: 'Transfer in',  sign: '+', cls: 'positive' },
};

export default function TransactionList({ transactions }) {
  const fmt = (n) =>
    new Intl.NumberFormat('en-AU', { style: 'currency', currency: 'AUD' }).format(n);

  const fmtDate = (iso) =>
    new Date(iso).toLocaleString('en-AU', {
      dateStyle: 'medium',
      timeStyle: 'short',
    });

  if (transactions.length === 0) {
    return (
      <div className="tx-empty">
        <p>No transactions yet. Make a deposit to get started!</p>
      </div>
    );
  }

  return (
    <div className="tx-list">
      <h3 className="tx-title">Transaction History</h3>
      {transactions.map((tx) => {
        const meta = TYPE_META[tx.type] || { label: tx.type, sign: '', cls: '' };
        return (
          <div key={tx.id} className="tx-row">
            <div className="tx-left">
              <span className={`tx-badge ${tx.type}`}>{meta.label}</span>
              <span className="tx-desc">{tx.description}</span>
              <span className="tx-date">{fmtDate(tx.created_at)}</span>
            </div>
            <span className={`tx-amount ${meta.cls}`}>
              {meta.sign}{fmt(tx.amount)}
            </span>
          </div>
        );
      })}
    </div>
  );
}
