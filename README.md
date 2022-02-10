# Light2D
* Proyecto para el uso de nodo [Light2D](https://docs.godotengine.org/es/stable/classes/class_light2d.html) y modificar distintas propiedades mientras el proyecto se ejecuta
* Las propiedades del nodo Light2D que se pueden modificar dentro de la aplicacion son: [color](https://docs.godotengine.org/es/stable/classes/class_light2d.html#class-light2d-property-color), [energy](https://docs.godotengine.org/es/stable/classes/class_light2d.html#class-light2d-property-energy) y [texture_scale](https://docs.godotengine.org/es/stable/classes/class_light2d.html#class-light2d-property-texture-scale)
* Los presets del [ColorPickerButton](https://docs.godotengine.org/en/3.4/classes/class_colorpickerbutton.html) tambien son guardados y cargados usando [add_preset](https://docs.godotengine.org/en/3.4/classes/class_colorpicker.html#class-colorpicker-method-add-preset) y [erase_preset](https://docs.godotengine.org/en/3.4/classes/class_colorpicker.html#class-colorpicker-method-erase-preset)

---

# Diccionario en el que se guardan los datos

* Script [global.gd](https://github.com/MarcoPaoletta/Light2D/blob/main/rsc/global/global.gd)

```gdscript
var light: Dictionary = {
	"color": "ffffff",
	"energy": 1,
	"texture_scale": 0.2,
	"presets": {
		
	}
}
```
* En este diccionario se almacena cada propiedad modificada por el usuario
* A su vez, este diccionario tiene otro mas llamado `presets` el cual va a almacenar cada preset del `ColorPicker` y de esa manera no se pierda al cerrar y volver a abrir el proyecto
* En el caso de que el diccionario `presets` tenga datos guardados se veria de esta manera:
    
```gdscript
{
	"color": "ffffff",
	"energy": 1,
	"texture_scale": 0.2,
	"presets": {
		"preset_1": "2ad6d9",
		"preset_2": "b7157e",
		"preset_3": "41eb14"
	}
}
```

---

# Manejo de los presets y modificacion de los valores de la luz

* Script [changer.gd](https://github.com/MarcoPaoletta/Light2D/blob/main/rsc/changer/changer.gd) 

```gdscript
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
```

* Actualizamos el valor del slider que modifica la escala de la luz, del que modifica la escala de la energia y del color del color picker
* Obtenemos el picker con [get_picker()](https://docs.godotengine.org/en/3.4/classes/class_colorpickerbutton.html#class-colorpickerbutton-method-get-picker), establecemos que el valor [edit_alpha](https://docs.godotengine.org/en/3.4/classes/class_colorpicker.html#class-colorpicker-property-edit-alpha) sea falso y conectamos las señales [preset_added](https://docs.godotengine.org/en/3.4/classes/class_colorpicker.html#class-colorpicker-signal-preset-added) y [preset_removed](https://docs.godotengine.org/en/3.4/classes/class_colorpicker.html#class-colorpicker-signal-preset-removed) a nosotros mismos, es decir, [self](https://docs.godotengine.org/en/3.4/classes/class_object.html#class-object-method-connect) y el metodo receptor va a tener exactamente el mismo nombre
* Ejecutando la funcion `
add_presets()`, para cada preset ya creado, agregamos un preset con el color guardado
* El metodo `preset_added()` era el receptor de la señal. En este, agregamos al final del diccionario de los presets un nuevo preset con el color correspondiente y ademas usamos [to_html(false)](https://docs.godotengine.org/en/3.4/classes/class_color.html#class-color-method-to-html) para que no se guarde con el valor alfa
* Por otro lado, en el metodo `preset_removed()`, iteramos dentro de cada preset creado y si el color ya esta en alguno de estos presets, borramos ese preset usando [erase](https://docs.godotengine.org/en/3.4/classes/class_dictionary.html#class-dictionary-method-erase)
* El resto es conexion de señales de nodos previamente creados y se actualizan los datos del diccionario

---

# Acutalizacion de las propiedade del nodo Light2D

* Script [light](https://github.com/MarcoPaoletta/Light2D/blob/main/rsc/light/light.gd)

```gdscript
func _ready():
	g.load_data()

func _process(_delta):
	position = get_global_mouse_position()
	
	color = g.light["color"]
	energy = g.light["energy"]
	texture_scale = g.light["texture_scale"]
```

* Cargamos los datos
* La posicion de la luz va a ser igual a la posicion del cursor del mouse
* Actualizamos los valores del nodo segun los datos guardados en el diccionario

---

# Descargar Godot Engine e importar el proyecto
---

## Descargar Godot Engine

* Accedemos al sitio oficial de [Godot Engine](https://godotengine.org/download) en la parte de descargas
* Seleccionamos nuestro sistema operativo
* Descargamos la **Standard version**
* Extraemos el archivo comprimido
* Esto nos dejara el ejecutable de Godot Engine

---

## Importar el proyecto

* Una vez descargado los archivos del proyecto, movemos la carpeta a una ruta de preferencia
* Abrimos Godot Engine y en la parte de la derecha buscamos el boton **Import** o **Importar**
* Escribimos la ruta del proyecto o buscamos manualmente en la carpeta del proyecto el archivo project.godot 
* Nos abrira el projecto y podremos ejecutarlo desde ahi tocando **F5** o en la parte superior derecha con el boton de play