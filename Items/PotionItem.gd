extends Item

var heal_strength = 20

func use(entity):
	entity.health += heal_strength
