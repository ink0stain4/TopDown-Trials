yLevel = lerp(yLevel, maxRevealOffset, 0.25)

if toastXPBar
{
	alarm[0] = 90
	toastXPBar = false
}

if instance_exists(objMenu) || alarm[0] != -1
showEXPBar(true)
else
showEXPBar(false)

image_index = (global.playerXP * (63/global.expRequiredLvlUP))