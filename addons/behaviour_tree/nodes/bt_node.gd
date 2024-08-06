class_name BTNode extends Node

## Each BTNode must return one of these for th status.
enum { SUCCESS, FAILURE, RUNNING }

## Executes this nod and returns status
## Must overwrite this function.
func tick(actor: Node, blackboard: Blackboard) -> int:
	return SUCCESS


## Called when this node needs to be interrupted before it can return FAILURE or SUCCESS.
func interrupt(actor: Node, blackboard: Blackboard) -> void:
	pass


## Code that runs before tick of parent.
func before_run(actor: Node, blackboard: Blackboard) -> void:
	pass


## Called after the last time it ticks and returns
## [code]SUCCESS[/code] or [code]FAILURE[/code].
func after_run(actor: Node, blackboard: Blackboard) -> void:
	pass


func get_class_name() -> Array[StringName]:
	return [&"BTNode"]

