const {createLogger, transports, format} = require('winston');

const addSeverity = format(info => {
  info.severity = info.level;
  return info;
});

const logger = createLogger({
  level: 'info',
  format: format.combine(
    addSeverity(),
    format.timestamp(),
    format.json()
    // format.prettyPrint(), // Uncomment for local debugging
  ),
  transports: [new transports.Console()],
});

module.exports = {
  logger,
};
