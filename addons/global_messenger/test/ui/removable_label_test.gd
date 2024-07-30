# GdUnit generated TestSuite
class_name RemoveableLabelTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/global_messenger/ui/removable_label.gd'
const __source_scene = 'res://addons/global_messenger/ui/removable_label.tscn'

const TEST = "TEST"

func test_set_label_text(input_text: String, expected: String, test_parameters := [
	['TEST', 'TEST'],
	['', '']]) -> void:
	var runner = scene_runner(__source_scene)
	var label = runner.invoke("find_child", "label")
	runner.scene().set_label_text(input_text)
	assert_str(label.text).is_equal(expected)


func test_remove_button_signal_emitted() -> void:
	assert_not_yet_implemented()
	#var runner = scene_runner(__source_scene)
	#runner.scene().set_label_text(TEST)
	#var button = runner.invoke("find_child", "remove")
	#await assert_signal(runner.scene()).wait_until(6000).is_emitted("remove_pressed", [TEST])
	#button.button_pressed = true
	#await_millis(1000)
	#runner.set_mouse_pos(button.position + button.size / 2)
	#runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	#await await_idle_frame()
	#button.invoke("_pressed")
