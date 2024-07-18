class_name ItemUseable

extends ItemBase

enum ITEM_STATE {READY, STARTUP, ACTIVE, ACTIVE_ALT, COOLDOWN}

@export_range(0, 5) var time_startup: float = 0.0
@export_range(0, 5) var time_active: float = 0.1
@export_range(0, 5) var time_cooldown: float = 0.1
# This affects ALL time values
@export_range(-1, 5) var speed_multiplier: float = 1

var item_state: ITEM_STATE = ITEM_STATE.READY
var is_active_alt: bool = false

var time_startup_current: float = time_startup
var time_active_current: float = time_active
var time_cooldown_current: float = time_cooldown

signal item_state_updated(new_item_state: ITEM_STATE)

# TODO: only run when player equips item, so maybe an equip() function
# may not be necessary at all
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Calculate time
	# If enough time has elapsed, update state machine
	match item_state:
		ITEM_STATE.STARTUP:
			if time_startup_current <= 0:
				if is_active_alt:
					update_state(ITEM_STATE.ACTIVE_ALT)
				else:
					update_state(ITEM_STATE.ACTIVE)
			else:
				time_startup_current -= delta
		ITEM_STATE.ACTIVE, ITEM_STATE.ACTIVE_ALT:
			if time_active_current <= 0:
				update_state(ITEM_STATE.COOLDOWN)
			else:
				time_active_current -= delta
		ITEM_STATE.COOLDOWN:
			if time_cooldown_current <= 0:
				reset()
			else:
				time_cooldown_current -= delta

func activate() -> bool:
	if item_state != ITEM_STATE.READY:
		return false

	#print("activate function")
	is_active_alt = false
	# calculate timers
	time_startup_current = time_startup/speed_multiplier # TODO: separate timer for ALT usage?
	time_active_current = time_active/speed_multiplier
	time_cooldown_current = time_cooldown/speed_multiplier # TODO: separate timer for ALT usage?
	# emit signal
	update_state(ITEM_STATE.STARTUP)

	return true

func activate_alt() -> bool:
	if item_state != ITEM_STATE.READY:
		return false

	#print("activate alt function")
	is_active_alt = true
	# calculate timers
	time_startup_current = time_startup/speed_multiplier # TODO: separate timer for ALT usage?
	time_active_current = time_active/speed_multiplier
	time_cooldown_current = time_cooldown/speed_multiplier # TODO: separate timer for ALT usage?
	# emit signal
	update_state(ITEM_STATE.STARTUP)

	return true

func update_state(new_state: ITEM_STATE):
	item_state = new_state
	item_state_updated.emit(new_state)

func reset() -> void:
	update_state(ITEM_STATE.READY)
