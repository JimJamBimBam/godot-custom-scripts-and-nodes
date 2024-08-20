class_name UntilFailDecorator extends Decorator


func _get_configuration_warnings() -> PackedStringArray:
	if not get_child_count() == 1:
		return ["Requires exactly one child node"]
	return []


func tick(actor: Node, blackboard: Blackboard) -> int:
	if not get_child_count() == 1:
		return RUNNING
	
	var child: BTNode = get_child(0) as BTNode
	
	if child != running_child:
		child.before_run(actor, blackboard)
	
	var response: int = child.tick(actor, blackboard)
	
	if child is ConditionLeaf:
		blackboard.set_value(LAST_CONDITION, child, str(actor.get_instance_id()))
		blackboard.set_value(LAST_CONDITION_STATUS, response, str(actor.get_instance_id()))
	
	if child is ActionLeaf:
		running_child = child
		blackboard.set_value(RUNNING_ACTION, child, str(actor.get_instance_id()))
	
	
	match response:
		SUCCESS:
			#child.after_run(actor, blackboard)
			response = RUNNING
		RUNNING:
			response = RUNNING
		FAILURE:
			response = SUCCESS
		_:
			push_error("Should not get here.")
	#child.after_run(actor, blackboard)
		#
	return response
