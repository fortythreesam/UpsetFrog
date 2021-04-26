extends Node
class_name StateManager

var owner_node

var current_state:State
var global_state:State
var previous_state:State

var states

func _ready():
	pass 

func _init(owner):
	owner_node = owner

func step(delta: float):
	global_state.step(owner_node, delta)
	current_state.step(owner_node, delta)

func change_state(new_state:String):
	if current_state:
		previous_state = current_state
		current_state.end(owner_node)
		current_state.disconnect('change_state', self, 'on_state_request_state_change')
		current_state.disconnect('revert_state', self, 'on_state_request_reverse_state')
	current_state = states[new_state]
	current_state.connect('change_state', self, 'on_state_request_state_change')
	current_state.connect('revert_state', self, 'on_state_request_reverse_state')
	current_state.start(owner_node)
	
func set_global_state(new_state:String):
	var state = states[new_state]
	state.connect('change_state', self, 'on_state_request_state_change')
	state.connect('revert_state', self, 'on_state_request_reverse_state')
	global_state = state
	global_state.start(owner_node)
	
func revert_state():
	var new_state = previous_state
	if current_state:
		previous_state = current_state
		current_state.end(owner_node)
		current_state.disconnect('change_state', self, 'on_state_request_state_change')
		current_state.disconnect('revert_state', self, 'on_state_request_reverse_state')
	current_state = new_state
	current_state.connect('change_state', self, 'on_state_request_state_change')
	current_state.connect('revert_state', self, 'on_state_request_reverse_state')
	current_state.start(owner_node)
	
func on_state_request_state_change(new_state:String):
	change_state(new_state)
	
func on_state_request_reverse_state():
	revert_state()
	
func handle_message(msg:Telegram):
	if current_state.handle_message(msg, owner_node):
		return true;
	elif global_state.handle_message(msg, owner_node):
		return true;
	return false;
