--============================================================--
-- 🛡 DUNHILL INTERNAL PROTECTION (MEDIUM) - AUTO RESET LOOP --
--============================================================--

local Protect = {}
Protect.__connections = {}
Protect.__tasks = {}
Protect.__alive = true
Protect.lastPulse = 0

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

        -- Print test: proteksi berjalan
        print("[DUNHILL PROTECT] Heartbeat OK | Pulse:", Protect.lastPulse)

        -- Hapus semua event lama
        for _, c in ipairs(Protect.__connections) do
            pcall(function()
                if c and c.Disconnect then c:Disconnect() end
            end)
        end
        table.clear(Protect.__connections)

        -- Bersihkan record task
        table.clear(Protect.__tasks)

        -- Jejak heartbeat reset
        Protect.lastPulse = os.clock()
    end
end)

function Protect:Stop()
    Protect.__alive = false
end



-- 🐟 Auto Fishing UI by DUNHILL x RezxyStore
-- Pastikan kamu sudah punya DUNHILL UI di path yang sesuai



local Dunhill = loadstring(game:HttpGet("https://raw.githubusercontent.com/Raistyan/DUNHILL/refs/heads/main/Dunhill.lua"))()

local window = Dunhill:CreateWindow({
    Name = "DUNHILL | Udutmu Semangatku",
    ConfigurationSaving = { Enabled = false }
})

local tab = window:CreateTab({
    Name = "Auto Fishing",
    Icon = "🎣"
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



-- ========================================
-- BLATANT FISH (OPTIMIZED VERSION)
-- ========================================
local blatantSection = tab:CreateSection({ Name = "⚡ Blatant Fish System" })

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

-- UI: Fish Delay Input
blatantSection:CreateInput({
    Name = "Fish Delay (Naikin Jika Ikan Ga Keangkat)",
    Flag = "blatantFishDelay",
    PlaceholderText = "0.70",
    Callback = function(value)
        local num = tonumber(value)
        if num then
            BlatantFishingDelay = num
            print("🎣 Fish Delay: " .. num .. "s")
        else
            print("⚠️ Input harus angka!")
        end
    end
})

-- UI: Cancel Delay Input
blatantSection:CreateInput({
    Name = "Cancel Delay (Lempar Rod Selanjutnya)",
    Flag = "blatantCancelDelay",    
    PlaceholderText = "0.30",
    Callback = function(value)
        local num = tonumber(value)
        if num then
            BlatantCancelDelay = num
            print("⏱️ Cancel Delay: " .. num .. "s")
        else
            print("⚠️ Input harus angka!")
        end
    end
})

-- TOGGLE AUTO FISH (OPTIMIZED)
blatantSection:CreateToggle({
    Name = "⚡ Auto Fish (Optimized 2x Speed)",
    Flag = "ultimateAutoFish",
    CurrentValue = false,
    Callback = function(state)
        AutoFishEnabled = state
        if state then
            print("🟢 BLATANT FISH: ENABLED")
            UltimateBypassFishing()
        else
            print("🔴 AUTO FISH STOPPED")
        end
    end
})



-- ========================================
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

section:CreateLabel({
    Text = "⚡ 50ms - Auto Game + Custom Position"
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


local section = tab:CreateSection({ Name = "Sell Fitur" })
section:CreateButton({
    Name = "Jual Semua Ikan",
    Callback = function()
        local sellAll = remotes:WaitForChild("RF/SellAllItems")
        sellAll:InvokeServer()
        print("💰 Semua ikan berhasil dijual!")
        local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
        gui.Name = "SellNotify"
        local label = Instance.new("TextLabel", gui)
        label.Size = UDim2.new(0, 300, 0, 50)
        label.Position = UDim2.new(0.5, -150, 0.8, 0)
        label.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 20
        label.Text = "💰 Semua ikan berhasil dijual!"
        label.BackgroundTransparency = 1
        TweenService:Create(label, TweenInfo.new(0.4), {BackgroundTransparency = 0.3}):Play()
        task.wait(2.5)
        TweenService:Create(label, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
        task.wait(0.5)
        gui:Destroy()
    end
})

section:CreateLabel({
    Text = "Tap Untuk Menjual Semua Ikan🐬"
})

-- 💸 Auto Sell Tiap 2 Jam Sekali
local autoSellEnabled = false

section:CreateToggle({
    Name = "Auto Sell Tiap 2 Jam",
    CurrentValue = false,
    Callback = function(state)
        autoSellEnabled = state
        if state then
            print("💰 Auto Sell aktif — ikan akan dijual tiap 2 jam.")
            task.spawn(function()
                while autoSellEnabled do
                    task.wait(3600) -- 1 jam = 3600 detik
                    local sellAll = remotes:WaitForChild("RF/SellAllItems")
                    sellAll:InvokeServer()
                    print("🕒 Auto Sell: Semua ikan dijual otomatis.")
                    
                    -- Notifikasi visual
                    local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
                    gui.Name = "AutoSellNotify"
                    local label = Instance.new("TextLabel", gui)
                    label.Size = UDim2.new(0, 300, 0, 50)
                    label.Position = UDim2.new(0.5, -150, 0.8, 0)
                    label.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                    label.TextColor3 = Color3.fromRGB(255, 255, 255)
                    label.Font = Enum.Font.GothamBold
                    label.TextSize = 20
                    label.Text = "💸 Auto Sell: Semua ikan dijual otomatis!"
                    label.BackgroundTransparency = 1
                    TweenService:Create(label, TweenInfo.new(0.4), {BackgroundTransparency = 0.3}):Play()
                    task.wait(2.5)
                    TweenService:Create(label, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
                    task.wait(0.5)
                    gui:Destroy()
                end
            end)
        else
            print("🛑 Auto Sell dimatikan.")
        end
    end
})

-- 🗺️ Tab Map
local mapTab = window:CreateTab({
    Name = "Map",
    Icon = "🗺️"
})

local mapSection = mapTab:CreateSection({ Name = "Teleport Locations" })

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
    ["Mesin Cuaca (Lautan)"] = CFrame.new(-1513.92, 6.50, 1892.11)
}

-- ambil semua nama lokasi
local locationNames = {}
for name, _ in pairs(teleportLocations) do
    table.insert(locationNames, name)
end

-- variabel lokasi terpilih
local selectedLocation = nil

-- dropdown pilih lokasi
mapSection:CreateDropdown({
    Name = "Pilih Lokasi",
    Options = locationNames,
    Callback = function(value)
        selectedLocation = value
        print("📍 Lokasi dipilih:", value)
    end
})

-- tombol teleport
mapSection:CreateButton({
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

mapSection:CreateLabel({
    Text = "Pilih Lokasi Dan Klik Teleport Sekarang"
})

local mapSection = mapTab:CreateSection({ Name = "Teleport To Player" })

-- 🧭 TELEPORT TO PLAYER SYSTEM
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local selectedPlayer = nil  -- display name player yg dipilih

-- 🔄 Fungsi update dropdown player
local function refreshPlayerList()
    local list = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            table.insert(list, plr.DisplayName) -- 👈 gunakan DisplayName
        end
    end
    return list
end

-- 🔽 Dropdown Player List
local tpDropdown = mapSection:CreateDropdown({
    Name = "Pilih Player",
    Options = refreshPlayerList(),
    Default = nil,
    Callback = function(value)
        selectedPlayer = value
        print("Target teleport:", selectedPlayer)
    end
})

-- 🔄 Auto-refresh daftar player tiap 5 detik
task.spawn(function()
    while true do
        task.wait(5)
        tpDropdown:Refresh(refreshPlayerList())  
    end
end)

-- 🚀 Teleport Button
mapSection:CreateButton({
    Name = "Teleport",
    Callback = function()
        if not selectedPlayer then
            print("❌ Belum pilih player.")
            return
        end

        -- cari player berdasarkan DisplayName
        local target = nil
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.DisplayName == selectedPlayer then
                target = plr
                break
            end
        end

        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character:MoveTo(
                target.Character.HumanoidRootPart.Position + Vector3.new(0, 2, 0)
            )
            print("✔️ Teleported to", target.DisplayName)
        else
            print("❌ Player tidak valid.")
        end
    end
})



-- ⚡ Tab Sakti
local saktiTab = window:CreateTab({
    Name = "Sakti",
    Icon = "⚡"
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

-- 🔧 Slider Fly Speed
saktiSection:CreateSlider({
    Name = "Fly Speed",
    Min = 10,
    Max = 200,
    Default = flySpeed,
    Increment = 5,
    Callback = function(val)
        flySpeed = val
    end
})

saktiSection:CreateLabel({
    Text = "Aktifkan Toggle Dan Atur Speed Untuk Terbang Bebas🕊️"
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
saktiSection:CreateSlider({
    Name = "Run Speed",
    Min = 16,
    Max = 200,
    Default = runSpeed,
    Increment = 5,
    Callback = function(val)
        runSpeed = val
        if speedEnabled then
            local hum = player.Character:FindFirstChild("Humanoid")
            if hum then
                hum.WalkSpeed = val
            end
        end
    end
})

saktiSection:CreateLabel({
    Text = "Aktifkan Toggle Dan Atur Speed Sesuai Keinginan⚡👟"
})


-- ========================================
-- 🌀 TAB CUACA - DROPDOWN MULTISELECT + BUTTON
-- ========================================

local cuacaTab = window:CreateTab({
    Name = "Cuaca",
    Icon = "🌦️"
})

-- 🌀 TAB CUACA - MULTISELECT DROPDOWN + BUTTON + AUTO CUACA
local cuacaSection = cuacaTab:CreateSection({ Name = "Weather Controls" })

-- daftar cuaca
local weatherOptions = {"Radiant", "Snow", "Rain", "Storm", "Fog"} -- bisa ditambah sesuai game

-- table untuk menyimpan cuaca yang dipilih
local selectedWeathers = {}

-- dropdown multi-select
cuacaSection:CreateDropdown({
    Name = "Pilih Cuaca",
    Options = weatherOptions,
    MultiSelect = true,
    Callback = function(selection)
        selectedWeathers = selection
        print("☁️ Cuaca terpilih:", table.concat(selectedWeathers, ", "))
    end
})

-- tombol ubah cuaca manual
cuacaSection:CreateButton({
    Name = "Ubah Cuaca Sekarang",
    Callback = function()
        if #selectedWeathers == 0 then
            print("⚠️ Pilih minimal satu cuaca dulu!")
            return
        end

        for _, weather in ipairs(selectedWeathers) do
            local success, err = pcall(function()
                local args = {weather}
                game:GetService("ReplicatedStorage")
                    :WaitForChild("Packages")
                    :WaitForChild("_Index")
                    :WaitForChild("sleitnick_net@0.2.0")
                    :WaitForChild("net")
                    :WaitForChild("RF/PurchaseWeatherEvent")
                    :InvokeServer(unpack(args))
            end)
            if success then
                print("✅ Cuaca diubah menjadi:", weather)
            else
                warn("❌ Gagal ubah cuaca:", err)
            end
        end
    end
})

-- toggle Auto Cuaca
local autoWeatherEnabled = false
local weatherInterval = 10 -- default jeda antar ganti cuaca (detik)

cuacaSection:CreateToggle({
    Name = "Auto Cuaca",
    CurrentValue = false,
    Callback = function(state)
        autoWeatherEnabled = state
        print(state and "🌦 Auto Cuaca Aktif" or "🛑 Auto Cuaca Nonaktif")

        if state then
            task.spawn(function()
                while autoWeatherEnabled do
                    task.wait(weatherInterval)
                    for _, weather in ipairs(selectedWeathers) do
                        if weather then
                            local success, err = pcall(function()
                                local args = {weather}
                                game:GetService("ReplicatedStorage")
                                    :WaitForChild("Packages")
                                    :WaitForChild("_Index")
                                    :WaitForChild("sleitnick_net@0.2.0")
                                    :WaitForChild("net")
                                    :WaitForChild("RF/PurchaseWeatherEvent")
                                    :InvokeServer(unpack(args))
                            end)
                            if success then
                                print("✅ Auto Cuaca: diubah menjadi", weather)
                            else
                                warn("❌ Gagal ubah cuaca:", err)
                            end
                        end
                    end
                end
            end)
        end
    end
})

-- slider interval auto cuaca
cuacaSection:CreateSlider({
    Name = "Interval Auto Cuaca (detik)",
    Min = 5,
    Max = 60,
    Default = weatherInterval,
    Increment = 1,
    Callback = function(val)
        weatherInterval = val
    end
})

cuacaSection:CreateLabel({
    Text = "Pilih cuaca di dropdown, centang yang ingin diaktifkan, lalu gunakan tombol manual atau toggle Auto Cuaca 🌈"
})

local performanceTab = window:CreateTab({
    Name = "Fitur Tambahan",
    Icon = "🤙"
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
    Name = "Boost FPS (Texture Smoother)",
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
local vfxSection = performanceTab:CreateSection({ Name = "Disable VFX" })

local disableVFX = false
local VFXFolder = ReplicatedStorage:FindFirstChild("VFX")
local VFXBackup = nil

-- Fungsi buat backup bila folder ada
local function createBackup()
    VFXFolder = ReplicatedStorage:FindFirstChild("VFX")
    if VFXFolder then
        -- overwrite backup agar selalu up-to-date
        VFXBackup = Instance.new("Folder")
        VFXBackup.Name = "VFXBackup"
        for _, obj in ipairs(VFXFolder:GetChildren()) do
            obj:Clone().Parent = VFXBackup
        end
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




-- ========================================
-- 🎣 TAB WEBHOOK + DISCORD NOTIFICATION
-- ========================================

local webhookTab = window:CreateTab({
    Name = "Webhook",
    Icon = "🔔"
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
                ["text"] = "DUNHILL Fish Logger",
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
