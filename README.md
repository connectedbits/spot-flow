# Spot Flow

Spot Flow is a workflow engine for Rails applications based on the [bpmn](https://www.bpmn.org) standard. It executes business processes defined in a [modeler](https://camunda.com/download/modeler/). It uses [Spot Feel](https://github.com/connectedbits/spot-feel) to evaluate expressions and business rules in the BPMN model. It can be used with [Spot Form](https://github.com/connectedbits/spot-form) to render dynamic forms for user tasks.

## Usage

### Simple Example - Hello World

The engine executes business processes like [this one](/test/fixtures/files/hello_world.bpmn).

<img src="test/fixtures/files/hello_world.png" alt="Hello World BPMN" style="width:400px;"/>

To start the process, initialize Spot Flow with the BPMN source, then call `start`.

```ruby
processes = SpotFlow.processes_from_xml(File.read("hello_world.bpmn"))
execution = SpotFlow.new(processes:).start
```

The 'HelloWorld' process begins at the 'Start' event and waits when it reaches the 'SayHello' service task. It's often useful to print the process state to the console.

```ruby
execution.print
```

```ruby
HelloWorld started * Flow_0zlro9p

0 StartEvent Start: completed * out: Flow_0zlro9p
1 ServiceTask SayHello: waiting * in: Flow_0zlro9p
```

It's common to save the state the process until a task is complete. For example, a user task might be waiting for a person to complete a form, or a service task might run in a background job. Calling `serialize` on a process will return the execution state so it can be continued later.

```ruby
# Returns a hash of the process state for saving in a database.
execution_state = execution.serialize

# Restores the process from the execution state.
processes = SpotFlow.processes_from_xml(File.read("hello_world.bpmn"))
execution = SpotFlow.new(processes:).restore(execution_state)
```

After the task is completed, the waiting step is sent a `signal` with result.

```ruby
step = execution.step_by_element_id("SayHello")
step.signal(message: "Hello World!")
```

Now the 'SayHello' task is completed, it's result is merged into the process variables, and the process continues to the 'End' event.

```ruby
HelloWorld completed *

{
  "message": "Hello World!"
}

0 StartEvent Start: completed * out: Flow_0zlro9p
1 ServiceTask SayHello: completed { "message": "Hello World!" } * in: Flow_0zlro9p * out: Flow_1doumjv
2 EndEvent End: completed * in: Flow_1doumjv
```

### Complex Example - Kitchen Sink

The previous example is a simple process with a single task, but BPMN can express more [complex workflows](/test/fixtures/files/kitchen_sink.bpmn).

![Example](test/fixtures/files/kitchen_sink.png)

The context provides information the engine will require to execute the process. Since the 'KitchenSink' process has a user, service, script, and business rule tasks it requires a bit more setup.

```ruby
# Setup the context
context = SpotFlow.new(
  processes: SpotFlow.processes_from_xml(File.read("kitchen_sink.bpmn")),
  decisions: SpotFlow.decisions_from_xml(File.read("greeting.dmn")),
  job_workers: {
    "generate_fortune": -> (execution) {
      [
        "The fortune you seek is in another cookie.",
        "A closed mouth gathers no feet.",
        "A conclusion is simply the place where you got tired of thinking.",
        ...
        "If a turtle doesn’t have a shell, is it naked or homeless?",
        "Change is inevitable, except for vending machines.",
        "Don’t eat the paper.",
      ].sample
    },
  }
)
```

To better understand how the engine works, we'll explore two different paths.

#### Scenario 1 - Happy Path

The "Happy Path" is the most common path through a process. It's the path that executes when everything goes right. We start the process by calling start on the context we setup previously. Event though there are multiple start events the engine will default to a simple start event.

```ruby
context.start
```

#### Scenario 2 - Error Path

In this scenario, we'll explore what happens when something goes wrong. We'll start the process with a message event.

```ruby
context.start(message: "error")
```

TODO: complete the kitchen sink example.

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
