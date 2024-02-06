extends Label

func _process(delta):
	var player = $"%PlayerCharacterBase"
	text = str("Charges: ", player.Charge,"/", player.ChargeMax)
