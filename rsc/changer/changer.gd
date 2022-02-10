extends Panel

func _ready():
	$v_box_container/scale.value = g.light["texture_scale"]
	$v_box_container/energy.value = g.light["energy"]
	$v_box_container/color_picker_button.color = g.light["color"]

	$v_box_container/color_picker_button.get_picker().edit_alpha = false
	$v_box_container/color_picker_button.get_picker().connect("preset_added", self, "preset_added")
	$v_box_container/color_picker_button.get_picker().connect("preset_removed", self, "preset_removed")
	
	add_presets()
	
func add_presets():
	for preset in range(g.light["presets"].keys().size()):
		$v_box_container/color_picker_button.get_picker().add_preset(g.light["presets"]["preset_" + str(preset + 1)])
	
func preset_added(color):
	g.light["presets"]["preset_" + str(g.light["presets"].keys().size() + 1)] = color.to_html(false) 
	
func preset_removed(color):
	for preset in g.light["presets"].keys().size():
		if color.to_html(false) in g.light["presets"]["preset_" + str(preset + 1)]:
			g.light["presets"].erase("preset_" + str(preset + 1))

func _on_scale_value_changed(value):
	g.light["texture_scale"] = value

func _on_energy_value_changed(value):
	g.light["energy"] = value

func _on_color_picker_button_color_changed(color):
	g.light["color"] = color.to_html(false)
