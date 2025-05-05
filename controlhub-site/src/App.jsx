import React from "react";
import './App.css';

const App = () => {
  const goToGithubRepo = () => {
    window.location.href = "https://github.com/Maulik0417/ControlHub/releases/tag/v1.0.0";
  };

  return (
    <div
      className="d-flex flex-column"
      style={{
        minHeight: '100vh',
        background: 'linear-gradient(to right, #00c6ff, #0072ff)',
      }}
    >
      {/* Header */}
      <header className="bg-dark text-white text-center py-3">
        <h1>Controlhub</h1>
      </header>

      {/* Main Body */}
      <div className="d-flex flex-grow-1 flex-column flex-md-row">
        {/* App Icon First on Mobile */}
        <div className="col-12 col-md-6 d-flex justify-content-center align-items-center p-4 order-1 order-md-2">
          <img src="src/assets/Appicon512.png" alt="App Icon" className="img-fluid" />
        </div>

        {/* Description Second on Mobile */}
        <div className="col-12 col-md-6 d-flex flex-column justify-content-center text-white p-4 order-2 order-md-1">
          <h2>Your macOS Control Hub</h2>
          <p>ControlHub provides Clipboard Management, System Statistics, Quick Notes, and a Calendar.</p>
          <button className="btn btn-light mx-auto" onClick={goToGithubRepo}>
            Go to Latest Release
          </button>
        </div>
      </div>

      {/* Footer */}
      <footer className="bg-dark text-white text-center py-2">
        <p>&copy; 2025 ControlHub. All rights reserved.</p>
      </footer>
    </div>
  );
};

export default App;