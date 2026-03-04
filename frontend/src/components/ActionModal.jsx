import { useState } from 'react';
import './ActionModal.css';

export default function ActionModal({ type, onClose, onSubmit }) {
  const [amount, setAmount] = useState('');
  const [toAccount, setToAccount] = useState('');
  const [description, setDescription] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  const titles = { deposit: 'Deposit funds', withdraw: 'Withdraw funds', transfer: 'Transfer funds' };

  const handleSubmit = async (e) => {
    e.preventDefault();
    const parsed = parseFloat(amount);
    if (!parsed || parsed <= 0) {
      setError('Please enter a valid amount greater than 0.');
      return;
    }
    setError('');
    setLoading(true);
    try {
      await onSubmit({ amount: parsed, to_account_number: toAccount, description });
      onClose();
    } catch (err) {
      setError(err.response?.data?.detail || 'Something went wrong. Please try again.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="modal-overlay" onClick={onClose}>
      <div className="modal-box" onClick={(e) => e.stopPropagation()}>
        <div className="modal-header">
          <h3>{titles[type]}</h3>
          <button className="modal-close" onClick={onClose}>✕</button>
        </div>

        {error && <div className="error-msg">{error}</div>}

        <form onSubmit={handleSubmit}>
          <div className="form-group">
            <label htmlFor="amount">Amount (AUD)</label>
            <input
              id="amount"
              type="number"
              min="0.01"
              step="0.01"
              required
              placeholder="0.00"
              value={amount}
              onChange={(e) => setAmount(e.target.value)}
              autoFocus
            />
          </div>

          {type === 'transfer' && (
            <>
              <div className="form-group">
                <label htmlFor="to_account">Destination account number</label>
                <input
                  id="to_account"
                  type="text"
                  required
                  placeholder="ACC1234567890"
                  value={toAccount}
                  onChange={(e) => setToAccount(e.target.value)}
                />
              </div>
              <div className="form-group">
                <label htmlFor="description">Description (optional)</label>
                <input
                  id="description"
                  type="text"
                  placeholder="e.g. Rent payment"
                  value={description}
                  onChange={(e) => setDescription(e.target.value)}
                />
              </div>
            </>
          )}

          <div className="modal-actions">
            <button type="button" className="btn-cancel" onClick={onClose}>
              Cancel
            </button>
            <button type="submit" className="btn-confirm" disabled={loading}>
              {loading ? 'Processing…' : 'Confirm'}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}
