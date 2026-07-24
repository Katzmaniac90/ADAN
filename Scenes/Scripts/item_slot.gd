extends Control


var item_name = ""
var amount = 0


func setup_item(name, quantity, texture):

	var item_icon = $ItemIcon
	var quantity_label = $Quantity

	item_name = name
	amount = quantity

	item_icon.texture = texture
	quantity_label.text = str(amount)

	tooltip_text = item_name + "\nQuantity: " + str(amount)
	if amount > 1:
		quantity_label.text = str(amount)
	else:
		quantity_label.text = ""
