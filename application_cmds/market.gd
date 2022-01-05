extends Reference
"""
Example command to showcase ApplicationCommand.sub_command_group_option() and .sub_command_option()
"""

func execute(main, bot: DiscordBot, interaction: DiscordInteraction, options: Array) -> void:
	var sub_command_group = options[0].name
	var sub_command = options[0].options[0].name

	print(sub_command_group)
	print(sub_command)

	interaction.reply({
		"content": "Sub command used was: `market %s %s`" % [sub_command_group, sub_command]
	})

var data = ApplicationCommand.new()\
	.set_name("market")\
	.set_description("An example of sub-commands. Buy or sell items from the market.")\
	.add_option(ApplicationCommand.sub_command_group_option("buy", "Buy some fruits or vegetables", {
		"options": [
			ApplicationCommand.sub_command_option("fruit", "Buy a fruit"),
			ApplicationCommand.sub_command_option("vegetable", "Buy a vegetable"),
		]
	}))\
	.add_option(ApplicationCommand.sub_command_group_option("sell", "Sell some fruits or vegetables", {
		"options": [
			ApplicationCommand.sub_command_option("fruit", "Sell a fruit"),
			ApplicationCommand.sub_command_option("vegetable", "Sell a vegetable"),
		]
	}))
