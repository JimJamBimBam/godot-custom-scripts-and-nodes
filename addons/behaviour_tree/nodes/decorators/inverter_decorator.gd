class_name InverterDecorator extends Decorator

## An inverter will return 'FAILURE' when it's child returns 'SUCCESS' or,
## 'SUCCESS' if the child returns 'FAILURE'.
## Returns 'RUNNING' if child node is also 'RUNNING'.

func tick(actor: Node, blackboard: Blackboard) -> int:
	var child = get_child(0) as BTNode
	
	if child != running_child:
		child.before_run(actor, blackboard)
	
	var response: int = child.tick(actor, blackboard)
	
	if child is ConditionLeaf:
		blackboard.set_value(LAST_CONDITION, child, str(actor.get_instance_id()))
		blackboard.set_value(LAST_CONDITION_STATUS, response, str(actor.get_instance_id()))
	
	match response:
		SUCCESS:
			child.after_run(actor, blackboard)
			return FAILURE
		FAILURE:
			child.after_run(actor, blackboard)
			return SUCCESS
		RUNNING:
			running_child = child
			if child is ActionLeaf:
				blackboard.set_value(RUNNING_ACTION, child, str(actor.get_instance_id()))
			return RUNNING
		_:
			push_error("This should be unreachable")
			return -1


func get_class_name() -> Array[StringName]:
	var classes := super()
	classes.push_back(&"Inverter")
	return classes
