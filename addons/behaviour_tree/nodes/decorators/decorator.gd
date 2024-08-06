class_name Decorator extends BTNode

## Decorator nodes are used to transform the result received by its child.
## Must only have one child.

## TODO: Put any configuration warnings here, such as:
## - Decorators only having one child.

func interrupt(actor: Node, blackboard: Blackboard) -> void:
	pass


func after_run(actor: Node, blackboard: Blackboard) -> void:
	pass


# TODO: Implement get_class_name() method.
func get_class_name() -> Array[StringName]:
	var classes := super()
	classes.push_back(&"Decorator")
	return classes
