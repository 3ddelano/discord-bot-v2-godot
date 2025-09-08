extends Node2D
signal interaction_create(world, bot, interaction, data)

const prefix = "gd."

var interactions = {}
var commands = {}
var command_aliases = {}
var application_commands = {}

var bookmarks = {}
var favorites = {}

func _load_bot_token() -> String:
	# read from .env file DISORD_BOT_TOKEN
	var lines = FileAccess.get_file_as_string(".env").split("\n")
	for line in lines:
		if line.begins_with("DISCORD_BOT_TOKEN="):
			return line.split("=")[1]
	return ""

func _ready() -> void:
	var bot = DiscordBot.new()
	add_child(bot)

	# Try to read token from global environment variables
	var token = OS.get_environment("DISCORD_BOT_TOKEN")
	if not token or (token and len(token) < 10):
		# Read token from local .env file
		token = _load_bot_token()

	bot.TOKEN = token
	bot.INTENTS = 4609
	bot.bot_ready.connect(_on_bot_ready)
	bot.message_create.connect(_on_message_create)
	bot.interaction_create.connect(_on_interaction_create)
	bot.login()
	_load_commands(bot)
	_load_application_commands(bot)

func _on_bot_ready(bot: DiscordBot):
	print("Logged in as " + bot.user.username + "#" + bot.user.discriminator)
	bot.set_presence({
		"activity": {
			"type": "Game",
			"name": "Discord.gd Tutorial v2 | Godot Engine"
		}
	})

	# Registering commands is not needed on every run,
	# only register the command if you change any options
	# or if you add/remove commands

	# For development use the single server command and
	# once you have the commands working you can register
	# them as global commands

	# -----Single server (updates instantly)
	#_register_application_commands(bot, "guild_id_here")
	#_register_application_commands(bot, "373766421882077186")

	# -----Global (may take upto 1hr to update)
	_register_application_commands(bot)


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
	var dir = DirAccess.open(cmd_path)
	if not dir:
		push_error("An error occurred when trying to open /cmds/ folder.")
		return

	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "": # End of files
			break
		elif not file.begins_with(".") and (file.ends_with(".gd") or file.ends_with(".gdc")):
			var script = load(cmd_path + file.get_basename() + ".gd").new()
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

func _load_application_commands(bot: DiscordBot) -> void:
	var app_cmd_path = "res://application_cmds/"
	var dir = DirAccess.open(app_cmd_path)
	
	if not dir:
		push_error("An error occurred when trying to open /application_cmds/ folder.")
		return

	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "": # End of files
			break
		elif not file.begins_with(".") and (file.ends_with(".gd") or file.ends_with(".gdc")):
			var script = load(app_cmd_path + file.get_basename() + ".gd").new()
			var data = script.data

			# Ensure that the commands don't have the default help values
			assert(data.name != "test_name" and data.description != "test_description", "Must change default values for ApplicationCommand in " + file)

			if script.has_method("on_ready"):
				script.on_ready(self, bot)

			application_commands[data.name] = script

	print("Loaded " + str(application_commands.size()) + " application cmds")
	dir.list_dir_end()

func _register_application_commands(bot, guild_id: String = "") -> void:
	var application_commands_data = []
	for app_cmd in application_commands.values():
		application_commands_data.append(app_cmd.data)

	bot.register_commands(application_commands_data, guild_id)

func _handle_command(bot: DiscordBot, message: Message, channel: Dictionary, cmd_or_alias: String, args: Array):
	var cmd = null
	if command_aliases.has(cmd_or_alias):
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
	# Handle ApplicationCommand
	if interaction.is_command() or interaction.is_autocomplete():
		var cmd_name = interaction.data.name
		if application_commands.has(cmd_name):
			# The application command was found, so execute it
			var app_cmd = application_commands[cmd_name]
			var options = interaction.data.options if interaction.data.has("options") else []

			if interaction.is_autocomplete():
				# It is an autocomplete command
				app_cmd.on_autocomplete(self, bot, interaction, options)
				return

			print("APP_CMD: " + app_cmd.data.name + " by " + interaction.member.user.username + "#" + interaction.member.user.discriminator + " (" + interaction.member.user.id + ")")
			app_cmd.execute(self, bot, interaction, options)
		else:
			# The application command was not found
			interaction.reply({
				"ephemeral": true,
				"content": ":electric_plug: The requested command was not found."
			})
		return

	var msg_id = interaction.message.id
	# Emit the interaction to the normal (text) commands
	if interactions.has(msg_id):
		emit_signal("interaction_create", self, bot, interaction, interactions[msg_id])
	else:
		remove_components_from_interaction(interaction)
