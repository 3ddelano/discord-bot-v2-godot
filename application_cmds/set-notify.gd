extends Reference
"""
Example command to showcase using ApplicationCommand.boolean_option()
"""

func execute(main, bot: DiscordBot, interaction: DiscordInteraction, options: Array) -> void:
	if options[0].value:
		# The user selected True
		interaction.reply({
			"content": ":white_check_mark: Notifications are enabled."
		})
	else:
		# The user selected False
		interaction.reply({
			"content": ":x: Notifications are disabled."
		})

var data = ApplicationCommand.new()\
	.set_name("set-notify")\
	.set_description("Example of boolean option. Toggle notification sending.")\
	.add_option(ApplicationCommand.boolean_option("value", "Enable notifications", {
		"required": true
	}))
