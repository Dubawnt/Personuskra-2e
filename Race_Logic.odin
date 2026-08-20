package Personuskra

import "core:strconv"

Stat_Adjustment :: struct {
	Strength: i8,
	Dexterity: i8,
	Constitution: i8,
	Intelligence: i8,
	Wisdom: i8,
	Charisma: i8,
}

Race_Traits :: struct {
	Stat_Adj: Stat_Adjustment,
	Movement: i8,
	Infravision: i8,
	Sleep_Charm_Resist: i8,
	Dwarf_Con_Save: bool,
	Bow_Hit_Bonus: i8,
	Sword_Hit_Bonus: i8,
	Thrown_Hit_Bonus: i8,
	VS_Giant_AC: i8,
	Detection: Detection_Chance,
	Thief_Mod: Thief_Skill_Modifiers,
	Display_Name: string,
}

Detection_Chance :: struct {
	detect_grade_slope:     i8, 
	detect_new_stone_work:  i8, 
	detect_sliding_walls:   i8, 
	detect_traps_in_stone:  i8, 
	detect_secret_doors:    i8, 
	detect_concealed_doors: i8, 
}

Thief_Skill_Modifiers :: struct {
	pick_pockets:          i8,
	open_locks:            i8,
	find_remove_traps:     i8,
	move_silently:         i8,
	hide_in_shadows:       i8,
	detect_noise:          i8,
	climb_walls:           i8,
	read_languages:        i8,
}