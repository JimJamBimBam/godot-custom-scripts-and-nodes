# GdUnit generated TestSuite
class_name UntilFailDecoratorTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/behaviour_tree/nodes/decorators/until_fail_decorator.gd'
const __mock_action = "res://addons/behaviour_tree/test/nodes/actions/mock_action.gd"
const __behaviour_tree = "res://addons/behaviour_tree/nodes/behaviour_tree.gd"
const __blackboard = "res://addons/behaviour_tree/blackboard.gd"

var behaviour_tree: BehaviourTree
var mock_action: MockAction
var until_fail: UntilFailDecorator
var actor: Node2D
var blackboard: Blackboard


func before_test() -> void:
	behaviour_tree = auto_free(load(__behaviour_tree).new())
	actor = auto_free(Node2D.new())
	blackboard = auto_free(load(__blackboard).new())

	behaviour_tree.actor = actor
	behaviour_tree.blackboard = blackboard
	mock_action = auto_free(load(__mock_action).new())
	until_fail = auto_free(load(__source).new())

	# mock action setup
	mock_action.running_frame_count = 3
	mock_action.started_running.connect(_on_action_started)
	mock_action.stopped_running.connect(_on_action_stopped)

	until_fail.add_child(mock_action)
	behaviour_tree.add_child(until_fail)


func after_test() -> void:
	# resets blackboard
	behaviour_tree.blackboard.set_value("started", 0)
	behaviour_tree.blackboard.set_value("ended", 0)


func test_child_returns_running_or_success_returns_running() -> void:
	mock_action.final_result = BTNode.SUCCESS
	
	for i in range(mock_action.running_frame_count + 1):
		assert_that(behaviour_tree.tick()).is_equal(BTNode.RUNNING)
	
	var times_started: int = blackboard.get_value("started", 0)
	var times_ended: int = blackboard.get_value("ended", 0)
	assert_int(times_started).is_equal(1)
	assert_int(times_ended).is_equal(0)
	
	mock_action.final_result = BTNode.FAILURE
	assert_that(behaviour_tree.tick()).is_equal(BTNode.SUCCESS)


func test_clear_running_child_after_run() -> void:
	mock_action.final_result = BTNode.FAILURE
	
	# Testing of mock action to see that it allows repeater to run for
	# a few frames, returning 'RUNNING' until it returns final_result.
	for i in range(mock_action.running_frame_count):
		assert_that(behaviour_tree.tick()).is_equal(BTNode.RUNNING)
		assert_that(until_fail.running_child).is_equal(mock_action)
	assert_that(behaviour_tree.tick()).is_equal(BTNode.SUCCESS)
	
	# Test that running child was removed when no longer running.
	assert_that(until_fail.running_child).is_null()


func _on_action_started(actor: Node, blackboard: Blackboard) -> void:
	var started: int = blackboard.get_value("started", 0)
	blackboard.set_value("started", started + 1)


func _on_action_stopped(actor: Node, blackboard: Blackboard) -> void:
	var ended: int = blackboard.get_value("ended", 0)
	blackboard.set_value("ended", ended + 1)
