extends Sprite2D

@onready var globals = get_node("/root/Main Scene/Globals")

var mousePos

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if globals.isController == false:
		mousePos = get_global_mouse_position()
		position.x = mousePos.x
		position.y = mousePos.y
