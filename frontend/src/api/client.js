import axios from 'axios';

const client = axios.create({
  baseURL: 'http://localhost:8000',
});

client.interceptors.request.use((config) => {
  const token = localStorage.getItem('token');
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

client.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      localStorage.removeItem('token');
      window.location.href = '/login';
    }
    return Promise.reject(error);
  }
);

export const authApi = {
  register: (data) => client.post('/api/auth/register', data),
  login: (email, password) => {
    const form = new URLSearchParams();
    form.append('username', email);
    form.append('password', password);
    return client.post('/api/auth/login', form, {
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    });
  },
  me: () => client.get('/api/auth/me'),
};

export const accountApi = {
  getMyAccount: () => client.get('/api/accounts/me'),
};

export const transactionApi = {
  deposit: (amount) => client.post('/api/transactions/deposit', { amount }),
  withdraw: (amount) => client.post('/api/transactions/withdraw', { amount }),
  transfer: (data) => client.post('/api/transactions/transfer', data),
  history: () => client.get('/api/transactions/history'),
};
