class_name RepeaterDecorator extends Decorator

## Repeater will execute its child until it returns 'SUCCESS' a certain number of times.
## When a certain number of 'SUCCESS' ticks are reached, 'SUCCESS' is returned.
## If the child returns 'FAILURE', the repeater will return 'FAILURE' immediately.
## Returns 'RUNNING' for any other scenario.

@export_range(0, 100) var repetitions: int = 1

var current_count: int = 0


func before_run(actor: Node, blackboard: Blackboard) -> void:
	current_count = 0


func tick(actor: Node, blackboard: Blackboard) -> int:
	var child = get_child(0) as BTNode
	
	if current_count < repetitions:
		if running_child == null:
			child.before_run(actor, blackboard)
		
		var response = child.tick(actor, blackboard)
		
		if child is ConditionLeaf:
			blackboard.set_value(LAST_CONDITION, child, str(actor.get_instance_id()))
			blackboard.set_value(LAST_CONDITION_STATUS, response, str(actor.get_instance_id()))
		
		if response == RUNNING:
			running_child = child
			if child is ActionLeaf:
				blackboard.set_value(RUNNING_ACTION, child, str(actor.get_instance_id()))
			return RUNNING
		
		current_count += 1
		child.after_run(actor, blackboard)
		
		if running_child != null:
			running_child = null
		
		if response == FAILURE:
			return FAILURE
		
		if current_count >= repetitions:
			return SUCCESS
		
		return RUNNING
	else:
		return SUCCESS


func get_class_name() -> Array[StringName]:
	var classes := super()
	classes.push_back(&"RepeaterDecorator")
	return classes
