class_name MockAction extends ActionLeaf

## Mock Action allows for a Behaviour Tree to be tested under some certain conditions
## that are set before hand.

## What is the final result expected to be?
@export_enum("Success", "Failure") var final_result: int = 0
## How many frames is this action expected to run for?
@export var running_frame_count: int = 0

signal started_running(actor, blackboard)
signal stopped_running(actor, blackoard)
signal ticked(actor, blackboard)
signal interrupted(actor, blackboard)

## The amount of frames that have ticked over in the tick() method,
## or how many times tick() has been called since starting.
var tick_count: int = 0


func before_run(actor: Node, blackboard: Blackboard) -> void:
	tick_count = 0
	started_running.emit(actor, blackboard)


func tick(actor: Node, blackboard: Blackboard) -> int:
	ticked.emit(actor, blackboard)
	if tick_count < running_frame_count:
		tick_count += 1
		return RUNNING
	else:
		return final_result


func interrupt(actor: Node, blackboard: Blackboard) -> void:
	interrupted.emit(actor, blackboard)


func after_run(actor: Node, blackboard: Blackboard) -> void:
	tick_count = 0
	stopped_running.emit(actor, blackboard)
