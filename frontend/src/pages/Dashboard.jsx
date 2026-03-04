import { useCallback, useEffect, useState } from 'react';
import ActionModal from '../components/ActionModal';
import BalanceCard from '../components/BalanceCard';
import TransactionList from '../components/TransactionList';
import { accountApi, transactionApi } from '../api/client';
import './Dashboard.css';

export default function Dashboard() {
  const [account, setAccount] = useState(null);
  const [transactions, setTransactions] = useState([]);
  const [modal, setModal] = useState(null); // 'deposit' | 'withdraw' | 'transfer' | null
  const [loading, setLoading] = useState(true);

  const refresh = useCallback(async () => {
    const [acct, txs] = await Promise.all([
      accountApi.getMyAccount(),
      transactionApi.history(),
    ]);
    setAccount(acct.data);
    setTransactions(txs.data);
  }, []);

  useEffect(() => {
    refresh().finally(() => setLoading(false));
  }, [refresh]);

  const handleAction = async (data) => {
    if (modal === 'deposit')  await transactionApi.deposit(data.amount);
    if (modal === 'withdraw') await transactionApi.withdraw(data.amount);
    if (modal === 'transfer') await transactionApi.transfer(data);
    await refresh();
  };

  if (loading) {
    return <div className="dashboard-loading">Loading your account…</div>;
  }

  return (
    <main className="dashboard">
      <div className="dashboard-inner">
        {account && (
          <BalanceCard
            account={account}
            onDeposit={() => setModal('deposit')}
            onWithdraw={() => setModal('withdraw')}
            onTransfer={() => setModal('transfer')}
          />
        )}
        <TransactionList transactions={transactions} />
      </div>

      {modal && (
        <ActionModal
          type={modal}
          onClose={() => setModal(null)}
          onSubmit={handleAction}
        />
      )}
    </main>
  );
}
