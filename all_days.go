package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"io/ioutil"
	"os"
	"path/filepath"
	"regexp"
	"runtime"
	"sort"
	"strconv"
	"strings"
	"time"

	"github.com/baseballlover723/advent-of-code/go_base"
)

const SLOW_THRESHOLD = 0.100

var TIMES_PATH string

func init() {
	goVersion := strings.TrimPrefix(runtime.Version(), "go")
	TIMES_PATH = fmt.Sprintf("./times_go_%s.json", goVersion)
}

// JSON data structures
type ResultData struct {
	TotalTime float64     `json:"total_time"`
	Times     int         `json:"times"`
	Result    interface{} `json:"result"` // string or int64
}

type ScriptTimes map[int]map[string]ResultData // year -> file -> result

// options
var (
	times       = flag.Int("times", 5, "Number of times per script")
	includeSlow = flag.Bool("slow", false, "Run slow scripts")
	prefix      = flag.String("prefix", "day", "Only run files that start with prefix")
	yearOpt     = flag.Int("year", -1, "Only run files for a specific year")
)

func main() {
	flag.Parse()
	fmt.Printf("Go version runner, times: %d\n", *times)

	// Scan years
	years := getYears()
	if *yearOpt != -1 {
		years = []int{*yearOpt}
	}

	// Read or initialize JSON
	timesJSON := readTimesJSON(TIMES_PATH)

	for _, year := range years {
		runYear(year, timesJSON)
	}

	writeTimesJSON(TIMES_PATH, timesJSON)
}

// Scan directories like Crystal version
func getYears() []int {
	entries, _ := os.ReadDir(".")
	var years []int
	for _, e := range entries {
		if e.IsDir() && len(e.Name()) == 4 && strings.HasPrefix(e.Name(), "20") {
			year, err := strconv.Atoi(e.Name())
			if err != nil {
				panic("invalid year in filename: " + e.Name())
			}
			years = append(years, year)
		}
	}
	sort.Ints(years)
	return years
}

// Read JSON file
func readTimesJSON(path string) ScriptTimes {
	data := ScriptTimes{}
	if _, err := os.Stat(path); err == nil {
		b, _ := ioutil.ReadFile(path)
		json.Unmarshal(b, &data)
	}
	return data
}

// Write JSON file
func writeTimesJSON(path string, data ScriptTimes) {
	b, _ := json.MarshalIndent(data, "", "  ")
	_ = ioutil.WriteFile(path, b, 0644)
}

// Run all scripts for a specific year
func runYear(year int, timesJSON ScriptTimes) {
	fmt.Printf("\nYear %s\n", year)
	if _, ok := timesJSON[year]; !ok {
		timesJSON[year] = map[string]ResultData{}
	}

	// Scan day scripts
	files := scanScripts(year, *prefix)

	totalTime := 0.0
	totalFiles := 0

	for _, file := range files {
		humanName := filepath.Base(file)
		if _, ok := timesJSON[year][humanName]; !ok {
			timesJSON[year][humanName] = ResultData{}
		}

		// Skip slow files if needed
		prev := timesJSON[year][humanName]
		if !*includeSlow && prev.Times > 0 && (prev.TotalTime/float64(prev.Times)) > SLOW_THRESHOLD {
			printTime(year, humanName, prev.TotalTime, prev.Times, prev.Result, false)
			totalTime += prev.TotalTime / float64(prev.Times)
			totalFiles++
			continue
		}

		// Read input file
		inputPath := filepath.Join(strconv.Itoa(year), "inputs", humanName[:len(humanName)-4]+"_input.txt")
		inputBytes, err := ioutil.ReadFile(inputPath)
		if err != nil {
			fmt.Println("Failed to read input:", inputPath)
			continue
		}
		input := strings.TrimSpace(string(inputBytes))

		// Instantiate solver dynamically (manual mapping in Go)
		dayPart := strings.TrimPrefix(strings.TrimSuffix(humanName, ".go"), "day")
		dayStr := dayPart[:len(dayPart)-1]
		variant := dayPart[len(dayPart)-1:]

		day, err := strconv.Atoi(dayStr)
		if err != nil {
			panic("invalid day in filename: " + dayStr)
		}
		script := go_base.GetSolver(year, day, variant)
		if script == nil {
			fmt.Println("No solver found for", humanName)
			continue
		}

		// Run benchmark
		start := time.Now()
		var result interface{}
		for i := 0; i < *times; i++ {
			result = script.Solve(input)
		}
		elapsed := time.Since(start).Seconds()

		timesJSON[year][humanName] = ResultData{
			TotalTime: elapsed,
			Times:     *times,
			Result:    result,
		}

		printTime(year, humanName, elapsed, *times, result, true)
		totalTime += elapsed / float64(*times)
		totalFiles++
	}

	fmt.Printf("Took an average of %s to run %d files (total_time: %.3f)\n",
		toHumanDuration(totalTime/float64(totalFiles)), totalFiles, totalTime)
}

// Scan scripts like all_days_macro.cr
func scanScripts(year int, prefix string) []string {
	pattern := filepath.Join(strconv.Itoa(year), "go", prefix+"*.go")
	files, _ := filepath.Glob(pattern)
	sort.Slice(files, func(i, j int) bool {
		numI := extractNumber(files[i])
		numJ := extractNumber(files[j])
		if numI == numJ {
			return files[i] < files[j]
		}
		return numI < numJ
	})
	return files
}

// Extract the number from filename like day1.cr
func extractNumber(file string) int {
	base := filepath.Base(file)
	re := regexp.MustCompile(`\d+`)
	match := re.FindString(base)
	if n, err := strconv.Atoi(match); err == nil {
		return n
	}
	return 0
}

// Print timing info
func printTime(year int, file string, totalTime float64, times int, result interface{}, ran bool) {
	fmt.Printf("%s: avg_time %.6f => %v%s\n",
		file, totalTime/float64(times), result, func() string {
			if !ran {
				return " (cached)"
			}
			return ""
		}())
}

// Convert seconds to human readable
func toHumanDuration(sec float64) string {
	d := time.Duration(sec * float64(time.Second))
	return d.String()
}
