# Scheduler Module

The Scheduler module is designed to enable task scheduling with flexible timing options.

## `task`

The `task` is the unit of work to be scheduled.

### Constructor: `New(name, scheduler/timing/timing, datum/datum, callback, arguments)`

Creates a new task.

- `name`: Task name
- `timing`: Timing instance (`scheduler/timing/timing`)
- `datum`: The datum instance that the task will call upon.
- `callback`: The procedure to be called when the task is executed.
- `arguments`: The arguments to be passed to the callback procedure.

### Variables

- `name`: Name of the task
- `timing`: The timing instance (`scheduler/timing/timing`)
- `datum`: The datum instance that the task will call upon.
- `callback`: The procedure to be called when the task is executed.
- `arguments`: The arguments to be passed to the callback procedure.

### Procedures

- `Callback()`: Calls the callback procedure with or without arguments, depending on whether `arguments` is populated.

## `datetime`

The `datetime` provides date and time information. It includes variables for the year, month, day of the week (dow), day, hour, minute, and second. 

### Constructor: `New()`

Creates a new `datetime` instance, initializing the date and time to the current system time.

## `timing`

The `timing` provides timing information for tasks.

### Constructor: `New(tick = 0, second = 0, minute = 0, hour = 0)`

Creates a new `timing` instance.

- `tick`: The tick interval.
- `second`: The second interval.
- `minute`: The minute interval.
- `hour`: The hour interval.

### Variables

- `start_time`: The start time of the timing instance.
- `interval`: The time interval for the task.

### Procedures

- `NextExecution(now, scheduler/datetime/datetime)`: Returns whether the next execution is due given the current time (`now`) and the `datetime` instance.

## `cron`

The `cron` allows cron-like scheduling.

### Constructor: `New(minute = "*", hour = "*", day = "*", month = "*", day_of_week = "*")`

Creates a new `cron` instance.

- `minute`: The minute field in cron format.
- `hour`: The hour field in cron format.
- `day`: The day field in cron format.
- `month`: The month field in cron format.
- `day_of_week`: The day of the week field in cron format.

## `executor`

The `executor` runs tasks.

### Variables

- `active`: Indicates whether the executor is currently active.
- `interval`: The interval between task executions.
- `tasks[]`: The list of tasks.

### Procedures

- `Schedule(task)`: Schedules a task.
- `Cancel(scheduler/task/task)`: Cancels a scheduled task.
- `Run(interval)`: Starts running tasks at the given interval.
- `Halt()`: Stops running tasks.

## `scheduler`

The `scheduler` manages the scheduling and execution of tasks.

### Constructor: `New(interval = world.tick_lag)`

Creates a new `scheduler` instance.

- `interval`: The interval between task executions.

### Variables

- `interval`: The interval between task executions.
- `scheduler/executor/executor`: The executor that runs the tasks.

### Procedures

- `Schedule(name, timing, datum/datum, callback, arguments)`: Schedules a task.
- `Cancel(scheduler/task/task)`: Cancels a scheduled task.
- `Start()`: Starts the scheduler.
- `Stop()`: Stops the scheduler.