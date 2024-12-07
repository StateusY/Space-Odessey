extends Camera2D

@onready var player = get_node("/root/Main Scene/player")
@onready var pCam = get_node("/root/Main Scene/PhantomCamera2D")
var zoomNum = 0.1

# Called when the node enters the scene tree for the first time.
func _physics_process(delta: float) -> void:
	pass#var overallSpeed = abs(pow(pow(player.xVel,2)+pow(player.yVel,2),0.5))
	#var zNum = (1/max(min(overallSpeed,2), 1))
	#pCam.zoom = Vector2(zNum,zNum)
