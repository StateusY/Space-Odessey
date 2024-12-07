extends Area2D

@export var edgeType = ""
@export var snapBack = 40000
@onready var pCam = get_node("/root/Main Scene/PhantomCamera2D")

func _on_area_entered(body) -> void:
	pCam.follow_damping = false
	if edgeType == "left": body.position.x += snapBack
	if edgeType == "right": body.position.x -= snapBack
	if edgeType == "top": body.position.y -= snapBack
	if edgeType == "bottom": body.position.y += snapBack
	pCam.follow_damping = false
