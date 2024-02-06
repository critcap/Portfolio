class_name CardFactory

static func create_card_data(atk:int, def:int) -> Dictionary:
    var data = {}
    data.name = "Hannes"
    data.power = atk
    data.toughness = def
    return data

static func create_card() -> GameCard:
    var rng = RandomNumberGenerator.new()
    var card = GameCard.new()
    card.id = card.get_instance_id()
    # rng stuff
    rng.seed = card.id + OS.get_unix_time()
    var rand_attack = rng.randi_range(4,6)
    var rand_toughness = rng.randi_range(5,7)

    card.data = create_card_data(rand_attack, rand_toughness)
    card.power = card.data.power
    card.toughness = card.data.toughness
    card.remaining_attacks = 0
    return card