extends Panel

@onready var label = $InventoryLabel

var player


func _ready():
	player = get_tree().get_first_node_in_group("player")
	GameManager.inventory_changed.connect(update_inventory)

	update_inventory()


func update_inventory():
	var wood = GameManager.inventory.get("Wood Log", 0)
	$InventoryLabel.text = "Inventory\nWood Log: " + str(wood)
	
func _process(delta):
	update_inventory()
