extends Parallax2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_background_scale()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Update the background scale every frame in case the window size changes dynamically
	update_background_scale()

# Function to scale the background based on the window size
func update_background_scale() -> void:
	# Get the window size
	var window_size = get_window().size
	#print(get_window().size)
	# Calculate the scale factor to fit the window width
	var scale_factor = window_size.x/750



	# Apply the scaling to the sprite
	scale = Vector2(scale_factor, scale_factor)
