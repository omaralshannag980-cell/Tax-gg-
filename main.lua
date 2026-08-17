--[[
    سكربت Time Patch - يغير الوقت المعروض في أمر info
    يعمل عن طريق تعديل دوال الوقت الأساسية (os.time و tick)
    الواجهة قابلة للسحب
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- حفظ الدوال الأصلية
local origOsTime = os.time
local origTick = tick

local timeOffset = 0 -- الإزاحة بالثواني
local scriptStartTick = origTick()

-- البحث عن وقت الانضمام المخزن في المتغيرات العالمية (إذا موجود)
local function findJoinTime()
    local names = {"joinTime", "JoinTime", "sessionStart", "SessionStart", "startTime", "StartTime", "TimeInServer", "timeInServer"}
    local tables = {}
    if getgenv then table.insert(tables, getgenv()) end
    table.insert(tables, shared)
    table.insert(tables, _G)

    for _, t in pairs(tables) do
        for _, name in pairs(names) do
            local v = t[name]
            if type(v) == "number" then
                return v
            end
        end
    end
    return nil
end

-- تطبيق الباتش
local function applyPatch(hours)
    local currentRealTime = origOsTime()
    local joinTime = findJoinTime() or currentRealTime -- لو ما لقينا وقت انضمام نعتبر الآن هو وقت الانضمام

    local desiredElapsed = hours * 3600
    timeOffset = (joinTime + desiredElapsed) - currentRealTime

    -- تعديل os.time
    os.time = function(...)
        return origOsTime(...) + timeOffset
    end

    -- تعديل tick (للسكربتات اللي تستخدم tick)
    tick = function()
        return origTick() + timeOffset
    end

    -- تعديل المتغيرات العالمية كمان
    if getgenv then
        getgenv().TimeInServer = hours
        getgenv().SessionTime = hours
        getgenv().PlayTime = hours
        getgenv().timePlayed = hours
        getgenv().Time = hours
        getgenv().time = hours
    end
    shared.TimeInServer = hours
    shared.SessionTime = hours
    shared.PlayTime = hours
    shared.timePlayed = hours
    shared.Time = hours
    shared.time = hours
    _G.TimeInServer = hours
    _G.SessionTime = hours
    _G.PlayTime = hours
    _G.timePlayed = hours
    _G.Time = hours
    _G.time = hours

    -- لو فيه leaderstats وقت
    if LocalPlayer then
        local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
        if leaderstats then
            for _, stat in pairs(leaderstats:GetChildren()) do
                local lowerName = string.lower(stat.Name)
                if lowerName:find("time") or lowerName:find("hour") or lowerName:find("play") then
                    if stat:IsA("IntValue") or stat:IsA("NumberValue") then
                        stat.Value = hours
                    end
                end
            end
        end
    end
end

-- إعادة تعيين الباتش
local function resetPatch()
    timeOffset = 0
    os.time = origOsTime
    tick = origTick
end

-- ============ إنشاء الواجهة ============
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TimePatchGUI"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 260, 0, 200)
Frame.Position = UDim2.new(0.5, -130, 0.5, -100)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Parent = ScreenGui

-- شريط العنوان للسحب
local TitleBar = Instance.new("TextLabel")
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
TitleBar.Text = "⏱ Time Patch - اسحب"
TitleBar.TextColor3 = Color3.new(1, 1, 1)
TitleBar.Font = Enum.Font.SourceSansBold
TitleBar.TextSize = 14
TitleBar.Active = true
TitleBar.Parent = Frame

-- خانة الكتابة
local InputBox = Instance.new("TextBox")
InputBox.Size = UDim2.new(1, -20, 0, 40)
InputBox.Position = UDim2.new(0, 10, 0, 40)
InputBox.PlaceholderText = "أدخل الوقت (ساعات)"
InputBox.Text = ""
InputBox.BackgroundColor3 = Color3.new(1, 1, 1)
InputBox.TextColor3 = Color3.new(0, 0, 0)
InputBox.Font = Enum.Font.SourceSans
InputBox.TextSize = 16
InputBox.Parent = Frame

-- زر التطبيق
local ApplyButton = Instance.new("TextButton")
ApplyButton.Size = UDim2.new(1, -20, 0, 40)
ApplyButton.Position = UDim2.new(0, 10, 0, 95)
ApplyButton.Text = "تغيير الوقت"
ApplyButton.BackgroundColor3 = Color3.fromRGB(0, 160, 255)
ApplyButton.TextColor3 = Color3.new(1, 1, 1)
ApplyButton.Font = Enum.Font.SourceSansBold
ApplyButton.TextSize = 16
ApplyButton.Parent = Frame

-- زر إعادة التعيين
local ResetButton = Instance.new("TextButton")
ResetButton.Size = UDim2.new(1, -20, 0, 35)
ResetButton.Position = UDim2.new(0, 10, 0, 145)
ResetButton.Text = "إعادة تعيين"
ResetButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
ResetButton.TextColor3 = Color3.new(1, 1, 1)
ResetButton.Font = Enum.Font.SourceSansBold
ResetButton.TextSize = 14
ResetButton.Parent = Frame

-- نظام السحب
local dragging = false
local startMouse = nil
local startFramePos = nil

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        startMouse = input.Position
        startFramePos = Frame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - startMouse
        Frame.Position = UDim2.new(
            startFramePos.X.Scale,
            startFramePos.X.Offset + delta.X,
            startFramePos.Y.Scale,
            startFramePos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- زر التطبيق
ApplyButton.MouseButton1Click:Connect(function()
    local value = tonumber(InputBox.Text)
    if not value then
        InputBox.PlaceholderText = "⚠️ أدخل رقم صحيح!"
        return
    end
    applyPatch(value)
    InputBox.PlaceholderText = "✅ تم تغيير الوقت إلى " .. value .. " ساعة"
    InputBox.Text = ""
end)

-- زر إعادة التعيين
ResetButton.MouseButton1Click:Connect(function()
    resetPatch()
    InputBox.PlaceholderText = "تم إعادة التعيين"
    InputBox.Text = ""
end)
