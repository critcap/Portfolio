class_name AnnouncerView
extends Node

const Announcement: = preload("res://src/scenes/gui/Announcer.tscn")

func Announce(text1: String, text2: String) -> void:
	var post = Announcement.instance()
	owner.add_child(post)
	post.get_node("Control/Container/HBoxContainer/Label2").text = text1
	post.get_node("Control/Container/HBoxContainer/Label").text = text2
	post.play("announce")
	yield(post, "animation_finished")
	post.queue_free()
