extends Control


var tile: Tile

func on_cursor_position_changed(_tile: Tile):
	if !_tile || _tile == tile:
		return

	tile = _tile
	refresh_content()


func refresh_content() -> void:
	var tile_pos = "Position X:%s | Y:%s"
	$TileInfo/Position.text = tile_pos % [tile.position.x, tile.position.z]
	$TileInfo/Height.text = str("Height: ", tile.position.y)
	$TileInfo/Type.text = str(tile.terrain)

	if !tile.content:
		$ContentInfo.visible = false
		return
	
	var unit = tile.content.owner
	$ContentInfo/Name.text = unit.name
	var content_health = "Health: %s | %s"
	var health: = unit.get_node("Health") as Health
	$ContentInfo/HP.text = content_health % [health.current, health.maxhp]
	$ContentInfo/WT.text = str("Wait Time: ", unit.get_node("Stats").get_value(StatTypes.WAIT))
	$ContentInfo.visible = true
