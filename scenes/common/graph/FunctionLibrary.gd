class_name FunctionLibrary

enum FunctionName {WAVE, MULTIWAVE, RIPPLE, SPHERE, TORUS}

# Cannot directly have an array of callables, so putting them inside a dictionary
var functions = [
	{"callable": Callable(self, "wave")}, 
	{"callable": Callable(self, "multiwave")}, 
	{"callable": Callable(self, "ripple")},
	{"callable": Callable(self, "sphere")},
	{"callable": Callable(self, "torus")}
]

func _init():
	pass
		
static func wave(u : float, v : float, t : float) -> Vector3:
	var p : Vector3 = Vector3.ONE
	p.x = u
	p.y = sin(PI * (u + v + t))
	p.z = v
	return p
	
static func multiwave(u : float, v : float, t : float) -> Vector3:
	var p : Vector3 = Vector3.ONE
	p.x = u
	p.y = sin(PI * (u + 0.5 * t))
	p.y += 0.5 * sin(2.0 * PI * (v + t))
	p.y += sin(PI * (u + v + 0.25 * t))
	p.y *= 1.0 / 2.5
	p.z = v
	return p

static func ripple(u : float, v : float, t : float) -> Vector3:
	var p : Vector3 = Vector3.ONE
	p.x = u
	var d : float = sqrt(u*u + v*v)
	p.y = sin(PI * (4.0 * d - t));
	p.y /= (1.0 + 10.0 * d)
	p.z = v
	return p
	
static func sphere(u : float, v : float, t : float) -> Vector3:
	var r : float = 0.9 + 0.1 * sin(PI * (6.0 * u + 4.0 * v + t));
	var s : float = r * cos(0.5 * PI * v)
	var p : Vector3 = Vector3.ONE
	p.x = s * sin(PI * u)
	p.y = r * sin(PI * 0.5 * v)
	p.z = s * cos(PI * u)
	return p
	
static func torus(u : float, v : float, t : float) -> Vector3:
	var r1 : float = 0.75 + 0.1 * sin(PI * u + 0.5 *t);
	var r2 : float = 0.25 + 0.05 * sin(PI * (8.0 * u + 4.0 * v + 2.0 * t));
	var s : float = r1 + r2 * cos(PI * v);
	var p : Vector3 = Vector3.ONE
	p.x = s * sin(PI * u);
	p.y = r2 * sin(PI * v);
	p.z = s * cos(PI * u);
	return p;
	
func get_function(name : FunctionName) -> Callable:
	return functions[int(name)].callable

func get_next_function_name(name : FunctionName):
	if int(name) < functions.size() - 1:
		return name + 1
	
#	At end so return back to first function
	return 0

func get_random_function_name_other_than(name : FunctionName):
	var choice = randi_range(1, functions.size() - 1)
	if choice == name:
		return 0
	
	return choice

func morph(u : float, v : float, t : float, from : Callable, to : Callable, progress : float) -> Vector3:
	var from_vector = from.call(u, v, t) as Vector3
	var to_vector = to.call(u, v, t) as Vector3
	return from_vector.lerp(to_vector, smoothstep(0.0, 1.0, progress))
