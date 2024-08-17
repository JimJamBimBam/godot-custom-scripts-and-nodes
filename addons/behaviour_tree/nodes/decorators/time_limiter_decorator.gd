class_name TimeLimiterDecorator extends Decorator

## TimeLimiterDecorator will wait 'n' number of seconds for a 'RUNNING' child
## to return 'SUCCESS' before interrupting the child and returning 'FAILURE'

@onready var cache_key: String = "time_limiter_%s" % self.get_instance_id()

@export var wait_time: float = 0.0


func _get_configuration_warnings() -> PackedStringArray:
	if not get_child_count() == 1:
		return ["Requires exactly one child node"]
	return []


func tick(actor: Node, blackboard: Blackboard) -> int:
	if not get_child_count() == 1:
		return FAILURE
	
	var child = get_child(0) as BTNode
	
	var time_left: float = blackboard.get_value(cache_key, 0.0, str(actor.get_instance_id()))
	
	if time_left < wait_time:
		time_left += get_physics_process_delta_time()
		blackboard.set_value(cache_key, time_left, str(actor.get_instance_id()))
		var response = child.tick(actor, blackboard)
		
		if child is ConditionLeaf:
			blackboard.set_value(LAST_CONDITION, child, str(actor.get_instance_id()))
			blackboard.set_value(LAST_CONDITION_STATUS, response, str(actor.get_instance_id()))
			
		if response == RUNNING:
			running_child = child
			if child is ActionLeaf:
				blackboard.set_value(RUNNING_ACTION, child, str(actor.get_instance_id()))
		else:
			child.after_run(actor, blackboard)
		
		return response
	else:
		interrupt(actor, blackboard)
		child.after_run(actor, blackboard)
		return FAILURE


func before_run(actor: Node, blackboard: Blackboard) -> void:
	blackboard.set_value(cache_key, 0.0, str(actor.get_instance_id()))
	if get_child_count() > 0:
		var child = get_child(0) as BTNode
		child.before_run(actor, blackboard)


func get_class_name() -> Array[StringName]:
	var classes := super()
	classes.push_back(&"TimeLimiterDecorator")
	return classes
