package Character_Sheet
import "core:fmt"

main :: proc() {
	score := "18/88"
	val, ok := Get_Strength(score)
	if ok{
		fmt.println(val)
	}
	else {
		fmt.println("Systax error hopefully")
	}
}