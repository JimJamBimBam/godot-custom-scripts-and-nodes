# GdUnit generated TestSuite
class_name DelayDecoratorTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/behaviour_tree/nodes/decorators/delay_decorator.gd'
const __mock_action = "res://addons/behaviour_tree/test/nodes/actions/mock_action.gd"
const __behaviour_tree = "res://addons/behaviour_tree/nodes/behaviour_tree.gd"
const __blackboard = "res://addons/behaviour_tree/blackboard.gd"

var behaviour_tree: BehaviourTree
var action: MockAction
var delayer: DelayDecorator
var runner: GdUnitSceneRunner


func before_test() -> void:
	behaviour_tree = auto_free(load(__behaviour_tree).new())
	action = auto_free(load(__mock_action).new())
	delayer = auto_free(load(__source).new())
	
	var actor = auto_free(Node.new())
	var blackboard = auto_free(load(__blackboard).new())
	
	behaviour_tree.add_child(delayer)
	delayer.add_child(action)
	
	behaviour_tree.actor = actor
	behaviour_tree.blackboard = blackboard
	runner = scene_runner(behaviour_tree)


func test_return_success_after_set_time() -> void:
	delayer.wait_time = get_physics_process_delta_time()
	action.final_result = BTNode.SUCCESS
	assert_that(behaviour_tree.tick()).is_equal(BTNode.RUNNING)
	assert_that(behaviour_tree.tick()).is_equal(BTNode.SUCCESS)
	# Run one more time to test that it resets.
	assert_that(behaviour_tree.tick()).is_equal(BTNode.RUNNING)
	assert_that(behaviour_tree.tick()).is_equal(BTNode.SUCCESS)


func test_return_running_after_delay() -> void:
	delayer.wait_time = 1.0
	action.final_result = BTNode.RUNNING
	assert_that(behaviour_tree.tick()).is_equal(BTNode.RUNNING)
	await runner.simulate_frames(1, 1000)
	assert_that(behaviour_tree.tick()).is_equal(BTNode.RUNNING)
	action.final_result = BTNode.SUCCESS
	assert_that(behaviour_tree.tick()).is_equal(BTNode.SUCCESS)
	# Assure that the delayer properly resets
	action.final_result = BTNode.RUNNING
	assert_that(behaviour_tree.tick()).is_equal(BTNode.RUNNING)
	await runner.simulate_frames(1, 1000)
	assert_that(behaviour_tree.tick()).is_equal(BTNode.RUNNING)
	action.final_result = BTNode.SUCCESS
	assert_that(behaviour_tree.tick()).is_equal(BTNode.SUCCESS)


func test_clear_running_child_after_run() -> void:
	action.final_result = BTNode.RUNNING
	behaviour_tree.tick()
	assert_that(delayer.running_child).is_equal(action)
	action.final_result = BTNode.SUCCESS
	behaviour_tree.tick()
	assert_that(delayer.running_child).is_null()
