extends Node

var light: Dictionary = {
	"color": "ffffff",
	"energy": 1,
	"texture_scale": 0.2,
	"presets": {
		
	}
}

var path: String = "user://data.json"

func load_data():
	var file = File.new()
	if not file.file_exists(path):
		return
	file.open(path, file.READ)
	var text = file.get_as_text()
	light = parse_json(text)
	file.close()

func save_data():
	var file = File.new()
	file.open(path, File.WRITE)
	file.store_line(JSON.print(light, "\t"))
	file.close()

func _process(_delta):
	g.save_data()
