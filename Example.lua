--[[
    ╔══════════════════════════════════════╗
    ║    DUNHILL UI EXAMPLE USAGE          ║
    ║  Contoh Lengkap Semua Komponen       ║
    ╚══════════════════════════════════════╝
]]

local Dunhill = loadstring(game:HttpGet("https://raw.githubusercontent.com/YourUsername/Dunhill/main/Dunhill.lua"))()

local Window = Dunhill:CreateWindow({
    Name = "Dunhill UI",
    LoadConfigurationOnStart = true,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "DunhillExample",
        FileName = "config"
    }
})

Window:CreateNotification({
    Title = "Welcome!",
    Content = "Dunhill UI berhasil dimuat",
    Duration = 4,
    Type = "Success"
})

local HomeTab = Window:CreateTab({
    Name = "Home",
    Icon = "🏠"
})

local ComponentsTab = Window:CreateTab({
    Name = "Components",
    Icon = "🔧"
})

local SettingsTab = Window:CreateTab({
    Name = "Settings",
    Icon = "⚙️"
})

local WelcomeSection = HomeTab:CreateSection({
    Name = "Welcome to Dunhill"
})

WelcomeSection:CreateLabel({
    Text = "Modern & Professional UI Library untuk Roblox Executors"
})

WelcomeSection:CreateLabel({
    Text = "Dibuat dengan design yang clean dan animasi smooth"
})

WelcomeSection:CreateButton({
    Name = "Show Success Notification",
    Callback = function()
        Window:CreateNotification({
            Title = "Success!",
            Content = "This is a success notification",
            Duration = 3,
            Type = "Success"
        })
    end
})

WelcomeSection:CreateButton({
    Name = "Show Warning Notification",
    Callback = function()
        Window:CreateNotification({
            Title = "Warning!",
            Content = "This is a warning notification",
            Duration = 3,
            Type = "Warning"
        })
    end
})

WelcomeSection:CreateButton({
    Name = "Show Error Notification",
    Callback = function()
        Window:CreateNotification({
            Title = "Error!",
            Content = "This is an error notification",
            Duration = 3,
            Type = "Error"
        })
    end
})

local BasicSection = ComponentsTab:CreateSection({
    Name = "Basic Components"
})

BasicSection:CreateButton({
    Name = "Click Me Button",
    Callback = function()
        print("Button clicked!")
        Window:CreateNotification({
            Title = "Button",
            Content = "You clicked the button!",
            Duration = 2,
            Type = "Info"
        })
    end
})

BasicSection:CreateToggle({
    Name = "Enable Feature",
    CurrentValue = false,
    Flag = "FeatureToggle",
    Callback = function(value)
        print("Toggle value:", value)
    end
})

BasicSection:CreateToggle({
    Name = "Auto Farm",
    CurrentValue = true,
    Flag = "AutoFarm",
    Callback = function(value)
        if value then
            print("Auto Farm: ON")
        else
            print("Auto Farm: OFF")
        end
    end
})

BasicSection:CreateSlider({
    Name = "Walk Speed",
    Min = 16,
    Max = 200,
    Default = 16,
    Increment = 1,
    Flag = "WalkSpeed",
    Callback = function(value)
        print("Walk Speed:", value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
})

BasicSection:CreateSlider({
    Name = "Jump Power",
    Min = 50,
    Max = 500,
    Default = 50,
    Increment = 10,
    Flag = "JumpPower",
    Callback = function(value)
        print("Jump Power:", value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
    end
})

BasicSection:CreateInput({
    Name = "Player Name",
    PlaceholderText = "Enter player name...",
    RemoveTextAfterFocusLost = false,
    Flag = "PlayerName",
    Callback = function(text)
        print("Player name entered:", text)
    end
})

BasicSection:CreateInput({
    Name = "Custom Message",
    PlaceholderText = "Type your message...",
    RemoveTextAfterFocusLost = true,
    Flag = "CustomMessage",
    Callback = function(text)
        if text ~= "" then
            Window:CreateNotification({
                Title = "Message Sent",
                Content = "Your message: " .. text,
                Duration = 3,
                Type = "Info"
            })
        end
    end
})

local AdvancedSection = ComponentsTab:CreateSection({
    Name = "Advanced Components"
})

AdvancedSection:CreateDropdown({
    Name = "Select Weapon",
    Options = {"Sword", "Gun", "Bow", "Staff", "Axe"},
    CurrentOption = "Sword",
    Flag = "WeaponChoice",
    Callback = function(option)
        print("Selected weapon:", option)
        Window:CreateNotification({
            Title = "Weapon Selected",
            Content = "You chose: " .. option,
            Duration = 2,
            Type = "Success"
        })
    end
})

AdvancedSection:CreateDropdown({
    Name = "Game Mode",
    Options = {"Easy", "Normal", "Hard", "Expert"},
    CurrentOption = "Normal",
    Flag = "GameMode",
    Callback = function(option)
        print("Game mode:", option)
    end
})

AdvancedSection:CreateKeybind({
    Name = "Toggle UI",
    CurrentKeybind = "RightControl",
    Flag = "UIToggleKey",
    Callback = function()
        print("UI toggle keybind pressed!")
        Window:CreateNotification({
            Title = "Keybind",
            Content = "Toggle UI key was pressed",
            Duration = 2,
            Type = "Info"
        })
    end
})

AdvancedSection:CreateKeybind({
    Name = "Teleport Key",
    CurrentKeybind = "E",
    Flag = "TeleportKey",
    Callback = function()
        print("Teleport!")
    end
})

AdvancedSection:CreateColorPicker({
    Name = "UI Theme Color",
    Color = Color3.fromRGB(200, 200, 200),
    Flag = "ThemeColor",
    Callback = function(color)
        print("Color selected:", color)
    end
})

AdvancedSection:CreateColorPicker({
    Name = "Highlight Color",
    Color = Color3.fromRGB(255, 100, 100),
    Flag = "HighlightColor",
    Callback = function(color)
        print("Highlight color:", color)
    end
})

local ConfigSection = SettingsTab:CreateSection({
    Name = "Configuration"
})

ConfigSection:CreateLabel({
    Text = "Manage your settings and configurations here"
})

ConfigSection:CreateButton({
    Name = "Save Configuration",
    Callback = function()
        Window.SaveConfiguration()
        Window:CreateNotification({
            Title = "Saved!",
            Content = "Configuration has been saved successfully",
            Duration = 3,
            Type = "Success"
        })
    end
})

ConfigSection:CreateButton({
    Name = "Load Configuration",
    Callback = function()
        Window.LoadConfiguration()
        Window:CreateNotification({
            Title = "Loaded!",
            Content = "Configuration has been loaded successfully",
            Duration = 3,
            Type = "Success"
        })
    end
})

local InfoSection = SettingsTab:CreateSection({
    Name = "Information"
})

InfoSection:CreateLabel({
    Text = "Dunhill UI Library v2.0"
})

InfoSection:CreateLabel({
    Text = "Made with ❤️ for Roblox Executors"
})

InfoSection:CreateButton({
    Name = "Join Discord",
    Callback = function()
        setclipboard("https://discord.gg/your-server")
        Window:CreateNotification({
            Title = "Discord",
            Content = "Discord link copied to clipboard!",
            Duration = 3,
            Type = "Info"
        })
    end
})

print("✅ Dunhill UI Example loaded successfully!")
print("📌 All components are now visible and functional")
