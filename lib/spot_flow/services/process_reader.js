#!/usr/bin/env node

const BpmnModdle = require("bpmn-moddle");

const bpmnModdle = new BpmnModdle({
  zeebe: require("zeebe-bpmn-moddle/resources/zeebe"),
});

var args = process.argv.slice(2);

const source = args[0];

const parseModdle = async (source) => {
  bpmnModdle
    .fromXML(source)
    .then(function (result) {
      process.stdout.write(JSON.stringify(result));
      setTimeout(function () {
        process.exit(0); // this is needed because large writes may not be complete before exiting the process
      }, 50);
    })
    .catch(function (err) {
      console.error(err);
      process.exit(1);
    });
};

(async () => {
  await parseModdle(source);
})();
