--[[
    ╔══════════════════════════════════════╗
    ║      DUNHILL UI LIBRARY v2.0         ║
    ║   Modern UI for Roblox Executors     ║
    ║          FIXED VERSION               ║
    ╚══════════════════════════════════════╝
]]

local Dunhill = {}
Dunhill.Version = "2.0.2"
Dunhill.Flags = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local DunhillFolder = "DunhillUI"
local ConfigurationExtension = ".dhl"

local Theme = {
    Background = Color3.fromRGB(15, 15, 15),
    BackgroundSecondary = Color3.fromRGB(20, 20, 20),
    TopBar = Color3.fromRGB(18, 18, 18),
    
    Sidebar = Color3.fromRGB(22, 22, 22),
    SidebarHover = Color3.fromRGB(28, 28, 28),
    SidebarSelected = Color3.fromRGB(180, 180, 180),
    
    Primary = Color3.fromRGB(200, 200, 200),
    Secondary = Color3.fromRGB(140, 140, 140),
    Accent = Color3.fromRGB(220, 220, 220),
    
    ElementBg = Color3.fromRGB(25, 25, 25),
    ElementBgHover = Color3.fromRGB(30, 30, 30),
    ElementBorder = Color3.fromRGB(45, 45, 45),
    
    TabActive = Color3.fromRGB(60, 60, 60),
    TabInactive = Color3.fromRGB(25, 25, 25),

    Text = Color3.fromRGB(245, 245, 245),
    TextDim = Color3.fromRGB(160, 160, 160),
    TextDark = Color3.fromRGB(20, 20, 20),
    
    Success = Color3.fromRGB(80, 200, 120),
    Warning = Color3.fromRGB(255, 180, 0),
    Error = Color3.fromRGB(240, 80, 80),
    Info = Color3.fromRGB(100, 160, 255),
    
    ToggleOn = Color3.fromRGB(200, 200, 200),
    ToggleOff = Color3.fromRGB(50, 50, 50),
    
    SliderFill = Color3.fromRGB(190, 190, 190),
    SliderBg = Color3.fromRGB(35, 35, 35),
}

local function Tween(obj, props, duration, style, direction)
    duration = duration or 0.25
    style = style or Enum.EasingStyle.Quad
    direction = direction or Enum.EasingDirection.Out
    TweenService:Create(obj, TweenInfo.new(duration, style, direction), props):Play()
end

local function MakeDraggable(frame, dragHandle)
    local dragging, dragInput, dragStart, startPos
    
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

function Dunhill:CreateWindow(config)
    config = config or {}
    local WindowName = config.Name or "Dunhill"
    local LoadConfigurationOnStart = config.LoadConfigurationOnStart
    if LoadConfigurationOnStart == nil then LoadConfigurationOnStart = true end
    local ConfigurationSaving = {
        Enabled = config.ConfigurationSaving and config.ConfigurationSaving.Enabled or false,
        FolderName = config.ConfigurationSaving and config.ConfigurationSaving.FolderName or WindowName,
        FileName = config.ConfigurationSaving and config.ConfigurationSaving.FileName or "config"
    }
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "DunhillUI_" .. math.random(1000, 9999)
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    
    if gethui then
        ScreenGui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = CoreGui
    else
        ScreenGui.Parent = CoreGui
    end
    
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = UDim2.new(0, 600, 0, 400)
    Main.Position = UDim2.new(0.5, -300, 0.5, -200)
    Main.BackgroundColor3 = Theme.Background
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    Main.Parent = ScreenGui
    
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
    
    local Shadow = Instance.new("ImageLabel", Main)
    Shadow.Name = "Shadow"
    Shadow.Size = UDim2.new(1, 40, 1, 40)
    Shadow.Position = UDim2.new(0, -20, 0, -20)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://5554236805"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.4
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    Shadow.ZIndex = -1
    
    local TopBar = Instance.new("Frame", Main)
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 45)
    TopBar.BackgroundColor3 = Theme.TopBar
    TopBar.BorderSizePixel = 0
    
    local TopBarCorner = Instance.new("UICorner", TopBar)
    TopBarCorner.CornerRadius = UDim.new(0, 10)
    
    local TopBarExtend = Instance.new("Frame", TopBar)
    TopBarExtend.Size = UDim2.new(1, 0, 0, 10)
    TopBarExtend.Position = UDim2.new(0, 0, 1, -10)
    TopBarExtend.BackgroundColor3 = Theme.TopBar
    TopBarExtend.BorderSizePixel = 0
    
    local Title = Instance.new("TextLabel", TopBar)
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Position = UDim2.new(0, 20, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "⚡ " .. WindowName
    Title.TextColor3 = Theme.Accent
    Title.TextSize = 17
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    local CloseBtn = Instance.new("TextButton", TopBar)
    CloseBtn.Size = UDim2.new(0, 35, 0, 35)
    CloseBtn.Position = UDim2.new(1, -40, 0.5, -17.5)
    CloseBtn.BackgroundColor3 = Theme.ElementBg
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Theme.Error
    CloseBtn.TextSize = 18
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.AutoButtonColor = false
    CloseBtn.BorderSizePixel = 0
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)
    
    local MinBtn = Instance.new("TextButton", TopBar)
    MinBtn.Size = UDim2.new(0, 35, 0, 35)
    MinBtn.Position = UDim2.new(1, -80, 0.5, -17.5)
    MinBtn.BackgroundColor3 = Theme.ElementBg
    MinBtn.Text = "−"
    MinBtn.TextColor3 = Theme.Text
    MinBtn.TextSize = 18
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.AutoButtonColor = false
    MinBtn.BorderSizePixel = 0
    Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 8)
    
    local MinimizedIcon = Instance.new("TextButton", ScreenGui)
    MinimizedIcon.Name = "MinIcon"
    MinimizedIcon.Size = UDim2.new(0, 65, 0, 65)
    MinimizedIcon.Position = UDim2.new(0, 20, 0, 20)
    MinimizedIcon.BackgroundColor3 = Theme.TopBar
    MinimizedIcon.Text = "🎮"
    MinimizedIcon.TextSize = 32
    MinimizedIcon.Font = Enum.Font.GothamBold
    MinimizedIcon.AutoButtonColor = false
    MinimizedIcon.BorderSizePixel = 0
    MinimizedIcon.Visible = false
    Instance.new("UICorner", MinimizedIcon).CornerRadius = UDim.new(1, 0)
    
    local MinIconShadow = Instance.new("ImageLabel", MinimizedIcon)
    MinIconShadow.Size = UDim2.new(1, 30, 1, 30)
    MinIconShadow.Position = UDim2.new(0, -15, 0, -15)
    MinIconShadow.BackgroundTransparency = 1
    MinIconShadow.Image = "rbxassetid://5554236805"
    MinIconShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    MinIconShadow.ImageTransparency = 0.4
    MinIconShadow.ScaleType = Enum.ScaleType.Slice
    MinIconShadow.SliceCenter = Rect.new(23, 23, 277, 277)
    MinIconShadow.ZIndex = -1
    
    local Content = Instance.new("Frame", Main)
    Content.Name = "Content"
    Content.Size = UDim2.new(1, 0, 1, -45)
    Content.Position = UDim2.new(0, 0, 0, 45)
    Content.BackgroundTransparency = 1
    
    local Sidebar = Instance.new("ScrollingFrame", Content)
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 150, 1, -15)
    Sidebar.Position = UDim2.new(0, 10, 0, 10)
    Sidebar.BackgroundColor3 = Theme.Sidebar
    Sidebar.BorderSizePixel = 0
    Sidebar.ScrollBarThickness = 3
    Sidebar.ScrollBarImageColor3 = Theme.Primary
    Sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
    Sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 8)
    
    local SidebarLayout = Instance.new("UIListLayout", Sidebar)
    SidebarLayout.Padding = UDim.new(0, 6)
    SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    local SidebarPadding = Instance.new("UIPadding", Sidebar)
    SidebarPadding.PaddingTop = UDim.new(0, 10)
    SidebarPadding.PaddingBottom = UDim.new(0, 10)
    
    MakeDraggable(Main, TopBar)
    
    CloseBtn.MouseEnter:Connect(function() Tween(CloseBtn, {BackgroundColor3 = Theme.Error}) end)
    CloseBtn.MouseLeave:Connect(function() Tween(CloseBtn, {BackgroundColor3 = Theme.ElementBg}) end)
    CloseBtn.MouseButton1Click:Connect(function()
        Tween(Main, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        wait(0.35)
        ScreenGui:Destroy()
    end)
    
    MinBtn.MouseEnter:Connect(function() Tween(MinBtn, {BackgroundColor3 = Theme.ElementBgHover}) end)
    MinBtn.MouseLeave:Connect(function() Tween(MinBtn, {BackgroundColor3 = Theme.ElementBg}) end)
    MinBtn.MouseButton1Click:Connect(function()
        Tween(Main, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        wait(0.3)
        Main.Visible = false
        MinimizedIcon.Visible = true
        MinimizedIcon.Size = UDim2.new(0, 0, 0, 0)
        Tween(MinimizedIcon, {Size = UDim2.new(0, 65, 0, 65)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    end)
    
    MinimizedIcon.MouseButton1Click:Connect(function()
        Tween(MinimizedIcon, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        wait(0.3)
        MinimizedIcon.Visible = false
        Main.Visible = true
        Main.Size = UDim2.new(0, 0, 0, 0)
        Main.Position = UDim2.new(0.5, 0, 0.5, 0)
        Tween(Main, {Size = UDim2.new(0, 600, 0, 400), Position = UDim2.new(0.5, -300, 0.5, -200)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    end)
    
    local Window = {}
    Window.Tabs = {}
    Window.CurrentTab = nil
    
    local function SaveConfig()
        if not ConfigurationSaving.Enabled then return end
        local cfg = {}
        for flag, data in pairs(Dunhill.Flags) do
            cfg[flag] = data.CurrentValue
        end
        local success, encoded = pcall(function() return HttpService:JSONEncode(cfg) end)
        if success and writefile then
            if makefolder and not isfolder(DunhillFolder) then makefolder(DunhillFolder) end
            if makefolder and not isfolder(DunhillFolder .. "/" .. ConfigurationSaving.FolderName) then
                makefolder(DunhillFolder .. "/" .. ConfigurationSaving.FolderName)
            end
            writefile(DunhillFolder .. "/" .. ConfigurationSaving.FolderName .. "/" .. ConfigurationSaving.FileName .. ConfigurationExtension, encoded)
        end
    end
    
    local function LoadConfig()
        if not ConfigurationSaving.Enabled then return end
        local path = DunhillFolder .. "/" .. ConfigurationSaving.FolderName .. "/" .. ConfigurationSaving.FileName .. ConfigurationExtension
        if isfile and isfile(path) then
            local success, decoded = pcall(function() return HttpService:JSONDecode(readfile(path)) end)
            if success and type(decoded) == "table" then
                for flag, value in pairs(decoded) do
                    if Dunhill.Flags[flag] and Dunhill.Flags[flag].SetValue then
                        Dunhill.Flags[flag]:SetValue(value)
                    end
                end
            end
        end
    end
    
    Window.SaveConfiguration = SaveConfig
    Window.LoadConfiguration = LoadConfig
    
    function Window:CreateTab(config)
        config = config or {}
        local TabName = config.Name or "Tab"
        local TabIcon = config.Icon or "📄"
        
        local TabBtn = Instance.new("TextButton", Sidebar)
        TabBtn.Name = TabName
        TabBtn.Size = UDim2.new(1, -12, 0, 38)
        TabBtn.BackgroundColor3 = Theme.ElementBg
        TabBtn.Text = ""
        TabBtn.AutoButtonColor = false
        TabBtn.BorderSizePixel = 0
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 7)
        
        local Icon = Instance.new("TextLabel", TabBtn)
        Icon.Name = "Icon"
        Icon.Size = UDim2.new(0, 28, 1, 0)
        Icon.Position = UDim2.new(0, 8, 0, 0)
        Icon.BackgroundTransparency = 1
        Icon.Text = TabIcon
        Icon.TextColor3 = Theme.TextDim
        Icon.TextSize = 16
        Icon.Font = Enum.Font.Gotham
        
        local Label = Instance.new("TextLabel", TabBtn)
        Label.Name = "Label"
        Label.Size = UDim2.new(1, -42, 1, 0)
        Label.Position = UDim2.new(0, 36, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = TabName
        Label.TextColor3 = Theme.TextDim
        Label.TextSize = 13
        Label.Font = Enum.Font.GothamMedium
        Label.TextXAlignment = Enum.TextXAlignment.Left
        
        local TabContent = Instance.new("ScrollingFrame", Content)
        TabContent.Name = TabName .. "Content"
        TabContent.Size = UDim2.new(1, -175, 1, -15)
        TabContent.Position = UDim2.new(0, 165, 0, 10)
        TabContent.BackgroundColor3 = Theme.Background
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.ScrollBarThickness = 3
        TabContent.ScrollBarImageColor3 = Theme.Primary
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        TabContent.Visible = false
        TabContent.ClipsDescendants = true
        
        local Layout = Instance.new("UIListLayout", TabContent)
        Layout.Padding = UDim.new(0, 10)
        Layout.SortOrder = Enum.SortOrder.LayoutOrder
        
        local Padding = Instance.new("UIPadding", TabContent)
        Padding.PaddingTop = UDim.new(0, 5)
        Padding.PaddingLeft = UDim.new(0, 5)
        Padding.PaddingRight = UDim.new(0, 5)
        Padding.PaddingBottom = UDim.new(0, 5)
        
        TabBtn.MouseEnter:Connect(function()
            if Window.CurrentTab ~= TabContent then
                Tween(TabBtn, {BackgroundColor3 = Theme.SidebarHover})
            end
        end)
        
        TabBtn.MouseLeave:Connect(function()
            if Window.CurrentTab ~= TabContent then
                Tween(TabBtn, {BackgroundColor3 = Theme.ElementBg})
            end
        end)
        
        local function ActivateTab()
            for _, tab in pairs(Window.Tabs) do
                tab.Content.Visible = false
                Tween(tab.Button, {BackgroundColor3 = Theme.TabInactive})
                Tween(tab.Icon, {TextColor3 = Theme.TextDim})
                Tween(tab.Label, {TextColor3 = Theme.TextDim})
            end
            
            Window.CurrentTab = TabContent
            TabContent.Visible = true
            Tween(TabBtn, {BackgroundColor3 = Theme.TabActive})
            Tween(Icon, {TextColor3 = Theme.Text})
            Tween(Label, {TextColor3 = Theme.Text})
        end
        
        TabBtn.MouseButton1Click:Connect(ActivateTab)
        
        if #Window.Tabs == 0 then
            task.defer(ActivateTab)
        end
        
        local Tab = {
            Button = TabBtn, 
            Content = TabContent,
            Icon = Icon,
            Label = Label
        }
        table.insert(Window.Tabs, Tab)
        
        function Tab:CreateSection(config)
            config = config or {}
            local SectionName = config.Name or "Section"
            
            local Section = Instance.new("Frame", TabContent)
            Section.Name = SectionName
            Section.Size = UDim2.new(1, 0, 0, 0)
            Section.AutomaticSize = Enum.AutomaticSize.Y
            Section.BackgroundColor3 = Theme.BackgroundSecondary
            Section.BorderSizePixel = 0
            Instance.new("UICorner", Section).CornerRadius = UDim.new(0, 8)
            
            local SectionStroke = Instance.new("UIStroke", Section)
            SectionStroke.Color = Theme.ElementBorder
            SectionStroke.Thickness = 1
            SectionStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            
            local SectionPadding = Instance.new("UIPadding", Section)
            SectionPadding.PaddingTop = UDim.new(0, 12)
            SectionPadding.PaddingBottom = UDim.new(0, 12)
            SectionPadding.PaddingLeft = UDim.new(0, 12)
            SectionPadding.PaddingRight = UDim.new(0, 12)
            
            local SectionTitle = Instance.new("TextLabel", Section)
            SectionTitle.Name = "Title"
            SectionTitle.Size = UDim2.new(1, 0, 0, 22)
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Text = "▸ " .. SectionName
            SectionTitle.TextColor3 = Theme.Accent
            SectionTitle.TextSize = 14
            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            local Container = Instance.new("Frame", Section)
            Container.Name = "Container"
            Container.Size = UDim2.new(1, 0, 0, 0)
            Container.Position = UDim2.new(0, 0, 0, 28)
            Container.AutomaticSize = Enum.AutomaticSize.Y
            Container.BackgroundTransparency = 1
            
            local ContainerLayout = Instance.new("UIListLayout", Container)
            ContainerLayout.Padding = UDim.new(0, 8)
            ContainerLayout.SortOrder = Enum.SortOrder.LayoutOrder
            
            local SectionObj = {Container = Container, Frame = Section}
            
            function SectionObj:CreateLabel(config)
                config = config or {}
                local Text = config.Text or "Label"
                
                local Label = Instance.new("TextLabel", Container)
                Label.Size = UDim2.new(1, 0, 0, 0)
                Label.AutomaticSize = Enum.AutomaticSize.Y
                Label.BackgroundTransparency = 1
                Label.Text = Text
                Label.TextColor3 = Theme.TextDim
                Label.TextSize = 13
                Label.Font = Enum.Font.Gotham
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.TextWrapped = true
                
                return {
                    SetText = function(_, text) Label.Text = text end
                }
            end
            
            function SectionObj:CreateButton(config)
                config = config or {}
                local Name = config.Name or "Button"
                local Callback = config.Callback or function() end
                
                local Btn = Instance.new("TextButton", Container)
                Btn.Size = UDim2.new(1, 0, 0, 38)
                Btn.BackgroundColor3 = Theme.ElementBg
                Btn.Text = Name
                Btn.TextColor3 = Theme.Text
                Btn.TextSize = 14
                Btn.Font = Enum.Font.GothamMedium
                Btn.AutoButtonColor = false
                Btn.BorderSizePixel = 0
                Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 7)
                
                local Stroke = Instance.new("UIStroke", Btn)
                Stroke.Color = Theme.ElementBorder
                Stroke.Thickness = 1
                Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                
                Btn.MouseEnter:Connect(function()
                    Tween(Btn, {BackgroundColor3 = Theme.ElementBgHover})
                    Tween(Stroke, {Color = Theme.Primary})
                end)
                
                Btn.MouseLeave:Connect(function()
                    Tween(Btn, {BackgroundColor3 = Theme.ElementBg})
                    Tween(Stroke, {Color = Theme.ElementBorder})
                end)
                
                Btn.MouseButton1Click:Connect(function()
                    Tween(Btn, {BackgroundColor3 = Theme.Primary}, 0.1)
                    Tween(Btn, {TextColor3 = Theme.TextDark}, 0.1)
                    wait(0.1)
                    Tween(Btn, {BackgroundColor3 = Theme.ElementBgHover}, 0.1)
                    Tween(Btn, {TextColor3 = Theme.Text}, 0.1)
                    pcall(Callback)
                end)
                
                return {
                    SetText = function(_, text) Btn.Text = text end
                }
            end
            
            function SectionObj:CreateToggle(config)
                config = config or {}
                local Name = config.Name or "Toggle"
                local CurrentValue = config.CurrentValue or false
                local Flag = config.Flag
                local Callback = config.Callback or function() end
                
                local Frame = Instance.new("Frame", Container)
                Frame.Size = UDim2.new(1, 0, 0, 38)
                Frame.BackgroundColor3 = Theme.ElementBg
                Frame.BorderSizePixel = 0
                Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 7)
                
                local Stroke = Instance.new("UIStroke", Frame)
                Stroke.Color = Theme.ElementBorder
                Stroke.Thickness = 1
                Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                
                local NameLabel = Instance.new("TextLabel", Frame)
                NameLabel.Size = UDim2.new(1, -60, 1, 0)
                NameLabel.Position = UDim2.new(0, 15, 0, 0)
                NameLabel.BackgroundTransparency = 1
                NameLabel.Text = Name
                NameLabel.TextColor3 = Theme.Text
                NameLabel.TextSize = 13
                NameLabel.Font = Enum.Font.Gotham
                NameLabel.TextXAlignment = Enum.TextXAlignment.Left
                
                local ToggleBg = Instance.new("Frame", Frame)
                ToggleBg.Size = UDim2.new(0, 44, 0, 22)
                ToggleBg.Position = UDim2.new(1, -52, 0.5, -11)
                ToggleBg.BackgroundColor3 = CurrentValue and Theme.ToggleOn or Theme.ToggleOff
                ToggleBg.BorderSizePixel = 0
                Instance.new("UICorner", ToggleBg).CornerRadius = UDim.new(1, 0)
                
                local ToggleCircle = Instance.new("Frame", ToggleBg)
                ToggleCircle.Size = UDim2.new(0, 18, 0, 18)
                ToggleCircle.Position = CurrentValue and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
                ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ToggleCircle.BorderSizePixel = 0
                Instance.new("UICorner", ToggleCircle).CornerRadius = UDim.new(1, 0)
                
                local Interact = Instance.new("TextButton", Frame)
                Interact.Size = UDim2.new(1, 0, 1, 0)
                Interact.BackgroundTransparency = 1
                Interact.Text = ""
                
                Interact.MouseEnter:Connect(function()
                    Tween(Frame, {BackgroundColor3 = Theme.ElementBgHover})
                end)
                
                Interact.MouseLeave:Connect(function()
                    Tween(Frame, {BackgroundColor3 = Theme.ElementBg})
                end)
                
                local function SetValue(value)
                    CurrentValue = value
                    Tween(ToggleBg, {BackgroundColor3 = value and Theme.ToggleOn or Theme.ToggleOff})
                    Tween(ToggleCircle, {Position = value and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)})
                    if Flag then
                        Dunhill.Flags[Flag] = {CurrentValue = value, SetValue = SetValue}
                    end
                    pcall(Callback, value)
                    SaveConfig()
                end
                
                Interact.MouseButton1Click:Connect(function()
                    SetValue(not CurrentValue)
                end)
                
                if Flag then
                    Dunhill.Flags[Flag] = {CurrentValue = CurrentValue, SetValue = SetValue}
                end
                
                return {
                    CurrentValue = CurrentValue,
                    Set = SetValue,
                    SetValue = SetValue
                }
            end
            
            function SectionObj:CreateSlider(config)
                config = config or {}
                local Name = config.Name or "Slider"
                local Min = config.Min or 0
                local Max = config.Max or 100
                local Default = config.Default or Min
                local Increment = config.Increment or 1
                local Flag = config.Flag
                local Callback = config.Callback or function() end
                
                local CurrentValue = Default
                
                local Frame = Instance.new("Frame", Container)
                Frame.Size = UDim2.new(1, 0, 0, 54)
                Frame.BackgroundColor3 = Theme.ElementBg
                Frame.BorderSizePixel = 0
                Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 7)
                
                local Stroke = Instance.new("UIStroke", Frame)
                Stroke.Color = Theme.ElementBorder
                Stroke.Thickness = 1
                Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                
                local NameLabel = Instance.new("TextLabel", Frame)
                NameLabel.Size = UDim2.new(1, -60, 0, 22)
                NameLabel.Position = UDim2.new(0, 15, 0, 8)
                NameLabel.BackgroundTransparency = 1
                NameLabel.Text = Name
                NameLabel.TextColor3 = Theme.Text
                NameLabel.TextSize = 13
                NameLabel.Font = Enum.Font.Gotham
                NameLabel.TextXAlignment = Enum.TextXAlignment.Left
                
                local ValueLabel = Instance.new("TextLabel", Frame)
                ValueLabel.Size = UDim2.new(0, 50, 0, 22)
                ValueLabel.Position = UDim2.new(1, -60, 0, 8)
                ValueLabel.BackgroundTransparency = 1
                ValueLabel.Text = tostring(CurrentValue)
                ValueLabel.TextColor3 = Theme.Primary
                ValueLabel.TextSize = 13
                ValueLabel.Font = Enum.Font.GothamBold
                ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
                
                local SliderBg = Instance.new("Frame", Frame)
                SliderBg.Size = UDim2.new(1, -30, 0, 6)
                SliderBg.Position = UDim2.new(0, 15, 1, -18)
                SliderBg.BackgroundColor3 = Theme.SliderBg
                SliderBg.BorderSizePixel = 0
                Instance.new("UICorner", SliderBg).CornerRadius = UDim.new(1, 0)
                
                local SliderFill = Instance.new("Frame", SliderBg)
                SliderFill.Size = UDim2.new((CurrentValue - Min) / (Max - Min), 0, 1, 0)
                SliderFill.BackgroundColor3 = Theme.SliderFill
                SliderFill.BorderSizePixel = 0
                Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(1, 0)
                
                -- BULATAN SLIDER (THUMB)
                local SliderThumb = Instance.new("Frame", SliderBg)
                SliderThumb.Size = UDim2.new(0, 16, 0, 16)
                SliderThumb.Position = UDim2.new((CurrentValue - Min) / (Max - Min), -8, 0.5, -8)
                SliderThumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                SliderThumb.BorderSizePixel = 0
                SliderThumb.ZIndex = 2
                Instance.new("UICorner", SliderThumb).CornerRadius = UDim.new(1, 0)
                
                -- Shadow untuk bulatan
                local ThumbShadow = Instance.new("UIStroke", SliderThumb)
                ThumbShadow.Color = Theme.SliderFill
                ThumbShadow.Thickness = 2
                ThumbShadow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                
                local SliderBtn = Instance.new("TextButton", SliderBg)
                SliderBtn.Size = UDim2.new(1, 0, 3, 0)
                SliderBtn.Position = UDim2.new(0, 0, -1, 0)
                SliderBtn.BackgroundTransparency = 1
                SliderBtn.Text = ""
                SliderBtn.ZIndex = 3
                
                local Dragging = false
                
                local function SetValue(value)
                    value = math.clamp(value, Min, Max)
                    value = math.floor((value - Min) / Increment + 0.5) * Increment + Min
                    value = math.clamp(value, Min, Max)
                    CurrentValue = value
                    ValueLabel.Text = tostring(value)
                    
                    local percent = (value - Min) / (Max - Min)
                    Tween(SliderFill, {Size = UDim2.new(percent, 0, 1, 0)}, 0.1)
                    Tween(SliderThumb, {Position = UDim2.new(percent, -8, 0.5, -8)}, 0.1)
                    
                    if Flag then
                        Dunhill.Flags[Flag] = {CurrentValue = value, SetValue = SetValue}
                    end
                    pcall(Callback, value)
                    SaveConfig()
                end
                
                local function UpdateSlider(input)
                    local pos = input.Position
                    local percent = math.clamp((pos.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
                    SetValue(Min + (Max - Min) * percent)
                end
                
                -- SUPPORT PC (Mouse)
                SliderBtn.MouseButton1Down:Connect(function()
                    Dragging = true
                    Tween(SliderThumb, {Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new((CurrentValue - Min) / (Max - Min), -10, 0.5, -10)}, 0.15)
                    
                    local moveConn, releaseConn
                    
                    moveConn = UserInputService.InputChanged:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseMovement and Dragging then
                            UpdateSlider(input)
                        end
                    end)
                    
                    releaseConn = UserInputService.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            Dragging = false
                            Tween(SliderThumb, {Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new((CurrentValue - Min) / (Max - Min), -8, 0.5, -8)}, 0.15)
                            moveConn:Disconnect()
                            releaseConn:Disconnect()
                        end
                    end)
                end)
                
                -- SUPPORT MOBILE (Touch)
                SliderBtn.TouchTap:Connect(function(touchPositions)
                    if #touchPositions > 0 then
                        local touchPos = touchPositions[1]
                        local percent = math.clamp((touchPos.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
                        SetValue(Min + (Max - Min) * percent)
                    end
                end)
                
                SliderBtn.TouchLongPress:Connect(function(touchPositions)
                    if #touchPositions > 0 then
                        Dragging = true
                        Tween(SliderThumb, {Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new((CurrentValue - Min) / (Max - Min), -10, 0.5, -10)}, 0.15)
                        
                        local moveConn, releaseConn
                        
                        moveConn = UserInputService.TouchMoved:Connect(function(touch, gameProcessed)
                            if Dragging and not gameProcessed then
                                local percent = math.clamp((touch.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
                                SetValue(Min + (Max - Min) * percent)
                            end
                        end)
                        
                        releaseConn = UserInputService.TouchEnded:Connect(function(touch, gameProcessed)
                            Dragging = false
                            Tween(SliderThumb, {Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new((CurrentValue - Min) / (Max - Min), -8, 0.5, -8)}, 0.15)
                            moveConn:Disconnect()
                            releaseConn:Disconnect()
                        end)
                    end
                end)
                
                -- Input alternatif untuk mobile yang lebih responsif
                SliderBtn.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.Touch then
                        Dragging = true
                        Tween(SliderThumb, {Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new((CurrentValue - Min) / (Max - Min), -10, 0.5, -10)}, 0.15)
                        UpdateSlider(input)
                    end
                end)
                
                SliderBtn.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.Touch and Dragging then
                        UpdateSlider(input)
                    end
                end)
                
                SliderBtn.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.Touch then
                        Dragging = false
                        Tween(SliderThumb, {Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new((CurrentValue - Min) / (Max - Min), -8, 0.5, -8)}, 0.15)
                    end
                end)
                
                -- Hover effect untuk PC
                SliderBtn.MouseEnter:Connect(function()
                    if not Dragging then
                        Tween(SliderThumb, {Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new((CurrentValue - Min) / (Max - Min), -9, 0.5, -9)}, 0.15)
                    end
                end)
                
                SliderBtn.MouseLeave:Connect(function()
                    if not Dragging then
                        Tween(SliderThumb, {Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new((CurrentValue - Min) / (Max - Min), -8, 0.5, -8)}, 0.15)
                    end
                end)
                
                if Flag then
                    Dunhill.Flags[Flag] = {CurrentValue = CurrentValue, SetValue = SetValue}
                end
                
                return {
                    CurrentValue = CurrentValue,
                    Set = SetValue,
                    SetValue = SetValue
                }
            end
