class_name ActionLeaf extends Leaf

## Actions are leaf nodes that define tasks for the actor to perform.
## Their execution can be long running, potentially over multiple frames.
## If this happens, the node should return "RUNNING" until the action is complete.

func get_class_name() -> Array[StringName]:
	var classes := super()
	classes.push_back(&"ActionLeaf")
	return classes
