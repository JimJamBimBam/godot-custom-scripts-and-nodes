## Base class for all leaf nodes of the tree.
class_name Leaf extends BTNode

# Handle any warnings such as:
# - any leaf nodes having children. They shouldn't have any.


# TODO: Implement get_class_name() method.
func get_class_name() -> Array[StringName]:
	var classes := super()
	classes.push_back(&"Leaf")
	return classes
	
