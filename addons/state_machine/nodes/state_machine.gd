class_name StateMachine extends Node

const CALLABLE_RETURN_TYPE_NOT_BOOL_ERROR: String = "ERROR: predicate must be a Callable that returns a boolean value. No exceptions."

var _current_state: State

## Collection of all the transitions in the state machine.
## Tansitions are organised by the state they can go to.
## Dictionary must have key = String and value = Array[Transition] to function properly.
var _transitions: Dictionary = {}
## An array of all the available transitions in the state machine that link from the current state
## to any other number of states.
var _current_transitions: Array[Transition] = []
## An array of all transitions that don't need to be in a particular state to transition.
var _any_transitions: Array[Transition] = []
## Default array with no transitions. Not for 
static var _empty_transitions: Array[Transition] = []

func _process(delta: float) -> void:
	tick()


## Process function for the state machine.
## The current state is processed here and
## if the state machine needs to, it will transition to other states and
## set the current state to the new state here as well.
func tick() -> void:
	var transition = get_transition()
	if transition != null:
		set_state(transition.to)
		
	if _current_state != null:
		_current_state._tick()


## Goes through the process of changing the current state to a new state.[br]
## Calls 'on exit' function of the old state before changing to the new state.
## 'on enter' function is also called.
func set_state(state: State) -> void:
	if state == _current_state:
		return
	
	if _current_state != null:
		_current_state._on_exit()
	
	_current_state = state
	
	if _current_state != null:
		_current_transitions = _transitions.get(_current_state._get_class(), _empty_transitions)
		_current_state._on_enter()


## Adds a new transition to the state machine that links a 'from' state to a 'to' state.
## A Callable that returns a boolean value is required.
## Callable return types can't be picked up in the editor
## but an error will be called should Callable.call() not return a boolean.
func add_transition(from: State, to: State, predicate: Callable) -> void:
	assert(predicate.call() is bool, CALLABLE_RETURN_TYPE_NOT_BOOL_ERROR)
	
	# Add a new Array of type Transition if the 'from' state has not been added before.
	if !_transitions.has(from._get_class()):
		var transitions: Array[Transition] = []
		_transitions[from._get_class()] = transitions
	
	_transitions[from._get_class()].append(Transition.new(to, predicate))


## Adds a new transition that can move to a state from any other state.
## As with 'add_transition', Callable that does not return a bool will cause an error to occur.
func add_any_transition(state: State, predicate: Callable) -> void:
	assert(predicate.call() is bool, CALLABLE_RETURN_TYPE_NOT_BOOL_ERROR)
	
	_any_transitions.append(Transition.new(state, predicate))


## Internal class for state machine that holds a condition needed to transition and
## the state to move to.
## New instances of Transition must have a State instance to transition to and
## a condition to be able to move.
## An error will occur if the condition is not a Callable with a return type of bool.
class Transition:
	var condition: Callable:
		get:
			return condition
	var to: State:
		get:
			return to
	
	func _init(init_to, init_condition) -> void:
		assert(init_condition.call() is bool, "condition in %s does not return a boolean value. Please make sure all Callables return a boolean value." % self)
		
		condition = init_condition
		to = init_to


## Returns the first Transition that meets the boolean condition.
## Transitions that can go from any state are searched first
## before transitions that need to be in a certain state before they can move to the new state.
func get_transition() -> Transition:
	for transition in _any_transitions:
		if transition.condition.call():
			return transition
	
	for transition in _current_transitions:
		if transition.condition.call():
			return transition
	
	return null
