-- ==============================
-- 🚫 DISABLE CUTSCENE (LEGENDARY+)
-- ==============================

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Net = require(
    ReplicatedStorage
        :WaitForChild("Packages")
        :WaitForChild("Net")
)

local ReplicateCutscene = Net:RemoteEvent("ReplicateCutscene")
local StopCutscene = Net:RemoteEvent("StopCutscene")

local disableCutscene = false
local cutsceneConnection

local function EnableCutsceneSkip()
    if cutsceneConnection then
        cutsceneConnection:Disconnect()
    end

    cutsceneConnection = ReplicateCutscene.OnClientEvent:Connect(function(...)
        -- langsung stop cutscene
        StopCutscene:FireServer()
    end)

    print("🚫 Cutscene Disabled")
end

local function DisableCutsceneSkip()
    if cutsceneConnection then
        cutsceneConnection:Disconnect()
        cutsceneConnection = nil
    end

    print("🎬 Cutscene Enabled")
end

-- ==============================
-- 🔘 TOGGLE UI
-- ==============================

FeatureSection:CreateToggle({
    Name = "Skip Legendary Cutscene",
    CurrentValue = false,
    Callback = function(state)
        disableCutscene = state

        if state then
            EnableCutsceneSkip()
        else
            DisableCutsceneSkip()
        end
    end
})
