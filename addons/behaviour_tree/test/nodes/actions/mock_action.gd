class_name MockAction extends ActionLeaf

## Mock Action allows for a Behaviour Tree to be tested under some certain conditions
## that are set before hand.

## What is the final result expected to be?
@export_enum("Success", "Failure") var _final_result: int = 0
## How many frames is this action expected to run for?
@export var _running_frame_count: int = 0

signal started_running(actor, blackboard)
signal stopped_running(actor, blackoard)
signal interrupted(actor, blackboard)

## The amount of frames that have ticked over in the tick() method,
## or how many times tick() has been called since starting.
var tick_count: int = 0


func _init(running_frame_count: int = 0, final_result: int = 0) -> void:
	_final_result = final_result
	_running_frame_count = running_frame_count


func before_run(actor: Node, blackboard: Blackboard) -> void:
	tick_count = 0
	started_running.emit(actor, blackboard)


func tick(_actor: Node, _blackboard: Blackboard) -> int:
	if tick_count < _running_frame_count:
		tick_count += 1
		return RUNNING
	else:
		return _final_result


func interrupt(actor: Node, blackboard: Blackboard) -> void:
	interrupted.emit(actor, blackboard)


func after_run(actor: Node, blackboard: Blackboard) -> void:
	tick_count = 0
	stopped_running.emit(actor, blackboard)
