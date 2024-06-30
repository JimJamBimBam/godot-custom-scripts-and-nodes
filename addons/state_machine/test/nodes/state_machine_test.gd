# GdUnit generated TestSuite
class_name StateMachineTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const _state_machine_source = 'res://addons/state_machine/nodes/state_machine.gd'
const _state_source = 'res://addons/state_machine/nodes/state_machine.gd'

#TODO: Refactor tests to use a special "TestState" script that has no other function but to act as State without warnings being thrown.
var _test_state_machine: StateMachine
var _test_state_01: State
var _test_state_02: State


func before():
	_test_state_machine = StateMachine.new()
	_test_state_01 = State.new()
	_test_state_02 = State.new()


func after():
	_test_state_machine.free()
	_test_state_01.free()
	_test_state_02.free()


func test_set_state(input_state: State, current_state, expected: State, test_parameters := [
[_test_state_01, _test_state_02, _test_state_02],
[_test_state_01, _test_state_01, _test_state_01],
[null, _test_state_02, null],
[_test_state_01, null, _test_state_01]]) -> void:

	_test_state_machine._current_state = current_state
	_test_state_machine.set_state(input_state)
	assert_that(_test_state_machine._current_state).is_equal(expected)
