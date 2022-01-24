extends Reference
"""
Example command to showcase using choices and ApplicationCommand.choice()
"""

func execute(main, bot: DiscordBot, interaction: DiscordInteraction, options: Array) -> void:
	var location = options[0].value
	#print(location)
	interaction.reply({
		"content": "Your location was set to: `%s`" % location
	})

var data = ApplicationCommand.new()\
	.set_name("set-location")\
	.set_description("Example of choices for string option. Sets your location.")\
	.add_option(ApplicationCommand.string_option("continent", "The name of the continent", {
		"required": true,
		# Provide a fixed set of choices to choose from
		"choices": [
			ApplicationCommand.choice("Asia", "asia"),
			ApplicationCommand.choice("Europe", "europe"),
			ApplicationCommand.choice("South America", "south-america"),
			ApplicationCommand.choice("North America", "north-america"),
			ApplicationCommand.choice("Antartica", "antartica"),
			ApplicationCommand.choice("Africa", "africa"),
			ApplicationCommand.choice("Oceania", "oceania"),
		]
	}))
