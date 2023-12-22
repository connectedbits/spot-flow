function blah(arg1) {
  return "blah blah blah"
}

function formatDateTime(time, format) {
  return time.format(format)
}

module.exports = {
  "blah":            blah,
  "format datetime": formatDateTime,
}
