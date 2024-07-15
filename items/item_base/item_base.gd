class_name ItemBase

extends Node2D

@export var item_data: ItemData

func activate() -> bool:
	#print("activate function")
	return true
func activate_alt() -> bool:
	#print("activate alt function")
	return true
#
func _ready():
	# TODO: Only load texture, don't need to instantiate entire scene
	var instance = item_data.scene.instantiate()
	add_child(instance)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("on_item_picked_up"):
		body.on_item_picked_up(item_data)
		queue_free()
