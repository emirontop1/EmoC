_G.Version = "V2" -- Değişken adı 'Version' olarak kaldı
local EmoC = loadstring(game:HttpGet('https://raw.githubusercontent.com/emirontop1/EmoC/refs/heads/main/src/' .. _G.Version .. '.lua'))()

local Config = {
    icon = "shield-check", 
    minWidth = 450,        
    maxWidth = 900,
    confirmClose = true -- Çarpıya basınca emin misiniz sorsun mu?
}

local MyWindow = EmoC:CreateWindow("Wind UI Ultimate", "TextBox, Slider, Dropdown & Theme", Config)

-- SEKME 1: YENİ ELEMENTLER
local HomeTab = MyWindow:CreateTab("Yeni Elementler", "TextBox, Slider, Dropdown", "home")

HomeTab:CreateTextBox("Oyuncu Adı Gir", "Hedef oyuncunun ismini yaz...", function(text)
	print("Girilen Yazı: " .. text)
end)

HomeTab:CreateSlider("Karakter Hızı (WalkSpeed)", 16, 200, 16, function(value)
	print("Yeni Hız Değeri: ", value)
	game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end)

HomeTab:CreateDropdown("Hedef Bölge Seç", {"Spawn Noktası", "VIP Alanı", "Arena", "Güvenli Bölge"}, "Spawn Noktası", function(selectedOption)
	print("Işınlanılacak Yer Seçildi: ", selectedOption)
end)

HomeTab:CreateSpace(15)

-- SEKME 2: TEMA DEĞİŞTİRİCİ
local SettingsTab = MyWindow:CreateTab("Arayüz Ayarları", "Temayı Özelleştir", "settings-gear")

local ThemeSection = SettingsTab:CreateSection("Tema Rengi Seçimi")

ThemeSection:CreateButton("Mor Tema (Purple Vibe)", "Arayüzü mor renge dönüştürür.", "play", function()
	MyWindow:ChangeTheme({
		Accent = Color3.fromRGB(155, 89, 182),
		Background = Color3.fromRGB(15, 12, 22),
		Stroke = Color3.fromRGB(40, 35, 55),
		TabSelected = Color3.fromRGB(25, 20, 35)
	})
end)

ThemeSection:CreateButton("Mavi Tema (Ocean Blue)", "Arayüzü deniz mavisine dönüştürür.", "play", function()
	MyWindow:ChangeTheme({
		Accent = Color3.fromRGB(0, 180, 255),
		Background = Color3.fromRGB(11, 14, 20),
		Stroke = Color3.fromRGB(30, 38, 50),
		TabSelected = Color3.fromRGB(20, 28, 40)
	})
end)

ThemeSection:CreateButton("Varsayılan Yeşil (Wind UI)", "Orijinal yeşil temaya döner.", "play", function()
	MyWindow:ChangeTheme({
		Accent = Color3.fromRGB(46, 204, 113),
		Background = Color3.fromRGB(14, 14, 14),
		Stroke = Color3.fromRGB(30, 30, 30),
		TabSelected = Color3.fromRGB(28, 28, 28)
	})
end)
