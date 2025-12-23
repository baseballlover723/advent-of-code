package go_base

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"time"
)

type Solver interface {
	Solve(input string) any
}

type Base struct {
	Solver Solver
}

var Registry = map[int]map[int]map[string]func() Solver{}

func Register(year int, day int, variant string, constructor func() Solver) {
	fmt.Println("Registered")
	if Registry[year] == nil {
		Registry[year] = map[int]map[string]func() Solver{}
	}
	if Registry[year][day] == nil {
		Registry[year][day] = map[string]func() Solver{}
	}
	Registry[year][day][variant] = constructor
}

func GetSolver(year int, day int, variant string) Solver {
	return Registry[year][day][variant]()
}

func (b *Base) Run(fileName string) {
	fmt.Println("Running base solve")
	base := filepath.Base(fileName)
	name := strings.TrimSuffix(base, filepath.Ext(base))

	fmt.Printf("solving %q\n", name)

	// matches: file_name[0..-2] + "_input.txt"
	inputFile := "../inputs/" + name[:len(name)-1] + "_input.txt"

	data, err := os.ReadFile(inputFile)
	if err != nil {
		panic(err)
	}

	input := strings.TrimSpace(string(data))

	var result any
	start := time.Now()
	result = b.Solver.Solve(input)
	elapsed := time.Since(start)

	fmt.Println("result")
	fmt.Printf("%#v\n", result)
	fmt.Printf("time taken: %s\n", ToHumanDuration(elapsed))
}

func (b *Base) Name(typeName string) string {
	if idx := strings.LastIndex(typeName, "."); idx >= 0 {
		return strings.ToLower(typeName[idx+1:])
	}
	return strings.ToLower(typeName)
}

func (b *Base) TestRun(arg string) {
	fmt.Println(b.Solver.Solve(arg))
}

func ToHumanDuration(d time.Duration) string {
	msTotal := float64(d.Milliseconds()) + float64(d.Nanoseconds()%1e6)/1e6

	ss := int(msTotal) / 1000
	ms := msTotal - float64(ss*1000)

	mm := ss / 60
	ss %= 60

	hh := mm / 60
	mm %= 60

	dd := hh / 24
	hh %= 24

	parts := []string{}
	if dd > 0 {
		parts = append(parts, fmt.Sprintf("%d days", dd))
	}
	if hh > 0 {
		parts = append(parts, fmt.Sprintf("%d hours", hh))
	}
	if mm > 0 {
		parts = append(parts, fmt.Sprintf("%d mins", mm))
	}
	if ss > 0 {
		parts = append(parts, fmt.Sprintf("%d sec", ss))
	}
	if ms > 0 {
		parts = append(parts, fmt.Sprintf("%.3f ms", ms))
	}

	if len(parts) == 0 {
		return "0 ms"
	}
	if len(parts) == 1 {
		return parts[0]
	}

	return strings.Join(parts[:len(parts)-1], ", ") + " and " + parts[len(parts)-1]
}
