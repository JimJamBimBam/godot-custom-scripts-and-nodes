# GdUnit generated TestSuite
class_name LimiterDecoratorTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/behaviour_tree/nodes/decorators/limiter_decorator.gd'
const __count_up_action = "res://addons/behaviour_tree/test/nodes/actions/count_up_action.gd"
const __behaviour_tree = "res://addons/behaviour_tree/nodes/behaviour_tree.gd"
const __blackboard = "res://addons/behaviour_tree/blackboard.gd"

var behaviour_tree: BehaviourTree
var count_up_action: CountUpAction
var limiter: LimiterDecorator
var actor: Node
var blackboard: Blackboard

func before_test() -> void:
	behaviour_tree = auto_free(load(__behaviour_tree).new())
	count_up_action = auto_free(load(__count_up_action).new())
	limiter = auto_free(load(__source).new())
	
	actor = auto_free(Node.new())
	blackboard = auto_free(load(__blackboard).new())
	
	behaviour_tree.add_child(limiter)
	limiter.add_child(count_up_action)
	
	behaviour_tree.actor = actor
	behaviour_tree.blackboard = blackboard


func test_return_failure_after_max_count_reached(count: int, test_parameters := [[3], [0]]) -> void:
	count_up_action.status = BTNode.RUNNING
	limiter.max_count = count
	
	for i in range(count):
		assert_that(behaviour_tree.tick()).is_equal(BTNode.RUNNING)
	
	assert_that(count_up_action.count).is_equal(count)
	assert_that(behaviour_tree.tick()).is_equal(BTNode.FAILURE)
	# Check to see that child is reset after is reached max count.
	assert_that(count_up_action.count).is_equal(0)


func test_interrupt_after_run() -> void:
	count_up_action.status = BTNode.RUNNING
	limiter.max_count = 1
	behaviour_tree.tick()
	assert_that(limiter.running_child).is_equal(count_up_action)
	#count_up_action.status = BTNode.FAILURE
	behaviour_tree.tick()
	assert_that(count_up_action.count).is_equal(0)
	assert_that(limiter.running_child).is_null()


func test_clear_running_child_after_run() -> void:
	count_up_action.status = BTNode.RUNNING
	limiter.max_count = 10
	behaviour_tree.tick()
	assert_that(limiter.running_child).is_equal(count_up_action)
	count_up_action.status = BTNode.FAILURE
	behaviour_tree.tick()
	assert_that(count_up_action.count).is_equal(2)
	assert_that(limiter.running_child).is_null()
