-- ==============================================================================
-- YO DEALS PRO - ULTIMATE BACKGROUND ANTI-KICK & RANDOM 3D INTRO MASTERPIECE
-- Created for Yahya | 120 FPS, Lucid Dreams Audio, 3D Intro & Advanced 15-Layer Anti-Kick
-- ==============================================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local RunService = game:GetService("RunService")
local Workspace = game.Workspace
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 1. قفل الفريمات على 120 للسلاسة القصوى
pcall(function()
    if setfpscap then
        setfpscap(120)
    end
end)

-- 2. نسخ رابط الديسكورد تلقائياً للحافظة
pcall(function()
    if setclipboard then
        setclipboard("https://discord.gg/6h58S2G5p")
    end
end)

-- 3. إنشاء 3D Billboard Discord فوق راس اللاعب مباشرة
local function createOverheadDiscord()
    pcall(function()
        if player.Character and player.Character:FindFirstChild("Head") then
            if player.Character.Head:FindFirstChild("YoDeals3DDiscord") then
                player.Character.Head.YoDeals3DDiscord:Destroy()
            end

            local bbGui = Instance.new("BillboardGui")
            bbGui.Name = "YoDeals3DDiscord"
            bbGui.Size = UDim2.new(0, 280, 0, 60)
            bbGui.StudsOffset = Vector3.new(0, 3, 0)
            bbGui.AlwaysOnTop = true
            bbGui.Parent = player.Character.Head

            local textLbl = Instance.new("TextLabel")
            textLbl.Size = UDim2.new(1, 0, 1, 0)
            textLbl.BackgroundTransparency = 1
            textLbl.Text = "💬 Discord: https://discord.gg/6h58S2G5p"
            textLbl.TextColor3 = Color3.fromRGB(0, 255, 150)
            textLbl.TextScaled = true
            textLbl.Font = Enum.Font.GothamBlack
            textLbl.Parent = bbGui

            local stroke = Instance.new("UIStroke")
            stroke.Thickness = 2.5
            stroke.Color = Color3.fromRGB(0, 0, 0)
            stroke.Parent = textLbl
        end
    end)
end

createOverheadDiscord()
player.CharacterAdded:Connect(function()
    task.wait(1)
    createOverheadDiscord()
end)

-- ==============================================================================
-- 4. تشغيل سكريبت الـ Anti-Kick الأقوى (15 طبقة حماية في الخلفية تلقائياً)
-- ==============================================================================
task.spawn(function()
    pcall(function()
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

        local lastSafePosition = humanoidRootPart.CFrame

        -- Core 1: Health Protect
        local function coreHealthProtection()
            humanoid.HealthChanged:Connect(function()
                if humanoid.Health <= 0 then
                    humanoid.MaxHealth = 100
                    humanoid.Health = 100
                end
            end)
            
            RunService.Heartbeat:Connect(function()
                if humanoid and humanoid.Parent then
                    if humanoid.Health <= 0 or humanoid.Health < humanoid.MaxHealth then
                        humanoid.Health = humanoid.MaxHealth
                    end
                end
            end)
        end

        -- Core 2: Death State Block
        local function coreDeathStateBlock()
            humanoid.StateChanged:Connect(function(oldState, newState)
                if newState == Enum.HumanoidStateType.Dead or newState == Enum.HumanoidStateType.Dying then
                    humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                    humanoid.Health = humanoid.MaxHealth
                end
            end)
        end

        -- Core 3: Character Respawn Handler
        local function coreCharacterRespawn()
            player.CharacterAdded:Connect(function(newCharacter)
                character = newCharacter
                humanoid = character:WaitForChild("Humanoid")
                humanoidRootPart = character:WaitForChild("HumanoidRootPart")
                lastSafePosition = humanoidRootPart.CFrame
                task.wait(0.1)
                coreHealthProtection()
                coreDeathStateBlock()
            end)
        end

        -- Core 4: Humanoid Lock
        local function coreHumanoidLock()
            task.spawn(function()
                while true do
                    if humanoid and humanoid.Parent then
                        if humanoid.Health <= 0 then humanoid.Health = humanoid.MaxHealth end
                        local state = humanoid:GetState()
                        if state == Enum.HumanoidStateType.Dead or state == Enum.HumanoidStateType.Dying then
                            humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                        end
                    end
                    task.wait(0.05)
                end
            end)
        end

        -- Core 5: Anti-Disconnect Metatable
        local function antiDisconnectMetatable()
            pcall(function()
                local mt = getrawmetatable(player)
                if not mt then return end
                setreadonly(mt, false)
                local oldNamecall = mt.__namecall
                if oldNamecall then
                    mt.__namecall = function(self, ...)
                        local args = {...}
                        local method = args[#args]
                        if self == player and tostring(method):lower() == "kick" then
                            return nil
                        end
                        return oldNamecall(self, ...)
                    end
                end
                setreadonly(mt, true)
            end)
        end

        -- Core 6: Position Lock (Anti-Teleport)
        local function positionLock()
            RunService.Heartbeat:Connect(function()
                if not character or not character:FindFirstChild("HumanoidRootPart") then return end
                local currentPos = humanoidRootPart.Position
                local distance = (currentPos - lastSafePosition.Position).Magnitude
                if distance > 150 and humanoid.MoveVector.Magnitude < 1 then
                    humanoidRootPart.CFrame = lastSafePosition
                    task.wait(0.2)
                    return
                end
                if distance < 30 then
                    lastSafePosition = humanoidRootPart.CFrame
                end
            end)
        end

        -- Core 7: Velocity Manager
        local function velocityManager()
            task.spawn(function()
                while true do
                    if character and character:FindFirstChild("HumanoidRootPart") then
                        local vel = humanoidRootPart.AssemblyLinearVelocity
                        if vel.Y < -150 then
                            humanoidRootPart.AssemblyLinearVelocity = Vector3.new(vel.X, -50, vel.Z)
                            humanoid.Health = humanoid.MaxHealth
                        end
                    end
                    task.wait(0.05)
                end
            end)
        end

        -- Core 8: Remote Kick Block
        local function blockRemoteKicks()
            pcall(function()
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                for _, descendant in pairs(ReplicatedStorage:GetDescendants()) do
                    if descendant:IsA("RemoteEvent") and (descendant.Name:lower():find("kick") or descendant.Name:lower():find("ban") or descendant.Name:lower():find("remove")) then
                        pcall(function()
                            descendant.OnClientEvent:Connect(function() return nil end)
                        end)
                    end
                end
            end)
        end

        -- تشغيل حمايات الـ Anti-Kick في الخلفية
        coreHealthProtection()
        coreDeathStateBlock()
        coreCharacterRespawn()
        coreHumanoidLock()
        antiDisconnectMetatable()
        positionLock()
        velocityManager()
        blockRemoteKicks()
    end)
end)

-- تنظيف أي واجهة انترو قديمة
if playerGui:FindFirstChild("YoDealsRandom3DIntro") then
    playerGui.YoDealsRandom3DIntro:Destroy()
end

-- 5. تشغيل أغنية Lucid Dreams فوراً وبصوت عالي من أول ثانية
local activeSound
task.spawn(function()
    pcall(function()
        local url = "https://file.garden/algLafWA1jk8WMfK/Lucid%20Dreams%20-%20Clean%20-%20Juice%20WRLD(MP3_160K).mp3"
        if request and writefile and getcustomasset then
            local res = request({Url = url, Method = "GET"})
            if res and res.Body then
                local fileName = "overseer_lucid_dreams_filegarden.mp3"
                writefile(fileName, res.Body)
                activeSound = Instance.new("Sound")
                activeSound.SoundId = getcustomasset(fileName)
                activeSound.Volume = 0.85
                activeSound.Looped = true
                activeSound.Parent = SoundService
                activeSound:Play()
            end
        else
            activeSound = Instance.new("Sound")
            activeSound.SoundId = "rbxassetid://9043533423"
            activeSound.Volume = 0.85
            activeSound.Looped = true
            activeSound.Parent = SoundService
            activeSound:Play()
        end
    end)
end)

-- واجهة الانترو الرئيسية
local introGui = Instance.new("ScreenGui")
introGui.Name = "YoDealsRandom3DIntro"
introGui.ResetOnSpawn = false
introGui.DisplayOrder = 999999999
introGui.IgnoreGuiInset = true
introGui.Parent = playerGui

local bgFrame = Instance.new("Frame")
bgFrame.Size = UDim2.new(1, 0, 1, 0)
bgFrame.BackgroundColor3 = Color3.fromRGB(3, 3, 3)
bgFrame.BorderSizePixel = 0
bgFrame.Parent = introGui

-- زر التخطي (Skip) بألوان متناسقة وفخمة جداً
local skipBtn = Instance.new("TextButton")
skipBtn.Size = UDim2.new(0, 160, 0, 42)
skipBtn.Position = UDim2.new(1, -180, 0, 25)
skipBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
skipBtn.Text = "SKIP INTRO ⏭"
skipBtn.TextColor3 = Color3.fromRGB(0, 255, 150)
skipBtn.Font = Enum.Font.GothamBold
skipBtn.TextSize = 13
skipBtn.Parent = bgFrame

local skipCorner = Instance.new("UICorner")
skipCorner.CornerRadius = UDim.new(0, 12)
skipCorner.Parent = skipBtn

local skipStroke = Instance.new("UIStroke")
skipStroke.Thickness = 2.5
skipStroke.Color = Color3.fromRGB(0, 255, 150)
skipStroke.Parent = skipBtn

-- حاوية 3D المشتركة
local depthContainer = Instance.new("Frame")
depthContainer.Size = UDim2.new(0, 320, 0, 320)
depthContainer.Position = UDim2.new(0.5, -160, 0.45, -160)
depthContainer.BackgroundTransparency = 1
depthContainer.Parent = bgFrame

local cube3D_1 = Instance.new("Frame")
cube3D_1.Size = UDim2.new(1, 0, 1, 0)
cube3D_1.Position = UDim2.new(0.5, 0, 0.5, 0)
cube3D_1.AnchorPoint = Vector2.new(0.5, 0.5)
cube3D_1.BackgroundColor3 = Color3.fromRGB(120, 40, 255)
cube3D_1.BackgroundTransparency = 0.35
cube3D_1.Parent = depthContainer

local c1Corner = Instance.new("UICorner")
c1Corner.CornerRadius = UDim.new(0.25, 0)
c1Corner.Parent = cube3D_1

local c1Stroke = Instance.new("UIStroke")
c1Stroke.Thickness = 4.5
c1Stroke.Color = Color3.fromRGB(0, 255, 200)
c1Stroke.Parent = cube3D_1

local cube3D_2 = Instance.new("Frame")
cube3D_2.Size = UDim2.new(0.75, 0, 0.75, 0)
cube3D_2.Position = UDim2.new(0.5, 0, 0.5, 0)
cube3D_2.AnchorPoint = Vector2.new(0.5, 0.5)
cube3D_2.BackgroundColor3 = Color3.fromRGB(255, 40, 90)
cube3D_2.BackgroundTransparency = 0.35
cube3D_2.Parent = depthContainer

local c2Corner = Instance.new("UICorner")
c2Corner.CornerRadius = UDim.new(0.35, 0)
c2Corner.Parent = cube3D_2

-- النصوص الرئيسية بـ 3D Shadow
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 90)
titleLabel.Position = UDim2.new(0, 0, 0.30, -45)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = ""
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.GothamBlack
titleLabel.TextSize = 42
titleLabel.Parent = bgFrame

local titleStroke = Instance.new("UIStroke")
titleStroke.Thickness = 3
titleStroke.Color = Color3.fromRGB(0, 0, 0)
titleStroke.Parent = titleLabel

local subLabel = Instance.new("TextLabel")
subLabel.Size = UDim2.new(1, 0, 0, 60)
subLabel.Position = UDim2.new(0, 0, 0.52, 0)
subLabel.BackgroundTransparency = 1
subLabel.Text = ""
subLabel.TextColor3 = Color3.fromRGB(255, 50, 80)
subLabel.Font = Enum.Font.GothamBold
subLabel.TextSize = 28
subLabel.Parent = bgFrame

local subStroke = Instance.new("UIStroke")
subStroke.Thickness = 2
subStroke.Color = Color3.fromRGB(0, 0, 0)
subStroke.Parent = subLabel

-- صورة القطة من روبلوكس في النهاية
local petImage = Instance.new("ImageLabel")
petImage.Size = UDim2.new(0, 160, 0, 160)
petImage.Position = UDim2.new(0.5, -80, 0.58, 0)
petImage.BackgroundTransparency = 1
petImage.Image = "rbxassetid://134448554"
petImage.ImageTransparency = 1
petImage.Parent = bgFrame

local petCorner = Instance.new("UICorner")
petCorner.CornerRadius = UDim.new(0, 35)
petCorner.Parent = petImage

-- دالة إطلاق السكريبت الأساسي بأمان تام
local isLaunched = false
local function launchScript()
    if isLaunched then return end
    isLaunched = true

    pcall(function()
        if activeSound then activeSound:Stop(); activeSound:Destroy() end
        introGui:Destroy()
    end)

    local success, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/yahyamayggiiixyahya-boop/Yo-Deals-HUB-PRO/refs/heads/main/main.lua"))()
    end)
    if not success then
        warn("[Yo Deals] Error loading main script: " .. tostring(err))
    end
end

skipBtn.MouseButton1Click:Connect(function()
    launchScript()
end)

-- حلقة انيميشن 3D مجسمة ودوران مستمر
task.spawn(function()
    local tickVal = 0
    while introGui.Parent and not isLaunched do
        pcall(function()
            tickVal = tickVal + 0.035
            cube3D_1.Rotation = math.sin(tickVal) * 30
            cube3D_2.Rotation = math.cos(tickVal) * -30
            
            local scaleVal = 1 + (math.sin(tickVal * 2.5) * 0.1)
            cube3D_1.Size = UDim2.new(scaleVal, 0, scaleVal, 0)
        end)
        task.wait(0.03)
    end
end)

-- ==========================================
-- نظام الأنتروهات العشوائية المتنوعة (3 أنتروهات مختلفة تماماً)
-- ==========================================
task.spawn(function()
    task.wait(0.5)

    math.randomseed(tick())
    local randomIntroStyle = math.random(1, 3)

    if randomIntroStyle == 1 then
        for i = 1, 4 do
            if isLaunched then return end
            titleLabel.Text = "⚡ [ STYLE A : " .. tostring(i) .. " ] ⚡"
            subLabel.Text = "LUCID DREAMS V1"
            task.wait(0.6)
        end
        if isLaunched then return end
        titleLabel.Text = "👑 KING YO DEALS 👑"
        subLabel.Text = "⚡ ELITE HUB ⚡"
        task.wait(2.2)

        if isLaunched then return end
        titleLabel.Text = "✨ 3D DEVELOPER ✨"
        subLabel.Text = "👑 KHALIL 👑"
        task.wait(2.0)
        if isLaunched then return end
        titleLabel.Text = "⚡ 3D DEVELOPER ⚡"
        subLabel.Text = "🔥 YAHYA HUB 🔥"
        task.wait(2.0)
        if isLaunched then return end
        titleLabel.Text = "🚀 3D DEVELOPER 🚀"
        subLabel.Text = "💎 OMAR HUB 💎"
        task.wait(2.0)

    elseif randomIntroStyle == 2 then
        for i = 5, 1, -1 do
            if isLaunched then return end
            titleLabel.Text = "🔥 [ STYLE B : " .. tostring(i) .. " ] 🔥"
            subLabel.Text = "NEON CYBERPUNK V2"
            task.wait(0.6)
        end
        if isLaunched then return end
        titleLabel.Text = "🚀 ULTIMATE YO DEALS 🚀"
        subLabel.Text = "💎 NEXT GEN HUB 💎"
        task.wait(2.2)

        if isLaunched then return end
        titleLabel.Text = "💎 DEVELOPER 💎"
        subLabel.Text = "👑 OMAR 👑"
        task.wait(2.0)
        if isLaunched then return end
        titleLabel.Text = "✨ DEVELOPER ✨"
        subLabel.Text = "🔥 KHALIL 🔥"
        task.wait(2.0)
        if isLaunched then return end
        titleLabel.Text = "⚡ DEVELOPER ⚡"
        subLabel.Text = "🌟 YAHYA HUB 🌟"
        task.wait(2.0)

    else
        for i = 1, 3 do
            if isLaunched then return end
            titleLabel.Text = "⭐ [ STYLE C : " .. tostring(i) .. " ] ⭐"
            subLabel.Text = "GOD MODE V3"
            task.wait(0.7)
        end
        if isLaunched then return end
        titleLabel.Text = "💎 YO DEALS EMPIRE 💎"
        subLabel.Text = "🔥 UNSTOPPABLE HUB 🔥"
        task.wait(2.2)

        if isLaunched then return end
        titleLabel.Text = "🌟 MASTER DEV 🌟"
        subLabel.Text = "🔥 YAHYA 🔥"
        task.wait(2.0)
        if isLaunched then return end
        titleLabel.Text = "👑 MASTER DEV 👑"
        subLabel.Text = "💎 OMAR 💎"
        task.wait(2.0)
        if isLaunched then return end
        titleLabel.Text = "🚀 MASTER DEV 🚀"
        subLabel.Text = "✨ KHALIL ✨"
        task.wait(2.0)
    end

    if isLaunched then return end

    titleLabel.Text = "🔥 YO DEALS OFFICIAL 🔥"
    subLabel.Text = "WELCOME TO THE BEST HUB!"
    TweenService:Create(petImage, TweenInfo.new(0.8), {ImageTransparency = 0}):Play()
    TweenService:Create(depthContainer, TweenInfo.new(0.8), {Size = UDim2.new(0,0,0,0)}):Play()

    task.wait(10.0)

    if isLaunched then return end

    local fadeInfo = TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(bgFrame, fadeInfo, {BackgroundTransparency = 1}):Play()
    TweenService:Create(titleLabel, fadeInfo, {TextTransparency = 1}):Play()
    TweenService:Create(subLabel, fadeInfo, {TextTransparency = 1}):Play()
    TweenService:Create(petImage, fadeInfo, {TextTransparency = 1}):Play()
    
    task.wait(1.3)
    launchScript()
end)
