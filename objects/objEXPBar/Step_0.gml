yLevel = lerp(yLevel, maxRevealOffset, 0.25)

if toastXPBar == true
{
	alarm[0] = 90
	showEXPBar(true)
	toastXPBar = false
}

// debug open check thing idk
//if keyboard_check(ord("F"))
//showEXPBar(true)
//else
//showEXPBar(false)

image_index = (global.playerXP * (63/global.expRequiredLvlUP))