local Mach = loadstring(game:HttpGet("https://raw.githubusercontent.com/Raistyan/DUNHILL/refs/heads/main/NewUI.lua"))()

-- Create Window
local Window = Mach:Window({
    Title = "Mach Fishing",
    Footer = "| Free Not For Sale",
    Color = Color3.fromRGB(255, 50, 50),
    ["Tab Width"] = 130,
    Version = 1,
    Image = "112076193091563" -- Icon untuk toggle button
})

-- Create Tab
local FarmTab = Window:AddTab({
    Name = "Fishing",
    Icon = "fish" -- atau gunakan "121452933704464"
})

-- ==========================================
-- 🎣 FISHING CONTROLS SECTION
-- ==========================================
local FishingSection = FarmTab:AddSection("Fishing Controls")

-- 🧠 Variabel utama
local cancelDelay = 0
local waitDelay = 0
local autoFishing = false
local blatanFishing = false

-- 📡 Service & Remote references
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
if not player then
    repeat task.wait() until Players.LocalPlayer
    player = Players.LocalPlayer
end

local character = player.Character
if not character then
    character = player.CharacterAdded:Wait()
end

local humanoid = character:WaitForChild("Humanoid", 10)
local hrp = character:WaitForChild("HumanoidRootPart", 10)

local remotes = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")
local chargeRod = remotes:WaitForChild("RF/ChargeFishingRod")
local startFishing = remotes:WaitForChild("RF/RequestFishingMinigameStarted")
local finishFishing = remotes:WaitForChild("RE/FishingCompleted")
local cancelFishing = remotes:WaitForChild("RF/CancelFishingInputs")

-- 🎣 Fungsi utama auto fishing
local function doFishing()
    while autoFishing do
        chargeRod:InvokeServer()
        task.wait(0.3)
        startFishing:InvokeServer(-1.233184814453125, 0.06081610394009457, 1762887821.300317)
        task.wait(waitDelay)
        finishFishing:FireServer()
        task.wait(cancelDelay)
        cancelFishing:InvokeServer()
    end
end

-- ⚡ MODE BLATAN (DOUBLE REMOTE)
local function doFishingBlatan()
    while blatanFishing do
        pcall(function()
            spawn(function()
                chargeRod:InvokeServer(1)
                startFishing:InvokeServer(
                    math.random(-1, 1),
                    1,
                    math.random(1000000, 9999999)
                )
            end)
            
            task.wait(waitDelay)
            finishFishing:FireServer()
            
            task.wait(cancelDelay)
            cancelFishing:InvokeServer()
        end)
    end
end

-- Toggle Auto Fishing
FishingSection:AddToggle({
    Title = "Auto Fishing",
    Content = "Automatic fishing mode",
    Default = false,
    Callback = function(state)
        autoFishing = state
        if state then
            print("🎣 Auto Fishing Started")
            task.spawn(doFishing)
        else
            print("🛑 Auto Fishing Stopped")
        end
    end
})

-- Toggle Blatan Mode
FishingSection:AddToggle({
    Title = "Blatan Mode 2X",
    Content = "Double speed fishing",
    Default = false,
    Callback = function(state)
        blatanFishing = state
        if state then
            print("⚡ Blatan Auto Fishing Started")
            task.spawn(doFishingBlatan)
        else
            print("🛑 Blatan Auto Fishing Stopped")
        end
    end
})

-- Input Wait Delay
FishingSection:AddInput({
    Title = "Wait Delay",
    Content = "Delay sebelum finish (detik)",
    Default = "0.1",
    Callback = function(text)
        local num = tonumber(text)
        if num then
            waitDelay = num
            print("WaitDelay =", waitDelay)
        else
            print("❌ Input WaitDelay harus angka!")
        end
    end
})

-- Input Cancel Delay
FishingSection:AddInput({
    Title = "Cancel Delay",
    Content = "Delay setelah finish (detik)",
    Default = "0.1",
    Callback = function(text)
        local num = tonumber(text)
        if num then
            cancelDelay = num
            print("CancelDelay =", cancelDelay)
        else
            print("❌ Input CancelDelay harus angka!")
        end
    end
})

-- ==========================================
-- 🔥 BLATANT SUPER V1 SECTION
-- ==========================================
local BlatantV1Section = FarmTab:AddSection("Blatant Super V1")

local BlatantFishingDelay = 0.70
local BlatantCancelDelay = 0.30
local AutoFishEnabled = false

local function safeFire(func)
    task.spawn(function()
        pcall(func)
    end)
end

local function UltimateBypassFishing()
    task.spawn(function()
        while AutoFishEnabled do
            local currentTime = workspace:GetServerTimeNow()
            
            safeFire(function()
                chargeRod:InvokeServer({[1] = currentTime})
            end)
            task.wait(0.001)
            safeFire(function()
                startFishing:InvokeServer(1, 0, currentTime)
            end)
            
            task.wait(BlatantFishingDelay)
            
            safeFire(function()
                finishFishing:FireServer()
            end)
            
            task.wait(BlatantCancelDelay)
            
            safeFire(function()
                cancelFishing:InvokeServer()
            end)
        end
    end)
end

BlatantV1Section:AddInput({
    Title = "Fish Delay V1",
    Content = "Delay fishing V1",
    Default = "0.70",
    Callback = function(value)
        local num = tonumber(value)
        if num then
            BlatantFishingDelay = num
            print("🎣 Fish Delay:", num)
        end
    end
})

BlatantV1Section:AddInput({
    Title = "Cancel Delay V1",
    Content = "Delay cancel V1",
    Default = "0.30",
    Callback = function(value)
        local num = tonumber(value)
        if num then
            BlatantCancelDelay = num
            print("⏱️ Cancel Delay:", num)
        end
    end
})

BlatantV1Section:AddToggle({
    Title = "Enable Blatant Super V1",
    Content = "Ultra fast fishing mode",
    Default = false,
    Callback = function(state)
        AutoFishEnabled = state
        if state then
            print("🟢 BLATANT V1: ON")
            UltimateBypassFishing()
        else
            print("🔴 BLATANT V1: OFF")
        end
    end
})

-- ==========================================
-- 🔥 BLATANT SUPER V2 SECTION
-- ==========================================
local BlatantV2Section = FarmTab:AddSection("Blatant Super V2")

local BlatantFishingDelayV2 = 0.36
local BlatantCancelDelayV2 = 0.30
local AutoFishEnabledV2 = false

local function safeFireV2(func)
    task.spawn(function()
        pcall(func)
    end)
end

local function UltimateBypassFishingV2()
    task.spawn(function()
        while AutoFishEnabledV2 do
            local currentTime = workspace:GetServerTimeNow()
            
            safeFireV2(function()
                chargeRod:InvokeServer({[1] = currentTime})
            end)
            task.wait(0.001)
            safeFireV2(function()
                startFishing:InvokeServer(1, 0, currentTime)
            end)
            
            task.wait(BlatantFishingDelayV2)
            
            safeFireV2(function()
                finishFishing:FireServer()
            end)
            
            task.wait(BlatantCancelDelayV2)
            
            safeFireV2(function()
                cancelFishing:InvokeServer()
            end)
            task.wait(0.080)
        end
    end)
end

BlatantV2Section:AddInput({
    Title = "Fish Delay V2",
    Content = "Delay fishing V2",
    Default = "0.36",
    Callback = function(value)
        local num = tonumber(value)
        if num then
            BlatantFishingDelayV2 = num
            print("🎣 V2 Fish Delay:", num)
        end
    end
})

BlatantV2Section:AddInput({
    Title = "Cancel Delay V2",
    Content = "Delay cancel V2",
    Default = "0.30",
    Callback = function(value)
        local num = tonumber(value)
        if num then
            BlatantCancelDelayV2 = num
            print("⏱️ V2 Cancel Delay:", num)
        end
    end
})

BlatantV2Section:AddToggle({
    Title = "Enable Blatant Super V2",
    Content = "Ultra fast fishing V2",
    Default = false,
    Callback = function(state)
        AutoFishEnabledV2 = state
        if state then
            print("🟢 BLATANT V2: ON")
            UltimateBypassFishingV2()
        else
            print("🔴 BLATANT V2: OFF")
        end
    end
})

-- ==========================================
-- 🛠️ SUPPORT FEATURES SECTION
-- ==========================================
local SupportSection = FarmTab:AddSection("Support Features")

-- 🐟 Block Animations
local disableAnim = false
local idleTrack = nil

local blockedAnims = { 
    "fish", "fishing", "rod", "cast", "reel", "hold",
    "throw", "caught", "charge"
}

local EQUIPIDLE_IDS = {
    "96586569072385", "108792932396384", "77549515147440",
    "84686809448947", "110434285817259", "115119558523816",
    "83219020397849", "103714544264522", "123194574699925",
    "124265469726043", "81302570422307", "93958525241489",
    "103641983335689", "79754634120924", "130474623877752",
    "79263851052023", "105569745192317", "79066316609985",
    "77452908864699", "82781088583962", "111118151202469",
    "131643088615283", "90021589040653", "106017647759827",
    "97171752999251", "101986838283328",
}

local function isEquipIdleAnimation(obj)
    if not obj then return false end
    
    local animId = ""
    
    if obj:IsA("Animation") then
        animId = obj.AnimationId or ""
    elseif type(obj) == "table" and obj.Animation then
        animId = obj.Animation.AnimationId or ""
    end
    
    for _, equipId in ipairs(EQUIPIDLE_IDS) do
        if string.find(animId, equipId) then
            return true
        end
    end
    
    return false
end

local function isFishingAnimation(obj)
    if not obj then return false end
    
    local name = string.lower(obj.Name or "")
    
    for _, v in ipairs(blockedAnims) do
        if string.find(name, v) then
            return true
        end
    end
    
    if isEquipIdleAnimation(obj) then
        return true
    end
    
    return false
end

local function loadIdleAnimation(char)
    local humanoid = char:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    local animator = humanoid:FindFirstChildOfClass("Animator")
    if not animator then
        animator = Instance.new("Animator", humanoid)
    end
    
    if idleTrack then
        pcall(function()
            idleTrack:Stop()
            idleTrack:Destroy()
        end)
        idleTrack = nil
    end
    
    local idleAnim = Instance.new("Animation")
    idleAnim.AnimationId = "rbxassetid://507766666"
    idleAnim.Name = "CharacterIdle"
    
    idleTrack = animator:LoadAnimation(idleAnim)
    idleTrack.Priority = Enum.AnimationPriority.Action4
    idleTrack.Looped = true
    
    task.wait(0.1)
    idleTrack:Play(0.2, 1, 1)
    
    print("🗿 Default Idle loaded")
end

local function hookAnimator(char)
    local humanoid = char:WaitForChild("Humanoid", 2)
    if not humanoid then return end

    local animator = humanoid:FindFirstChildOfClass("Animator")
    if not animator then
        animator = Instance.new("Animator", humanoid)
    end

    animator.AnimationPlayed:Connect(function(track)
        if disableAnim and isFishingAnimation(track.Animation) then
            task.defer(function()
                track:Stop(0)
                
                if idleTrack and not idleTrack.IsPlaying then
                    task.wait(0.05)
                    pcall(function()
                        idleTrack:Play(0.2, 1, 1)
                    end)
                end
            end)
        end
    end)
end

local function hookTools(char)
    char.ChildAdded:Connect(function(child)
        if not disableAnim then return end
        
        if child:IsA("Tool") then
            task.spawn(function()
                for _, v in ipairs(child:GetDescendants()) do
                    if v:IsA("Animation") then
                        pcall(function() v:Destroy() end)
                    end
                end

                local humanoid = char:FindFirstChild("Humanoid")
                if humanoid then
                    for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
                        if track ~= idleTrack and isFishingAnimation(track.Animation) then
                            track:Stop(0)
                        end
                    end
                end
                
                if idleTrack and not idleTrack.IsPlaying then
                    task.wait(0.1)
                    pcall(function()
                        idleTrack:Play(0.2, 1, 1)
                    end)
                end
            end)
        end
    end)
end

local idleCheckerTask = nil

local function startIdleChecker()
    if idleCheckerTask then
        task.cancel(idleCheckerTask)
    end
    
    idleCheckerTask = task.spawn(function()
        while disableAnim do
            local char = player.Character
            if char then
                local humanoid = char:FindFirstChild("Humanoid")
                
                if humanoid then
                    for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
                        if track ~= idleTrack and isFishingAnimation(track.Animation) then
                            pcall(function()
                                track:Stop(0)
                            end)
                        end
                    end
                end
                
                if idleTrack and not idleTrack.IsPlaying then
                    pcall(function()
                        idleTrack:Play(0.2, 1, 1)
                    end)
                end
                
                for _, tool in ipairs(char:GetChildren()) do
                    if tool:IsA("Tool") then
                        for _, obj in ipairs(tool:GetDescendants()) do
                            if obj:IsA("Animation") and isEquipIdleAnimation(obj) then
                                pcall(function() obj:Destroy() end)
                            end
                        end
                    end
                end
            end
            
            task.wait(0.2)
        end
    end)
end

local function stopIdleChecker()
    if idleCheckerTask then
        task.cancel(idleCheckerTask)
        idleCheckerTask = nil
    end
    
    if idleTrack then
        pcall(function()
            idleTrack:Stop()
            idleTrack:Destroy()
        end)
        idleTrack = nil
    end
end

local character = player.Character or player.CharacterAdded:Wait()
hookAnimator(character)
hookTools(character)

player.CharacterAdded:Connect(function(char)
    task.wait(1.5)
    hookAnimator(char)
    hookTools(char)
    
    if disableAnim then
        task.wait(0.5)
        loadIdleAnimation(char)
        startIdleChecker()
    end
end)

SupportSection:AddToggle({
    Title = "Block Animations",
    Content = "Remove fishing animations",
    Default = false,
    Callback = function(state)
        disableAnim = state
        
        if state then
            print("🔥 Animasi mancing dimatikan")
            
            local char = player.Character
            if char then
                loadIdleAnimation(char)
                startIdleChecker()
            end
        else
            print("🎣 Animasi aktif kembali")
            stopIdleChecker()
        end
    end
})

-- 🔒 Lock Position
local lockPosition = false
local lockedCFrame = nil
local positionConnection = nil

local function startPositionLock()
    if positionConnection then return end

    lockedCFrame = hrp.CFrame
    positionConnection = RunService.Heartbeat:Connect(function()
        if lockPosition and hrp and hrp.Parent then
            hrp.CFrame = lockedCFrame
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end
    end)
end

local function stopPositionLock()
    if positionConnection then
        positionConnection:Disconnect()
        positionConnection = nil
    end
end

SupportSection:AddToggle({
    Title = "Lock Posisi Mancing",
    Content = "Freeze character position",
    Default = false,
    Callback = function(state)
        lockPosition = state
        if state then
            lockedCFrame = hrp.CFrame
            startPositionLock()
            print("🔒 Posisi dikunci")
        else
            stopPositionLock()
            print("🔓 Posisi dilepas")
        end
    end
})

-- 🚫 Blatant Status
local function deleteCanvasGroup()
    pcall(function()
        local playerGui = player:WaitForChild("PlayerGui")
        local fishingGui = playerGui:FindFirstChild("Fishing")
        
        if fishingGui then
            local main = fishingGui:FindFirstChild("Main")
            if main then
                local display = main:FindFirstChild("Display")
                if display then
                    local canvasGroup = display:FindFirstChild("CanvasGroup")
                    if canvasGroup then
                        canvasGroup:Destroy()
                        print("🚫 CanvasGroup dihapus!")
                    end
                end
            end
        end
    end)
end

SupportSection:AddToggle({
    Title = "Blatant Status",
    Content = "Remove fishing UI",
    Default = false,
    Callback = function(state)
        if state then
            deleteCanvasGroup()
            print("🔥 UI Fishing dihapus")
        else
            print("✅ Blatant Status: OFF")
        end
    end
})

-- 🚫 Disable Pop Up
local disableSmallNotification = false
local notifConnection = nil
local notifRenderConnection = nil
local playerGui = player:WaitForChild("PlayerGui")

local function hideNotification(gui)
    for _, v in ipairs(gui:GetDescendants()) do
        if v:IsA("GuiObject") then
            v.Visible = false
            v.BackgroundTransparency = 1
        elseif v:IsA("UIStroke") or v:IsA("UIGradient") then
            v.Enabled = false
        end
    end
end

SupportSection:AddToggle({
    Title = "Disable POP UP",
    Content = "Block notifications",
    Default = false,
    Callback = function(state)
        disableSmallNotification = state

        if notifConnection then
            pcall(function() notifConnection:Disconnect() end)
            notifConnection = nil
        end
        
        if notifRenderConnection then
            pcall(function() notifRenderConnection:Disconnect() end)
            notifRenderConnection = nil
        end

        if state then
            print("🚫 Pop-up Blocker: ON")

            for _, obj in ipairs(playerGui:GetChildren()) do
                if obj.Name == "Small Notification" then
                    pcall(function()
                        if obj:IsA("ScreenGui") then
                            obj.Enabled = false
                        end
                        hideNotification(obj)
                    end)
                end
            end

            notifConnection = playerGui.ChildAdded:Connect(function(child)
                if not disableSmallNotification then return end
                if not child or not child.Parent then return end

                if child.Name == "Small Notification" then
                    task.wait(0.1)
                    pcall(function()
                        if child:IsA("ScreenGui") then
                            child.Enabled = false
                        end
                        hideNotification(child)
                    end)
                end
            end)
            
            notifRenderConnection = RunService.RenderStepped:Connect(function()
                if not disableSmallNotification then return end
                
                for _, obj in ipairs(playerGui:GetChildren()) do
                    if obj.Name == "Small Notification" and obj:IsA("ScreenGui") then
                        if obj.Enabled then
                            obj.Enabled = false
                        end
                        for _, v in ipairs(obj:GetDescendants()) do
                            if v:IsA("GuiObject") and v.Visible then
                                v.Visible = false
                            end
                        end
                    end
                end
            end)

        else
            print("✅ Pop-up Blocker: OFF")
            
            for _, obj in ipairs(playerGui:GetChildren()) do
                if obj.Name == "Small Notification" and obj:IsA("ScreenGui") then
                    obj.Enabled = true
                end
            end
        end
    end
})

-- ✨ Disable VFX
local disableVFX = false
local originalVFXFolder = nil
local dummyVFXFolder = nil
local isVFXDisabled = false

local function disableAllVFX()
    originalVFXFolder = ReplicatedStorage:FindFirstChild("VFX")
    if not originalVFXFolder then
        warn("⚠ Folder VFX tidak ditemukan!")
        return
    end
    
    dummyVFXFolder = Instance.new("Folder")
    dummyVFXFolder.Name = "VFX"
    dummyVFXFolder.Archivable = false
    
    originalVFXFolder.Name = "VFX_BACKUP"
    originalVFXFolder.Parent = nil
    
    dummyVFXFolder.Parent = ReplicatedStorage
    
    task.spawn(function()
        for _, obj in ipairs(originalVFXFolder:GetChildren()) do
            pcall(function() obj:Destroy() end)
            task.wait()
        end
    end)
    
    isVFXDisabled = true
    print("✨ VFX disabled")
end

SupportSection:AddToggle({
    Title = "Disable Skin Effect",
    Content = "Remove visual effects (Restart to restore)",
    Default = false,
    Callback = function(state)
        disableVFX = state

        if disableVFX then
            disableAllVFX()
            warn("⚠️ VFX disabled PERMANENT!")
        else
            if isVFXDisabled then
                print("VFX tetap disabled. Restart untuk restore.")
            end
        end
    end
})


local MiscSection = FarmTab:AddSection("Mics")

-- ==========================================
-- 🎯 PING MONITOR MODULE (REDESIGNED)
-- ==========================================

local MachMonitor = (function()
    local RunService = game:GetService("RunService")
    local Stats = game:GetService("Stats")
    local UserInputService = game:GetService("UserInputService")
    local PlayerGui = player:WaitForChild("PlayerGui")

    local Monitor = {}
    
    -- Variables
    local pingUpdateConnection = nil
    local guiInstance = nil

    -- ==========================================
    -- 🔧 HELPER FUNCTIONS
    -- ==========================================
    
    -- Get Ping
    local function getPing()
        local ping = 0
        pcall(function()
            local networkStats = Stats:FindFirstChild("Network")
            if networkStats then
                local serverStatsItem = networkStats:FindFirstChild("ServerStatsItem")
                if serverStatsItem then
                    local pingStr = serverStatsItem["Data Ping"]:GetValueString()
                    ping = tonumber(pingStr:match("%d+")) or 0
                end
            end
            if ping == 0 then 
                ping = math.floor(player:GetNetworkPing() * 1000) 
            end
        end)
        return ping
    end

    -- Color Updater
    local function updatePingColor(label, val)
        if val <= 60 then 
            label.TextColor3 = Color3.fromRGB(0, 255, 127) -- Hijau Terang
        elseif val <= 120 then 
            label.TextColor3 = Color3.fromRGB(255, 200, 100) -- Kuning
        else 
            label.TextColor3 = Color3.fromRGB(255, 100, 100) -- Merah
        end
    end

    -- ==========================================
    -- 🎨 CREATE GUI (REDESIGNED)
    -- ==========================================
    
    local function createGUI()
        if guiInstance then return guiInstance end

        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "MachPanelMonitor"
        screenGui.ResetOnSpawn = false
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        screenGui.DisplayOrder = 100

        -- Container (Background Hitam)
        local container = Instance.new("Frame")
        container.Name = "Container"
        container.Size = UDim2.new(0, 220, 0, 80) -- Lebih tinggi untuk logo + text
        container.Position = UDim2.new(0, 50, 0.5, -40) -- Kiri Tengah
        container.BackgroundColor3 = Color3.fromRGB(15, 15, 15) -- Hitam Pekat
        container.BackgroundTransparency = 0.1 -- Hampir solid (tidak terlalu transparan)
        container.Parent = screenGui

        local uiCorner = Instance.new("UICorner", container)
        uiCorner.CornerRadius = UDim.new(0, 12)

        local uiStroke = Instance.new("UIStroke", container)
        uiStroke.Color = Color3.fromRGB(50, 50, 50) -- Abu Gelap
        uiStroke.Thickness = 2
        uiStroke.Transparency = 0.3

        -- Logo (Pojok Kiri Atas)
        local logo = Instance.new("ImageLabel", container)
        logo.Size = UDim2.new(0, 50, 0, 50)
        logo.Position = UDim2.new(0, 10, 0, 10)
        logo.Image = "rbxassetid://101311528770915" -- Mach logo
        logo.BackgroundTransparency = 1
        logo.ScaleType = Enum.ScaleType.Fit

        -- Title "MACH PANEL" (Pojok Kanan Atas)
        local title = Instance.new("TextLabel", container)
        title.Size = UDim2.new(0, 140, 0, 20)
        title.Position = UDim2.new(0, 70, 0, 15) -- Di samping logo
        title.BackgroundTransparency = 1
        title.Text = "MACH PANEL"
        title.TextColor3 = Color3.fromRGB(255, 255, 255) -- Putih
        title.TextSize = 14
        title.Font = Enum.Font.GothamBold
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.TextYAlignment = Enum.TextYAlignment.Top

        -- Ping Label (Bawah Logo, Hijau Terang)
        local pingLbl = Instance.new("TextLabel", container)
        pingLbl.Size = UDim2.new(1, -20, 0, 20)
        pingLbl.Position = UDim2.new(0, 10, 0, 55) -- Di bawah logo
        pingLbl.BackgroundTransparency = 1
        pingLbl.Text = "Ping: -- ms"
        pingLbl.TextColor3 = Color3.fromRGB(0, 255, 127) -- Hijau Terang (Default)
        pingLbl.TextSize = 14
        pingLbl.Font = Enum.Font.GothamBold
        pingLbl.TextXAlignment = Enum.TextXAlignment.Left

        -- ==========================================
        -- 🖱️ DRAGGING LOGIC
        -- ==========================================
        
        local dragging, dragInput, dragStart, startPos
        
        container.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or 
               input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = container.Position
                
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then 
                        dragging = false 
                    end
                end)
            end
        end)
        
        container.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or 
               input.UserInputType == Enum.UserInputType.Touch then 
                dragInput = input 
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                container.Position = UDim2.new(
                    startPos.X.Scale, 
                    startPos.X.Offset + delta.X, 
                    startPos.Y.Scale, 
                    startPos.Y.Offset + delta.Y
                )
            end
        end)

        guiInstance = {
            ScreenGui = screenGui,
            PingLabel = pingLbl
        }
        
        screenGui.Parent = PlayerGui
        return guiInstance
    end

    -- ==========================================
    -- 🔄 PUBLIC METHODS
    -- ==========================================
    
    function Monitor:Show()
        local ui = createGUI()
        ui.ScreenGui.Enabled = true

        -- Ping Update Loop (0.5s interval)
        local lastCheck = 0
        if pingUpdateConnection then 
            pingUpdateConnection:Disconnect() 
        end
        
        pingUpdateConnection = RunService.Heartbeat:Connect(function()
            local now = tick()
            if now - lastCheck >= 0.5 then
                local ping = getPing()
                ui.PingLabel.Text = "Ping: " .. ping .. " ms"
                updatePingColor(ui.PingLabel, ping)
                lastCheck = now
            end
        end)
        
        print("✅ Ping Panel: ON")
    end

    function Monitor:Destroy()
        if pingUpdateConnection then 
            pingUpdateConnection:Disconnect() 
            pingUpdateConnection = nil
        end
        
        if guiInstance and guiInstance.ScreenGui then
            guiInstance.ScreenGui:Destroy()
            guiInstance = nil
        end
        
        print("🔴 Ping Panel: OFF")
    end

    return Monitor
end)()

-- ==========================================
-- 🎛️ UI TOGGLE
-- ==========================================

MiscSection:AddToggle({
    Title = "Show Panel",
    Content = "Show Real Ping",
    Default = false,
    Callback = function(state)
        disableVFX = state

        if state then
            MachMonitor:Show()
            
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Panel Active",
                Text = "Ping panel shown (Draggable)",
                Duration = 3
            })
        else
            MachMonitor:Destroy()
            
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "📊 Panel Hidden",
                Text = "Ping panel disabled",
                Duration = 2
            })
        end
    end
})



-- ==========================================
-- 🗺️ TELEPORT TAB
-- ==========================================

local TeleportTab = Window:AddTab({
    Name = "Teleport",
    Icon = "teleport" -- atau gunakan icon lain dari Icons table
})

-- ==========================================
-- 📍 SECTION 1: TELEPORT LOCATIONS
-- ==========================================

local LocationSection = TeleportTab:AddSection("Teleport Locations")

-- Daftar lokasi teleport
local teleportLocations = {
    ["Hutan Kuno"] = CFrame.new(1469.27, 7.63, -342.92),
    ["Ancient Ruin"] = CFrame.new(6075.24, -585.92, 4610.32),
    ["Terumbu Karang"] = CFrame.new(-2934.81, 2.75, 2113.44),
    ["Pulau Kawah"] = CFrame.new(1079.68, 4.71, 5044.67),
    ["Kedalaman Esoterik"] = CFrame.new(3259.52, -1300.83, 1377.87),
    ["Pulau Nelayan"] = CFrame.new(92.81, 9.53, 2762.08),
    ["Kohana"] = CFrame.new(-643.31, 16.04, 622.36),
    ["Gunung Berapi Kohana"] = CFrame.new(-595.02, 40.52, 152.29),
    ["Lost Isle"] = CFrame.new(-3712.02, 10.93, -1014.16),
    ["Kuil Suci"] = CFrame.new(1443.38, -22.13, -630.15),
    ["Patung Sisyphus (Keramat)"] = CFrame.new(-3651.51, -134.55, -925.15),
    ["Kamar Harta Karun"] = CFrame.new(-3569.58, -266.57, -1583.04),
    ["Hutan Tropis"] = CFrame.new(-2113.34, 6.78, 3700.81),
    ["Ruang Bawah Tanah"] = CFrame.new(2096.15, -91.20, -715.09),
    ["Mesin Cuaca (Lautan)"] = CFrame.new(-1513.92, 6.50, 1892.11),
    ["Pulau Natal"] = CFrame.new(1174.79, 23.43, 1551.83)
}

-- Konversi ke format {Label, Value}
local locationOptions = {}
for name, cframe in pairs(teleportLocations) do
    table.insert(locationOptions, {Label = name, Value = name})
end

-- Sort alphabetically
table.sort(locationOptions, function(a, b) 
    return a.Label < b.Label 
end)

-- Variabel lokasi terpilih
local selectedLocation = nil

-- Dropdown pilih lokasi
local locationDropdown = LocationSection:AddDropdown({
    Title = "Pilih Lokasi",
    Content = "Pilih tempat tujuan teleport",
    Multi = false,
    Options = locationOptions,
    Default = nil,
    Callback = function(value)
        selectedLocation = value
        print("📍 Lokasi dipilih:", value)
    end
})

-- Tombol teleport
LocationSection:AddButton({
    Title = "Teleport Sekarang",
    Callback = function()
        if not selectedLocation then
            notif("Pilih lokasi dulu!", 3, Color3.fromRGB(255, 100, 100), "Mach", "Teleport")
            return
        end
        
        local player = game:GetService("Players").LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")
        
        pcall(function()
            hrp.CFrame = teleportLocations[selectedLocation]
            notif("Teleport ke " .. selectedLocation .. " berhasil!", 3, Color3.fromRGB(0, 255, 127), "Mach", "Success")
        end)
    end
})

-- ==========================================
-- 👤 SECTION 2: TELEPORT TO PLAYER
-- ==========================================

local PlayerSection = TeleportTab:AddSection("Teleport To Player")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local selectedPlayer = nil

-- Function untuk refresh player list
local function refreshPlayerList()
    local list = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            table.insert(list, {Label = plr.DisplayName, Value = plr.DisplayName})
        end
    end
    
    if #list == 0 then
        return {{Label = "(No Players)", Value = nil}}
    end
    
    return list
end

-- Dropdown player
local playerDropdown = PlayerSection:AddDropdown({
    Title = "Pilih Player",
    Content = "Pilih player target teleport",
    Multi = false,
    Options = refreshPlayerList(),
    Default = nil,
    Callback = function(value)
        selectedPlayer = value
        print("🎯 Target:", selectedPlayer)
    end
})

-- Auto refresh player list setiap 5 detik
task.spawn(function()
    while task.wait(5) do
        pcall(function()
            local newList = refreshPlayerList()
            playerDropdown:SetValues(newList, selectedPlayer)
        end)
    end
end)

-- Tombol teleport ke player
PlayerSection:AddButton({
    Title = "Teleport ke Player",
    Callback = function()
        if not selectedPlayer then
            notif("Pilih player dulu!", 3, Color3.fromRGB(255, 100, 100), "Mach", "Teleport")
            return
        end

        local target = nil
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.DisplayName == selectedPlayer then
                target = plr
                break
            end
        end

        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                LocalPlayer.Character.HumanoidRootPart.CFrame = 
                    target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 2, 0)
                notif("Teleport ke " .. target.DisplayName .. " berhasil!", 3, Color3.fromRGB(0, 255, 127), "Mach", "Success")
            end)
        else
            notif("Player tidak valid atau tidak online!", 3, Color3.fromRGB(255, 100, 100), "Mach", "Error")
        end
    end
})

-- ==========================================
-- 🌊 SECTION 3: EVENT TELEPORT + WALK ON WATER
-- ==========================================

local EventSection = TeleportTab:AddSection("Event Teleport")

-- Services
local RunService = game:GetService("RunService")
local workspace = game:GetService("Workspace")

-- Walk on Water Variables
local walkOnWaterEnabled = false
local waterPlatform = nil
local platformConnection = nil

-- Create invisible platform
local function createWaterPlatform()
    local platform = Instance.new("Part")
    platform.Name = "WaterPlatform"
    platform.Size = Vector3.new(10, 0.5, 10)
    platform.Transparency = 1
    platform.Anchored = true
    platform.CanCollide = true
    platform.Material = Enum.Material.ForceField
    platform.Parent = workspace
    
    return platform
end

-- Walk on Water Function
local function setWalkOnWater(state)
    local char = LocalPlayer.Character
    if not char then return end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    if state then
        if not waterPlatform then
            waterPlatform = createWaterPlatform()
        end
        
        if platformConnection then
            platformConnection:Disconnect()
        end
        
        platformConnection = RunService.Heartbeat:Connect(function()
            if not walkOnWaterEnabled then return end
            if not char or not char.Parent then return end
            
            local humanoid = char:FindFirstChild("Humanoid")
            if not humanoid then return end
            
            local waterLevel = -1.4
            local platformY = waterLevel + 0.25
            
            waterPlatform.Position = Vector3.new(
                hrp.Position.X,
                platformY,
                hrp.Position.Z
            )
        end)
        
        notif("Walk on Water aktif!", 3, Color3.fromRGB(0, 200, 255), "Mach", "Water Walk")
    else
        if platformConnection then
            platformConnection:Disconnect()
            platformConnection = nil
        end
        
        if waterPlatform then
            waterPlatform:Destroy()
            waterPlatform = nil
        end
        
        notif("Walk on Water nonaktif!", 3, Color3.fromRGB(255, 200, 100), "Mach", "Water Walk")
    end
end

-- Event Data
local Events = {
    ["Megalodon Hunt"] = {
        Keywords = {"megalodon"},
        Coords = {
            Vector3.new(-1076.3, -1.3999, 1676.19),
            Vector3.new(-1191.8, -1.3999, 3597.30),
            Vector3.new(412.7, -1.3999, 4134.39)
        },
        Offset = Vector3.new(0, 0, -35)
    },
    ["Worm Hunt"] = {
        Keywords = {"worm"},
        Coords = {
            Vector3.new(2190.85, -1.3999, 97.5749),
            Vector3.new(-2450.6, -1.3999, 139.731),
            Vector3.new(-267.47, -1.3999, 5188.53)
        },
        Offset = Vector3.new(0, 5, -25)
    },
    ["Ghost Shark Hunt"] = {
        Keywords = {"ghost"},
        Coords = {
            Vector3.new(489.558, -1.35, 25.406),
            Vector3.new(-1358.2, -1.35, 4100.55),
            Vector3.new(627.859, -1.35, 3798.08)
        },
        Offset = Vector3.new(0, 5, -30)
    },
    ["Shark Hunt"] = {
        Keywords = {"shark"},
        Exclude = {"ghost"},
        Coords = {
            Vector3.new(1.64999, -1.35, 2095.72),
            Vector3.new(1369.94, -1.35, 930.125),
            Vector3.new(-1585.5, -1.35, 1242.87),
            Vector3.new(-1896.8, -1.35, 2634.37)
        },
        Offset = Vector3.new(0, 5, -30)
    }
}

-- Find Event Model Function
local function findEventModel(event)
    local data = Events[event]
    if not data then return nil end

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") then
            local name = string.lower(obj.Name)
            local valid = false

            for _, key in ipairs(data.Keywords) do
                if string.find(name, key) then
                    valid = true
                end
            end

            if data.Exclude then
                for _, ex in ipairs(data.Exclude) do
                    if string.find(name, ex) then
                        valid = false
                    end
                end
            end

            if valid then
                local part = obj:FindFirstChild("HumanoidRootPart")
                    or obj.PrimaryPart
                    or obj:FindFirstChildWhichIsA("BasePart")

                if part then
                    return part
                end
            end
        end
    end
    return nil
end

-- Event Options
local eventOptions = {}
for name in pairs(Events) do 
    table.insert(eventOptions, {Label = name, Value = name})
end
table.sort(eventOptions, function(a, b) 
    return a.Label < b.Label 
end)

local selectedEvent = nil
local currentPos = nil

-- Dropdown Event
EventSection:AddDropdown({
    Title = "Pilih Event",
    Content = "Pilih event hunt yang aktif",
    Multi = false,
    Options = eventOptions,
    Default = nil,
    Callback = function(value)
        selectedEvent = value
        currentPos = nil
        print("🎯 Event dipilih:", value)
    end
})

-- Button Refresh Location
EventSection:AddButton({
    Title = "🔄 Refresh Location",
    Callback = function()
        if not selectedEvent then
            notif("Pilih event dulu!", 3, Color3.fromRGB(255, 100, 100), "Mach", "Event")
            return
        end
        
        local data = Events[selectedEvent]
        currentPos = data.Coords[math.random(#data.Coords)]
        notif("Area " .. selectedEvent .. " di-refresh!", 3, Color3.fromRGB(100, 200, 255), "Mach", "Refresh")
    end
})

-- Toggle Teleport & Walk on Water
local eventToggle = EventSection:AddToggle({
    Title = "Teleport & Walk on Water",
    Content = "Teleport ke event + jalan di air",
    Default = false,
    Callback = function(state)
        if not selectedEvent then
            notif("Pilih event dulu!", 3, Color3.fromRGB(255, 100, 100), "Mach", "Event")
            eventToggle:Set(false)
            return
        end

        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")
        local data = Events[selectedEvent]

        if state then
            -- PRIORITY 1: MODEL
            local modelPart = findEventModel(selectedEvent)
            if modelPart then
                hrp.CFrame = modelPart.CFrame * CFrame.new(data.Offset)
                setWalkOnWater(true)
                walkOnWaterEnabled = true
                notif("Teleport ke MODEL: " .. selectedEvent, 3, Color3.fromRGB(0, 255, 127), "Mach", "Event")
                return
            end

            -- FALLBACK: COORDS
            if not currentPos then
                notif("Model belum spawn! Klik Refresh dulu!", 4, Color3.fromRGB(255, 200, 100), "Mach", "Warning")
                eventToggle:Set(false)
                return
            end

            hrp.CFrame = CFrame.new(currentPos + data.Offset)
            setWalkOnWater(true)
            walkOnWaterEnabled = true
            notif("Teleport ke AREA: " .. selectedEvent, 3, Color3.fromRGB(0, 255, 127), "Mach", "Event")
        else
            setWalkOnWater(false)
            walkOnWaterEnabled = false
        end
    end
})

-- ==========================================
-- 🔄 AUTO CLEANUP ON RESPAWN
-- ==========================================

LocalPlayer.CharacterRemoving:Connect(function()
    if platformConnection then
        platformConnection:Disconnect()
        platformConnection = nil
    end
    if waterPlatform then
        waterPlatform:Destroy()
        waterPlatform = nil
    end
    walkOnWaterEnabled = false
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    
    if walkOnWaterEnabled then
        setWalkOnWater(false)
        walkOnWaterEnabled = false
    end
end)

game:GetService("Players").PlayerRemoving:Connect(function(plr)
    if plr == LocalPlayer then
        if platformConnection then
            platformConnection:Disconnect()
        end
        if waterPlatform then
            waterPlatform:Destroy()
        end
    end
end)

-- ======================================================
-- 👤 TAB PLAYER
-- ======================================================
local PlayerTab = Window:AddTab({
    Name = "Player",
    Icon = "user" -- Menggunakan icon dari Icons table di library
})

-- ======================================================
-- 📦 SECTION: MOVEMENT
-- ======================================================
local MovementSection = PlayerTab:AddSection("Movement") -- false = bisa dibuka/tutup

-- ======================================================
-- 🦘 HIGH JUMP
-- ======================================================
local jumpEnabled = false
local jumpPower = 100

local HighJumpToggle = MovementSection:AddToggle({
    Title = "High Jump",
    Content = "Enable high jump with custom power",
    Default = false,
    Callback = function(state)
        jumpEnabled = state
        local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
        if not hum then return end

        if state then
            hum.UseJumpPower = true
            hum.JumpPower = jumpPower
            print("🦘 High Jump Aktif:", jumpPower)
        else
            hum.JumpPower = 50 -- default Roblox
            print("⬇️ High Jump Nonaktif")
        end
    end
})

-- 🔢 INPUT JUMP POWER
local JumpPowerInput = MovementSection:AddInput({
    Title = "Jump Power",
    Content = "Set jump power (50-300)",
    Default = tostring(jumpPower),
    Callback = function(val)
        local num = tonumber(val)
        if not num then return end

        jumpPower = math.clamp(num, 50, 300)
        print("✅ Jump Power diubah ke:", jumpPower)

        if jumpEnabled then
            local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
            if hum then
                hum.JumpPower = jumpPower
            end
        end
    end
})

-- ======================================================
-- 🌀 HOVER LOCK
-- ======================================================
local hoverLock = false
local bodyPos = nil

local HoverToggle = MovementSection:AddToggle({
    Title = "Hover Lock",
    Content = "Lock your position in the air with safe landing",
    Default = false,
    Callback = function(state)
        hoverLock = state
        local player = game.Players.LocalPlayer
        local char = player.Character or player.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")
        local humanoid = char:WaitForChild("Humanoid")

        if state then
            print("🌀 Hover Lock Aktif (NO LOOP)")
            
            -- ✅ BODYPOSITION METHOD (NO LOOP NEEDED!)
            bodyPos = Instance.new("BodyPosition")
            bodyPos.Position = hrp.Position
            bodyPos.MaxForce = Vector3.new(0, math.huge, 0) -- Only lock Y axis
            bodyPos.P = 50000  -- Stiffness
            bodyPos.D = 5000   -- Damping
            bodyPos.Parent = hrp
            
            print("✅ Player locked at Y=" .. math.floor(hrp.Position.Y))
            
        else
            print("⚙️ Hover Lock Nonaktif")
            
            -- Cleanup BodyPosition
            if bodyPos then
                bodyPos:Destroy()
                bodyPos = nil
            end
            
            -- ✅ SAFE LANDING SYSTEM
            local currentHeight = hrp.Position.Y
            
            if currentHeight > 10 then
                print("🪂 Safe Landing Activated...")
                
                -- Slow fall effect
                local bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.Velocity = Vector3.new(0, -10, 0) -- Turun pelan
                bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
                bodyVelocity.Parent = hrp
                
                -- Auto cleanup saat landing
                task.spawn(function()
                    repeat 
                        task.wait(0.1)
                    until humanoid.FloorMaterial ~= Enum.Material.Air
                    
                    if bodyVelocity and bodyVelocity.Parent then
                        bodyVelocity:Destroy()
                        print("✅ Landed safely from Y=" .. math.floor(currentHeight))
                    end
                end)
            else
                print("✅ Low height, normal landing")
            end
        end
    end
})

-- ======================================================
-- ⚡ SPEED MODE
-- ======================================================
local speedEnabled = false
local runSpeed = 50

local SpeedToggle = MovementSection:AddToggle({
    Title = "Speed Mode",
    Content = "Enable custom walk speed",
    Default = false,
    Callback = function(state)
        speedEnabled = state
        local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
        if not hum then return end

        if state then
            hum.WalkSpeed = runSpeed
            print("⚡ Speed Mode Aktif:", runSpeed)
        else
            hum.WalkSpeed = 16
            print("🛑 Speed Mode Nonaktif")
        end
    end
})

-- 🔢 INPUT RUN SPEED
local SpeedInput = MovementSection:AddInput({
    Title = "Walk Speed",
    Content = "Set walk speed (16-300)",
    Default = tostring(runSpeed),
    Callback = function(val)
        local num = tonumber(val)
        if not num then return end

        runSpeed = math.clamp(num, 16, 300)
        print("✅ Speed diubah ke:", runSpeed)

        if speedEnabled then
            local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
            if hum then
                hum.WalkSpeed = runSpeed
            end
        end
    end
})

--====================================================--
-- 🛒 TAB SHOP
--====================================================--
local ShopTab = Window:AddTab({
    Name = "Shop",
    Icon = "shop" -- Menggunakan icon dari Icons table
})

--====================================================--
-- 🔗 NET REMOTES
--====================================================--
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

local Net = ReplicatedStorage
    :WaitForChild("Packages")
    :WaitForChild("_Index")
    :WaitForChild("sleitnick_net@0.2.0")
    :WaitForChild("net")

local PurchaseRod = Net:WaitForChild("RF/PurchaseFishingRod")
local EquipItem = Net:WaitForChild("RE/EquipItem")
local PurchaseBait = Net:WaitForChild("RF/PurchaseBait")
local EquipBait = Net:WaitForChild("RE/EquipBait")
local PurchaseMarketItem = Net:WaitForChild("RF/PurchaseMarketItem")

--====================================================--
-- 🎣 SECTION: BUY FISHING ROD
--====================================================--
local RodSection = ShopTab:AddSection("Buy Fishing Rod")

local Rods = {
    {Name="Carbon Rod", Id=76, Price=750},
    {Name="Grass Rod", Id=85, Price=1500},
    {Name="Demascus Rod", Id=77, Price=3000},
    {Name="Ice Rod", Id=78, Price=5000},
    {Name="Lucky Rod", Id=4, Price=15000},
    {Name="Midnight Rod", Id=80, Price=50000},
    {Name="Steampunk Rod", Id=6, Price=215000},
    {Name="Chrome Rod", Id=7, Price=437000},
    {Name="Fluorescent Rod", Id=255, Price=715000},
    {Name="Astral Rod", Id=5, Price=1000000},
    {Name="Ares Rod", Id=126, Price=3000000},
    {Name="Angler Rod", Id=168, Price=8000000},
    {Name="Bamboo Rod", Id=258, Price=12000000},
}

local function HasRod(name)
    local inv = player:FindFirstChild("Rods")
    return inv and inv:FindFirstChild(name)
end

local function FormatPrice(p)
    if p >= 1e6 then
        return string.format("%.1fm", p/1e6):gsub("%.0","")
    elseif p >= 1e3 then
        return string.format("%.1fk", p/1e3):gsub("%.0","")
    end
    return tostring(p)
end

local rodDropdownList = {}
local rodByLabel = {}

for _, rod in ipairs(Rods) do
    local owned = HasRod(rod.Name)
    local label = rod.Name.." ("..FormatPrice(rod.Price)..")"
    if owned then
        label = label .. " ✔"
    end
    table.insert(rodDropdownList, {Label = label, Value = rod.Name})
    rodByLabel[label] = rod
end

local selectedRod = nil

local RodDropdown = RodSection:AddDropdown({
    Title = "Select Rod",
    Content = "Choose a fishing rod to purchase",
    Multi = false,
    Options = rodDropdownList,
    Default = nil,
    Callback = function(value)
        -- Find rod by matching name
        for label, rod in pairs(rodByLabel) do
            if label:find(value, 1, true) then
                selectedRod = rod
                print("🎣 Selected:", rod.Name)
                break
            end
        end
    end
})

RodSection:AddButton({
    Title = "Buy Selected Rod",
    Callback = function()
        if not selectedRod then
            warn("❌ No rod selected")
            return
        end

        if HasRod(selectedRod.Name) then
            warn("❌ Rod already owned")
            return
        end

        local success, result = pcall(function()
            return PurchaseRod:InvokeServer(selectedRod.Id)
        end)

        if success then
            task.delay(0.4, function()
                EquipItem:FireServer(selectedRod.Id, "Fishing Rods")
            end)
            print("✅ Bought & equipped:", selectedRod.Name)
        else
            warn("❌ Failed to buy rod")
        end
    end
})

--====================================================--
-- 🪱 SECTION: BUY BAIT
--====================================================--
local BaitSection = ShopTab:AddSection("Buy Bait")

local Baits = {
    {Name="Luck Bait", Id=2, Price=1000},
    {Name="Nature Bait", Id=17, Price=83500},
    {Name="Chroma Bait", Id=6, Price=290000},
    {Name="Dark Matter Bait", Id=8, Price=630000},
    {Name="Corrupt Bait", Id=15, Price=1148484},
    {Name="Aether Bait", Id=16, Price=3700000},
    {Name="Floral Bait", Id=20, Price=4000000},
}

local baitDropdownList = {}
local baitByLabel = {}

for _, bait in ipairs(Baits) do
    local label = bait.Name .. " (" .. FormatPrice(bait.Price) .. ")"
    table.insert(baitDropdownList, {Label = label, Value = bait.Name})
    baitByLabel[label] = bait
end

local selectedBait = nil

local BaitDropdown = BaitSection:AddDropdown({
    Title = "Select Bait",
    Content = "Choose bait to purchase and equip",
    Multi = false,
    Options = baitDropdownList,
    Default = nil,
    Callback = function(value)
        for label, bait in pairs(baitByLabel) do
            if label:find(value, 1, true) then
                selectedBait = bait
                print("🪱 Selected:", bait.Name)
                break
            end
        end
    end
})

BaitSection:AddButton({
    Title = "Buy & Equip Bait",
    Callback = function()
        if not selectedBait then
            warn("❌ No bait selected")
            return
        end

        local success, result = pcall(function()
            return PurchaseBait:InvokeServer(selectedBait.Id)
        end)

        if success then
            EquipBait:FireServer(selectedBait.Id)
            print("✅ Bought & equipped:", selectedBait.Name)
        else
            warn("❌ Failed to buy bait")
        end
    end
})

--====================================================--
-- 🗿 SECTION: BUY TOTEMS
--====================================================--
local TotemSection = ShopTab:AddSection("Buy Totems")

local Totems = {
    {Name = "Luck Totem", Id = 5},
    {Name = "Mutation Totem", Id = 6},
    {Name = "Shiny Totem", Id = 7}
}

local totemDropdownList = {}
local totemByName = {}

for _, totem in ipairs(Totems) do
    table.insert(totemDropdownList, {Label = totem.Name, Value = totem.Name})
    totemByName[totem.Name] = totem
end

local selectedTotem = nil

local TotemDropdown = TotemSection:AddDropdown({
    Title = "Select Totem",
    Content = "Choose a totem to purchase",
    Multi = false,
    Options = totemDropdownList,
    Default = nil,
    Callback = function(value)
        selectedTotem = totemByName[value]
        if selectedTotem then
            print("🗿 Selected:", selectedTotem.Name)
        end
    end
})

TotemSection:AddButton({
    Title = "Buy Selected Totem",
    Callback = function()
        if not selectedTotem then
            warn("❌ No totem selected")
            return
        end
        
        local success, result = pcall(function()
            return PurchaseMarketItem:InvokeServer(selectedTotem.Id)
        end)
        
        if success then
            print("✅ Bought:", selectedTotem.Name)
            
            -- Notification
            local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
            gui.Name = "TotemNotify"
            
            local label = Instance.new("TextLabel", gui)
            label.Size = UDim2.new(0, 300, 0, 50)
            label.Position = UDim2.new(0.5, -150, 0.8, 0)
            label.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            label.TextColor3 = Color3.fromRGB(255, 215, 0)
            label.Font = Enum.Font.GothamBold
            label.TextSize = 20
            label.Text = "🗿 " .. selectedTotem.Name .. " Purchased!"
            label.BackgroundTransparency = 1
            
            TweenService:Create(label, TweenInfo.new(0.4), {BackgroundTransparency = 0.3}):Play()
            task.wait(2.5)
            TweenService:Create(label, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
            task.wait(0.5)
            gui:Destroy()
        else
            warn("❌ Failed to buy totem:", result)
        end
    end
})

TotemSection:AddDivider()

--====================================================--
-- 🔄 AUTO BUY TOTEM
--====================================================--
local autoBuyTotem = false
local autoBuyInterval = 3540
local selectedAutoTotem = nil

local AutoTotemDropdown = TotemSection:AddDropdown({
    Title = "Auto Buy Totem",
    Content = "Select totem for automatic purchase",
    Multi = false,
    Options = totemDropdownList,
    Default = nil,
    Callback = function(value)
        selectedAutoTotem = totemByName[value]
        if selectedAutoTotem then
            print("🔄 Auto Buy Target:", selectedAutoTotem.Name)
        end
    end
})

local IntervalSlider = TotemSection:AddSlider({
    Title = "Re-buy Interval",
    Content = "Set interval in minutes (30-60)",
    Min = 30,
    Max = 60,
    Default = 59,
    Increment = 1,
    Callback = function(value)
        autoBuyInterval = value * 60
        print("⏱️ Auto buy interval:", value, "minutes")
    end
})

local AutoBuyToggle = TotemSection:AddToggle({
    Title = "Enable Auto Buy",
    Content = "Automatically purchase selected totem at interval",
    Default = false,
    Callback = function(state)
        autoBuyTotem = state
        
        if state then
            if not selectedAutoTotem then
                warn("❌ Select totem for auto buy first!")
                autoBuyTotem = false
                return
            end
            
            print("🟢 AUTO BUY TOTEM: ON")
            print("🗿 Target:", selectedAutoTotem.Name)
            print("⏱️ Interval:", autoBuyInterval / 60, "minutes")
            
            task.spawn(function()
                while autoBuyTotem do
                    local success, result = pcall(function()
                        return PurchaseMarketItem:InvokeServer(selectedAutoTotem.Id)
                    end)
                    
                    if success then
                        print("✅ Auto bought:", selectedAutoTotem.Name, "at", os.date("%H:%M:%S"))
                        
                        local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
                        gui.Name = "AutoTotemNotify"
                        
                        local label = Instance.new("TextLabel", gui)
                        label.Size = UDim2.new(0, 300, 0, 50)
                        label.Position = UDim2.new(0.5, -150, 0.8, 0)
                        label.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                        label.TextColor3 = Color3.fromRGB(0, 255, 127)
                        label.Font = Enum.Font.GothamBold
                        label.TextSize = 18
                        label.Text = "🔄 Auto Bought: " .. selectedAutoTotem.Name
                        label.BackgroundTransparency = 1
                        
                        TweenService:Create(label, TweenInfo.new(0.4), {BackgroundTransparency = 0.3}):Play()
                        task.wait(3)
                        TweenService:Create(label, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
                        task.wait(0.5)
                        gui:Destroy()
                    else
                        warn("❌ Auto buy failed:", result)
                    end
                    
                    local countdown = autoBuyInterval
                    while countdown > 0 and autoBuyTotem do
                        task.wait(60)
                        countdown = countdown - 60
                        
                        if countdown > 0 and countdown % 300 == 0 then
                            print("⏱️ Next totem buy in", countdown / 60, "minutes")
                        end
                    end
                end
            end)
            
        else
            print("🔴 AUTO BUY TOTEM: OFF")
        end
    end
})

--====================================================--
-- 🛍️ SECTION: MERCHANT GUI
--====================================================--
local MerchantSection = ShopTab:AddSection("Merchant Controls")

local playerGui = player:WaitForChild("PlayerGui")

local function getMerchantGUI()
    local merchant = playerGui:FindFirstChild("Merchant")
    if not merchant then
        warn("❌ Merchant GUI not found!")
        return nil
    end
    return merchant
end

local function openMerchant()
    local merchant = getMerchantGUI()
    if not merchant then return end
    
    merchant.Enabled = true
    
    local main = merchant:FindFirstChild("Main")
    if main then
        main.Visible = true
        
        local background = main:FindFirstChild("Background")
        if background then
            background.Visible = true
        end
    end
    
    print("✅ Merchant opened")
end

local function closeMerchant()
    local merchant = getMerchantGUI()
    if not merchant then return end
    
    local closeBtn = merchant:FindFirstChild("Close", true)
    if closeBtn then
        pcall(function()
            for _, conn in pairs(getconnections(closeBtn.MouseButton1Click)) do
                conn:Fire()
            end
        end)
        task.wait(0.1)
    end
    
    merchant.Enabled = false
    print("✅ Merchant closed")
end

MerchantSection:AddButton({
    Title = "Open Merchant",
    Callback = function()
        openMerchant()
    end
})

MerchantSection:AddButton({
    Title = "Close Merchant",
    Callback = function()
        closeMerchant()
    end
})

print("✅ SHOP TAB LOADED!")
