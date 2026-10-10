# Cricket Scoreboard Simulator

A keyboard-driven cricket scoreboard built in **8086 Assembly Language** for **CSE341 — Microprocessors**. The program runs in EMU8086 and records a two-innings match, from team setup to the final result.

The operator enters each delivery manually. The program updates batting and bowling statistics, displays the live score, and calculates the second-innings target and winning margin.

## Project structure

```text
cricket-scoreboard/
├── README.md
├── .gitignore
├── src/
│   └── 01_08_23301352_23301371_23301399.asm
└── docs/
    └── usage.md
```

- [Assembly source](src/01_08_23301352_23301371_23301399.asm): the complete program, including macros, data, and procedures.
- [Usage guide](docs/usage.md): a worked match example, scoreboard explanation, and manual checks.

## Requirements and running the program

Use an environment capable of running **EMU8086**. This is a 16-bit DOS-style program using `INT 21H` services; the `.asm` file does not run directly in a macOS or Linux terminal.

1. Download the repository or clone it:

   ```bash
   git clone https://github.com/MehediHasan19131/cricket-scoreboard.git
   cd cricket-scoreboard
   ```

2. Open EMU8086 in your supported environment. On macOS, use a Windows environment with EMU8086 available.
3. Open `src/01_08_23301352_23301371_23301399.asm` in the editor.
4. Compile/emulate the source, then run the program in the emulator.
5. Enter match information in the program's console. After the result, restart the program to play another match.

## How to use it

1. Enter Team A and Team B names, up to 10 characters each.
2. Enter the number of players per team: **2–11**.
3. Enter the overs per innings: **1–9**. An out-of-range value uses the default of **2 overs**.
4. Enter every Team A player name, then every Team B player name. Their entry order determines their player numbers, starting at **1**.
5. Press **A** or **B** to choose the team batting first. This is a manual choice, not a random toss.
6. Player 1 starts batting. At the bowler prompt, enter a player number from the opposing team.
7. Enter one ball event at a time using the controls below. After a wicket, select the next batsman by number if the side is not all out.
8. The program prints the first innings scorecard, switches batting teams, and starts the chase. It prints the second scorecard and final result when the match ends.

**Names and numeric entries require Enter. Batting-order and ball-event keys are read immediately; do not press Enter after them.** Lowercase letters are accepted. Use digits only for numeric prompts and avoid `$` in names because it terminates DOS strings.

### Delivery controls

| Key | Event | Team score | Legal delivery? |
| --- | --- | --- | --- |
| `0` | Dot ball | No change | Yes |
| `1`–`6` | Runs scored | Adds the selected runs | Yes |
| `W` | Wicket | Adds one wicket | Yes |
| `X` | Wide | Adds one extra run | No |
| `N` | No-ball | Adds one extra run | No |

Runs entered as `0`–`6` are recorded for the batsman and charged to the bowler. Wides and no-balls are charged to the bowler but do not add a ball faced to the batsman. Other ball-event keys are rejected and requested again.

## Features

1. **Match and player setup** — team names, 2–11 players per side, 1–9 overs, and fixed-width player names.
2. **Batting-order selection** — choose Team A or Team B to bat first; the other team chases.
3. **Player career profiles** — a single combined feature showing a batsman's stored career runs before batting and a bowler's stored career wickets before an over.
4. **Ball-by-ball input and validation** — keyboard entry for runs, wickets, wides, and no-balls, with retry for unsupported event keys.
5. **Live scoreboard** — total runs/wickets, overs, current batsman runs and balls, and current bowler figures after each accepted delivery.
6. **Wicket and extras handling** — records dismissals, requests a replacement batsman, and repeats the delivery slot for wides and no-balls.
7. **Innings scorecards** — batting runs, balls, fours, sixes, and status; bowling overs, runs conceded, and wickets; plus innings totals.
8. **Target and chase management** — target equals the first innings total plus one. An innings ends at the overs limit, at `players − 1` wickets, or when the chasing team reaches the target.
9. **Match result and Man of the Match** — declares a tie or a win by runs/wickets and selects the highest individual run scorer across both innings.

Six legal balls make one over. The over loop also prints an `Over complete` message when exiting early because of all-out or a completed chase; use the displayed `O.B` value for the actual number of deliveries.

## Assembly concepts used

- `.MODEL SMALL`, `.STACK`, `.DATA`, and `.CODE` organize the program.
- `DS` is initialized for data access; `DB` and `DW` hold byte and word values.
- Fixed arrays store names, career records, batting statistics, and bowling statistics.
- Each name occupies 12 bytes: 10 character/space positions and two `$` terminators.
- Match-stat arrays contain 22 slots: 11 per innings. Indexing uses `innings × 11 + player index`; word arrays use twice that offset.
- Procedures use `CALL` and `RET`; stack operations preserve registers where needed.
- Comparisons, conditional jumps, and loops control validation, deliveries, and scorecard rows.
- DOS `INT 21H` services handle keyboard input, character/string output, and program exit.
- Decimal conversion and division by six support numeric output and cricket overs notation.

## Scope and limitations

This is an educational scoreboard simulator with simplified cricket rules:

- Only one active batsman is tracked. There is no non-striker or automatic strike rotation.
- Career statistics are predefined sample values associated with player slots, not retrieved from a database or updated persistently.
- Player selection checks the numeric range but does not reject an already-dismissed batsman. Select an unused player after each wicket.
- The same bowler can be selected in consecutive overs.
- Wides and no-balls always add exactly one run. Byes, leg-byes, free hits, and different dismissal types are not implemented.
- Numeric input ignores non-digit characters and has no overflow validation. Enter only small, valid values at each prompt.
- Names are stored, but some messages identify teams simply as Team A and Team B.
- Matches are held in memory only. There is no file saving or match history.
- Man of the Match is based only on runs; equal scores retain the earliest slot in the scan.

See the [manual checks](docs/usage.md#manual-checks) for example inputs and expected outcomes. These are instructions for verification, not a claim of automated emulator testing.

## Team

| Name | Student ID |
| --- | --- |
| Mehedi Hasan | 23301352 |
| Junayed Ahmed | 23301371 |
| Md. Shakibul Islam | 23301399 |

Developed as a **CSE341 Microprocessors** course project using 8086 Assembly Language.
