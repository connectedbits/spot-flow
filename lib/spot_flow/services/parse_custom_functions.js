module.exports = function(files_or_strings) {
  var output = {}
  for (const arg of files_or_strings) {
    var functions
    if (arg[0] == "/") {
      functions = require(arg)
    } else {
      functions = eval(arg)
    }
    output = Object.assign(output, functions)
  }
  return output
}
