extends RefCounted
"""
An example to show autocompleted value in ApplicationCommand
"""

# Random list of words starting with the letter d
var hints = ["dairy",
	"damage",
	"damn",
	"dance",
	"danger",
	"dangerous",
	"dare",
	"dark",
	"dash",
	"date",
	"daughter",
	"dawn",
	"day",
	"dead",
	"deadly",
	"deal",
	"dealer",
	"death",
	"debate",
	"debt",
	"debut",
	"decade",
	"decay",
	"decide",
	"decisive",
	"deck",
	"declaration",
	"decline"
]

func on_autocomplete(main, bot: DiscordBot, interaction: DiscordInteraction, options: Array) -> void:
	# The part of string which the user is typing
	var part = options[0].value
	#print("received autocomplete: ", part)

	# The final Array of choices for the autocomplete response
	var result = []
	for hint in hints:
		# If the user hasn't typed anything, add all the hints
		if part == "":
			result.append(ApplicationCommand.choice(hint, hint))
		else:
			# If the user has typed some part of string,
			# add only those hints which have the part as a substring
			if hint.findn(part) > -1:
				result.append(ApplicationCommand.choice(hint, hint))

	# Limit the number of results to 25 (Discord's limit is 25)
	if result.size() > 25:
		result = result.slice(0, 24)

	# Respond with the results
	interaction.respond_autocomplete(result)

func execute(main, bot: DiscordBot, interaction: DiscordInteraction, options: Array) -> void:
	# Nothing is done here, except reply back with the text
	interaction.reply({
		"content": "You chose the word: `%s`" % options[0].value
	})

var data = ApplicationCommand.new()\
	.set_name("autocomplete")\
	.set_description("An example command with autocomplete")\
	.add_option(ApplicationCommand.string_option("text", "Type some text to get autocomplete hints.", {
		"required": true,
		"autocomplete": true
	}))
