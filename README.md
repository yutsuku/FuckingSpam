FuckingSpam - a World of Warcraft (1.12.1) AddOn
====================================

Installation:

Put "FuckingSpam" folder into ".../World of Warcraft/Interface/AddOns/".
Create AddOns folder if necessary

After Installation directory tree should look like the following

<pre>
World of Warcraft
`- Interface
   `- AddOns
      `- FuckingSpam
         |-- FuckingSpam.toc
         |-- README.md
         `-- core.lua

</pre>

Features:
- Filters common spamm messages out of `world` channel
- Custom words can be added by command

Commands:
- `/spam add WORD` (adds **word** to spam filter)
- `/spam remove WORD` (removes **word** from spam filter)
- `/spam list` (lists all words)

Advanced pattern matching
-------------------------------------------
Words can contain lua patterns, see [Pattern Patching](https://wow.gamepedia.com/Pattern_matching) for more info.


Known Issues:
- None.
