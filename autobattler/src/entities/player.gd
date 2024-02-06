class_name PlayerBase
extends Node


var toughness: int
var max_toughness: int
var index: int 

var cards: Array 
var hand_cards: Array setget , get_hands_cards
var board_cards: Array setget , get_board_cards
var gravey_cards: Array setget, get_gravey_cards

func get_hands_cards() -> Array: 
	var out: = []
	for c in cards:
		if c.zone == Zones.HAND:
			out.append(c)
	return out

func get_board_cards() -> Array: 
	var out: = []
	for c in cards:
		if c.zone == Zones.FIELD:
			out.append(c)
	return out

func get_gravey_cards() -> Array:
	var out: = []
	for c in cards:
		if c.zone == Zones.GRAVEYARD:
			out.append(c)
	return out

func is_alive() -> bool: 
	return toughness > 0

