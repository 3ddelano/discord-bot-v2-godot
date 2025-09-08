extends RefCounted
"""
Sends some information about a user
"""

func on_message(main, bot: DiscordBot, message: Message, channel: Dictionary, args: Array) -> void:
	var user_id = message.author.id

	if message.mentions.size() > 0:
		# Got a user mention
		user_id = message.mentions[0].id
	elif args.size() == 1:
		# Got a user Id
		user_id = args[0]

	var member = await bot.get_guild_member(message.guild_id, user_id)

	if member.has("code"):
		# User was not found
		bot.reply(message, "User not found. Make sure you mention a user or specify a valid user Id.")
		return

	var user = User.new(bot, member.user)

	var embed = Embed.new()
	embed.set_title("User infomation for %s#%s" % [member.user.username, member.user.discriminator])
	embed.set_timestamp().set_color("#4084e3")

	embed.set_image(user.get_display_avatar_url({
		"format": "webp",
		"size": 128
	}))
	if member.nick:
		embed.add_field("Nickname", member.nick)

	embed.add_field("User Id", user_id)
	embed.add_field("Joined Server", "<t:%s:R>" % Helpers.iso2unix(member.joined_at))

	var has_nitro
	if not member.premium_since == null:
		has_nitro = "Yes, since <t:%s:R>" % Helpers.iso2unix(member.premium_since)
	else:
		has_nitro = "No"

	embed.add_field("Has Nitro?", has_nitro)
	embed.add_field("Is Muted?", "Yes" if member.mute else "No")
	embed.set_footer("Requested by %s#%s" % [message.author.username, message.author.discriminator])

	var roles = ""
	if member.roles.size() > 0:
		roles = []
		for role in member.roles:
			roles.append("<@&%s>" % role)

		roles = " ".join(PackedStringArray(roles))
	else:
		roles = "None"

	embed.add_field("Roles", roles)
	bot.reply(message, {"embeds": [embed]})

func get_usage(p: String) -> String:
	return "`%suserinfo [@someone]`" % p

var help = {
	"name": "userinfo",
	"category": "General",
	"aliases": [],
	"enabled": true,
	"description": "Shows some information about a user",
}
