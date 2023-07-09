var
	scheduler
		scheduler
			scheduler = new (interval = world.tick_lag) // High speed scheduler for low latency tasks
			cron = new (interval = 10) // Low speed scheduler for cron tasks
