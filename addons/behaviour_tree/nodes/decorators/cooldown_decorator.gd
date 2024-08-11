class_name CooldownDecorator extends Decorator

## Cooldown will return 'FAILURE' for a set amount of time, in seconds,
## until it can process again.

@export var wait_time: float = 0.0

@onready var cache_key: String = "cooldown_%s" % self.get_instance_id()


func tick(actor: Node, blackboard: Blackboard) -> int:
	var child: BTNode = get_child(0) as BTNode
	var remaining_time: float = blackboard.get_value(cache_key, 0.0, str(actor.get_instance_id()))
	var response: int
	
	if child != running_child:
		child.before_run(actor, blackboard)
	
	if remaining_time > 0.0:
		response = FAILURE
		remaining_time -= get_physics_process_delta_time()
		blackboard.set_value(cache_key, remaining_time, str(actor.get_instance_id()))
	else:
		response = child.tick(actor, blackboard)
		
		if child is ConditionLeaf:
			blackboard.set_value(LAST_CONDITION, child, str(actor.get_instance_id()))
			blackboard.set_value(LAST_CONDITION_STATUS, response, str(actor.get_instance_id()))
	
		if response == RUNNING and child is ActionLeaf:
			running_child = child
			blackboard.set_value(RUNNING_ACTION, child, str(actor.get_instance_id()))
			
		if response != RUNNING:
			blackboard.set_value(cache_key, wait_time, str(actor.get_instance_id()))
	
	return response


func get_class_name() -> Array[StringName]:
	var classes := super()
	classes.push_back(&"CooldownDecorator")
	return classes
