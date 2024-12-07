extends Area2D
@onready var globals = get_node("/root/Main Scene/Globals")
var minimap_icon = "missle"

var turning = 3
var velocity = 1000
var target
var hits = 0
var lowestDistanceTarget = null
var lowestDistance = 100000

@onready var player = get_node("/root/Main Scene/player")
@onready var minimap = get_node("/root/Main Scene/UI Elements/CanvasLayer/MiniMap")
@onready var pointText = get_node("/root/Main Scene/UI Elements/CanvasLayer/PointText")

func _ready() -> void:
	minimap.add_icon(self)

func kill():
	if hits != 5:
		hits+=1
	else:
		queue_free()
		minimap.remove_obj(self)

func _physics_process(delta: float) -> void:
	var d = 0
	var possible_targets = get_tree().get_nodes_in_group("enemy")
	
	for i in range(possible_targets.size() - 1, -1, -1):  # Start from the last index and go backward
		for enemy in globals.targetedEnemies:
			if possible_targets[i] == enemy:
				possible_targets.remove_at(i)
				break  # No need to continue checking for the same target
	
	if is_instance_valid(target):
		velocity = 1000
		d = target.position.angle_to_point(position) 
		lowestDistanceTarget = null
		lowestDistance = 100000
		
	elif possible_targets.size() > 0:
		for i in range(possible_targets.size()):
			if possible_targets[i].position.distance_to(position) < lowestDistance:
				lowestDistance = possible_targets[i].position.distance_to(position)
				lowestDistanceTarget = possible_targets[i]
		if lowestDistanceTarget != null:
			target = lowestDistanceTarget
			globals.targetedEnemies.append(target)
	else:
		velocity = 300
		d = (player.position).angle_to_point(position) + PI/2
	
	rotation = Util.rotate_toward(rotation, d, turning*delta)
	position += Vector2.LEFT.rotated(rotation) * velocity * delta
	
func _on_area_entered(body):
	if body.is_in_group("enemy"):
		body.kill()
		globals.points += 1
		pointText.text = str(globals.points)
		kill()
