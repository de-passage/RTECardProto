extends CanvasLayer
class_name HandManager

signal card_selected(card: CardResource)
signal draw_pile_changed(new_size: int)
signal discard_changed(new_size: int)
signal exhaust_changed(new_size: int)

# Resource management
var _card_scene: PackedScene = preload("res://Scenes/card.tscn")

var _game_logic: GameLogic

@onready var _hand_container = $HandContainer

# Creates the hand and so on
func initialize(deck: Array[CardResource], player_ref:PlayableEntity):
	_game_logic = GameLogic.new()
	_game_logic.discard_changed.connect(func(x): discard_changed.emit(x))
	_game_logic.draw_pile_changed.connect(func(x): draw_pile_changed.emit(x))
	_game_logic.exhaust_changed.connect(func(x): exhaust_changed.emit(x))
	_game_logic.hand_changed.connect(func(_x): _show_hand())
	_game_logic.card_played.connect(_on_card_played)
	_game_logic.initialize(player_ref, deck.duplicate())
	_show_hand()

# Build a new hand
func _show_hand():
	for child in _hand_container.get_children():
		if child is Card:
			child.queue_free()

	for card_resource in _game_logic.hand():
		var card: Card = _card_scene.instantiate()
		_hand_container.add_child(card)
		card.initialize(card_resource, _game_logic.player())
		card.scale = Vector2(1.,1.)
		card.selected.connect(_emit_selected.bind(card))
		card.discarded.connect(_emit_discarded.bind(card))

func _emit_selected(card_scene: Card):
	card_selected.emit(card_scene)

func _emit_discarded(card_scene: Card):
	if (card_scene._resource.playable):
		_game_logic.discard(card_scene._resource)
		card_scene.queue_free()

func play(card: Card, enemy: PlayableEntity):
	_game_logic.play(card._resource, enemy)
	card.queue_free()

func _on_card_played(_card: CardResource):
	# Update card text
	for child in _hand_container.get_children():
		if child is Card:
			child.update_description(Context.source_only(_game_logic.player()))

func draw_one_card() -> bool:
	return _game_logic.draw_one_card()
