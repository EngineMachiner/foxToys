[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/W7W32691S)

# foxToys

foxToys are my modules, resources, scripts and custom actors that can be added to **[OutFox](https://github.com/TeamRizu/OutFox)** like theming elements.

**[Video Example](https://youtu.be/XTOGAQQ7mzY)**

## Usage

Be aware that to successfully add the actors, it's important that you have a basic understanding of **scripting and theme structure**.

1. Use [tapLua](https://github.com/EngineMachiner/tapLua).
2. Load the actors if needed using foxToys.Load() like this:
```lua
-- ScreenGameplay overlay script file
-- t is the ActorFrame.


-- Loading the combo actor for player 1 would be...

t[#t+1] = foxToys.Load( "Actors/DDR 4th/Combo", 'P1' ) -- Notice that not all scripts need arguments.
```

- Some modules need to override theme elements to be shown and its transition times to show their animation completely.
