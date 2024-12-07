extends Area2D

var speed = 1750
@export var Xdir = 1
@export var Ydir = 1
@export var isPlayerBullet = true
@onready var player = get_node("/root/Main Scene/player")
@onready var globals = get_node("/root/Main Scene/Globals")
@onready var pointText = get_node("/root/Main Scene/UI Elements/CanvasLayer/PointText")

func _physics_process(delta):
	position -= transform.x * speed * delta * Xdir
	position -= transform.y * speed * delta * Ydir
	if position.x > abs(20000) or position.y > abs(20000):
		queue_free()

func _on_area_entered(body):
	if body.is_in_group("enemy") and isPlayerBullet:
		body.kill()
		globals.points += 1
		pointText.text = str(globals.points)
		queue_free()
	if body.is_in_group("player") and not isPlayerBullet:
		body.hit()
		queue_free()
