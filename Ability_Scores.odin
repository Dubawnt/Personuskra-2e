package Character_Sheet
//imports
import "core:fmt"
import "core:strconv"
import "core:strings"

//Ability Score Tables + Logic
//Strength

// Strength Tables
Strength_Bonuses :: struct {
	Hit_Prob:           i8,
	Damage_Adjust:      i8,
	Weight_Allow:       i16,
	Max_Press:          i16,
	Open_Doors:         i8,
	Open_Magical_Doors: i8,
	Bend_Bars:          i8,
}

Strength_Table := [26]Strength_Bonuses {
	1  = {-5, -4, 1, 3, 1, 0, 0},
	2  = {-3, -2, 1, 5, 1, 0, 0},
	3  = {-3, -1, 5, 10, 2, 0, 0},
	4  = {-2, -1, 10, 25, 3, 0, 0},
	5  = {-2, -1, 10, 25, 3, 0, 0},
	6  = {-1, 0, 20, 55, 4, 0, 0},
	7  = {-1, 0, 20, 55, 4, 0, 0},
	8  = {0, 0, 35, 90, 5, 0, 1},
	9  = {0, 0, 35, 90, 5, 0, 1},
	10 = {0, 0, 40, 115, 6, 0, 2},
	11 = {0, 0, 40, 115, 6, 0, 2},
	12 = {0, 0, 45, 140, 7, 0, 4},
	13 = {0, 0, 45, 140, 7, 0, 4},
	14 = {0, 0, 55, 170, 8, 0, 7},
	15 = {0, 0, 55, 170, 8, 0, 7},
	16 = {0, 1, 70, 195, 9, 0, 10},
	17 = {1, 1, 85, 220, 10, 0, 13},
	18 = {1, 2, 110, 255, 11, 0, 16},
	19 = {3, 7, 485, 640, 16, 8, 50},
	20 = {3, 8, 535, 700, 17, 10, 60},
	21 = {4, 9, 635, 810, 17, 12, 70},
	22 = {4, 10, 785, 970, 18, 14, 80},
	23 = {5, 11, 935, 1130, 18, 16, 90},
	24 = {6, 12, 1235, 1440, 19, 17, 95},
	25 = {7, 14, 1535, 1750, 19, 18, 99},
}

Exceptional_Bracket :: enum {
	p01_50, //percentiles for exceptional strength
	p51_75,
	p76_90,
	p91_99,
	p00,
}

Exceptional_Strength_Table :: [Exceptional_Bracket]Strength_Bonuses {
	.p01_50 = {1, 3, 135, 280, 12, 0, 20},
	.p51_75 = {2, 3, 160, 305, 13, 0, 25},
	.p76_90 = {2, 4, 185, 330, 14, 0, 30},
	.p91_99 = {2, 5, 235, 380, 15, 0, 35},
	.p00    = {3, 6, 335, 480, 16, 6, 40},
}

//Strength calc
Get_Strength :: proc(score: string) -> (bonuses: Strength_Bonuses, valid: bool) {
	// 1. Check for '/'
	if slash_idx := strings.index_byte(score, '/'); slash_idx != -1 {
		left_str := score[:slash_idx]
		right_str := score[slash_idx + 1:]

		left, ok_left := strconv.parse_int(left_str)
		right, ok_right := strconv.parse_int(right_str)

		if ok_left && ok_right && left == 18 {
			switch right {
			case 0:
				return Exceptional_Strength_Table[.p00], true
			case 1 ..= 50:
				return Exceptional_Strength_Table[.p01_50], true
			case 51 ..= 75:
				return Exceptional_Strength_Table[.p51_75], true
			case 76 ..= 90:
				return Exceptional_Strength_Table[.p76_90], true
			case 91 ..= 99:
				return Exceptional_Strength_Table[.p91_99], true
			}
		}
		return {}, false
	}

	//Standard Strength
	if val, ok := strconv.parse_int(score); ok && val >= 1 && val <= 25 {
		return Strength_Table[val], true
	}

	return {}, false
}

//Dexterity Table

Dex_Bonuses :: struct {
	Reaction_Adj:  i8,
	Missile_Adj:   i8,
	Defensive_Adj: i8,
}

Dexterity_Table := [26]Dex_Bonuses {
	1  = {-6, -6, 5},
	2  = {-4, -4, 5},
	3  = {-3, -3, 4},
	4  = {-2, -2, 3},
	5  = {-1, -1, 2},
	6  = {0, 0, 1},
	7 ..= 14  = {0, 0, 0},
	15 = {0, 0, -1},
	16 = {1, 1, -2},
	17 = {2, 2, -3},
	18 = {2, 2, -4},
	19 = {3, 3, -4},
	20 = {3, 3, -4},
	21 = {4, 4, -5},
	22 = {4, 4, -5},
	23 = {4, 4, -5},
	24 = {5, 5, -6},
	25 = {5, 5, -6},
}

Get_Dex :: proc(score: string) -> (bonuses: Dex_Bonuses, valid: bool) {
	dexterity, ok := strconv.parse_int(score)
	if ok && dexterity > 0 && dexterity < 26 {
		return Dexterity_Table[dexterity], true
	} else {
		return {}, false
	}
}

//Constitution Table

Con_Bonuses :: struct {
	HP_Adj:       i8,
	HP_Adj_Warr:  i8,
	System_Shock: i8,
	Res_Chance:   i8,
	Poison_Save:  i8,
	Regen:        i8,
}

Constitution_Table := [26]Con_Bonuses {
	1  = {-3, -3, 25, 30, -2, 0},
	2  = {-2, -2, 30, 35, -1, 0},
	3  = {-2, -2, 35, 40, 0, 0},
	4  = {-1, -1, 40, 45, 0, 0},
	5  = {-1, -1, 45, 50, 0, 0},
	6  = {-1, -1, 50, 55, 0, 0},
	7  = {0, 0, 55, 60, 0, 0},
	8  = {0, 0, 60, 65, 0, 0},
	9  = {0, 0, 65, 70, 0, 0},
	10 = {0, 0, 70, 75, 0, 0},
	11 = {0, 0, 75, 80, 0, 0},
	12 = {0, 0, 70, 75, 0, 0},
	13 = {0, 0, 85, 90, 0, 0},
	14 = {0, 0, 88, 92, 0, 0},
	15 = {1, 1, 90, 94, 0, 0},
	16 = {2, 2, 95, 96, 0, 0},
	17 = {2, 3, 97, 98, 0, 0},
	18 = {2, 4, 99, 100, 0, 0},
	19 = {2, 5, 99, 100, 1, 0},
	20 = {2, 5, 99, 100, 1, 6},
	21 = {2, 6, 99, 100, 2, 5},
	22 = {2, 6, 99, 100, 2, 4},
	23 = {2, 6, 99, 100, 3, 3},
	24 = {2, 7, 99, 100, 3, 2},
	25 = {2, 7, 100, 100, 4, 1},
}

Get_Regen_String :: proc(turns: i8) -> string {
	switch turns {
	case 0:
		return "Nil"
	case 6:
		return "1/6 turns"
	case 5:
		return "1/5 turns"
	case 3:
		return "1/3 turns"
	case 2:
		return "1/2 turns"
	case 1:
		return "1/1 turn"
	case:
		return "Nil"
	}
}

Get_Con :: proc(score1: string) -> (bonuses: Con_Bonuses, valid: bool) {
	constitution, ok := strconv.parse_int(score1)
	if ok && constitution > 0 && constitution < 26 {
		return Constitution_Table[constitution], true
	} else {
		return {}, false
	}
}

//Intelligence Table
Int_Bonuses :: struct {
	Num_Languages:   i8,
	Max_Spell_lvl:   i8,
	Chance_to_Learn: i8,
	Max_Per_Level:   i8,
	Ill_Immunity:    i8,
}
//-1 means All in Table
Intelligence_Table := [26]Int_Bonuses {
	1  = {0, 0, 0, 0, 0},
	2 ..= 8  = {1, 0, 0, 0, 0},
	9  = {2, 4, 35, 6, 0},
	10 = {2, 5, 40, 7, 0},
	11 = {2, 5, 45, 7, 0},
	12 = {3, 6, 50, 7, 0},
	13 = {3, 6, 55, 9, 0},
	14 = {4, 7, 60, 9, 0},
	15 = {4, 7, 65, 11, 0},
	16 = {5, 8, 70, 11, 0},
	17 = {6, 8, 75, 14, 0},
	18 = {7, 9, 85, 18, 0},
	19 = {8, 9, 95, -1, 1},
	20 = {9, 9, 96, -1, 2},
	21 = {10, 9, 97, -1, 3},
	22 = {11, 9, 98, -1, 4},
	23 = {12, 9, 99, -1, 5},
	24 = {15, 9, 100, -1, 6},
	25 = {20, 9, 100, -1, 7},
}

Get_Int :: proc(score: string) -> (bonuses: Int_Bonuses, valid: bool) {
	intelligence, ok := strconv.parse_int(score)
	if ok && intelligence > 0 && intelligence < 26 {
		return Intelligence_Table[intelligence], true
	} else {
		return {}, false
	}
}

get_max_spells :: proc(max_spells: i8) -> string {
	switch max_spells {
	case -1:
		return "All"
	case 0:
		return "0"
	case:
		return fmt.tprintf("%d", max_spells)
	}
}

//Wisdom Table
//Bonus Spells will be separated from primary struct
//Spell Immunities will also be separated
Wis_Bonuses :: struct {
	Def_Adj_Mind: i8,
	Spell_Fail: i8,
}

Wisdom_Table := [26]Wis_Bonuses {
	1 = {-6, 80},
	2 = {-4, 60},
	3 = {-3, 50},
	4 = {-2, 45},
	5 = {-1, 40},
	6 = {-1, 35},
	7 = {-1, 30},
	8 = {0, 25},
	9 = {0, 20},
	10 = {0, 15},
	11 = {0, 10},
	12 = {0, 5},
	13 = {0, 0},
	14 = {0, 0},
	15 = {1, 0},
	16 = {2, 0},
	17 = {3, 0},
	18 ..= 25 = {4, 0},
}

Get_Wis :: proc(score: string) -> (bonuses: Wis_Bonuses, valid: bool) {
	wisdom, ok := strconv.parse_int(score)
	if ok && wisdom > 0 && wisdom < 26 {
		return Wisdom_Table[wisdom], true
	} else {
		return {}, false
	}
}

Bonus_Spells :: [8]i8

Bonus_Table := [26]Bonus_Spells {
	1 ..= 12 = {0, 0, 0, 0, 0, 0, 0, 0},
	13 = {0, 1, 0, 0, 0, 0, 0, 0},
	14 = {0, 2, 0, 0, 0, 0, 0, 0},
	15 = {0, 2, 1, 0, 0, 0, 0, 0},
	16 = {0, 2, 2, 0, 0, 0, 0, 0},
	17 = {0, 2, 2, 1, 0, 0, 0, 0},
	18 = {0, 2, 2, 1, 1, 0, 0, 0},
	19 = {0, 3, 2, 2, 1, 0, 0, 0},
	20 = {0, 3, 3, 2, 2, 0, 0, 0},
	21 = {0, 3, 3, 3, 2, 1, 0, 0},
	22 = {0, 3, 3, 3, 3, 2, 0, 0},
	23 = {0, 4, 3, 3, 3, 2, 1, 0},
	24 = {0, 4, 3, 3, 3, 3, 2, 0},
	25 = {0, 4, 3, 3, 3, 3, 3, 1},
}

Get_Bonus_Spells :: proc(score: string) -> (bonuses: Bonus_Spells, valid: bool) {
	index, ok := strconv.parse_int(score)
	if ok && index > 0 && index < 26 {
		return Bonus_Table[index], true
	} else {
		return {}, false
	}
}

Wisdom_Spell_Immunities := [26][]string{
	1 ..= 18 = {},
	19       = {"Cause Fear", "Charm Person", "Command", "Friends", "Hypnotism"},
	20       = {"Cause Fear", "Charm Person", "Command", "Friends", "Hypnotism",
	            "Forget", "Hold Person", "Ray of Enfeeblement", "Scare"},
	21       = {"Cause Fear", "Charm Person", "Command", "Friends", "Hypnotism",
	            "Forget", "Hold Person", "Ray of Enfeeblement", "Scare",
	            "Fear"},
	22       = {"Cause Fear", "Charm Person", "Command", "Friends", "Hypnotism",
	            "Forget", "Hold Person", "Ray of Enfeeblement", "Scare",
	            "Fear", "Charm Monster", "Confusion", "Emotion", "Fumble", "Suggestion"},
	23       = {"Cause Fear", "Charm Person", "Command", "Friends", "Hypnotism",
	            "Forget", "Hold Person", "Ray of Enfeeblement", "Scare",
	            "Fear", "Charm Monster", "Confusion", "Emotion", "Fumble", "Suggestion",
	            "Chaos", "Feeblemind", "Hold Monster", "Magic Jar", "Quest"},
	24       = {"Cause Fear", "Charm Person", "Command", "Friends", "Hypnotism",
	            "Forget", "Hold Person", "Ray of Enfeeblement", "Scare",
	            "Fear", "Charm Monster", "Confusion", "Emotion", "Fumble", "Suggestion",
	            "Chaos", "Feeblemind", "Hold Monster", "Magic Jar", "Quest",
	            "Geas", "Mass Suggestion", "Rod of Rulership"},
	25       = {"Cause Fear", "Charm Person", "Command", "Friends", "Hypnotism",
	            "Forget", "Hold Person", "Ray of Enfeeblement", "Scare",
	            "Fear", "Charm Monster", "Confusion", "Emotion", "Fumble", "Suggestion",
	            "Chaos", "Feeblemind", "Hold Monster", "Magic Jar", "Quest",
	            "Geas", "Mass Suggestion", "Rod of Rulership",
	            "Antipathy/Sympathy", "Death Spell", "Mass Charm"},
}

Get_Wisdom_Immunities :: proc(wis: string) -> []string {
	wisdom, ok := strconv.parse_int(wis)
	if ok && wisdom > 0 && wisdom < 26 {
		return Wisdom_Spell_Immunities[wisdom]
	} else {
		return {}
	}
}

//Charisma Tables