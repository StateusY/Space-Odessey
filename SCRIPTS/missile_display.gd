extends AnimatedSprite2D

@onready var globals = get_node("/root/Main Scene/Globals")
#@onready var player = get_node("/root/Main Scene/player")

func _process(delta: float) -> void:
	frame = globals.missilePercent
