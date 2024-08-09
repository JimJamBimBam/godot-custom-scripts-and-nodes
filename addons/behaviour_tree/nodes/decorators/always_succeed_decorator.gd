class_name AlwaysSucceedDecorator extends Decorator

## Always Succeed Decorator will always return a 'SUCCEED' status
## whether or not an action node returns 'SUCCEED' or 'FAILURE'.
## Will, however, return 'RUNNING' if an action node is 'RUNNING'.

func tick(actor: Node, blackboard: Blackboard) -> int:
	var child: BTNode = get_child(0) as BTNode
	
	if child != running_child:
		child.before_run(actor, blackboard)
	
	var response: int = child.tick(actor, blackboard)
	
	if child is ConditionLeaf:
		blackboard.set_value(LAST_CONDITION, child, str(actor.get_instance_id()))
		blackboard.set_value(LAST_CONDITION_STATUS, response, str(actor.get_instance_id()))
	
	if response == RUNNING:
		running_child = child
		if child is ActionLeaf:
			blackboard.set_value(RUNNING_ACTION, child, str(actor.get_instance_id()))
		return RUNNING
	else:
		child.after_run(actor, blackboard)
		return SUCCESS


func get_class_name() -> Array[StringName]:
	var classes := super()
	classes.push_back(&"AlwaysSucceedDecorator")
	return classes
