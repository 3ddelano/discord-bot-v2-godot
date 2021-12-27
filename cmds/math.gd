extends Reference
var first_digit = RegEx.new()
var last_digit = RegEx.new()

func on_ready(main, bot: DiscordBot):
	main.connect("interaction_create", self, "on_interaction")
	bot.connect("message_create", self, "on_bot_message_create")

	first_digit.compile("^[-]?(?'first'[1-9])(?'remaining'[0-9]*)$")
	last_digit.compile("^[-]?(?'remaining'[1-9][0-9]*)(?'last'[0-9])$")

func on_message(main, bot: DiscordBot, message: Message, channel: Dictionary, args: Array) -> void:
	# Get question data for first question
	var ques_data = _gen_question()
	# Store various important data for this interaction
	var data = {
		"author_id": message.author.id,
		"author_tag": message.author.username + "#" + message.author.discriminator,
		# Stats
		"question_num": 1,
		"correct_num": 0,
		# Question data
		"question": ques_data.question,
		"correct_idx": ques_data.correct_idx,
		"answers": ques_data.answers,
	}

	var msg = yield(bot.send(message, _make_message(data)), "completed")
	# Cache this in the interactions
	main.interactions[msg.id] = data

func _make_message(data: Dictionary) -> Dictionary:

	var menu = SelectMenu.new().set_custom_id("math").set_placeholder("Choose the correct option")
	# Add the four options to the menu
	for i in range(data.answers.size()):
		menu.add_option(str(i), data.answers[i])

	var row = MessageActionRow.new().add_component(menu)
	# The message will have one embed and the menu
	return {
		"embeds": [
			Embed.new().set_color("#73c6f0").set_title("Math Quiz Game")                                          .set_footer("Requested by " + data.author_tag).set_timestamp()                                               .set_description("Correct: %s" % str(data.correct_num)),
			Embed.new().set_color("#73c6f0").set_description("Question %s\n**%s**" % [str(data.question_num), data.question])
			],
		"components": [row]
	}

func _gen_question() -> Dictionary:
	# This method is used to generate a new question.
	# It returns a Dictionary containing the question (String),
	# an Array of answers and the index of the correct answer.

	var min_num = 2
	var max_num = 20
	var operations = ["+", "-", "*"]

	randomize()
	operations.shuffle()

	var operation = operations[0]
	# Generate two random numbers between the min and max
	var num1 = randi() % max_num + min_num
	var num2 = randi() % max_num + min_num
	var correct

	match operation:
		"+":
			correct = num1 + num2
		"-":
			correct = num1 - num2
		"*":
			correct = num1 * num2

	var answers = [str(correct)]

	# Add 1 random wrong answer
	var rand_inc = floor(rand_range(-20, 20))
	if rand_inc == 0:
		rand_inc = randi() % 10 + 1
	answers.append(str(correct + rand_inc))

	correct = str(correct)

	# Add one wrong answer whose 1st digit is wrong
	var wrong2 = correct
	while wrong2 == correct:
		wrong2 = "-" if correct[0] == "-" else ""
		wrong2 += str(randi() % 9 + 1) + first_digit.search(correct).strings[2]
	answers.append(wrong2)

	# Add one wrong answer whose last digit is wrong
	var wrong3 = correct
	while wrong3 == correct:
		wrong3 = "-" if correct[0] == "-" else ""
		wrong3 += first_digit.search(correct).strings[1] + str(randi() % 9 + 1)
	answers.append(wrong3)

	answers.shuffle()

	return {
		"question": "%s %s %s = ?" % [num1, operation, num2],
		"correct_idx": answers.find(correct),
		"answers": answers
	}

func on_interaction(main, bot: DiscordBot, interaction: DiscordInteraction, data: Dictionary) -> void:
	if not interaction.is_select_menu():
		return

	# Make sure that only the user who requested this command is only allowed to answer
	if not interaction.member.user.id == data.author_id:
		interaction.reply({
			"ephemeral": true,
			"content": "Not allowed. You did not request this command."
		})
		return

	var custom_id = interaction.data.custom_id
	var value = interaction.data.values[0]
	var msg_id = interaction.message.id

	match custom_id:
		"math":
			# If the user chose the correct answer, increment the correct answer counter
			if value == str(data.correct_idx):
				main.interactions[msg_id].correct_num += 1

			# Get the data for the next question
			var ques_data = _gen_question()
			main.interactions[msg_id].question_num += 1
			main.interactions[msg_id].question = ques_data.question
			main.interactions[msg_id].correct_idx = ques_data.correct_idx
			main.interactions[msg_id].answers = ques_data.answers

			# Update the message with new data
			interaction.update(_make_message(main.interactions[msg_id]))

func get_usage(p: String) -> String:
	return "`%smath`" % p

var help = {
	"name": "math",
	"category": "Menu",
	"aliases": [],
	"enabled": true,
	"description": "A simple math quiz",
}
