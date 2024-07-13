extends Node

## Dictionary of Events (key) and Array[Callables] (value).
## Each event should run through all the methods in it (if any are found).
var _broadcasters: Dictionary = {}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
