scheduler
	task
		New(name, scheduler/timing/timing, datum/datum, callback, arguments)
			src.name = name
			src.timing = timing
			src.datum = datum
			src.callback = callback
			src.arguments = arguments
		var
			name
			scheduler
				timing/timing
			datum
			callback
			arguments
		proc
			Callback()
				if(arguments)
					call(datum, callback)(arglist(arguments))
				else
					call(datum, callback)()
	datetime
		var
			year
			month
			day_of_week
			day
			hour
			minute
			second
			dow[] = list(
				Mon = 1,
				Tue = 2,
				Wed = 3,
				Thu = 4,
				Fri = 5,
				Sat = 6,
				Sun = 0
			)
		New()
			var/time[] = splittext(time2text(world.realtime, "YYYY-MM-DDD-DD"), "-")
			year = text2num(time[1])
			month = text2num(time[2])
			day_of_week = dow[time[3]]
			day = text2num(time[4])
			time = splittext(time2text(world.timeofday, "hh-mm-ss"), "-")
			hour = text2num(time[1])
			minute = text2num(time[2])
			second = text2num(time[3])


	timing
		New(tick = 0, second = 0, minute = 0, hour = 0)
			src.start_time = world.time
			src.interval = tick + second * 10 + minute * 600 + hour * 36000
		var
			start_time
			interval
		proc
			NextExecution(now)
				return (start_time + interval) < now
		cron
			New(minute = "*", hour = "*", day = "*", month = "*", day_of_week = "*")
				src.minute = ParseField(minute, 0, 59)
				src.hour = ParseField(hour, 0, 23)
				src.day = ParseField(day, 1, 31)
				src.month = ParseField(month, 1, 12)
				src.day_of_week = ParseField(day_of_week, 0, 6)
			var
				minute[]
				hour[]
				day[]
				month[]
				day_of_week[]
				last_exec = 0
			proc
				Range(min_value, max_value, interval = 1)
					. = new /list
					for(var/i = min_value to max_value step interval)
						. += i
				ParseField(field, min_value, max_value)
					if(field == "*")
						return Range(min_value, max_value)
					else if(findtext(field, ","))
						. = new /list
						for(var/f in splittext(field, ","))
							. += ParseField(f, min_value, max_value)
					else if(copytext(field, 1, 3) == "*/")
						field = text2num(copytext(field, 3))
						return Range(min_value, max_value, field)
					else if(findtext(field, "-"))
						field = splittext(field, "-")
						var
							start = text2num(field[1])
							end = text2num(field[2])
						return Range(start, end)
					else
						return clamp(text2num(field), min_value, max_value)
			NextExecution()
				if((world.time - last_exec) >= 10)
				else return FALSE
				var/scheduler/datetime/now = new
				if(now.second == 0)
				else return FALSE
				if(now.minute in minute)
				else return FALSE
				if(now.hour in hour)
				else return FALSE
				if(now.day in day)
				else return FALSE
				if(now.month in month)
				else return FALSE
				if(now.day_of_week in day_of_week)
				else return FALSE
				last_exec = world.time
				return TRUE

	executor
		var
			active = FALSE
			interval
			tasks[] = new
		proc
			Schedule(task)
				tasks += task
			Cancel(scheduler/task/task)
				if(tasks.Find(task))
					tasks -= task
					return TRUE
				else
					return FALSE
			Run(interval)
				if(active) return
				active = TRUE
				src.interval = interval
				while(active)
					var/now = world.time
					for(var/scheduler/task/task in tasks)
						if(task.timing.NextExecution(now))
							task.Callback()
							task.timing.start_time = now
					sleep(src.interval)
				active = FALSE
			Halt()
				active = FALSE
	scheduler
		New(interval = world.tick_lag)
			src.interval = interval
		var
			interval
			scheduler/executor/executor = new
		proc
			Schedule(name, timing, datum/datum, callback, arguments)
				var/scheduler/task/task = new (name, timing, datum, callback, arguments)
				executor.Schedule(task)
				return task
			Cancel(scheduler/task/task)
				return executor.Cancel(task)
			Start()
				set waitfor = FALSE
				executor.Run(interval)
			Stop()
				set waitfor = FALSE
				executor.Halt()