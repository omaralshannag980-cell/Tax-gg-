--[[
    سكربت عرض وقت مزيف متزايد
    - يبدأ من 100:00:00 ويزداد كل ثانية
    - واجهة قابلة للسحب من الشريط العلوي
    - لا يحتاج أي إعدادات
]]

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- ============ إنشاء الواجهة ============
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FakeTimeDisplay"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

local Frame = Instance.new("Frame")
Frame.Name = "MainFrame"
Frame.Size = UDim2.new(0, 220, 0, 70)
Frame.Position = UDim2.new(0.5, -110, 0.5, -35)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Parent = ScreenGui

-- شريط العنوان (للسحب)
local TitleBar = Instance.new("TextLabel")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 25)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
TitleBar.Text = "⏱ وقت الجلسة - اسحب من هنا"
TitleBar.TextColor3 = Color3.new(1, 1, 1)
TitleBar.Font = Enum.Font.SourceSansBold
TitleBar.TextSize = 12
TitleBar.Active = true
TitleBar.Parent = Frame

-- عرض الوقت
local TimeLabel = Instance.new("TextLabel")
TimeLabel.Name = "TimeLabel"
TimeLabel.Size = UDim2.new(1, 0, 0, 45)
TimeLabel.Position = UDim2.new(0, 0, 0, 25)
TimeLabel.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
TimeLabel.Text = "100:00:00"
TimeLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
TimeLabel.Font = Enum.Font.SourceSansBold
TimeLabel.TextSize = 20
TimeLabel.Parent = Frame

-- ============ نظام السحب ============
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

-- ============ عداد الوقت المزيف ============
local fakeTime = 100 * 3600 -- 100 ساعة بالثواني
local lastTick = os.clock()

RunService.Heartbeat:Connect(function()
    local now = os.clock()
    local delta = now - lastTick
    lastTick = now
    fakeTime = fakeTime + delta

    local hours = math.floor(fakeTime / 3600)
    local minutes = math.floor((fakeTime % 3600) / 60)
    local seconds = math.floor(fakeTime % 60)
    TimeLabel.Text = string.format("%02d:%02d:%02d", hours, minutes, seconds)
end)
