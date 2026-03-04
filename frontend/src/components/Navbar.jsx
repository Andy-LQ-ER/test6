import { useNavigate } from 'react-router-dom';
import './Navbar.css';

export default function Navbar({ user }) {
  const navigate = useNavigate();

  const handleLogout = () => {
    localStorage.removeItem('token');
    navigate('/login');
  };

  return (
    <nav className="navbar">
      <div className="navbar-brand">
        <span className="logo-icon">🏦</span>
        <span className="brand-name">VaultBank</span>
      </div>
      <div className="navbar-right">
        {user && <span className="user-name">Hello, {user.full_name.split(' ')[0]}</span>}
        <button className="btn-logout" onClick={handleLogout}>Sign out</button>
      </div>
    </nav>
  );
}
