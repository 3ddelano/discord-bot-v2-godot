extends RefCounted
"""
Simply replies back with the same text
"""

func execute(main, bot: DiscordBot, interaction: DiscordInteraction, options: Array) -> void:
	interaction.reply({
		"content": options[0].value
	})

var data = ApplicationCommand.new().set_name("say").set_description("Copies what you typed")\
	.add_option(ApplicationCommand.string_option("text", "Type some text", {
		"required": true
	}))
