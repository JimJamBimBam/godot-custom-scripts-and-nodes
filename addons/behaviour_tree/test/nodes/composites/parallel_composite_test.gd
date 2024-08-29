# GdUnit generated TestSuite
class_name ParallelCompositeTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/behaviour_tree/nodes/composites/parallel_composite.gd'
const __mock_action = "res://addons/behaviour_tree/test/nodes/actions/mock_action.gd"
const __behaviour_tree = "res://addons/behaviour_tree/nodes/behaviour_tree.gd"
const __blackboard = "res://addons/behaviour_tree/blackboard.gd"

var behaviour_tree: BehaviourTree
var simple_parallel: ParallelComposite
var mock_action_1: MockAction
var mock_action_2: MockAction
var actor: Node
var blackboard: Blackboard

var blackboard_1_name: String
var blackboard_2_name: String


func before_test() -> void:	
	behaviour_tree = auto_free(load(__behaviour_tree).new())
	simple_parallel = auto_free(load(__source).new())
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

	
	behaviour_tree.add_child(simple_parallel)
	simple_parallel.add_child(mock_action_1)
	simple_parallel.add_child(mock_action_2)
	
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


func test_always_return_first_node_result() -> void:
	mock_action_1.final_result = BTNode.SUCCESS
	mock_action_2.final_result = BTNode.FAILURE
	assert_that(simple_parallel.tick(actor, blackboard)).is_equal(BTNode.SUCCESS)
	
	var mock_action_1_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_1_name)
	var mock_action_2_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_2_name)
	assert_int(mock_action_1_times_ticked).is_equal(1)
	assert_int(mock_action_2_times_ticked).is_equal(0)
	
	mock_action_1.final_result = BTNode.FAILURE
	mock_action_2.final_result = BTNode.SUCCESS
	assert_that(simple_parallel.tick(actor, blackboard)).is_equal(BTNode.FAILURE)
	mock_action_1_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_1_name)
	mock_action_2_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_2_name)
	assert_int(mock_action_1_times_ticked).is_equal(2)
	assert_int(mock_action_2_times_ticked).is_equal(0)


func test_interrupt_second_when_first_is_succeeding() -> void:
	mock_action_1.final_result = BTNode.RUNNING
	mock_action_2.final_result = BTNode.RUNNING
	assert_that(simple_parallel.tick(actor, blackboard)).is_equal(BTNode.RUNNING)
	var mock_action_1_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_1_name)
	var mock_action_2_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_2_name)
	assert_int(mock_action_1_times_ticked).is_equal(1)
	assert_int(mock_action_2_times_ticked).is_equal(1)
	
	mock_action_1.final_result = BTNode.SUCCESS
	assert_that(simple_parallel.tick(actor, blackboard)).is_equal(BTNode.SUCCESS)
	mock_action_1_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_1_name)
	mock_action_2_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_2_name)
	assert_int(mock_action_1_times_ticked).is_equal(2)
	assert_int(mock_action_2_times_ticked).is_equal(1)


func test_interrupt_second_when_first_is_failing() -> void:
	mock_action_1.final_result = BTNode.RUNNING
	mock_action_2.final_result = BTNode.RUNNING
	assert_that(simple_parallel.tick(actor, blackboard)).is_equal(BTNode.RUNNING)
	var mock_action_1_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_1_name)
	var mock_action_2_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_2_name)
	assert_int(mock_action_1_times_ticked).is_equal(1)
	assert_int(mock_action_2_times_ticked).is_equal(1)
	
	mock_action_1.final_result = BTNode.FAILURE
	assert_that(simple_parallel.tick(actor, blackboard)).is_equal(BTNode.FAILURE)
	mock_action_1_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_1_name)
	mock_action_2_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_2_name)
	assert_int(mock_action_1_times_ticked).is_equal(2)
	assert_int(mock_action_2_times_ticked).is_equal(1)


func test_continue_tick_when_child_returns_failing() -> void:
	mock_action_1.final_result = BTNode.RUNNING
	mock_action_2.final_result = BTNode.FAILURE
	assert_that(simple_parallel.tick(actor, blackboard)).is_equal(BTNode.RUNNING)
	var mock_action_1_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_1_name)
	var mock_action_2_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_2_name)
	assert_int(mock_action_1_times_ticked).is_equal(1)
	assert_int(mock_action_2_times_ticked).is_equal(1)
	
	assert_that(simple_parallel.tick(actor, blackboard)).is_equal(BTNode.RUNNING)
	mock_action_1_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_1_name)
	mock_action_2_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_2_name)
	assert_int(mock_action_1_times_ticked).is_equal(2)
	assert_int(mock_action_2_times_ticked).is_equal(2)


func test_child_continue_tick_in_delay_mode() -> void:
	simple_parallel.delay_mode = true
	mock_action_1.final_result = BTNode.RUNNING
	mock_action_2.final_result = BTNode.RUNNING
	
	assert_that(simple_parallel.tick(actor, blackboard)).is_equal(BTNode.RUNNING)
	var mock_action_1_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_1_name)
	var mock_action_2_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_2_name)
	assert_int(mock_action_1_times_ticked).is_equal(1)
	assert_int(mock_action_2_times_ticked).is_equal(1)
	
	mock_action_1.final_result = BTNode.SUCCESS
	assert_that(simple_parallel.tick(actor, blackboard)).is_equal(BTNode.RUNNING)
	mock_action_1_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_1_name)
	mock_action_2_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_2_name)
	assert_int(mock_action_1_times_ticked).is_equal(2)
	assert_int(mock_action_2_times_ticked).is_equal(2)
	
	mock_action_2.final_result = BTNode.FAILURE
	assert_that(simple_parallel.tick(actor, blackboard)).is_equal(BTNode.SUCCESS)
	mock_action_1_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_1_name)
	mock_action_2_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_2_name)
	assert_int(mock_action_1_times_ticked).is_equal(2)
	assert_int(mock_action_2_times_ticked).is_equal(3)


func test_child_tick_count() -> void:
	simple_parallel.secondary_node_repeat_count = 2
	mock_action_1.final_result = BTNode.RUNNING
	mock_action_2.final_result = BTNode.FAILURE
	
	assert_that(behaviour_tree.tick()).is_equal(BTNode.RUNNING)
	var mock_action_1_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_1_name)
	var mock_action_2_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_2_name)
	assert_int(mock_action_1_times_ticked).is_equal(1)
	assert_int(mock_action_2_times_ticked).is_equal(1)
	assert_int(simple_parallel.secondary_node_repeat_left).is_equal(1)
	
	mock_action_2.final_result = BTNode.RUNNING
	assert_that(behaviour_tree.tick()).is_equal(BTNode.RUNNING)
	mock_action_1_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_1_name)
	mock_action_2_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_2_name)
	assert_int(mock_action_1_times_ticked).is_equal(2)
	assert_int(mock_action_2_times_ticked).is_equal(2)
	assert_int(simple_parallel.secondary_node_repeat_left).is_equal(1)
	
	mock_action_2.final_result = BTNode.SUCCESS
	assert_that(behaviour_tree.tick()).is_equal(BTNode.RUNNING)
	mock_action_1_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_1_name)
	mock_action_2_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_2_name)
	assert_int(mock_action_1_times_ticked).is_equal(3)
	assert_int(mock_action_2_times_ticked).is_equal(3)
	assert_int(simple_parallel.secondary_node_repeat_left).is_equal(0)
	
	assert_that(behaviour_tree.tick()).is_equal(BTNode.RUNNING)
	mock_action_1_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_1_name)
	mock_action_2_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_2_name)
	assert_int(mock_action_1_times_ticked).is_equal(4)
	assert_int(mock_action_2_times_ticked).is_equal(3)


func test_nested_simple_parallel() -> void:
	var simple_parallel_2 = auto_free(load(__source).new())
	var mock_action_3 = auto_free(load(__mock_action).new())
	# Connect mock_action_3 signals
	mock_action_3.ticked.connect(_on_action_ticked.bind(mock_action_3))
	var blackboard_3_name: String = "blackboard_%s" % str(mock_action_3.get_instance_id())
	simple_parallel.remove_child(mock_action_2)
	simple_parallel.add_child(simple_parallel_2)
	simple_parallel_2.add_child(mock_action_2)
	simple_parallel_2.add_child(mock_action_3)

	mock_action_1.final_result = BTNode.RUNNING
	mock_action_2.final_result = BTNode.RUNNING
	mock_action_3.final_result = BTNode.RUNNING

	assert_that(simple_parallel.tick(actor, blackboard)).is_equal(BTNode.RUNNING)
	var mock_action_1_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_1_name)
	var mock_action_2_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_2_name)
	var mock_action_3_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_3_name)
	assert_int(mock_action_1_times_ticked).is_equal(1)
	assert_int(mock_action_2_times_ticked).is_equal(1)
	assert_int(mock_action_3_times_ticked).is_equal(1)

	mock_action_2.final_result = BTNode.SUCCESS
	assert_that(simple_parallel.tick(actor, blackboard)).is_equal(BTNode.RUNNING)
	mock_action_1_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_1_name)
	mock_action_2_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_2_name)
	mock_action_3_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_3_name)
	assert_int(mock_action_1_times_ticked).is_equal(2)
	assert_int(mock_action_2_times_ticked).is_equal(2)
	assert_int(mock_action_3_times_ticked).is_equal(1)

	mock_action_3.final_result = BTNode.RUNNING
	assert_that(simple_parallel.tick(actor, blackboard)).is_equal(BTNode.RUNNING)
	mock_action_1_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_1_name)
	mock_action_2_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_2_name)
	mock_action_3_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_3_name)
	assert_int(mock_action_1_times_ticked).is_equal(3)
	assert_int(mock_action_2_times_ticked).is_equal(3)
	assert_int(mock_action_3_times_ticked).is_equal(1)
	
	mock_action_2.final_result = BTNode.RUNNING
	mock_action_3.final_result = BTNode.RUNNING
	assert_that(simple_parallel.tick(actor, blackboard)).is_equal(BTNode.RUNNING)
	mock_action_1_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_1_name)
	mock_action_2_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_2_name)
	mock_action_3_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_3_name)
	assert_int(mock_action_1_times_ticked).is_equal(4)
	assert_int(mock_action_2_times_ticked).is_equal(4)
	assert_int(mock_action_3_times_ticked).is_equal(2)
	
	mock_action_1.final_result = BTNode.SUCCESS
	assert_that(simple_parallel.tick(actor, blackboard)).is_equal(BTNode.SUCCESS)
	mock_action_1_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_1_name)
	mock_action_2_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_2_name)
	mock_action_3_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_3_name)
	assert_int(mock_action_1_times_ticked).is_equal(5)
	assert_int(mock_action_2_times_ticked).is_equal(4)
	assert_int(mock_action_3_times_ticked).is_equal(2)

	# Cleanup
	simple_parallel_2.remove_child(mock_action_2)
	simple_parallel_2.remove_child(mock_action_3)
	simple_parallel.remove_child(simple_parallel_2)
	simple_parallel.add_child(mock_action_2)


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
