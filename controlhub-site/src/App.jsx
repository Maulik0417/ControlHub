import React from 'react';
import './App.css';

function App() {
  return (
    <div className="app-container">
      <header className="py-4 text-center text-white bg-dark">
        <h1>ControlHub</h1>
      </header>

      <main className="gradient-background text-white py-5">
        <div className="container">
          <div className="row align-items-center">
            <div className="col-md-6 text-center text-md-start mb-4 mb-md-0">
              <h2>Your Keyboard Shortcut Hub</h2>
              <p className="lead">
                ControlHub lets you bind powerful custom keyboard shortcuts to open apps and trigger actions with ease.
              </p>
              <a
                className="btn btn-light btn-lg mt-3"
                href="https://github.com/YOUR_USERNAME/YOUR_REPO/releases/latest"
                target="_blank"
                rel="noopener noreferrer"
              >
                ⬇️ Download Latest
              </a>
            </div>
            <div className="col-md-6 text-center">
              <img
                src="/app-icon.png"
                alt="App Icon"
                className="img-fluid app-icon"
                style={{ maxWidth: '250px' }}
              />
            </div>
          </div>
        </div>
      </main>

      <footer className="text-center text-white py-3 bg-dark">
        © {new Date().getFullYear()} ControlHub. All rights reserved.
      </footer>
    </div>
  );
}

export default App;