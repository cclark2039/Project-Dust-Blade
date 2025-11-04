extends Label

@export var start_time: float = 0.0  # Starting time in seconds
var time_elapsed: float = 0.0
var running: bool = false

func _ready() -> void:
	time_elapsed = start_time
	running = true
	update_label()

func _process(delta: float) -> void:
	if running:
		time_elapsed += delta
		update_label()

func update_label() -> void:
	text = "Time Survived: %0.1f" % time_elapsed

func start() -> void:
	time_elapsed = start_time
	running = true
	update_label()

func stop() -> void:
	running = false

func reset() -> void:
	time_elapsed = start_time
	update_label()
