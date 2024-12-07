extends Area2D

var curverSpawnRate = 157
var centipedeSpawnRate = 347
var sawSpawnRate = 123

var spawnTimer = 0

@export var SpaceSaw : PackedScene
@export var Curver : PackedScene
@export var Centipede : PackedScene
@onready var globals = get_node("/root/Main Scene/Globals")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawnTimer = randi_range(0,50000)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if globals.spawnEnemies == true:
		if spawnTimer > 100000: spawnTimer = 0
		spawnTimer += 1
		if spawnTimer%curverSpawnRate == 0 and globals.points >= 15:
			var b = Curver.instantiate()
			b.position.x = -(get_window().size.x/2)
			b.position.y = randf_range(-500,500)
			owner.add_child(b)
			var d = Curver.instantiate()
			d.position.x = (get_window().size.x/2)
			d.position.y = randf_range(-500,500)
			owner.add_child(d)
		if spawnTimer%centipedeSpawnRate == 0 and globals.points >= 75:
			var c = Centipede.instantiate()
			c.position.x = randf_range(-500,500)
			c.position.y = -1000
			owner.add_child(c)
			var e = Centipede.instantiate()
			e.position.x = randf_range(-500,500)
			e.position.y = 1000
			owner.add_child(e)
		if spawnTimer%sawSpawnRate == 0 and globals.points >= 0:
			var tempRand = randi_range(1,4)
			if tempRand == 1:
				var c = SpaceSaw.instantiate()
				c.position.x = randf_range(-500,500)
				c.position.y = -1000
				owner.add_child(c)
			elif tempRand == 2:
				var c = SpaceSaw.instantiate()
				c.position.x = randf_range(-500,500)
				c.position.y = 1000
				owner.add_child(c)
			elif tempRand == 3:
				var c = SpaceSaw.instantiate()
				c.position.y = randf_range(-500,500)
				c.position.x = -1000
				owner.add_child(c)
			else:
				var c = SpaceSaw.instantiate()
				c.position.y = randf_range(-500,500)
				c.position.x = 1000
				owner.add_child(c)
