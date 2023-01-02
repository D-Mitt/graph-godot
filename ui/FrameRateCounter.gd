extends Node
enum DisplayMode {FPS, MS}
@export_range(0.1, 2.0, 0.1, float) var sample_duration : float = 1.0
@export_enum("FPS", "MS") var display_mode
@onready var frames : int = 0
@onready var duration : float = 0.0
@onready var float_max : float = float("1.79769e308") # float max
@onready var best_duration : float = float_max # set to float max
@onready var worst_duration : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
#	Average of how long a frame is over a given duration
	frames += 1
	duration += delta
	var frame_duration: float = frames / duration
	var title : RichTextLabel = $CanvasLayer/FPSVertContainer/HBoxContainer/VBoxContainer/Title
	var bestFPS : RichTextLabel = $CanvasLayer/FPSVertContainer/HBoxContainer/VBoxContainer/BestFPS
	var averageFPS : RichTextLabel = $CanvasLayer/FPSVertContainer/HBoxContainer/VBoxContainer/AverageFPS
	var worstFPS : RichTextLabel = $CanvasLayer/FPSVertContainer/HBoxContainer/VBoxContainer/WorstFPS
	
	if delta < best_duration:
		best_duration = delta
		
	if delta > worst_duration:
		worst_duration = delta

	if duration >= sample_duration:
		if display_mode == DisplayMode.FPS:
#			Set title
			title.clear()
			title.add_text("FPS")
			
	#		clear, format to 2 decimal places
			bestFPS.clear()
			var best_format_string = "%.0f"
			var best_actual_string = best_format_string % (1.0 / best_duration)
			bestFPS.add_text(best_actual_string)
			
			averageFPS.clear()
			var average_format_string = "%.0f"
			var average_actual_string = average_format_string % frame_duration
			averageFPS.add_text(average_actual_string)
			
			worstFPS.clear()
			var worst_format_string = "%.0f"
			var worst_actual_string = worst_format_string % (1.0 / worst_duration)
			worstFPS.add_text(worst_actual_string)
		else:
			title.clear()
			title.add_text("MS")
				#		clear, format to 2 decimal places
			bestFPS.clear()
			var best_format_string = "%.1f"
			var best_actual_string = best_format_string % (1000 * best_duration)
			bestFPS.add_text(best_actual_string)
			
			averageFPS.clear()
			var average_format_string = "%.1f"
			var average_actual_string = average_format_string % (1000 * duration/frames)
			averageFPS.add_text(average_actual_string)
			
			worstFPS.clear()
			var worst_format_string = "%.1f"
			var worst_actual_string = worst_format_string % (worst_duration*1000)
			worstFPS.add_text(worst_actual_string)
			
#		reset averaging
		frames = 0
		duration = 0.0
		worst_duration = 0.0
		best_duration = float_max
