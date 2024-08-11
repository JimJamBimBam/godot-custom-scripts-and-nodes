class_name DelayDecorator extends Decorator

## Returns 'RUNNING' for a set amount of time before returning 'SUCCESS' or 'FAILURE'.

@export var wait_time: float = 0.0

@onready var cache_key: String = "time_limiter_%s" % self.get_instance_id()


func tick(actor: Node, blackboard: Blackboard) -> int:
	var child: BTNode = get_child(0) as BTNode
	var total_time: float = blackboard.get_value(cache_key, 0.0, str(actor.get_instance_id()))
	var response: int
	
	if child != running_child:
		child.before_run(actor, blackboard)
	
	if total_time < wait_time:
		response = RUNNING
		total_time += get_physics_process_delta_time()
		blackboard.set_value(cache_key, total_time, str(actor.get_instance_id()))
	else:
		response = child.tick(actor, blackboard)
		
		if child is ConditionLeaf:
			blackboard.set_value(LAST_CONDITION, child, str(actor.get_instance_id()))
			blackboard.set_value(LAST_CONDITION_STATUS, response, str(actor.get_instance_id()))
		
		if response == RUNNING and child is ActionLeaf:
			running_child = child
			blackboard.set_value(RUNNING_ACTION, child, str(actor.get_instance_id()))
	
		if response != RUNNING:
			blackboard.set_value(cache_key, 0.0, str(actor.get_instance_id()))
	
	return response


func get_class_name() -> Array[StringName]:
	var classes := super()
	classes.push_back(&"DelayDecorator")
	return classes
