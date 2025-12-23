--============================================================--
-- 🛡 DUNHILL INTERNAL PROTECTION - SILENT MODE
--============================================================--

local Protect = {}
Protect.__connections = {}
Protect.__tasks = {}
Protect.__alive = true
Protect.lastPulse = 0
local firstPulse = true -- ✅ FLAG UNTUK PRINT SEKALI

function Protect:Connect(signal, func)
    if not signal or not func then return end
    local ok, c = pcall(function()
        return signal:Connect(func)
    end)
    if ok and c then
        table.insert(self.__connections, c)
        return c
    end
end

function Protect:Task(func)
    if not func then return end
    local t = task.spawn(func)
    table.insert(self.__tasks, t)
    return t
end

task.spawn(function()
    while Protect.__alive do
        task.wait(2)

        -- ✅ PRINT CUMA SEKALI PAS FIRST PULSE
        if firstPulse then
            print("[GHOST PROTECT] ✅ Active & Running")
            firstPulse = false
        end

        -- Cleanup connections
        for _, c in ipairs(Protect.__connections) do
            pcall(function()
                if c and c.Disconnect then c:Disconnect() end
            end)
        end
        table.clear(Protect.__connections)
        table.clear(Protect.__tasks)
        
        Protect.lastPulse = os.clock()
    end
end)

function Protect:Stop()
    Protect.__alive = false
end


local oldWarn = warn
warn = function(...)
    local msg = table.concat({...}, " ")
    if not string.find(msg, "SurfaceAppearance") and 
       not string.find(msg, "PBR") then
        oldWarn(...)
    end
end



local Dunhill = loadstring(game:HttpGet("https://raw.githubusercontent.com/Raistyan/DUNHILL/refs/heads/main/Dunhill.lua"))()

local Window = Dunhill:CreateWindow({
    Name = "Ghost Hun",
    ConfigurationSaving = {
        Enabled = true,
    }
})

local tab = Window:CreateTab({
    Name = "Farm"
})

local section = tab:CreateSection({ Name = "Fishing Controls" })

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
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")

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

---------------------------------------
-- ⚡ MODE BLATAN (DOUBLE REMOTE)
---------------------------------------
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

section:CreateToggle({
    Name = "Auto Fishing",
    Flag = "autoFishing",
    CurrentValue = false,
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

---------------------------------------
-- ⚡ TOGGLE MODE BLATAN
---------------------------------------
section:CreateToggle({
    Name = "Blatan Mode 2X",
    Flag = "blatanFishing",
    CurrentValue = false,
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

    -- 📦 INPUT WAIT DELAY (TEXTBOX)
    section:CreateInput({
        Name = "Wait Delay (detik)",
        PlaceholderText = "0.1",
        RemoveTextAfterFocusLost = false,
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


    -- 📦 INPUT CANCEL DELAY (TEXBOX)
    section:CreateInput({
        Name = "Cancel Delay (detik)",
        PlaceholderText = "0.1",
        RemoveTextAfterFocusLost = false,
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


-- ================================ --
-- BLATANT FISH (OPTIMIZED VERSION) --
-- ================================ --
local blatantSection = tab:CreateSection({ Name = "Blatant Super (Beta)" })

BlatantFishingDelay = 0.70
BlatantCancelDelay = 0.30
AutoFishEnabled = false

-- SAFE PARALLEL EXECUTION
local function safeFire(func)
    task.spawn(function()
        pcall(func)
    end)
end

-- MAIN LOOP (PARAMETER SESUAI GAME)
local function UltimateBypassFishing()
    task.spawn(function()
        while AutoFishEnabled do
            local currentTime = workspace:GetServerTimeNow()
            
            -- CAST
            safeFire(function()
                chargeRod:InvokeServer({[1] = currentTime})
            end)
            safeFire(function()
                startFishing:InvokeServer(1, 0, currentTime)
            end)
            
            task.wait(BlatantFishingDelay)
            
            -- COMPLETE
            safeFire(function()
                finishFishing:FireServer()
            end)
            
            task.wait(BlatantCancelDelay)
            
            -- CANCEL
            safeFire(function()
                cancelFishing:InvokeServer()
            end)
            
            task.wait() -- anti-freeze
        end
    end)
end

-- ✅ BIKIN COLLAPSIBLE (ACCORDION)
local blatantCollapse = blatantSection:CreateCollapsible({
    Name = "Blatant Settings",
    DefaultExpanded = false  -- Mulai collapsed
})

-- ✅ ISI DENGAN INPUT & TOGGLE
blatantCollapse:CreateInput({
    Name = "Fish Delay (detik)",
    PlaceholderText = "0.70",
    RemoveTextAfterFocusLost = false,
    Callback = function(value)
        local num = tonumber(value)
        if num then
            BlatantFishingDelay = num
            print("🎣 Fish Delay:", num)
        end
    end
})

blatantCollapse:CreateInput({
    Name = "Cancel Delay (detik)",
    PlaceholderText = "0.30",
    RemoveTextAfterFocusLost = false,
    Callback = function(value)
        local num = tonumber(value)
        if num then
            BlatantCancelDelay = num
            print("⏱️ Cancel Delay:", num)
        end
    end
})

blatantCollapse:CreateToggle({
    Name = "ON/OFF Blatant Super",
    CurrentValue = false,
    Callback = function(state)
        AutoFishEnabled = state
        if state then
            print("🟢 BLATANT: ON")
            UltimateBypassFishing()
        else
            print("🔴 BLATANT: OFF")
        end
    end
})

-- ======================================== --
-- 🎯 AUTO CLICKER STANDALONE + LEGIT MODE  
-- ========================================

local legitAndTap = false
local tapSpeed = 0.05 -- 50ms
local updateAutoFishingState = remotes:WaitForChild("RF/UpdateAutoFishingState")

-- 🎯 Buat UI Bulatan Kecil yang bisa digeser
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoClickerUI"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local dot = Instance.new("Frame")
dot.Size = UDim2.new(0, 20, 0, 20) -- Bulatan kecil
dot.Position = UDim2.new(0.5, -10, 0.5, -10) -- Posisi tengah
dot.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
dot.BackgroundTransparency = 0.5
dot.BorderSizePixel = 0
dot.Visible = false

-- Buat bentuk bulatan
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0) -- Bulat sempurna
UICorner.Parent = dot

dot.Parent = screenGui

-- 🎯 Function untuk drag bulatan
local dragging = false
local dragInput, dragStart, startPos

dot.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = dot.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

dot.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and (input == dragInput) then
        local delta = input.Position - dragStart
        dot.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X,
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- 🎯 Function untuk klik di posisi bulatan
local function clickAtDotPosition()
    pcall(function()
        local dotPosition = dot.AbsolutePosition
        local centerX = dotPosition.X + 10 -- Tengah bulatan
        local centerY = dotPosition.Y + 10
        
        if game:GetService("VirtualInputManager") then
            game:GetService("VirtualInputManager"):SendMouseButtonEvent(centerX, centerY, 0, true, game, 1)
            task.wait(0.01)
            game:GetService("VirtualInputManager"):SendMouseButtonEvent(centerX, centerY, 0, false, game, 1)
        end
    end)
end

-- 🔒 SATU TOGGLE untuk Legit Mode + Auto Tap
section:CreateToggle({
    Name = "🔒 Legit Mode + Auto Tap",
    CurrentValue = false,
    Callback = function(state)
        legitAndTap = state
        
        if state then
            print("🔒 Legit Mode + Auto Tap NYALA - 50ms")
            dot.Visible = true -- Tampilkan bulatan
            
            -- 1. Aktifin fitur auto fishing game
            pcall(function()
                updateAutoFishingState:InvokeServer(true)
            end)
            
            -- 2. Start auto tap loop di posisi bulatan
            task.spawn(function()
                while legitAndTap do
                    clickAtDotPosition() -- Klik di posisi bulatan
                    task.wait(tapSpeed) -- 50ms
                end
            end)
            
        else
            print("🔒 Legit Mode + Auto Tap MATI")
            dot.Visible = false -- Sembunyikan bulatan
            
            -- Matiin fitur auto fishing game
            pcall(function()
                updateAutoFishingState:InvokeServer(false)
            end)
        end
    end
})

-- 📝 Label info
section:CreateLabel({
    Text = "🎯 Drag bulatan merah - Klik dimana aja!"
})



print("🔒 Auto Clicker Standalone Loaded!")


local section = tab:CreateSection({ Name = "Fishing Animation" })

-- 🐟 Hilangkan Semua Animasi Mancing (Full)
local disableAnim = false

-- Kata yang dianggap animasi mancing
local blockedAnims = { "fish", "fishing", "rod", "cast", "reel", "hold", "idle" }

local function isFishingAnimation(obj)
    local name = string.lower(obj.Name or "")
    for _,v in ipairs(blockedAnims) do
        if string.find(name, v) then
            return true
        end
    end
    return false
end

-- Stop animasi dari Humanoid Animator
local function hookAnimator(char)
    local humanoid = char:WaitForChild("Humanoid", 2)
    if not humanoid then return end

    local animator = humanoid:FindFirstChildWhichIsA("Animator")
    if not animator then
        animator = Instance.new("Animator")
        animator.Parent = humanoid
    end

    animator.AnimationPlayed:Connect(function(track)
        if disableAnim and isFishingAnimation(track.Animation) then
            task.defer(function()
                track:Stop()
            end)
        end
    end)
end

-- Stop animasi dari Tool (FishingRod Tool Animation)
local function hookTools(char)
    char.ChildAdded:Connect(function(child)
        if child:IsA("Tool") and isFishingAnimation(child) then
            -- Stop Animation from Tool
            for _,v in ipairs(child:GetDescendants()) do
                if v:IsA("Animation") and disableAnim then
                    v:Destroy()  -- hapus animasi dari tool
                end
            end

            -- Stop animation track yang sempat dimainkan
            for _,track in ipairs(char.Humanoid:GetPlayingAnimationTracks()) do
                if isFishingAnimation(track.Animation) then
                    track:Stop()
                end
            end
        end
    end)
end

-- Setup awal
local character = player.Character or player.CharacterAdded:Wait()
hookAnimator(character)
hookTools(character)

player.CharacterAdded:Connect(function(char)
    task.wait(1)
    hookAnimator(char)
    hookTools(char)
end)

-- Toggle UI
section:CreateToggle({
    Name = "Hilangkan Semua Animasi Mancing",
    CurrentValue = false,
    Callback = function(state)
        disableAnim = state
        print(state and "🔥 Semua animasi mancing dimatikan" or "🎣 Animasi mancing aktif kembali")
    end
})


-- ═══════════════════════════════════════════════
-- 💰 JUAL SEMUA IKAN (CLEAN VERSION - NO POPUP)
-- ═══════════════════════════════════════════════

local section = tab:CreateSection({ Name = "Sell Fitur" })

section:CreateButton({
    Name = "Jual Semua Ikan",
    Callback = function()
        local sellAll = remotes:WaitForChild("RF/SellAllItems")
        sellAll:InvokeServer()
        print("💰 Semua ikan berhasil dijual!")
    end
})

section:CreateLabel({
    Text = "Tap Untuk Menjual Semua Ikan🐬"
})

-- ═══════════════════════════════════════════════
-- 💸 AUTO SELL TIAP 30 MENIT (CLEAN VERSION)
-- ═══════════════════════════════════════════════

local autoSellEnabled = false

section:CreateToggle({
    Name = "Auto Sell Tiap 30 menit",
    CurrentValue = false,
    Callback = function(state)
        autoSellEnabled = state
        if state then
            print("💰 Auto Sell aktif — ikan akan dijual tiap 30 menit.")
            task.spawn(function()
                while autoSellEnabled do
                    task.wait(1800) -- 30 menit
                    local sellAll = remotes:WaitForChild("RF/SellAllItems")
                    sellAll:InvokeServer()
                    print("🕒 Auto Sell: Semua ikan dijual otomatis.")
                end
            end)
        else
            print("🛑 Auto Sell dimatikan.")
        end
    end
})

-- 🗺️ Tab Map
local mapTab = Window:CreateTab({
    Name = "Teleport"
})

--====================================================--
-- 📍 SECTION 1: TELEPORT LOCATIONS
--====================================================--

local locationSection = mapTab:CreateSection({ Name = "Teleport Locations" })

-- daftar lokasi teleport
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

-- ambil semua nama lokasi
local locationNames = {}
for name, _ in pairs(teleportLocations) do
    table.insert(locationNames, name)
end

-- variabel lokasi terpilih
local selectedLocation = nil

-- dropdown pilih lokasi
locationSection:CreateDropdown({
    Name = "Pilih Lokasi",
    Options = locationNames,
    Callback = function(value)
        selectedLocation = value
        print("📍 Lokasi dipilih:", value)
    end
})

-- tombol teleport
locationSection:CreateButton({
    Name = "Teleport Sekarang",
    Callback = function()
        if not selectedLocation then
            print("⚠️ Pilih lokasi dulu sebelum teleport!")
            return
        end
        local player = game:GetService("Players").LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")
        hrp.CFrame = teleportLocations[selectedLocation]
        print("✅ Teleport ke " .. selectedLocation .. " berhasil!")
    end
})

locationSection:CreateLabel({
    Text = "Pilih Lokasi Dan Klik Teleport Sekarang"
})

--====================================================--
-- 👤 TELEPORT TO PLAYER (FIXED FOR PRIVATE SERVER)
--====================================================--

local playerSection = mapTab:CreateSection({ Name = "Teleport To Player" })

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local selectedPlayer = nil

local function refreshPlayerList()
    local list = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            table.insert(list, plr.DisplayName)
        end
    end
    return #list > 0 and list or {"(No Players)"} -- SAFE RETURN
end

local tpDropdown = playerSection:CreateDropdown({
    Name = "Pilih Player",
    Options = {"Cari Player"}, -- DEFAULT AMAN
    Callback = function(value)
        selectedPlayer = value
        print("Target:", selectedPlayer)
    end
})

-- Update setelah UI ready
task.wait(0.5)
tpDropdown:Refresh(refreshPlayerList())

-- Auto refresh setiap 5 detik
task.spawn(function()
    while task.wait(5) do
        pcall(function()
            tpDropdown:Refresh(refreshPlayerList())
        end)
    end
end)

playerSection:CreateButton({
    Name = "Teleport",
    Callback = function()
        if not selectedPlayer or selectedPlayer == "(Loading...)" or selectedPlayer == "(No Players)" then
            warn("❌ Pilih player valid!")
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
            LocalPlayer.Character:MoveTo(target.Character.HumanoidRootPart.Position + Vector3.new(0, 2, 0))
            print("✅ Teleported to", target.DisplayName)
        else
            warn("❌ Player tidak valid")
        end
    end
})

--====================================================--
-- 🌊 SECTION 3: EVENT TELEPORT + WALK ON WATER
--====================================================--

local eventSection = mapTab:CreateSection({ Name = "Teleport Game Event" })

-- Services
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
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
    local char = player.Character
    if not char then return end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    if state then
        -- Create platform if doesn't exist
        if not waterPlatform then
            waterPlatform = createWaterPlatform()
        end
        
        -- Start platform following
        if platformConnection then
            platformConnection:Disconnect()
        end
        
        platformConnection = RunService.Heartbeat:Connect(function()
            if not walkOnWaterEnabled then return end
            if not char or not char.Parent then return end
            
            local humanoid = char:FindFirstChild("Humanoid")
            if not humanoid then return end
            
            -- Position platform under player (water level)
            local waterLevel = -1.4 -- Game water level
            local platformY = waterLevel + 0.25 -- Slightly above water
            
            waterPlatform.Position = Vector3.new(
                hrp.Position.X,
                platformY,
                hrp.Position.Z
            )
        end)
        
        print("🌊 Walk on Water: ENABLED")
    else
        -- Disable platform
        if platformConnection then
            platformConnection:Disconnect()
            platformConnection = nil
        end
        
        if waterPlatform then
            waterPlatform:Destroy()
            waterPlatform = nil
        end
        
        print("💧 Walk on Water: DISABLED")
    end
end

-- Event Data
local Events = {
    ["Megalodon Hunt"] = {
        Keywords = {"megalodon"},
        Coords = {
            Vector3.new(-1076.3, -1.3999, 1676.19),
            Vector3.new(-1191.8, -1.3999, 3597.30),
            Vector3.new(412.7,  -1.3999, 4134.39)
        },
        Offset = Vector3.new(0, 0, -35)
    },

    ["Worm Hunt"] = {
        Keywords = {"worm"},
        Coords = {
            Vector3.new(2190.85, -1.3999, 97.5749),
            Vector3.new(-2450.6, -1.3999, 139.731),
            Vector3.new(-267.47,  -1.3999, 5188.53)
        },
        Offset = Vector3.new(0, 5, -25)
    },

    ["Ghost Shark Hunt"] = {
        Keywords = {"ghost"},
        Coords = {
            Vector3.new(489.558,  -1.35, 25.406),
            Vector3.new(-1358.2,  -1.35, 4100.55),
            Vector3.new(627.859,  -1.35, 3798.08)
        },
        Offset = Vector3.new(0, 5, -30)
    },

    ["Shark Hunt"] = {
        Keywords = {"shark"},
        Exclude = {"ghost"},
        Coords = {
            Vector3.new(1.64999,  -1.35, 2095.72),
            Vector3.new(1369.94,  -1.35, 930.125),
            Vector3.new(-1585.5,  -1.35, 1242.87),
            Vector3.new(-1896.8,  -1.35, 2634.37)
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
                local part =
                    obj:FindFirstChild("HumanoidRootPart")
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

-- Event UI
local options = {}
for name in pairs(Events) do table.insert(options, name) end
table.sort(options)

local selectedEvent
local currentPos

eventSection:CreateDropdown({
    Name = "Pilih Event",
    Options = options,
    Callback = function(v)
        selectedEvent = v
        currentPos = nil
    end
})

eventSection:CreateButton({
    Name = "🔄 Refresh Location",
    Callback = function()
        if not selectedEvent then return end
        local data = Events[selectedEvent]
        currentPos = data.Coords[math.random(#data.Coords)]
        warn("🔄", selectedEvent, "area refreshed")
    end
})

eventSection:CreateToggle({
    Name = "Teleport & Walk on Water",
    CurrentValue = false,
    Callback = function(state)
        if not selectedEvent then
            warn("❌ Pilih event dulu")
            return
        end

        local char = player.Character or player.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")
        local data = Events[selectedEvent]

        if state then
            -- PRIORITY 1: MODEL
            local modelPart = findEventModel(selectedEvent)
            if modelPart then
                hrp.CFrame = modelPart.CFrame * CFrame.new(data.Offset)
                setWalkOnWater(true)
                walkOnWaterEnabled = true
                warn("🎯 Teleport + Walk on Water ke MODEL:", selectedEvent)
                return
            end

            -- FALLBACK: COORDS
            if not currentPos then
                warn("❌ Model belum spawn & area belum di-refresh")
                return
            end

            hrp.CFrame = CFrame.new(currentPos + data.Offset)
            setWalkOnWater(true)
            walkOnWaterEnabled = true
            warn("📍 Teleport + Walk on Water ke AREA:", selectedEvent)
        else
            -- TOGGLE OFF
            setWalkOnWater(false)
            walkOnWaterEnabled = false
            warn("🟢 Walk on Water OFF (jalan normal)")
        end
    end
})


--====================================================--
-- 🔄 AUTO CLEANUP ON RESPAWN
--====================================================--

-- ✅ Cleanup SEBELUM character removed (anti leak)
player.CharacterRemoving:Connect(function()
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

player.CharacterAdded:Connect(function(char)
    task.wait(1)
    
    -- Reset walk on water
    if walkOnWaterEnabled then
        setWalkOnWater(false)
        walkOnWaterEnabled = false
    end
end)

-- Cleanup on script unload
game:GetService("Players").PlayerRemoving:Connect(function(plr)
    if plr == player then
        if platformConnection then
            platformConnection:Disconnect()
        end
        if waterPlatform then
            waterPlatform:Destroy()
        end
    end
end)






-- ⚡ Tab Sakti
local saktiTab = Window:CreateTab({
    Name = "Player"
})

local saktiSection = saktiTab:CreateSection({ Name = "Power Features" })

-- 🌪️ Variabel utama
local flyEnabled = false
local hoverLock = false
local flySpeed = 80
local bodyVelocity, bodyGyro



-- ✈️ Fly Mode (PC + Mobile)
saktiSection:CreateToggle({
    Name = "Fly Mode",
    CurrentValue = false,
    Callback = function(state)
        flyEnabled = state
        local char = player.Character or player.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")
        local humanoid = char:WaitForChild("Humanoid")

        if state then
            print("✈️ Fly Mode Aktif (PC + Mobile)")

            bodyVelocity = Instance.new("BodyVelocity")
            bodyGyro = Instance.new("BodyGyro")
            bodyVelocity.MaxForce = Vector3.new(400000, 400000, 400000)
            bodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000)
            bodyGyro.P = 9000
            bodyVelocity.Parent = hrp
            bodyGyro.Parent = hrp

            task.spawn(function()
                while flyEnabled and not hoverLock do
                    RunService.Heartbeat:Wait()
                    if not hrp or not bodyVelocity or not bodyGyro then break end

                    local cam = workspace.CurrentCamera
                    bodyGyro.CFrame = CFrame.new(hrp.Position, hrp.Position + cam.CFrame.LookVector)
                    local move = Vector3.zero

                    -- 🖥️ Keyboard (PC)
                    if not UserInputService.TouchEnabled then
                        if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
                        if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
                        if UserInputService:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
                        if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
                        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0, 1, 0) end
                        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move -= Vector3.new(0, 1, 0) end
                    else
                        -- 📱 Mobile: joystick + auto lift
                        local dir = humanoid.MoveDirection
                        if dir.Magnitude > 0 then
                            move = cam.CFrame:VectorToWorldSpace(Vector3.new(dir.X, 0.3, dir.Z))
                        else
                            move = Vector3.new(0, 0.2, 0)
                        end
                    end

                    if move.Magnitude > 0 then
                        bodyVelocity.Velocity = move.Unit * flySpeed
                    else
                        bodyVelocity.Velocity = Vector3.zero
                    end
                end
            end)
        else
            print("🛑 Fly Mode Nonaktif")
            if bodyVelocity then bodyVelocity:Destroy() end
            if bodyGyro then bodyGyro:Destroy() end
        end
    end
})

saktiSection:CreateInput({
    Name = "Fly Speed (10-200)",
    PlaceholderText = "80",
    RemoveTextAfterFocusLost = false,
    Callback = function(text)
        local num = tonumber(text)
        if num and num >= 10 and num <= 200 then
            flySpeed = num
            print("✈️ Fly Speed:", flySpeed)
        else
            print("❌ Input harus angka 10-200")
        end
    end
})

-- 🌀 Hover Lock (PC + Mobile)
saktiSection:CreateToggle({
    Name = "Hover Lock (Ngambang)",
    CurrentValue = false,
    Callback = function(state)
        hoverLock = state
        local char = player.Character or player.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")

        if state then
            print("🌀 Hover Lock Aktif — posisi terkunci di udara")
            local savedCFrame = hrp.CFrame

            -- matikan gaya terbang aktif
            if bodyVelocity then bodyVelocity.Velocity = Vector3.zero end

            task.spawn(function()
                while hoverLock do
                    RunService.Heartbeat:Wait()
                    if not hrp then break end
                    hrp.Velocity = Vector3.zero
                    hrp.CFrame = savedCFrame
                end
            end)
        else
            print("⚙️ Hover Lock Nonaktif")
        end
    end
})

saktiSection:CreateLabel({
    Text = "Aktifkan Toggle Untuk Kunci Posisi🔐"
})

-- ⚡ Speed Mode
local speedEnabled = false
local runSpeed = 50

saktiSection:CreateToggle({
    Name = "Speed Mode",
    CurrentValue = false,
    Callback = function(state)
        speedEnabled = state
        local hum = player.Character:WaitForChild("Humanoid")
        if state then
            hum.WalkSpeed = runSpeed
            print("⚡ Speed Mode Aktif")
        else
            hum.WalkSpeed = 16
            print("🛑 Speed Mode Nonaktif")
        end
    end
})

-- 🏃‍♂️ Slider Run Speed
saktiSection:CreateInput({
    Name = "Run Speed (16-200)",
    PlaceholderText = "50",
    RemoveTextAfterFocusLost = false,
    Callback = function(text)
        local num = tonumber(text)
        if num and num >= 16 and num <= 200 then
            runSpeed = num
            if speedEnabled then
                local hum = player.Character:FindFirstChild("Humanoid")
                if hum then
                    hum.WalkSpeed = num
                end
            end
            print("⚡ Run Speed:", runSpeed)
        else
            print("❌ Input harus angka 16-200")
        end
    end
})

local shopTab = Window:CreateTab({
    Name = "Shop"
})
--====================================================--
-- 🛒 SHOP - BUY ROD (UI SAFE)
--====================================================--

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

--====================================================--
-- 🔗 NET REMOTES (BENAR)
--====================================================--

local Net = ReplicatedStorage
    :WaitForChild("Packages")
    :WaitForChild("_Index")
    :WaitForChild("sleitnick_net@0.2.0")
    :WaitForChild("net")

local PurchaseRod = Net:WaitForChild("RF/PurchaseFishingRod")
local EquipItem = Net:WaitForChild("RE/EquipItem")

--====================================================--
-- 📦 DATA ROD
--====================================================--

local Rods = {
    {Name="Carbon Rod",Id=76,Price=750},
    {Name="Grass Rod",Id=85,Price=1500},
    {Name="Demascus Rod",Id=77,Price=3000},
    {Name="Ice Rod",Id=78,Price=5000},
    {Name="Lucky Rod",Id=4,Price=15000},
    {Name="Midnight Rod",Id=80,Price=50000},
    {Name="Steampunk Rod",Id=6,Price=215000},
    {Name="Chrome Rod",Id=7,Price=437000},
    {Name="Fluorescent Rod",Id=255,Price=715000},
    {Name="Astral Rod",Id=5,Price=1000000},
    {Name="Ares Rod",Id=126,Price=3000000},
    {Name="Angler Rod",Id=168,Price=8000000},
    {Name="Bamboo Rod",Id=258,Price=12000000},
}

--====================================================--
-- 🧠 UTIL
--====================================================--

local function HasRod(name)
    local inv = player:FindFirstChild("Rods")
    return inv and inv:FindFirstChild(name)
end

local function FormatPrice(p)
    if p >= 1e6 then
        return (p/1e6).."m"
    elseif p >= 1e3 then
        return (p/1e3).."k"
    end
    return tostring(p)
end

--====================================================--
-- 🛒 UI
--====================================================--

local shopSection = shopTab:CreateSection({
    Name = "Buy Fishing Rod"
})

local dropdownList = {}
local rodByLabel = {}
local selectedLabel

for _, rod in ipairs(Rods) do
    local owned = HasRod(rod.Name)
    local label = rod.Name.." ("..FormatPrice(rod.Price)..")"
    if owned then
        label ..= " ✔"
    end

    dropdownList[#dropdownList+1] = label
    rodByLabel[label] = rod
end

shopSection:CreateDropdown({
    Name = "Select Rod",
    Options = dropdownList,
    Callback = function(v)
        selectedLabel = v
    end
})

shopSection:CreateButton({
    Name = "Buy Selected Rod",
    Callback = function()
        if not selectedLabel then return end

        local rod = rodByLabel[selectedLabel]
        if not rod then return end

        if HasRod(rod.Name) then
            warn("Rod already owned")
            return
        end

        PurchaseRod:InvokeServer(rod.Id)

        task.delay(0.4, function()
            EquipItem:FireServer(rod.Id, "Fishing Rods")
        end)
    end
})


--====================================================--
-- 🪱 BUY BAIT SYSTEM (FIXED & SAFE)
--====================================================--

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- 🔗 REMOTES (VALID DARI RSPY)
local Net = ReplicatedStorage
    :WaitForChild("Packages")
    :WaitForChild("_Index")
    :WaitForChild("sleitnick_net@0.2.0")
    :WaitForChild("net")

local PurchaseBait = Net:WaitForChild("RF/PurchaseBait")
local EquipBait = Net:WaitForChild("RE/EquipBait")

--====================================================--
-- 📦 BAIT DATA
--====================================================--

local Baits = {
    {Name="Luck Bait", Id=2, Price=1000},
    {Name="Nature Bait", Id=17, Price=83500},
    {Name="Chroma Bait", Id=6, Price=290000},
    {Name="Dark Matter Bait", Id=8, Price=630000},
    {Name="Corrupt Bait", Id=15, Price=1148484},
    {Name="Aether Bait", Id=16, Price=3700000},
    {Name="Floral Bait", Id=20, Price=4000000},
}

--====================================================--
-- 🧠 UTIL
--====================================================--

local function FormatPrice(price)
    if price >= 1_000_000 then
        return string.format("%.1fm", price / 1_000_000):gsub("%.0","")
    elseif price >= 1_000 then
        return string.format("%.1fk", price / 1_000):gsub("%.0","")
    else
        return tostring(price)
    end
end

--====================================================--
-- 🛒 UI (PAKAI SHOP TAB YANG SUDAH ADA)
--====================================================--

local baitSection = shopTab:CreateSection({
    Name = "Buy Bait"
})

local BaitMap = {}
local DropdownList = {}

for _, bait in ipairs(Baits) do
    local label = bait.Name .. " (" .. FormatPrice(bait.Price) .. ")"
    DropdownList[#DropdownList+1] = label
    BaitMap[label] = bait
end

local SelectedBait = nil

baitSection:CreateDropdown({
    Name = "Select Bait",
    Options = DropdownList, -- ⚠️ STRING ONLY (ANTI ERROR)
    Callback = function(value)
        SelectedBait = BaitMap[value]
    end
})

baitSection:CreateButton({
    Name = "Buy & Equip Bait",
    Callback = function()
        if not SelectedBait then
            warn("No bait selected")
            return
        end

        -- 💰 BUY
        local success, result = pcall(function()
            return PurchaseBait:InvokeServer(SelectedBait.Id)
        end)

        if success then
            -- 🎣 AUTO EQUIP
            EquipBait:FireServer(SelectedBait.Id)
            print("✅ Bought & equipped:", SelectedBait.Name)
        else
            warn("❌ Failed to buy bait")
        end
    end
})

--====================================================--
-- ✅ END BUY BAIT
--====================================================--

--====================================================--
-- 🗿 TOTEM SHOP SYSTEM (NO PRICE VERSION)
--====================================================--

local totemSection = shopTab:CreateSection({
    Name = "Buy Totems"
})

--====================================================--
-- 📊 TOTEM DATA
--====================================================--

local Totems = {
    {Name = "Luck Totem", Id = 5, Icon = "rbxassetid://85563171162845"},
    {Name = "Mutation Totem", Id = 6, Icon = "rbxassetid://120458051113475"},
    {Name = "Shiny Totem", Id = 7, Icon = "rbxassetid://71168469297686"}
}

--====================================================--
-- 🔗 REMOTE
--====================================================--

local PurchaseMarketItem = Net:WaitForChild("RF/PurchaseMarketItem")

--====================================================--
-- 🛒 MANUAL BUY SYSTEM
--====================================================--

local selectedTotem = nil
local totemDropdownList = {}
local totemByLabel = {}

-- Build dropdown list
for _, totem in ipairs(Totems) do
    table.insert(totemDropdownList, totem.Name)
    totemByLabel[totem.Name] = totem
end

-- Dropdown untuk pilih totem
totemSection:CreateDropdown({
    Name = "Select Totem",
    Options = totemDropdownList,
    Callback = function(value)
        selectedTotem = totemByLabel[value]
        if selectedTotem then
            print("🗿 Selected:", selectedTotem.Name)
        end
    end
})

-- Button beli totem
totemSection:CreateButton({
    Name = "Buy Selected Totem",
    Callback = function()
        if not selectedTotem then
            warn("❌ Pilih totem dulu!")
            return
        end
        
        local success, result = pcall(function()
            return PurchaseMarketItem:InvokeServer(selectedTotem.Id)
        end)
        
        if success then
            print("✅ Bought:", selectedTotem.Name)
            
            -- Visual notification
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

totemSection:CreateLabel({
    Text = "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
})

--====================================================--
-- 🔄 AUTO BUY TOTEM SYSTEM
--====================================================--

local autoBuyTotem = false
local autoBuyInterval = 3540  -- 59 menit (buffer 1 menit sebelum expire)
local selectedAutoTotem = nil

totemSection:CreateLabel({
    Text = "🔄 Auto Buy System (Re-buy before expire)"
})

-- Dropdown untuk auto buy
totemSection:CreateDropdown({
    Name = "Auto Buy Totem",
    Options = totemDropdownList,
    Callback = function(value)
        selectedAutoTotem = totemByLabel[value]
        if selectedAutoTotem then
            print("🔄 Auto Buy Target:", selectedAutoTotem.Name)
        end
    end
})

-- Slider untuk interval (30-60 menit)
totemSection:CreateInput({
    Name = "Re-buy Interval (30-60 menit)",
    PlaceholderText = "59",
    RemoveTextAfterFocusLost = false,
    Callback = function(text)
        local num = tonumber(text)
        if num and num >= 30 and num <= 60 then
            autoBuyInterval = num * 60
            print("⏱️ Interval Set:", num, "minutes")
        end
    end
})

-- Toggle auto buy
totemSection:CreateToggle({
    Name = "Enable Auto Buy Totem",
    CurrentValue = false,
    Callback = function(state)
        autoBuyTotem = state
        
        if state then
            if not selectedAutoTotem then
                warn("❌ Pilih totem untuk auto buy dulu!")
                autoBuyTotem = false
                return
            end
            
            print("🟢 AUTO BUY TOTEM: ON")
            print("🗿 Target:", selectedAutoTotem.Name)
            print("⏱️ Interval:", autoBuyInterval / 60, "minutes")
            
            -- Auto buy loop
            task.spawn(function()
                while autoBuyTotem do
                    -- Buy totem
                    local success, result = pcall(function()
                        return PurchaseMarketItem:InvokeServer(selectedAutoTotem.Id)
                    end)
                    
                    if success then
                        print("✅ Auto bought:", selectedAutoTotem.Name, "at", os.date("%H:%M:%S"))
                        
                        -- Notification
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
                    
                    -- Wait interval (dengan countdown)
                    local countdown = autoBuyInterval
                    while countdown > 0 and autoBuyTotem do
                        task.wait(60)  -- Check every minute
                        countdown = countdown - 60
                        
                        if countdown > 0 and countdown % 300 == 0 then  -- Every 5 minutes
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
-- 📊 STATUS MONITOR
--====================================================--

totemSection:CreateLabel({
    Text = "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
})

local statusTotem = totemSection:CreateLabel({
    Text = "Status: Idle"
})

-- Real-time status update
task.spawn(function()
    while true do
        task.wait(1)
        
        if autoBuyTotem and selectedAutoTotem then
            statusTotem.Text = "🟢 Auto Buying: " .. selectedAutoTotem.Name
        else
            statusTotem.Text = "🔴 Status: Idle"
        end
    end
end)


print("✅ TOTEM SHOP SYSTEM LOADED!")

-- ========================================
-- 🛍️ MERCHANT GUI OPENER (SIMPLE VERSION)
-- ========================================

local merchantSection = shopTab:CreateSection({ Name = "Open Merchant" })

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ========================================
-- 📦 GET MERCHANT GUI
-- ========================================

local function getMerchantGUI()
    local merchant = playerGui:FindFirstChild("Merchant")
    if not merchant then
        warn("❌ Merchant GUI not found!")
        return nil
    end
    return merchant
end

-- ========================================
-- 🔓 OPEN MERCHANT
-- ========================================

local function openMerchant()
    local merchant = getMerchantGUI()
    if not merchant then return end
    
    -- Enable GUI
    merchant.Enabled = true
    
    -- Make sure Main & Background visible
    local main = merchant:FindFirstChild("Main")
    if main then
        main.Visible = true
        
        local background = main:FindFirstChild("Background")
        if background then
            background.Visible = true
        end
    end
    
end

-- ========================================
-- 🔒 CLOSE MERCHANT
-- ========================================

local function closeMerchant()
    local merchant = getMerchantGUI()
    if not merchant then return end
    
    -- Try clicking close button first
    local closeBtn = merchant:FindFirstChild("Close", true)
    if closeBtn then
        pcall(function()
            for _, conn in pairs(getconnections(closeBtn.MouseButton1Click)) do
                conn:Fire()
            end
        end)
        task.wait(0.1)
    end
    
    -- Fallback: manual close
    merchant.Enabled = false
    
end

-- ========================================
-- 🎛️ UI BUTTONS
-- ========================================

merchantSection:CreateButton({
    Name = "Open Merchant",
    Callback = function()
        openMerchant()
    end
})

merchantSection:CreateButton({
    Name = "Close Merchant",
    Callback = function()
        closeMerchant()
    end
})


print("✅ Merchant GUI Controls Loaded!")


local cuacaTab = Window:CreateTab({
    Name = "Cuaca"
})

-- Tambahkan di bagian Tab Cuaca

local cuacaSection = cuacaTab:CreateSection({ Name = "Weather Machine System" })

-- ==========================================
-- VARIABLES
-- ==========================================
local AutoBuyWeather = false
local SelectedWeathers = {}

-- ✅ DEKLARASI VARIABLE DI LUAR (SCOPE GLOBAL KE SECTION)
local weather1 = nil
local weather2 = nil
local weather3 = nil

-- ==========================================
-- REMOTE FUNCTION
-- ==========================================
local RFPurchaseWeatherEvent = ReplicatedStorage
    :WaitForChild("Packages")
    :WaitForChild("_Index")
    :WaitForChild("sleitnick_net@0.2.0")
    :WaitForChild("net")
    :WaitForChild("RF/PurchaseWeatherEvent")

-- ==========================================
-- DAFTAR CUACA
-- ==========================================
local AllWeathers = {
    "Cloudy",
    "Storm", 
    "Wind",
    "Snow",
    "Radiant",
    "Shark Hunt"
}

-- ==========================================
-- FUNCTION BUY WEATHER
-- ==========================================
local function BuyWeather(weatherName)
    local success, err = pcall(function()
        RFPurchaseWeatherEvent:InvokeServer(weatherName)
    end)
    
    if success then
        print("🌤️ Beli cuaca:", weatherName)
    else
        warn("❌ Gagal beli cuaca:", weatherName)
    end
end

-- ==========================================
-- FUNCTION UPDATE SELECTED WEATHERS
-- ==========================================
local function updateSelectedWeathers()
    SelectedWeathers = {}
    if weather1 then table.insert(SelectedWeathers, weather1) end
    if weather2 then table.insert(SelectedWeathers, weather2) end
    if weather3 then table.insert(SelectedWeathers, weather3) end
    print("📋 Selected:", table.concat(SelectedWeathers, ", "))
end

-- ==========================================
-- COMPACT SELECTION SYSTEM
-- ==========================================

cuacaSection:CreateLabel({
    Text = "Pilih Cuaca (Klik 3x untuk pilih 3 cuaca)"
})

-- Dropdown untuk Weather 1
cuacaSection:CreateDropdown({
    Name = "Weather Slot 1",
    Options = AllWeathers,
    Callback = function(value)
        weather1 = value  -- ✅ Update variable yang sudah dideklarasi di atas
        updateSelectedWeathers()
    end
})

-- Dropdown untuk Weather 2
cuacaSection:CreateDropdown({
    Name = "Weather Slot 2",
    Options = AllWeathers,
    Callback = function(value)
        weather2 = value
        updateSelectedWeathers()
    end
})

-- Dropdown untuk Weather 3
cuacaSection:CreateDropdown({
    Name = "Weather Slot 3",
    Options = AllWeathers,
    Callback = function(value)
        weather3 = value
        updateSelectedWeathers()
    end
})

-- ==========================================
-- AUTO MAINTAIN WEATHER
-- ==========================================

cuacaSection:CreateToggle({
    Name = "🔄 Auto Maintain Weather",
    CurrentValue = false,
    Callback = function(state)
        AutoBuyWeather = state
        
        if state then
            if #SelectedWeathers == 0 then
                warn("❌ Pilih minimal 1 cuaca dulu!")
                return
            end
            
            print("🟢 AUTO WEATHER: ON")
            print("📌 Maintaining:", table.concat(SelectedWeathers, ", "))
            
            -- AUTO BUY LOOP
            task.spawn(function()
                while AutoBuyWeather do
                    for _, weather in ipairs(SelectedWeathers) do
                        if not AutoBuyWeather then break end
                        BuyWeather(weather)
                        task.wait(2)
                    end
                    task.wait(18)
                end
            end)
            
        else
            print("🔴 AUTO WEATHER: OFF")
        end
    end
})

-- ==========================================
-- MANUAL CONTROL
-- ==========================================

cuacaSection:CreateButton({
    Name = "Beli Semua Sekarang",
    Callback = function()
        if #SelectedWeathers == 0 then
            warn("❌ Belum ada cuaca yang dipilih!")
            return
        end
        
        print("💰 Membeli", #SelectedWeathers, "cuaca...")
        for _, weather in ipairs(SelectedWeathers) do
            BuyWeather(weather)
            task.wait(1)
        end
        print("✅ Selesai membeli!")
    end
})

-- ==========================================
-- STATUS MONITOR
-- ==========================================

cuacaSection:CreateLabel({
    Text = "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
})

local statusLabel = cuacaSection:CreateLabel({
    Text = "Status: Idle | Slots: 0/3"
})

-- Update status real-time
task.spawn(function()
    while true do
        task.wait(5)  -- ✅ Update tiap 5 detik aja
        
        local slots = #SelectedWeathers
        local mode = AutoBuyWeather and "🟢 Auto Maintaining" or "🔴 Manual"
        local weatherList = #SelectedWeathers > 0 and 
            table.concat(SelectedWeathers, ", ") or 
            "Belum ada"
        
        statusLabel.Text = mode .. " | Slots: " .. slots .. "/3 | " .. weatherList
    end
end)

print("✅ COMPACT WEATHER SYSTEM LOADED!")





local performanceTab = Window:CreateTab({
    Name = "Fitur Tambahan"
})

-- BUAT SECTION-NYA DULU
local PerformanceSection = performanceTab:CreateSection("Boost / Optimization")

local renderOff = false
local RunService = game:GetService("RunService")

PerformanceSection:CreateToggle({
    Name = "Disable Render 3D",
    CurrentValue = false,
    Callback = function(state)
        renderOff = state

        -- Matikan / hidupkan render 3D
        RunService:Set3dRenderingEnabled(not state)

        print(state and "🔇 Render 3D Disabled (Layar Gelap)" or "🔆 Render 3D Enabled (Normal)")
    end
})

-- BOOST FPS - TEXTURE SMOOTHER
local textureBoost = false

local function ApplyTextureBoost()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Part") or obj:IsA("MeshPart") then
            obj.Material = Enum.Material.SmoothPlastic
            obj.Reflectance = 0
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = 1 -- sembunyikan tekstur berat
        end
    end

    -- Kurangi kualitas rendering
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01

    print("⚡ Texture Boost Applied")
end

local function RemoveTextureBoost()
    -- Kualitas auto
    settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic

    -- Kembalikan decal / texture
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = 0
        end
    end

    print("♻ Texture Boost Removed")
end

PerformanceSection:CreateToggle({
    Name = "Boost FPS",
    CurrentValue = false,
    Callback = function(state)
        textureBoost = state

        if state then
            ApplyTextureBoost()
        else
            RemoveTextureBoost()
        end
    end
})

local disableSmallNotification = false
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Toggle di tab Fitur
PerformanceSection:CreateToggle({
    Name = "Disable POP UP",
    CurrentValue = false,
    Callback = function(state)
        disableSmallNotification = state
        

        if state then
            -- Hapus yang sudah ada
            for _, obj in ipairs(playerGui:GetChildren()) do
                if obj.Name == "Small Notification" then
                    obj:Destroy()
                    
                end
            end
        end
    end
})

-- Listener untuk setiap anak baru PlayerGui
playerGui.ChildAdded:Connect(function(child)
    if disableSmallNotification and child.Name == "Small Notification" then
        child:Destroy()
        
    end
end)

local performanceSection = performanceTab:CreateSection({ Name = "Utility" })

local hideNameEnabled = false
local hideNameTask

performanceSection:CreateToggle({
    Name = "Hide Name",
    CurrentValue = false,
    Callback = function(state)
        hideNameEnabled = state
        
        -- Hentikan task lama
        if hideNameTask then
            task.cancel(hideNameTask)
            hideNameTask = nil
        end
        
        if state then
            print("👻 Hide Name: AKTIF - Menyembunyikan name tag")

            local function hideTags()
                if player.Character then
                    for _, v in ipairs(player.Character:GetDescendants()) do
                        if v:IsA("BillboardGui") then
                            v.Enabled = false
                        end
                    end
                end
            end

            -- Jalankan sekarang
            hideTags()

            -- Loop biar tetap hidden
            hideNameTask = task.spawn(function()
                while hideNameEnabled and task.wait(1) do
                    hideTags()
                end
            end)

        else
            print("👤 Hide Name: NONAKTIF - Menampilkan name tag kembali")

            if player.Character then
                for _, v in ipairs(player.Character:GetDescendants()) do
                    if v:IsA("BillboardGui") then
                        v.Enabled = true
                    end
                end
            end
        end
    end
})

-- Auto apply saat respawn
player.CharacterAdded:Connect(function(char)
    task.wait(2)
    if hideNameEnabled then
        for _, v in ipairs(char:GetDescendants()) do
            if v:IsA("BillboardGui") then
                v.Enabled = false
            end
        end
    else
        for _, v in ipairs(char:GetDescendants()) do
            if v:IsA("BillboardGui") then
                v.Enabled = true
            end
        end
    end
end)

performanceSection:CreateLabel({
    Text = "Sembunyikan name tag karakter kamu 👻"
})

local tambahanSection = performanceTab:CreateSection({
    Name = "Anti AFK"
})

-- 💤 ANTI AFK HYBRID (Camera Move + Fake Touch)
local antiAFK = false
local UIS = game:GetService("UserInputService")
local VU = game:GetService("VirtualUser")

local function AntiAfkPing()
    VU:CaptureController()
    VU:ClickButton2(Vector2.new(), game:GetService("Workspace").CurrentCamera.CFrame)

    local cam = workspace.CurrentCamera
    cam.CFrame = cam.CFrame * CFrame.Angles(0, math.rad(1), 0)

    print("🔄 Anti AFK Hybrid Triggered")
end

tambahanSection:CreateToggle({
    Name = "Anti AFK Hybrid",
    CurrentValue = false,
    Callback = function(state)
        antiAFK = state
        print(state and "🟢 Anti AFK Hybrid ON" or "🔴 Anti AFK Hybrid OFF")

        if state then
            task.spawn(function()
                while antiAFK do
                    task.wait(math.random(240, 360))
                    if not antiAFK then break end
                    AntiAfkPing()
                end
            end)
        end
    end
})


-- ============================
-- 🪄 Disable Skin Effects (VFX)
-- ============================
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Buat section khusus di tab "Fitur Tambahan"
local vfxSection = performanceTab:CreateSection({ Name = "Disable Skin Effect" })

local disableVFX = false
local VFXFolder = ReplicatedStorage:FindFirstChild("VFX")
local VFXBackup = nil

-- ✅ FIXED: Hapus backup lama sebelum bikin baru
local function createBackup()
    -- Destroy backup lama dulu (anti memory leak)
    if VFXBackup then
        pcall(function() VFXBackup:Destroy() end)
        VFXBackup = nil
    end
    
    VFXFolder = ReplicatedStorage:FindFirstChild("VFX")
    if VFXFolder then
        VFXBackup = Instance.new("Folder")
        VFXBackup.Name = "VFXBackup"
        for _, obj in ipairs(VFXFolder:GetChildren()) do
            pcall(function() obj:Clone().Parent = VFXBackup end)
        end
        print("✅ VFX Backup created:", #VFXBackup:GetChildren(), "objects")
    else
        VFXBackup = nil
    end
end

-- Buat backup saat script load
createBackup()

-- Jika folder VFX dibuat/dihapus ulang di runtime, update backup otomatis
ReplicatedStorage.ChildAdded:Connect(function(child)
    if child.Name == "VFX" then
        task.wait(0.1)
        createBackup()
    end
end)
ReplicatedStorage.ChildRemoved:Connect(function(child)
    if child.Name == "VFX" then
        VFXFolder = nil
        VFXBackup = nil
    end
end)

-- Toggle UI (pakai CreateToggle sesuai style UI kamu)
vfxSection:CreateToggle({
    Name = "Disable Skin Effect",
    CurrentValue = false,
    Callback = function(state)
        disableVFX = state

        -- Pastikan folder ada (coba cari lagi)
        VFXFolder = ReplicatedStorage:FindFirstChild("VFX")
        if not VFXFolder then
            warn("⚠ Folder VFX tidak ditemukan di ReplicatedStorage!")
            return
        end

        if disableVFX then
            -- Hapus semua child di VFX
            for _, obj in ipairs(VFXFolder:GetChildren()) do
                pcall(function() obj:Destroy() end)
            end
            print("✨ Semua efek skin telah di-disable")
        else
            -- Restore dari backup (jika ada)
            if VFXBackup then
                -- Hapus isi sekarang dulu (aman)
                for _, obj in ipairs(VFXFolder:GetChildren()) do
                    pcall(function() obj:Destroy() end)
                end
                -- Clone backup kembali
                for _, obj in ipairs(VFXBackup:GetChildren()) do
                    pcall(function() obj:Clone().Parent = VFXFolder end)
                end
                print("🔄 Efek skin telah di-restore")
            else
                warn("⚠ Tidak ada backup VFX. Tidak dapat me-restore.")
            end
        end
    end
})


-- 📸 Unlimited Camera Zoom Out
local unlimitedZoom = false
local Players = game:GetService("Players")
local player = Players.LocalPlayer

performanceSection:CreateToggle({
    Name = "Unlimited Camera Zoom",
    CurrentValue = false,
    Callback = function(state)
        unlimitedZoom = state

        if state then
            print("📸 Unlimited Camera Zoom: ON")

            -- Set zoom max tinggi banget
            player.CameraMaxZoomDistance = 999999
            player.CameraMinZoomDistance = 0

            -- Auto enforce bila game mereset
            task.spawn(function()
                while unlimitedZoom do
                    task.wait(0.2)
                    player.CameraMaxZoomDistance = 999999
                    player.CameraMinZoomDistance = 0
                end
            end)

        else
            print("📸 Unlimited Camera Zoom: OFF")

            -- Kembalikan default Roblox
            player.CameraMaxZoomDistance = 128
            player.CameraMinZoomDistance = 0.5
        end
    end
})


-- Tambahin di section "Utility" atau bikin section baru di tab "Fitur Tambahan"

local animSection = performanceTab:CreateSection({ Name = "Skin Animation" })

--====================================================--
-- 🎨 CUSTOM SKIN ANIMATION - FISH CAUGHT ONLY
--====================================================--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")

local Animator = humanoid:FindFirstChildOfClass("Animator")
if not Animator then
    Animator = Instance.new("Animator", humanoid)
end

--====================================================--
-- 📦 SKIN ANIMATION DATABASE (FISH CAUGHT ONLY)
--====================================================--

local SkinAnimations = {
    ["Holy Trident"] = "rbxassetid://128167068291703",
    ["Soul Scythe"] = "rbxassetid://82259219343456",
    ["Oceanic Harpoon"] = "rbxassetid://76325124055693",
    ["Binary Edge"] = "rbxassetid://109653945741202",
    ["The Vanquisher"] = "rbxassetid://93884986836266",
    ["Frozen Krampus Scythe"] = "rbxassetid://134934781977605",
    ["1x1x1x1 Ban Hammer"] = "rbxassetid://96285280763544",
    ["Corruption Edge"] = "rbxassetid://126613975718573",
    ["Eclipse Katana"] = "rbxassetid://107940819382815",
    ["Princess Parasol"] = "rbxassetid://99143072029495"
}

--====================================================--
-- 🎬 VARIABLES
--====================================================--

local SelectedSkin = "Holy Trident" -- Default
local FishCaughtAnim = nil
local FishCaughtTrack = nil
local AutoReplaceEnabled = false
local activeConnection = nil

--====================================================--
-- 🔄 LOAD SELECTED SKIN ANIMATION
--====================================================--

local function LoadSkinAnimation(skinName)
    local animId = SkinAnimations[skinName]
    if not animId then
        warn("❌ Skin not found:", skinName)
        return
    end
    
    -- Stop old animation
    if FishCaughtTrack and FishCaughtTrack.IsPlaying then
        FishCaughtTrack:Stop()
    end
    
    -- Create new animation
    FishCaughtAnim = Instance.new("Animation")
    FishCaughtAnim.AnimationId = animId
    FishCaughtAnim.Name = skinName .. "_FishCaught"
    
    -- Load animation track
    FishCaughtTrack = Animator:LoadAnimation(FishCaughtAnim)
    FishCaughtTrack.Priority = Enum.AnimationPriority.Action4
    FishCaughtTrack.Looped = false
    
    print("✅ Loaded:", skinName, "FishCaught Animation")
end

--====================================================--
-- 🐟 DETECTION & REPLACEMENT
--====================================================--

local function ReplaceFishCaughtAnimation()
    if not AutoReplaceEnabled or not FishCaughtTrack then return end
    
    for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
        local trackName = string.lower(track.Name or "")
        local animName = string.lower(track.Animation.Name or "")
        
        -- Skip our custom animation
        if string.find(trackName, "fishcaught") and string.find(trackName, string.lower(SelectedSkin)) then
            continue
        end
        
        -- Detect Fish Caught animation
        if (string.find(trackName, "fish") or 
            string.find(animName, "caught") or 
            string.find(animName, "fish")) and
           not track.Looped and 
           track.Priority == Enum.AnimationPriority.Action4 then
            
            -- Stop default
            track:Stop()
            
            -- Play custom
            FishCaughtTrack:Play()
            
        end
    end
end

--====================================================--
-- 🖥 DUNHILL UI INTEGRATION
--====================================================--

-- Build skin list for dropdown
local skinList = {}
for skinName, _ in pairs(SkinAnimations) do
    table.insert(skinList, skinName)
end
table.sort(skinList)

-- Dropdown untuk pilih skin
animSection:CreateDropdown({
    Name = "Pilih Skin Animation",
    Options = skinList,
    Default = "Holy Trident",
    Callback = function(selected)
        SelectedSkin = selected
        print("🎨 Selected Skin:", selected)
        
        -- Load animation langsung
        LoadSkinAnimation(selected)
    end
})

-- Toggle ON/OFF
animSection:CreateToggle({
    Name = "Enable Custom Animation",
    CurrentValue = false,
    Callback = function(state)
        AutoReplaceEnabled = state
        
        if state then
            print("⚡ Custom Animation: ON -", SelectedSkin)
            
            -- Load selected skin animation
            LoadSkinAnimation(SelectedSkin)
            
            -- Setup monitoring
            if activeConnection then
                activeConnection:Disconnect()
            end
            
            activeConnection = RunService.Heartbeat:Connect(function()
                ReplaceFishCaughtAnimation()
            end)
            
        else
            print("🛑 Custom Animation: OFF")
            
            -- Stop monitoring
            if activeConnection then
                activeConnection:Disconnect()
                activeConnection = nil
            end
            
            -- Stop custom animation if playing
            if FishCaughtTrack and FishCaughtTrack.IsPlaying then
                FishCaughtTrack:Stop()
            end
        end
    end
})

-- Info label
animSection:CreateLabel({
    Text = "🎨 Pilih skin di dropdown → Toggle ON"
})

--====================================================--
-- 🔄 AUTO REAPPLY ON RESPAWN
--====================================================--

player.CharacterAdded:Connect(function(newChar)
    task.wait(2)
    char = newChar
    humanoid = char:WaitForChild("Humanoid")
    Animator = humanoid:FindFirstChildOfClass("Animator")
    if not Animator then
        Animator = Instance.new("Animator", humanoid)
    end
    
    -- Reload animation jika toggle masih ON
    if AutoReplaceEnabled then
        LoadSkinAnimation(SelectedSkin)
        print("🔄 Reapplying", SelectedSkin, "FishCaught after respawn")
    end
end)

print("🎨 Custom Skin Animation System Loaded!")



local webhookTab = Window:CreateTab({
    Name = "Webhook"
})

local webhookSection = webhookTab:CreateSection({ Name = "Discord Configuration" })

-- ==========================================
-- WEBHOOK CONFIG VARIABLES
-- ==========================================
local WEBHOOK_URL = ""  -- User custom webhook
local WEBHOOK_ENABLED = false
local DiscordUserID = ""  -- Discord User ID untuk mention
local CustomUsername = player.Name  -- Default username

-- Filter Rarity (default semua aktif)
local rarityFilters = {
    Common = true,
    Uncommon = true,
    Rare = true,
    Epic = true,
    Legendary = true,
    Mythic = true,
    SECRET = true
}

-- ==========================================
-- DATA TIER MAPPING
-- ==========================================
local TIER_NAMES = {
    [1] = "Common",
    [2] = "Uncommon", 
    [3] = "Rare",
    [4] = "Epic",
    [5] = "Legendary",
    [6] = "Mythic",
    [7] = "SECRET"
}

local TIER_COLORS = {
    [1] = 11184810,  -- Gray (Common)
    [2] = 5763719,   -- Green (Uncommon)
    [3] = 2067276,   -- Blue (Rare)
    [4] = 10181046,  -- Purple (Epic)
    [5] = 15844367,  -- Orange (Legendary)
    [6] = 16711935,  -- Magenta (Mythic)
    [7] = 16711680   -- Red (SECRET)
}

-- ==========================================
-- HELPER FUNCTIONS
-- ==========================================
local function getTierName(tierNumber)
    return TIER_NAMES[tierNumber] or "Unknown"
end

local function getTierColor(tierNumber)
    return TIER_COLORS[tierNumber] or 0
end

-- Fungsi untuk cari ikan berdasarkan Item ID
local function getFishData(itemId)
    local itemsModule = require(ReplicatedStorage:WaitForChild("Items"))
    for _, fish in pairs(itemsModule) do
        if fish.Data and fish.Data.Id == itemId then
            return fish
        end
    end
    return nil
end

-- Fungsi untuk cari variant berdasarkan Variant ID
local function getVariantData(variantId)
    if not variantId then return nil end
    
    local variantsModule = require(ReplicatedStorage:WaitForChild("Variants"))
    for _, variant in pairs(variantsModule) do
        if variant.Data and variant.Data.Id == variantId then
            return variant
        end
    end
    return nil
end

-- ==========================================
-- SEND TO DISCORD FUNCTION
-- ==========================================
local function sendToDiscord(fishName, weight, tierNumber, sellPrice, icon, variantData, displayName, userID)
    if not WEBHOOK_ENABLED or WEBHOOK_URL == "" then 
        print("⚠️ Webhook disabled atau URL kosong")
        return 
    end
    
    -- Cek filter rarity
    local tierName = getTierName(tierNumber)
    if not rarityFilters[tierName] then
        print("⏭️ Skipped:", fishName, "(" .. tierName .. ") - Filter OFF")
        return
    end
    
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print("🚀 Sending to Discord...")
    print("Player:", displayName)
    print("Fish:", fishName)
    print("Weight:", weight, "kg")
    print("Tier:", tierName)
    
    -- Validasi icon URL
    local validIcon = (icon and icon ~= "" and string.match(icon, "^http")) and icon or "https://i.imgur.com/placeholder.png"
    
    -- Build fields
    local fields = {
        {["name"] = "👤 Player", ["value"] = displayName, ["inline"] = true},
        {["name"] = "🐟 Fish Name", ["value"] = tostring(fishName), ["inline"] = true},
        {["name"] = "⚖️ Weight", ["value"] = tostring(weight) .. " kg", ["inline"] = true},
        {["name"] = "✨ Rarity", ["value"] = tierName, ["inline"] = true}
    }
    
    -- Mutation field
    if variantData then
        local mutationValue = "✨ " .. variantData.Data.Name .. " (" .. tostring(variantData.SellMultiplier) .. "x)"
        table.insert(fields, {
            ["name"] = "🧬 Mutation", 
            ["value"] = mutationValue, 
            ["inline"] = true
        })
        print("Mutation:", variantData.Data.Name, "(" .. variantData.SellMultiplier .. "x)")
    else
        table.insert(fields, {
            ["name"] = "🧬 Mutation", 
            ["value"] = "None", 
            ["inline"] = true
        })
    end
    
    -- Calculate final sell price with variant multiplier
    local finalSellPrice = sellPrice
    if variantData and variantData.SellMultiplier then
        finalSellPrice = sellPrice * variantData.SellMultiplier
    end
    
    table.insert(fields, {
        ["name"] = "💰 Sell Price", 
        ["value"] = "$" .. tostring(math.floor(finalSellPrice)), 
        ["inline"] = true
    })
    
    print("Sell Price: $" .. math.floor(finalSellPrice))
    
    -- Get tier color
    local embedColor = getTierColor(tierNumber)
    if variantData then
        embedColor = 16776960  -- Gold color for mutation
    end
    
    -- Build mention string
    local mentionText = ""
    if userID and userID ~= "" then
        mentionText = "<@" .. userID .. "> "
    end
    
    -- Build embed
    local embed = {
        ["content"] = mentionText .. "🎣 **New Fish Caught!**",
        ["embeds"] = {{
            ["title"] = "🐟 " .. fishName .. " Caught!",
            ["description"] = "**" .. tierName .. "** rarity fish has been caught!",
            ["color"] = embedColor,
            ["fields"] = fields,
            ["thumbnail"] = {["url"] = validIcon},
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ"),
            ["footer"] = {
                ["text"] = "Ghost Fish Logger",
                ["icon_url"] = "https://i.imgur.com/fishing.png"
            }
        }}
    }

    local jsonData = game:GetService("HttpService"):JSONEncode(embed)

    -- Send webhook
    local success, response = pcall(function()
        local request = (syn and syn.request) or 
                       (http and http.request) or 
                       (http_request) or 
                       (request)
        
        if not request then
            error("❌ HTTP request function not found!")
        end
        
        return request({
            Url = WEBHOOK_URL,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = jsonData
        })
    end)
    
    if success then
        print("✅ Webhook sent successfully!")
        if response then
            print("📡 Status:", response.StatusCode or "N/A")
        end
    else
        warn("❌ Failed to send webhook!")
        warn("Error:", tostring(response))
    end
    
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
end

-- ==========================================
-- LISTEN FISH EVENT
-- ==========================================
local fishEvent = ReplicatedStorage:WaitForChild("Packages")
    :WaitForChild("_Index")
    :WaitForChild("sleitnick_net@0.2.0")
    :WaitForChild("net")
    :WaitForChild("RE/ObtainedNewFishNotification")

fishEvent.OnClientEvent:Connect(function(itemId, metadata, extraData, boolFlag)
    if not WEBHOOK_ENABLED then return end
    
    local fishData = getFishData(itemId)
    if not fishData then 
        print("⚠️ Fish data not found for ID:", itemId)
        return 
    end

    -- Get variant data if exists
    local variantData = nil
    if metadata and metadata.Variant then
        variantData = getVariantData(metadata.Variant)
    end

    -- Send to Discord
    sendToDiscord(
        fishData.Data.Name,
        metadata.Weight or 0,
        fishData.Data.Tier,
        fishData.SellPrice or 0,
        fishData.Data.Icon,
        variantData,
        CustomUsername,
        DiscordUserID
    )
end)

-- ==========================================
-- UI ELEMENTS
-- ==========================================

-- Toggle Enable/Disable Webhook
webhookSection:CreateToggle({
    Name = "Enable Webhook",
    CurrentValue = false,
    Callback = function(state)
        WEBHOOK_ENABLED = state
        print(state and "🔔 Webhook ENABLED" or "🔕 Webhook DISABLED")
    end
})

-- Input Webhook URL
webhookSection:CreateInput({
    Name = "Discord Webhook URL",
    PlaceholderText = "https://discord.com/api/webhooks/...",
    RemoveTextAfterFocusLost = false,
    Callback = function(text)
        if text and text ~= "" and string.match(text, "^https://discord.com/api/webhooks/") then
            WEBHOOK_URL = text
            print("✅ Webhook URL Set!")
        else
            print("❌ Invalid Webhook URL!")
        end
    end
})


-- Input Custom Username
webhookSection:CreateInput({
    Name = "Display Username (Optional)",
    PlaceholderText = player.Name,
    RemoveTextAfterFocusLost = false,
    Callback = function(text)
        if text and text ~= "" then
            CustomUsername = text
            print("✅ Custom Username Set:", text)
        else
            CustomUsername = player.Name
            print("⚠️ Username Reset to:", player.Name)
        end
    end
})

-- ==========================================
-- RARITY FILTER SECTION
-- ==========================================
local filterSection = webhookTab:CreateSection({ Name = "Rarity Filter" })

filterSection:CreateLabel({
    Text = "Select which rarities to send to Discord:"
})

-- Common Filter
filterSection:CreateToggle({
    Name = "Common",
    CurrentValue = true,
    Callback = function(state)
        rarityFilters.Common = state
        print("Common Filter:", state and "ON" or "OFF")
    end
})

-- Uncommon Filter
filterSection:CreateToggle({
    Name = "Uncommon",
    CurrentValue = true,
    Callback = function(state)
        rarityFilters.Uncommon = state
        print("Uncommon Filter:", state and "ON" or "OFF")
    end
})

-- Rare Filter
filterSection:CreateToggle({
    Name = "Rare",
    CurrentValue = true,
    Callback = function(state)
        rarityFilters.Rare = state
        print("Rare Filter:", state and "ON" or "OFF")
    end
})

-- Epic Filter
filterSection:CreateToggle({
    Name = "Epic",
    CurrentValue = true,
    Callback = function(state)
        rarityFilters.Epic = state
        print("Epic Filter:", state and "ON" or "OFF")
    end
})

-- Legendary Filter
filterSection:CreateToggle({
    Name = "Legendary",
    CurrentValue = true,
    Callback = function(state)
        rarityFilters.Legendary = state
        print("Legendary Filter:", state and "ON" or "OFF")
    end
})

-- Mythic Filter
filterSection:CreateToggle({
    Name = "Mythic",
    CurrentValue = true,
    Callback = function(state)
        rarityFilters.Mythic = state
        print("Mythic Filter:", state and "ON" or "OFF")
    end
})

-- SECRET Filter
filterSection:CreateToggle({
    Name = "SECRET",
    CurrentValue = true,
    Callback = function(state)
        rarityFilters.SECRET = state
        print("SECRET Filter:", state and "ON" or "OFF")
    end
})

-- ==========================================
-- HELPER INFO SECTION
-- ==========================================
local infoSection = webhookTab:CreateSection({ Name = "Setup Guide" })

infoSection:CreateLabel({
    Text = "📖 How to Get Discord Webhook:"
})

infoSection:CreateLabel({
    Text = "1. Open Discord Server Settings"
})

infoSection:CreateLabel({
    Text = "2. Go to 'Integrations' → 'Webhooks'"
})

infoSection:CreateLabel({
    Text = "3. Click 'New Webhook' or 'Create Webhook'"
})

infoSection:CreateLabel({
    Text = "4. Choose a channel and copy the URL"
})

infoSection:CreateLabel({
    Text = "5. Paste it in the textbox above!"
})

infoSection:CreateLabel({
    Text = "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
})



print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("🔔 Webhook Tab Loaded!")
print("✅ Fish Logger Active!")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━")


