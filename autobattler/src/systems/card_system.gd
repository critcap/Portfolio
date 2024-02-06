class_name CardSystem
extends Node

func change_zone(card: GameCard, to_zone: int, to_player: PlayerBase = null) -> void:
    var from_player = owner.players[card.owner_index]
    to_player = to_player if to_player != null else from_player
    card.zone = to_zone
    if !card in to_player.cards:
        to_player.cards.append(card)
    card.owner_index = to_player.index


