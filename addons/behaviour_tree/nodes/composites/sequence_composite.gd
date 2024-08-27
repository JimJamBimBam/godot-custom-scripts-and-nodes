class_name SequenceComposite extends Composite

## Sequence nodes will attempt to execute all of its children.
## If all children return 'SUCCESS', then sequence node will return 'SUCCESS'.
## If any one of the children return 'FAILURE', the sequence will restart.
## If a child returns 'RUNNING', this node will tick again.

var last_execution_index: int = 0

func tick(actor: Node, blackboard: Blackboard) -> int:
	for child in get_children():
		child = child as BTNode
		if child.get_index() < last_execution_index:
			continue
		
		if child != running_child:
			child.before_run(actor, blackboard)
		
		var response: int = child.tick(actor, blackboard)
		
		if child is ConditionLeaf:
			blackboard.set_value(BTNode.LAST_CONDITION, child, str(actor.get_instance_id()))
			blackboard.set_value(BTNode.LAST_CONDITION_STATUS, response, str(actor.get_instance_id()))
		
		match response:
			SUCCESS:
				_cleanup_running_task(child, actor, blackboard)
				last_execution_index += 1
				child.after_run(actor, blackboard)
			FAILURE:
				_cleanup_running_task(child, actor, blackboard)
				# Interrupt any child that was RUNNING before.
				interrupt(actor, blackboard)
				child.after_run(actor, blackboard)
				return FAILURE
			RUNNING:
				if child != running_child:
					if running_child != null:
						running_child.interrupt(actor, blackboard)
					running_child = child
				if child is ActionLeaf:
					blackboard.set_value(BTNode.RUNNING_ACTION, child, str(actor.get_instance_id()))
				return RUNNING
	
	_reset()
	return SUCCESS


func interrupt(actor: Node, blackboard: Blackboard) -> void:
	_reset()
	super(actor, blackboard)


func _reset() -> void:
	last_execution_index = 0


func _cleanup_running_task(finished_action: BTNode, actor: Node, blackboard: Blackboard) -> void:
	var blackboard_name: String = str(actor.get_instance_id())
	if finished_action == running_child:
		running_child = null
		if finished_action == blackboard.get_value(BTNode.RUNNING_ACTION, null, blackboard_name):
			blackboard.set_value(BTNode.RUNNING_ACTION, null, blackboard_name)


func get_class_name() -> Array[StringName]:
	var classes := super()
	classes.push_back(&"SequenceComposite")
	return classes
