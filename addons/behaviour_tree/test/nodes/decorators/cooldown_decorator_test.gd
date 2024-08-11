# GdUnit generated TestSuite
class_name CooldownDecoratorTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/behaviour_tree/nodes/decorators/cooldown_decorator.gd'
const __mock_action = "res://addons/behaviour_tree/test/nodes/actions/mock_action.gd"
const __behaviour_tree = "res://addons/behaviour_tree/nodes/behaviour_tree.gd"
const __blackboard = "res://addons/behaviour_tree/blackboard.gd"

var behaviour_tree: BehaviourTree
var action: MockAction
var cooldown: CooldownDecorator
var runner: GdUnitSceneRunner


func before_test() -> void:
	behaviour_tree = auto_free(load(__behaviour_tree).new())
	action = auto_free(load(__mock_action).new())
	cooldown = auto_free(load(__source).new())
	
	var actor = auto_free(Node.new())
	var blackboard = auto_free(load(__blackboard).new())
	
	behaviour_tree.add_child(cooldown)
	cooldown.add_child(action)
	
	behaviour_tree.actor = actor
	behaviour_tree.blackboard = blackboard
	runner = scene_runner(behaviour_tree)


func test_return_failure_for_set_time_after_tick() -> void:
	cooldown.wait_time = 1.0
	action.final_result = BTNode.RUNNING
	assert_that(behaviour_tree.tick()).is_equal(BTNode.RUNNING)
	action.final_result = BTNode.SUCCESS
	assert_that(behaviour_tree.tick()).is_equal(BTNode.SUCCESS)
	action.final_result = BTNode.RUNNING
	assert_that(behaviour_tree.tick()).is_equal(BTNode.FAILURE)
	await runner.simulate_frames(1, 2000)
	assert_that(behaviour_tree.tick()).is_equal(BTNode.RUNNING)


func test_clear_running_child_after_run() -> void:
	action.final_result = BTNode.RUNNING
	behaviour_tree.tick()
	assert_that(cooldown.running_child).is_equal(action)
	action.final_result = BTNode.SUCCESS
	behaviour_tree.tick()
	assert_that(cooldown.running_child).is_null()
