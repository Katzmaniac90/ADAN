extends Panel

@onready var label = $InventoryLabel

var player


func _ready():
	player = get_tree().get_first_node_in_group("player")
	GameManager.inventory_changed.connect(update_inventory)

	update_inventory()


func update_inventory():
	var tree1_log = GameManager.inventory.get("Tree1 Log", 0)
	var tree2_log = GameManager.inventory.get("Tree2 Log", 0)
	var tree3_log = GameManager.inventory.get("Tree3 Log", 0)
	var tree4_log = GameManager.inventory.get("Tree4 Log", 0)

	$InventoryLabel.text = "Inventory\n" \
	+ "Tree1 Log: " + str(tree1_log) + "\n" \
	+ "Tree2 Log: " + str(tree2_log) + "\n" \
	+ "Tree3 Log: " + str(tree3_log) + "\n" \
	+ "Tree4 Log: " + str(tree4_log)
	
func _process(delta):
	update_inventory()
