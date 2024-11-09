extends Node2D

enum lantern_modes { OFF, AREA, DIRECTION }

var mode : lantern_modes = lantern_modes.OFF

# Called when the node enters the scene tree for the first time.
func _ready():
	$AreaLight.hide()
	$BeamLight.hide()
	
func _process(_delta):
	$BeamLight.look_at(get_global_mouse_position())
		
func mode_switch():
	mode = ((mode as int + 1) % len(lantern_modes)) as lantern_modes
	match mode:
		lantern_modes.OFF:
			$AreaLight.hide()
			$BeamLight.hide()
			$BeamLight.set_process(false)
		lantern_modes.AREA:
			$AreaLight.show()
			$BeamLight.hide()
			$BeamLight.set_process(false)
		lantern_modes.DIRECTION:
			$AreaLight.hide()
			$BeamLight.show()
			$BeamLight.set_process(true)
