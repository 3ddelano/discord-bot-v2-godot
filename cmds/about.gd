extends RefCounted
"""
Sends some basic information about the bot
"""

var started_epoch

func on_ready(main, bot: DiscordBot):
	# Sets the current epoch timestamp so that we can use it later to calculate how long the bot is running
	started_epoch = Time.get_ticks_msec()

func on_message(main, bot: DiscordBot, message: Message, channel: Dictionary, args: Array) -> void:
	var time_running = Time.get_ticks_msec() - started_epoch
	var embed = Embed.new().set_title("About Me").set_timestamp().set_color("#f2b210")

	embed.set_description("I am made by `3ddelano#6033` using the Godot Engine and an open-source plugin called Discord.gd.\n\nSource Code: [Github Repo](https://github.com/3ddelano/discord-bot-v2-godot)\n\n[Join Support Server](https://discord.gg/FZY9TqW)\n[Support My Creator](https://www.buymeacoffee.com/3ddelano)")

	embed.set_thumbnail(bot.user.get_display_avatar_url())
	embed.add_field("Godot Version", Engine.get_version_info().string, true)
	embed.add_field("Uptime", _millis_to_string(time_running))

	bot.send(message, {
		"embeds": [embed]
	})

func _millis_to_string(millis: int) -> String:
	var days = -1
	days = int(millis / 86400000)
	millis -= days * 86400000

	var hours = -1
	hours = int(millis / 3600000)
	millis -= hours * 3600000

	var minutes = -1
	minutes = int(millis / 60000)
	millis -= minutes * 60000

	var seconds = -1
	seconds = int(millis / 1000)
	millis -= seconds * 1000

	var ret = []
	if days:
		if days == 1:
			ret.append(str(days) + " day")
		else:
			ret.append(str(days) + " days")
	if hours:
		if hours == 1:
			ret.append(str(hours) + " hour")
		else:
			ret.append(str(hours) + " hours")
	if minutes:
		if minutes == 1:
			ret.append(str(minutes) + " minute")
		else:
			ret.append(str(minutes) + " minutes")
	if seconds:
		if seconds == 1:
			ret.append(str(seconds) + " second")
		else:
			ret.append(str(seconds) + " seconds")


	return ', '.join(PackedStringArray(ret))

func get_usage(p: String) -> String:
	return "`%sabout`" % p

var help = {
	"name": "about",
	"category": "System",
	"aliases": ["info"],
	"enabled": true,
	"description": "Know a little more about me"
}
