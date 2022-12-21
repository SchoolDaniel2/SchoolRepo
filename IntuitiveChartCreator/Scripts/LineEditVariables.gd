extends Control

# if you are wondering what this is all about, it is for me to easily grab
# variables from the script instead of some lame ass way of grabbing it from
# the nodes itself.

@export var Points = 0
@export var MaximumPoints = 0
@export var Name = ""

func _on_name_text_changed(new_text):
	Name = new_text

func _on_maximum_text_changed(new_text):
	if int(new_text) != 0:
		MaximumPoints = int(new_text)
	else:
		get_node("Maximum").set("text", "")

func _on_points_text_changed(new_text):
	if int(new_text) != 0:
		Points = int(new_text)
	else:
		get_node("Points").set("text", "")
