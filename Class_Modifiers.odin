package Personuskra
//imports
import "core:strconv"

//Class Enumerations

Class_Groups :: enum{
	Warrior,
	Priest,
	Rogue,
	Wizard,
	Psionicist,
}

Classes :: enum {
	Fighter,
	Paladin,
	Ranger,
	Cleric,
	Druid,
	Thief,
	Bard,
	Mage,
	Psionicist,
}

Class_To_Group := [Classes]Class_Groups {
	.Fighter = .Warrior,
	.Paladin = .Warrior,
	.Ranger = .Warrior,
	.Cleric = .Priest,
	.Druid = .Priest,
	.Thief = .Rogue,
	.Bard = .Rogue,
	.Mage = .Wizard,
	.Psionicist = .Psionicist,
}

Get_Class_Group :: proc(class: Classes) -> (group: Class_Groups) {
	return Class_To_Group[class]
}

//Saving Throws
Saving_Throws :: struct {
	Para_Poison_Death: i8,
	Rod_Staff_Wand: i8,
	Petri_Poly: i8,
	Breath_Weapon: i8,
	Spell: i8,
}

Priest_Saves := [31]Saving_Throws {
	1 ..= 3 = {10, 14, 13, 16, 15},
	4 ..= 6 = {9, 13, 12, 15, 14},
	7 ..= 9 = {7, 11, 10, 13, 12},
	10 ..= 12 = {6, 10, 9, 12, 11},
	13 ..= 15 = {5, 9, 8, 11, 10},
	16 ..= 18 = {4, 8, 7, 10, 9},
	19 ..= 30 = {2, 6, 5, 8, 7},
}

Rogue_Saves := [31]Saving_Throws {
	1 ..= 4 = {13, 14, 12, 16, 15},
	5 ..= 8 = {12, 12, 11, 15, 13},
	9 ..= 12 = {11, 10, 10, 14, 11},
	13 ..= 16 = {10, 8, 9, 13, 9},
	17 ..= 20 = {9, 6, 8, 12, 7},
	21 ..= 30 = {8, 4, 7, 11, 5},
}

Warrior_Saves := [31]Saving_Throws {
	0 = {16, 18, 17, 20, 19},
	1 ..= 2 = {14, 16, 15, 17, 17},
	3 ..= 4 = {13, 15, 14, 16, 16},
	5 ..= 6 = {11, 13, 12, 13, 14},
	7 ..= 8 = {10, 12, 11, 12, 13},
	9 ..= 10 = {8, 10, 9, 9, 11},
	11 ..= 12 = {7, 9, 8, 8, 10},
	13 ..= 14 = {5, 7, 6, 5, 8},
	15 ..= 16 = {4, 6, 5, 4, 7},
	17 ..= 30 = {3, 5, 4, 4, 6},
}

Wizard_Saves := [31]Saving_Throws {
	1 ..= 5 = {14, 11, 13, 15, 12},
	6 ..= 10 = {13, 9, 11, 13, 10},
	11 ..= 15 = {11, 7, 9, 11, 8},
	16 ..= 20 = {10, 5, 7, 9, 6},
	21 ..= 30 = {8, 3, 5, 7, 4},
}

Psionicist_Saves := [31]Saving_Throws {
	1 ..= 4 = {13, 15, 10, 16, 15},
	5 ..= 8 = {12, 13, 9, 15, 14},
	9 ..= 12 = {11, 11, 8, 13, 12},
	13 ..= 16 = {10, 9, 7, 12, 11},
	17 ..= 20 = {9, 7, 6, 11, 9},
	21 ..= 30 = {8, 5, 5, 9, 7},
}

Get_Saves :: proc(level: string, class: Classes) -> (Saves: Saving_Throws, valid: bool) {
	lvl, ok := strconv.parse_int(level)
	if ok && lvl>=0 && lvl<31 {
		if lvl == 0 {
			return Warrior_Saves[0], true
		}
		else {
			group := Get_Class_Group(class)
			switch group {
			case .Warrior: return Warrior_Saves[lvl], true
			case .Priest: return Priest_Saves[lvl], true
			case .Rogue: return Rogue_Saves[lvl], true
			case .Wizard: return Wizard_Saves[lvl], true
			case .Psionicist: return Psionicist_Saves[lvl], true
			}
		}
	}
	return {}, false
}

//Thac0

Warrior_Thac0 := [31]i8 {
    1 = 20, 2 = 19, 3 = 18, 4 = 17, 5 = 16, 6 = 15, 7 = 14, 8 = 13, 9 = 12, 10 = 11,
    11 = 10, 12 = 9, 13 = 8, 14 = 7, 15 = 6, 16 = 5, 17 = 4, 18 = 3, 19 = 2, 20..= 30 = 1,
}

Priest_Thac0 := [31]i8 {
	1 ..= 3   = 20,
    4 ..= 6   = 18,
    7 ..= 9   = 16,
    10 ..= 12 = 14,
    13 ..= 15 = 12,
    16 ..= 18 = 10,
    19 ..= 30 = 8,
}

Rogue_Psi_Thac0 := [31]i8 {
	1 ..= 2   = 20,
    3 ..= 4   = 19,
    5 ..= 6   = 18,
    7 ..= 8   = 17,
    9 ..= 10  = 16,
    11 ..= 12 = 15,
    13 ..= 14 = 14,
    15 ..= 16 = 13,
    17 ..= 18 = 12,
    19 ..= 30 = 11,
}

Wizard_THAC0 := [31]i8 {
    1 ..= 3   = 20,
    4 ..= 6   = 19,
    7 ..= 9   = 18,
    10 ..= 12 = 17,
    13 ..= 15 = 16,
    16 ..= 18 = 15,
    19 ..= 30 = 14,
}

get_Thac0 :: proc(level: string, class: Classes) -> (Thac0: i8, valid: bool) {
	lvl, ok := strconv.parse_int(level)
	if ok && lvl>=0 && lvl<31 {
		if lvl == 0 {
			return 20, true
		}
		else {
			group := Get_Class_Group(class)
			switch group {
			case .Warrior: return Warrior_Thac0[lvl] , true
			case .Priest: return Priest_Thac0[lvl], true
			case .Rogue: return Rogue_Psi_Thac0[lvl], true
			case .Wizard: return Wizard_THAC0[lvl], true
			case .Psionicist: return Rogue_Psi_Thac0[lvl], true
			}
		}
	}
	return {}, false
}
