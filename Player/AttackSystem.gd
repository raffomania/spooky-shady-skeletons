extends Area3D

@export
var damage : int # percent damage per attack

var attackable_enemies : Array[Enemy]


func enemy_entered(node: Node3D):
	#check if node is enemy
	if (node is Enemy):
		attackable_enemies.append(node)
		print_debug(node.name)


func _ready():
	area_entered.connect(enemy_entered)
