# GdUnit generated TestSuite
class_name StateMachineTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __state_machine_source = 'res://addons/state_machine/nodes/state_machine.gd'
const __state_source = 'res://addons/state_machine/nodes/state.gd'

#TODO: Refactor tests to use a special "TestState" script that has no other function but to act as State without warnings being thrown.
var _test_state_machine: StateMachine
var _transition_test: StateMachine.Transition
var _test_state_01: State
var _test_state_02: State
var _returns_true_callable: Callable
var _returns_false_callable: Callable
var _returns_int_callable: Callable


func before_test() -> void:
	_test_state_machine = load(__state_machine_source).new()
	_test_state_01 = load(__state_source).new()
	_test_state_02 = load(__state_source).new()
	_returns_true_callable = func(): return true
	_returns_false_callable = func(): return false
	_returns_int_callable = func(): return 1


func after_test() -> void:
	_test_state_machine.free()
	_test_state_01.free()
	_test_state_02.free()


func test_add_transition() -> void:
	_test_state_machine.add_transition(_test_state_01, _test_state_02, _returns_true_callable)
	assert_bool(_test_state_machine._transitions.has(_test_state_01._get_class()))


func test_add_any_transition() -> void:
	_test_state_machine.add_any_transition(_test_state_02, _returns_false_callable)
	assert_object(_test_state_machine._any_transitions[0]).is_not_null()


func test_tick() -> void:
	await assert_error(func(): _test_state_machine.tick()).is_success()


func test_set_state(input_state: State, current_state, expected: State, test_parameters := [
[_test_state_01, _test_state_02, _test_state_02],
[_test_state_01, _test_state_01, _test_state_01],
[null, _test_state_02, null],
[_test_state_01, null, _test_state_01]]) -> void:

	_test_state_machine._current_state = current_state
	_test_state_machine.set_state(input_state)
	assert_that(_test_state_machine._current_state).is_equal(expected)


func test_get_transition_with_current_transition() -> void:
	_test_state_machine.add_transition(_test_state_01, _test_state_02, _returns_true_callable)
	_test_state_machine.set_state(_test_state_01)
	assert_object(_test_state_machine.get_transition()).is_not_null()


func test_get_transition_with_any_transition() -> void:
	_test_state_machine.add_any_transition(_test_state_01, _returns_true_callable)
	_test_state_machine.set_state(_test_state_01)
	assert_object(_test_state_machine.get_transition()).is_not_null()
