-- ==============================================================================
-- YO DEALS PRO - MULTI-RANDOM 3D INTRO MASTERPIECE
-- Created for Yahya | 120 FPS, Lucid Dreams Audio, 3D Rotating Overheads & Random Intros
-- ==============================================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
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

-- تنظيف أي واجهة قديمة
if playerGui:FindFirstChild("YoDealsRandom3DIntro") then
    playerGui.YoDealsRandom3DIntro:Destroy()
end

-- 4. تشغيل أغنية Lucid Dreams فوراً وبصوت عالي من أول ثانية
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

    -- اختيار عشوائي لرقم الأنترو (1 أو 2 أو 3) كل مرة تشغل فيها السكريبت
    math.randomseed(tick())
    local randomIntroStyle = math.random(1, 3)

    if randomIntroStyle == 1 then
        -- [الأنترو الأول: ستايل المجرة النيون الحماسي]
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
        -- [الأنترو الثاني: ستايل الألوان المتوهجة السريعة]
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
        -- [الأنترو الثالث: ستايل الأساطير والهيمنة]
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

    -- النهاية المشتركة: صورة القطة واسم يوديلز
    titleLabel.Text = "🔥 YO DEALS OFFICIAL 🔥"
    subLabel.Text = "WELCOME TO THE BEST HUB!"
    TweenService:Create(petImage, TweenInfo.new(0.8), {ImageTransparency = 0}):Play()
    TweenService:Create(depthContainer, TweenInfo.new(0.8), {Size = UDim2.new(0,0,0,0)}):Play()

    -- وقت ممتع للاستمتاع بالأغنية بالكامل
    task.wait(10.0)

    if isLaunched then return end

    local fadeInfo = TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(bgFrame, fadeInfo, {BackgroundTransparency = 1}):Play()
    TweenService:Create(titleLabel, fadeInfo, {TextTransparency = 1}):Play()
    TweenService:Create(subLabel, fadeInfo, {TextTransparency = 1}):Play()
    TweenService:Create(petImage, fadeInfo, {ImageTransparency = 1}):Play()
    
    task.wait(1.3)
    launchScript()
end)
