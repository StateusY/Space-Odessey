extends Node


var points: int = 0
var difficulty = 1
var isController: bool = false
@export var spawnEnemies: bool = false
var sheildPercent = 20
var missilePercent = 0
var targetedEnemies = []

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
func _process(delta: float) -> void:
	if sheildPercent < 0: sheildPercent = 0
	if sheildPercent > 44: sheildPercent = 44
	
	if missilePercent < 0: missilePercent = 0
	if missilePercent > 6: missilePercent = 6
	
	if Input.is_key_pressed(KEY_R):
		get_tree().paused = false
		get_tree().reload_current_scene()
