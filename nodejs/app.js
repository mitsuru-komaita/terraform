'use strict';

const { logger } = require('./logging');
const express = require('express');

const app = express();

app.use(express.json());
app.use(express.urlencoded({
    extended: true
}));

app.get('/', (req, res) => {
  res.status(200).send('Hello, world!').end();
});


app.post('/', (req, res, next) => {
    logger.info(req.body)
    res.status(200).send('OK')
});

const PORT = process.env.PORT || 8080;
app.listen(PORT, () => {
  console.log(`App listening on port ${PORT}`);
  console.log('Press Ctrl+C to quit.');
});

module.exports = app;
