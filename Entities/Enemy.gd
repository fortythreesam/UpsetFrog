extends Entity
class_name Enemy

export(int) var vision_range = 200
export(int) var attack_range = 25
export(int) var attack_range_y = 3
export(int) var personal_space = 20

var target

var ai_controller

func _ready():
	ai_controller = StateManager.new(self)
	
	ai_controller.states = {
		idle = IdleState.new(),
		chase = ChaseState.new(),
		empty = EmptyState.new(),
		attack = AttackState.new()
	}
	
	ai_controller.change_state("idle")
	ai_controller.set_global_state("empty")
	ai_controller.name = "AIController"

func _process(delta):
	if alive:
		ai_controller.step(delta)

func set_target(new_target):
	target = new_target 
