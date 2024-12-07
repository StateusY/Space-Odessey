extends Area2D
@onready var globals = get_node("/root/Main Scene/Globals")
var minimap_icon = "enemy"

var VELOCITY = 500.0
var TURNING = 1
var FIRE_RATE = 0.01

@export var Bullet : PackedScene
@onready var player = get_node("/root/Main Scene/player")
@onready var minimap = get_node("/root/Main Scene/UI Elements/CanvasLayer/MiniMap")

func kill():
	globals.sheildPercent += 1
	
	queue_free()
	minimap.remove_obj(self)

func _ready():
	FIRE_RATE*=globals.difficulty
	VELOCITY*=globals.difficulty
	minimap.add_icon(self)

func _process(delta):
	var d = player.position.angle_to_point(position) 
	rotation = Util.rotate_toward(rotation, d, TURNING*delta)
	position += Vector2.RIGHT.rotated(rotation) * VELOCITY * delta

	if position.distance_to(player.position) > 7000:
		queue_free()

	if randf()<FIRE_RATE:
		var b = Bullet.instantiate()
		get_tree().current_scene.add_child(b)
		b.position = self.global_position
		
		TURNING *= -1
		
		var v = Vector2(position.x-player.position.x,position.y-player.position.y)
		v = v.normalized()
		b.Xdir = v.x
		b.Ydir = v.y
