class_name ParallelComposite extends Composite

## ParallelComposite will attempt to execute all children at the same time and can only have
## exactly two children. First child is primary node, second child is
## secondary node.
## ParallelComposite will always report the primary node's status and continue to tick
## while primary node returns 'RUNNING'.
## If primary node returns 'SUCCESS' or 'FAILURE', this node will interrupt
## secondary node and return primary node's result.
## If delay mode is set to true, it will wait for secondary node to finsih its action
## after primary node terminates.

## How many times secondary node repeats after primary node finishes.
## Zero means it will loop forever.
@export var secondary_node_repeat_count: int = 0

## Whether to wait for secondary node to finish its current action after primary node has finished.
@export var delay_mode: bool = false

var delayed_result := SUCCESS
var main_task_finished: bool = false
var secondary_node_running: bool = false
var secondary_node_repeat_left: int = 0


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = super._get_configuration_warnings()
	
	if get_child_count() != 2:
		warnings.append("Parallel should have exactly two child nodes.")
	
	if not get_child(0) is ActionLeaf:
		warnings.append("Parrallel should have an action leaf node as first child node.")
	
	return warnings


func tick(actor: Node, blackboard: Blackboard) -> int:
	for child in get_children():
		child = child as BTNode
		var node_index: int = child.get_index()
		if node_index == 0 and not main_task_finished:
			if child != running_child:
				child.before_run(actor, blackboard)
			
			var response: int = child.tick(actor, blackboard)
			
			delayed_result = response
			match response:
				SUCCESS, FAILURE:
					_cleanup_running_task(child, actor, blackboard)
					child.after_run(actor, blackboard)
					main_task_finished = true
					if not delay_mode:
						if secondary_node_running:
							var secondary_child = get_child(1)
							if secondary_child is BTNode:
								secondary_child.interrupt(actor, blackboard)
						_reset()
						return delayed_result
				RUNNING:
					running_child = child
					if child is ActionLeaf:
						blackboard.set_value(BTNode.RUNNING_ACTION, child, str(actor.get_instance_id()))
		
		elif node_index == 1:
			if secondary_node_repeat_count == 0 or secondary_node_repeat_left > 0:
				if not secondary_node_running:
					child.before_run(actor, blackboard)
				var subtree_response: int = child.tick(actor, blackboard)
				if subtree_response != RUNNING:
					secondary_node_running = false
					child.after_run(actor, blackboard)
					if delay_mode and main_task_finished:
						_reset()
						return delayed_result
					elif secondary_node_repeat_left > 0:
						secondary_node_repeat_left -= 1
				else:
					secondary_node_running = true
	
	return RUNNING


func before_run(actor: Node, blackboard: Blackboard) -> void:
	secondary_node_repeat_left = secondary_node_repeat_count
	super(actor, blackboard)


func interrupt(actor: Node, blackboard: Blackboard) -> void:
	if not main_task_finished:
		get_child(0).interrupt(actor, blackboard)
	if secondary_node_running:
		get_child(1).interrupt(actor, blackboard)
	_reset()
	super(actor, blackboard)


func after_run(actor: Node, blackboard: Blackboard) -> void:
	_reset()
	super(actor, blackboard)


func _reset() -> void:
	main_task_finished = false
	secondary_node_running = false


## Changes `running_action` and `running_child` after the node finishes executing.
func _cleanup_running_task(finished_action: Node, actor: Node, blackboard: Blackboard):
	var blackboard_name = str(actor.get_instance_id())
	if finished_action == running_child:
		running_child = null
		if finished_action == blackboard.get_value(BTNode.RUNNING_ACTION, null, blackboard_name):
			blackboard.set_value(BTNode.RUNNING_ACTION, null, blackboard_name)


func get_class_name() -> Array[StringName]:
	var classes := super()
	classes.push_back(&"ParallelComposite")
	return classes
