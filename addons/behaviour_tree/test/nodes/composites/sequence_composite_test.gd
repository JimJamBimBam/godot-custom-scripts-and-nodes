# GdUnit generated TestSuite
class_name SequenceCompositeTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/behaviour_tree/nodes/composites/sequence_composite.gd'
const __mock_action = "res://addons/behaviour_tree/test/nodes/actions/mock_action.gd"
const __behaviour_tree = "res://addons/behaviour_tree/nodes/behaviour_tree.gd"
const __blackboard = "res://addons/behaviour_tree/blackboard.gd"

var behaviour_tree: BehaviourTree
var sequence: SequenceComposite
var mock_action_1: MockAction
var mock_action_2: MockAction
var actor: Node
var blackboard: Blackboard

var blackboard_1_name: String
var blackboard_2_name: String


func before_test() -> void:	
	behaviour_tree = auto_free(load(__behaviour_tree).new())
	sequence = auto_free(load(__source).new())
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

	
	behaviour_tree.add_child(sequence)
	sequence.add_child(mock_action_1)
	sequence.add_child(mock_action_2)
	
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


## Test to make sure that all nodes that are going to return 'SUCCESS' are
## in fact, being run.
func test_always_executing_all_successful_nodes() -> void:
	mock_action_1.final_result = BTNode.SUCCESS
	mock_action_2.final_result = BTNode.SUCCESS
	assert_that(sequence.tick(actor, blackboard)).is_equal(BTNode.SUCCESS)
	assert_that(sequence.tick(actor, blackboard)).is_equal(BTNode.SUCCESS)
	var mock_action_1_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_1_name)
	var mock_action_2_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_2_name)
	assert_int(mock_action_1_times_ticked).is_equal(2)
	assert_int(mock_action_2_times_ticked).is_equal(2)


## Tests to make sure that a failure of a node halts the whole process.
func test_never_execute_second_when_first_fails() -> void:
	mock_action_1.final_result = BTNode.FAILURE
	assert_that(sequence.tick(actor, blackboard)).is_equal(BTNode.FAILURE)
	assert_that(sequence.tick(actor, blackboard)).is_equal(BTNode.FAILURE)
	var mock_action_1_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_1_name)
	var mock_action_2_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_2_name)
	assert_int(mock_action_1_times_ticked).is_equal(2)
	assert_int(mock_action_2_times_ticked).is_equal(0)


## This test is to make sure that previous nodes in the sequence are not
## called when a running node has to run again
## to possibly finish and return 'SUCCESS'.
func test_not_interrupt_second_when_first_is_failing() -> void:
	mock_action_1.final_result = BTNode.SUCCESS
	mock_action_2.final_result = BTNode.RUNNING
	assert_that(sequence.tick(actor, blackboard)).is_equal(BTNode.RUNNING)
	var mock_action_1_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_1_name)
	var mock_action_2_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_2_name)
	assert_int(mock_action_1_times_ticked).is_equal(1)
	assert_int(mock_action_2_times_ticked).is_equal(1)
	
	mock_action_1.final_result = BTNode.FAILURE
	assert_that(sequence.tick(actor, blackboard)).is_equal(BTNode.RUNNING)
	mock_action_1_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_1_name)
	mock_action_2_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_2_name)
	assert_int(mock_action_1_times_ticked).is_equal(1)
	assert_int(mock_action_2_times_ticked).is_equal(2)


## Much like the previous test, this test makes sure that changes in the first node
## are not going to be picked up when the second node is still returning 'RUNNING'.
func test_not_interrupting_second_when_first_is_running() -> void:
	mock_action_1.final_result = BTNode.SUCCESS
	mock_action_2.final_result = BTNode.RUNNING
	assert_that(sequence.tick(actor, blackboard)).is_equal(BTNode.RUNNING)
	var mock_action_1_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_1_name)
	var mock_action_2_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_2_name)
	assert_int(mock_action_1_times_ticked).is_equal(1)
	assert_int(mock_action_2_times_ticked).is_equal(1)
	
	mock_action_1.final_result = BTNode.RUNNING
	assert_that(sequence.tick(actor, blackboard)).is_equal(BTNode.RUNNING)
	mock_action_1_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_1_name)
	mock_action_2_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_2_name)
	assert_int(mock_action_1_times_ticked).is_equal(1)
	assert_int(mock_action_2_times_ticked).is_equal(2)


## Test to make sure that any child that returns 'FAILURE' will, in fact,
## restart the sequence and let previously ticked children tick again.
func test_restart_when_child_returns_failure() -> void:
	mock_action_1.final_result = BTNode.SUCCESS
	mock_action_2.final_result = BTNode.FAILURE
	assert_that(sequence.tick(actor, blackboard)).is_equal(BTNode.FAILURE)
	assert_that(sequence.tick(actor, blackboard)).is_equal(BTNode.FAILURE)
	var mock_action_1_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_1_name)
	var mock_action_2_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_2_name)
	assert_int(mock_action_1_times_ticked).is_equal(2)
	assert_int(mock_action_2_times_ticked).is_equal(2)


## Test to make sure that sequence continues from the child node that
## is returning 'RUNNING' on the next tick.
func test_tick_again_when_child_returns_running() -> void:
	mock_action_1.final_result = BTNode.SUCCESS
	mock_action_2.final_result = BTNode.RUNNING
	assert_that(sequence.tick(actor, blackboard)).is_equal(BTNode.RUNNING)
	assert_that(sequence.tick(actor, blackboard)).is_equal(BTNode.RUNNING)
	var mock_action_1_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_1_name)
	var mock_action_2_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_2_name)
	assert_int(mock_action_1_times_ticked).is_equal(1)
	assert_int(mock_action_2_times_ticked).is_equal(2)


## Test to make sure that the running child of the sequence node is being
## dereferenced after it has finished.
func test_clear_running_child_after_run() -> void:
	mock_action_1.final_result = BTNode.SUCCESS
	mock_action_2.final_result = BTNode.RUNNING
	behaviour_tree.tick()
	assert_that(sequence.running_child).is_equal(mock_action_2)
	
	mock_action_2.final_result = BTNode.SUCCESS
	behaviour_tree.tick()
	assert_that(sequence.running_child).is_null()


## Tests to make sure that if first node returns 'RUNNING' that subsequent
## nodes will not be called until the first one returns 'SUCCESS'.
func test_not_interrupt_first_after_finished() -> void:
	var mock_action_3 = auto_free(load(__mock_action).new())
	mock_action_3.ticked.connect(_on_action_ticked.bind(mock_action_3))
	var blackboard_3_name: String = "blackboard_%s" % str(mock_action_3.get_instance_id())
	sequence.add_child(mock_action_3)
	
	mock_action_1.final_result = BTNode.RUNNING
	mock_action_2.final_result = BTNode.SUCCESS
	mock_action_3.final_result = BTNode.RUNNING
	
	assert_that(sequence.tick(actor, blackboard)).is_equal(BTNode.RUNNING)
	var mock_action_1_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_1_name)
	var mock_action_2_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_2_name)
	var mock_action_3_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_3_name)
	assert_int(mock_action_1_times_ticked).is_equal(1)
	assert_int(mock_action_2_times_ticked).is_equal(0)
	assert_int(mock_action_3_times_ticked).is_equal(0)
	
	mock_action_1.final_result = BTNode.SUCCESS
	assert_that(sequence.tick(actor, blackboard)).is_equal(BTNode.RUNNING)
	mock_action_1_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_1_name)
	mock_action_2_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_2_name)
	mock_action_3_times_ticked = behaviour_tree.blackboard.get_value("ticked", 0, blackboard_3_name)
	assert_int(mock_action_1_times_ticked).is_equal(2)
	assert_int(mock_action_2_times_ticked).is_equal(1)
	assert_int(mock_action_3_times_ticked).is_equal(1)


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
