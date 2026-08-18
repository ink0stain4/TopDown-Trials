switch (type)
{
	case DamageType.DAMAGE:
	{
		draw_set_colour(#FF595E) // Vibrant Coral Red
	}
	break;
	
	case DamageType.HEAL:
	{
		draw_set_colour(#8AC926) // Radioactive Grass Green
	}
	break;
	
	case DamageType.FIRE:
	{
		draw_set_colour(#FFB732) // Sunflower Gold
	}
	break;
	
	case DamageType.COSMIC:
	{
		draw_set_colour(#E11FFF) // Neon Violet
	}
	break;
}

draw_text(x, y - z, string(amount))