# Dunhill UI Library - Project Documentation

## Overview

Dunhill is a modern, feature-rich UI library designed for Roblox executors. It provides a comprehensive set of UI components with a sleek black and silver aesthetic, smooth animations, and full configuration management.

## Project Purpose

This library enables Roblox script developers to quickly create professional-looking user interfaces for their executor scripts without having to build UI systems from scratch.

## Key Features

### User Interface
- Fully draggable main window with smooth animations
- Minimize functionality (transforms into circular 🎮 button)
- Modern black and silver color scheme
- Responsive design with smooth transitions

### Component Library
- **Basic**: Labels, Buttons, Toggles, Sliders, Input fields
- **Advanced**: Dropdowns, Keybinds, Color Pickers
- **Organization**: Tabs, Sections, Notifications

### Technical Features
- Configuration save/load system using executor file functions
- Flags system for easy value management
- Universal executor compatibility
- Automatic UI animations and transitions
- Error handling for all callbacks

## File Structure

```
/
├── Dunhill.lua         # Main library file
├── Example.lua         # Complete usage example
├── README.md           # Documentation and usage guide
└── replit.md           # This file - project documentation
```

## Recent Changes

- **2025-01-11**: Initial creation of Dunhill UI library
  - Implemented core UI framework with draggable windows
  - Created all basic and advanced components
  - Added notification system
  - Implemented configuration save/load functionality
  - Added comprehensive example file
  - Created detailed documentation

## Architecture

### Core Systems

1. **Window Management**
   - Main window with draggable topbar
   - Minimize/maximize functionality
   - Tab-based navigation system

2. **Component System**
   - Modular component architecture
   - Consistent API across all components
   - Flag-based state management

3. **Configuration System**
   - JSON-based configuration storage
   - Automatic save on value changes
   - Load on startup support

4. **Animation System**
   - TweenService-based animations
   - Consistent easing and timing
   - Smooth state transitions

### Technology Stack

- **Language**: Lua (for Roblox/Luau)
- **UI Framework**: Roblox GUI system
- **Services Used**:
  - TweenService (animations)
  - UserInputService (input handling)
  - RunService (frame updates)
  - HttpService (JSON encoding/decoding)

## Usage Context

This library is designed to be used in Roblox executor environments where users:
1. Load the library via `loadstring` and `HttpGet`
2. Create a window and configure tabs
3. Add components to sections
4. Users interact with the UI in-game

## Executor Compatibility

The library is designed to work with all major executors by:
- Checking for executor-specific functions
- Providing fallbacks for missing features
- Using standard Roblox API where possible
- Handling errors gracefully

## Future Enhancements

Potential improvements for future versions:
- Additional theme presets
- More component types (lists, grids, charts)
- Advanced color picker with gradient support
- Image/icon support
- Multi-language localization
- Plugin system for custom components
- Mobile executor support

## Development Notes

### Design Philosophy
- **Simplicity**: Easy-to-use API with minimal setup
- **Flexibility**: Customizable components with callbacks
- **Performance**: Optimized animations and updates
- **Reliability**: Error handling and fallback systems

### Code Style
- Clear, descriptive variable names
- Consistent formatting throughout
- Comments for complex logic
- Modular, reusable functions

## User Preferences

The UI library uses Indonesian language in its branding and was created with the following preferences:
- Modern, sleek design (black and silver theme)
- Full feature set comparable to or exceeding Rayfield
- GitHub-ready for public release
- Universal executor support required
