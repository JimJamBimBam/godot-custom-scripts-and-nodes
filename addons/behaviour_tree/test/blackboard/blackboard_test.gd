# GdUnit generated TestSuite
class_name BlackboardTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/behaviour_tree/blackboard.gd'


func test_set_value() -> void:
	var blackboard: Blackboard = auto_free(load(__source).new()) as Blackboard
	blackboard.set_value("my_key", 123)
	assert_that(blackboard.get_value("my_key")).is_equal(123)


func test_get_default() -> void:
	var blackboard: Blackboard = auto_free(load(__source).new()) as Blackboard
	blackboard.set_value("my_key", 123)
	assert_that(blackboard.get_value("my_key2", 234)).is_equal(234)


func test_has_value() -> void:
	var blackboard: Blackboard = auto_free(load(__source).new()) as Blackboard
	blackboard.set_value("my_key", 123)
	assert_bool(blackboard.has_value("my_key")).is_true()
	assert_bool(blackboard.has_value("my_key2")).is_false()


func test_erase_value() -> void:
	var blackboard: Blackboard = auto_free(load(__source).new()) as Blackboard
	blackboard.set_value("my_key", 123)
	blackboard.erase_value("my_key")
	assert_bool(blackboard.has_value("my_key")).is_false()


func test_seperate_blackboard_erase_value() -> void:
	var blackboard: Blackboard = auto_free(load(__source).new()) as Blackboard
	blackboard.set_value("my_key", 123, "other_blackboard")
	blackboard.erase_value("my_key", "other_blackboard")
	assert_bool(blackboard.has_value("my_key", "other_blackboard")).is_false()


func test_seperate_blackboard_id_value() -> void:
	var blackboard: Blackboard = auto_free(load(__source).new()) as Blackboard
	blackboard.set_value("my_key", 123)
	blackboard.set_value("my_key", 456, "other_blackboard")
	assert_that(blackboard.get_value("my_key")).is_equal(123)
	assert_that(blackboard.get_value("my_key", null, "other_blackboard")).is_equal(456)


func test_blackboard_shared_between_trees() -> void:
	assert_not_yet_implemented()


func test_blackboard_property_shared_between_trees() -> void:
	assert_not_yet_implemented()
