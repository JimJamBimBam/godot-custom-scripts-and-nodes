class_name BehaviourTree extends Node

# TODO: Refactor BehaviourTree so that it either keeps track of 'delta time' itself,
# or sets the value in the blackboard for other nodes to keep track of.

enum { SUCCESS, FAILURE, RUNNING }

enum ProcessThread { IDLE, PHYSICS }

signal tree_enabled
signal tree_disabled

## Whether to enable or disable this tree.
@export var enabled: bool = true:
	set(value):
		enabled = value
		set_physics_process(enabled and process_thread == ProcessThread.PHYSICS)
		set_process(enabled and process_thread == ProcessThread.IDLE)
		if value == true:
			tree_enabled.emit()
		else:
			interrupt()
			tree_disabled.emit()
	get:
		return enabled

## Whether this runs in the process or physics process.
@export var process_thread: ProcessThread = ProcessThread.PHYSICS:
	set(value):
		process_thread = value
		set_physics_process(enabled and process_thread == ProcessThread.PHYSICS)
		set_process(enabled and process_thread == ProcessThread.IDLE)

## How often the tree should tick, in frames. Default of 1 means
## tick() runs every frame, 2, every 2 frames etc.
@export var tick_rate: int = 1

## The data store for an entire behaviour tree.
## If no value is set, an internal blackboard is created and added as a child
## to the behaviour tree.
## If a value is set, any internal blackboards are removed.
@export var blackboard: Blackboard:
	set(b):
		blackboard = b
		if blackboard and _internal_blackboard:
			remove_child(_internal_blackboard)
			_internal_blackboard.free()
			_internal_blackboard = null
		elif not blackboard and not _internal_blackboard:
			_internal_blackboard = Blackboard.new()
			add_child(_internal_blackboard, false, Node.INTERNAL_MODE_BACK)
	get:
		# in case blackboard is accessed before this node is,
		# we need to ensure that the internal blackboard is used.
		if not blackboard and not _internal_blackboard:
			_internal_blackboard = Blackboard.new()
			add_child(_internal_blackboard, false, Node.INTERNAL_MODE_BACK)
		return blackboard if blackboard else _internal_blackboard

@export var actor: Node:
	set(new_actor):
		actor = new_actor
		if actor == null:
			actor = get_parent()
		if Engine.is_editor_hint():
			update_configuration_warnings()

## Reference to the internal blackboard incase one is not supplied.
var _internal_blackboard: Blackboard
## This is the result of the behaviour tree after walking through it's children.
var status: int = -1
## Number of frame ticks since the last reset due to tick_rate being reached.
## Used to determine when the behaviour tree can perform tick() on it's child.
var last_tick: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not process_thread:
		process_thread = ProcessThread.PHYSICS
	
	if actor == null:
		actor = get_parent()
	
	if not blackboard:
		self.blackboard = null
	
	set_physics_process(enabled and process_thread == ProcessThread.PHYSICS)
	set_process(enabled and process_thread == ProcessThread.IDLE)
	
	if Engine.is_editor_hint():
		update_configuration_warnings.call_deferred()
	
	# Randomize at what frames tick() will happen to avoid stutters
	last_tick = randi_range(0, tick_rate - 1)


func _physics_process(delta: float) -> void:
	_process_internally()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_process_internally()


func _process_internally() -> void:
	if Engine.is_editor_hint():
		return
	
	if last_tick < tick_rate - 1:
		last_tick += 1
		return
	
	last_tick = 0
	
	tick()


func tick() -> int:
	# Null checks
	if actor == null or self.get_child_count() == 0:
		status = FAILURE
		return status
	
	var child = get_child(0) as BTNode
	
	if status != RUNNING:
		child.before_run(actor, blackboard)
	
	status = child.tick(actor, blackboard)
	
	## Clear the running action if nothing is happening.
	if status != RUNNING:
		blackboard.set_value(BTNode.RUNNING_ACTION, null, str(actor.get_instance_id()))
		child.after_run(actor, blackboard)
	
	return status


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	
	if actor == null:
		warnings.append("Configure the target node for tree.")
	
	if get_children().any(func(x): return not (x is BTNode)):
		warnings.append("All children of this node should inherit from BTNode class.")
		
	if get_child_count() != 1:
		warnings.append("BhaviourTree should have exactly one child node.")
		
	return warnings


## Returns the currently running action
func get_running_action() -> ActionLeaf:
	return blackboard.get_value(BTNode.RUNNING_ACTION, null, str(actor.get_instance_id()))


## Returns the last condition that was executed
func get_last_condition() -> ConditionLeaf:
	return blackboard.get_value(BTNode.RUNNING_ACTION, null, str(actor.get_instance_id()))


## Returns the status of the last executed condition
func get_last_condition_status() -> String:
	if blackboard.has_value(BTNode.LAST_CONDITION_STATUS, str(actor.get_instance_id())):
		var status = blackboard.get_value(
			BTNode.LAST_CONDITION_STATUS, null, str(actor.get_instance_id())
		)
		if status == SUCCESS:
			return "SUCCESS"
		elif status == FAILURE:
			return "FAILURE"
		else:
			return "RUNNING"
	return ""


## interrupts this tree if anything was running
func interrupt() -> void:
	if self.get_child_count() != 0:
		var first_child = self.get_child(0) as BTNode
		first_child.interrupt(actor, blackboard)


## Enables this tree.
func enable() -> void:
	self.enabled = true


## Disables this tree.
func disable() -> void:
	self.enabled = false


func get_class_name() -> Array[StringName]:
	return [&"BeehaveTree"]
