extends Node2D
class_name MatchManager

@onready var tick_timer := $TickTimer
@onready var send_test_message_button: DefaultButton = $SendTestMessageButton

var current_tick := 0.0

signal tick_complete(current_tick)

func _ready():
	_setup_match()
	_start_match()

func _setup_match():
	tick_timer.timeout.connect(_handle_tick_timer)

func _start_match():
	tick_timer.start()
	
func _handle_tick_timer():
	current_tick += tick_timer.wait_time
	emit_signal("tick_complete", current_tick)
	# print("Curent Ticks: %s" % [current_tick])

# TODO: add a func to check for duplicate players and error on it


func _on_send_test_message_button_button_up() -> void:
	NetworkManager._send_test_message.rpc("Sup")
	pass # Replace with function body.
