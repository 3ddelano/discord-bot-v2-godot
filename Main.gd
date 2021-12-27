extends Node2D
signal interaction_create(world, bot, interaction, data)

const prefix = "gd."

var interactions = {}
var commands = {}
var command_aliases = {}

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
	_load_commands(bot)

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

	# Make sure to use trim_prefix() instead of lstrip()
	var raw_content = message.content.trim_prefix(prefix)
	var tokens = []
	var r = RegEx.new()
	r.compile("\\S+") # Negated whitespace character class
	for token in r.search_all(raw_content):
		tokens.append(token.get_string())
	var cmd_or_alias = tokens[0].to_lower()
	tokens.remove(0) # Remove the command name from the tokens
	var args = tokens
	_handle_command(bot, message, channel, cmd_or_alias, args)

func _load_commands(bot: DiscordBot) -> void:
	var cmd_path = "res://cmds/"
	var dir = Directory.new()
	if dir.open(cmd_path) != OK:
		push_error("An error occurred when trying to open /cmds folder.")
		return

	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "": # End of files
			break
		elif not file.begins_with(".") and (file.ends_with(".gd") or file.ends_with(".gdc")):
			var script = load("res://cmds/" + file.get_basename() + ".gd").new()
			var data = script.help

			# Ensure that the commands don't have the default help values
			assert(data.name != "test_name" and data.category != "test_category" and data.description != "test_description" and script.get_usage(prefix) != "test usage", "Must change default values for Command in " + file)

			if not data.enabled:
				continue

			if script.has_method("on_ready"):
				script.on_ready(self, bot)

			commands[data.name] = script

			if not data.has("aliases"):
				continue

			for alias in data.aliases:
				assert(not command_aliases.has(alias), "Duplicate cmd aliases found in cmd: " + file)

				command_aliases[alias] = data.name

	print("Loaded " + str(commands.size()) + " cmds")
	dir.list_dir_end()

func _handle_command(bot: DiscordBot, message: Message, channel: Dictionary, cmd_or_alias: String, args: Array):
	var cmd = null
	if command_aliases.has(cmd_or_alias):
		print('found ', command_aliases[cmd_or_alias])
		cmd = commands[command_aliases[cmd_or_alias]]
	elif commands.has(cmd_or_alias):
		cmd = commands[cmd_or_alias]

	if cmd == null:
		return

	print("CMD: " + cmd.help.name + " by " + message.author.username + "#" + message.author.discriminator + " (" + message.author.id + ")")
	cmd.on_message(self, bot, message, channel, args)

func remove_components_from_interaction(interaction: DiscordInteraction, msg = ":robot: Components have timed out!") -> void:
	var embed = Embed.new().set_description(msg)
	var new_embeds = interaction.message.embeds + [embed]
	interaction.update({
		"content": interaction.message.content,
		"embeds": new_embeds,
		"components": []
	})

func _on_interaction_create(bot: DiscordBot, interaction: DiscordInteraction):
	var msg_id = interaction.message.id

	# Emit the signal to the commands
	if interactions.has(msg_id):
		emit_signal("interaction_create", self, bot, interaction, interactions[msg_id])
	else:
		remove_components_from_interaction(interaction)
