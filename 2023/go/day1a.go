package main

import (
	"log"
	"strconv"
	"strings"

	"github.com/baseballlover723/advent-of-code/go_base"
)

// Day1a is equivalent to your Crystal class
type Year2023Day1a struct{}

// Solve implements the logic from your Crystal `solve` method
func (d Year2023Day1a) Solve(input string) any {
	lines := strings.Split(input, "\n")
	sum := 0

	for _, line := range lines {
		digit := ""

		// Take the first numeric character
		for _, c := range line {
			if c >= '0' && c <= '9' {
				digit += string(c)
				break
			}
		}

		// Take the last numeric character
		for i := len(line) - 1; i >= 0; i-- {
			c := line[i]
			if c >= '0' && c <= '9' {
				digit += string(c)
				break
			}
		}

		// Convert digit string to integer
		num, err := strconv.Atoi(digit)
		if err != nil {
			log.Fatalf("failed to convert %q to int: %v", digit, err)
		}
		sum += num
	}

	return sum
}

func init() {
	go_base.Register(2023, 1, "a", func() go_base.Solver { return Year2023Day1a{} })
}

func main() {
	solver := Year2023Day1a{}
	b := &go_base.Base{Solver: solver} // Base “wraps” your solver
	b.Run("day1a.go")
}
