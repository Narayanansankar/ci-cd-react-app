import logo from './logo.svg'; // Assumes you have logo.svg from create-react-app
import './App.css';

function App() {
  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        <h1>React CI/CD Pipeline Demo</h1>
        <p>
          This application is automatically built and deployed using Jenkins and Docker.
        </p>
        <p className="small-text">
          Version 1.0 - Deployed on Friday, October 3, 2025.
        </p>
        <a
          className="App-link"
          href="https://reactjs.org"
          target="_blank"
          rel="noopener noreferrer"
        >
          Learn React
        </a>
      </header>
    </div>
  );
}

export default App;