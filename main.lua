--[[
    سكربت تغيير الوقت مع واجهة GUI قابلة للسحب
    يعمل في منفذ Roblox (Executor)
    ضع الرقم ثم اضغط "تغيير الوقت"
]]

local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- إنشاء الواجهة
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TimeChangerGUI"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 260, 0, 160)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -80)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

-- شريط العنوان للسحب
local TitleBar = Instance.new("TextLabel")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
TitleBar.Text = "⏱ تغيير الوقت - اسحب من هنا"
TitleBar.TextColor3 = Color3.new(1, 1, 1)
TitleBar.Font = Enum.Font.SourceSansBold
TitleBar.TextSize = 14
TitleBar.Active = true
TitleBar.Parent = MainFrame

-- خانة الكتابة
local InputBox = Instance.new("TextBox")
InputBox.Name = "InputBox"
InputBox.Size = UDim2.new(1, -20, 0, 40)
InputBox.Position = UDim2.new(0, 10, 0, 40)
InputBox.PlaceholderText = "أدخل الوقت مثال: 100"
InputBox.Text = ""
InputBox.BackgroundColor3 = Color3.new(1, 1, 1)
InputBox.TextColor3 = Color3.new(0, 0, 0)
InputBox.Font = Enum.Font.SourceSans
InputBox.TextSize = 16
InputBox.Parent = MainFrame

-- زر التنفيذ
local SetButton = Instance.new("TextButton")
SetButton.Name = "SetButton"
SetButton.Size = UDim2.new(1, -20, 0, 40)
SetButton.Position = UDim2.new(0, 10, 0, 95)
SetButton.Text = "تغيير الوقت"
SetButton.BackgroundColor3 = Color3.fromRGB(0, 160, 255)
SetButton.TextColor3 = Color3.new(1, 1, 1)
SetButton.Font = Enum.Font.SourceSansBold
SetButton.TextSize = 16
SetButton.Parent = MainFrame

-- كائنات السحب
local dragging = false
local startMouse = nil
local startFramePos = nil

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        startMouse = input.Position
        startFramePos = MainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - startMouse
        MainFrame.Position = UDim2.new(
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
SetButton.MouseButton1Click:Connect(function()
    local value = tonumber(InputBox.Text)
    if not value then
        InputBox.PlaceholderText = "⚠️ أدخل رقم صحيح!"
        return
    end

    -- تغيير وقت اللعبة (Lighting)
    Lighting.ClockTime = value
    Lighting:SetMinutesAfterMidnight(value)

    -- محاولة تعديل متغيرات سكربت انفنتي (عدّل الأسماء حسب سكربتك)
    if getgenv then
        getgenv().Time = value
        getgenv().time = value
        getgenv().InfoTime = value
    end
    _G.Time = value
    _G.time = value
    _G.InfoTime = value
    shared.Time = value
    shared.time = value

    -- لو فيه دالة setTime في السكربت
    if getgenv and getgenv().setTime then getgenv().setTime(value) end
    if _G.setTime then _G.setTime(value) end

    InputBox.PlaceholderText = "✅ تم تغيير الوقت إلى " .. value
    InputBox.Text = ""
end)
