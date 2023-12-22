#!/usr/bin/env node

const DmnModdle = require("dmn-moddle")

const dmnModdle = new DmnModdle()

var args = process.argv.slice(2)

const source = args[0]

const parseModdle = async (source) => {
  dmnModdle.fromXML(source, 'dmn:Definitions').then((result) => {
    const { rootElement } = result
    process.stdout.write(JSON.stringify(rootElement))
    setTimeout(function() {
      process.exit(0) // this is needed because large writes may not be complete before exiting the process
    }, 50)
  }).catch(function (err) {
    console.error(err)
    process.exit(1)
  })
};

(async () => {
  await parseModdle(source);
})();
