const express = require('express');
const app = express();
const PORT = process.env.PORT || 5000;

// 🌟 1. Establish a live in-memory counter variable
let totalRequestsCounter = 0;

function logEvent(level, message, extra = {}) {
    const logPayload = {
        timestamp: new Date().toISOString(),
        level: level,
        message: message,
        ...extra
    };
    console.log(JSON.stringify(logPayload));
}

// Middleware to log incoming requests
app.use((req, res, next) => {
    // 🌟 2. Increment the counter every single time any endpoint is hit
    totalRequestsCounter++;

    logEvent('INFO', `Incoming request: ${req.method} ${req.url}`, {
        method: req.method,
        path: req.url
    });
    next();
});

// Base Route
app.get('/', (req, res) => {
    res.json({ message: "Welcome to the Backend API!" });
});

// Mandatory Health Check Endpoint
app.get('/health', (req, res) => {
    logEvent('INFO', 'Health check endpoint hit');
    res.status(200).json({ status: 'UP', database: 'connected' });
});

// Mandatory Metrics Endpoint
app.get('/metrics', (req, res) => {
    logEvent('INFO', 'Metrics endpoint hit');
    
    res.set('Content-Type', 'text/plain');
    
    // 🌟 3. Dynamically inject the live counter into the Prometheus string format
    res.send(`# HELP api_http_requests_total Total number of HTTP requests\n# TYPE api_http_requests_total counter\napi_http_requests_total ${totalRequestsCounter}\n`);
});

app.get('/error-test', (req, res) => {
    logEvent('ERROR', 'A simulated internal error occurred', { errorCode: 500 });
    res.status(500).json({ error: 'Something went wrong!' });
});

app.listen(PORT, () => {
    logEvent('INFO', `Backend service successfully started on port ${PORT}`);
});