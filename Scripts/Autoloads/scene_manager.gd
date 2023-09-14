extends Node

var _scene_stack: Array[PackedScene] = []

var _main_scene = preload("res://Scenes/main_menu.tscn")
var _world_scene
var _combat_scene
var _option_scene
var _recap_screen
var _rest_scene

func _ready():
	_scene_stack.append(_main_scene)

func go_to_main_menu():
	_new_scene(_main_scene)

func go_to_path_selection():
	if _world_scene == null:
		_world_scene = preload("res://Scenes/path_selection.tscn")
	_new_scene(_world_scene)
	
func go_to_combat():
	if _combat_scene == null:
		_combat_scene = load("res://Scenes/main.tscn")
	_new_scene(_combat_scene)

func go_to_options():
	if _option_scene == null:
		_option_scene = load("res://Scenes/option_screen.tscn")
	_new_scene(_option_scene)

func go_to_rest():
	if _rest_scene == null:
		_rest_scene = load("res://Scenes/rest_screen.tscn")
	_new_scene(_rest_scene)

func swap_in_recap_screen():
	if _recap_screen == null:
		_recap_screen = load("res://Scenes/recap_screen.tscn")
		
	if _scene_stack.size() > 0: 
		_scene_stack.pop_back()
		_new_scene(_recap_screen)

func exit_scene():
	if _scene_stack.size() > 1: 
		_scene_stack.pop_back()
		_l(_scene_stack.back())

func _new_scene(s: PackedScene):
	_scene_stack.append(s)
	_l(s)

func _l(s: PackedScene):
	get_tree().change_scene_to_packed(s)
