//itemGem create

init_airborne_properties(0.15, 0.3)

enum ItemState
{
	DEFAULT,
	TRASHING
}

enum TrashPhase
{
	HOVER,
	DROP
}

trash_target = noone
trash_phase = TrashPhase.HOVER
state = ItemState.DEFAULT

PickupCD  = 60
MagnetSpeed = 5
lifetime = 3600

alarm[0] = PickupCD
alarm[1] = lifetime

friction = 0.06

sprite_index = item.SlotSprite;
hovered = false



launch_airborne(2.2)

