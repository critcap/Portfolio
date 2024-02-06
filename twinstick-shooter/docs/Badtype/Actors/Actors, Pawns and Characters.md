# Actors, Pawns and Characters

## Intro
In Badtype we copy the naming scheme for objects that can live on the level plain from Unreal Engine.  Common traits are: All of them inherit atleast from Node2D/Node3D and should be perceivable in some form by the user.

### Actors 
Actors are the most basic type of objects in a level. They cannot be controlled by the player or an AI. Actors cannot interact with other objects themself but can be interacted with by Pawns and Characters

- Barricades
- Collectables


### Pawns
Pawns are externally controlled objects that live on in a level. Not through physical input but rather by a controller and predefined behaviours. Pawns can interact with other objects like actors, other pawns or characters.
There is no hard limit how many **Pawns** can be active in a level.

- [[Enemy]] units
- Friendly units e.g. turrets

### Characters
Characters are objects that are directly controlled by the user's inputs. There can only be one *active* Character in a level per player at the time. Technically you can have 2 or more Characters exist in a level at the same time, but you will only be able to control 1 and let the rest be inactive or be controlled by a controller (In that case the **Character** objects are considered **Pawns** in a gameplay sense). There are some edgecases where is possible that you can control multiple **Characters** at the same time given the user input happens simultaneously for the both of them.

**The CharacterBody node is not limited to Characters and can also be used by Pawns!** 

- [[PlayerCharacter]]