# GdUnit generated TestSuite
class_name TimeLimiterDecoratorTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/behaviour_tree/nodes/decorators/time_limiter_decorator.gd'
const __mock_action = "res://addons/behaviour_tree/test/nodes/actions/count_up_action.gd"
const __behaviour_tree = "res://addons/behaviour_tree/nodes/behaviour_tree.gd"
const __blackboard = "res://addons/behaviour_tree/blackboard.gd"

var tree: BehaviourTree
var count_up_action: CountUpAction
var time_limiter: TimeLimiterDecorator
var actor: Node2D
var blackboard: Blackboard
var runner: GdUnitSceneRunner


func before_test() -> void:
	tree = auto_free(load(__behaviour_tree).new())
	actor = auto_free(Node2D.new())
	blackboard = auto_free(load(__blackboard).new())

	tree.actor = actor
	tree.blackboard = blackboard
	count_up_action = auto_free(load(__mock_action).new())
	time_limiter = auto_free(load(__source).new())

	time_limiter.add_child(count_up_action)
	tree.add_child(time_limiter)

	runner = scene_runner(tree)


func test_return_failure_when_child_exceeds_time_limiter() -> void:
	time_limiter.wait_time = 1.0
	count_up_action.status = BTNode.RUNNING
	tree.tick()
	assert_that(tree.tick()).is_equal(BTNode.RUNNING)
	await runner.simulate_frames(1, 1500)
	assert_that(tree.tick()).is_equal(BTNode.FAILURE)


func test_reset_when_child_finishes() -> void:
	time_limiter.wait_time = 0.5
	count_up_action.status = BTNode.RUNNING
	tree.tick()
	assert_that(tree.tick()).is_equal(BTNode.RUNNING)
	await runner.simulate_frames(2, 500)
	count_up_action.status = BTNode.SUCCESS
	assert_that(tree.tick()).is_equal(BTNode.SUCCESS)


func test_clear_running_child_after_run() -> void:
	time_limiter.wait_time = 1.5
	count_up_action.status = BTNode.RUNNING
	tree.tick()
	assert_that(time_limiter.running_child).is_equal(count_up_action)
	count_up_action.status = BTNode.SUCCESS
	await runner.simulate_frames(1, 1600)
	assert_that(time_limiter.running_child).is_null()
