# ⚡ Dunhill UI Library v2.0

**Modern, Professional UI Library untuk Roblox Executors**

Tampilan yang clean, smooth animations, dan full-featured components - Built untuk memberikan pengalaman UI terbaik di Roblox executors.

![Version](https://img.shields.io/badge/version-2.0.0-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![Roblox](https://img.shields.io/badge/platform-Roblox-red)

## ✨ Features

- 🎯 **Draggable Interface** - Smooth drag & drop functionality
- 📦 **Minimize System** - Minimize ke circular button dengan emoji 🎮
- 🎨 **Modern Design** - Clean black & silver theme yang profesional
- 📂 **Tab System** - Organize UI dengan tabs dan sections
- 💾 **Auto Save** - Configuration system yang otomatis save settings
- 🔔 **Notifications** - Beautiful notification dengan 4 tipe (Success, Warning, Error, Info)
- 🚀 **Smooth Animations** - Semua transisi menggunakan smooth tweening
- 🛡️ **Universal Support** - Compatible dengan semua executor populer

## 📦 Components

### Basic Components
- ✅ **Label** - Text display
- ✅ **Button** - Interactive buttons dengan hover effects
- ✅ **Toggle** - On/off switches dengan smooth animation
- ✅ **Slider** - Value sliders dengan real-time feedback
- ✅ **Input** - Text input fields dengan validation

### Advanced Components
- ✅ **Dropdown** - Selection menus dengan smooth expand/collapse
- ✅ **Keybind** - Key binding selector
- ✅ **ColorPicker** - Color selection display
- ✅ **Section** - Organize components dalam sections
- ✅ **Notification** - Toast notifications dengan auto-dismiss

## 🚀 Quick Start

### Loading the Library

```lua
local Dunhill = loadstring(game:HttpGet("https://raw.githubusercontent.com/YourUsername/Dunhill/main/Dunhill.lua"))()
```

### Creating a Window

```lua
local Window = Dunhill:CreateWindow({
    Name = "My Script",
    LoadConfigurationOnStart = true,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "MyScript",
        FileName = "config"
    }
})
```

### Creating Tabs and Sections

```lua
local Tab = Window:CreateTab({
    Name = "Main",
    Icon = "🏠"
})

local Section = Tab:CreateSection({
    Name = "Features"
})
```

### Adding Components

```lua
Section:CreateButton({
    Name = "Click Me",
    Callback = function()
        print("Button clicked!")
    end
})

Section:CreateToggle({
    Name = "Enable Feature",
    CurrentValue = false,
    Flag = "MyToggle",
    Callback = function(value)
        print("Toggle:", value)
    end
})

Section:CreateSlider({
    Name = "Speed",
    Min = 16,
    Max = 200,
    Default = 16,
    Increment = 1,
    Flag = "Speed",
    Callback = function(value)
        print("Speed:", value)
    end
})
```

## 📖 Complete Documentation

### Window Configuration

```lua
Dunhill:CreateWindow({
    Name = "Window Title",              -- Window title
    LoadConfigurationOnStart = true,    -- Auto load saved config
    ConfigurationSaving = {
        Enabled = true,                 -- Enable config save/load
        FolderName = "FolderName",      -- Config folder name
        FileName = "config"             -- Config file name
    }
})
```

### Tab Creation

```lua
Window:CreateTab({
    Name = "Tab Name",      -- Tab name
    Icon = "🏠"            -- Tab icon (emoji)
})
```

### Section Creation

```lua
Tab:CreateSection({
    Name = "Section Name"   -- Section header text
})
```

### Component API

#### Label
```lua
Section:CreateLabel({
    Text = "Your text here"
})
```

#### Button
```lua
Section:CreateButton({
    Name = "Button Name",
    Callback = function()
        -- Your code
    end
})
```

#### Toggle
```lua
Section:CreateToggle({
    Name = "Toggle Name",
    CurrentValue = false,       -- Initial state
    Flag = "ToggleFlag",        -- Optional: for saving
    Callback = function(value)
        -- value is true/false
    end
})
```

#### Slider
```lua
Section:CreateSlider({
    Name = "Slider Name",
    Min = 0,                    -- Minimum value
    Max = 100,                  -- Maximum value
    Default = 50,               -- Default value
    Increment = 1,              -- Step size
    Flag = "SliderFlag",        -- Optional: for saving
    Callback = function(value)
        -- value is number
    end
})
```

#### Input
```lua
Section:CreateInput({
    Name = "Input Name",
    PlaceholderText = "Enter text...",
    RemoveTextAfterFocusLost = false,   -- Clear after unfocus
    Flag = "InputFlag",                  -- Optional: for saving
    Callback = function(text)
        -- text is string
    end
})
```

#### Dropdown
```lua
Section:CreateDropdown({
    Name = "Dropdown Name",
    Options = {"Option 1", "Option 2", "Option 3"},
    CurrentOption = "Option 1",
    Flag = "DropdownFlag",      -- Optional: for saving
    Callback = function(option)
        -- option is selected string
    end
})
```

#### Keybind
```lua
Section:CreateKeybind({
    Name = "Keybind Name",
    CurrentKeybind = "E",       -- Default key
    Flag = "KeybindFlag",       -- Optional: for saving
    Callback = function()
        -- Triggered when key is pressed
    end
})
```

#### ColorPicker
```lua
Section:CreateColorPicker({
    Name = "Color Name",
    Color = Color3.fromRGB(255, 255, 255),
    Flag = "ColorFlag",         -- Optional: for saving
    Callback = function(color)
        -- color is Color3
    end
})
```

### Notifications

```lua
Window:CreateNotification({
    Title = "Title",
    Content = "Your message here",
    Duration = 3,               -- Seconds
    Type = "Success"            -- Success, Warning, Error, Info
})
```

### Flags System

Save and access component values:

```lua
-- Get value
local value = Dunhill.Flags["MyFlag"].CurrentValue

-- Set value programmatically
Dunhill.Flags["MyToggle"]:SetValue(true)
```

### Manual Configuration

```lua
-- Save configuration
Window.SaveConfiguration()

-- Load configuration
Window.LoadConfiguration()
```

## 🎨 Design Philosophy

Dunhill UI dibuat dengan fokus pada:

- **Clean Design** - Interface yang tidak berantakan
- **Professional Look** - Tampilan yang serius dan modern
- **Smooth Experience** - Animasi yang halus di semua interaksi
- **Easy to Use** - API yang simple dan straightforward
- **Fully Featured** - Semua komponen yang dibutuhkan tersedia

## 🔧 Executor Compatibility

Dunhill UI kompatibel dengan semua major executors:

- ✅ Synapse X / Synapse Z
- ✅ Script-Ware
- ✅ Krnl
- ✅ Fluxus
- ✅ Oxygen U
- ✅ Arceus X
- ✅ Delta
- ✅ Solara
- ✅ Dan executor lainnya!

Library secara otomatis mendeteksi executor-specific functions dan menggunakan fallback yang sesuai.

## 📝 Example

Lihat `Example.lua` untuk contoh lengkap penggunaan semua komponen.

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/YourUsername/Dunhill/main/Example.lua"))()
```

## 🎯 Key Features Highlight

### 1. Drag & Drop
Window bisa di-drag dengan smooth movement dan positioning yang akurat.

### 2. Minimize System
Click minimize button untuk collapse UI menjadi circular button dengan emoji 🎮. Click lagi untuk restore.

### 3. Configuration System
Semua nilai dengan `Flag` otomatis disimpan dan dimuat kembali saat startup.

### 4. Smooth Animations
Semua transisi menggunakan TweenService untuk animasi yang smooth dan profesional.

### 5. Modern UI Design
Black & silver color scheme dengan proper spacing dan clean layout.

## 📋 To-Do / Future Features

- [ ] Color picker dengan RGB sliders
- [ ] Multi-dropdown (select multiple)
- [ ] Custom themes support
- [ ] Image/icon support
- [ ] Paragraph text component
- [ ] Progress bar component
- [ ] Graph/chart visualization

## 🤝 Contributing

Contributions welcome! Feel free to:
- Report bugs
- Suggest features
- Submit pull requests
- Improve documentation

## 📄 License

This project is licensed under the MIT License.

## 💬 Support

Jika ada pertanyaan atau issue:
1. Open an issue di GitHub
2. Sertakan informasi executor yang digunakan
3. Berikan contoh code yang menyebabkan issue

---

**Made with ❤️ by Dunhill**

*Modern UI for Modern Scripts*
