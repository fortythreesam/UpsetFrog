class_name State

signal change_state(new_state)
signal revert_state

func start(owner):
	pass

func step(owner, delta: float):
	pass
	
func end(owner):
	pass

func handle_message(msg:Telegram, owner):
	match msg.message:
		_:
			return false
