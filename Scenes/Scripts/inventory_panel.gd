extends Panel

@onready var label = $InventoryLabel

var player


func _ready():
	player = get_tree().get_first_node_in_group("player")
	GameManager.inventory_changed.connect(update_inventory)

	update_inventory()


func update_inventory():

	var tree1_log = GameManager.inventory.get("Greenwood", 0)
	var tree2_log = GameManager.inventory.get("Ironbark", 0)
	var tree3_log = GameManager.inventory.get("Heartwood", 0)
	var tree4_log = GameManager.inventory.get("Ancientwood", 0)
	var tree5_log = GameManager.inventory.get("Elderwood", 0)

	var rock1 = GameManager.inventory.get("Granite", 0)
	var rock2 = GameManager.inventory.get("Bloodstone", 0)
	var rock3 = GameManager.inventory.get("Verdantstone", 0)
	var rock4 = GameManager.inventory.get("Shale", 0)
	var rock5 = GameManager.inventory.get("Tidestone", 0)

	$InventoryLabel.text = "Inventory\n" \
		+ "Greenwood: " + str(tree1_log) + "\n" \
		+ "Ironbark: " + str(tree2_log) + "\n" \
		+ "Heartwood: " + str(tree3_log) + "\n" \
		+ "Ancientwood: " + str(tree4_log) + "\n" \
		+ "Elderwood: " + str(tree5_log) + "\n" \
		+ "Granite: " + str(rock1) + "\n" \
		+ "Bloodstone: " + str(rock2) + "\n" \
		+ "Verdantstone: " + str(rock3) + "\n" \
		+ "Shale: " + str(rock4) + "\n" \
		+ "Tidestone: " + str(rock5)
	
func _process(delta):
	update_inventory()
