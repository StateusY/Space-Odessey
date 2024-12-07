extends AnimatedSprite2D

@onready var globals = get_node("/root/Main Scene/Globals")
@onready var player = get_node("/root/Main Scene/player")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	frame = globals.sheildPercent
	position.x = player.global_position.x
	position.y = player.global_position.y - 50
