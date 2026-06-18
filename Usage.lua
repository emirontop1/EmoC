_G.Version = "V1" -- Değişken adı 'Version' olarak kaldı
local EmoC = loadstring(game:HttpGet('https://raw.githubusercontent.com/emirontop1/EmoC/refs/heads/main/src/' .. _G.Version .. '.lua'))()

local MyWindow = EmoC:CreateWindow("EmoC Example", "Subtext", {
    icon = "shield-check", 
    minWidth = 400,        
    maxWidth = 800         
})

local HomeTab = MyWindow:CreateTab("Random ahh tab", "Random ahh tab description", "home")

HomeTab:CreateToggle("Another random ahh toggle", "Another random ahh toggle with description.", "box", false, false, function(state)
    print("Otomatik Çiftlik Durumu: ", state)
end)

HomeTab:CreateButton("example button", "Gerekli tüm kütüphaneleri sisteme enjekte eder.", "play", function()
    print("Modüller başarıyla yüklendi!")
end)

local SettingsTab = MyWindow:CreateTab("random ahh tab", "and one more random ahh Tab description.", "settings-gear")

SettingsTab:CreateToggle("another random ahh toggle", "another random ahh toggle description.", "power", true, true, function(state)
    print("Performans Modu Aktif: ", state)
end)

SettingsTab:CreateButton("Button example", "button description.", "user", function()
    print("Kullanıcı: " .. game.Players.LocalPlayer.Name)
end)
