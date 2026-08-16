--[[
    سكربت Time Spoofer
    يغير الوقت المعروض في أمر info (وقت البقاء في السيرفر)
    الواجهة قابلة للسحب
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- إنشاء الواجهة
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TimeSpooferGUI"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

local Frame = Instance.new("Frame")
Frame.Name = "MainFrame"
Frame.Size = UDim2.new(0, 260, 0, 160)
Frame.Position = UDim2.new(0.5, -130, 0.5, -80)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Parent = ScreenGui

-- شريط العنوان للسحب
local TitleBar = Instance.new("TextLabel")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
TitleBar.Text = "⏱ Time Spoofer - اسحب"
TitleBar.TextColor3 = Color3.new(1, 1, 1)
TitleBar.Font = Enum.Font.SourceSansBold
TitleBar.TextSize = 14
TitleBar.Active = true
TitleBar.Parent = Frame

-- خانة الكتابة
local InputBox = Instance.new("TextBox")
InputBox.Name = "InputBox"
InputBox.Size = UDim2.new(1, -20, 0, 40)
InputBox.Position = UDim2.new(0, 10, 0, 40)
InputBox.PlaceholderText = "أدخل الوقت (ساعات)"
InputBox.Text = ""
InputBox.BackgroundColor3 = Color3.new(1, 1, 1)
InputBox.TextColor3 = Color3.new(0, 0, 0)
InputBox.Font = Enum.Font.SourceSans
InputBox.TextSize = 16
InputBox.Parent = Frame

-- زر التنفيذ
local Button = Instance.new("TextButton")
Button.Name = "SetButton"
Button.Size = UDim2.new(1, -20, 0, 40)
Button.Position = UDim2.new(0, 10, 0, 95)
Button.Text = "تغيير الوقت"
Button.BackgroundColor3 = Color3.fromRGB(0, 160, 255)
Button.TextColor3 = Color3.new(1, 1, 1)
Button.Font = Enum.Font.SourceSansBold
Button.TextSize = 16
Button.Parent = Frame

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

-- وظيفة تغيير الوقت
Button.MouseButton1Click:Connect(function()
    local value = tonumber(InputBox.Text)
    if not value then
        InputBox.PlaceholderText = "⚠️ أدخل رقم صحيح!"
        return
    end

    local hours = value
    local minutes = hours * 60
    local seconds = hours * 3600

    -- تعديل المتغيرات العالمية الشائعة
    if getgenv then
        getgenv().TimeInServer = hours
        getgenv().SessionTime = hours
        getgenv().PlayTime = hours
        getgenv().timePlayed = hours
        getgenv().Time = hours
        getgenv().time = hours
        getgenv().InfoTime = hours
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

    -- تعديل Attributes على اللاعب (بعض الألعاب تستخدمها)
    if LocalPlayer then
        LocalPlayer:SetAttribute("TimeInServer", hours)
        LocalPlayer:SetAttribute("SessionTime", hours)
        LocalPlayer:SetAttribute("PlayTime", hours)
        LocalPlayer:SetAttribute("timePlayed", hours)
        LocalPlayer:SetAttribute("Time", hours)
    end

    -- تعديل leaderstats إذا وجد فيها وقت
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

    -- محاولة تعديل وقت السيرفر (بعض السكربتات تقرأه)
    if workspace:FindFirstChild("DistributedGameTime") then
        workspace.DistributedGameTime = seconds
    end

    -- لو فيه دالة setTime مشهورة
    if getgenv and getgenv().setTime then getgenv().setTime(hours) end
    if _G.setTime then _G.setTime(hours) end

    InputBox.PlaceholderText = "✅ تم تغيير الوقت إلى " .. hours .. " ساعة"
    InputBox.Text = ""
end)
