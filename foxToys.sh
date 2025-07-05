#!/bin/bash
set -e

FALLBACK="Themes/_fallback";         MODULES="Modules";

if [ -d "Appearance" ]; then

    FALLBACK="Appearance/$FALLBACK";        MODULES="$FALLBACK/$MODULES"

fi

SCRIPTS="$FALLBACK/Scripts";        FOXTOYS="$MODULES/foxToys"


# Clone repository.

REPOSITORY="https://github.com/EngineMachiner/foxToys.git"

git clone "$REPOSITORY" "$FOXTOYS"


# Add to init script.

echo "Checking initialization script...";           TAPLUA="$SCRIPTS/tapLua.lua"

echo "LoadModule(\"foxToys/foxToys.lua\")" | { grep -xFv -f "$TAPLUA" >> "$TAPLUA" || true; }


echo "Now, add the actors you want in your theme using the loading function like this:

foxToys.Load( \"DDR 4th/Combo\", \"P1\" )

Happy theming."
