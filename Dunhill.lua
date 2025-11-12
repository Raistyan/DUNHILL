--[[
    ╔══════════════════════════════════════╗
    ║      DUNHILL UI LIBRARY v2.0         ║
    ║   Modern UI for Roblox Executors     ║
    ║    MOBILE OPTIMIZED & TAB FIXED      ║
    ╚══════════════════════════════════════╝
]]

local Dunhill = {}
Dunhill.Version = "2.0.5"
Dunhill.Flags = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local DunhillFolder = "DunhillUI"
local ConfigurationExtension = ".dhl"

-- Deteksi apakah device mobile
local IsMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled

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
    SliderThumb = Color3.fromRGB(255, 255, 255),
}

-- Helper function untuk deteksi input (mouse atau touch)
local function IsValidInput(inputType)
    return inputType == Enum.UserInputType.MouseButton1 or 
           inputType == Enum.UserInputType.Touch
end

local function IsValidMoveInput(inputType)
    return inputType == Enum.UserInputType.MouseMovement or 
           inputType == Enum.UserInputType.Touch
end

local function Tween(obj, props, duration, style, direction)
    duration = duration or 0.25
    style = style or Enum.EasingStyle.Quad
    direction = direction or Enum.EasingDirection.Out
    TweenService:Create(obj, TweenInfo.new(duration, style, direction), props):Play()
end

local function MakeDraggable(frame, dragHandle)
    local dragging = false
    local dragInput = nil
    local dragStart = nil
    local startPos = nil
    
    -- Untuk mobile, kita perlu track connection
    local inputChangedConnection = nil
    local inputEndedConnection = nil
    
    dragHandle.InputBegan:Connect(function(input)
        if IsValidInput(input.UserInputType) then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            -- Disconnect previous connections jika ada
            if inputChangedConnection then
                inputChangedConnection:Disconnect()
            end
            if inputEndedConnection then
                inputEndedConnection:Disconnect()
            end
            
            -- Track pergerakan global
            inputChangedConnection = UserInputService.InputChanged:Connect(function(input2)
                if dragging and IsValidMoveInput(input2.UserInputType) then
                    local delta = input2.Position - dragStart
                    frame.Position = UDim2.new(
                        startPos.X.Scale,
                        startPos.X.Offset + delta.X,
                        startPos.Y.Scale,
                        startPos.Y.Offset + delta.Y
                    )
                end
            end)
            
            -- Track release global
            inputEndedConnection = UserInputService.InputEnded:Connect(function(input2)
                if IsValidInput(input2.UserInputType) then
                    dragging = false
                    if inputChangedConnection then
                        inputChangedConnection:Disconnect()
                        inputChangedConnection = nil
                    end
                    if inputEndedConnection then
                        inputEndedConnection:Disconnect()
                        inputEndedConnection = nil
                    end
                end
            end)
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
    
    -- Ukuran window berbeda untuk mobile dan PC
    local WindowWidth = IsMobile and 380 or 600
    local WindowHeight = IsMobile and 320 or 400
    
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
    Main.Size = UDim2.new(0, WindowWidth, 0, WindowHeight)
    Main.Position = UDim2.new(0.5, -WindowWidth/2, 0.5, -WindowHeight/2)
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
    TopBar.Size = UDim2.new(1, 0, 0, IsMobile and 40 or 45)
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
    Title.Position = UDim2.new(0, IsMobile and 10 or 20, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "⚡ " .. WindowName
    Title.TextColor3 = Theme.Accent
    Title.TextSize = IsMobile and 14 or 17
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    local buttonSize = IsMobile and 30 or 35
    
    local CloseBtn = Instance.new("TextButton", TopBar)
    CloseBtn.Size = UDim2.new(0, buttonSize, 0, buttonSize)
    CloseBtn.Position = UDim2.new(1, -(buttonSize + 5), 0.5, -buttonSize/2)
    CloseBtn.BackgroundColor3 = Theme.ElementBg
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Theme.Error
    CloseBtn.TextSize = IsMobile and 16 or 18
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.AutoButtonColor = false
    CloseBtn.BorderSizePixel = 0
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)
    
    local MinBtn = Instance.new("TextButton", TopBar)
    MinBtn.Size = UDim2.new(0, buttonSize, 0, buttonSize)
    MinBtn.Position = UDim2.new(1, -(buttonSize*2 + 10), 0.5, -buttonSize/2)
    MinBtn.BackgroundColor3 = Theme.ElementBg
    MinBtn.Text = "−"
    MinBtn.TextColor3 = Theme.Text
    MinBtn.TextSize = IsMobile and 16 or 18
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.AutoButtonColor = false
    MinBtn.BorderSizePixel = 0
    Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 8)
    
    local iconSize = IsMobile and 55 or 65
    
    local MinimizedIcon = Instance.new("TextButton", ScreenGui)
    MinimizedIcon.Name = "MinIcon"
    MinimizedIcon.Size = UDim2.new(0, iconSize, 0, iconSize)
    MinimizedIcon.Position = UDim2.new(0, 20, 0, 20)
    MinimizedIcon.BackgroundColor3 = Theme.TopBar
    MinimizedIcon.Text = "🎮"
    MinimizedIcon.TextSize = IsMobile and 28 or 32
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
    Content.Size = UDim2.new(1, 0, 1, -(IsMobile and 40 or 45))
    Content.Position = UDim2.new(0, 0, 0, IsMobile and 40 or 45)
    Content.BackgroundTransparency = 1
    
    local sidebarWidth = IsMobile and 120 or 150
    
    local Sidebar = Instance.new("ScrollingFrame", Content)
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, sidebarWidth, 1, -15)
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
        Tween(MinimizedIcon, {Size = UDim2.new(0, iconSize, 0, iconSize)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    end)
    
    MinimizedIcon.MouseButton1Click:Connect(function()
        Tween(MinimizedIcon, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        wait(0.3)
        MinimizedIcon.Visible = false
        Main.Visible = true
        Main.Size = UDim2.new(0, 0, 0, 0)
        Main.Position = UDim2.new(0.5, 0, 0.5, 0)
        Tween(Main, {Size = UDim2.new(0, WindowWidth, 0, WindowHeight), Position = UDim2.new(0.5, -WindowWidth/2, 0.5, -WindowHeight/2)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
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
        
        local TabBtn = Instance.new("TextButton")
        TabBtn.Name = TabName
        TabBtn.Size = UDim2.new(1, -12, 0, IsMobile and 35 or 38)
        TabBtn.BackgroundColor3 = Theme.ElementBg
        TabBtn.Text = ""
        TabBtn.AutoButtonColor = false
        TabBtn.BorderSizePixel = 0
        TabBtn.Parent = Sidebar
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 7)
        
        local Icon = Instance.new("TextLabel")
        Icon.Name = "Icon"
        Icon.Size = UDim2.new(0, IsMobile and 24 or 28, 1, 0)
        Icon.Position = UDim2.new(0, IsMobile and 6 or 8, 0, 0)
        Icon.BackgroundTransparency = 1
        Icon.Text = TabIcon
        Icon.TextColor3 = Theme.TextDim
        Icon.TextSize = IsMobile and 14 or 16
        Icon.Font = Enum.Font.Gotham
        Icon.Parent = TabBtn
        
        local Label = Instance.new("TextLabel")
        Label.Name = "Label"
        Label.Size = UDim2.new(1, -(IsMobile and 34 or 42), 1, 0)
        Label.Position = UDim2.new(0, IsMobile and 30 or 36, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = TabName
        Label.TextColor3 = Theme.TextDim
        Label.TextSize = IsMobile and 11 or 13
        Label.Font = Enum.Font.GothamMedium
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.TextTruncate = Enum.TextTruncate.AtEnd
        Label.Parent = TabBtn
        
        -- PENTING: Buat TabContent dengan benar
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = TabName .. "_Content"
        TabContent.Size = UDim2.new(1, -(sidebarWidth + 20), 1, -15)
        TabContent.Position = UDim2.new(0, sidebarWidth + 15, 0, 10)
        TabContent.BackgroundColor3 = Theme.Background
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.ScrollBarThickness = 3
        TabContent.ScrollBarImageColor3 = Theme.Primary
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        TabContent.Visible = false
        TabContent.ClipsDescendants = true
        TabContent.Parent = Content -- Pastikan parent di-set
        
        local Layout = Instance.new("UIListLayout")
        Layout.Padding = UDim.new(0, 10)
        Layout.SortOrder = Enum.SortOrder.LayoutOrder
        Layout.Parent = TabContent
        
        local Padding = Instance.new("UIPadding")
        Padding.PaddingTop = UDim.new(0, 5)
        Padding.PaddingLeft = UDim.new(0, 5)
        Padding.PaddingRight = UDim.new(0, 5)
        Padding.PaddingBottom = UDim.new(0, 5)
        Padding.Parent = TabContent
        
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
                if tab.Content and tab.Content.Parent then
                    tab.Content.Visible = false
                end
                if tab.Button and tab.Button.Parent then
                    Tween(tab.Button, {BackgroundColor3 = Theme.TabInactive})
                end
                if tab.Icon and tab.Icon.Parent then
                    Tween(tab.Icon, {TextColor3 = Theme.TextDim})
                end
                if tab.Label and tab.Label.Parent then
                    Tween(tab.Label, {TextColor3 = Theme.TextDim})
                end
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
            Label = Label,
            Name = TabName
        }
        table.insert(Window.Tabs, Tab)
        
        function Tab:CreateSection(config)
            config = config or {}
            local SectionName = config.Name or "Section"
            
            -- Pastikan TabContent ada sebelum membuat Section
            if not TabContent or not TabContent.Parent then
                warn("TabContent tidak valid untuk tab: " .. TabName)
                return nil
            end
            
            -- Parent langsung ke TabContent yang benar
            local Section = Instance.new("Frame")
            Section.Name = SectionName
            Section.Size = UDim2.new(1, 0, 0, 0)
            Section.AutomaticSize = Enum.AutomaticSize.Y
            Section.BackgroundColor3 = Theme.BackgroundSecondary
            Section.BorderSizePixel = 0
            Section.Parent = TabContent -- Set parent ke TabContent yang benar
            Instance.new("UICorner", Section).CornerRadius = UDim.new(0, 8)
            
            local SectionStroke = Instance.new("UIStroke", Section)
            SectionStroke.Color = Theme.ElementBorder
            SectionStroke.Thickness = 1
            SectionStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            
            local SectionPadding = Instance.new("UIPadding", Section)
            SectionPadding.PaddingTop = UDim.new(0, IsMobile and 10 or 12)
            SectionPadding.PaddingBottom = UDim.new(0, IsMobile and 10 or 12)
            SectionPadding.PaddingLeft = UDim.new(0, IsMobile and 10 or 12)
            SectionPadding.PaddingRight = UDim.new(0, IsMobile and 10 or 12)
            
            local SectionTitle = Instance.new("TextLabel", Section)
            SectionTitle.Name = "Title"
            SectionTitle.Size = UDim2.new(1, 0, 0, IsMobile and 20 or 22)
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Text = "▸ " .. SectionName
            SectionTitle.TextColor3 = Theme.Accent
            SectionTitle.TextSize = IsMobile and 12 or 14
            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            local Container = Instance.new("Frame", Section)
            Container.Name = "Container"
            Container.Size = UDim2.new(1, 0, 0, 0)
            Container.Position = UDim2.new(0, 0, 0, IsMobile and 26 or 28)
            Container.AutomaticSize = Enum.AutomaticSize.Y
            Container.BackgroundTransparency = 1
            
            local ContainerLayout = Instance.new("UIListLayout", Container)
            ContainerLayout.Padding = UDim.new(0, IsMobile and 6 or 8)
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
                Label.TextSize = IsMobile and 11 or 13
                Label.Font = Enum.Font.Gotham
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.TextWrapped = true
                
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
                Frame.Size = UDim2.new(1, 0, 0, IsMobile and 35 or 38)
                Frame.BackgroundColor3 = Theme.ElementBg
                Frame.BorderSizePixel = 0
                Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 7)
                
                local Stroke = Instance.new("UIStroke", Frame)
                Stroke.Color = Theme.ElementBorder
                Stroke.Thickness = 1
                Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                
                local NameLabel = Instance.new("TextLabel", Frame)
                NameLabel.Size = UDim2.new(1, -55, 1, 0)
                NameLabel.Position = UDim2.new(0, IsMobile and 12 or 15, 0, 0)
                NameLabel.BackgroundTransparency = 1
                NameLabel.Text = Name
                NameLabel.TextColor3 = Theme.Text
                NameLabel.TextSize = IsMobile and 11 or 13
                NameLabel.Font = Enum.Font.Gotham
                NameLabel.TextXAlignment = Enum.TextXAlignment.Left
                NameLabel.TextTruncate = Enum.TextTruncate.AtEnd
                
                local ColorDisplay = Instance.new("TextButton", Frame)
                ColorDisplay.Size = UDim2.new(0, IsMobile and 30 or 35, 0, IsMobile and 20 or 22)
                ColorDisplay.Position = UDim2.new(1, -(IsMobile and 38 or 43), 0.5, -(IsMobile and 10 or 11))
                ColorDisplay.BackgroundColor3 = Color
                ColorDisplay.Text = ""
                ColorDisplay.AutoButtonColor = false
                ColorDisplay.BorderSizePixel = 0
                Instance.new("UICorner", ColorDisplay).CornerRadius = UDim.new(0, 5)
                
                local ColorStroke = Instance.new("UIStroke", ColorDisplay)
                ColorStroke.Color = Theme.Primary
                ColorStroke.Thickness = 1
                
                ColorDisplay.MouseButton1Click:Connect(function()
                    pcall(Callback, Color)
                end)
                
                if Flag then
                    Dunhill.Flags[Flag] = {CurrentValue = Color}
                end
                
                return {
                    SetValue = function(_, color)
                        Color = color
                        ColorDisplay.BackgroundColor3 = color
                        if Flag then
                            Dunhill.Flags[Flag] = {CurrentValue = color}
                        end
                        pcall(Callback, color)
                        SaveConfig()
                    end
                }
            end
            
            return SectionObj
        end
        
        return Tab
    end
    
    function Window:CreateNotification(config)
        config = config or {}
        local Title = config.Title or "Notification"
        local Content = config.Content or "Content"
        local Duration = config.Duration or 3
        local Type = config.Type or "Info"
        
        local Color = Theme.Info
        if Type == "Success" then Color = Theme.Success
        elseif Type == "Warning" then Color = Theme.Warning
        elseif Type == "Error" then Color = Theme.Error
        end
        
        local notifWidth = IsMobile and 280 or 320
        local notifHeight = IsMobile and 75 or 85
        
        local Notif = Instance.new("Frame", ScreenGui)
        Notif.Size = UDim2.new(0, notifWidth, 0, notifHeight)
        Notif.Position = UDim2.new(1, -(notifWidth + 20), 1, 100)
        Notif.BackgroundColor3 = Theme.BackgroundSecondary
        Notif.BorderSizePixel = 0
        Instance.new("UICorner", Notif).CornerRadius = UDim.new(0, 10)
        
        local NotifStroke = Instance.new("UIStroke", Notif)
        NotifStroke.Color = Color
        NotifStroke.Thickness = 2
        
        local NotifTitle = Instance.new("TextLabel", Notif)
        NotifTitle.Size = UDim2.new(1, -20, 0, IsMobile and 22 or 26)
        NotifTitle.Position = UDim2.new(0, 10, 0, IsMobile and 8 or 10)
        NotifTitle.BackgroundTransparency = 1
        NotifTitle.Text = Title
        NotifTitle.TextColor3 = Theme.Accent
        NotifTitle.TextSize = IsMobile and 13 or 15
        NotifTitle.Font = Enum.Font.GothamBold
        NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
        
        local NotifContent = Instance.new("TextLabel", Notif)
        NotifContent.Size = UDim2.new(1, -20, 1, -(IsMobile and 34 or 40))
        NotifContent.Position = UDim2.new(0, 10, 0, IsMobile and 30 or 36)
        NotifContent.BackgroundTransparency = 1
        NotifContent.Text = Content
        NotifContent.TextColor3 = Theme.TextDim
        NotifContent.TextSize = IsMobile and 11 or 13
        NotifContent.Font = Enum.Font.Gotham
        NotifContent.TextXAlignment = Enum.TextXAlignment.Left
        NotifContent.TextYAlignment = Enum.TextYAlignment.Top
        NotifContent.TextWrapped = true
        
        Tween(Notif, {Position = UDim2.new(1, -(notifWidth + 20), 1, -(notifHeight + 20))}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        
        task.delay(Duration, function()
            Tween(Notif, {Position = UDim2.new(1, -(notifWidth + 20), 1, 100)}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In)
            task.wait(0.5)
            Notif:Destroy()
        end)
    end
    
    if LoadConfigurationOnStart then
        LoadConfig()
    end
    
    return Window
end

return Dunhillate = Enum.TextTruncate.AtEnd
                
                local toggleWidth = IsMobile and 40 or 44
                local toggleHeight = IsMobile and 20 or 22
                
                local ToggleBg = Instance.new("Frame", Frame)
                ToggleBg.Size = UDim2.new(0, toggleWidth, 0, toggleHeight)
                ToggleBg.Position = UDim2.new(1, -(toggleWidth + 8), 0.5, -toggleHeight/2)
                ToggleBg.BackgroundColor3 = CurrentValue and Theme.ToggleOn or Theme.ToggleOff
                ToggleBg.BorderSizePixel = 0
                Instance.new("UICorner", ToggleBg).CornerRadius = UDim.new(1, 0)
                
                local circleSize = IsMobile and 16 or 18
                
                local ToggleCircle = Instance.new("Frame", ToggleBg)
                ToggleCircle.Size = UDim2.new(0, circleSize, 0, circleSize)
                ToggleCircle.Position = CurrentValue and UDim2.new(1, -(circleSize + 2), 0.5, -circleSize/2) or UDim2.new(0, 2, 0.5, -circleSize/2)
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
                    Tween(ToggleCircle, {Position = value and UDim2.new(1, -(circleSize + 2), 0.5, -circleSize/2) or UDim2.new(0, 2, 0.5, -circleSize/2)})
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
                Frame.Size = UDim2.new(1, 0, 0, IsMobile and 55 or 60)
                Frame.BackgroundColor3 = Theme.ElementBg
                Frame.BorderSizePixel = 0
                Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 7)
                
                local Stroke = Instance.new("UIStroke", Frame)
                Stroke.Color = Theme.ElementBorder
                Stroke.Thickness = 1
                Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                
                local NameLabel = Instance.new("TextLabel", Frame)
                NameLabel.Size = UDim2.new(1, -55, 0, 20)
                NameLabel.Position = UDim2.new(0, IsMobile and 12 or 15, 0, IsMobile and 6 or 8)
                NameLabel.BackgroundTransparency = 1
                NameLabel.Text = Name
                NameLabel.TextColor3 = Theme.Text
                NameLabel.TextSize = IsMobile and 11 or 13
                NameLabel.Font = Enum.Font.Gotham
                NameLabel.TextXAlignment = Enum.TextXAlignment.Left
                
                local ValueLabel = Instance.new("TextLabel", Frame)
                ValueLabel.Size = UDim2.new(0, 45, 0, 20)
                ValueLabel.Position = UDim2.new(1, -(IsMobile and 52 or 60), 0, IsMobile and 6 or 8)
                ValueLabel.BackgroundTransparency = 1
                ValueLabel.Text = tostring(CurrentValue)
                ValueLabel.TextColor3 = Theme.Primary
                ValueLabel.TextSize = IsMobile and 11 or 13
                ValueLabel.Font = Enum.Font.GothamBold
                ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
                
                local SliderBg = Instance.new("Frame", Frame)
                SliderBg.Size = UDim2.new(1, -(IsMobile and 24 or 30), 0, IsMobile and 6 or 8)
                SliderBg.Position = UDim2.new(0, IsMobile and 12 or 15, 1, -(IsMobile and 18 or 22))
                SliderBg.BackgroundColor3 = Theme.SliderBg
                SliderBg.BorderSizePixel = 0
                Instance.new("UICorner", SliderBg).CornerRadius = UDim.new(1, 0)
                
                local SliderFill = Instance.new("Frame", SliderBg)
                SliderFill.Size = UDim2.new((CurrentValue - Min) / (Max - Min), 0, 1, 0)
                SliderFill.BackgroundColor3 = Theme.SliderFill
                SliderFill.BorderSizePixel = 0
                Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(1, 0)
                
                local thumbSize = IsMobile and 14 or 16
                
                local SliderThumb = Instance.new("Frame", SliderBg)
                SliderThumb.Size = UDim2.new(0, thumbSize, 0, thumbSize)
                SliderThumb.Position = UDim2.new((CurrentValue - Min) / (Max - Min), -thumbSize/2, 0.5, -thumbSize/2)
                SliderThumb.BackgroundColor3 = Theme.SliderThumb
                SliderThumb.BorderSizePixel = 0
                SliderThumb.ZIndex = 2
                Instance.new("UICorner", SliderThumb).CornerRadius = UDim.new(1, 0)
                
                local ThumbShadow = Instance.new("UIStroke", SliderThumb)
                ThumbShadow.Color = Color3.fromRGB(0, 0, 0)
                ThumbShadow.Thickness = 2
                ThumbShadow.Transparency = 0.5
                
                local SliderBtn = Instance.new("TextButton", SliderBg)
                SliderBtn.Size = UDim2.new(1, 0, 1, IsMobile and 25 or 20)
                SliderBtn.Position = UDim2.new(0, 0, 0, -(IsMobile and 12 or 10))
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
                    Tween(SliderThumb, {Position = UDim2.new(percent, -thumbSize/2, 0.5, -thumbSize/2)}, 0.1)
                    
                    if Flag then
                        Dunhill.Flags[Flag] = {CurrentValue = value, SetValue = SetValue}
                    end
                    pcall(Callback, value)
                    SaveConfig()
                end
                
                local function GetInputPosition(input)
                    if input.UserInputType == Enum.UserInputType.Touch then
                        return input.Position
                    else
                        return UserInputService:GetMouseLocation()
                    end
                end
                
                local function Update(input)
                    local pos = GetInputPosition(input)
                    local relativeX = pos.X - SliderBg.AbsolutePosition.X
                    local percent = math.clamp(relativeX / SliderBg.AbsoluteSize.X, 0, 1)
                    SetValue(Min + (Max - Min) * percent)
                end
                
                SliderBtn.InputBegan:Connect(function(input)
                    if IsValidInput(input.UserInputType) then
                        Dragging = true
                        Tween(SliderThumb, {Size = UDim2.new(0, thumbSize + 4, 0, thumbSize + 4)}, 0.1)
                        Update(input)
                    end
                end)
                
                SliderBtn.InputChanged:Connect(function(input)
                    if Dragging and IsValidMoveInput(input.UserInputType) then
                        Update(input)
                    end
                end)
                
                SliderBtn.InputEnded:Connect(function(input)
                    if IsValidInput(input.UserInputType) and Dragging then
                        Dragging = false
                        Tween(SliderThumb, {Size = UDim2.new(0, thumbSize, 0, thumbSize)}, 0.1)
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if Dragging and IsValidMoveInput(input.UserInputType) then
                        Update(input)
                    end
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if IsValidInput(input.UserInputType) and Dragging then
                        Dragging = false
                        Tween(SliderThumb, {Size = UDim2.new(0, thumbSize, 0, thumbSize)}, 0.1)
                    end
                end)
                
                SliderBtn.MouseEnter:Connect(function()
                    if not Dragging then
                        Tween(SliderThumb, {Size = UDim2.new(0, thumbSize + 2, 0, thumbSize + 2)}, 0.15)
                    end
                end)
                
                SliderBtn.MouseLeave:Connect(function()
                    if not Dragging then
                        Tween(SliderThumb, {Size = UDim2.new(0, thumbSize, 0, thumbSize)}, 0.15)
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
            
            function SectionObj:CreateInput(config)
                config = config or {}
                local Name = config.Name or "Input"
                local PlaceholderText = config.PlaceholderText or "Enter text..."
                local RemoveTextAfterFocusLost = config.RemoveTextAfterFocusLost or false
                local Flag = config.Flag
                local Callback = config.Callback or function() end
                
                local Frame = Instance.new("Frame", Container)
                Frame.Size = UDim2.new(1, 0, 0, IsMobile and 60 or 65)
                Frame.BackgroundColor3 = Theme.ElementBg
                Frame.BorderSizePixel = 0
                Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 7)
                
                local Stroke = Instance.new("UIStroke", Frame)
                Stroke.Color = Theme.ElementBorder
                Stroke.Thickness = 1
                Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                
                local NameLabel = Instance.new("TextLabel", Frame)
                NameLabel.Size = UDim2.new(1, -(IsMobile and 24 or 30), 0, 20)
                NameLabel.Position = UDim2.new(0, IsMobile and 12 or 15, 0, IsMobile and 6 or 8)
                NameLabel.BackgroundTransparency = 1
                NameLabel.Text = Name
                NameLabel.TextColor3 = Theme.Text
                NameLabel.TextSize = IsMobile and 11 or 13
                NameLabel.Font = Enum.Font.Gotham
                NameLabel.TextXAlignment = Enum.TextXAlignment.Left
                
                local InputBox = Instance.new("TextBox", Frame)
                InputBox.Size = UDim2.new(1, -(IsMobile and 24 or 30), 0, IsMobile and 26 or 28)
                InputBox.Position = UDim2.new(0, IsMobile and 12 or 15, 0, IsMobile and 28 or 32)
                InputBox.BackgroundColor3 = Theme.SliderBg
                InputBox.Text = ""
                InputBox.PlaceholderText = PlaceholderText
                InputBox.PlaceholderColor3 = Theme.TextDim
                InputBox.TextColor3 = Theme.Text
                InputBox.TextSize = IsMobile and 11 or 13
                InputBox.Font = Enum.Font.Gotham
                InputBox.ClearTextOnFocus = false
                InputBox.BorderSizePixel = 0
                Instance.new("UICorner", InputBox).CornerRadius = UDim.new(0, 5)
                
                local InputPadding = Instance.new("UIPadding", InputBox)
                InputPadding.PaddingLeft = UDim.new(0, 10)
                InputPadding.PaddingRight = UDim.new(0, 10)
                
                InputBox.Focused:Connect(function()
                    Tween(Stroke, {Color = Theme.Primary})
                end)
                
                InputBox.FocusLost:Connect(function()
                    Tween(Stroke, {Color = Theme.ElementBorder})
                    local text = InputBox.Text
                    if Flag then
                        Dunhill.Flags[Flag] = {CurrentValue = text}
                    end
                    pcall(Callback, text)
                    if RemoveTextAfterFocusLost then
                        InputBox.Text = ""
                    end
                    SaveConfig()
                end)
                
                if Flag then
                    Dunhill.Flags[Flag] = {CurrentValue = ""}
                end
                
                return {
                    SetValue = function(_, text)
                        InputBox.Text = text
                        if Flag then
                            Dunhill.Flags[Flag] = {CurrentValue = text}
                        end
                    end
                }
            end
            
            function SectionObj:CreateDropdown(config)
                config = config or {}
                local Name = config.Name or "Dropdown"
                local Options = config.Options or {"Option 1", "Option 2"}
                local CurrentOption = config.CurrentOption or Options[1]
                local Flag = config.Flag
                local Callback = config.Callback or function() end
                
                local Frame = Instance.new("Frame", Container)
                Frame.Size = UDim2.new(1, 0, 0, IsMobile and 35 or 38)
                Frame.BackgroundColor3 = Theme.ElementBg
                Frame.BorderSizePixel = 0
                Frame.ClipsDescendants = true
                Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 7)
                
                local Stroke = Instance.new("UIStroke", Frame)
                Stroke.Color = Theme.ElementBorder
                Stroke.Thickness = 1
                Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                
                local Btn = Instance.new("TextButton", Frame)
                Btn.Size = UDim2.new(1, 0, 0, IsMobile and 35 or 38)
                Btn.BackgroundTransparency = 1
                Btn.Text = ""
                
                local NameLabel = Instance.new("TextLabel", Frame)
                NameLabel.Size = UDim2.new(1, -35, 1, 0)
                NameLabel.Position = UDim2.new(0, IsMobile and 12 or 15, 0, 0)
                NameLabel.BackgroundTransparency = 1
                NameLabel.Text = CurrentOption
                NameLabel.TextColor3 = Theme.Text
                NameLabel.TextSize = IsMobile and 11 or 13
                NameLabel.Font = Enum.Font.Gotham
                NameLabel.TextXAlignment = Enum.TextXAlignment.Left
                NameLabel.TextTruncate = Enum.TextTruncate.AtEnd
                
                local Arrow = Instance.new("TextLabel", Frame)
                Arrow.Size = UDim2.new(0, 20, 0, 20)
                Arrow.Position = UDim2.new(1, -26, 0, (IsMobile and 35 or 38)/2 - 10)
                Arrow.BackgroundTransparency = 1
                Arrow.Text = "▼"
                Arrow.TextColor3 = Theme.TextDim
                Arrow.TextSize = IsMobile and 8 or 10
                Arrow.Font = Enum.Font.Gotham
                
                local OptionsFrame = Instance.new("Frame", Frame)
                OptionsFrame.Size = UDim2.new(1, 0, 0, 0)
                OptionsFrame.Position = UDim2.new(0, 0, 0, IsMobile and 35 or 38)
                OptionsFrame.BackgroundTransparency = 1
                
                local OptionsLayout = Instance.new("UIListLayout", OptionsFrame)
                OptionsLayout.Padding = UDim.new(0, 3)
                
                local Opened = false
                
                local optionHeight = IsMobile and 24 or 25
                
                local function UpdateSize()
                    if Opened then
                        Tween(Frame, {Size = UDim2.new(1, 0, 0, (IsMobile and 35 or 38) + (#Options * optionHeight) + ((#Options - 1) * 3))})
                        Tween(Arrow, {Rotation = 180})
                    else
                        Tween(Frame, {Size = UDim2.new(1, 0, 0, IsMobile and 35 or 38)})
                        Tween(Arrow, {Rotation = 0})
                    end
                end
                
                for _, option in ipairs(Options) do
                    local OptBtn = Instance.new("TextButton", OptionsFrame)
                    OptBtn.Size = UDim2.new(1, -10, 0, optionHeight)
                    OptBtn.BackgroundColor3 = Theme.SliderBg
                    OptBtn.Text = option
                    OptBtn.TextColor3 = Theme.Text
                    OptBtn.TextSize = IsMobile and 10 or 12
                    OptBtn.Font = Enum.Font.Gotham
                    OptBtn.AutoButtonColor = false
                    OptBtn.BorderSizePixel = 0
                    Instance.new("UICorner", OptBtn).CornerRadius = UDim.new(0, 5)
                    
                    OptBtn.MouseEnter:Connect(function()
                        Tween(OptBtn, {BackgroundColor3 = Theme.ElementBgHover})
                    end)
                    
                    OptBtn.MouseLeave:Connect(function()
                        Tween(OptBtn, {BackgroundColor3 = Theme.SliderBg})
                    end)
                    
                    OptBtn.MouseButton1Click:Connect(function()
                        CurrentOption = option
                        NameLabel.Text = option
                        Opened = false
                        UpdateSize()
                        if Flag then
                            Dunhill.Flags[Flag] = {CurrentValue = option}
                        end
                        pcall(Callback, option)
                        SaveConfig()
                    end)
                end
                
                Btn.MouseButton1Click:Connect(function()
                    Opened = not Opened
                    UpdateSize()
                end)
                
                if Flag then
                    Dunhill.Flags[Flag] = {CurrentValue = CurrentOption}
                end
                
                return {
                    SetValue = function(_, option)
                        if table.find(Options, option) then
                            CurrentOption = option
                            NameLabel.Text = option
                            if Flag then
                                Dunhill.Flags[Flag] = {CurrentValue = option}
                            end
                        end
                    end,
                    Refresh = function(_, newOptions)
                        Options = newOptions
                        for _, child in ipairs(OptionsFrame:GetChildren()) do
                            if child:IsA("TextButton") then
                                child:Destroy()
                            end
                        end
                        for _, option in ipairs(Options) do
                            local OptBtn = Instance.new("TextButton", OptionsFrame)
                            OptBtn.Size = UDim2.new(1, -10, 0, optionHeight)
                            OptBtn.BackgroundColor3 = Theme.SliderBg
                            OptBtn.Text = option
                            OptBtn.TextColor3 = Theme.Text
                            OptBtn.TextSize = IsMobile and 10 or 12
                            OptBtn.Font = Enum.Font.Gotham
                            OptBtn.AutoButtonColor = false
                            OptBtn.BorderSizePixel = 0
                            Instance.new("UICorner", OptBtn).CornerRadius = UDim.new(0, 5)
                            OptBtn.MouseEnter:Connect(function() Tween(OptBtn, {BackgroundColor3 = Theme.ElementBgHover}) end)
                            OptBtn.MouseLeave:Connect(function() Tween(OptBtn, {BackgroundColor3 = Theme.SliderBg}) end)
                            OptBtn.MouseButton1Click:Connect(function()
                                CurrentOption = option
                                NameLabel.Text = option
                                Opened = false
                                UpdateSize()
                                if Flag then Dunhill.Flags[Flag] = {CurrentValue = option} end
                                pcall(Callback, option)
                                SaveConfig()
                            end)
                        end
                    end
                }
            end
            
            function SectionObj:CreateKeybind(config)
                config = config or {}
                local Name = config.Name or "Keybind"
                local CurrentKeybind = config.CurrentKeybind or "NONE"
                local Flag = config.Flag
                local Callback = config.Callback or function() end
                
                local Frame = Instance.new("Frame", Container)
                Frame.Size = UDim2.new(1, 0, 0, IsMobile and 35 or 38)
                Frame.BackgroundColor3 = Theme.ElementBg
                Frame.BorderSizePixel = 0
                Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 7)
                
                local Stroke = Instance.new("UIStroke", Frame)
                Stroke.Color = Theme.ElementBorder
                Stroke.Thickness = 1
                Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                
                local NameLabel = Instance.new("TextLabel", Frame)
                NameLabel.Size = UDim2.new(1, -(IsMobile and 65 or 75), 1, 0)
                NameLabel.Position = UDim2.new(0, IsMobile and 12 or 15, 0, 0)
                NameLabel.BackgroundTransparency = 1
                NameLabel.Text = Name
                NameLabel.TextColor3 = Theme.Text
                NameLabel.TextSize = IsMobile and 11 or 13
                NameLabel.Font = Enum.Font.Gotham
                NameLabel.TextXAlignment = Enum.TextXAlignment.Left
                NameLabel.TextTruncate = Enum.TextTruncate.AtEnd
                
                local KeyBtn = Instance.new("TextButton", Frame)
                KeyBtn.Size = UDim2.new(0, IsMobile and 55 or 60, 0, IsMobile and 24 or 26)
                KeyBtn.Position = UDim2.new(1, -(IsMobile and 60 or 68), 0.5, -(IsMobile and 12 or 13))
                KeyBtn.BackgroundColor3 = Theme.SliderBg
                KeyBtn.Text = CurrentKeybind
                KeyBtn.TextColor3 = Theme.Primary
                KeyBtn.TextSize = IsMobile and 10 or 12
                KeyBtn.Font = Enum.Font.GothamBold
                KeyBtn.AutoButtonColor = false
                KeyBtn.BorderSizePixel = 0
                Instance.new("UICorner", KeyBtn).CornerRadius = UDim.new(0, 5)
                
                local Binding = false
                
                KeyBtn.MouseButton1Click:Connect(function()
                    Binding = true
                    KeyBtn.Text = "..."
                    local conn
                    conn = UserInputService.InputBegan:Connect(function(input)
                        if Binding then
                            local key = input.KeyCode.Name
                            if key ~= "Unknown" then
                                CurrentKeybind = key
                                KeyBtn.Text = key
                                Binding = false
                                if Flag then
                                    Dunhill.Flags[Flag] = {CurrentValue = key}
                                end
                                SaveConfig()
                                conn:Disconnect()
                            end
                        end
                    end)
                end)
                
                UserInputService.InputBegan:Connect(function(input, gpe)
                    if not gpe and input.KeyCode.Name == CurrentKeybind then
                        pcall(Callback)
                    end
                end)
                
                if Flag then
                    Dunhill.Flags[Flag] = {CurrentValue = CurrentKeybind}
                end
                
                return {
                    SetValue = function(_, key)
                        CurrentKeybind = key
                        KeyBtn.Text = key
                        if Flag then
                            Dunhill.Flags[Flag] = {CurrentValue = key}
                        end
                    end
                }
            end
            
            function SectionObj:CreateColorPicker(config)
                config = config or {}
                local Name = config.Name or "Color Picker"
                local Color = config.Color or Color3.fromRGB(255, 255, 255)
                local Flag = config.Flag
                local Callback = config.Callback or function() end
                
                local Frame = Instance.new("Frame", Container)
                Frame.Size = UDim2.new(1, 0, 0, IsMobile and 35 or 38)
                Frame.BackgroundColor3 = Theme.ElementBg
                Frame.BorderSizePixel = 0
                Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 7)
                
                local Stroke = Instance.new("UIStroke", Frame)
                Stroke.Color = Theme.ElementBorder
                Stroke.Thickness = 1
                Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                
                local NameLabel = Instance.new("TextLabel", Frame)
                NameLabel.Size = UDim2.new(1, -50, 1, 0)
                NameLabel.Position = UDim2.new(0, IsMobile and 12 or 15, 0, 0)
                NameLabel.BackgroundTransparency = 1
                NameLabel.Text = Name
                NameLabel.TextColor3 = Theme.Text
                NameLabel.TextSize = IsMobile and 11 or 13
                NameLabel.Font = Enum.Font.Gotham
                NameLabel.TextXAlignment = Enum.TextXAlignment.Left
                NameLabel.TextTrunc
                    SetText = function(_, text) Label.Text = text end
                }
            end
            
            function SectionObj:CreateButton(config)
                config = config or {}
                local Name = config.Name or "Button"
                local Callback = config.Callback or function() end
                
                local Btn = Instance.new("TextButton", Container)
                Btn.Size = UDim2.new(1, 0, 0, IsMobile and 35 or 38)
                Btn.BackgroundColor3 = Theme.ElementBg
                Btn.Text = Name
                Btn.TextColor3 = Theme.Text
                Btn.TextSize = IsMobile and 12 or 14
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
