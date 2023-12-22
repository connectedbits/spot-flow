# Spot Flow

Spot Flow is a workflow engine for Rails applications based on the [bpmn](https://www.bpmn.org) standard. It executes business processes defined in a [modeler](https://camunda.com/download/modeler/).

Spot Flow uses [Spot Feel](https://github.com/connectedbits/spot-feel) to evaluate expressions and business rules in the BPMN model. It's designed to be extended with custom tasks and events.

## Usage

The engine executes business processes like [this one](/test/fixtures/files/hello_world.bpmn).

![Example](test/fixtures/files/hello_world.png)

To start the process, initialize Spot Flow with the BPMN source, then call `start`.

```ruby
process = SpotFlow.new(File.read("hello_world.bpmn")).start
```

The 'HelloWorld' process begins at the 'Start' event and waits when it reaches the 'SayHello' service task. It's often useful to print the process state to the console.

```ruby
process.print
```

```
HelloWorld started * Flow_0zlro9p

0 StartEvent Start: completed * out: Flow_0zlro9p
1 ServiceTask SayHello: waiting * in: Flow_0zlro9p
```

It's common to save the state the process until a task is complete. For example, a user task might be waiting for a person to complete a form, or a service task might run in a background job. Calling `serialize` on a process will return the execution state so it can be continued later.

```ruby
# Returns a hash of the process state for saving in a database.
execution_state = process.serialize

# Restores the process from the execution state.
process = SpotFlow.new(File.read("hello_world.bpmn")).restore(execution_state)
```

After the task is completed, the waiting step is sent a `signal` with result.

```ruby
step = process.step_by_element_id("SayHello")
step.signal(message: "Hello World!")
```

Now the 'SayHello' task is completed, it's result is merged into the process variables, and the process continues to the 'End' event.

```
HelloWorld completed *

{
  "message": "Hello World!"
}

0 StartEvent Start: completed * out: Flow_0zlro9p
1 ServiceTask SayHello: completed { "message": "Hello World!" } * in: Flow_0zlro9p * out: Flow_1doumjv
2 EndEvent End: completed * in: Flow_1doumjv
```

### Kitchen Sink

The previous example is a simple process with a single task, but BPMN can express more complex workflows.

TODO: Add a kitchen sink example.

## Documentation

- [Processes](/docs/processes.md)
- [Tasks](/docs/tasks.md)
- [Events](/docs/events.md)
- [Event Definitions](/docs/event_definitions.md)
- [Gateways](/docs/gateways.md)
- [Expressions](/docs/expressions.md)
- [Data Flow](/docs/data_flow.md)
- [Execution](/docs/execution.md)

## Installation

Execute:

```bash
$ bundle add spot_flow
```

Or install it directly:

```bash
$ gem install spot_flow
```

## Development

```bash
$ git clone ...
$ bin/setup
$ bin/rake
$ bin/guard
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

Developed by [Connected Bits](http://www.connectedbits.com)
