import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import Header from './components/Header';
import TopPage from './pages/TopPage';
import PostDetailPage from './pages/PostDetailPage';
import './App.css';

function App() {
  return (
    <Router>
      <div className="App">
        <Header />
        <main>
          <Routes>
            <Route path="/" element={<TopPage />} />
            <Route path="/posts/:id" element={<PostDetailPage />} />
          </Routes>
        </main>
      </div>
    </Router>
  );
}

export default App;
