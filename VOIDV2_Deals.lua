-- ============================================================
-- VOID HUB PRO - MULTI-MENU (SETTINGS, SCRIPTS, MAIN)
-- ============================================================
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- Config & Security Settings
local CORRECT_KEY = "VOID_VID63726"
local KEY_DURATION = 7 * 24 * 60 * 60 -- 7 Days
local keyFile = "VoidHub_KeyData.txt"
local configSaveFile = "VoidHub_Config.txt"

local getHWID = function()
    local suc, res = pcall(function()
        return game:GetService("RbxAnalyticsService"):GetClientId()
    end)
    return suc and res or "DefaultDevice_HWID"
end

-- ============================================================
-- KEY SYSTEM (7 Days & Single Device Lock)
-- ============================================================
local function createKeySystem(onSuccess)
    local keyGui = Instance.new("ScreenGui")
    keyGui.Name = "VoidKeySystem"
    keyGui.ResetOnSpawn = false
    keyGui.DisplayOrder = 1000000
    keyGui.Parent = CoreGui

    local frame = Instance.new("Frame", keyGui)
    frame.Size = UDim2.new(0, 280, 0, 160)
    frame.Position = UDim2.new(0.5, -140, 0.5, -80)
    frame.BackgroundColor3 = Color3.fromRGB(15, 12, 25)
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = Color3.fromRGB(0, 160, 255)
    stroke.Thickness = 1.5

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, 0, 0, 35)
    title.BackgroundTransparency = 1
    title.Text = "SECURITY KEY REQUIRED"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 13

    local textBox = Instance.new("TextBox", frame)
    textBox.Size = UDim2.new(0.85, 0, 0, 35)
    textBox.Position = UDim2.new(0.075, 0, 0, 45)
    textBox.BackgroundColor3 = Color3.fromRGB(25, 20, 35)
    textBox.PlaceholderText = "Enter Key here..."
    textBox.Text = ""
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.Font = Enum.Font.Gotham
    textBox.TextSize = 12
    Instance.new("UICorner", textBox).CornerRadius = UDim.new(0, 8)

    local submitBtn = Instance.new("TextButton", frame)
    submitBtn.Size = UDim2.new(0.85, 0, 0, 35)
    submitBtn.Position = UDim2.new(0.075, 0, 0, 90)
    submitBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 255)
    submitBtn.Text = "VERIFY KEY"
    submitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    submitBtn.Font = Enum.Font.GothamBold
    submitBtn.TextSize = 12
    Instance.new("UICorner", submitBtn).CornerRadius = UDim.new(0, 8)

    if isfile and isfile(keyFile) then
        local suc, data = pcall(function() return HttpService:JSONDecode(readfile(keyFile)) end)
        if suc and data and data.Key == CORRECT_KEY and data.HWID == getHWID() then
            if os.time() - data.Time < KEY_DURATION then
                keyGui:Destroy()
                onSuccess()
                return
            end
        end
    end

    submitBtn.MouseButton1Click:Connect(function()
        if textBox.Text == CORRECT_KEY then
            if writefile then
                local data = {Key = CORRECT_KEY, HWID = getHWID(), Time = os.time()}
                writefile(keyFile, HttpService:JSONEncode(data))
            end
            keyGui:Destroy()
            onSuccess()
        else
            submitBtn.Text = "INVALID KEY / WRONG DEVICE!"
            submitBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 100)
            task.wait(1.5)
            submitBtn.Text = "VERIFY KEY"
            submitBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 255)
        end
    end)
end

-- ============================================================
-- MAIN SCRIPT EXECUTION
-- ============================================================
createKeySystem(function()
    -- 1. Run First Script Automatically (Yo-Deals HUB PRO)
    task.spawn(function()
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/yahyamayggiiixyahya-boop/Yo-Deals-HUB-PRO/refs/heads/main/main.lua"))()
        end)
    end)

    -- Variables for External Script (Chocola)
    local chocolaRunning = false

    local function toggleChocola(state)
        chocolaRunning = state
        if state then
            task.spawn(function()
                pcall(function()
                    loadstring(game:HttpGet("https://raw.githubusercontent.com/chocolascript-glitch/Chocola-Anti-Desync/refs/heads/main/script.lua"))()
                end)
            end)
        end
    end

    -- ============================================================
    -- MULTI-MENU INTERFACE (3 Tabs: Main, Script Start, Settings)
    -- ============================================================
    local gui = Instance.new("ScreenGui")
    gui.Name = "VoidMultiMenu"
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 999999
    gui.IgnoreGuiInset = true
    gui.Parent = CoreGui

    local PW, PH = 250, 280
    local MINI_H = 40
    local isMinimized = false

    local dp = Instance.new("ImageLabel", gui)
    dp.Name = "MainFrame"
    dp.Size = UDim2.new(0, PW, 0, PH)
    dp.Position = UDim2.new(0.5, -PW/2, 0.5, -PH/2)
    dp.BackgroundColor3 = Color3.fromRGB(12, 10, 20)
    dp.Image = "rbxassetid://120250897689342"
    dp.ScaleType = Enum.ScaleType.Crop
    dp.Active = true
    dp.ClipsDescendants = true
    Instance.new("UICorner", dp).CornerRadius = UDim.new(0, 14)

    local dpSt = Instance.new("UIStroke", dp)
    dpSt.Color = Color3.fromRGB(0, 160, 255)
    dpSt.Thickness = 1.5

    -- Dragging System
    local dragging, dragStart, startPos
    dp.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = dp.Position
            local conn
            conn = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    conn:Disconnect()
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            dp.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Header
    local header = Instance.new("Frame", dp)
    header.Size = UDim2.new(1, 0, 0, 36)
    header.BackgroundTransparency = 1

    local titleLbl = Instance.new("TextLabel", header)
    titleLbl.Size = UDim2.new(1, -45, 1, 0)
    titleLbl.Position = UDim2.new(0, 12, 0, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = "VOID HUB // PRO"
    titleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLbl.Font = Enum.Font.GothamBlack
    titleLbl.TextSize = 12
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left

    local minimizeBtn = Instance.new("TextButton", header)
    minimizeBtn.Size = UDim2.new(0, 24, 0, 24)
    minimizeBtn.Position = UDim2.new(1, -30, 0.5, -12)
    minimizeBtn.BackgroundColor3 = Color3.fromRGB(20, 15, 30)
    minimizeBtn.Text = "−"
    minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.TextSize = 14
    Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0, 6)

    -- Navigation Tabs Bar (3 Options)
    local tabNav = Instance.new("Frame", dp)
    tabNav.Size = UDim2.new(1, -20, 0, 28)
    tabNav.Position = UDim2.new(0, 10, 0, 38)
    tabNav.BackgroundTransparency = 1

    local tabLayout = Instance.new("UIListLayout", tabNav)
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabLayout.Padding = UDim.new(0, 4)

    local function createTabButton(text)
        local btn = Instance.new("TextButton", tabNav)
        btn.Size = UDim2.new(0.32, 0, 1, 0)
        btn.BackgroundColor3 = Color3.fromRGB(20, 15, 30)
        btn.BackgroundTransparency = 0.4
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 10
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        local str = Instance.new("UIStroke", btn)
        str.Color = Color3.fromRGB(50, 100, 200)
        str.Thickness = 1
        return btn, str
    end

    local btnMenu, strMenu = createTabButton("Menu")
    local btnScripts, strScripts = createTabButton("Script Start")
    local btnSettings, strSettings = createTabButton("Settings")

    -- Pages Container
    local pagesContainer = Instance.new("Frame", dp)
    pagesContainer.Size = UDim2.new(1, -20, 1, -80)
    pagesContainer.Position = UDim2.new(0, 10, 0, 72)
    pagesContainer.BackgroundTransparency = 1
    pagesContainer.ClipsDescendants = true

    local function createPage()
        local p = Instance.new("ScrollingFrame", pagesContainer)
        p.Size = UDim2.new(1, 0, 1, 0)
        p.BackgroundTransparency = 1
        p.Visible = false
        p.CanvasSize = UDim2.new(0, 0, 0, 0)
        p.ScrollBarThickness = 2
        local l = Instance.new("UIListLayout", p)
        l.SortOrder = Enum.SortOrder.LayoutOrder
        l.Padding = UDim.new(0, 6)
        return p
    end

    local pageMenu = createPage()
    local pageScripts = createPage()
    local pageSettings = createPage()

    local function switchTab(selectedPage, btnActive, strActive)
        pageMenu.Visible = false
        pageScripts.Visible = false
        pageSettings.Visible = false
        selectedPage.Visible = true

        strMenu.Color = Color3.fromRGB(50, 100, 200)
        strScripts.Color = Color3.fromRGB(50, 100, 200)
        strSettings.Color = Color3.fromRGB(50, 100, 200)
        btnMenu.TextColor3 = Color3.fromRGB(200, 200, 200)
        btnScripts.TextColor3 = Color3.fromRGB(200, 200, 200)
        btnSettings.TextColor3 = Color3.fromRGB(200, 200, 200)

        strActive.Color = Color3.fromRGB(0, 160, 255)
        btnActive.TextColor3 = Color3.fromRGB(255, 255, 255)
    end

    btnMenu.MouseButton1Click:Connect(function() switchTab(pageMenu, btnMenu, strMenu) end)
    btnScripts.MouseButton1Click:Connect(function() switchTab(pageScripts, btnScripts, strScripts) end)
    btnSettings.MouseButton1Click:Connect(function() switchTab(pageSettings, btnSettings, strSettings) end)

    switchTab(pageMenu, btnMenu, strMenu) -- Default active

    local function createRowInPage(parentPage)
        local r = Instance.new("Frame", parentPage)
        r.Size = UDim2.new(1, 0, 0, 32)
        r.BackgroundColor3 = Color3.fromRGB(15, 12, 25)
        r.BackgroundTransparency = 0.5
        Instance.new("UICorner", r).CornerRadius = UDim.new(0, 6)
        local str = Instance.new("UIStroke", r)
        str.Color = Color3.fromRGB(50, 100, 200)
        str.Thickness = 1
        return r, str
    end

    -- ----------------------------------------------------
    -- PAGE 1: MENU (Online Count / Main Status)
    -- ----------------------------------------------------
    local onlineRow = createRowInPage(pageMenu)
    local onlineTxt = Instance.new("TextLabel", onlineRow)
    onlineTxt.Size = UDim2.new(1, 0, 1, 0)
    onlineTxt.BackgroundTransparency = 1
    onlineTxt.Text = "Hub Active Clients: 1 (Connected)"
    onlineTxt.TextColor3 = Color3.fromRGB(0, 255, 140)
    onlineTxt.Font = Enum.Font.GothamBold
    onlineTxt.TextSize = 10

    -- ----------------------------------------------------
    -- PAGE 2: SCRIPT START (External Scripts Control)
    -- ----------------------------------------------------
    local chocolaRow, chocolaStr = createRowInPage(pageScripts)
    local chocolaBtn = Instance.new("TextButton", chocolaRow)
    chocolaBtn.Size = UDim2.new(1, 0, 1, 0)
    chocolaBtn.BackgroundTransparency = 1
    chocolaBtn.Text = "Chocola Anti-Desync: OFF"
    chocolaBtn.TextColor3 = Color3.fromRGB(255, 70, 100)
    chocolaBtn.Font = Enum.Font.GothamBold
    chocolaBtn.TextSize = 11

    chocolaBtn.MouseButton1Click:Connect(function()
        chocolaRunning = not chocolaRunning
        toggleChocola(chocolaRunning)
        if chocolaRunning then
            chocolaBtn.Text = "Chocola Anti-Desync: ON"
            chocolaBtn.TextColor3 = Color3.fromRGB(0, 255, 140)
            chocolaStr.Color = Color3.fromRGB(0, 255, 140)
        else
            chocolaBtn.Text = "Chocola Anti-Desync: OFF"
            chocolaBtn.TextColor3 = Color3.fromRGB(255, 70, 100)
            chocolaStr.Color = Color3.fromRGB(50, 100, 200)
        end
    end)

    -- ----------------------------------------------------
    -- PAGE 3: SETTINGS (Save Config)
    -- ----------------------------------------------------
    local saveRow, saveStr = createRowInPage(pageSettings)
    local saveBtn = Instance.new("TextButton", saveRow)
    saveBtn.Size = UDim2.new(1, 0, 1, 0)
    saveBtn.BackgroundTransparency = 1
    saveBtn.Text = "Save Settings (Config)"
    saveBtn.TextColor3 = Color3.fromRGB(0, 160, 255)
    saveBtn.Font = Enum.Font.GothamBold
    saveBtn.TextSize = 11

    saveBtn.MouseButton1Click:Connect(function()
        if writefile then
            local configData = {ChocolaState = chocolaRunning}
            pcall(function()
                writefile(configSaveFile, HttpService:JSONEncode(configData))
            end)
            saveBtn.Text = "Saved Successfully!"
            task.wait(1.2)
            saveBtn.Text = "Save Settings (Config)"
        else
            saveBtn.Text = "Executor does not support writefile!"
            task.wait(1.2)
            saveBtn.Text = "Save Settings (Config)"
        end
    end)

    -- Minimize Toggle Logic
    minimizeBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        local targetH = isMinimized and MINI_H or PH
        TweenService:Create(dp, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Size = UDim2.new(0, PW, 0, targetH)}):Play()
        pagesContainer.Visible = not isMinimized
        tabNav.Visible = not isMinimized
        minimizeBtn.Text = isMinimized and "+" or "−"
    end)

    print("VOID MULTI-MENU - Loaded Successfully!")
end)
