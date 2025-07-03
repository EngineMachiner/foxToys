[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/W7W32691S)

# foxToys

foxToys are my modules, resources, scripts and custom actors that can be added to **[OutFox](https://github.com/TeamRizu/OutFox)** like theming elements.

**[Video Example](https://youtu.be/XTOGAQQ7mzY)**

## Installation

1. Install [tapLua](https://github.com/EngineMachiner/tapLua).

### Bash

foxToys can be installed using the next bash commands in the game directory:

```console
curl -s https://raw.githubusercontent.com/EngineMachiner/bitEye/refs/heads/master/foxToys.sh | bash
```

---

Or it can be installed manually:

Be aware that to successfully add the actors, it's important that you have a basic understanding of **scripting and theme structure**.


2. Clone this repository into the modules folder.
3. Load the actors if needed using foxToys.Load() like this:
```lua
-- ScreenGameplay overlay.lua

-- Considering t is the ActorFrame, loading the combo actor for player 1 would be...

t[#t+1] = foxToys.Load( "DDR 4th/Combo", "P1" ) -- Notice that not all scripts need arguments.
```

- Some actors animations might be cut short on some screen transitions. To fix that add sleep() to those transitions.
