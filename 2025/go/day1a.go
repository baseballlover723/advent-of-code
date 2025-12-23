package main

import (
	"strconv"
	"strings"

	"github.com/baseballlover723/advent-of-code/go_base"
)

type Year2025Day1a struct{}

// Solve implements the logic from your Crystal `solve` method
func (d Year2025Day1a) Solve(input string) any {
	lines := strings.Split(input, "\n")
	numb_zeros := 0
	current_position := 50

	for _, line := range lines {
		direction := line[:1]
		rotations, _ := strconv.Atoi(line[1:])
		rotations %= 100

		if direction == "L" {
			rotations *= -1
		}

		current_position += rotations + 100
		current_position %= 100

		if current_position == 0 {
			numb_zeros++
		}

		//fmt.Println("current position", current_position)
	}

	return numb_zeros
}

func init() {
	go_base.Register(2025, 1, "a", func() go_base.Solver { return Year2025Day1a{} })
}

func main() {
	solver := Year2025Day1a{}
	b := &go_base.Base{Solver: solver} // Base “wraps” your solver
	b.Run("day1a.go")
}
