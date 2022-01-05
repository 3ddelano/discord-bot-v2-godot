extends Reference
"""
Example command to showcase using SelectMenu
"""

func on_ready(main, bot: DiscordBot):
	main.connect("interaction_create", self, "on_interaction")

func on_message(main, bot: DiscordBot, message: Message, channel: Dictionary, args: Array) -> void:

	# Define the Select Menu
	var menu = SelectMenu.new().set_custom_id("menu1")
	menu.set_placeholder("Choose some option")
	menu.set_min_values(1)
	menu.set_max_values(2)

	menu.add_option("option1", "This is option 1", {
		"description": "More info on option1"
	})
	menu.add_option("option2", "This is option 2",{
		"description": "This is a nice parrot!",
		"emoji": {"id": "565171769187500032"}, # Animated parrot emoji
	})

	menu.add_option("option3", "This is option 3")

	var row = MessageActionRow.new().add_component(menu)

	var msg = yield(bot.send(message, {
		"content": "Here's a select menu for you",
		"components": [row]
	}), "completed")

	# Cache this in the interactions
	main.interactions[msg.id] = {
		"author_id": message.author.id
	}

func on_interaction(main, bot: DiscordBot, interaction: DiscordInteraction, data: Dictionary) -> void:
	if not interaction.is_select_menu():
		return

	var custom_id = interaction.data.custom_id

	# Make sure to only handle interaction with menu1 custom_id
	match custom_id:
		"menu1":
			interaction.reply({
				"content": "I received a menu interaction"
			})


func get_usage(p: String) -> String:
	return "`%smenu`" % p

var help = {
	"name": "menu",
	"category": "Menu",
	"aliases": [],
	"enabled": true,
	"description": "Sends some menus",
}
