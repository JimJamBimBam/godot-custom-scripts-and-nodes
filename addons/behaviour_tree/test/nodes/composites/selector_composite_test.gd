# GdUnit generated TestSuite
class_name SelectorCompositeTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/behaviour_tree/nodes/composites/selector_composite.gd'
const __mock_action = "res://addons/behaviour_tree/test/nodes/actions/mock_action.gd"
const __behaviour_tree = "res://addons/behaviour_tree/nodes/behaviour_tree.gd"
const __blackboard = "res://addons/behaviour_tree/blackboard.gd"

var behaviour_tree: BehaviourTree
var selector: SelectorComposite
var mock_action_1: MockAction
var mock_action_2: MockAction
var actor: Node
var blackboard: Blackboard

var blackboard_1_name: String
var blackboard_2_name: String


func before_test() -> void:	
	behaviour_tree = auto_free(load(__behaviour_tree).new())
	selector = auto_free(load(__source).new())
	mock_action_1 = auto_free(load(__mock_action).new())
	mock_action_2 = auto_free(load(__mock_action).new())
	actor = auto_free(Node.new())
	blackboard = auto_free(load(__blackboard).new())
	
	# mock action(s) setup
	mock_action_1.started_running.connect(_on_action_started.bind(mock_action_1))
	mock_action_1.stopped_running.connect(_on_action_stopped.bind(mock_action_1))
	mock_action_1.ticked.connect(_on_action_ticked.bind(mock_action_1))
	mock_action_1.interrupted.connect(_on_action_interrupted.bind(mock_action_1))
	mock_action_2.started_running.connect(_on_action_started.bind(mock_action_2))
	mock_action_2.stopped_running.connect(_on_action_stopped.bind(mock_action_2))
	mock_action_2.ticked.connect(_on_action_ticked.bind(mock_action_2))
	mock_action_2.interrupted.connect(_on_action_interrupted.bind(mock_action_2))

	
	behaviour_tree.add_child(selector)
	selector.add_child(mock_action_1)
	selector.add_child(mock_action_2)
	
	behaviour_tree.actor = actor
	behaviour_tree.blackboard = blackboard
	
	blackboard_1_name = "blackboard_%s" % str(mock_action_1.get_instance_id())
	blackboard_2_name = "blackboard_%s" % str(mock_action_2.get_instance_id())


func after_test() -> void:
	behaviour_tree.blackboard.set_value("started", 0, blackboard_1_name)
	behaviour_tree.blackboard.set_value("ended", 0, blackboard_1_name)
	behaviour_tree.blackboard.set_value("ticked", 0, blackboard_1_name)
	behaviour_tree.blackboard.set_value("interrupted", 0, blackboard_1_name)
	
	behaviour_tree.blackboard.set_value("started", 0, blackboard_2_name)
	behaviour_tree.blackboard.set_value("ended", 0, blackboard_2_name)
	behaviour_tree.blackboard.set_value("ticked", 0, blackboard_2_name)
	behaviour_tree.blackboard.set_value("interrupted", 0, blackboard_2_name)


## Test to make sure other nodes are not called if first one in the selector is returning 'SUCCESS'.
func test_first_successful_node_always_executing() -> void:
	mock_action_1.final_result = BTNode.SUCCESS
	mock_action_2.final_result = BTNode.SUCCESS
	assert_that(selector.tick(actor, blackboard)).is_equal(BTNode.SUCCESS)
	assert_that(selector.tick(actor, blackboard)).is_equal(BTNode.SUCCESS)
	var mock_action_1_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_1_name)
	var mock_action_2_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_2_name)
	assert_int(mock_action_1_times_ticked).is_equal(2)
	assert_int(mock_action_2_times_ticked).is_equal(0)


## Test to make sure the next available node is being called after the first one returns 'FAILURE'.
func test_second_successful_node_always_executing_when_first_fails() -> void:
	mock_action_1.final_result = BTNode.FAILURE
	mock_action_2.final_result = BTNode.SUCCESS
	assert_that(selector.tick(actor, blackboard)).is_equal(BTNode.SUCCESS)
	assert_that(selector.tick(actor, blackboard)).is_equal(BTNode.SUCCESS)
	var mock_action_1_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_1_name)
	var mock_action_2_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_2_name)
	assert_int(mock_action_1_times_ticked).is_equal(1)
	assert_int(mock_action_2_times_ticked).is_equal(2)


## Test to make sure selector is returning 'FAILURE' when nodes all return 'FAILURE'.
func test_return_failure_when_none_is_succeeding() -> void:
	mock_action_1.final_result = BTNode.FAILURE
	mock_action_2.final_result = BTNode.FAILURE
	assert_that(selector.tick(actor, blackboard)).is_equal(BTNode.FAILURE)
	var mock_action_1_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_1_name)
	var mock_action_2_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_2_name)
	assert_int(mock_action_1_times_ticked).is_equal(1)
	assert_int(mock_action_2_times_ticked).is_equal(1)


## Test to make sure that a failed node does not get called
## when subsequent nodes are returning 'RUNNING'.
func test_not_interrupt_second_when_first_is_succeeding() -> void:
	mock_action_1.final_result = BTNode.FAILURE
	mock_action_2.final_result = BTNode.RUNNING
	assert_that(selector.tick(actor, blackboard)).is_equal(BTNode.RUNNING)
	var mock_action_1_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_1_name)
	var mock_action_2_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_2_name)
	assert_int(mock_action_1_times_ticked).is_equal(1)
	assert_int(mock_action_2_times_ticked).is_equal(1)
	
	mock_action_1.final_result = BTNode.SUCCESS
	assert_that(selector.tick(actor, blackboard)).is_equal(BTNode.RUNNING)
	mock_action_1_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_1_name)
	mock_action_2_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_2_name)
	assert_int(mock_action_1_times_ticked).is_equal(1)
	assert_int(mock_action_2_times_ticked).is_equal(2)


## Test to see if second node still runs even if first is returns 'RUNNING'.
func test_not_interrupt_second_when_first_is_running() -> void:
	mock_action_1.final_result = BTNode.FAILURE
	mock_action_2.final_result = BTNode.RUNNING
	assert_that(selector.tick(actor, blackboard)).is_equal(BTNode.RUNNING)
	var mock_action_1_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_1_name)
	var mock_action_2_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_2_name)
	assert_that(mock_action_1_times_ticked).is_equal(1)
	assert_that(mock_action_2_times_ticked).is_equal(1)

	mock_action_1.final_result = BTNode.RUNNING
	assert_that(selector.tick(actor, blackboard)).is_equal(BTNode.RUNNING)
	mock_action_1_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_1_name)
	mock_action_2_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_2_name)
	assert_that(mock_action_1_times_ticked).is_equal(1)
	assert_that(mock_action_2_times_ticked).is_equal(2)


## Test to see if the child node that returned 'RUNNING' returns 'RUNNING' again.
func test_tick_again_when_child_returns_running() -> void:
	mock_action_1.final_result = BTNode.FAILURE
	mock_action_2.final_result = BTNode.RUNNING
	assert_that(selector.tick(actor, blackboard)).is_equal(BTNode.RUNNING)
	assert_that(selector.tick(actor, blackboard)).is_equal(BTNode.RUNNING)
	var mock_action_1_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_1_name)
	var mock_action_2_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_2_name)
	assert_that(mock_action_1_times_ticked).is_equal(1)
	assert_that(mock_action_2_times_ticked).is_equal(2)


## Test to see if 'running_child' property of SelectorDecorator
## is properly nulled out when a child node is no longer running.
func test_clear_running_child_after_run() -> void:
	mock_action_1.final_result = BTNode.FAILURE
	mock_action_2.final_result = BTNode.RUNNING
	behaviour_tree.tick()
	assert_that(selector.running_child).is_equal(mock_action_2)
	mock_action_2.final_result = BTNode.FAILURE
	behaviour_tree.tick()
	assert_that(selector.running_child).is_equal(null)


## Test to see if a node that returns 'RUNNING' ignores all subsequent nodes and
## if it then returns 'FAILURE', that the other nodes are able to then continue to run.
func test_not_interrupt_first_after_finished() -> void:
	var action3 = auto_free(load(__mock_action).new())
	action3.ticked.connect(_on_action_ticked.bind(action3))
	selector.add_child(action3)

	mock_action_1.final_result = BTNode.RUNNING
	mock_action_2.final_result = BTNode.FAILURE
	action3.final_result = BTNode.RUNNING

	assert_that(selector.tick(actor, blackboard)).is_equal(BTNode.RUNNING)
	var mock_action_1_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_1_name)
	var mock_action_2_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_2_name)
	var action3_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, "blackboard_%s" % str(mock_action_2.get_instance_id()))
	assert_that(mock_action_1_times_ticked).is_equal(1)
	assert_that(mock_action_2_times_ticked).is_equal(0)
	assert_that(action3_times_ticked).is_equal(0)

	mock_action_1.final_result = BTNode.FAILURE
	assert_that(selector.tick(actor, blackboard)).is_equal(BTNode.RUNNING)
	mock_action_1_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_1_name)
	mock_action_2_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_2_name)
	action3_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, "blackboard_%s" % str(mock_action_2.get_instance_id()))
	assert_that(mock_action_1_times_ticked).is_equal(2)
	assert_that(mock_action_2_times_ticked).is_equal(1)
	assert_that(action3_times_ticked).is_equal(1)

	selector.remove_child(action3)


func test_interrupt_when_nested() -> void:
	assert_not_yet_implemented()
	#var test_selector = auto_free(load(__source).new())
	#var fake_condition = auto_free(load(__mock_action).new())
	#
	#behaviour_tree.remove_child(selector)
	#behaviour_tree.add_child(test_selector)
	#test_selector.add_child(fake_condition)
	#test_selector.add_child(selector)
	#
	#fake_condition.final_result = BTNode.FAILURE
	#mock_action_1.final_result = BTNode.RUNNING
	#
	#assert_that(behaviour_tree.tick()).is_equal(BTNode.RUNNING)
	#behaviour_tree.interrupt()
	#var mock_action_1_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_1_name)
	#var mock_action_2_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_2_name)
	#assert_that(mock_action_1_times_ticked).is_equal(1)
	#assert_that(mock_action_2_times_ticked).is_equal(0)
	#
	#fake_condition.final_result = BTNode.SUCCESS
	#assert_that(behaviour_tree.tick()).is_equal(BTNode.SUCCESS)
	#var mock_action_1_times_interrupted = behaviour_tree.blackboard.get_value("interrupted", 0, blackboard_1_name)
	#var mock_action_2_times_interrupted = behaviour_tree.blackboard.get_value("interrupted", 0, blackboard_2_name)
	#assert_that(mock_action_1_times_interrupted).is_equal(1)
	#assert_that(mock_action_2_times_interrupted).is_equal(1)
	


func _on_action_started(actor: Node, blackboard: Blackboard, called_action: BTNode) -> void:
	var blackboard_name: String = "blackboard_%s" % str(called_action.get_instance_id())
	var started: int = blackboard.get_value("started", 0, blackboard_name)
	blackboard.set_value("started", started + 1, blackboard_name)


func _on_action_stopped(actor: Node, blackboard: Blackboard, called_action: BTNode) -> void:
	var blackboard_name: String = "blackboard_%s" % str(called_action.get_instance_id())
	var ended: int = blackboard.get_value("ended", 0, blackboard_name)
	blackboard.set_value("ended", ended + 1, blackboard_name)


func _on_action_ticked(actor: Node, blackboard: Blackboard, called_action: BTNode) -> void:
	var blackboard_name: String = "blackboard_%s" % str(called_action.get_instance_id())
	var ticked: int = blackboard.get_value("ticked", 0, blackboard_name)
	blackboard.set_value("ticked", ticked + 1, blackboard_name)


func _on_action_interrupted(actor: Node, blackboard: Blackboard, called_action: BTNode) -> void:
	var blackboard_name: String = "blackboard_%s " % str(called_action.get_instance_id())
	var interrupted: int = blackboard.get_value("interrupted", 0, blackboard_name)
	blackboard.set_value("interrupted", interrupted + 1, blackboard_name)
