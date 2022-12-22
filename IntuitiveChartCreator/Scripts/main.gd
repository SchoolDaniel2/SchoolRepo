extends Control

@export var Subjects = 0
var ShowNames = false
@export var LineEditScene: PackedScene

@export var CircleScene: PackedScene
@export var LabelScene: PackedScene

# The first 3 methods are for what is shown on the menu
func _on_line_edit_text_changed(new_text):
	if int(new_text) != 0:
		Subjects = int(new_text)
	else:
		get_node("MainMenuStuff/LineEdit").set("text", "")

func _on_continue_pressed():
	if int(get_node("MainMenuStuff/LineEdit").get("text")) != 0:
		get_node("MainMenuStuff").set("visible", false)
		get_node("StackedLineEdits").set("visible", true)
		CreateLineEdit()

func _on_check_box_toggled(button_pressed):
	ShowNames = button_pressed

# Now this is where people get their stuff filled in on.
func CreateLineEdit():
	var loop = 0;
	while loop != Subjects:
		var thing = LineEditScene.instantiate();
		get_node("StackedLineEdits").add_child(thing)
		thing.position.y = 31 * loop
		if ShowNames == false:
			thing.get_child(0).set("visible", false)
		loop += 1

func _on_piechart_pressed():
	# Get the children (and remove the extras) :)
	var Children = get_node("StackedLineEdits").get_children()
	Children.remove_at(0)
	Children.remove_at(0)
	# Check for bugs
	for i in Children:
		if i.get("Points") > i.get("MaximumPoints"):
			get_node("StackedLineEdits/Label").set("text", "One of your points is over the maximum set, please change it!")
			return
		if i.get("MaximumPoints") == 0:
			get_node("StackedLineEdits/Label").set("text", "You forgot to input something...")
			return
		if ShowNames == true && i.get("Name") == "":
			get_node("StackedLineEdits/Label").set("text", "You selected to put in names and yet you didn't put in names! ")
			return
	# No bugs? Great! Lets move on!
	get_node("StackedLineEdits").set("visible", false)
	get_node("StackedBars").set("visible", true)
	CreateCircleScene()

# Lastly, create the pie chart!
func CreateCircleScene():
	# Get the children (and remove the extras) :)
	var Children = get_node("StackedLineEdits").get_children()
	Children.remove_at(0)
	Children.remove_at(0)
	# Create the pie chart.
	var TheRadius = 360 / Children.size()
	var loop = 0
	for i in Children:
		# Set some variables that are used later
		var thing = CircleScene.instantiate()
		var Colored = Color8(randi_range(0, 255), randi_range(0, 255), randi_range(0, 255))
		# This has to be set for all of the instantiated variables
		thing.set("radial_initial_angle", TheRadius * loop)
		thing.set("radial_fill_degrees", TheRadius)
		# Now we set some stuff :D
		get_node("StackedBars").add_child(thing)
		thing.set("value", i.get("Points"))
		thing.set("max_value", i.get("MaximumPoints"))
		thing.set("tint_progress", Colored)
		# if you put names, they should appear
		if ShowNames:
			var thing2 = LabelScene.instantiate()
			get_node("StackedBars/Names").add_child(thing2)
			thing2.set("modulate", Colored)
			thing2.position.y += (26 * (loop + 1))
			thing2.set("text", i.get("Name"))
		loop += 1

func _on_restart_pressed():
	get_tree().change_scene_to_file("res://main.tscn")
