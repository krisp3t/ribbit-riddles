extends Marker2D
	
func select():
	for child in get_tree().get_nodes_in_group("zone"):
		child.deselect();
	modulate = Color.TRANSPARENT;
	
func deselect():
	modulate = Color.WHITE;
