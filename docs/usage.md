# Usage guide

Open the [assembly source](../src/01_08_23301352_23301371_23301399.asm) in EMU8086, compile/emulate it, and run it. Type inputs into the program console when prompted.

## Example match

This walkthrough describes expected results calculated from the source. Enter values one prompt at a time rather than pasting them all at once.

### Match setup

| Prompt | Input |
| --- | --- |
| Team A name | Tigers, then Enter |
| Team B name | Eagles, then Enter |
| Players per team | 3, then Enter |
| Overs per innings | 1, then Enter |
| Team A players | Ali, Babu, Sami — Enter after each name |
| Team B players | Rafi, Nabil, Hasan — Enter after each name |
| Who bats first | A, without Enter |

Ali starts batting automatically. Choose Team B bowler **1** (Rafi), then press Enter.

### First innings

At successive `Ball:` prompts, press these six keys individually without Enter:

```text
1  2  0  4  1  2
```

The total is **10/0 after 1.0 overs**. Ali scores 10 from six balls, with one four. Rafi's figures are one over, 10 runs, and zero wickets. The program prints the innings scorecard and stores a target of **11**.

### Second innings

Rafi now starts batting for Team B. Choose Team A bowler **1** (Ali), then press Enter.

Enter these delivery keys individually:

```text
4  6  1
```

After the second ball, the score is **10/0**, so the chase continues. After the third ball, it is **11/0 after 0.3 overs**, so the target is reached. Team B wins by **2 wickets**, because each team has three players and no wickets were lost. Rafi is the highest scorer with 11 runs.

## Understanding the scoreboard

- `10/1` means 10 team runs and one wicket lost.
- `0.3` means zero complete overs and three legal balls. It is not a decimal fraction of an over.
- `1.0` means six legal balls have been bowled.
- The batsman entry shows the player's runs and balls faced.
- The bowler entry shows `overs-runs-wickets`.
- In the batting scorecard, `R` is runs, `B` is balls faced, `4s` and `6s` count boundaries, and `St` is status.
- `OUT` means dismissed, `NO` means not out, and `DNB` means did not bat.

## Wickets and extras

Pressing `W` records a legal ball, increases the wicket count, marks the current batsman out, and credits the bowler. If fewer than `players − 1` wickets have fallen, enter the number of an unused batsman at the next prompt. Player numbers follow the order in which you entered the names.

Pressing `X` or `N` adds one run to the team and bowler figures. The legal-ball count stays unchanged, so another input is needed for that delivery slot. The two event keys share the same scoring logic in this implementation.

## Manual checks

Restart the program for each independent match test.

| Check | Input or scenario | Expected behavior |
| --- | --- | --- |
| Correct target | First innings 10; chasing side reaches 10 | Chase continues until 11, unless overs or wickets end it |
| Wide | Press X | One run added; legal-ball count unchanged |
| No-ball | Press N | One run added; legal-ball count unchanged |
| Invalid event | Press Z at a ball prompt | Error message and another ball prompt; score unchanged |
| Lowercase input | Press x | Same scoring as X |
| All out | Two players per side; press W | Innings ends after that wicket |
| Tie | One over each; enter six 0 keys in each innings | Both teams finish on zero; match tied |
| Defending win | Team A scores 10; Team B finishes on 8 | Team A wins by 2 runs |
| Player-count range | Enter 1 or 12 at setup | Player-count prompt repeats |
| Overs fallback | Enter 0 or 10 for overs | Uses 2 overs |

## Common input issues

- Press Enter after names, player counts, overs, and player indexes.
- Do not press Enter after A/B batting-order selection or individual ball-event keys. These use single-character input; leftover Enter characters may affect a later buffered numeric prompt.
- Use player numbers from 1 to the selected squad size, not zero-based indexes.
- Keep names to 10 characters. Additional characters are not copied into the saved name slot.
- Avoid `$` in names because DOS string printing stops at that character.
- Restart the program in EMU8086 to reset the match; there is no replay menu.
