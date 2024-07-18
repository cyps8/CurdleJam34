extends Node

class_name GameManager
static var ins: GameManager

var paused = false

var pauseMenuRef: CanvasLayer

var dialogueWinRef: CanvasLayer

var dialogueOpen: bool = false

@export var objective: PackedScene

enum Customer {
	CROC,
	PENGUIN,
	GOAT,
	TRAIN,
	SQUID,
	FISH
}

var currentCustomer: int = 0

func _init():
	ins = self

func _ready():
	pauseMenuRef = $Pause
	pauseMenuRef.visible = true
	dialogueWinRef = $Dialogue
	dialogueWinRef.visible = true
	remove_child(pauseMenuRef)
	remove_child(dialogueWinRef)
	var delayTween: Tween = create_tween()
	delayTween.tween_callback(Root.ins.HideLoadingScreen).set_delay(0.05)
	OpenDialogueWindow()
	DialogueWindow.ins.PlayDialogue("BOSS", "Hey! Stop sleeping! Get off your lazy butt and get some pizza delivered, do you need a reminder of what to do?", 6, self.FirstDelivery, "No!", self.Tutorial1, "Yes!")
	seen.append(Customer.CROC)

func _process(_dt):
	if Input.is_action_just_pressed("Pause") && !Root.ins.optionsOpen && !dialogueOpen:
		TogglePause()

func TogglePause():
	paused = !paused
	get_tree().paused = paused
	if paused:
		add_child(pauseMenuRef)
	else:
		remove_child(pauseMenuRef)

func Tutorial1():
	DialogueWindow.ins.PlayDialogue("BOSS", "We've given you a ship, thrust with W or Right Trigger, rotate with A and D or Left Stick, and brake with Space or Left Trigger", 6, self.Tutorial2, "Next")

func Tutorial2():
	DialogueWindow.ins.PlayDialogue("BOSS", "If you brake whilst accelerating with enough speed you can perform a drift, it's good for changing direction quickly, but it does cost your speed", 6, self.Tutorial3, "Next")

func Tutorial3():
	DialogueWindow.ins.PlayDialogue("BOSS", "To save money on gas, you will have to cook the pizza yourself using the heat from stars, just go close to them and your pizza should start sizzling", 6, self.Tutorial4, "Next")

func Tutorial4():
	DialogueWindow.ins.PlayDialogue("BOSS", "There is an indicator telling you what stage your pizza is at; RAW, UNDERCOOKED, GOOD, PERFECT, OVERCOOKED and BURNT, I'm sure the customers will have something to say for each stage", 6, self.Tutorial5, "Next")

func Tutorial5():
	DialogueWindow.ins.PlayDialogue("BOSS", "You will also see the minimap we've installed, it'll show where your current objective is, which will show up as a green circle", 6, self.FirstDelivery, "Next")

func FirstDelivery():
	DialogueWindow.ins.PlayDialogue("BOSS", "Your first delivery is to the crocstomers, they need pizza to enjoy with thier movie, dont mess this up!", 6, self.StartGame, "I'll try")

func StartGame():
	AcceptNewDelivery()

func OpenDialogueWindow():
	dialogueOpen = true
	get_tree().paused = true
	add_child(dialogueWinRef)

func CloseDialogueWindow():
	dialogueOpen = false
	get_tree().paused = false
	remove_child(dialogueWinRef)

func AcceptNewDelivery():
	var pos = $World/Planets.get_child(currentCustomer).global_position
	NewDelivery(pos)
	CloseDialogueWindow()

func GetNewDelivery():
	OpenDialogueWindow()
	currentCustomer = NewCustomer()
	match currentCustomer:
		Customer.CROC:
			DialogueWindow.ins.PlayDialogue("BOSS", "Here is another crocstomer order, try not to disturb their movie!", 6, self.AcceptNewDelivery, "Yessir")
		Customer.PENGUIN:
			DialogueWindow.ins.PlayDialogue("BOSS", "This one is for the Pizguin, They sure are cool, but their fish pizzas stink!", 6, self.AcceptNewDelivery, "Real")
		Customer.GOAT:
			DialogueWindow.ins.PlayDialogue("BOSS", "The GOAT ordered a pizza, they're a bit delusional so just ignore their ramblings and it'll be fine", 6, self.AcceptNewDelivery, "Okie")
		Customer.TRAIN:
			DialogueWindow.ins.PlayDialogue("BOSS", "Choo choo, this one is for the trainee, you better get chugging along to deliver this one on time!", 6, self.AcceptNewDelivery, "Got it")
		Customer.SQUID:
			DialogueWindow.ins.PlayDialogue("BOSS", "Another one for the Octopi?? They are so lazy, I wonder if they go outside?", 6, self.AcceptNewDelivery, "lol")
		Customer.FISH:
			DialogueWindow.ins.PlayDialogue("BOSS", "I'd deliver to THAT fish, but I'm busy so you'll have to cook for this Very Important Fish", 6, self.AcceptNewDelivery, "On it")

var seen: Array[int]

func NewCustomer() -> int:
	seen.append(currentCustomer)
	if seen.size() > 5:
		seen.clear()
	var num = randi_range(0, 5)
	while seen.has(num):
		num = randi_range(0, 5)
	return num

func ReturnToBase():
	var newObjective = objective.instantiate()
	$World.add_child(newObjective)
	newObjective.trigger = self.GetNewDelivery
	newObjective.position = Vector2(0, 0)
	CloseDialogueWindow()

func NewDelivery(position: Vector2):
	var newObjective = objective.instantiate()
	$World.add_child(newObjective)
	newObjective.trigger = self.DeliveryCompleted
	newObjective.position = position
	Oven.ins.AddPizza(currentCustomer)

func DeliveryCompleted():
	SFXPlayer.ins.PlaySound(0)
	OpenDialogueWindow()
	match currentCustomer:
		Customer.CROC:
			match Oven.ins.TakePizza():
				Oven.Stage.RAW:
					DialogueWindow.ins.PlayDialogue("Crocstomer", "ITS RAWWW RAAAARRR GRRRR IM MAD, MOVIE NIGHT RUINED", currentCustomer, self.ReturnToBase, "Sorry sir")
				Oven.Stage.UNDER:
					DialogueWindow.ins.PlayDialogue("Crocstomer", "The cheese isn't even melted... This is not a good pizza, This will be a disappointing movie night", currentCustomer, self.ReturnToBase, "My bad")
				Oven.Stage.GOOD:
					DialogueWindow.ins.PlayDialogue("Crocstomer", "Thank you for the pizza! Can't wait to eat this with the gang at movie night!", currentCustomer, self.ReturnToBase, "Yayyy")
				Oven.Stage.PERFECT:
					DialogueWindow.ins.PlayDialogue("Crocstomer", "This pizza is PERFECT, tysm! This will be the best movie night ever! We would ivite you if you weren't so busy!", currentCustomer, self.ReturnToBase, "Thanks!")
				Oven.Stage.OVER:
					DialogueWindow.ins.PlayDialogue("Crocstomer", "Its a little too crispy for me, but still nice, at least food is not so important for movie night", currentCustomer, self.ReturnToBase, "Apologies")
				Oven.Stage.BURNT:
					DialogueWindow.ins.PlayDialogue("Crocstomer", "Its burnt, I'm gonna burn up soon if you don't leave right now you stu-", currentCustomer, self.ReturnToBase, "leaves")
		Customer.PENGUIN:
			match Oven.ins.TakePizza():
				Oven.Stage.RAW:
					DialogueWindow.ins.PlayDialogue("Pizguin", "This pizza is as cold as my planet, I maybe a penguin but I don't literally eat ice...", currentCustomer, self.ReturnToBase, "Oopsie")
				Oven.Stage.UNDER:
					DialogueWindow.ins.PlayDialogue("Pizguin", "Is this a joke? Even my ancestors didn't eat UNDERCOOKED fish, This pizza is a flop", currentCustomer, self.ReturnToBase, "Im dumb")
				Oven.Stage.GOOD:
					DialogueWindow.ins.PlayDialogue("Pizguin", "Yo this pizza is pretty good, man I love eating fishes, gonna slide this down my beak", currentCustomer, self.ReturnToBase, "Fishy")
				Oven.Stage.PERFECT:
					DialogueWindow.ins.PlayDialogue("Pizguin", "I love fish AND I love pizza, this is literally the coolest day of my life", currentCustomer, self.ReturnToBase, "Yippee!")
				Oven.Stage.OVER:
					DialogueWindow.ins.PlayDialogue("Pizguin", "Did you leave this in the sun for too long? It looks like it", currentCustomer, self.ReturnToBase, "Maybe")
				Oven.Stage.BURNT:
					DialogueWindow.ins.PlayDialogue("Pizguin", "WHAT IS THIS?!?! I'm gonna break my beak trying to eat this", currentCustomer, self.ReturnToBase, "Oh no")
		Customer.GOAT:
			match Oven.ins.TakePizza():
				Oven.Stage.RAW:
					DialogueWindow.ins.PlayDialogue("The GOAT", "Baaaah, BAAAAAH, Beeeeeh, It is pizza raw, I still prefer it to thinky climbing", currentCustomer, self.ReturnToBase, "Right...")
				Oven.Stage.UNDER:
					DialogueWindow.ins.PlayDialogue("The GOAT", "I'm gonna eat this undercooked, I'm gonna eat this undercooked, I'm gonna eat this undercooked", currentCustomer, self.ReturnToBase, "Undercooked")
				Oven.Stage.GOOD:
					DialogueWindow.ins.PlayDialogue("The GOAT", "Zipline the ingredients straight into my belly one at a time, hehe heh heh he he hehehe", currentCustomer, self.ReturnToBase, "Im scared")
				Oven.Stage.PERFECT:
					DialogueWindow.ins.PlayDialogue("The GOAT", "Yummy yum yum, yim yum yumminy yums yum yummers yumy yummy yummes yum yum yummies yum yum yum", currentCustomer, self.ReturnToBase, "Yum")
				Oven.Stage.OVER:
					DialogueWindow.ins.PlayDialogue("The GOAT", "I'm going to fly away after eating this cronchy snack, to the stars and beyond!!!", currentCustomer, self.ReturnToBase, "???")
				Oven.Stage.BURNT:
					DialogueWindow.ins.PlayDialogue("The GOAT", "This is hard like the big rocks I used to climb on when I was a kid", currentCustomer, self.ReturnToBase, "Hard stuff")
		Customer.TRAIN:
			match Oven.ins.TakePizza():
				Oven.Stage.RAW:
					DialogueWindow.ins.PlayDialogue("Trainee", "You are guilty of grinding my gears with this raw crude oil...", currentCustomer, self.ReturnToBase, "I know")
				Oven.Stage.UNDER:
					DialogueWindow.ins.PlayDialogue("Trainee", "The bolts are still solid, this fails the test, I'm going to have to fail you", currentCustomer, self.ReturnToBase, "Sad")
				Oven.Stage.GOOD:
					DialogueWindow.ins.PlayDialogue("Trainee", "This is just like my mother used to make, This is going to improve my performance", currentCustomer, self.ReturnToBase, "Beep")
				Oven.Stage.PERFECT:
					DialogueWindow.ins.PlayDialogue("Trainee", "Analysing, Integrity: PERFECT, Security: PERFECT, Complexity: PERFECT, Overall: PERFECT, You win", currentCustomer, self.ReturnToBase, "Wooo!")
				Oven.Stage.OVER:
					DialogueWindow.ins.PlayDialogue("Trainee", "You fried this just like you fried my circuits right now, Reporting this as a scam", currentCustomer, self.ReturnToBase, "how?")
				Oven.Stage.BURNT:
					DialogueWindow.ins.PlayDialogue("Trainee", "This pizza is cracked, can I return it for a refund?? how long is the warranty?", currentCustomer, self.ReturnToBase, "What?")
		Customer.SQUID:
			match Oven.ins.TakePizza():
				Oven.Stage.RAW:
					DialogueWindow.ins.PlayDialogue("Octopi Za", "My dad works for the galaxy, you are going to get blocked and banned", currentCustomer, self.ReturnToBase, "yikers")
				Oven.Stage.UNDER:
					DialogueWindow.ins.PlayDialogue("Octopi Za", "Even heating this up in the microwave could've been better than nothing, this is so uncool", currentCustomer, self.ReturnToBase, "I tried")
				Oven.Stage.GOOD:
					DialogueWindow.ins.PlayDialogue("Octopi Za", "You should've let him cook more, but still a pretty gamer pizza", currentCustomer, self.ReturnToBase, "Wow")
				Oven.Stage.PERFECT:
					DialogueWindow.ins.PlayDialogue("Octopi Za", "This pizza is legendary rarity, I'm going to upvote you on all my alt accounts", currentCustomer, self.ReturnToBase, "Gaming")
				Oven.Stage.OVER:
					DialogueWindow.ins.PlayDialogue("Octopi Za", "I don't know what you were cooking, but you overcooked and now you are so cooked my friend...", currentCustomer, self.ReturnToBase, "Im cooked")
				Oven.Stage.BURNT:
					DialogueWindow.ins.PlayDialogue("Octopi Za", "This is literally charcoal, I could use this as fuel to smelt my iron ore fr fr", currentCustomer, self.ReturnToBase, "fr")
		Customer.FISH:
			match Oven.ins.TakePizza():
				Oven.Stage.RAW:
					DialogueWindow.ins.PlayDialogue("Kissed Fish", "This is disgusting, I can't believe you'd even dare to show me this, get lost peasant", currentCustomer, self.ReturnToBase, "Ouch")
				Oven.Stage.UNDER:
					DialogueWindow.ins.PlayDialogue("Kissed Fish", "You seriously expect me to eat this?? well expect a 1 star rating on Blobble reviews", currentCustomer, self.ReturnToBase, "Idc")
				Oven.Stage.GOOD:
					DialogueWindow.ins.PlayDialogue("Kissed Fish", "Thank you sweetie, this is just what I need before I perform at my fishion show!!", currentCustomer, self.ReturnToBase, "Cool!")
				Oven.Stage.PERFECT:
					DialogueWindow.ins.PlayDialogue("Kissed Fish", "OMG, this pizza is fintastic!! I'm gonna post it on Blobber so all my followers can see!", currentCustomer, self.ReturnToBase, "Ty bestie!!")
				Oven.Stage.OVER:
					DialogueWindow.ins.PlayDialogue("Kissed Fish", "Ugh, what the ocean, didn't you realise this is cooked t0o long?? what a loser!!", currentCustomer, self.ReturnToBase, "Meanie...")
				Oven.Stage.BURNT:
					DialogueWindow.ins.PlayDialogue("Kissed Fish", "It's literally unedible charcoal, I am so posting this on Blobber, you are getting CANCELLED!!", currentCustomer, self.ReturnToBase, "Oh my...")

