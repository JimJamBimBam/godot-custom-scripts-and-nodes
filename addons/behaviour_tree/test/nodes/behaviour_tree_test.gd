# GdUnit generated TestSuite
class_name BehaviourTreeTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/behaviour_tree/nodes/behaviour_tree.gd'
const __unit_test_empty_behaviour_tree_scene = "res://addons/behaviour_tree/test/scenes/unit_test_empty_behaviour_tree_scene.tscn"
const __unit_test_default_behaviour_tree_scene = "res://addons/behaviour_tree/test/scenes/unit_test_default_behaviour_tree_scene.tscn"

#func create_tree() -> BehaviourTree:
	#return auto_free(load(__source).new())


func create_empty_tree() -> UnitTestEmptyBehaviourTreeScene:
	return auto_free(load(__unit_test_empty_behaviour_tree_scene).instantiate())


func create_default_behaviour_tree() -> UnitTestDefaultBehaviourTreeScene:
	return auto_free(load(__unit_test_default_behaviour_tree_scene).instantiate())


## Code not fully implemented in base script.
func test_behaviour_tree_actor_is_not_null_on_creation() -> void:
	var empty_behaviour_tree_scene: UnitTestEmptyBehaviourTreeScene = create_empty_tree()
	scene_runner(empty_behaviour_tree_scene)
	assert_that(empty_behaviour_tree_scene.empty_behaviour_tree.actor).is_not_null()


func test_tick_when_child_count_is_zero_returns_failure() -> void:
	var empty_tree_scene: UnitTestEmptyBehaviourTreeScene = create_empty_tree()
	var scene_runner = scene_runner(empty_tree_scene)
	assert_int(empty_tree_scene.empty_behaviour_tree.get_child_count()).is_equal(0)
	empty_tree_scene.empty_behaviour_tree._physics_process(1.0)
	assert_that(empty_tree_scene.empty_behaviour_tree.status).is_equal(BTNode.FAILURE)


func test_normal_tick_rate() -> void:
	var default_behaviour_tree_scene: UnitTestDefaultBehaviourTreeScene = create_default_behaviour_tree()
	scene_runner(default_behaviour_tree_scene)
	default_behaviour_tree_scene.behaviour_tree._physics_process(1.0)
	assert_that(default_behaviour_tree_scene.behaviour_tree.status).is_equal(BTNode.SUCCESS)


func test_low_tick_rate() -> void:
	var default_behaviour_tree: UnitTestDefaultBehaviourTreeScene = create_default_behaviour_tree()
	scene_runner(default_behaviour_tree)
	default_behaviour_tree.behaviour_tree.tick_rate = 3
	default_behaviour_tree.behaviour_tree._physics_process(1.0)
	assert_that(default_behaviour_tree.behaviour_tree.status).is_equal(-1)
	default_behaviour_tree.behaviour_tree._physics_process(1.0)
	assert_that(default_behaviour_tree.behaviour_tree.status).is_equal(-1)
	default_behaviour_tree.behaviour_tree._physics_process(1.0)
	assert_that(default_behaviour_tree.behaviour_tree.status).is_equal(BTNode.SUCCESS)
