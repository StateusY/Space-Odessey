extends MarginContainer

@export var player : NodePath
@export var zoom = 1.5

@onready var grid = $MarginContainer/TextureRect
@onready var player_marker = $MarginContainer/TextureRect/PlayerMarker
@onready var enemy_marker = $MarginContainer/TextureRect/EnemyMarker
@onready var alert_marker = $MarginContainer/TextureRect/AlertMarker
@onready var missle_marker = $MarginContainer/TextureRect/MissleMarker

@onready var icons = {"enemy": enemy_marker, "alert": alert_marker, "missle": missle_marker} #"player": player_marker,

var grid_scale
var markers = {}

func add_icon(item):
	var new_marker = icons[item.minimap_icon].duplicate()
	grid.add_child(new_marker)
	new_marker.show()
	markers[item] = new_marker
	
	
func _ready():
	player_marker.position = Vector2(26,26) #grid.size / 2
	grid_scale = grid.size / (get_viewport().size * zoom)
	var map_objects = get_tree().get_nodes_in_group("minimap_objects")
	for item in map_objects:
		var new_marker = icons[item.minimap_icon].duplicate()
		grid.add_child(new_marker)
		new_marker.show()
		markers[item] = new_marker
		
		var obj_pos = (item.position - get_node(player).position) * grid_scale + grid.size / 2
		obj_pos.x = clamp(obj_pos.x, 0, grid.size.x)
		obj_pos.y = clamp(obj_pos.y, 0, grid.size.y)
		if abs((item.position - get_node(player).position).x) < 100 or abs((item.position - get_node(player).position).y) < 100:
			markers[item].visible = true
			markers[item].position = obj_pos
		else:
			markers[item].visible = false

func remove_obj(obj):
	for item in markers:
		if item == obj:
			markers[item].queue_free()
			markers.erase(item)

func _physics_process(delta):
	if !player:
		return
	player_marker.rotation = get_node(player).rotation
	for item in markers:
		if is_instance_valid(item):
			var obj_pos = (item.position - get_node(player).position) * grid_scale + grid.size / 2
			obj_pos.x = clamp(obj_pos.x, 0, grid.size.x)
			obj_pos.y = clamp(obj_pos.y, 0, grid.size.y)
			markers[item].position = obj_pos
