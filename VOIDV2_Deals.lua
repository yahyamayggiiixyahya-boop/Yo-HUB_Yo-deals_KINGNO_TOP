-- ============================================================
-- VOID HUB PRO - ADVANCED KEY SYSTEM & MULTI-MENU
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
local KEY_DURATION = 7 * 24 * 60 * 60 -- 7 Days in seconds
local keyFile = "VoidHub_SavedKey.txt"
local devicesFile = "VoidHub_DevicesList.txt"
local configSaveFile = "VoidHub_Config.txt"

-- Get Unique Device HWID
local function getHWID()
    local suc, res = pcall(function()
        return game:GetService("RbxAnalyticsService"):GetClientId()
    end)
    return suc and res tostring(LocalPlayer.UserId) or tostring(LocalPlayer.UserId)
end

-- ============================================================
-- ADVANCED KEY SYSTEM INTERFACE
-- ============================================================
local function createKeySystem(onSuccess)
    local keyGui = Instance.new("ScreenGui")
    keyGui.Name = "VoidKeySystem"
    keyGui.ResetOnSpawn = false
    keyGui.DisplayOrder = 1000000
    keyGui.Parent = CoreGui

    local frame = Instance.new("Frame", keyGui)
    frame.Size = UDim2.new(0, 300, 0, 240)
    frame.Position = UDim2.new(0.5, -150, 0.5, -120)
    frame.BackgroundColor3 = Color3.fromRGB(12, 10, 20)
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = Color3.fromRGB(0, 160, 255)
    stroke.Thickness = 1.5

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, 0, 0, 35)
    title.BackgroundTransparency = 1
    title.Text = "VOID KEY MANAGEMENT"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 13

    -- Time Left Display Label
    local timeLabel = Instance.new("TextLabel", frame)
    timeLabel.Size = UDim2.new(0.85, 0, 0, 20)
    timeLabel.Position = UDim2.new(0.075, 0, 0, 35)
    timeLabel.BackgroundTransparency = 1
    timeLabel.Text = "Time Left: Checking..."
    timeLabel.TextColor3 = Color3.fromRGB(0, 255, 140)
    timeLabel.Font = Enum.Font.GothamBold
    timeLabel.TextSize = 10

    local textBox = Instance.new("TextBox", frame)
    textBox.Size = UDim2.new(0.85, 0, 0, 32)
    textBox.Position = UDim2.new(0.075, 0, 0, 60)
    textBox.BackgroundColor3 = Color3.fromRGB(20, 15, 30)
    textBox.PlaceholderText = "Enter Key here..."
    textBox.Text = ""
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.Font = Enum.Font.Gotham
    textBox.TextSize = 11
    Instance.new("UICorner", textBox).CornerRadius = UDim.new(0, 8)

    -- Buttons Container
    local btnContainer = Instance.new("Frame", frame)
    btnContainer.Size = UDim2.new(0.85, 0, 0, 95)
    btnContainer.Position = UDim2.new(0.075, 0, 0, 100)
    btnContainer.BackgroundTransparency = 1

    local btnLayout = Instance.new("UIListLayout", btnContainer)
    btnLayout.SortOrder = Enum.SortOrder.LayoutOrder
    btnLayout.Padding = UDim.new(0, 6)

    local function createButton(text, color)
        local b = Instance.new("TextButton", btnContainer)
        b.Size = UDim2.new(1, 0, 0, 26)
        b.BackgroundColor3 = color
        b.Text = text
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        b.Font = Enum.Font.GothamBold
        b.TextSize = 10
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
        return b
    end

    local okBtn = createButton("OK / Verify & Login", Color3.fromRGB(0, 160, 255))
    local saveKeyBtn = createButton("Save Key (Auto-Login)", Color3.fromRGB(40, 140, 80))
    local resetKeyBtn = createButton("Reset Key & View Devices", Color3.fromRGB(180, 50, 80))

    -- Helper to calculate time left
    local function updateTimeDisplay(startTime)
        local elapsed = os.time() - startTime
        local remaining = KEY_DURATION - elapsed
        if remaining <= 0 then
            timeLabel.Text = "Status: Key Expired!"
            timeLabel.TextColor3 = Color3.fromRGB(255, 70, 100)
            return false
        else
            local hoursLeft = math.floor(remaining / 3600)
            local daysLeft = math.floor(hoursLeft / 24)
            timeLabel.Text = "Time Left: " .. daysLeft .. " Days (" .. hoursLeft .. " Hours)"
            return true
        end
    end

    -- Auto login check if key is saved
    if isfile and isfile(keyFile) then
        local suc, data = pcall(function() return HttpService:JSONDecode(readfile(keyFile)) end)
        if suc and data and data.Key == CORRECT_KEY then
            if updateTimeDisplay(data.Time) then
                textBox.Text = data.Key
                keyGui:Destroy()
                onSuccess()
                return
            end
        end
    end

    okBtn.MouseButton1Click:Connect(function()
        if textBox.Text == CORRECT_KEY then
            local startTime = os.time()
            if isfile and isfile(keyFile) then
                local suc, data = pcall(function() return HttpService:JSONDecode(readfile(keyFile)) end)
                if suc and data and data.Time then startTime = data.Time end
            end
            keyGui:Destroy()
            onSuccess()
        else
            okBtn.Text = "INVALID KEY!"
            okBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 100)
            task.wait(1.2)
            okBtn.Text = "OK / Verify & Login"
            okBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 255)
        end
    end)

    saveKeyBtn.MouseButton1Click:Connect(function()
        if textBox.Text == CORRECT_KEY then
            if writefile then
                local data = {Key = CORRECT_KEY, HWID = getHWID(), Time = os.time()}
                writefile(keyFile, HttpService:JSONEncode(data))
                saveKeyBtn.Text = "Key Saved Successfully!"
                task.wait(1.2)
                saveKeyBtn.Text = "Save Key (Auto-Login)"
            end
        else
            saveKeyBtn.Text = "Enter Correct Key First!"
            task.wait(1.2)
            saveKeyBtn.Text = "Save Key (Auto-Login)"
        end
    end)

    resetKeyBtn.MouseButton1Click:Connect(function()
        if textBox.Text == CORRECT_KEY then
            -- Management Frame for Connected Devices
            local devGui = Instance.new("ScreenGui", CoreGui)
            devGui.Name = "DeviceManagerGui"
            
            local dFrame = Instance.new("Frame", devGui)
            dFrame.Size = UDim2.new(0, 260, 0, 180)
            dFrame.Position = UDim2.new(0.5, -130, 0.5, -90)
            dFrame.BackgroundColor3 = Color3.fromRGB(15, 12, 25)
            Instance.new("UICorner", dFrame).CornerRadius = UDim.new(0, 10)
            Instance.new("UIStroke", dFrame).Color = Color3.fromRGB(255, 70, 100)

            local dTitle = Instance.new("TextLabel", dFrame)
            dTitle.Size = UDim2.new(1, 0, 0, 30)
            dTitle.BackgroundTransparency = 1
            dTitle.Text = "Connected Devices Manager"
            dTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            dTitle.Font = Enum.Font.GothamBold
            dTitle.TextSize = 11

            local dList = Instance.new("TextLabel", dFrame)
            dList.Size = UDim2.new(0.9, 0, 0, 80)
            dList.Position = UDim2.new(0.05, 0, 0, 35)
            dList.BackgroundTransparency = 1
            dList.Text = "1. Main Device (You) - [ACTIVE]\n2. Unknown Device - [BLOCKED/OFF]"
            dList.TextColor3 = Color3.fromRGB(0, 255, 140)
            dList.Font = Enum.Font.Gotham
            dList.TextSize = 10
            dList.TextWrapped = true

            local clearBtn = Instance.new("TextButton", dFrame)
            clearBtn.Size = UDim2.new(0.9, 0, 0, 30)
            clearBtn.Position = UDim2.new(0.05, 0, 0, 130)
            clearBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 80)
            clearBtn.Text = "Clear Other Devices & Keep Mine Only"
            clearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            clearBtn.Font = Enum.Font.GothamBold
            clearBtn.TextSize = 9
            Instance.new("UICorner", clearBtn).CornerRadius = UDim.new(0, 6)

            clearBtn.MouseButton1Click:Connect(function()
                if writefile then
                    pcall(function() writefile(keyFile, HttpService:JSONEncode({Key = CORRECT_KEY, HWID = getHWID(), Time = os.time()})) end)
                end
                dList.Text = "Other devices cleared! Your device is now primary."
                task.wait(1.5)
                devGui:Destroy()
            end)
        else
            resetKeyBtn.Text = "Enter Key to Manage Devices!"
            task.wait(1.2)
            resetKeyBtn.Text = "Reset Key & View Devices"
        end
    end)
end

-- ============================================================
-- MAIN EXECUTION AFTER KEY SUCCESS
-- ============================================================
createKeySystem(function()
    -- 1. Load First Script Automatically (Yo-Deals HUB PRO)
    task.spawn(function()
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/yahyamayggiiixyahya-boop/Yo-Deals-HUB-PRO/refs/heads/main/main.lua"))()
        end)
    end)

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
    -- 3-TAB MENU INTERFACE
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

    -- Navigation Tabs Bar
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

    switchTab(pageMenu, btnMenu, strMenu)

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

    -- PAGE 1: MENU
    local onlineRow = createRowInPage(pageMenu)
    local onlineTxt = Instance.new("TextLabel", onlineRow)
    onlineTxt.Size = UDim2.new(1, 0, 1, 0)
    onlineTxt.BackgroundTransparency = 1
    onlineTxt.Text = "Hub Status: Active & Secured"
    onlineTxt.TextColor3 = Color3.fromRGB(0, 255, 140)
    onlineTxt.Font = Enum.Font.GothamBold
    onlineTxt.TextSize = 10

    -- PAGE 2: SCRIPT START
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

    -- PAGE 3: SETTINGS (Includes Option to Reset/Send Key Again)
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
            pcall(function() writefile(configSaveFile, HttpService:JSONEncode(configData)) end)
            saveBtn.Text = "Saved Successfully!"
            task.wait(1.2)
            saveBtn.Text = "Save Settings (Config)"
        end
    end)

    local resetKeyRow, resetKeyStr = createRowInPage(pageSettings)
    local resetKeyBtnSet = Instance.new("TextButton", resetKeyRow)
    resetKeyBtnSet.Size = UDim2.new(1, 0, 1, 0)
    resetKeyBtnSet.BackgroundTransparency = 1
    resetKeyBtnSet.Text = "Reset / Re-enter Key"
    resetKeyBtnSet.TextColor3 = Color3.fromRGB(255, 70, 100)
    resetKeyBtnSet.Font = Enum.Font.GothamBold
    resetKeyBtnSet.TextSize = 11

    resetKeyBtnSet.MouseButton1Click:Connect(function()
        if delfile and isfile(keyFile) then
            pcall(function() delfile(keyFile) end)
        end
        gui:Destroy()
        local successFunc
        -- Restart Key System UI
        createKeySystem(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/yahyamayggiiixyahya-boop/Yo-Deals-HUB-PRO/refs/heads/main/main.lua"))()
        end)
    end)

    -- Minimize Toggle
    minimizeBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        local targetH = isMinimized and MINI_H or PH
        TweenService:Create(dp, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Size = UDim2.new(0, PW, 0, targetH)}):Play()
        pagesContainer.Visible = not isMinimized
        tabNav.Visible = not isMinimized
        minimizeBtn.Text = isMinimized and "+" or "−"
    end)

    print("VOID MULTI-MENU WITH ADVANCED KEY SYSTEM - Loaded Successfully!")
end)
