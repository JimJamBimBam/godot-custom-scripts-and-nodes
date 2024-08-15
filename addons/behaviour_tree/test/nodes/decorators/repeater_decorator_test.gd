# GdUnit generated TestSuite
class_name RepeaterDecoratorTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/behaviour_tree/test/nodes/decorators/repeater_decorator.gd'
const __mock_action = "res://addons/behaviour_tree/test/nodes/actions/mock_action.gd"
const __behaviour_tree = "res://addons/behaviour_tree/nodes/behaviour_tree.gd"
const __blackboard = "res://addons/behaviour_tree/blackboard.gd"

var behaviour_tree: BehaviourTree
var mock_action: MockAction
var repeater: RepeaterDecorator


func before_test() -> void:
	behaviour_tree = auto_free(load(__behaviour_tree).new())
	mock_action = auto_free(load(__mock_action).new())
	repeater = auto_free(load(__source).new())
	
	# action setup
	mock_action.running_frame_count = 3
	mock_action.started_running.connect(_on_action_started)
	mock_action.stopped_running.connect(_on_action_stopped)
	
	var actor = auto_free(Node.new())
	var blackboard = auto_free(load(__blackboard).new())
	
	behaviour_tree.add_child(repeater)
	repeater.add_child(mock_action)
	
	behaviour_tree.actor = actor
	behaviour_tree.blackboard = blackboard


func after_test() -> void:
	# resets blackboard
	behaviour_tree.blackboard.set_value("started", 0)
	behaviour_tree.blackboard.set_value("ended", 0)


func test_repetitions(count: int, test_parameters := [[0], [2]]) -> void:
	mock_action.final_result = BTNode.SUCCESS
	repeater.repetitions = count
	
	var frames_to_run: int = count * (mock_action.running_frame_count + 1)
	
	# it should return 'RUNNING' for every frame but the last one.
	for i in range(frames_to_run - 1):
		assert_that(behaviour_tree.tick()).is_equal(BTNode.RUNNING)
	assert_that(behaviour_tree.tick()).is_equal(BTNode.SUCCESS)
	
	# Test to see if mock action started and stopped the expected number of times,
	# which in this case, is the count given at the start.
	var times_started = behaviour_tree.blackboard.get_value("started", 0)
	var times_ended = behaviour_tree.blackboard.get_value("ended", 0)
	assert_int(times_started).is_equal(count)
	assert_int(times_ended).is_equal(count)


func test_failure() -> void:
	repeater.repetitions = 2
	mock_action.final_result = BTNode.SUCCESS
	
	# Testing of repeater node still returning 'RUNNING' since
	# one 'SUCCESS' is not enough to trigger repeater just yet.
	for i in range(mock_action.running_frame_count + 1):
		assert_that(behaviour_tree.tick()).is_equal(BTNode.RUNNING)
	
	# It should have started and ended normally.
	var times_started: int = behaviour_tree.blackboard.get_value("started", 0)
	var times_ended: int = behaviour_tree.blackboard.get_value("ended", 0)
	assert_int(times_started).is_equal(1)
	assert_int(times_ended).is_equal(1)
	
	mock_action.final_result = BTNode.FAILURE
	
	# Testing of repeater node should now return 'FALIURE' here
	# since the mock action has returned FAILURE only after it has run through its cycle.
	for i in range(mock_action.running_frame_count):
		assert_that(behaviour_tree.tick()).is_equal(BTNode.RUNNING)
	assert_that(behaviour_tree.tick()).is_equal(BTNode.FAILURE)
	
	# Test here to make sure the total number of times the mock action started and stopped
	# (their before_run and after_run methods were called) is equal to the number of
	# times they were expected to be called, in this case two (2).
	times_started = behaviour_tree.blackboard.get_value("started", 0)
	times_ended = behaviour_tree.blackboard.get_value("ended", 0)
	assert_int(times_started).is_equal(2)
	assert_int(times_ended).is_equal(2)


func test_clear_running_child_after_run() -> void:
	repeater.repetitions = 1
	mock_action.final_result = BTNode.SUCCESS
	
	# Testing of mock action to see that it allows repeater to run for
	# a few frames, returning 'RUNNING' until it returns 'SUCCESS'.
	for i in range(mock_action.running_frame_count):
		assert_that(behaviour_tree.tick()).is_equal(BTNode.RUNNING)
	assert_that(behaviour_tree.tick()).is_equal(BTNode.SUCCESS)
	
	# Test that running child was removed when no longer running.
	assert_that(repeater.running_child).is_null()


func _on_action_started(actor: Node, blackboard: Blackboard) -> void:
	var started: int = blackboard.get_value("started", 0)
	blackboard.set_value("started", started + 1)


func _on_action_stopped(actor: Node, blackboard: Blackboard) -> void:
	var ended: int = blackboard.get_value("ended", 0)
	blackboard.set_value("ended", ended + 1)
