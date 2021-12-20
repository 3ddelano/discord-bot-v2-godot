extends Reference

func on_ready(main, bot: DiscordBot) -> void:
#	main.connect("interaction_create", self, "on_interaction")
	pass

func on_message(main, bot: DiscordBot, message: Message, channel: Dictionary, args: Array) -> void:
	pass

#func on_interaction(main, bot: DiscordBot, interaction: DiscordInteraction, data: Dictionary) -> void:
#	pass

func get_usage(p: String) -> String:
	return "test usage"

#var help = {
#	"name": "test_name",
#	"category": "test_category",
#	"aliases": [],
#	"enabled": true,
#	"description": "test_description",
#}
