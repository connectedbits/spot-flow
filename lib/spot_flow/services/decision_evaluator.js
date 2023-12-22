#!/usr/bin/env node

const { decisionTable } = require("@connectedbits/dmn-eval-js")
const parseCustomFunctions = require("./parse_custom_functions")

var args = process.argv.slice(2)

const decisionId = args[0]
const source = args[1]
const context = JSON.parse(args[2])
Object.assign(context, parseCustomFunctions(args.slice(3)))

const evaluateDecision = async (source) => {
  decisionTable.parseDmnXml(source).then((decisions) => {
    try {
      // Data is the output of the decision execution
      // it is an array for hit policy COLLECT and RULE ORDER, and an object else
      // it is undefined if no rule matched
      const data = decisionTable.evaluateDecision(decisionId, decisions, context)
      process.stdout.write(JSON.stringify(data))
      setTimeout(function() {
        process.exit(0) // this is needed because large writes may not be complete before exiting the process
      }, 50)
    } catch (err) {
      // Failed to evaluate rule, maybe the context is missing some data?
      console.error(err)
      process.exit(1)
    }
  })
}

(async () => {
  await evaluateDecision(source)
})();
