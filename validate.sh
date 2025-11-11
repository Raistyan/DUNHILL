#!/bin/bash

echo "🎮 Dunhill UI Library - Syntax Validation"
echo "=========================================="
echo ""

# Validate Dunhill.lua
echo "Checking Dunhill.lua..."
if luac -p Dunhill.lua 2>&1 | grep -q "syntax error"; then
    echo "❌ Syntax error in Dunhill.lua"
    luac -p Dunhill.lua
    exit 1
else
    echo "✅ Dunhill.lua syntax is valid"
fi

# Validate Example.lua
echo "Checking Example.lua..."
if luac -p Example.lua 2>&1 | grep -q "syntax error"; then
    echo "❌ Syntax error in Example.lua"
    luac -p Example.lua
    exit 1
else
    echo "✅ Example.lua syntax is valid"
fi

echo ""
echo "=========================================="
echo "✅ All files passed syntax validation!"
echo "=========================================="
echo ""
echo "ℹ️  Note: This library is designed for Roblox executors."
echo "   To use it, upload to GitHub and load via:"
echo "   loadstring(game:HttpGet('YOUR_URL'))()
"
