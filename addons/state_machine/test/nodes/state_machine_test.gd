# GdUnit generated TestSuite
class_name StateMachineTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __state_machine_source = 'res://addons/state_machine/nodes/state_machine.gd'
const __mock_state_source = "res://addons/state_machine/test/nodes/mock_state.gd"

var _test_state_machine: StateMachine
var _transition_test: StateMachine.Transition
var _test_state_01: MockState
var _test_state_02: MockState
var _returns_true_callable: Callable
var _returns_false_callable: Callable
var _returns_int_callable: Callable


func before_test() -> void:
	_test_state_machine = load(__state_machine_source).new()
	_test_state_01 = load(__mock_state_source).new()
	_test_state_02 = load(__mock_state_source).new()
	_returns_true_callable = func(): return true
	_returns_false_callable = func(): return false
	_returns_int_callable = func(): return 1


func after_test() -> void:
	_test_state_machine.free()
	_test_state_01.free()
	_test_state_02.free()


func test_add_transition() -> void:
	_test_state_machine.add_transition(_test_state_01, _test_state_02, _returns_true_callable)
	assert_bool(_test_state_machine.transitions.has(_test_state_01._get_class()))


func test_add_any_transition() -> void:
	_test_state_machine.add_any_transition(_test_state_02, _returns_false_callable)
	assert_object(_test_state_machine.any_transitions[0]).is_not_null()


func test_tick() -> void:
	await assert_error(func(): _test_state_machine.tick()).is_success()


func test_set_state(input_state: State, expected: State, test_parameters := [
[_test_state_01, _test_state_01],
[null, null]]) -> void:
	_test_state_machine.set_state(input_state)
	assert_that(_test_state_machine.current_state).is_equal(expected)


func test_set_state_calls_on_exit_method() -> void:
	# First test: Does it ignore on_exit() when current state is null.
	_test_state_machine.set_state(_test_state_01)
	assert_bool(_test_state_01.on_exit_called).is_false()
	# Second test: Does it now call on_exit() when current state is not null.
	_test_state_machine.set_state(_test_state_02)
	assert_bool(_test_state_01.on_exit_called).is_true()


#func test_get_transition_with_current_transition() -> void:
	#_test_state_machine.add_transition(_test_state_01, _test_state_02, _returns_true_callable)
	#_test_state_machine.set_state(_test_state_01)
	#assert_object(_test_state_machine._get_transition()).is_not_null()
#
#
#func test_get_transition_with_any_transition() -> void:
	#_test_state_machine.add_any_transition(_test_state_01, _returns_true_callable)
	#_test_state_machine.set_state(_test_state_01)
	#assert_object(_test_state_machine._get_transition()).is_not_null()
