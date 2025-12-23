package main

import (
	"strconv"
	"strings"

	"github.com/baseballlover723/advent-of-code/go_base"
)

type Year2025Day1b struct{}

// Solve implements the logic from your Crystal `solve` method
func (d Year2025Day1b) Solve(input string) any {
	lines := strings.Split(input, "\n")
	numbZeros := 0
	currentPosition := 50

	for _, line := range lines {
		direction := line[:1]
		rotations, _ := strconv.Atoi(line[1:])
		//fmt.Println("\nrotations", rotations, "adding", rotations/100)
		numbZeros += rotations / 100
		rotations %= 100

		if direction == "L" {
			rotations *= -1
		}

		//fmt.Println("dir", direction, "rotations", rotations, "current position", currentPosition, "end", currentPosition+rotations)
		currentPosition += rotations

		if currentPosition > 99 {
			numbZeros += 1
			currentPosition -= 100
			//fmt.Println("adding 1")
		} else if currentPosition == 0 {
			numbZeros += 1
			//fmt.Println("adding 1")
		} else if currentPosition < 0 {
			if currentPosition != rotations {
				numbZeros += 1
			}
			//fmt.Println("adding 1")
			currentPosition += 100
		}
	}

	//fmt.Println("current position", currentPosition)
	return numbZeros
}

func init() {
	go_base.Register(2025, 1, "b", func() go_base.Solver { return Year2025Day1b{} })
}

func main() {
	solver := Year2025Day1b{}
	b := &go_base.Base{Solver: solver} // Base “wraps” your solver
	//	b.TestRun(`L68
	//L30
	//R48
	//L5
	//R60
	//L55
	//L1
	//L99
	//R14
	//L82`)
	b.Run("day1b.go")
}
