-- السلام عليكم لا تنسى سكربتك

-- 1. تحميل مكتبة RedzLib V4
local redzlib = loadstring(game:HttpGet("https://raw.githubusercontent.com/techwearhubofc/Redz/main/Source.lua"))()

-- 2. إنشاء النافذة الرئيسية بالواجهة الجديدة المطلوبة (by: 7zn)
local Window = redzlib:MakeWindow({
  Title = "DEMOz HUB [ Beta ] : Brookhaven 🏡RP",
  SubTitle = "by : 7zn",
  LoadText = "Demoz Hub Troll version",
  Flags = "Demoz Hub | Example.lua"
})

-- 3. إضافة زر التصغير للواجهة
Window:AddMinimizeButton({
  Button = {
    Image = "rbxassetid://130688450838044"
  },
  UICorner = {true, CornerRadius = UDim.new(0.5, 0)},
  UIStroke = {false, {}}
})

-- تنبيه ترحيبي عند التشغيل
redzlib:Notification("DEMOz HUB", "تم تشغيل السكربت بنجاح بالواجهة الجديدة!\nby: 7zn", "success", 5)

---------------------------------------------------------------------
-- [ التركيز على إنشاء التبويبات والـ Tabs بالصيغة المتوافقة ]
---------------------------------------------------------------------
local SongsTab = Window:MakeTab({ Name = "قائمة الأغاني والـ IDs", Icon = "rbxassetid://4483345998" })
local AntiTab = Window:MakeTab({ Name = "المضادات والـ Anti", Icon = "rbxassetid://4483345998" })
local CreditsTab = Window:MakeTab({ Name = "الحقوق والمطور", Icon = "rbxassetid://4483345998" })

---------------------------------------------------------------------
-- [1] نظام الصوتيات والأغاني المحسن (داخل SongsTab)
---------------------------------------------------------------------
local LocalPlayer = game:GetService("Players").LocalPlayer

local function playForEveryone(audioId)
    local cleanId = tostring(audioId):match("%d+")
    if not cleanId then
        redzlib:Notification("تنبيه", "الـ ID المدخل غير صالح!", "error", 3)
        return
    end

    -- محاولة العثور على أداة الصوت في الحقيبة أو الشخصية
    local radio = LocalPlayer.Backpack:FindFirstChild("Radio") or LocalPlayer.Character:FindFirstChild("Radio") 
               or LocalPlayer.Backpack:FindFirstChild("Boombox") or LocalPlayer.Character:FindFirstChild("Boombox") or LocalPlayer.Backpack:FindFirstChild("Music")
    
    if radio then
        -- البحث عن الريموت المسؤول عن البث للجميع
        local remote = radio:FindFirstChild("Remote") or radio:FindFirstChild("Server") or radio:FindFirstChildOfClass("RemoteEvent")
        if remote and remote:IsA("RemoteEvent") then
            remote:FireServer(cleanId)
            redzlib:Notification("DEMOz HUB", "تم تشغيل الصوت عبر الراديو لكي يسمعه الجميع!", "success", 3)
        else
            -- البحث عن ريموت Brookhaven الشهير للموسيقى
            local bkrMusic = game:GetService("ReplicatedStorage"):FindFirstChild("MusicRemote") or game:GetService("ReplicatedStorage"):FindFirstChild("SoundEvent")
            if bkrMusic and bkrMusic:IsA("RemoteEvent") then
                bkrMusic:FireServer(cleanId)
                redzlib:Notification("DEMOz HUB", "تم تشغيل الصوت للجميع عبر نظام الخريطة!", "success", 3)
            else
                redzlib:Notification("تنبيه", "تم العثور على الأداة ولكن لم يتم التعرف على نظام البث العام.", "warning", 3)
            end
        end
    else
        -- تشغيل محلي كخيار احتياطي إذا لم يمتلك اللاعب راديو
        local localSound = game:GetService("Workspace"):FindFirstChild("TaxGGLocalSound")
        if not localSound then
            localSound = Instance.new("Sound", game:GetService("Workspace"))
            localSound.Name = "TaxGGLocalSound"
        end
        localSound.SoundId = "rbxassetid://" .. cleanId
        localSound.Volume = 2
        localSound:Play()
        redzlib:Notification("DEMOz HUB", "تنبيه: تم التشغيل محلياً (أنت فقط من يسمع) لعدم توفر راديو بيدك.", "warning", 4)
    end
end

SongsTab:AddSection({"التحكم بالتشغيل (by 7zn)"})

local customTrackID = ""
SongsTab:AddTextBox({"ضع ID مخصص هنا", "", function(value)
    customTrackID = value
end})

SongsTab:AddButton({"تشغيل الـ ID اليدوي 🌐", function()
    if customTrackID ~= "" then
        playForEveryone(customTrackID)
    else
        redzlib:Notification("تنبيه", "الرجاء كتابة ID أولاً", "error", 3)
    end
end})

SongsTab:AddSection({"قائمة الأكواد الخاصة بك (تبان للناس)"})

local userTracks = {
    "95877137552489", "125861618879629", "134693931986753", "107273226047360", 
    "124123680327164", "73721014572224", "87920916682123", "126581313655066", 
    "12412368037164", "79193631928944", "85822106162452", "7984027399", 
    "129963257934687", "93297302504653", "98313375960954", "3230475415", 
    "71701207559451", "106330590409106", "71373562243752", "127666185347295", 
    "9108676586"
}

for index, id in ipairs(userTracks) do
    SongsTab:AddButton({"🎵 تشغيل الكود رقم [" .. tostring(index) .. "]", function()
        playForEveryone(id)
    end})
end

---------------------------------------------------------------------
-- [2] قسم المضادات والـ Anti (داخل AntiTab)
---------------------------------------------------------------------
AntiTab:AddSection({"حماية اللاعب (Anti-AFK)"})

local antiAFKEnabled = false
AntiTab:AddToggle({"تفعيل مضاد الطرد الخامل", false, function(state)
    antiAFKEnabled = state
    if antiAFKEnabled then
        redzlib:Notification("DEMOz HUB", "مضاد الطرد يعمل الآن بنجاح!", "success", 3)
    end
end})

local VirtualUser = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    if antiAFKEnabled then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

AntiTab:AddSection({"تخفيف اللاق وزيادة الفريمات (Anti-Lag)"})

AntiTab:AddButton({"تنظيف الخريطة (إزالة التأثيرات المسببة لللاق)", function()
    local cleared = 0
    local targets = {game:GetService("Workspace"), game:GetService("Lighting")}
    for _, service in pairs(targets) do
        for _, obj in pairs(service:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
                obj.Enabled = false
                cleared = cleared + 1
            elseif obj:IsA("PostEffect") then
                obj.Enabled = false
                cleared = cleared + 1
            end
        end
    end
    redzlib:Notification("DEMOz HUB", "تم تنظيف " .. tostring(cleared) .. " تأثير لاق بنجاح!", "success", 4)
end})

AntiTab:AddButton({"نمط البطاطس (أعلى فريمات ممكنة للجميع)", function()
    for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
        if v:IsA("MeshPart") then
            v.TextureID = ""
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v:Destroy()
        end
    end
    redzlib:Notification("DEMOz HUB", "تم تفعيل نمط الفريمات العالية والمظهر المبسط!", "success", 4)
end})

---------------------------------------------------------------------
-- [3] تبويب الحقوق والمطور (داخل CreditsTab)
---------------------------------------------------------------------
CreditsTab:AddSection({"معلومات السكربت"})

CreditsTab:AddButton({"اسم السكربت: DEMOz HUB", function() end})
CreditsTab:AddButton({"المطور الرئيسي: 7zn", function() end})

CreditsTab:AddSection({"التواصل والدعم"})

CreditsTab:AddButton({"حساب التيك توك: 9z_e.1", function() 
    setclipboard("9z_e.1")
    redzlib:Notification("DEMOz HUB", "تم نسخ حساب التيك توك 9z_e.1 إلى الحافظة!", "success", 3)
end})

