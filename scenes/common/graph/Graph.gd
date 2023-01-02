extends Node3D

enum TransitionMode {CYCLE, RANDOM}

@export_range(10, 100, 1.0, int) var resolution = 10
# Unfortunately, these need to sync with the fucntions provided in the functions library
@export_enum("Wave", "Multiwave", "Ripple", "Sphere", "Torus") var function

@export_range(0.0, 100.0, 1.0, float) var function_duration : float = 1.0

@export_enum("Cycle", "Random") var transition_mode

@onready var functionLibrary = preload("res://scenes/common/graph/FunctionLibrary.gd")
var funcLibraryInstance : FunctionLibrary
var points : Array = []
var duration : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	funcLibraryInstance = functionLibrary.new()
	var point = preload("res://scenes/common/point/Point.tscn")
	var step: float = 2 / float(resolution)
	#	The 2 is needed because it uses transform coords rather than rect-coords like unity
	var stepScale: Vector3 = Vector3.ONE * step / 1.0
	var point_position: Vector3 = Vector3.ZERO
	
#	Grid of points
	points.resize(resolution * resolution)
	
	var x: int = 0
	var z: int  = 0
	for i in range(points.size()):
		if (x == resolution):
			x = 0
			z += 1
			
		var point_instance: Node3D = point.instantiate()
		points[i] = point_instance
		
		point_position.x = ((x + 0.5) * step - 1.0)
		point_position.z = ((z + 0.5) * step - 1.0)
		point_instance.translate_object_local(point_position)
		point_instance.scale_object_local(stepScale)
		
		add_child(point_instance)
		point_instance.set_owner(get_tree().edited_scene_root)

func _update_function():
	#	time at start of frame in seconds
	var time: float = (Time.get_ticks_msec()/1000.0)
	var step: float = 2 / float(resolution)
#	functionLibrary class is not  an object, so new() is required
#	instance is needed because get_functions is not a static call (due to using Callable)
	var fn: Callable = funcLibraryInstance.get_function(function)
	var x: int = 0
	var z: int  = 0
	var v : float = 0.5 * step - 1.0
	
	for i in range(points.size()):
		if (x == resolution):
			x = 0
			z += 1
			v = (z + 0.5) * step - 1.0
			
		var u : float = (x + 0.5) * step - 1.0
		
		points[i].transform.origin = fn.call(u, v, time)
		x += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	duration += delta
	if duration >= function_duration:
#		This is done so that timings do not get out of hand, if we go over the frame duration,
# 		We try to keep it in sync by removing some time on the next function
		duration -= function_duration
		_pick_next_function()
		
	_update_function()
	
func _pick_next_function():
	if function == transition_mode:
		function = funcLibraryInstance.get_next_function_name(function)
		
	function = funcLibraryInstance.get_random_function_name_other_than(function)
