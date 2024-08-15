class_name LimiterDecorator extends Decorator

## The limiter will execute its 'RUNNING' child 'n' number of times.
## When the maximum ticks is reached, it will instead return a 'FAILURE'.
## Count will reset when a child is no longer returning 'RUNNING'.

@onready var cache_key: String = "limiter_%s" % self.get_instance_id()

@export var max_count: int = 0


func _get_configuration_warnings() -> PackedStringArray:
	if not get_child_count() == 1:
		return ["Requires exactly one child node"]
	return []


func tick(actor: Node, blackboard: Blackboard) -> int:
	var child = get_child(0) as BTNode
	
	var current_count: int = blackboard.get_value(cache_key, 0, str(actor.get_instance_id()))
	
	if current_count < max_count:
		blackboard.set_value(cache_key, current_count + 1, str(actor.get_instance_id()))
		var response = child.tick(actor, blackboard)
		
		if child is ConditionLeaf:
			blackboard.set_value(LAST_CONDITION, child, str(actor.get_instance_id()))
			blackboard.set_value(LAST_CONDITION_STATUS, response, str(actor.get_instance_id()))
			
		if child is ActionLeaf and response == RUNNING:
			running_child = child
			blackboard.set_value(RUNNING_ACTION, child, str(actor.get_instance_id))
		
		if response != RUNNING:
			child.after_run(actor, blackboard)
		
		return response
	else:
		interrupt(actor, blackboard)
		child.after_run(actor, blackboard)
		return FAILURE


func before_run(actor: Node, blackboard: Blackboard) -> void:
	blackboard.set_value(cache_key, 0, str(actor.get_instance_id()))
	if get_child_count() > 0:
		var child = get_child(0) as BTNode
		child.before_run(actor, blackboard)


func get_class_name() -> Array[StringName]:
	var classes := super()
	classes.push_back(&"LimiterDecorator")
	return classes
