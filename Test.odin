package Character_Sheet

import "core:testing"

// ==========================================
// STRENGTH TESTS
// ==========================================

@(test)
test_strength_standard :: proc(t: ^testing.T) {
	// Boundary: Minimum (1)
	str_1, ok_1 := Get_Strength("1")
	testing.expect(t, ok_1, "Expected '1' to be valid")
	testing.expect_value(t, str_1.Hit_Prob, i8(-5))
	testing.expect_value(t, str_1.Damage_Adjust, i8(-4))
	testing.expect_value(t, str_1.Weight_Allow, i16(1))

	// Average: 10
	str_10, ok_10 := Get_Strength("10")
	testing.expect(t, ok_10, "Expected '10' to be valid")
	testing.expect_value(t, str_10.Hit_Prob, i8(0))
	testing.expect_value(t, str_10.Damage_Adjust, i8(0))
	testing.expect_value(t, str_10.Max_Press, i16(115))

	// Boundary: Maximum (25)
	str_25, ok_25 := Get_Strength("25")
	testing.expect(t, ok_25, "Expected '25' to be valid")
	testing.expect_value(t, str_25.Hit_Prob, i8(7))
	testing.expect_value(t, str_25.Damage_Adjust, i8(14))
	testing.expect_value(t, str_25.Bend_Bars, i8(99))
}

@(test)
test_exceptional_strength :: proc(t: ^testing.T) {
	// Bracket 1: 18/01 -> 18/50
	s1, ok1 := Get_Strength("18/35")
	testing.expect(t, ok1, "Expected '18/35' to be valid")
	testing.expect_value(t, s1.Damage_Adjust, i8(3))
	testing.expect_value(t, s1.Weight_Allow, i16(135))

	// Bracket 3: 18/76 -> 18/90
	s3, ok3 := Get_Strength("18/80")
	testing.expect(t, ok3, "Expected '18/80' to be valid")
	testing.expect_value(t, s3.Hit_Prob, i8(2))
	testing.expect_value(t, s3.Damage_Adjust, i8(4))

	// Bracket 5: 18/00 (parsed as 0)
	s5, ok5 := Get_Strength("18/00")
	testing.expect(t, ok5, "Expected '18/00' to be valid")
	testing.expect_value(t, s5.Hit_Prob, i8(3))
	testing.expect_value(t, s5.Damage_Adjust, i8(6))
	testing.expect_value(t, s5.Open_Magical_Doors, i8(6))

	// Invalid Exceptional inputs
	_, ok_bad1 := Get_Strength("17/50") // Only 18 can have exceptional
	testing.expect(t, !ok_bad1, "17/50 should not be valid")

	_, ok_bad2 := Get_Strength("18/105") // Out of range percentile
	testing.expect(t, !ok_bad2, "18/105 should not be valid")
}

// ==========================================
// DEXTERITY TESTS
// ==========================================

@(test)
test_dexterity :: proc(t: ^testing.T) {
	// Min score
	dex_1, ok_1 := Get_Dex("1")
	testing.expect(t, ok_1, "Expected '1' to be valid")
	testing.expect_value(t, dex_1.Reaction_Adj, i8(-6))
	testing.expect_value(t, dex_1.Defensive_Adj, i8(5))

	// Mid range (7..=14 all zeroes)
	dex_10, ok_10 := Get_Dex("10")
	testing.expect(t, ok_10, "Expected '10' to be valid")
	testing.expect_value(t, dex_10.Reaction_Adj, i8(0))
	testing.expect_value(t, dex_10.Defensive_Adj, i8(0))

	// AC improvement (negative is better in 2e)
	dex_18, ok_18 := Get_Dex("18")
	testing.expect(t, ok_18, "Expected '18' to be valid")
	testing.expect_value(t, dex_18.Defensive_Adj, i8(-4))
}

// ==========================================
// CONSTITUTION TESTS
// ==========================================

@(test)
test_constitution_and_regen :: proc(t: ^testing.T) {
	// Standard scores vs Warrior bonus
	con_17, ok_17 := Get_Con("17")
	testing.expect(t, ok_17, "Expected '17' to be valid")
	testing.expect_value(t, con_17.HP_Adj, i8(2))
	testing.expect_value(t, con_17.HP_Adj_Warr, i8(3))
	testing.expect_value(t, con_17.System_Shock, i8(97))

	// Constitution 12 progression test
	con_12, ok_12 := Get_Con("12")
	testing.expect(t, ok_12, "Expected '12' to be valid")
	testing.expect_value(t, con_12.System_Shock, i8(80))
	testing.expect_value(t, con_12.Res_Chance, i8(85))

	// High Con with Regen string lookup
	con_20, ok_20 := Get_Con("20")
	testing.expect(t, ok_20, "Expected '20' to be valid")
	testing.expect_value(t, con_20.Poison_Save, i8(1))
	testing.expect_value(t, con_20.Regen, i8(6))
	testing.expect_value(t, Get_Regen_String(con_20.Regen), "1/6 turns")

	con_25, _ := Get_Con("25")
	testing.expect_value(t, Get_Regen_String(con_25.Regen), "1/1 turn")
}

// ==========================================
// INTELLIGENCE TESTS
// ==========================================

@(test)
test_intelligence :: proc(t: ^testing.T) {
	// Low Int range (2..=8)
	int_5, ok_5 := Get_Int("5")
	testing.expect(t, ok_5, "Expected '5' to be valid")
	testing.expect_value(t, int_5.Num_Languages, i8(1))
	testing.expect_value(t, int_5.Max_Spell_lvl, i8(0))

	// Wizard baseline (18)
	int_18, ok_18 := Get_Int("18")
	testing.expect(t, ok_18, "Expected '18' to be valid")
	testing.expect_value(t, int_18.Chance_to_Learn, i8(85))
	testing.expect_value(t, int_18.Max_Per_Level, i8(18))
	testing.expect_value(t, get_max_spells(int_18.Max_Per_Level), "18")

	// Demigod tier with "All" spells (-1) & Illusion immunity
	int_22, ok_22 := Get_Int("22")
	testing.expect(t, ok_22, "Expected '22' to be valid")
	testing.expect_value(t, int_22.Max_Per_Level, i8(-1))
	testing.expect_value(t, int_22.Ill_Immunity, i8(4))
	testing.expect_value(t, get_max_spells(int_22.Max_Per_Level), "All")
}

// ==========================================
// WISDOM & SPELL IMMUNITY TESTS
// ==========================================

@(test)
test_wisdom_and_bonus_spells :: proc(t: ^testing.T) {
	// Low Wisdom penalties
	wis_1, ok_1 := Get_Wis("1")
	testing.expect(t, ok_1, "Expected '1' to be valid")
	testing.expect_value(t, wis_1.Def_Adj_Mind, i8(-6))
	testing.expect_value(t, wis_1.Spell_Fail, i8(80))

	// Bonus spells lookup
	spells_13, ok_s13 := Get_Bonus_Spells("13")
	testing.expect(t, ok_s13, "Expected '13' to have bonus spells table entry")
	testing.expect_value(t, spells_13[1], i8(1)) // +1 1st level
	testing.expect_value(t, spells_13[2], i8(0))

	// High Wisdom cumulative slots (Score 19: {0, 3, 2, 2, 1, 0, 0, 0})
	spells_19, _ := Get_Bonus_Spells("19")
	testing.expect_value(t, spells_19[1], i8(3)) // 1st
	testing.expect_value(t, spells_19[2], i8(2)) // 2nd
	testing.expect_value(t, spells_19[3], i8(2)) // 3rd
	testing.expect_value(t, spells_19[4], i8(1)) // 4th
	testing.expect_value(t, spells_19[5], i8(0))

	// Immunities checks
	imm_18 := Get_Wisdom_Immunities("18")
	testing.expect_value(t, len(imm_18), 0)

	imm_19 := Get_Wisdom_Immunities("19")
	testing.expect_value(t, len(imm_19), 5)
	testing.expect_value(t, imm_19[0], "Cause Fear")

	imm_25 := Get_Wisdom_Immunities("25")
	testing.expect_value(t, len(imm_25), 26)
}

// ==========================================
// CHARISMA TESTS
// ==========================================

@(test)
test_charisma :: proc(t: ^testing.T) {
	cha_1, ok_1 := Get_Cha("1")
	testing.expect(t, ok_1, "Expected '1' to be valid")
	testing.expect_value(t, cha_1.Max_Henchman, i8(0))
	testing.expect_value(t, cha_1.Loyalty_Base, i8(-8))
	testing.expect_value(t, cha_1.React_Adj, i8(-7))

	cha_18, ok_18 := Get_Cha("18")
	testing.expect(t, ok_18, "Expected '18' to be valid")
	testing.expect_value(t, cha_18.Max_Henchman, i8(15))
	testing.expect_value(t, cha_18.Loyalty_Base, i8(8))
	testing.expect_value(t, cha_18.React_Adj, i8(7))
}

// ==========================================
// INVALID INPUT SANITY TESTS
// ==========================================

@(test)
test_invalid_inputs :: proc(t: ^testing.T) {
	// Negative and Zero bounds
	_, ok_zero := Get_Wis("0")
	testing.expect(t, !ok_zero, "'0' should return invalid")

	_, ok_neg := Get_Dex("-5")
	testing.expect(t, !ok_neg, "'-5' should return invalid")

	// Over 25 bounds
	_, ok_high := Get_Con("26")
	testing.expect(t, !ok_high, "'26' should return invalid")

	// Garbage strings
	_, ok_text := Get_Int("eighteen")
	testing.expect(t, !ok_text, "'eighteen' should return invalid")

	_, ok_empty := Get_Cha("")
	testing.expect(t, !ok_empty, "Empty string should return invalid")
}