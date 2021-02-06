extends Node

var InkRuntime = load("res://addons/inkgd/runtime.gd")
var Story = load("res://addons/inkgd/runtime/story.gd")

var story_path = "res://assets/dialogue/dialogue.ink.json"

var story

func _ready():
	call_deferred("_initialize")

func start_dialogue(name: String) -> Dictionary:
	story.choose_path_string(name)
	return _get_current_dialogue()

func select_option(index: int) -> Dictionary:
	story.choose_choice_index(index)
	return _get_current_dialogue()

func _initialize():
	InkRuntime.init(get_tree().root)
	_load_story(story_path)

func _load_story(ink_story_path):
	var ink_story = File.new()
	ink_story.open(ink_story_path, File.READ)
	var content = ink_story.get_as_text()
	ink_story.close()
	self.story = Story.new(content)

func _get_current_dialogue() -> Dictionary:
	var text_lines = []
	while story.can_continue:
		var line = story.continue()
#		var tags = story.current_tags
		text_lines.append(line)
	return {
		"lines": text_lines,
		"options": story.current_choices
	}

func save_story() -> String:
	return story.state.to_json()

func load_story(json) -> void:
	story.state.load_json(json)
