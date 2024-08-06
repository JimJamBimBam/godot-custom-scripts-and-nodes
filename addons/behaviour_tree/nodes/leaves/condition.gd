class_name ConditionLeaf extends Leaf

## Conditions are leaf nodes that either return a SUCCESS or FAILURE
## depending on a simple condition. They should never return "RUNNING".

# TODO: Implement get_class_name() method.
func get_class_name() -> Array[StringName]:
	var classes := super()
	classes.push_back(&"ConditionLeaf")
	return classes
