# Dead But Delicious

*Every corpse is a meal. Every meal deserves a review.*

A WoW Forever and Classic Era addon for Undead characters. When you Cannibalize a corpse, your character comments on it in `/say` like a food critic, with a line that fits what you're eating:

> Murloc. Salty, with a fishy finish. Mrglrgl to you too.

> Ghost meat. Zero calories. Diet food.

> Kobold. Tastes like candle wax and bad decisions.

## How it works

Target the corpse and Cannibalize with the Dead But Delicious **key binding** (Options > Keybindings > Dead But Delicious), its **icon** (shown next to the target frame while your target is a corpse you can eat, with the cooldown on it), or a macro with `/click DeadButDeliciousButton`. One press casts Cannibalize and says the comment.

The game only lets addons talk during a key press or click, so the comment goes out with the press, just before the cast. Dead But Delicious stays quiet when the cast clearly won't work: you're moving, Cannibalize is on cooldown, or the corpse is more than about 10 yards away.

Cast Cannibalize from your own action bar and you still get a comment, but only you see it (it looks like your own `/say` line in your chat).

On Forever, in dungeons and raids the addon stays out of it (no icon, no comments): the game hides what a corpse is there, so it can't tell a meal from a raptor. Cannibalize itself works as usual. Classic Era doesn't hide anything, so there it comments everywhere.

## What it knows

- **Monsters** by name: murlocs, kobolds, gnolls, trolls, ogres, harpies, centaurs, quilboar, naga, furbolgs, troggs, goblins, gnomes, dwarves, orcs, tauren, night elves, the Defias, the Scarlet Crusade, pirates, the Syndicate, cultists, Forsaken, ghosts, skeletons and ghouls, plus a few famous names (Hogger, VanCleef, Herod).
- **Players** by race.
- **Anything else** by type (Humanoid or Undead), and a "mystery meat" line when you cast from your bar with no corpse targeted.

Edit every line, and the words that pick them, in `Data.lua`.

## Commands

Use `/cannibal` or `/foodcritic`.

| Command | Does |
|---|---|
| `/cannibal say` | Comment in `/say` (default) |
| `/cannibal emote` | Comment as an `/e` emote: *Grimbald chews thoughtfully. "Murloc. Salty."* |
| `/cannibal private` | Toggle: every comment is for your eyes only |
| `/cannibal test` | Taste your target (or the last corpse) without eating it, only you see it |
| `/cannibal reset` | Reset the icon position (Shift-drag moves it) |

## Install

Install from CurseForge or Wago, or download the zip from the [Releases](../../releases) page and extract the `DeadButDelicious` folder into one of:

```
World of Warcraft\_classic_beta_\Interface\AddOns\
World of Warcraft\_classic_era_\Interface\AddOns\
```
