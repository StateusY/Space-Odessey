extends Area2D
@onready var globals = get_node("/root/Main Scene/Globals")
var minimap_icon = "enemy"

var turnRate = 0.5
var fireRate = 0.005
var speed = 500
var leader = null
var index = null
var buffer = 700
var snapBackAmount = 1.25
var isHit = false
@export var BODY_SEGMENT_DISTANCE = 50
@export var BODY_COUNT = 10

var bodySegments = []
@export var Bullet : PackedScene = load("res://enemy_bullet.tscn")
@onready var player = get_node("/root/Main Scene/player")
@onready var minimap = get_node("/root/Main Scene/UI Elements/CanvasLayer/MiniMap")

func kill():
	globals.sheildPercent += 1
	# Mark the segment as hit first
	isHit = true

	# Avoid re-assigning leaders immediately by queuing the operation
	if leader != null:
		leader.cutBody(index)
	else:
		if bodySegments.size() > 0:
			for i in range(bodySegments.size()):
				if i == 0:
					bodySegments[i].leader = null
				if i > 0:
					bodySegments[0].bodySegments.append(bodySegments[i])
			bodySegments[0].commandSegments()

		queue_free()

	minimap.remove_obj(self)
	

func _ready() -> void:
	speed*=globals.difficulty
	fireRate*=globals.difficulty
	if leader == null:
		createBodySegments(BODY_COUNT)
	minimap.add_icon(self)


func _physics_process(delta: float) -> void:
	if leader == null:
		updateBodySegments()
		position += Vector2.LEFT.rotated(rotation) * speed * delta
		if randf()<turnRate:
			var d = player.position.angle_to_point(position)
			rotation = Util.rotate_toward(rotation, d, 2*delta)
	if randf()<fireRate:
		#bullet shooting
		var b = Bullet.instantiate()
		get_tree().current_scene.add_child(b)
		b.position = self.global_position
		var v = Vector2(position.x-player.position.x,position.y-player.position.y)
		v = v.normalized()
		b.Xdir = v.x
		b.Ydir = v.y

# Create body segments for the centipede
func createBodySegments(amount: int):
		var back_direction = -Vector2(cos(rotation),sin(rotation))
		for i in range(amount):
			var bodySegment = load("res://centipede.tscn").instantiate()
			get_tree().current_scene.add_child.call_deferred(bodySegment)
			bodySegment.global_position = global_position# + back_direction * BODY_SEGMENT_DISTANCE * (i+1)
			bodySegment.leader = self
			bodySegment.index = i
			bodySegments.append(bodySegment)
			
func updateBodySegments():
	for i in bodySegments.size():
		if i == 0:
			var direction_to_head = bodySegments[i].global_position.direction_to(global_position)
			var distance_to_head = bodySegments[i].global_position.distance_to(global_position)
			
			bodySegments[i].global_position = global_position - direction_to_head * BODY_SEGMENT_DISTANCE
			bodySegments[i].look_at(global_position)
		else:
			var direction_to_previous_segment = bodySegments[i].global_position.direction_to(bodySegments[i-1].global_position)
			var distance_to_previous_segment = bodySegments[i].global_position.distance_to(bodySegments[i-1].global_position)
			
			if distance_to_previous_segment > BODY_SEGMENT_DISTANCE:
				bodySegments[i].global_position = bodySegments[i-1].global_position - direction_to_previous_segment * BODY_SEGMENT_DISTANCE
				bodySegments[i].look_at(bodySegments[i-1].global_position)

func cutBody(index: int):
	# Create a temporary list of body segments
	var tempBodySegments = []
	if index != bodySegments.size()-1:
		if bodySegments.size() > 0:
			for i in range(bodySegments.size()):
				# Ensure we are only processing non-hit segments
				if bodySegments[i].isHit == false:
					if i < index:
						tempBodySegments.append(bodySegments[i])
					if i == index+1:
						bodySegments[index+1].leader = null
						bodySegments[index+1].index = null
					if i > index+1:
						bodySegments[index+1].bodySegments.append(bodySegments[i])
			# Reassign the leader after processing
			bodySegments[index+1].commandSegments()
			bodySegments[index].queue_free()
			bodySegments.clear()
			bodySegments = tempBodySegments
			for i in range(bodySegments.size()):
				bodySegments[i].index = i
				bodySegments[i].leader = self
	else:
		bodySegments[index].queue_free()
		bodySegments.pop_back()


func commandSegments():
	for i in range(bodySegments.size()):
		bodySegments[i].index = i
		bodySegments[i].leader = self
