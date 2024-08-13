class_name CountUpAction extends ActionLeaf

## A mock action that keeps track of the number of times it has run the tick() function.

@export var key = "custom_value"

var count: int = 0
var status: = SUCCESS


func tick(actor: Node, blackboard: Blackboard) -> int:
	count += 1
	blackboard.set_value(key, count)
	return status


func interrupt(actor: Node, blackboard: Blackboard) -> void:
	count = 0
	blackboard.set_value(key, count)
	status = FAILURE
