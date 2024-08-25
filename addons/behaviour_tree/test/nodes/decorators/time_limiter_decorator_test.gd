# GdUnit generated TestSuite
class_name TimeLimiterDecoratorTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/behaviour_tree/nodes/decorators/time_limiter_decorator.gd'
const __mock_action = "res://addons/behaviour_tree/test/nodes/actions/mock_action.gd"
const __behaviour_tree = "res://addons/behaviour_tree/nodes/behaviour_tree.gd"
const __blackboard = "res://addons/behaviour_tree/blackboard.gd"

var behaviour_tree: BehaviourTree
var mock_action: MockAction
var time_limiter: TimeLimiterDecorator
var actor: Node2D
var blackboard: Blackboard
var runner: GdUnitSceneRunner

# TODO: Refactor tests so that time is not so unpredictable when performing the tests.

func before_test() -> void:
	behaviour_tree = auto_free(load(__behaviour_tree).new())
	actor = auto_free(Node2D.new())
	blackboard = auto_free(load(__blackboard).new())

	behaviour_tree.actor = actor
	behaviour_tree.blackboard = blackboard
	mock_action = auto_free(load(__mock_action).new())
	time_limiter = auto_free(load(__source).new())

	# mock action setup
	mock_action.started_running.connect(_on_action_started)
	mock_action.stopped_running.connect(_on_action_stopped)
	mock_action.interrupted.connect(_on_action_interrupted)

	time_limiter.add_child(mock_action)
	behaviour_tree.add_child(time_limiter)

	runner = scene_runner(behaviour_tree)


func after_test() -> void:
	# resets blackboard
	behaviour_tree.blackboard.set_value("started", 0)
	behaviour_tree.blackboard.set_value("ended", 0)
	behaviour_tree.blackboard.set_value("interrupted", 0)


func test_interrupted() -> void:
	time_limiter.wait_time = 1.0
	mock_action.final_result = BTNode.RUNNING
	
	behaviour_tree.tick()
	
	# Makes sure that the behaviour tree started properly.
	var times_started: int = behaviour_tree.blackboard.get_value("started", 0)
	var times_ended: int = behaviour_tree.blackboard.get_value("ended", 0)
	var times_interrupted: int = behaviour_tree.blackboard.get_value("interrupted", 0)
	assert_int(times_started).is_equal(1)
	assert_int(times_ended).is_equal(0)
	assert_int(times_interrupted).is_equal(0)
	
	await runner.simulate_frames(1, 1000)
	
	# Make sure that the behaviour tree ran as expected after being simulated for
	# some time.
	times_started = behaviour_tree.blackboard.get_value("started", 0)
	times_ended = behaviour_tree.blackboard.get_value("ended", 0)
	times_interrupted = behaviour_tree.blackboard.get_value("interrupted", 0)
	assert_int(times_started).is_equal(2)
	assert_int(times_ended).is_equal(1)
	assert_int(times_interrupted).is_equal(1)


func test_reset_when_child_finishes() -> void:
	time_limiter.wait_time = 0.5
	mock_action.final_result = BTNode.RUNNING
	behaviour_tree.tick()
	
	# Makes sure that the behaviour tree started properly.
	var times_started: int = behaviour_tree.blackboard.get_value("started", 0)
	var times_ended: int = behaviour_tree.blackboard.get_value("ended", 0)
	var times_interrupted: int = behaviour_tree.blackboard.get_value("interrupted", 0)
	assert_int(times_started).is_equal(1)
	assert_int(times_ended).is_equal(0)
	assert_int(times_interrupted).is_equal(0)
	
	assert_that(behaviour_tree.tick()).is_equal(BTNode.RUNNING)
	await runner.simulate_frames(2, 500)
	mock_action.final_result = BTNode.SUCCESS
	assert_that(behaviour_tree.tick()).is_equal(BTNode.SUCCESS)


func test_clear_running_child_after_run() -> void:
	time_limiter.wait_time = 1.5
	mock_action.final_result = BTNode.RUNNING
	behaviour_tree.tick()
	assert_that(time_limiter.running_child).is_equal(mock_action)
	mock_action.final_result = BTNode.SUCCESS
	await runner.simulate_frames(1, 1600)
	assert_that(time_limiter.running_child).is_null()


func _on_action_started(actor: Node, blackboard: Blackboard) -> void:
	var started: int = blackboard.get_value("started", 0)
	blackboard.set_value("started", started + 1)


func _on_action_stopped(actor: Node, blackboard: Blackboard) -> void:
	var ended: int = blackboard.get_value("ended", 0)
	blackboard.set_value("ended", ended + 1)


func _on_action_interrupted(actor: Node, blackboard: Blackboard) -> void:
	var interrupted: int = blackboard.get_value("interrupted", 0)
	blackboard.set_value("interrupted", interrupted + 1)
