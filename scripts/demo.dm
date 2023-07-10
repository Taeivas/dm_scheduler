var
	scheduler
		scheduler
			scheduler = new (interval = world.tick_lag) // High speed scheduler for low latency tasks
			cron = new (interval = 10) // Low speed scheduler for cron tasks

world
	New()
		. = ..()
		scheduler.Schedule("Every 10 Second Run", new /scheduler/timing (second = 10), null, /proc/serialize, list(one = 1, two = 2, three = 3))
		cron.Schedule("Every Minute Run", new /scheduler/timing/cron (minute = "*"), null, /proc/serialize, list(3, 2, 1))
		scheduler.Start()
		cron.Start()

proc
	serialize(one, two, three)
		world << json_encode(args)