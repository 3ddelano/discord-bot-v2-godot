extends RefCounted
"""
Sends the latency of the bot
"""

func on_message(main, bot: DiscordBot, message: Message, channel: Dictionary, args: Array) -> void:
	var starttime = Time.get_ticks_msec()
	var msg = await bot.reply(message, "Ping...")
	var latency = str(Time.get_ticks_msec() - starttime)
	bot.edit(msg, "Pong! Latency is " + latency + "ms.")

func get_usage(p: String) -> String:
	return "`%sping`" % p

var help = {
	"name": "ping",
	"category": "System",
	"aliases": ["latency"],
	"enabled": true,
	"description": "Shows the bot latency",
}
