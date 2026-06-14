// generated-by: groundrules v1.6.0 (loop tutorial fixture)
//
// The ORACLE for the Game of Life task — the loop's deterministic back pressure.
// Pre-written before any implementation (writer != maker): it does not compile until `life.go`
// provides `func Step(g [][]bool) [][]bool`, and then fails until Step is correct. The maker makes
// `go test ./...` green; it must never edit this file to fit the implementation.
//
// Four cases, each targeting a classic pitfall:
//   block          — a still life stays put (basic survival rule)
//   block-in-corner — out-of-grid neighbours count as dead; no crash at the edge
//   blinker        — birth and death applied to the SAME snapshot (period 2)
//   glider         — simultaneous update across the whole grid (reappears shifted +1,+1 after 4 gens)

package life

import (
	"strings"
	"testing"
)

// grid builds a grid from rows of strings; 'X' = alive, anything else = dead.
func grid(rows ...string) [][]bool {
	g := make([][]bool, len(rows))
	for r, s := range rows {
		g[r] = make([]bool, len(s))
		for c := 0; c < len(s); c++ {
			g[r][c] = s[c] == 'X'
		}
	}
	return g
}

func stepN(g [][]bool, n int) [][]bool {
	for i := 0; i < n; i++ {
		g = Step(g)
	}
	return g
}

func equal(a, b [][]bool) bool {
	if len(a) != len(b) {
		return false
	}
	for r := range a {
		if len(a[r]) != len(b[r]) {
			return false
		}
		for c := range a[r] {
			if a[r][c] != b[r][c] {
				return false
			}
		}
	}
	return true
}

func render(g [][]bool) string {
	var b strings.Builder
	for _, row := range g {
		for _, cell := range row {
			if cell {
				b.WriteByte('X')
			} else {
				b.WriteByte('.')
			}
		}
		b.WriteByte('\n')
	}
	return b.String()
}

func TestBlockStillLife(t *testing.T) {
	g := grid(
		"....",
		".XX.",
		".XX.",
		"....",
	)
	want := grid(
		"....",
		".XX.",
		".XX.",
		"....",
	)
	if got := Step(g); !equal(got, want) {
		t.Fatalf("block (still life) should be unchanged, got:\n%s", render(got))
	}
}

func TestBlockInCorner(t *testing.T) {
	g := grid(
		"XX.",
		"XX.",
		"...",
	)
	want := grid(
		"XX.",
		"XX.",
		"...",
	)
	if got := Step(g); !equal(got, want) {
		t.Fatalf("corner block changed — out-of-grid neighbours must count as dead; got:\n%s", render(got))
	}
}

func TestBlinkerPeriod2(t *testing.T) {
	horizontal := grid(
		".....",
		".....",
		".XXX.",
		".....",
		".....",
	)
	vertical := grid(
		".....",
		"..X..",
		"..X..",
		"..X..",
		".....",
	)
	if got := Step(horizontal); !equal(got, vertical) {
		t.Fatalf("blinker gen 1 should be vertical, got:\n%s", render(got))
	}
	if got := stepN(horizontal, 2); !equal(got, horizontal) {
		t.Fatalf("blinker gen 2 should return to horizontal, got:\n%s", render(got))
	}
}

func TestGliderMovesDiagonally(t *testing.T) {
	start := grid(
		".X......",
		"..X.....",
		"XXX.....",
		"........",
		"........",
		"........",
		"........",
		"........",
	)
	// A glider reappears with the same shape after 4 generations, shifted by (+1 row, +1 col).
	want := make([][]bool, len(start))
	for r := range start {
		want[r] = make([]bool, len(start[r]))
	}
	for r := 0; r < len(start); r++ {
		for c := 0; c < len(start[r]); c++ {
			if start[r][c] {
				want[r+1][c+1] = true
			}
		}
	}
	if got := stepN(start, 4); !equal(got, want) {
		t.Fatalf("glider after 4 generations should be shifted by (1,1), got:\n%s", render(got))
	}
}
