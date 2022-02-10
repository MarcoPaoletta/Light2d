extends Light2D

func _ready():
	g.load_data()

func _process(_delta):
	position = get_global_mouse_position()
	
	color = g.light["color"]
	energy = g.light["energy"]
	texture_scale = g.light["texture_scale"]
