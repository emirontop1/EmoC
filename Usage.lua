local EmoC = 

local MyWindow = Library:CreateWindow("Wind UI Ultimate", "Gelişmiş Yönetim Paneli", {
    icon = "shield-check", -- Başlık yanındaki ikon adı
    minWidth = 400,        -- Minimum genişlik
    maxWidth = 800         -- Maksimum genişlik
})


local HomeTab = MyWindow:CreateTab("Ana Sayfa", "Genel Ayarlar ve Durum", "home")

HomeTab:CreateToggle("Otomatik Çiftlik", "Arka planda otomatik kasılmayı başlatır.", "box", false, false, function(state)
    print("Otomatik Çiftlik Durumu: ", state)
end)

HomeTab:CreateButton("Modülleri Yükle", "Gerekli tüm kütüphaneleri sisteme enjekte eder.", "play", function()
    print("Modüller başarıyla yüklendi!")
end)

local SettingsTab = MyWindow:CreateTab("Ayarlar", "Arayüz ve Sistem Seçenekleri", "settings-gear")

SettingsTab:CreateToggle("Performans Modu", "Gereksiz efektleri kapatarak FPS artırır.", "power", true, true, function(state)
    print("Performans Modu Aktif: ", state)
end)

SettingsTab:CreateButton("Kullanıcı Bilgisi", "Mevcut profil detaylarını konsola yazdırır.", "user", function()
    print("Kullanıcı: " .. game.Players.LocalPlayer.Name)
end)
