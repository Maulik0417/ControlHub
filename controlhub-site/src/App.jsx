import React from "react";
import "bootstrap/dist/css/bootstrap.min.css";

const App = () => {
  return (
    <div className="bg-light min-vh-100 d-flex flex-column align-items-center justify-content-center text-center p-4">
      <img
        src="/app-screenshot.png"
        alt="ControlHub Screenshot"
        className="img-fluid rounded shadow mb-4"
        style={{ maxWidth: "400px" }}
      />
      <h1 className="display-5 fw-bold mb-3">ControlHub</h1>
      <p className="lead mb-4">
        ControlHub is a lightweight macOS app that lets you trigger apps and actions with custom keyboard shortcuts.
      </p>
      <a
        href="https://github.com/YOUR_USERNAME/ControlHub/releases/latest"
        className="btn btn-primary btn-lg"
        target="_blank"
        rel="noopener noreferrer"
      >
        Download for macOS
      </a>
    </div>
  );
};

export default App;