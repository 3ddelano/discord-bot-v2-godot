extends Node2D

const prefix = "gd."

var interactions = {}

func _ready() -> void:
	var bot = DiscordBot.new()
	add_child(bot)

	var file = File.new()
	file.open("res://token.secret", File.READ)
	var token = file.get_as_text()

	if token == null or token == "":
		push_error("Bot TOKEN missing")

	bot.TOKEN = token
	bot.connect("bot_ready", self, "_on_bot_ready")
	bot.connect("message_create", self, "_on_message_create")
	bot.connect("interaction_create", self, "_on_interaction_create")
	bot.login()

func _on_bot_ready(bot: DiscordBot):
	print("Logged in as " + bot.user.username + "#" + bot.user.discriminator)
	bot.set_presence({
		"activity": {
			"type": "Game",
			"name": "Discord.gd Tutorial v2 | Godot Engine"
		}
	})

func _on_message_create(bot: DiscordBot, message: Message, channel: Dictionary) -> void:
	if message.author.bot or not message.content.begins_with(prefix):
		return

	var raw_content = message.content.lstrip(prefix)
	var tokens = []
	var r = RegEx.new()
	r.compile("\\S+") # Negated whitespace character class
	for token in r.search_all(raw_content):
		tokens.append(token.get_string())
	var cmd_or_alias = tokens[0].to_lower()
	tokens.remove(0) # Remove the command name from the tokens
	var args = tokens
	_handle_command(bot, message, channel, cmd_or_alias, args)

func _handle_command(bot: DiscordBot, message: Message, channel: Dictionary, cmd: String, args: Array):

	match cmd:
		"ping":
			# Sends bot latency
			var starttime = OS.get_ticks_msec() # start epoch
			var msg = yield(bot.reply(message, "Ping..."), "completed") # Wait for message to be sent

			var latency = str(OS.get_ticks_msec() - starttime)

			bot.edit(msg, "Pong! My latency is " + latency + " ms.")

		"image":
			# Sends the guild icon
			var guild_id = message.guild_id
			var bytes = yield(bot.get_guild_icon(guild_id), "completed")

			var image = Helpers.to_png_image(bytes)
			var texture = Helpers.to_image_texture(image)

			$GuildIcon.texture = texture

			bot.send(message, {
				"files": [
					{
						"name": "avatar.png",
						"media_type": "image/png",
						"data": bytes
					}
				]
			})

		"button":
			# Shows some buttons
			var button = MessageButton.new().set_style(MessageButton.STYLES.DEFAULT)
			button.set_custom_id("my_custom_button").set_label("Click Me")

			var button2 = MessageButton.new().set_style(MessageButton.STYLES.DANGER)
			button2.set_custom_id("my_custom_button2").set_label("Do not Click Me")

			var row = MessageActionRow.new()
			var row2 = MessageActionRow.new()

			row.add_component(button)
			row2.add_component(button2)

			var msg = yield(bot.send(message, {
				"content": "Here's some buttons",
				"components": [row, row2]
			}), "completed")

			# Cache the message with buttons
			interactions[msg.id] = {
				"author_id": message.author.id,
			}

		"embed":
			# Sends an embed
			var embed1 = Embed.new().set_description("First Embed").set_color("#ff0000")
			var embed2 = Embed.new().set_description("Second Embed").set_color("#00ff00")

			var msg = yield(bot.send(message, 'Content here too', {
				"embeds": [embed1, embed2]
			}), "completed")

func _on_interaction_create(bot: DiscordBot, interaction: DiscordInteraction):
	# If not a button then return
	if not interaction.is_button():
		return

	var msg_id = interaction.message.id

	if not interactions.has(msg_id):
		# Disable the buttons from the messaage if the interaction is not cached
		for row in interaction.message.components:
			for component in row.components:
				if component.type == 2:
					component["disabled"] = true

		interaction.update({
			"content": interaction.message.content,
			"components": interaction.message.components
		})

		return

	match interaction.data.custom_id:
		"my_custom_button":
			interaction.reply({
				"content": "You pressed the button."
			})

		"my_custom_button2":
			interaction.reply({
				"content": "Why did you press me?"
			})
