# Enemy Unit

## Intro
#Placeholder

## Scene Structure

Base:
CharacterBody2D - Inject Speed
								Inject Faction 
CollisionShape - Inject Size, Layer, Mask
Sprite - Inject Texture
HurtBox - Inject Size and Layer, Mask

Custom:
Health - Injected Component exposed via properties in
Behaviour/Pathfinding - Injected Component
Stats *Note: Can also be a injected resource*

Optional:
Weapon
AnimationPlayer

Expose:

IHealth


EnemyController injects Behaviour into Enemies

Follow Behaviour:
	- needs target
	- needs pathfinding agent
	
	- on creation inject target: IDestructable and NavigationHandler into the behaviour
	
	lookup player target




