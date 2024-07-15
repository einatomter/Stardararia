class_name ItemUseable

extends ItemBase

enum ITEM_STATE {READY, ACTIVE, ACTIVE_ALT, COOLDOWN}

@export_range(0, 50) var max_range: int = 10 # blocks
@export_range(-1, 5) var speed_multiplier: float = 1
@export_range(-1, 5) var item_cooldown: float = 0.1

var item_state: ITEM_STATE = ITEM_STATE.READY
var item_cooldown_current: float = item_cooldown

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if item_state == ITEM_STATE.COOLDOWN:
		if item_cooldown_current <= 0:
			reset()
		else:
			item_cooldown_current -= delta

func activate() -> bool:
	if item_state != ITEM_STATE.READY:
		return false

	#print("activate function")

	# TODO: Knows nothing about "active" time and must be manually overriden by extended class
	item_cooldown_current = item_cooldown/speed_multiplier # TODO: separate cooldown for ALT usage?
	item_state = ITEM_STATE.ACTIVE
	var activated:= _activate()
	if not activated:
		reset()
		return false
	item_state = ITEM_STATE.COOLDOWN
	return true

# Override this function
# TODO: maybe emitting signal is better
func _activate() -> bool:
	return true

func activate_alt() -> bool:
	if item_state != ITEM_STATE.READY:
		return false

	#print("activate alt function")

	item_cooldown_current = item_cooldown/speed_multiplier # TODO: separate cooldown for ALT usage?
	item_state = ITEM_STATE.ACTIVE_ALT
	var activated:= _activate_alt()
	if not activated:
		reset()
		return false
	item_state = ITEM_STATE.COOLDOWN
	return true

# Override this function
# TODO: maybe emitting signal is better
func _activate_alt() -> bool:
	return true

func reset() -> void:
	_reset()
	item_state = ITEM_STATE.READY

func _reset() -> void:
	pass
