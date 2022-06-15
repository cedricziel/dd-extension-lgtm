import React from "react";
import Button from "@mui/material/Button";
import CssBaseline from '@mui/material/CssBaseline';
import { DockerMuiThemeProvider } from '@docker/docker-mui-theme';
import { createDockerDesktopClient } from '@docker/extension-api-client';
import "./App.css";

const client = createDockerDesktopClient();

function useDockerDesktopClient() {
    return client;
}

function App() {
  const [response, setResponse] = React.useState("");
  const ddClient = useDockerDesktopClient();
  const get = async () => {
    const result = await ddClient.extension.vm.service.get("/hello");
    setResponse(JSON.stringify(result));
  };

  return (
    <DockerMuiThemeProvider>
      <CssBaseline />
      <div className="App">
        <Button variant="contained" onClick={get}>
          Call backend
        </Button>
        <pre>{response}</pre>
      </div>
    </DockerMuiThemeProvider>
  );
}

export default App;
