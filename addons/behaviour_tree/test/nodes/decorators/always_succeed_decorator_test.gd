# GdUnit generated TestSuite
class_name AlwaysSucceedDecoratorTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/behaviour_tree/nodes/decorators/always_succeed_decorator.gd'
const __mock_action = "res://addons/behaviour_tree/test/nodes/actions/mock_action.gd"
const __behaviour_tree = "res://addons/behaviour_tree/nodes/behaviour_tree.gd"
const __blackboard = "res://addons/behaviour_tree/blackboard.gd"

var behaviour_tree: BehaviourTree
var action: MockAction
var succeeder: AlwaysSucceedDecorator

func before_test() -> void:
	behaviour_tree = auto_free(load(__behaviour_tree).new())
	action = auto_free(load(__mock_action).new())
	succeeder = auto_free(load(__source).new())
	
	var actor = auto_free(Node.new())
	var blackboard = auto_free(load(__blackboard).new())
	
	behaviour_tree.add_child(succeeder)
	succeeder.add_child(action)
	
	behaviour_tree.actor = actor
	behaviour_tree.blackboard = blackboard


func test_success_returns_sucess() -> void:
	action.final_result = BTNode.SUCCESS
	assert_that(behaviour_tree.tick()).is_equal(BTNode.SUCCESS)


func test_failure_returns_success() -> void:
	action.final_result = BTNode.FAILURE
	assert_that(behaviour_tree.tick()).is_equal(BTNode.SUCCESS)


func test_clear_running_child_after_run() -> void:
	action.final_result = BTNode.RUNNING
	behaviour_tree.tick()
	assert_that(succeeder.running_child).is_equal(action)
	action.final_result = BTNode.SUCCESS
	behaviour_tree.tick()
	assert_that(succeeder.running_child).is_null()
