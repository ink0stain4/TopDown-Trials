bulletLifetime = (2*(game_get_speed(gamespeed_fps))) // 0.5 seconds

speedPrev = 3

alarm[0] = bulletLifetime

refreshed = false

piercing = false // penetrative bullet or nah (nah by default)
hitList = ds_list_create()