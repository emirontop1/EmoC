local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local EmoC = {}

--------------------------------------------------------------------
-- İKON SİSTEMİ
--------------------------------------------------------------------
local IconSystem = {
	Spritesheets = {
		["1"] = "rbxassetid://133454478968909",
		["2"] = "rbxassetid://72981277089259",
		["3"] = "rbxassetid://73688247122068",
		["4"] = "rbxassetid://81914421960723",
		["5"] = "rbxassetid://86699749765447",
		["6"] = "rbxassetid://120220597097660",
		["7"] = "rbxassetid://72166980445410",
		["8"] = "rbxassetid://101990875962066",
	},
	Icons = {
		["home"]          = { Image = 4, ImageRectPosition = Vector2.new(512, 256),  ImageRectSize = Vector2.new(128, 128) },
		["settings-gear"] = { Image = 6, ImageRectPosition = Vector2.new(512, 768),  ImageRectSize = Vector2.new(128, 128) },
		["user"]          = { Image = 7, ImageRectPosition = Vector2.new(640, 896),  ImageRectSize = Vector2.new(128, 128) },
		["box"]           = { Image = 1, ImageRectPosition = Vector2.new(640, 768),  ImageRectSize = Vector2.new(128, 128) },
		["shield-check"]  = { Image = 6, ImageRectPosition = Vector2.new(384, 896),  ImageRectSize = Vector2.new(128, 128) },
		["code"]          = { Image = 2, ImageRectPosition = Vector2.new(768, 640),  ImageRectSize = Vector2.new(128, 128) },
		["play"]          = { Image = 6, ImageRectPosition = Vector2.new(0, 384),    ImageRectSize = Vector2.new(128, 128) },
		["power"]         = { Image = 6, ImageRectPosition = Vector2.new(768, 384),  ImageRectSize = Vector2.new(128, 128) },
		["chevron-down"]  = { Image = 2, ImageRectPosition = Vector2.new(640, 384),  ImageRectSize = Vector2.new(128, 128) },
		["pencil"]        = { Image = 6, ImageRectPosition = Vector2.new(128, 256),  ImageRectSize = Vector2.new(128, 128) },
		["menu"]          = { Image = 5, ImageRectPosition = Vector2.new(640, 768),  ImageRectSize = Vector2.new(128, 128) },
		["bell"]          = { Image = 3, ImageRectPosition = Vector2.new(0, 0),      ImageRectSize = Vector2.new(128, 128) },
		["check"]         = { Image = 2, ImageRectPosition = Vector2.new(256, 256),  ImageRectSize = Vector2.new(128, 128) },
		["x"]             = { Image = 2, ImageRectPosition = Vector2.new(768, 896),  ImageRectSize = Vector2.new(128, 128) },
		["search"]        = { Image = 5, ImageRectPosition = Vector2.new(256, 896),  ImageRectSize = Vector2.new(128, 128) },
		["keyboard"]      = { Image = 4, ImageRectPosition = Vector2.new(384, 640),  ImageRectSize = Vector2.new(128, 128) },
		["palette"]       = { Image = 3, ImageRectPosition = Vector2.new(768, 768),  ImageRectSize = Vector2.new(128, 128) },
		["info"]          = { Image = 4, ImageRectPosition = Vector2.new(128, 512),  ImageRectSize = Vector2.new(128, 128) },
		["warning"]       = { Image = 3, ImageRectPosition = Vector2.new(512, 896),  ImageRectSize = Vector2.new(128, 128) },
		["star"]          = { Image = 5, ImageRectPosition = Vector2.new(128, 896),  ImageRectSize = Vector2.new(128, 128) },
		["trash"]         = { Image = 7, ImageRectPosition = Vector2.new(512, 512),  ImageRectSize = Vector2.new(128, 128) },
		["copy"]          = { Image = 2, ImageRectPosition = Vector2.new(0, 512),    ImageRectSize = Vector2.new(128, 128) },
		["lock"]          = { Image = 5, ImageRectPosition = Vector2.new(128, 384),  ImageRectSize = Vector2.new(128, 128) },
		["eye"]           = { Image = 3, ImageRectPosition = Vector2.new(256, 384),  ImageRectSize = Vector2.new(128, 128) },
	}
}

local function LoadIcon(imageLabel, iconName)
	local iconData = IconSystem.Icons[iconName]
	if iconData then
		imageLabel.Image = IconSystem.Spritesheets[tostring(iconData.Image)]
		imageLabel.ImageRectOffset = iconData.ImageRectPosition
		imageLabel.ImageRectSize = iconData.ImageRectSize
		imageLabel.BackgroundTransparency = 1
		imageLabel.Visible = true
	else
		imageLabel.Visible = false
	end
end

--------------------------------------------------------------------
-- YARDIMCI FONKSİYONLAR
--------------------------------------------------------------------
local function Tween(obj, duration, props, style, dir)
	style = style or Enum.EasingStyle.Quad
	dir = dir or Enum.EasingDirection.Out
	TweenService:Create(obj, TweenInfo.new(duration, style, dir), props):Play()
end

local function HSVtoRGB(h, s, v)
	local r, g, b
	local i = math.floor(h * 6)
	local f = h * 6 - i
	local p = v * (1 - s)
	local q = v * (1 - f * s)
	local t = v * (1 - (1 - f) * s)
	i = i % 6
	if i == 0 then r, g, b = v, t, p
	elseif i == 1 then r, g, b = q, v, p
	elseif i == 2 then r, g, b = p, v, t
	elseif i == 3 then r, g, b = p, q, v
	elseif i == 4 then r, g, b = t, p, v
	elseif i == 5 then r, g, b = v, p, q end
	return Color3.new(r, g, b)
end

local function RGBtoHSV(color)
	local r, g, b = color.R, color.G, color.B
	local max = math.max(r, g, b)
	local min = math.min(r, g, b)
	local delta = max - min
	local h, s, v = 0, 0, max
	if max ~= 0 then s = delta / max end
	if delta ~= 0 then
		if max == r then h = (g - b) / delta % 6
		elseif max == g then h = (b - r) / delta + 2
		else h = (r - g) / delta + 4 end
		h = h / 6
	end
	return h, s, v
end

local function ColorToHex(color)
	return string.format("#%02X%02X%02X",
		math.floor(color.R * 255),
		math.floor(color.G * 255),
		math.floor(color.B * 255))
end

--------------------------------------------------------------------
-- ANA KÜTÜPHANE MOTORU
--------------------------------------------------------------------
function EmoC:CreateWindow(mainTitle, subTitleText, config)
	config = config or {}
	local minWidth    = config.minWidth    or 400
	local maxWidth    = config.maxWidth    or 900
	local confirmClose = config.confirmClose == nil and true or config.confirmClose
	local toggleKey   = config.toggleKey   or Enum.KeyCode.RightControl

	local currentTheme = {
		Background  = Color3.fromRGB(14, 14, 14),
		Topbar      = Color3.fromRGB(18, 18, 18),
		Accent      = Color3.fromRGB(46, 204, 113),
		Stroke      = Color3.fromRGB(30, 30, 30),
		Text        = Color3.fromRGB(255, 255, 255),
		TextMuted   = Color3.fromRGB(120, 120, 120),
		TabSelected = Color3.fromRGB(28, 28, 28),
		Success     = Color3.fromRGB(46, 204, 113),
		Warning     = Color3.fromRGB(241, 196, 15),
		Error       = Color3.fromRGB(231, 76, 60),
		Info        = Color3.fromRGB(52, 152, 219),
	}

	if config.customTheme and config.theme then
		for key, value in pairs(config.theme) do currentTheme[key] = value end
	end

	local ThemeRegistry = {}
	for key, _ in pairs(currentTheme) do ThemeRegistry[key] = {} end

	local function RegisterTheme(obj, prop, type)
		if ThemeRegistry[type] then
			table.insert(ThemeRegistry[type], {Obj = obj, Prop = prop})
		end
	end

	--------------------------------------------------------------------
	-- SCREENGUI
	--------------------------------------------------------------------
	local ScreenGui = Instance.new("ScreenGui")
	pcall(function() ScreenGui.Parent = CoreGui end)
	if not ScreenGui.Parent then ScreenGui.Parent = PlayerGui end
	ScreenGui.Name = "WindUiUltimate_V4"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.DisplayOrder = 100

	local isMinimized, isMaximized = false, false
	local originalSize = UDim2.new(0, math.clamp(560, minWidth, maxWidth), 0, 400)
	local originalPos  = UDim2.new(0.5, -280, 0.5, -200)
	local normalSizeBeforeMaximize, normalPosBeforeMaximize = originalSize, originalPos
	local windowVisible = true

	--------------------------------------------------------------------
	-- WATERMARK (Opsiyonel üst sol köşe etiketi)
	--------------------------------------------------------------------
	local WatermarkFrame = nil
	local WatermarkLabel = nil

	--------------------------------------------------------------------
	-- ANA FRAME
	--------------------------------------------------------------------
	local MainFrame = Instance.new("Frame", ScreenGui)
	MainFrame.Name = "MainFrame"
	MainFrame.Size = originalSize
	MainFrame.Position = originalPos
	MainFrame.BackgroundColor3 = currentTheme.Background
	MainFrame.BorderSizePixel = 0
	MainFrame.ClipsDescendants = false
	RegisterTheme(MainFrame, "BackgroundColor3", "Background")

	Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
	local MainStroke = Instance.new("UIStroke", MainFrame)
	MainStroke.Color = currentTheme.Stroke
	MainStroke.Thickness = 1.5
	RegisterTheme(MainStroke, "Color", "Stroke")

	-- Gölge efekti
	local Shadow = Instance.new("ImageLabel", MainFrame)
	Shadow.Name = "Shadow"
	Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
	Shadow.BackgroundTransparency = 1
	Shadow.Position = UDim2.new(0.5, 0, 0.5, 4)
	Shadow.Size = UDim2.new(1, 30, 1, 30)
	Shadow.ZIndex = 0
	Shadow.Image = "rbxassetid://5554236805"
	Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	Shadow.ImageTransparency = 0.7
	Shadow.ScaleType = Enum.ScaleType.Slice
	Shadow.SliceCenter = Rect.new(23, 23, 277, 277)

	--------------------------------------------------------------------
	-- ÜSTBAR
	--------------------------------------------------------------------
	local Topbar = Instance.new("Frame", MainFrame)
	Topbar.Size = UDim2.new(1, 0, 0, 55)
	Topbar.BackgroundTransparency = 1

	local TopbarBottom = Instance.new("Frame", Topbar)
	TopbarBottom.Size = UDim2.new(1, 0, 0, 1)
	TopbarBottom.Position = UDim2.new(0, 0, 1, -1)
	TopbarBottom.BackgroundColor3 = currentTheme.Stroke
	TopbarBottom.BorderSizePixel = 0
	RegisterTheme(TopbarBottom, "BackgroundColor3", "Stroke")

	local titleOffsetX = config.icon and 45 or 15
	if config.icon then
		local WindowIcon = Instance.new("ImageLabel", Topbar)
		WindowIcon.Size = UDim2.new(0, 22, 0, 22)
		WindowIcon.Position = UDim2.new(0, 15, 0, 15)
		WindowIcon.ImageColor3 = currentTheme.Accent
		LoadIcon(WindowIcon, config.icon)
		RegisterTheme(WindowIcon, "ImageColor3", "Accent")
	end

	local Title = Instance.new("TextLabel", Topbar)
	Title.Size = UDim2.new(0.6, 0, 0, 25)
	Title.Position = UDim2.new(0, titleOffsetX, 0, 10)
	Title.BackgroundTransparency = 1
	Title.Text = mainTitle or "WIND UI V4"
	Title.TextColor3 = currentTheme.Text
	Title.Font = Enum.Font.GothamBold
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.TextScaled = true
	local TitleSC = Instance.new("UITextSizeConstraint", Title)
	TitleSC.MaxTextSize = 16; TitleSC.MinTextSize = 12

	local SubTitle = Instance.new("TextLabel", Topbar)
	SubTitle.Size = UDim2.new(0.6, 0, 0, 15)
	SubTitle.Position = UDim2.new(0, titleOffsetX, 0, 32)
	SubTitle.BackgroundTransparency = 1
	SubTitle.Text = subTitleText or "EmoC UI Library"
	SubTitle.TextColor3 = currentTheme.TextMuted
	SubTitle.Font = Enum.Font.GothamMedium
	SubTitle.TextXAlignment = Enum.TextXAlignment.Left
	SubTitle.TextScaled = true
	local SubSC = Instance.new("UITextSizeConstraint", SubTitle)
	SubSC.MaxTextSize = 11; SubSC.MinTextSize = 9

	-- Kontrol Butonları
	local ButtonContainer = Instance.new("Frame", Topbar)
	ButtonContainer.Size = UDim2.new(0, 90, 0, 30)
	ButtonContainer.Position = UDim2.new(1, -100, 0, 12)
	ButtonContainer.BackgroundTransparency = 1
	local BtnLayout = Instance.new("UIListLayout", ButtonContainer)
	BtnLayout.FillDirection = Enum.FillDirection.Horizontal
	BtnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	BtnLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	BtnLayout.Padding = UDim.new(0, 8)

	local function createControlBtn(name, color, symbol)
		local Btn = Instance.new("TextButton", ButtonContainer)
		Btn.Size = UDim2.new(0, 22, 0, 22)
		Btn.BackgroundColor3 = currentTheme.TabSelected
		Btn.Text = symbol
		Btn.TextColor3 = color
		Btn.TextSize = 10
		Btn.Font = Enum.Font.GothamBold
		Btn.AutoButtonColor = false
		Instance.new("UICorner", Btn).CornerRadius = UDim.new(1, 0)
		local bs = Instance.new("UIStroke", Btn)
		bs.Color = currentTheme.Stroke
		RegisterTheme(bs, "Color", "Stroke")
		Btn.MouseEnter:Connect(function() Tween(Btn, 0.2, {BackgroundColor3 = color, TextColor3 = currentTheme.Background}) end)
		Btn.MouseLeave:Connect(function() Tween(Btn, 0.2, {BackgroundColor3 = currentTheme.TabSelected, TextColor3 = color}) end)
		return Btn
	end

	local MinimizeBtn = createControlBtn("Minimize", Color3.fromRGB(241, 196, 15), "-")
	local MaximizeBtn = createControlBtn("Maximize", currentTheme.Accent, "+")
	RegisterTheme(MaximizeBtn, "TextColor3", "Accent")
	local CloseBtn = createControlBtn("Close", Color3.fromRGB(231, 76, 60), "x")

	--------------------------------------------------------------------
	-- ARAMA ÇUBUĞU (Sidebar üstü)
	--------------------------------------------------------------------
	local currentSidebarWidth = 150

	local Sidebar = Instance.new("Frame", MainFrame)
	Sidebar.Size = UDim2.new(0, currentSidebarWidth, 1, -55)
	Sidebar.Position = UDim2.new(0, 0, 0, 55)
	Sidebar.BackgroundTransparency = 1
	Sidebar.ClipsDescendants = true

	-- Sidebar arama kutusu
	local SidebarSearchFrame = Instance.new("Frame", Sidebar)
	SidebarSearchFrame.Size = UDim2.new(1, -16, 0, 28)
	SidebarSearchFrame.Position = UDim2.new(0, 8, 0, 6)
	SidebarSearchFrame.BackgroundColor3 = currentTheme.TabSelected
	SidebarSearchFrame.BackgroundTransparency = 0.4
	SidebarSearchFrame.ZIndex = 2
	Instance.new("UICorner", SidebarSearchFrame).CornerRadius = UDim.new(0, 6)
	local ssStroke = Instance.new("UIStroke", SidebarSearchFrame)
	ssStroke.Color = currentTheme.Stroke
	ssStroke.Thickness = 1
	RegisterTheme(SidebarSearchFrame, "BackgroundColor3", "TabSelected")
	RegisterTheme(ssStroke, "Color", "Stroke")

	local SearchIcon = Instance.new("ImageLabel", SidebarSearchFrame)
	SearchIcon.Size = UDim2.new(0, 12, 0, 12)
	SearchIcon.Position = UDim2.new(0, 8, 0.5, -6)
	SearchIcon.BackgroundTransparency = 1
	SearchIcon.ImageColor3 = currentTheme.TextMuted
	LoadIcon(SearchIcon, "search")

	local SidebarSearch = Instance.new("TextBox", SidebarSearchFrame)
	SidebarSearch.Size = UDim2.new(1, -28, 1, 0)
	SidebarSearch.Position = UDim2.new(0, 24, 0, 0)
	SidebarSearch.BackgroundTransparency = 1
	SidebarSearch.Text = ""
	SidebarSearch.PlaceholderText = "Sekme ara..."
	SidebarSearch.TextColor3 = currentTheme.Text
	SidebarSearch.PlaceholderColor3 = currentTheme.TextMuted
	SidebarSearch.TextSize = 11
	SidebarSearch.Font = Enum.Font.Gotham
	SidebarSearch.TextXAlignment = Enum.TextXAlignment.Left
	SidebarSearch.ClearTextOnFocus = false
	SidebarSearch.ZIndex = 3

	local SidebarScrollFrame = Instance.new("ScrollingFrame", Sidebar)
	SidebarScrollFrame.Size = UDim2.new(1, 0, 1, -42)
	SidebarScrollFrame.Position = UDim2.new(0, 0, 0, 40)
	SidebarScrollFrame.BackgroundTransparency = 1
	SidebarScrollFrame.ScrollBarThickness = 0
	local SidebarLayout = Instance.new("UIListLayout", SidebarScrollFrame)
	SidebarLayout.Padding = UDim.new(0, 5)
	SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
	local SidebarPadding = Instance.new("UIPadding", SidebarScrollFrame)
	SidebarPadding.PaddingLeft = UDim.new(0, 8)
	SidebarPadding.PaddingRight = UDim.new(0, 8)
	SidebarPadding.PaddingTop = UDim.new(0, 4)
	SidebarLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		SidebarScrollFrame.CanvasSize = UDim2.new(0, 0, 0, SidebarLayout.AbsoluteContentSize.Y + 20)
	end)

	local TabButtons = {} -- Arama için tab referansları

	SidebarSearch:GetPropertyChangedSignal("Text"):Connect(function()
		local query = SidebarSearch.Text:lower()
		for _, entry in pairs(TabButtons) do
			local matches = query == "" or entry.Name:lower():find(query, 1, true)
			entry.Button.Visible = matches ~= nil and matches ~= false
		end
	end)

	--------------------------------------------------------------------
	-- BÖLÜCÜ & İÇERİK ALANI
	--------------------------------------------------------------------
	local VerticalDivider = Instance.new("Frame", MainFrame)
	VerticalDivider.Size = UDim2.new(0, 1, 1, -55)
	VerticalDivider.Position = UDim2.new(0, currentSidebarWidth, 0, 55)
	VerticalDivider.BackgroundColor3 = currentTheme.Stroke
	VerticalDivider.BorderSizePixel = 0
	RegisterTheme(VerticalDivider, "BackgroundColor3", "Stroke")

	local ContentArea = Instance.new("Frame", MainFrame)
	ContentArea.Size = UDim2.new(1, -(currentSidebarWidth + 1), 1, -55)
	ContentArea.Position = UDim2.new(0, currentSidebarWidth + 1, 0, 55)
	ContentArea.BackgroundTransparency = 1
	ContentArea.ClipsDescendants = true

	-- Resizable Divider
	local DividerHandle = Instance.new("TextButton", VerticalDivider)
	DividerHandle.Size = UDim2.new(0, 10, 1, 0)
	DividerHandle.Position = UDim2.new(0.5, -5, 0, 0)
	DividerHandle.BackgroundTransparency = 1
	DividerHandle.Text = ""
	DividerHandle.ZIndex = 50

	local divResizing, divStartPos, divStartWidth = false
	DividerHandle.MouseEnter:Connect(function() Tween(VerticalDivider, 0.2, {BackgroundColor3 = currentTheme.Accent, Size = UDim2.new(0, 2, 1, -55)}) end)
	DividerHandle.MouseLeave:Connect(function() if not divResizing then Tween(VerticalDivider, 0.2, {BackgroundColor3 = currentTheme.Stroke, Size = UDim2.new(0, 1, 1, -55)}) end end)
	DividerHandle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			divResizing = true; divStartPos = input.Position; divStartWidth = currentSidebarWidth
			Tween(VerticalDivider, 0.2, {BackgroundColor3 = currentTheme.Accent, Size = UDim2.new(0, 2, 1, -55)})
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if divResizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - divStartPos
			currentSidebarWidth = math.clamp(divStartWidth + delta.X, 100, 260)
			Sidebar.Size = UDim2.new(0, currentSidebarWidth, 1, -55)
			VerticalDivider.Position = UDim2.new(0, currentSidebarWidth, 0, 55)
			ContentArea.Size = UDim2.new(1, -(currentSidebarWidth + 1), 1, -55)
			ContentArea.Position = UDim2.new(0, currentSidebarWidth + 1, 0, 55)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			divResizing = false
			Tween(VerticalDivider, 0.2, {BackgroundColor3 = currentTheme.Stroke, Size = UDim2.new(0, 1, 1, -55)})
		end
	end)

	--------------------------------------------------------------------
	-- BİLDİRİM SİSTEMİ (Toast Notifications)
	--------------------------------------------------------------------
	local NotifContainer = Instance.new("Frame", ScreenGui)
	NotifContainer.Size = UDim2.new(0, 300, 1, 0)
	NotifContainer.Position = UDim2.new(1, -310, 0, 0)
	NotifContainer.BackgroundTransparency = 1
	NotifContainer.ZIndex = 200
	local NotifLayout = Instance.new("UIListLayout", NotifContainer)
	NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	NotifLayout.Padding = UDim.new(0, 8)
	local NotifPad = Instance.new("UIPadding", NotifContainer)
	NotifPad.PaddingBottom = UDim.new(0, 12)
	NotifPad.PaddingRight = UDim.new(0, 4)

	local function SendNotification(title, message, notifType, duration)
		notifType = notifType or "info"
		duration = duration or 4

		local typeColors = {
			success = currentTheme.Success,
			warning = currentTheme.Warning,
			error   = currentTheme.Error,
			info    = currentTheme.Info,
		}
		local typeIcons = {
			success = "check",
			warning = "warning",
			error   = "x",
			info    = "info",
		}

		local accentColor = typeColors[notifType] or currentTheme.Accent
		local iconName    = typeIcons[notifType]   or "bell"

		local NFrame = Instance.new("Frame", NotifContainer)
		NFrame.Size = UDim2.new(1, 0, 0, 0)
		NFrame.BackgroundColor3 = currentTheme.Background
		NFrame.BackgroundTransparency = 0
		NFrame.ClipsDescendants = true
		NFrame.ZIndex = 201
		Instance.new("UICorner", NFrame).CornerRadius = UDim.new(0, 8)
		local nStroke = Instance.new("UIStroke", NFrame)
		nStroke.Color = accentColor; nStroke.Thickness = 1

		local AccentBar = Instance.new("Frame", NFrame)
		AccentBar.Size = UDim2.new(0, 3, 1, 0)
		AccentBar.BackgroundColor3 = accentColor
		AccentBar.BorderSizePixel = 0
		AccentBar.ZIndex = 202
		Instance.new("UICorner", AccentBar).CornerRadius = UDim.new(0, 2)

		local NIcon = Instance.new("ImageLabel", NFrame)
		NIcon.Size = UDim2.new(0, 16, 0, 16)
		NIcon.Position = UDim2.new(0, 12, 0, 12)
		NIcon.BackgroundTransparency = 1
		NIcon.ImageColor3 = accentColor
		NIcon.ZIndex = 202
		LoadIcon(NIcon, iconName)

		local NTitle = Instance.new("TextLabel", NFrame)
		NTitle.Size = UDim2.new(1, -52, 0, 18)
		NTitle.Position = UDim2.new(0, 34, 0, 8)
		NTitle.BackgroundTransparency = 1
		NTitle.Text = title
		NTitle.TextColor3 = currentTheme.Text
		NTitle.Font = Enum.Font.GothamBold
		NTitle.TextSize = 13
		NTitle.TextXAlignment = Enum.TextXAlignment.Left
		NTitle.ZIndex = 202

		local NDesc = Instance.new("TextLabel", NFrame)
		NDesc.Size = UDim2.new(1, -20, 0, 30)
		NDesc.Position = UDim2.new(0, 12, 0, 28)
		NDesc.BackgroundTransparency = 1
		NDesc.Text = message or ""
		NDesc.TextColor3 = currentTheme.TextMuted
		NDesc.Font = Enum.Font.Gotham
		NDesc.TextSize = 11
		NDesc.TextWrapped = true
		NDesc.TextXAlignment = Enum.TextXAlignment.Left
		NDesc.ZIndex = 202

		-- Progress bar
		local NProgress = Instance.new("Frame", NFrame)
		NProgress.Size = UDim2.new(1, 0, 0, 2)
		NProgress.Position = UDim2.new(0, 0, 1, -2)
		NProgress.BackgroundColor3 = accentColor
		NProgress.BorderSizePixel = 0
		NProgress.ZIndex = 202
		Instance.new("UICorner", NProgress).CornerRadius = UDim.new(0, 1)

		-- Kapat butonu
		local NClose = Instance.new("TextButton", NFrame)
		NClose.Size = UDim2.new(0, 16, 0, 16)
		NClose.Position = UDim2.new(1, -20, 0, 8)
		NClose.BackgroundTransparency = 1
		NClose.Text = "×"
		NClose.TextColor3 = currentTheme.TextMuted
		NClose.TextSize = 16
		NClose.Font = Enum.Font.GothamBold
		NClose.ZIndex = 203

		-- Animasyon: aç
		Tween(NFrame, 0.3, {Size = UDim2.new(1, 0, 0, 64)}, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
		Tween(NProgress, duration, {Size = UDim2.new(0, 0, 0, 2)})

		local function CloseNotif()
			Tween(NFrame, 0.3, {Size = UDim2.new(1, 0, 0, 0)})
			task.delay(0.35, function() NFrame:Destroy() end)
		end

		NClose.MouseButton1Click:Connect(CloseNotif)
		task.delay(duration, CloseNotif)
	end

	--------------------------------------------------------------------
	-- POPUP SİSTEMİ
	--------------------------------------------------------------------
	local PopupOverlay = Instance.new("TextButton", MainFrame)
	PopupOverlay.Size = UDim2.new(1, 0, 1, 0)
	PopupOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	PopupOverlay.BackgroundTransparency = 1
	PopupOverlay.Text = ""
	PopupOverlay.AutoButtonColor = false
	PopupOverlay.Visible = false
	PopupOverlay.ZIndex = 100
	Instance.new("UICorner", PopupOverlay).CornerRadius = UDim.new(0, 10)

	local PopupBox = Instance.new("Frame", PopupOverlay)
	PopupBox.Size = UDim2.new(0, 300, 0, 160)
	PopupBox.Position = UDim2.new(0.5, -150, 0.5, -55)
	PopupBox.BackgroundColor3 = currentTheme.Background
	PopupBox.ZIndex = 101
	PopupBox.BackgroundTransparency = 1
	Instance.new("UICorner", PopupBox).CornerRadius = UDim.new(0, 8)
	local PopupStroke = Instance.new("UIStroke", PopupBox)
	PopupStroke.Color = currentTheme.Stroke; PopupStroke.Thickness = 1; PopupStroke.Transparency = 1
	RegisterTheme(PopupBox, "BackgroundColor3", "Background")
	RegisterTheme(PopupStroke, "Color", "Stroke")

	local PopupTitle = Instance.new("TextLabel", PopupBox)
	PopupTitle.Size = UDim2.new(1, 0, 0, 30)
	PopupTitle.Position = UDim2.new(0, 0, 0, 12)
	PopupTitle.BackgroundTransparency = 1
	PopupTitle.Text = ""
	PopupTitle.TextColor3 = currentTheme.Text
	PopupTitle.Font = Enum.Font.GothamBold
	PopupTitle.TextSize = 16
	PopupTitle.ZIndex = 102
	PopupTitle.TextTransparency = 1

	local PopupDesc = Instance.new("TextLabel", PopupBox)
	PopupDesc.Size = UDim2.new(1, -40, 0, 45)
	PopupDesc.Position = UDim2.new(0, 20, 0, 48)
	PopupDesc.BackgroundTransparency = 1
	PopupDesc.Text = ""
	PopupDesc.TextColor3 = currentTheme.TextMuted
	PopupDesc.Font = Enum.Font.GothamMedium
	PopupDesc.TextSize = 13
	PopupDesc.TextWrapped = true
	PopupDesc.ZIndex = 102
	PopupDesc.TextTransparency = 1

	local PopupBtnContainer = Instance.new("Frame", PopupBox)
	PopupBtnContainer.Size = UDim2.new(1, -40, 0, 35)
	PopupBtnContainer.Position = UDim2.new(0, 20, 1, -52)
	PopupBtnContainer.BackgroundTransparency = 1
	PopupBtnContainer.ZIndex = 102
	local PopupLayout = Instance.new("UIListLayout", PopupBtnContainer)
	PopupLayout.FillDirection = Enum.FillDirection.Horizontal
	PopupLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	PopupLayout.Padding = UDim.new(0, 15)

	local function ShowPopup(title, desc, buttonLabels, callback)
		PopupTitle.Text = title; PopupDesc.Text = desc
		for _, v in pairs(PopupBtnContainer:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end

		for _, btnText in pairs(buttonLabels) do
			local pBtn = Instance.new("TextButton", PopupBtnContainer)
			pBtn.Size = UDim2.new(0, 110, 1, 0)
			pBtn.BackgroundColor3 = currentTheme.TabSelected
			pBtn.Text = btnText
			pBtn.TextColor3 = currentTheme.Text
			pBtn.Font = Enum.Font.GothamBold
			pBtn.TextSize = 12
			pBtn.ZIndex = 102
			pBtn.BackgroundTransparency = 1
			pBtn.TextTransparency = 1
			Instance.new("UICorner", pBtn).CornerRadius = UDim.new(0, 6)
			local pbStroke = Instance.new("UIStroke", pBtn)
			pbStroke.Color = currentTheme.Stroke; pbStroke.Transparency = 1
			RegisterTheme(pBtn, "BackgroundColor3", "TabSelected")
			RegisterTheme(pbStroke, "Color", "Stroke")

			pBtn.MouseButton1Click:Connect(function()
				Tween(PopupOverlay, 0.2, {BackgroundTransparency = 1})
				Tween(PopupBox, 0.2, {BackgroundTransparency = 1, Position = UDim2.new(0.5, -150, 0.5, -55)})
				Tween(PopupTitle, 0.2, {TextTransparency = 1})
				Tween(PopupDesc, 0.2, {TextTransparency = 1})
				for _, b in pairs(PopupBtnContainer:GetChildren()) do
					if b:IsA("TextButton") then
						Tween(b, 0.2, {BackgroundTransparency = 1, TextTransparency = 1})
						if b:FindFirstChildOfClass("UIStroke") then
							Tween(b:FindFirstChildOfClass("UIStroke"), 0.2, {Transparency = 1})
						end
					end
				end
				task.wait(0.2); PopupOverlay.Visible = false
				if callback then callback(btnText) end
			end)
		end

		PopupOverlay.Visible = true
		Tween(PopupOverlay, 0.3, {BackgroundTransparency = 0.5})
		Tween(PopupBox, 0.3, {BackgroundTransparency = 0, Position = UDim2.new(0.5, -150, 0.5, -80)}, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
		PopupStroke.Transparency = 0
		Tween(PopupTitle, 0.2, {TextTransparency = 0})
		Tween(PopupDesc, 0.2, {TextTransparency = 0})
		for _, b in pairs(PopupBtnContainer:GetChildren()) do
			if b:IsA("TextButton") then
				Tween(b, 0.2, {BackgroundTransparency = 0, TextTransparency = 0})
				if b:FindFirstChildOfClass("UIStroke") then
					Tween(b:FindFirstChildOfClass("UIStroke"), 0.2, {Transparency = 0})
				end
			end
		end
	end

	--------------------------------------------------------------------
	-- PENCERE OBJESI
	--------------------------------------------------------------------
	local WindowObj = { CurrentTab = nil }

	-- TEMA DEĞİŞTİRİCİ
	function WindowObj:ChangeTheme(newColors)
		for key, color in pairs(newColors) do currentTheme[key] = color end
		for colorType, elements in pairs(ThemeRegistry) do
			if currentTheme[colorType] then
				for _, item in pairs(elements) do
					if item.Obj and item.Obj.Parent then
						Tween(item.Obj, 0.5, {[item.Prop] = currentTheme[colorType]})
					end
				end
			end
		end
	end

	-- BİLDİRİM (dışarıdan çağırılabilir)
	function WindowObj:Notify(title, message, notifType, duration)
		SendNotification(title, message, notifType, duration)
	end

	-- WATERMARK
	function WindowObj:SetWatermark(text, enabled)
		if not WatermarkFrame then
			WatermarkFrame = Instance.new("Frame", ScreenGui)
			WatermarkFrame.Size = UDim2.new(0, 200, 0, 30)
			WatermarkFrame.Position = UDim2.new(0, 10, 0, 10)
			WatermarkFrame.BackgroundColor3 = currentTheme.Background
			WatermarkFrame.ZIndex = 50
			Instance.new("UICorner", WatermarkFrame).CornerRadius = UDim.new(0, 6)
			local wStroke = Instance.new("UIStroke", WatermarkFrame)
			wStroke.Color = currentTheme.Stroke; wStroke.Thickness = 1

			WatermarkLabel = Instance.new("TextLabel", WatermarkFrame)
			WatermarkLabel.Size = UDim2.new(1, -16, 1, 0)
			WatermarkLabel.Position = UDim2.new(0, 8, 0, 0)
			WatermarkLabel.BackgroundTransparency = 1
			WatermarkLabel.TextColor3 = currentTheme.Text
			WatermarkLabel.Font = Enum.Font.GothamMedium
			WatermarkLabel.TextSize = 12
			WatermarkLabel.TextXAlignment = Enum.TextXAlignment.Left
			WatermarkLabel.ZIndex = 51
		end
		WatermarkFrame.Visible = enabled ~= false
		if WatermarkLabel then WatermarkLabel.Text = text or "" end
	end

	-- PENCERE AÇ/KAPAT
	function WindowObj:Toggle()
		windowVisible = not windowVisible
		MainFrame.Visible = windowVisible
	end

	-- Kapat Butonu
	CloseBtn.MouseButton1Click:Connect(function()
		if confirmClose then
			ShowPopup("Arayüzü Kapat", "Arayüzü tamamen kapatmak istediğinize emin misiniz?", {"Evet, Kapat", "İptal"}, function(res)
				if res == "Evet, Kapat" then ScreenGui:Destroy() end
			end)
		else
			ScreenGui:Destroy()
		end
	end)

	-- Toggle Keybind
	UserInputService.InputBegan:Connect(function(input, gpe)
		if not gpe and input.KeyCode == toggleKey then
			WindowObj:Toggle()
		end
	end)

	--------------------------------------------------------------------
	-- SÜRÜKLEME & BOYUTLANDIRMA
	--------------------------------------------------------------------
	local DragHandleArea = Instance.new("TextButton", MainFrame)
	DragHandleArea.Size = UDim2.new(0, 25, 0, 120)
	DragHandleArea.Position = UDim2.new(0, -33, 0.5, -60)
	DragHandleArea.BackgroundTransparency = 1
	DragHandleArea.Text = ""

	local DragBar = Instance.new("Frame", DragHandleArea)
	DragBar.Size = UDim2.new(0, 4, 0, 50)
	DragBar.Position = UDim2.new(0.5, -2, 0.5, -25)
	DragBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	DragBar.BorderSizePixel = 0
	Instance.new("UICorner", DragBar).CornerRadius = UDim.new(1, 0)
	DragHandleArea.MouseEnter:Connect(function() Tween(DragBar, 0.25, {BackgroundColor3 = Color3.fromRGB(255, 255, 255), Size = UDim2.new(0, 4, 0, 80), Position = UDim2.new(0.5, -2, 0.5, -40)}) end)
	DragHandleArea.MouseLeave:Connect(function() Tween(DragBar, 0.25, {BackgroundColor3 = Color3.fromRGB(60, 60, 60), Size = UDim2.new(0, 4, 0, 50), Position = UDim2.new(0.5, -2, 0.5, -25)}) end)

	local dragging, dragStart, startPos
	DragHandleArea.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true; dragStart = input.Position; startPos = MainFrame.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	-- Sağdan boyutlandırma
	local ResizeHandle = Instance.new("TextButton", MainFrame)
	ResizeHandle.Size = UDim2.new(0, 15, 1, -20)
	ResizeHandle.Position = UDim2.new(1, -10, 0, 10)
	ResizeHandle.BackgroundTransparency = 1
	ResizeHandle.Text = ""
	ResizeHandle.AutoButtonColor = false
	local ResizeVisual = Instance.new("Frame", ResizeHandle)
	ResizeVisual.Size = UDim2.new(0, 2, 0.3, 0)
	ResizeVisual.Position = UDim2.new(0.5, -1, 0.35, 0)
	ResizeVisual.BackgroundColor3 = currentTheme.Stroke
	ResizeVisual.BorderSizePixel = 0
	RegisterTheme(ResizeVisual, "BackgroundColor3", "Stroke")
	Instance.new("UICorner", ResizeVisual).CornerRadius = UDim.new(1, 0)

	ResizeHandle.MouseEnter:Connect(function() Tween(ResizeVisual, 0.2, {BackgroundColor3 = currentTheme.Accent, Size = UDim2.new(0, 3, 0.4, 0)}) end)
	ResizeHandle.MouseLeave:Connect(function() Tween(ResizeVisual, 0.2, {BackgroundColor3 = currentTheme.Stroke, Size = UDim2.new(0, 2, 0.3, 0)}) end)

	local resizing, resizeStartSize, resizeStartMousePos = false
	ResizeHandle.InputBegan:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1) and not isMaximized and not isMinimized then
			resizing = true; resizeStartMousePos = input.Position; resizeStartSize = MainFrame.Size
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - resizeStartMousePos
			MainFrame.Size = UDim2.new(0, math.clamp(resizeStartSize.X.Offset + delta.X, minWidth, maxWidth), MainFrame.Size.Y.Scale, MainFrame.Size.Y.Offset)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then resizing = false end
	end)

	-- Alt-sağ köşe boyutlandırma (yükseklik + genişlik)
	local ResizeCorner = Instance.new("TextButton", MainFrame)
	ResizeCorner.Size = UDim2.new(0, 16, 0, 16)
	ResizeCorner.Position = UDim2.new(1, -16, 1, -16)
	ResizeCorner.BackgroundTransparency = 1
	ResizeCorner.Text = "⤡"
	ResizeCorner.TextColor3 = currentTheme.TextMuted
	ResizeCorner.TextSize = 12
	ResizeCorner.Font = Enum.Font.GothamBold
	ResizeCorner.ZIndex = 10

	local cornerResizing, cornerStartMouse, cornerStartSize = false
	ResizeCorner.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 and not isMaximized then
			cornerResizing = true; cornerStartMouse = input.Position; cornerStartSize = MainFrame.Size
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if cornerResizing and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - cornerStartMouse
			MainFrame.Size = UDim2.new(0,
				math.clamp(cornerStartSize.X.Offset + delta.X, minWidth, maxWidth),
				0,
				math.clamp(cornerStartSize.Y.Offset + delta.Y, 200, 700)
			)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then cornerResizing = false end
	end)

	-- Minimize
	MinimizeBtn.MouseButton1Click:Connect(function()
		if isMaximized then return end
		isMinimized = not isMinimized
		if isMinimized then
			originalSize = MainFrame.Size
			Sidebar.Visible, VerticalDivider.Visible, ContentArea.Visible, ResizeHandle.Visible, DragHandleArea.Visible, ResizeCorner.Visible = false, false, false, false, false, false
			Tween(MainFrame, 0.3, {Size = UDim2.new(0, MainFrame.Size.X.Offset, 0, 55)})
		else
			Tween(MainFrame, 0.3, {Size = originalSize})
			task.delay(0.2, function()
				if not isMinimized then Sidebar.Visible, VerticalDivider.Visible, ContentArea.Visible, ResizeHandle.Visible, DragHandleArea.Visible, ResizeCorner.Visible = true, true, true, true, true, true end
			end)
		end
	end)

	-- Maximize
	MaximizeBtn.MouseButton1Click:Connect(function()
		if isMinimized then return end
		isMaximized = not isMaximized
		if isMaximized then
			normalSizeBeforeMaximize, normalPosBeforeMaximize = MainFrame.Size, MainFrame.Position
			ResizeHandle.Visible, DragHandleArea.Visible, ResizeCorner.Visible = false, false, false
			Tween(MainFrame, 0.3, {Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0, 0, 0, 0)})
		else
			ResizeHandle.Visible, DragHandleArea.Visible, ResizeCorner.Visible = true, true, true
			Tween(MainFrame, 0.3, {Size = normalSizeBeforeMaximize, Position = normalPosBeforeMaximize})
		end
	end)

	--------------------------------------------------------------------
	-- ELEMENT OLUŞTURUCU MİMARİSİ
	--------------------------------------------------------------------
	local function BuildElements(ParentContainer)
		local Elements = {}

		-- BOŞLUK
		function Elements:CreateSpace(height)
			local Space = Instance.new("Frame", ParentContainer)
			Space.Size = UDim2.new(1, 0, 0, height or 15)
			Space.BackgroundTransparency = 1
			return Space
		end

		-- AYRAÇ ÇİZGİSİ
		function Elements:CreateSeparator(labelText)
			local SepFrame = Instance.new("Frame", ParentContainer)
			SepFrame.Size = UDim2.new(1, 0, 0, 20)
			SepFrame.BackgroundTransparency = 1

			if labelText and labelText ~= "" then
				local LeftLine = Instance.new("Frame", SepFrame)
				LeftLine.Size = UDim2.new(0.35, 0, 0, 1)
				LeftLine.Position = UDim2.new(0, 0, 0.5, 0)
				LeftLine.BackgroundColor3 = currentTheme.Stroke
				LeftLine.BorderSizePixel = 0
				RegisterTheme(LeftLine, "BackgroundColor3", "Stroke")

				local SepLabel = Instance.new("TextLabel", SepFrame)
				SepLabel.Size = UDim2.new(0.3, 0, 1, 0)
				SepLabel.Position = UDim2.new(0.35, 0, 0, 0)
				SepLabel.BackgroundTransparency = 1
				SepLabel.Text = labelText
				SepLabel.TextColor3 = currentTheme.TextMuted
				SepLabel.Font = Enum.Font.Gotham
				SepLabel.TextSize = 10

				local RightLine = Instance.new("Frame", SepFrame)
				RightLine.Size = UDim2.new(0.35, 0, 0, 1)
				RightLine.Position = UDim2.new(0.65, 0, 0.5, 0)
				RightLine.BackgroundColor3 = currentTheme.Stroke
				RightLine.BorderSizePixel = 0
				RegisterTheme(RightLine, "BackgroundColor3", "Stroke")
			else
				local Line = Instance.new("Frame", SepFrame)
				Line.Size = UDim2.new(1, 0, 0, 1)
				Line.Position = UDim2.new(0, 0, 0.5, 0)
				Line.BackgroundColor3 = currentTheme.Stroke
				Line.BorderSizePixel = 0
				RegisterTheme(Line, "BackgroundColor3", "Stroke")
			end
		end

		-- BİLGİ ETİKETİ
		function Elements:CreateLabel(text, labelType)
			-- labelType: "default" | "info" | "success" | "warning" | "error"
			labelType = labelType or "default"
			local typeColors = {
				default = currentTheme.TextMuted,
				info    = currentTheme.Info,
				success = currentTheme.Success,
				warning = currentTheme.Warning,
				error   = currentTheme.Error,
			}
			local bgColors = {
				default = currentTheme.TabSelected,
				info    = Color3.fromRGB(15, 30, 50),
				success = Color3.fromRGB(10, 35, 20),
				warning = Color3.fromRGB(40, 30, 5),
				error   = Color3.fromRGB(40, 10, 10),
			}

			local LabelFrame = Instance.new("Frame", ParentContainer)
			LabelFrame.Size = UDim2.new(1, 0, 0, 36)
			LabelFrame.BackgroundColor3 = bgColors[labelType] or currentTheme.TabSelected
			LabelFrame.BackgroundTransparency = 0.4
			Instance.new("UICorner", LabelFrame).CornerRadius = UDim.new(0, 6)
			local lblStroke = Instance.new("UIStroke", LabelFrame)
			lblStroke.Color = typeColors[labelType] or currentTheme.Stroke
			lblStroke.Thickness = 1
			lblStroke.Transparency = 0.5

			local LabelBar = Instance.new("Frame", LabelFrame)
			LabelBar.Size = UDim2.new(0, 3, 1, 0)
			LabelBar.BackgroundColor3 = typeColors[labelType] or currentTheme.Accent
			LabelBar.BorderSizePixel = 0
			Instance.new("UICorner", LabelBar).CornerRadius = UDim.new(0, 2)

			local Lbl = Instance.new("TextLabel", LabelFrame)
			Lbl.Size = UDim2.new(1, -20, 1, 0)
			Lbl.Position = UDim2.new(0, 12, 0, 0)
			Lbl.BackgroundTransparency = 1
			Lbl.Text = text
			Lbl.TextColor3 = typeColors[labelType] or currentTheme.TextMuted
			Lbl.TextSize = 12
			Lbl.Font = Enum.Font.GothamMedium
			Lbl.TextXAlignment = Enum.TextXAlignment.Left
			Lbl.TextWrapped = true

			local LabelObj = {}
			function LabelObj:SetText(newText) Lbl.Text = newText end
			function LabelObj:SetType(newType)
				Lbl.TextColor3 = typeColors[newType] or currentTheme.TextMuted
				LabelFrame.BackgroundColor3 = bgColors[newType] or currentTheme.TabSelected
				LabelBar.BackgroundColor3 = typeColors[newType] or currentTheme.Accent
				lblStroke.Color = typeColors[newType] or currentTheme.Stroke
			end
			return LabelObj
		end

		-- İLERLEME ÇUBUĞU
		function Elements:CreateProgressBar(name, min, max, defaultValue, showPercent)
			min = min or 0; max = max or 100
			local val = math.clamp(defaultValue or 0, min, max)

			local BarFrame = Instance.new("Frame", ParentContainer)
			BarFrame.Size = UDim2.new(1, 0, 0, 50)
			BarFrame.BackgroundColor3 = currentTheme.TabSelected
			BarFrame.BackgroundTransparency = 0.6
			Instance.new("UICorner", BarFrame).CornerRadius = UDim.new(0, 6)
			local bfStroke = Instance.new("UIStroke", BarFrame)
			bfStroke.Color = currentTheme.Stroke; bfStroke.Thickness = 1
			RegisterTheme(BarFrame, "BackgroundColor3", "TabSelected")
			RegisterTheme(bfStroke, "Color", "Stroke")

			local TitleLbl = Instance.new("TextLabel", BarFrame)
			TitleLbl.Size = UDim2.new(0.7, 0, 0, 20)
			TitleLbl.Position = UDim2.new(0, 12, 0, 5)
			TitleLbl.BackgroundTransparency = 1
			TitleLbl.Text = name
			TitleLbl.TextColor3 = currentTheme.Text
			TitleLbl.TextSize = 13
			TitleLbl.Font = Enum.Font.GothamMedium
			TitleLbl.TextXAlignment = Enum.TextXAlignment.Left

			local ValueLbl = Instance.new("TextLabel", BarFrame)
			ValueLbl.Size = UDim2.new(0.3, -12, 0, 20)
			ValueLbl.Position = UDim2.new(0.7, 0, 0, 5)
			ValueLbl.BackgroundTransparency = 1
			ValueLbl.TextColor3 = currentTheme.Accent
			ValueLbl.TextSize = 12
			ValueLbl.Font = Enum.Font.GothamBold
			ValueLbl.TextXAlignment = Enum.TextXAlignment.Right
			RegisterTheme(ValueLbl, "TextColor3", "Accent")

			local function getPct() return (val - min) / (max - min) end

			if showPercent then
				ValueLbl.Text = math.floor(getPct() * 100) .. "%"
			else
				ValueLbl.Text = tostring(val) .. " / " .. tostring(max)
			end

			local Track = Instance.new("Frame", BarFrame)
			Track.Size = UDim2.new(1, -24, 0, 8)
			Track.Position = UDim2.new(0, 12, 0, 32)
			Track.BackgroundColor3 = currentTheme.Background
			Track.BorderSizePixel = 0
			Instance.new("UICorner", Track).CornerRadius = UDim.new(1, 0)
			RegisterTheme(Track, "BackgroundColor3", "Background")

			local Fill = Instance.new("Frame", Track)
			Fill.Size = UDim2.new(getPct(), 0, 1, 0)
			Fill.BackgroundColor3 = currentTheme.Accent
			Fill.BorderSizePixel = 0
			Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)
			RegisterTheme(Fill, "BackgroundColor3", "Accent")

			-- Animasyonlu parlama efekti
			local Shimmer = Instance.new("Frame", Fill)
			Shimmer.Size = UDim2.new(0, 30, 1, 0)
			Shimmer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Shimmer.BackgroundTransparency = 0.7
			Shimmer.BorderSizePixel = 0
			Instance.new("UICorner", Shimmer).CornerRadius = UDim.new(1, 0)
			Fill.ClipsDescendants = true

			local shimmerRunning = true
			task.spawn(function()
				while shimmerRunning and Fill.Parent do
					Shimmer.Position = UDim2.new(-0.5, 0, 0, 0)
					Tween(Shimmer, 1.5, {Position = UDim2.new(1.5, 0, 0, 0)})
					task.wait(2)
				end
			end)

			local BarObj = {}
			function BarObj:SetValue(newVal)
				val = math.clamp(newVal, min, max)
				local pct = getPct()
				Tween(Fill, 0.4, {Size = UDim2.new(pct, 0, 1, 0)})
				if showPercent then
					ValueLbl.Text = math.floor(pct * 100) .. "%"
				else
					ValueLbl.Text = tostring(val) .. " / " .. tostring(max)
				end
			end
			function BarObj:GetValue() return val end
			function BarObj:Destroy() shimmerRunning = false; BarFrame:Destroy() end
			return BarObj
		end

		-- TEXTBOX
		function Elements:CreateTextBox(name, placeholder, callback, clearOnSubmit)
			local BoxFrame = Instance.new("Frame", ParentContainer)
			BoxFrame.Size = UDim2.new(1, 0, 0, 52)
			BoxFrame.BackgroundColor3 = currentTheme.TabSelected
			BoxFrame.BackgroundTransparency = 0.6
			Instance.new("UICorner", BoxFrame).CornerRadius = UDim.new(0, 6)
			local bfStroke = Instance.new("UIStroke", BoxFrame)
			bfStroke.Color = currentTheme.Stroke; bfStroke.Thickness = 1
			RegisterTheme(BoxFrame, "BackgroundColor3", "TabSelected")
			RegisterTheme(bfStroke, "Color", "Stroke")

			local TitleLbl = Instance.new("TextLabel", BoxFrame)
			TitleLbl.Size = UDim2.new(1, -20, 0, 20)
			TitleLbl.Position = UDim2.new(0, 12, 0, 5)
			TitleLbl.BackgroundTransparency = 1
			TitleLbl.Text = name
			TitleLbl.TextColor3 = currentTheme.Text
			TitleLbl.TextSize = 13
			TitleLbl.Font = Enum.Font.GothamMedium
			TitleLbl.TextXAlignment = Enum.TextXAlignment.Left

			local InputBox = Instance.new("TextBox", BoxFrame)
			InputBox.Size = UDim2.new(1, -44, 0, 20)
			InputBox.Position = UDim2.new(0, 12, 0, 27)
			InputBox.BackgroundTransparency = 1
			InputBox.Text = ""
			InputBox.PlaceholderText = placeholder or "Buraya yazın..."
			InputBox.TextColor3 = currentTheme.Accent
			InputBox.PlaceholderColor3 = currentTheme.TextMuted
			InputBox.TextSize = 12
			InputBox.Font = Enum.Font.Gotham
			InputBox.TextXAlignment = Enum.TextXAlignment.Left
			InputBox.ClearTextOnFocus = false
			RegisterTheme(InputBox, "TextColor3", "Accent")

			-- Temizle butonu
			local ClearBtn = Instance.new("TextButton", BoxFrame)
			ClearBtn.Size = UDim2.new(0, 20, 0, 20)
			ClearBtn.Position = UDim2.new(1, -28, 0, 27)
			ClearBtn.BackgroundTransparency = 1
			ClearBtn.Text = "×"
			ClearBtn.TextColor3 = currentTheme.TextMuted
			ClearBtn.TextSize = 16
			ClearBtn.Font = Enum.Font.GothamBold
			ClearBtn.Visible = false

			InputBox:GetPropertyChangedSignal("Text"):Connect(function()
				ClearBtn.Visible = InputBox.Text ~= ""
			end)
			ClearBtn.MouseButton1Click:Connect(function()
				InputBox.Text = ""; ClearBtn.Visible = false
			end)

			InputBox.Focused:Connect(function() Tween(bfStroke, 0.2, {Color = currentTheme.Accent}) end)
			InputBox.FocusLost:Connect(function(enter)
				Tween(bfStroke, 0.2, {Color = currentTheme.Stroke})
				if callback then callback(InputBox.Text) end
				if clearOnSubmit and enter then InputBox.Text = "" end
			end)

			local TextBoxObj = {}
			function TextBoxObj:SetText(t) InputBox.Text = t end
			function TextBoxObj:GetText() return InputBox.Text end
			return TextBoxObj
		end

		-- SAYISAL GİRİŞ
		function Elements:CreateNumericInput(name, min, max, default, step, callback)
			min = min or 0; max = max or 100; step = step or 1
			local val = math.clamp(default or min, min, max)

			local NFrame = Instance.new("Frame", ParentContainer)
			NFrame.Size = UDim2.new(1, 0, 0, 52)
			NFrame.BackgroundColor3 = currentTheme.TabSelected
			NFrame.BackgroundTransparency = 0.6
			Instance.new("UICorner", NFrame).CornerRadius = UDim.new(0, 6)
			local nStroke = Instance.new("UIStroke", NFrame)
			nStroke.Color = currentTheme.Stroke; nStroke.Thickness = 1
			RegisterTheme(NFrame, "BackgroundColor3", "TabSelected")
			RegisterTheme(nStroke, "Color", "Stroke")

			local TitleLbl = Instance.new("TextLabel", NFrame)
			TitleLbl.Size = UDim2.new(1, -20, 0, 20)
			TitleLbl.Position = UDim2.new(0, 12, 0, 5)
			TitleLbl.BackgroundTransparency = 1
			TitleLbl.Text = name .. string.format(" [%d - %d]", min, max)
			TitleLbl.TextColor3 = currentTheme.Text
			TitleLbl.TextSize = 12
			TitleLbl.Font = Enum.Font.GothamMedium
			TitleLbl.TextXAlignment = Enum.TextXAlignment.Left

			local DecBtn = Instance.new("TextButton", NFrame)
			DecBtn.Size = UDim2.new(0, 26, 0, 20)
			DecBtn.Position = UDim2.new(0, 12, 0, 27)
			DecBtn.BackgroundColor3 = currentTheme.Background
			DecBtn.Text = "−"
			DecBtn.TextColor3 = currentTheme.Accent
			DecBtn.TextSize = 16
			DecBtn.Font = Enum.Font.GothamBold
			Instance.new("UICorner", DecBtn).CornerRadius = UDim.new(0, 4)
			RegisterTheme(DecBtn, "BackgroundColor3", "Background")
			RegisterTheme(DecBtn, "TextColor3", "Accent")

			local NumInput = Instance.new("TextBox", NFrame)
			NumInput.Size = UDim2.new(1, -90, 0, 20)
			NumInput.Position = UDim2.new(0, 44, 0, 27)
			NumInput.BackgroundTransparency = 1
			NumInput.Text = tostring(val)
			NumInput.TextColor3 = currentTheme.Accent
			NumInput.TextSize = 13
			NumInput.Font = Enum.Font.GothamBold
			NumInput.TextXAlignment = Enum.TextXAlignment.Center
			RegisterTheme(NumInput, "TextColor3", "Accent")

			local IncBtn = Instance.new("TextButton", NFrame)
			IncBtn.Size = UDim2.new(0, 26, 0, 20)
			IncBtn.Position = UDim2.new(1, -40, 0, 27)
			IncBtn.BackgroundColor3 = currentTheme.Background
			IncBtn.Text = "+"
			IncBtn.TextColor3 = currentTheme.Accent
			IncBtn.TextSize = 16
			IncBtn.Font = Enum.Font.GothamBold
			Instance.new("UICorner", IncBtn).CornerRadius = UDim.new(0, 4)
			RegisterTheme(IncBtn, "BackgroundColor3", "Background")
			RegisterTheme(IncBtn, "TextColor3", "Accent")

			local function updateVal(newVal)
				val = math.clamp(newVal, min, max)
				NumInput.Text = tostring(val)
				if callback then callback(val) end
			end

			DecBtn.MouseButton1Click:Connect(function() updateVal(val - step) end)
			IncBtn.MouseButton1Click:Connect(function() updateVal(val + step) end)
			NumInput.FocusLost:Connect(function()
				local num = tonumber(NumInput.Text)
				if num then updateVal(num) else NumInput.Text = tostring(val) end
			end)

			local NumObj = {}
			function NumObj:SetValue(v) updateVal(v) end
			function NumObj:GetValue() return val end
			return NumObj
		end

		-- SLIDER
		function Elements:CreateSlider(name, min, max, default, callback, showInput)
			local val = math.clamp(default or min, min, max)

			local SliderFrame = Instance.new("Frame", ParentContainer)
			SliderFrame.Size = UDim2.new(1, 0, 0, 55)
			SliderFrame.BackgroundColor3 = currentTheme.TabSelected
			SliderFrame.BackgroundTransparency = 0.6
			Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 6)
			local sfStroke = Instance.new("UIStroke", SliderFrame)
			sfStroke.Color = currentTheme.Stroke; sfStroke.Thickness = 1
			RegisterTheme(SliderFrame, "BackgroundColor3", "TabSelected")
			RegisterTheme(sfStroke, "Color", "Stroke")

			local TitleLbl = Instance.new("TextLabel", SliderFrame)
			TitleLbl.Size = UDim2.new(1, -60, 0, 20)
			TitleLbl.Position = UDim2.new(0, 12, 0, 5)
			TitleLbl.BackgroundTransparency = 1
			TitleLbl.Text = name
			TitleLbl.TextColor3 = currentTheme.Text
			TitleLbl.TextSize = 13
			TitleLbl.Font = Enum.Font.GothamMedium
			TitleLbl.TextXAlignment = Enum.TextXAlignment.Left

			local ValueLbl = Instance.new("TextLabel", SliderFrame)
			ValueLbl.Size = UDim2.new(0, 40, 0, 20)
			ValueLbl.Position = UDim2.new(1, -52, 0, 5)
			ValueLbl.BackgroundTransparency = 1
			ValueLbl.Text = tostring(val)
			ValueLbl.TextColor3 = currentTheme.Accent
			ValueLbl.TextSize = 13
			ValueLbl.Font = Enum.Font.GothamBold
			ValueLbl.TextXAlignment = Enum.TextXAlignment.Right
			RegisterTheme(ValueLbl, "TextColor3", "Accent")

			local Track = Instance.new("TextButton", SliderFrame)
			Track.Size = UDim2.new(1, -24, 0, 6)
			Track.Position = UDim2.new(0, 12, 0, 36)
			Track.BackgroundColor3 = currentTheme.Background
			Track.Text = ""
			Track.AutoButtonColor = false
			Instance.new("UICorner", Track).CornerRadius = UDim.new(1, 0)
			RegisterTheme(Track, "BackgroundColor3", "Background")

			local Fill = Instance.new("Frame", Track)
			Fill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
			Fill.BackgroundColor3 = currentTheme.Accent
			Fill.BorderSizePixel = 0
			Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)
			RegisterTheme(Fill, "BackgroundColor3", "Accent")

			local Grabber = Instance.new("Frame", Fill)
			Grabber.Size = UDim2.new(0, 14, 0, 14)
			Grabber.Position = UDim2.new(1, -7, 0.5, -7)
			Grabber.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Grabber.BorderSizePixel = 0
			Instance.new("UICorner", Grabber).CornerRadius = UDim.new(1, 0)
			local GrabStroke = Instance.new("UIStroke", Grabber)
			GrabStroke.Color = currentTheme.Accent; GrabStroke.Thickness = 2
			RegisterTheme(GrabStroke, "Color", "Accent")

			local sliding = false
			local function updateSlider(input)
				local percent = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
				local rawVal  = min + (max - min) * percent
				local stepped = math.floor(rawVal + 0.5)
				if stepped ~= val then
					val = math.clamp(stepped, min, max)
					ValueLbl.Text = tostring(val)
					Fill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
					if callback then callback(val) end
				end
			end

			Track.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					sliding = true; updateSlider(input)
					Tween(Grabber, 0.1, {Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(1, -9, 0.5, -9)})
				end
			end)
			UserInputService.InputChanged:Connect(function(input)
				if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
					updateSlider(input)
				end
			end)
			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					sliding = false
					Tween(Grabber, 0.1, {Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(1, -7, 0.5, -7)})
				end
			end)

			local SliderObj = {}
			function SliderObj:SetValue(newVal)
				val = math.clamp(newVal, min, max)
				ValueLbl.Text = tostring(val)
				Tween(Fill, 0.2, {Size = UDim2.new((val - min) / (max - min), 0, 1, 0)})
				if callback then callback(val) end
			end
			function SliderObj:GetValue() return val end
			return SliderObj
		end

		-- DROPDOWN (tekli seçim)
		function Elements:CreateDropdown(name, options, default, callback)
			local selected = default or options[1]

			local DropBtn = Instance.new("TextButton", ParentContainer)
			DropBtn.Size = UDim2.new(1, 0, 0, 40)
			DropBtn.BackgroundColor3 = currentTheme.TabSelected
			DropBtn.BackgroundTransparency = 0.6
			DropBtn.Text = ""
			DropBtn.AutoButtonColor = false
			Instance.new("UICorner", DropBtn).CornerRadius = UDim.new(0, 6)
			local dStroke = Instance.new("UIStroke", DropBtn)
			dStroke.Color = currentTheme.Stroke; dStroke.Thickness = 1
			RegisterTheme(DropBtn, "BackgroundColor3", "TabSelected")
			RegisterTheme(dStroke, "Color", "Stroke")

			local TitleLbl = Instance.new("TextLabel", DropBtn)
			TitleLbl.Size = UDim2.new(0.5, 0, 1, 0)
			TitleLbl.Position = UDim2.new(0, 12, 0, 0)
			TitleLbl.BackgroundTransparency = 1
			TitleLbl.Text = name
			TitleLbl.TextColor3 = currentTheme.Text
			TitleLbl.TextSize = 13
			TitleLbl.Font = Enum.Font.GothamMedium
			TitleLbl.TextXAlignment = Enum.TextXAlignment.Left

			local SelectedLbl = Instance.new("TextLabel", DropBtn)
			SelectedLbl.Size = UDim2.new(0, 110, 1, 0)
			SelectedLbl.Position = UDim2.new(1, -140, 0, 0)
			SelectedLbl.BackgroundTransparency = 1
			SelectedLbl.Text = tostring(selected)
			SelectedLbl.TextColor3 = currentTheme.Accent
			SelectedLbl.TextSize = 12
			SelectedLbl.Font = Enum.Font.Gotham
			SelectedLbl.TextXAlignment = Enum.TextXAlignment.Right
			SelectedLbl.TextTruncate = Enum.TextTruncate.AtEnd
			RegisterTheme(SelectedLbl, "TextColor3", "Accent")

			local Chevron = Instance.new("ImageLabel", DropBtn)
			Chevron.Size = UDim2.new(0, 16, 0, 16)
			Chevron.Position = UDim2.new(1, -26, 0.5, -8)
			Chevron.BackgroundTransparency = 1
			Chevron.ImageColor3 = currentTheme.TextMuted
			LoadIcon(Chevron, "chevron-down")

			local DropList = Instance.new("ScrollingFrame", ScreenGui)
			DropList.Size = UDim2.new(0, 0, 0, 0)
			DropList.BackgroundColor3 = currentTheme.Background
			DropList.BorderSizePixel = 0
			DropList.ZIndex = 200
			DropList.Visible = false
			DropList.ScrollBarThickness = 2
			DropList.ScrollBarImageColor3 = currentTheme.Accent
			Instance.new("UICorner", DropList).CornerRadius = UDim.new(0, 6)
			local listStroke = Instance.new("UIStroke", DropList)
			listStroke.Color = currentTheme.Stroke; listStroke.Thickness = 1
			RegisterTheme(DropList, "BackgroundColor3", "Background")
			RegisterTheme(listStroke, "Color", "Stroke")

			local ListLayout = Instance.new("UIListLayout", DropList)
			ListLayout.Padding = UDim.new(0, 2)
			ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			local ListPad = Instance.new("UIPadding", DropList)
			ListPad.PaddingTop = UDim.new(0, 4); ListPad.PaddingBottom = UDim.new(0, 4)
			ListPad.PaddingLeft = UDim.new(0, 4); ListPad.PaddingRight = UDim.new(0, 4)

			local isOpen = false

			local function RenderOptions()
				for _, v in pairs(DropList:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
				for _, opt in pairs(options) do
					local optBtn = Instance.new("TextButton", DropList)
					optBtn.Size = UDim2.new(1, 0, 0, 30)
					optBtn.BackgroundColor3 = currentTheme.TabSelected
					optBtn.BackgroundTransparency = 1
					optBtn.Text = tostring(opt)
					optBtn.TextColor3 = (opt == selected) and currentTheme.Accent or currentTheme.TextMuted
					optBtn.Font = Enum.Font.Gotham
					optBtn.TextSize = 12
					optBtn.ZIndex = 201
					optBtn.AutoButtonColor = false
					Instance.new("UICorner", optBtn).CornerRadius = UDim.new(0, 4)

					if opt == selected then
						local Dot = Instance.new("Frame", optBtn)
						Dot.Size = UDim2.new(0, 6, 0, 6)
						Dot.Position = UDim2.new(1, -16, 0.5, -3)
						Dot.BackgroundColor3 = currentTheme.Accent
						Dot.ZIndex = 202
						Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)
					end

					optBtn.MouseEnter:Connect(function() Tween(optBtn, 0.2, {BackgroundTransparency = 0.5}) end)
					optBtn.MouseLeave:Connect(function() Tween(optBtn, 0.2, {BackgroundTransparency = 1}) end)
					optBtn.MouseButton1Click:Connect(function()
						selected = opt; SelectedLbl.Text = tostring(opt)
						isOpen = false; DropList.Visible = false
						Tween(Chevron, 0.3, {Rotation = 0})
						if callback then callback(opt) end
					end)
				end
				DropList.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 8)
			end

			DropBtn.MouseButton1Click:Connect(function()
				isOpen = not isOpen
				Tween(Chevron, 0.3, {Rotation = isOpen and 180 or 0})
				if isOpen then
					RenderOptions()
					local absPos  = DropBtn.AbsolutePosition
					local absSize = DropBtn.AbsoluteSize
					local listHeight = math.clamp(ListLayout.AbsoluteContentSize.Y + 8, 30, 180)
					DropList.Position = UDim2.new(0, absPos.X, 0, absPos.Y + absSize.Y + 5)
					DropList.Size = UDim2.new(0, absSize.X, 0, listHeight)
					DropList.Visible = true
				else
					DropList.Visible = false
				end
			end)

			MainFrame:GetPropertyChangedSignal("Position"):Connect(function()
				if isOpen then isOpen = false; DropList.Visible = false; Tween(Chevron, 0.3, {Rotation = 0}) end
			end)

			local DropObj = {}
			function DropObj:SetOptions(newOpts) options = newOpts end
			function DropObj:SetSelected(opt) selected = opt; SelectedLbl.Text = tostring(opt) end
			function DropObj:GetSelected() return selected end
			return DropObj
		end

		-- ÇOKLU DROPDOWN
		function Elements:CreateMultiDropdown(name, options, defaults, callback)
			local selected = {}
			if defaults then for _, v in pairs(defaults) do selected[v] = true end end

			local function getSelectedText()
				local sel = {}
				for _, opt in pairs(options) do if selected[opt] then table.insert(sel, opt) end end
				if #sel == 0 then return "Seçilmedi"
				elseif #sel == 1 then return sel[1]
				else return sel[1] .. " +" .. (#sel - 1) end
			end

			local DropBtn = Instance.new("TextButton", ParentContainer)
			DropBtn.Size = UDim2.new(1, 0, 0, 40)
			DropBtn.BackgroundColor3 = currentTheme.TabSelected
			DropBtn.BackgroundTransparency = 0.6
			DropBtn.Text = ""
			DropBtn.AutoButtonColor = false
			Instance.new("UICorner", DropBtn).CornerRadius = UDim.new(0, 6)
			local dStroke = Instance.new("UIStroke", DropBtn)
			dStroke.Color = currentTheme.Stroke; dStroke.Thickness = 1
			RegisterTheme(DropBtn, "BackgroundColor3", "TabSelected")
			RegisterTheme(dStroke, "Color", "Stroke")

			local TitleLbl = Instance.new("TextLabel", DropBtn)
			TitleLbl.Size = UDim2.new(0.5, 0, 1, 0)
			TitleLbl.Position = UDim2.new(0, 12, 0, 0)
			TitleLbl.BackgroundTransparency = 1
			TitleLbl.Text = name
			TitleLbl.TextColor3 = currentTheme.Text
			TitleLbl.TextSize = 13
			TitleLbl.Font = Enum.Font.GothamMedium
			TitleLbl.TextXAlignment = Enum.TextXAlignment.Left

			local SelectedLbl = Instance.new("TextLabel", DropBtn)
			SelectedLbl.Size = UDim2.new(0, 110, 1, 0)
			SelectedLbl.Position = UDim2.new(1, -140, 0, 0)
			SelectedLbl.BackgroundTransparency = 1
			SelectedLbl.Text = getSelectedText()
			SelectedLbl.TextColor3 = currentTheme.Accent
			SelectedLbl.TextSize = 11
			SelectedLbl.Font = Enum.Font.Gotham
			SelectedLbl.TextXAlignment = Enum.TextXAlignment.Right
			SelectedLbl.TextTruncate = Enum.TextTruncate.AtEnd
			RegisterTheme(SelectedLbl, "TextColor3", "Accent")

			local Chevron = Instance.new("ImageLabel", DropBtn)
			Chevron.Size = UDim2.new(0, 16, 0, 16)
			Chevron.Position = UDim2.new(1, -26, 0.5, -8)
			Chevron.BackgroundTransparency = 1
			Chevron.ImageColor3 = currentTheme.TextMuted
			LoadIcon(Chevron, "chevron-down")

			local DropList = Instance.new("ScrollingFrame", ScreenGui)
			DropList.BackgroundColor3 = currentTheme.Background
			DropList.BorderSizePixel = 0
			DropList.ZIndex = 200
			DropList.Visible = false
			DropList.ScrollBarThickness = 2
			DropList.ScrollBarImageColor3 = currentTheme.Accent
			Instance.new("UICorner", DropList).CornerRadius = UDim.new(0, 6)
			local listStroke2 = Instance.new("UIStroke", DropList)
			listStroke2.Color = currentTheme.Stroke; listStroke2.Thickness = 1
			RegisterTheme(DropList, "BackgroundColor3", "Background")
			RegisterTheme(listStroke2, "Color", "Stroke")

			local ListLayout = Instance.new("UIListLayout", DropList)
			ListLayout.Padding = UDim.new(0, 2)
			ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			local ListPad2 = Instance.new("UIPadding", DropList)
			ListPad2.PaddingTop = UDim.new(0, 4); ListPad2.PaddingBottom = UDim.new(0, 4)
			ListPad2.PaddingLeft = UDim.new(0, 4); ListPad2.PaddingRight = UDim.new(0, 4)

			local isOpen = false

			local function getSelectedList()
				local sel = {}
				for _, opt in pairs(options) do if selected[opt] then table.insert(sel, opt) end end
				return sel
			end

			local function RenderOptions()
				for _, v in pairs(DropList:GetChildren()) do if v:IsA("TextButton") or v:IsA("Frame") then v:Destroy() end end
				for _, opt in pairs(options) do
					local optBtn = Instance.new("TextButton", DropList)
					optBtn.Size = UDim2.new(1, 0, 0, 30)
					optBtn.BackgroundColor3 = currentTheme.TabSelected
					optBtn.BackgroundTransparency = selected[opt] and 0.3 or 1
					optBtn.Text = ""
					optBtn.ZIndex = 201
					optBtn.AutoButtonColor = false
					Instance.new("UICorner", optBtn).CornerRadius = UDim.new(0, 4)

					local checkBox = Instance.new("Frame", optBtn)
					checkBox.Size = UDim2.new(0, 14, 0, 14)
					checkBox.Position = UDim2.new(0, 8, 0.5, -7)
					checkBox.BackgroundColor3 = selected[opt] and currentTheme.Accent or Color3.fromRGB(40, 40, 40)
					checkBox.BorderSizePixel = 0
					checkBox.ZIndex = 202
					Instance.new("UICorner", checkBox).CornerRadius = UDim.new(0, 3)
					local cbStroke = Instance.new("UIStroke", checkBox)
					cbStroke.Color = selected[opt] and currentTheme.Accent or currentTheme.Stroke
					cbStroke.Thickness = 1

					local checkMark = Instance.new("TextLabel", checkBox)
					checkMark.Size = UDim2.new(1, 0, 1, 0)
					checkMark.BackgroundTransparency = 1
					checkMark.Text = "✓"
					checkMark.TextColor3 = Color3.fromRGB(255, 255, 255)
					checkMark.TextSize = 10
					checkMark.Font = Enum.Font.GothamBold
					checkMark.ZIndex = 203
					checkMark.Visible = selected[opt]

					local optLbl = Instance.new("TextLabel", optBtn)
					optLbl.Size = UDim2.new(1, -34, 1, 0)
					optLbl.Position = UDim2.new(0, 30, 0, 0)
					optLbl.BackgroundTransparency = 1
					optLbl.Text = tostring(opt)
					optLbl.TextColor3 = selected[opt] and currentTheme.Accent or currentTheme.TextMuted
					optLbl.Font = Enum.Font.Gotham
					optLbl.TextSize = 12
					optLbl.ZIndex = 202
					optLbl.TextXAlignment = Enum.TextXAlignment.Left

					optBtn.MouseEnter:Connect(function() Tween(optBtn, 0.2, {BackgroundTransparency = selected[opt] and 0.15 or 0.6}) end)
					optBtn.MouseLeave:Connect(function() Tween(optBtn, 0.2, {BackgroundTransparency = selected[opt] and 0.3 or 1}) end)
					optBtn.MouseButton1Click:Connect(function()
						selected[opt] = not selected[opt]
						optBtn.BackgroundTransparency = selected[opt] and 0.3 or 1
						checkBox.BackgroundColor3 = selected[opt] and currentTheme.Accent or Color3.fromRGB(40, 40, 40)
						cbStroke.Color = selected[opt] and currentTheme.Accent or currentTheme.Stroke
						checkMark.Visible = selected[opt]
						optLbl.TextColor3 = selected[opt] and currentTheme.Accent or currentTheme.TextMuted
						SelectedLbl.Text = getSelectedText()
						if callback then callback(getSelectedList()) end
					end)
				end
				DropList.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 8)
			end

			DropBtn.MouseButton1Click:Connect(function()
				isOpen = not isOpen
				Tween(Chevron, 0.3, {Rotation = isOpen and 180 or 0})
				if isOpen then
					RenderOptions()
					local absPos  = DropBtn.AbsolutePosition
					local absSize = DropBtn.AbsoluteSize
					local listH = math.clamp(#options * 34 + 8, 30, 200)
					DropList.Position = UDim2.new(0, absPos.X, 0, absPos.Y + absSize.Y + 5)
					DropList.Size = UDim2.new(0, absSize.X, 0, listH)
					DropList.Visible = true
				else
					DropList.Visible = false
				end
			end)

			local MDropObj = {}
			function MDropObj:GetSelected() return getSelectedList() end
			function MDropObj:SetSelected(list)
				selected = {}
				for _, v in pairs(list) do selected[v] = true end
				SelectedLbl.Text = getSelectedText()
			end
			return MDropObj
		end

		-- BUTON
		function Elements:CreateButton(btnName, btnDescription, iconName, callback)
			local hasDesc = (btnDescription ~= nil and btnDescription ~= "")
			local hasIcon = (iconName ~= nil and iconName ~= "")
			local rowHeight = hasDesc and 48 or 36

			local ButtonFrame = Instance.new("TextButton", ParentContainer)
			ButtonFrame.Size = UDim2.new(1, 0, 0, rowHeight)
			ButtonFrame.BackgroundColor3 = currentTheme.TabSelected
			ButtonFrame.BackgroundTransparency = 0.6
			ButtonFrame.Text = ""
			ButtonFrame.AutoButtonColor = false
			Instance.new("UICorner", ButtonFrame).CornerRadius = UDim.new(0, 6)
			local btnStroke = Instance.new("UIStroke", ButtonFrame)
			btnStroke.Color = currentTheme.Stroke; btnStroke.Thickness = 1
			RegisterTheme(ButtonFrame, "BackgroundColor3", "TabSelected")
			RegisterTheme(btnStroke, "Color", "Stroke")

			local contentOffsetX = hasIcon and 38 or 12
			if hasIcon then
				local BtnIcon = Instance.new("ImageLabel", ButtonFrame)
				BtnIcon.Size = UDim2.new(0, 18, 0, 18)
				BtnIcon.Position = UDim2.new(0, 10, 0.5, -9)
				BtnIcon.ImageColor3 = currentTheme.Text
				LoadIcon(BtnIcon, iconName)
			end

			local PointerIcon = Instance.new("ImageLabel", ButtonFrame)
			PointerIcon.Size = UDim2.new(0, 16, 0, 16)
			PointerIcon.Position = UDim2.new(1, -26, 0.5, -8)
			PointerIcon.ImageColor3 = currentTheme.TextMuted
			LoadIcon(PointerIcon, "play")

			local TextContainer = Instance.new("Frame", ButtonFrame)
			TextContainer.Size = UDim2.new(1, -contentOffsetX - 35, 1, 0)
			TextContainer.Position = UDim2.new(0, contentOffsetX, 0, 0)
			TextContainer.BackgroundTransparency = 1

			local TitleLbl = Instance.new("TextLabel", TextContainer)
			TitleLbl.Size = UDim2.new(1, 0, 0, hasDesc and 22 or rowHeight)
			TitleLbl.Position = UDim2.new(0, 0, 0, hasDesc and 5 or 0)
			TitleLbl.BackgroundTransparency = 1
			TitleLbl.Text = btnName
			TitleLbl.TextColor3 = currentTheme.Text
			TitleLbl.TextSize = 13
			TitleLbl.Font = Enum.Font.GothamMedium
			TitleLbl.TextXAlignment = Enum.TextXAlignment.Left

			if hasDesc then
				local DescLbl = Instance.new("TextLabel", TextContainer)
				DescLbl.Size = UDim2.new(1, 0, 0, 16)
				DescLbl.Position = UDim2.new(0, 0, 0, 24)
				DescLbl.BackgroundTransparency = 1
				DescLbl.Text = btnDescription
				DescLbl.TextColor3 = currentTheme.TextMuted
				DescLbl.TextSize = 10
				DescLbl.Font = Enum.Font.Gotham
				DescLbl.TextXAlignment = Enum.TextXAlignment.Left
			end

			ButtonFrame.MouseEnter:Connect(function()
				Tween(btnStroke, 0.2, {Color = currentTheme.Accent})
				Tween(PointerIcon, 0.2, {ImageColor3 = currentTheme.Accent, Position = UDim2.new(1, -22, 0.5, -8)})
			end)
			ButtonFrame.MouseLeave:Connect(function()
				Tween(btnStroke, 0.2, {Color = currentTheme.Stroke})
				Tween(PointerIcon, 0.2, {ImageColor3 = currentTheme.TextMuted, Position = UDim2.new(1, -26, 0.5, -8)})
			end)
			ButtonFrame.MouseButton1Click:Connect(function()
				ButtonFrame.BackgroundColor3 = currentTheme.Accent
				Tween(ButtonFrame, 0.35, {BackgroundColor3 = currentTheme.TabSelected})
				if callback then callback() end
			end)
		end

		-- TOGGLE
		function Elements:CreateToggle(toggleName, toggleDescription, iconName, defaultState, useCircleStyle, callback)
			local toggleActive = defaultState or false
			local hasDesc = (toggleDescription ~= nil and toggleDescription ~= "")
			local hasIcon = (iconName ~= nil and iconName ~= "")
			local rowHeight = hasDesc and 48 or 36

			local ToggleFrame = Instance.new("TextButton", ParentContainer)
			ToggleFrame.Size = UDim2.new(1, 0, 0, rowHeight)
			ToggleFrame.BackgroundColor3 = currentTheme.TabSelected
			ToggleFrame.BackgroundTransparency = 0.6
			ToggleFrame.Text = ""
			ToggleFrame.AutoButtonColor = false
			Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 6)
			local tfStroke = Instance.new("UIStroke", ToggleFrame)
			tfStroke.Color = currentTheme.Stroke; tfStroke.Thickness = 1
			RegisterTheme(ToggleFrame, "BackgroundColor3", "TabSelected")
			RegisterTheme(tfStroke, "Color", "Stroke")

			local contentOffsetX = hasIcon and 38 or 12
			if hasIcon then
				local TglIcon = Instance.new("ImageLabel", ToggleFrame)
				TglIcon.Size = UDim2.new(0, 18, 0, 18)
				TglIcon.Position = UDim2.new(0, 10, 0.5, -9)
				TglIcon.ImageColor3 = currentTheme.Text
				LoadIcon(TglIcon, iconName)
			end

			local TextContainer = Instance.new("Frame", ToggleFrame)
			TextContainer.Size = UDim2.new(1, -contentOffsetX - 60, 1, 0)
			TextContainer.Position = UDim2.new(0, contentOffsetX, 0, 0)
			TextContainer.BackgroundTransparency = 1

			local TitleLbl = Instance.new("TextLabel", TextContainer)
			TitleLbl.Size = UDim2.new(1, 0, 0, hasDesc and 22 or rowHeight)
			TitleLbl.Position = UDim2.new(0, 0, 0, hasDesc and 5 or 0)
			TitleLbl.BackgroundTransparency = 1
			TitleLbl.Text = toggleName
			TitleLbl.TextColor3 = currentTheme.Text
			TitleLbl.TextSize = 13
			TitleLbl.Font = Enum.Font.GothamMedium
			TitleLbl.TextXAlignment = Enum.TextXAlignment.Left

			if hasDesc then
				local DescLbl = Instance.new("TextLabel", TextContainer)
				DescLbl.Size = UDim2.new(1, 0, 0, 16)
				DescLbl.Position = UDim2.new(0, 0, 0, 24)
				DescLbl.BackgroundTransparency = 1
				DescLbl.Text = toggleDescription
				DescLbl.TextColor3 = currentTheme.TextMuted
				DescLbl.TextSize = 10
				DescLbl.Font = Enum.Font.Gotham
				DescLbl.TextXAlignment = Enum.TextXAlignment.Left
			end

			local IndicatorContainer = Instance.new("Frame", ToggleFrame)
			IndicatorContainer.BackgroundTransparency = 1
			Instance.new("UICorner", IndicatorContainer).CornerRadius = UDim.new(1, 0)
			local IndicatorStroke = Instance.new("UIStroke", IndicatorContainer)
			local MovingPart = Instance.new("Frame", IndicatorContainer)
			MovingPart.BorderSizePixel = 0
			Instance.new("UICorner", MovingPart).CornerRadius = UDim.new(1, 0)

			local ToggleObj = {}

			if useCircleStyle then
				IndicatorContainer.Size = UDim2.new(0, 22, 0, 22)
				IndicatorContainer.Position = UDim2.new(1, -34, 0.5, -11)
				IndicatorStroke.Thickness = 1.5
				MovingPart.BackgroundColor3 = currentTheme.Text

				local function updateVisuals(animate)
					local dur = animate and 0.2 or 0
					if toggleActive then
						Tween(IndicatorContainer, dur, {BackgroundColor3 = currentTheme.Accent})
						Tween(IndicatorStroke, dur, {Color = currentTheme.Accent})
						Tween(MovingPart, dur, {Size = UDim2.new(0, 10, 0, 10), Position = UDim2.new(0.5, -5, 0.5, -5)})
					else
						Tween(IndicatorContainer, dur, {BackgroundColor3 = Color3.fromRGB(0, 0, 0)})
						Tween(IndicatorStroke, dur, {Color = currentTheme.Stroke})
						Tween(MovingPart, dur, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)})
					end
				end
				updateVisuals(false)
				ToggleFrame.MouseButton1Click:Connect(function()
					toggleActive = not toggleActive; updateVisuals(true)
					if callback then callback(toggleActive) end
				end)
			else
				IndicatorContainer.Size = UDim2.new(0, 42, 0, 22)
				IndicatorContainer.Position = UDim2.new(1, -54, 0.5, -11)
				IndicatorStroke.Thickness = 1
				MovingPart.Size = UDim2.new(0, 16, 0, 16)
				MovingPart.BackgroundColor3 = currentTheme.Text

				local function updateVisuals(animate)
					local dur = animate and 0.2 or 0
					if toggleActive then
						Tween(IndicatorContainer, dur, {BackgroundColor3 = currentTheme.Accent})
						Tween(IndicatorStroke, dur, {Color = currentTheme.Accent})
						Tween(MovingPart, dur, {Position = UDim2.new(1, -19, 0.5, -8)})
					else
						Tween(IndicatorContainer, dur, {BackgroundColor3 = Color3.fromRGB(24, 24, 24)})
						Tween(IndicatorStroke, dur, {Color = currentTheme.Stroke})
						Tween(MovingPart, dur, {Position = UDim2.new(0, 3, 0.5, -8)})
					end
				end
				updateVisuals(false)
				ToggleFrame.MouseButton1Click:Connect(function()
					toggleActive = not toggleActive; updateVisuals(true)
					if callback then callback(toggleActive) end
				end)
			end

			ToggleFrame.MouseEnter:Connect(function() Tween(tfStroke, 0.2, {Color = currentTheme.TextMuted}) end)
			ToggleFrame.MouseLeave:Connect(function() Tween(tfStroke, 0.2, {Color = currentTheme.Stroke}) end)

			function ToggleObj:SetState(state)
				toggleActive = state
				-- rebuild visuals would be needed; simplified here
			end
			function ToggleObj:GetState() return toggleActive end
			return ToggleObj
		end

		-- KEYBİND
		function Elements:CreateKeybind(name, description, defaultKey, callback)
			local currentKey = defaultKey or Enum.KeyCode.Unknown
			local listening = false

			local KFrame = Instance.new("TextButton", ParentContainer)
			KFrame.Size = UDim2.new(1, 0, 0, description ~= "" and 48 or 36)
			KFrame.BackgroundColor3 = currentTheme.TabSelected
			KFrame.BackgroundTransparency = 0.6
			KFrame.Text = ""
			KFrame.AutoButtonColor = false
			Instance.new("UICorner", KFrame).CornerRadius = UDim.new(0, 6)
			local kStroke = Instance.new("UIStroke", KFrame)
			kStroke.Color = currentTheme.Stroke; kStroke.Thickness = 1
			RegisterTheme(KFrame, "BackgroundColor3", "TabSelected")
			RegisterTheme(kStroke, "Color", "Stroke")

			local KIcon = Instance.new("ImageLabel", KFrame)
			KIcon.Size = UDim2.new(0, 18, 0, 18)
			KIcon.Position = UDim2.new(0, 10, 0.5, -9)
			KIcon.BackgroundTransparency = 1
			KIcon.ImageColor3 = currentTheme.TextMuted
			LoadIcon(KIcon, "keyboard")

			local TitleLbl = Instance.new("TextLabel", KFrame)
			TitleLbl.Size = UDim2.new(1, -130, 0, description ~= "" and 22 or 36)
			TitleLbl.Position = UDim2.new(0, 34, 0, description ~= "" and 5 or 0)
			TitleLbl.BackgroundTransparency = 1
			TitleLbl.Text = name
			TitleLbl.TextColor3 = currentTheme.Text
			TitleLbl.TextSize = 13
			TitleLbl.Font = Enum.Font.GothamMedium
			TitleLbl.TextXAlignment = Enum.TextXAlignment.Left

			if description and description ~= "" then
				local DescLbl = Instance.new("TextLabel", KFrame)
				DescLbl.Size = UDim2.new(1, -130, 0, 16)
				DescLbl.Position = UDim2.new(0, 34, 0, 26)
				DescLbl.BackgroundTransparency = 1
				DescLbl.Text = description
				DescLbl.TextColor3 = currentTheme.TextMuted
				DescLbl.TextSize = 10
				DescLbl.Font = Enum.Font.Gotham
				DescLbl.TextXAlignment = Enum.TextXAlignment.Left
			end

			local KeyBadge = Instance.new("TextButton", KFrame)
			KeyBadge.Size = UDim2.new(0, 80, 0, 24)
			KeyBadge.Position = UDim2.new(1, -92, 0.5, -12)
			KeyBadge.BackgroundColor3 = currentTheme.Background
			KeyBadge.Text = currentKey ~= Enum.KeyCode.Unknown and currentKey.Name or "Ayarla"
			KeyBadge.TextColor3 = currentTheme.Accent
			KeyBadge.TextSize = 11
			KeyBadge.Font = Enum.Font.GothamBold
			KeyBadge.AutoButtonColor = false
			Instance.new("UICorner", KeyBadge).CornerRadius = UDim.new(0, 4)
			local kbStroke = Instance.new("UIStroke", KeyBadge)
			kbStroke.Color = currentTheme.Accent; kbStroke.Thickness = 1
			RegisterTheme(KeyBadge, "BackgroundColor3", "Background")
			RegisterTheme(KeyBadge, "TextColor3", "Accent")
			RegisterTheme(kbStroke, "Color", "Accent")

			KeyBadge.MouseButton1Click:Connect(function()
				if listening then return end
				listening = true
				KeyBadge.Text = "..."
				KeyBadge.TextColor3 = Color3.fromRGB(241, 196, 15)
				kbStroke.Color = Color3.fromRGB(241, 196, 15)
				Tween(kStroke, 0.2, {Color = Color3.fromRGB(241, 196, 15)})
			end)

			UserInputService.InputBegan:Connect(function(input, gpe)
				if not listening then return end
				if input.UserInputType == Enum.UserInputType.Keyboard then
					if input.KeyCode == Enum.KeyCode.Escape then
						listening = false
						KeyBadge.Text = currentKey ~= Enum.KeyCode.Unknown and currentKey.Name or "Ayarla"
						KeyBadge.TextColor3 = currentTheme.Accent
						kbStroke.Color = currentTheme.Accent
						Tween(kStroke, 0.2, {Color = currentTheme.Stroke})
						return
					end
					listening = false
					currentKey = input.KeyCode
					KeyBadge.Text = currentKey.Name
					KeyBadge.TextColor3 = currentTheme.Accent
					kbStroke.Color = currentTheme.Accent
					Tween(kStroke, 0.2, {Color = currentTheme.Stroke})
					if callback then callback(currentKey) end
				end
			end)

			-- Aktif tuş dinleyici
			UserInputService.InputBegan:Connect(function(input, gpe)
				if not gpe and not listening and input.UserInputType == Enum.UserInputType.Keyboard then
					if input.KeyCode == currentKey and currentKey ~= Enum.KeyCode.Unknown then
						if callback then callback(currentKey, "pressed") end
					end
				end
			end)

			local KeyObj = {}
			function KeyObj:SetKey(key) currentKey = key; KeyBadge.Text = key.Name end
			function KeyObj:GetKey() return currentKey end
			return KeyObj
		end

		-- RENK SEÇİCİ (ColorPicker)
		function Elements:CreateColorPicker(name, defaultColor, callback)
			local currentColor = defaultColor or Color3.fromRGB(255, 0, 0)
			local h, s, v = RGBtoHSV(currentColor)
			local pickerOpen = false

			local PickerFrame = Instance.new("TextButton", ParentContainer)
			PickerFrame.Size = UDim2.new(1, 0, 0, 40)
			PickerFrame.BackgroundColor3 = currentTheme.TabSelected
			PickerFrame.BackgroundTransparency = 0.6
			PickerFrame.Text = ""
			PickerFrame.AutoButtonColor = false
			Instance.new("UICorner", PickerFrame).CornerRadius = UDim.new(0, 6)
			local pStroke = Instance.new("UIStroke", PickerFrame)
			pStroke.Color = currentTheme.Stroke; pStroke.Thickness = 1
			RegisterTheme(PickerFrame, "BackgroundColor3", "TabSelected")
			RegisterTheme(pStroke, "Color", "Stroke")

			local PIcon = Instance.new("ImageLabel", PickerFrame)
			PIcon.Size = UDim2.new(0, 18, 0, 18)
			PIcon.Position = UDim2.new(0, 10, 0.5, -9)
			PIcon.BackgroundTransparency = 1
			PIcon.ImageColor3 = currentTheme.TextMuted
			LoadIcon(PIcon, "palette")

			local TitleLbl = Instance.new("TextLabel", PickerFrame)
			TitleLbl.Size = UDim2.new(1, -120, 1, 0)
			TitleLbl.Position = UDim2.new(0, 34, 0, 0)
			TitleLbl.BackgroundTransparency = 1
			TitleLbl.Text = name
			TitleLbl.TextColor3 = currentTheme.Text
			TitleLbl.TextSize = 13
			TitleLbl.Font = Enum.Font.GothamMedium
			TitleLbl.TextXAlignment = Enum.TextXAlignment.Left

			local ColorPreview = Instance.new("Frame", PickerFrame)
			ColorPreview.Size = UDim2.new(0, 60, 0, 22)
			ColorPreview.Position = UDim2.new(1, -80, 0.5, -11)
			ColorPreview.BackgroundColor3 = currentColor
			ColorPreview.BorderSizePixel = 0
			Instance.new("UICorner", ColorPreview).CornerRadius = UDim.new(0, 4)
			local cpStroke = Instance.new("UIStroke", ColorPreview)
			cpStroke.Color = currentTheme.Stroke; cpStroke.Thickness = 1

			local HexLabel = Instance.new("TextLabel", PickerFrame)
			HexLabel.Size = UDim2.new(0, 68, 0, 14)
			HexLabel.Position = UDim2.new(1, -76, 1, -18)
			HexLabel.BackgroundTransparency = 1
			HexLabel.Text = ColorToHex(currentColor)
			HexLabel.TextColor3 = currentTheme.TextMuted
			HexLabel.TextSize = 9
			HexLabel.Font = Enum.Font.Gotham

			-- Picker Popup
			local PickerPopup = Instance.new("Frame", ScreenGui)
			PickerPopup.Size = UDim2.new(0, 240, 0, 260)
			PickerPopup.BackgroundColor3 = currentTheme.Background
			PickerPopup.ZIndex = 300
			PickerPopup.Visible = false
			PickerPopup.BorderSizePixel = 0
			Instance.new("UICorner", PickerPopup).CornerRadius = UDim.new(0, 8)
			local ppStroke = Instance.new("UIStroke", PickerPopup)
			ppStroke.Color = currentTheme.Stroke; ppStroke.Thickness = 1
			RegisterTheme(PickerPopup, "BackgroundColor3", "Background")
			RegisterTheme(ppStroke, "Color", "Stroke")

			-- SV Alan (Saturation/Value gradyan)
			local SVArea = Instance.new("ImageButton", PickerPopup)
			SVArea.Size = UDim2.new(1, -20, 0, 150)
			SVArea.Position = UDim2.new(0, 10, 0, 10)
			SVArea.Image = "rbxassetid://0"
			SVArea.BackgroundColor3 = HSVtoRGB(h, 1, 1)
			SVArea.BorderSizePixel = 0
			SVArea.ZIndex = 301
			Instance.new("UICorner", SVArea).CornerRadius = UDim.new(0, 4)

			-- Beyaz soldan sağa gradient
			local WhiteGrad = Instance.new("UIGradient", SVArea)
			WhiteGrad.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
			})
			WhiteGrad.Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0),
				NumberSequenceKeypoint.new(1, 1)
			})
			-- Siyah üstten alta overlay
			local BlackOverlay = Instance.new("Frame", SVArea)
			BlackOverlay.Size = UDim2.new(1, 0, 1, 0)
			BlackOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			BlackOverlay.BackgroundTransparency = 1
			BlackOverlay.BorderSizePixel = 0
			BlackOverlay.ZIndex = 302
			Instance.new("UICorner", BlackOverlay).CornerRadius = UDim.new(0, 4)
			local BlackGrad = Instance.new("UIGradient", BlackOverlay)
			BlackGrad.Rotation = 90
			BlackGrad.Color = ColorSequence.new(Color3.fromRGB(0, 0, 0))
			BlackGrad.Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0),
				NumberSequenceKeypoint.new(1, 1)
			})

			-- SV İmleci
			local SVCursor = Instance.new("Frame", SVArea)
			SVCursor.Size = UDim2.new(0, 12, 0, 12)
			SVCursor.AnchorPoint = Vector2.new(0.5, 0.5)
			SVCursor.Position = UDim2.new(s, 0, 1 - v, 0)
			SVCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SVCursor.BorderSizePixel = 0
			SVCursor.ZIndex = 304
			Instance.new("UICorner", SVCursor).CornerRadius = UDim.new(1, 0)
			local svCStroke = Instance.new("UIStroke", SVCursor)
			svCStroke.Color = Color3.fromRGB(0, 0, 0); svCStroke.Thickness = 1.5

			-- Hue Bar
			local HueBar = Instance.new("ImageButton", PickerPopup)
			HueBar.Size = UDim2.new(1, -20, 0, 16)
			HueBar.Position = UDim2.new(0, 10, 0, 168)
			HueBar.BorderSizePixel = 0
			HueBar.ZIndex = 301
			HueBar.Image = "rbxassetid://0"
			HueBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Instance.new("UICorner", HueBar).CornerRadius = UDim.new(0, 4)
			local HueGrad = Instance.new("UIGradient", HueBar)
			HueGrad.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0,    Color3.fromRGB(255, 0,   0  )),
				ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0  )),
				ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0,   255, 0  )),
				ColorSequenceKeypoint.new(0.5,  Color3.fromRGB(0,   255, 255)),
				ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0,   0,   255)),
				ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0,   255)),
				ColorSequenceKeypoint.new(1,    Color3.fromRGB(255, 0,   0  )),
			})

			local HueCursor = Instance.new("Frame", HueBar)
			HueCursor.Size = UDim2.new(0, 6, 1, 4)
			HueCursor.AnchorPoint = Vector2.new(0.5, 0.5)
			HueCursor.Position = UDim2.new(h, 0, 0.5, 0)
			HueCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			HueCursor.BorderSizePixel = 0
			HueCursor.ZIndex = 302
			Instance.new("UICorner", HueCursor).CornerRadius = UDim.new(0, 2)
			local hcStroke = Instance.new("UIStroke", HueCursor)
			hcStroke.Color = Color3.fromRGB(0, 0, 0); hcStroke.Thickness = 1

			-- Hex giriş
			local HexFrame = Instance.new("Frame", PickerPopup)
			HexFrame.Size = UDim2.new(1, -20, 0, 28)
			HexFrame.Position = UDim2.new(0, 10, 0, 194)
			HexFrame.BackgroundColor3 = currentTheme.TabSelected
			HexFrame.BorderSizePixel = 0
			HexFrame.ZIndex = 301
			Instance.new("UICorner", HexFrame).CornerRadius = UDim.new(0, 4)
			RegisterTheme(HexFrame, "BackgroundColor3", "TabSelected")
			local HexLblPre = Instance.new("TextLabel", HexFrame)
			HexLblPre.Size = UDim2.new(0, 20, 1, 0)
			HexLblPre.BackgroundTransparency = 1
			HexLblPre.Text = "#"
			HexLblPre.TextColor3 = currentTheme.TextMuted
			HexLblPre.TextSize = 12
			HexLblPre.Font = Enum.Font.GothamBold
			HexLblPre.ZIndex = 302
			local HexInput = Instance.new("TextBox", HexFrame)
			HexInput.Size = UDim2.new(1, -24, 1, 0)
			HexInput.Position = UDim2.new(0, 20, 0, 0)
			HexInput.BackgroundTransparency = 1
			HexInput.Text = ColorToHex(currentColor):sub(2)
			HexInput.TextColor3 = currentTheme.Accent
			HexInput.PlaceholderColor3 = currentTheme.TextMuted
			HexInput.TextSize = 12
			HexInput.Font = Enum.Font.GothamMedium
			HexInput.ZIndex = 302
			HexInput.ClearTextOnFocus = false
			RegisterTheme(HexInput, "TextColor3", "Accent")

			-- Renk kutuları (son kullanılan)
			local ColorRowFrame = Instance.new("Frame", PickerPopup)
			ColorRowFrame.Size = UDim2.new(1, -20, 0, 20)
			ColorRowFrame.Position = UDim2.new(0, 10, 0, 230)
			ColorRowFrame.BackgroundTransparency = 1
			ColorRowFrame.ZIndex = 301
			local CRLayout = Instance.new("UIListLayout", ColorRowFrame)
			CRLayout.FillDirection = Enum.FillDirection.Horizontal
			CRLayout.Padding = UDim.new(0, 4)

			local presetColors = {
				Color3.fromRGB(231, 76, 60),
				Color3.fromRGB(241, 196, 15),
				Color3.fromRGB(46, 204, 113),
				Color3.fromRGB(52, 152, 219),
				Color3.fromRGB(155, 89, 182),
				Color3.fromRGB(230, 126, 34),
				Color3.fromRGB(255, 255, 255),
				Color3.fromRGB(127, 140, 141),
			}
			for _, pc in pairs(presetColors) do
				local PCBtn = Instance.new("TextButton", ColorRowFrame)
				PCBtn.Size = UDim2.new(0, 20, 0, 20)
				PCBtn.BackgroundColor3 = pc
				PCBtn.Text = ""
				PCBtn.ZIndex = 302
				Instance.new("UICorner", PCBtn).CornerRadius = UDim.new(0, 4)
				PCBtn.MouseButton1Click:Connect(function()
					currentColor = pc
					h, s, v = RGBtoHSV(pc)
					SVArea.BackgroundColor3 = HSVtoRGB(h, 1, 1)
					HueCursor.Position = UDim2.new(h, 0, 0.5, 0)
					SVCursor.Position = UDim2.new(s, 0, 1 - v, 0)
					ColorPreview.BackgroundColor3 = pc
					HexLabel.Text = ColorToHex(pc)
					HexInput.Text = ColorToHex(pc):sub(2)
					if callback then callback(pc) end
				end)
			end

			local function updateColor()
				currentColor = HSVtoRGB(h, s, v)
				ColorPreview.BackgroundColor3 = currentColor
				HexLabel.Text = ColorToHex(currentColor)
				HexInput.Text = ColorToHex(currentColor):sub(2)
				SVArea.BackgroundColor3 = HSVtoRGB(h, 1, 1)
				if callback then callback(currentColor) end
			end

			local svDragging = false
			SVArea.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					svDragging = true
					local relX = math.clamp((input.Position.X - SVArea.AbsolutePosition.X) / SVArea.AbsoluteSize.X, 0, 1)
					local relY = math.clamp((input.Position.Y - SVArea.AbsolutePosition.Y) / SVArea.AbsoluteSize.Y, 0, 1)
					s = relX; v = 1 - relY
					SVCursor.Position = UDim2.new(s, 0, 1 - v, 0)
					updateColor()
				end
			end)
			UserInputService.InputChanged:Connect(function(input)
				if svDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
					local relX = math.clamp((input.Position.X - SVArea.AbsolutePosition.X) / SVArea.AbsoluteSize.X, 0, 1)
					local relY = math.clamp((input.Position.Y - SVArea.AbsolutePosition.Y) / SVArea.AbsoluteSize.Y, 0, 1)
					s = relX; v = 1 - relY
					SVCursor.Position = UDim2.new(s, 0, 1 - v, 0)
					updateColor()
				end
			end)
			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then svDragging = false end
			end)

			local hueDragging = false
			HueBar.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					hueDragging = true
					h = math.clamp((input.Position.X - HueBar.AbsolutePosition.X) / HueBar.AbsoluteSize.X, 0, 1)
					HueCursor.Position = UDim2.new(h, 0, 0.5, 0)
					updateColor()
				end
			end)
			UserInputService.InputChanged:Connect(function(input)
				if hueDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
					h = math.clamp((input.Position.X - HueBar.AbsolutePosition.X) / HueBar.AbsoluteSize.X, 0, 1)
					HueCursor.Position = UDim2.new(h, 0, 0.5, 0)
					updateColor()
				end
			end)
			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then hueDragging = false end
			end)

			HexInput.FocusLost:Connect(function()
				local hexStr = HexInput.Text:gsub("#", "")
				if #hexStr == 6 then
					local r = tonumber(hexStr:sub(1, 2), 16)
					local g = tonumber(hexStr:sub(3, 4), 16)
					local b = tonumber(hexStr:sub(5, 6), 16)
					if r and g and b then
						currentColor = Color3.fromRGB(r, g, b)
						h, s, v = RGBtoHSV(currentColor)
						SVArea.BackgroundColor3 = HSVtoRGB(h, 1, 1)
						HueCursor.Position = UDim2.new(h, 0, 0.5, 0)
						SVCursor.Position = UDim2.new(s, 0, 1 - v, 0)
						ColorPreview.BackgroundColor3 = currentColor
						HexLabel.Text = ColorToHex(currentColor)
						if callback then callback(currentColor) end
					end
				end
			end)

			PickerFrame.MouseButton1Click:Connect(function()
				pickerOpen = not pickerOpen
				if pickerOpen then
					local absPos = PickerFrame.AbsolutePosition
					local absSize = PickerFrame.AbsoluteSize
					PickerPopup.Position = UDim2.new(0, absPos.X, 0, absPos.Y + absSize.Y + 5)
					PickerPopup.Visible = true
					Tween(pStroke, 0.2, {Color = currentTheme.Accent})
				else
					PickerPopup.Visible = false
					Tween(pStroke, 0.2, {Color = currentTheme.Stroke})
				end
			end)

			MainFrame:GetPropertyChangedSignal("Position"):Connect(function()
				if pickerOpen then pickerOpen = false; PickerPopup.Visible = false end
			end)

			local PickerObj = {}
			function PickerObj:GetColor() return currentColor end
			function PickerObj:SetColor(color)
				currentColor = color
				h, s, v = RGBtoHSV(color)
				ColorPreview.BackgroundColor3 = color
				HexLabel.Text = ColorToHex(color)
				HexInput.Text = ColorToHex(color):sub(2)
				SVArea.BackgroundColor3 = HSVtoRGB(h, 1, 1)
				HueCursor.Position = UDim2.new(h, 0, 0.5, 0)
				SVCursor.Position = UDim2.new(s, 0, 1 - v, 0)
			end
			return PickerObj
		end

		-- SEKSİYON
		function Elements:CreateSection(sectionTitle)
			local SectionMain = Instance.new("Frame", ParentContainer)
			SectionMain.Size = UDim2.new(1, 0, 0, 34)
			SectionMain.BackgroundTransparency = 1
			SectionMain.ClipsDescendants = true

			local SectionHeader = Instance.new("TextButton", SectionMain)
			SectionHeader.Size = UDim2.new(1, 0, 0, 34)
			SectionHeader.BackgroundColor3 = currentTheme.TabSelected
			SectionHeader.BackgroundTransparency = 0.3
			SectionHeader.AutoButtonColor = false
			SectionHeader.Text = ""
			Instance.new("UICorner", SectionHeader).CornerRadius = UDim.new(0, 6)
			local HeaderStroke = Instance.new("UIStroke", SectionHeader)
			HeaderStroke.Color = currentTheme.Stroke
			RegisterTheme(SectionHeader, "BackgroundColor3", "TabSelected")
			RegisterTheme(HeaderStroke, "Color", "Stroke")

			local AccentBar = Instance.new("Frame", SectionHeader)
			AccentBar.Size = UDim2.new(0, 3, 1, -12)
			AccentBar.Position = UDim2.new(0, 0, 0, 6)
			AccentBar.BackgroundColor3 = currentTheme.Accent
			AccentBar.BorderSizePixel = 0
			Instance.new("UICorner", AccentBar).CornerRadius = UDim.new(1, 0)
			RegisterTheme(AccentBar, "BackgroundColor3", "Accent")

			local TitleLbl = Instance.new("TextLabel", SectionHeader)
			TitleLbl.Size = UDim2.new(1, -40, 1, 0)
			TitleLbl.Position = UDim2.new(0, 12, 0, 0)
			TitleLbl.BackgroundTransparency = 1
			TitleLbl.Text = sectionTitle
			TitleLbl.TextColor3 = currentTheme.Text
			TitleLbl.TextSize = 13
			TitleLbl.Font = Enum.Font.GothamMedium
			TitleLbl.TextXAlignment = Enum.TextXAlignment.Left

			local Chevron = Instance.new("ImageLabel", SectionHeader)
			Chevron.Size = UDim2.new(0, 16, 0, 16)
			Chevron.Position = UDim2.new(1, -26, 0.5, -8)
			Chevron.BackgroundTransparency = 1
			Chevron.ImageColor3 = currentTheme.TextMuted
			LoadIcon(Chevron, "chevron-down")

			local SectionContent = Instance.new("Frame", SectionMain)
			SectionContent.Size = UDim2.new(1, 0, 0, 0)
			SectionContent.Position = UDim2.new(0, 0, 0, 40)
			SectionContent.BackgroundTransparency = 1
			SectionContent.ClipsDescendants = true
			local ContentLayout = Instance.new("UIListLayout", SectionContent)
			ContentLayout.Padding = UDim.new(0, 6)
			ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder

			local expanded = false
			local function UpdateSize()
				if expanded then
					Tween(SectionMain, 0.3, {Size = UDim2.new(1, 0, 0, 42 + ContentLayout.AbsoluteContentSize.Y)})
					Tween(SectionContent, 0.3, {Size = UDim2.new(1, 0, 0, ContentLayout.AbsoluteContentSize.Y)})
				else
					Tween(SectionMain, 0.3, {Size = UDim2.new(1, 0, 0, 34)})
					Tween(SectionContent, 0.3, {Size = UDim2.new(1, 0, 0, 0)})
				end
			end

			ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				if expanded then
					SectionMain.Size = UDim2.new(1, 0, 0, 42 + ContentLayout.AbsoluteContentSize.Y)
					SectionContent.Size = UDim2.new(1, 0, 0, ContentLayout.AbsoluteContentSize.Y)
				end
			end)
			SectionHeader.MouseButton1Click:Connect(function()
				expanded = not expanded
				Tween(Chevron, 0.3, {Rotation = expanded and 180 or 0})
				Tween(AccentBar, 0.3, {BackgroundColor3 = expanded and currentTheme.Accent or currentTheme.TextMuted})
				UpdateSize()
			end)
			SectionHeader.MouseEnter:Connect(function() Tween(HeaderStroke, 0.2, {Color = currentTheme.Accent}) end)
			SectionHeader.MouseLeave:Connect(function() Tween(HeaderStroke, 0.2, {Color = currentTheme.Stroke}) end)

			return BuildElements(SectionContent)
		end

		return Elements
	end

	--------------------------------------------------------------------
	-- TAB OLUŞTURMA
	--------------------------------------------------------------------
	function WindowObj:CreateTab(tabName, tabDescription, iconName, badgeText)
		local hasDesc = (tabDescription ~= nil and tabDescription ~= "")
		local hasIcon = (iconName ~= nil and iconName ~= "")
		local btnHeight = hasDesc and 44 or 34

		local TabButton = Instance.new("TextButton", SidebarScrollFrame)
		TabButton.Size = UDim2.new(1, 0, 0, btnHeight)
		TabButton.BackgroundColor3 = currentTheme.Accent
		TabButton.BackgroundTransparency = 1
		TabButton.ClipsDescendants = true
		TabButton.Text = ""
		TabButton.AutoButtonColor = false
		Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0, 6)
		RegisterTheme(TabButton, "BackgroundColor3", "Accent")

		local contentOffsetX = hasIcon and 32 or 8

		if hasIcon then
			local TabIcon = Instance.new("ImageLabel", TabButton)
			TabIcon.Size = UDim2.new(0, 16, 0, 16)
			TabIcon.Position = UDim2.new(0, 8, 0.5, -8)
			TabIcon.ImageColor3 = currentTheme.TextMuted
			LoadIcon(TabIcon, iconName)
		end

		local TabTitle = Instance.new("TextLabel", TabButton)
		TabTitle.Size = UDim2.new(1, -contentOffsetX - (badgeText and 34 or 8), 0, hasDesc and 20 or btnHeight)
		TabTitle.Position = UDim2.new(0, contentOffsetX, 0, hasDesc and 4 or 0)
		TabTitle.BackgroundTransparency = 1
		TabTitle.Text = tabName
		TabTitle.TextColor3 = currentTheme.TextMuted
		TabTitle.TextSize = 13
		TabTitle.Font = Enum.Font.GothamMedium
		TabTitle.TextXAlignment = Enum.TextXAlignment.Left
		TabTitle.TextWrapped = true
		TabTitle.TextTruncate = Enum.TextTruncate.AtEnd

		if hasDesc then
			local TabDesc = Instance.new("TextLabel", TabButton)
			TabDesc.Size = UDim2.new(1, -contentOffsetX - 8, 0, 16)
			TabDesc.Position = UDim2.new(0, contentOffsetX, 0, 22)
			TabDesc.BackgroundTransparency = 1
			TabDesc.Text = tabDescription
			TabDesc.TextColor3 = Color3.fromRGB(80, 80, 80)
			TabDesc.TextSize = 10
			TabDesc.Font = Enum.Font.Gotham
			TabDesc.TextXAlignment = Enum.TextXAlignment.Left
			TabDesc.TextWrapped = true
			TabDesc.TextTruncate = Enum.TextTruncate.AtEnd
		end

		-- Badge (rozet)
		local BadgeLabel = nil
		if badgeText then
			BadgeLabel = Instance.new("TextLabel", TabButton)
			BadgeLabel.Size = UDim2.new(0, 26, 0, 16)
			BadgeLabel.Position = UDim2.new(1, -30, 0.5, -8)
			BadgeLabel.BackgroundColor3 = currentTheme.Accent
			BadgeLabel.Text = tostring(badgeText)
			BadgeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			BadgeLabel.TextSize = 9
			BadgeLabel.Font = Enum.Font.GothamBold
			Instance.new("UICorner", BadgeLabel).CornerRadius = UDim.new(1, 0)
			RegisterTheme(BadgeLabel, "BackgroundColor3", "Accent")
		end

		-- Sekme sayfası
		local TabPage = Instance.new("ScrollingFrame", ContentArea)
		TabPage.Size = UDim2.new(1, 0, 1, 0)
		TabPage.BackgroundTransparency = 1
		TabPage.Visible = false
		TabPage.ScrollBarThickness = 2
		TabPage.ScrollBarImageColor3 = currentTheme.Accent
		TabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
		RegisterTheme(TabPage, "ScrollBarImageColor3", "Accent")

		local PageLayout = Instance.new("UIListLayout", TabPage)
		PageLayout.Padding = UDim.new(0, 8)
		PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
		local PagePadding = Instance.new("UIPadding", TabPage)
		PagePadding.PaddingTop = UDim.new(0, 15)
		PagePadding.PaddingLeft = UDim.new(0, 15)
		PagePadding.PaddingRight = UDim.new(0, 15)
		PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			TabPage.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 30)
		end)

		-- Sekme geçiş seçici
		local function SelectTab()
			if WindowObj.CurrentTab then
				WindowObj.CurrentTab.Button.BackgroundTransparency = 1
				WindowObj.CurrentTab.Title.TextColor3 = currentTheme.TextMuted
				local ci = WindowObj.CurrentTab.Button:FindFirstChildOfClass("ImageLabel")
				if ci then ci.ImageColor3 = currentTheme.TextMuted end
				WindowObj.CurrentTab.Page.Visible = false
			end
			WindowObj.CurrentTab = {Button = TabButton, Title = TabTitle, Icon = TabButton:FindFirstChildOfClass("ImageLabel"), Page = TabPage}
			Tween(TabButton, 0.2, {BackgroundTransparency = 0.9})
			Tween(TabTitle, 0.2, {TextColor3 = currentTheme.Accent})
			if WindowObj.CurrentTab.Icon then Tween(WindowObj.CurrentTab.Icon, 0.2, {ImageColor3 = currentTheme.Accent}) end
			TabPage.Visible = true
		end

		TabButton.MouseButton1Click:Connect(SelectTab)
		-- İlk sekme otomatik seç (layout children: UIListLayout + UIPadding = 2)
		if #SidebarScrollFrame:GetChildren() == 3 then SelectTab() end

		-- Arama için kaydet
		table.insert(TabButtons, {Name = tabName, Button = TabButton})

		local TabObj = BuildElements(TabPage)

		-- Badge güncelleme
		function TabObj:SetBadge(text)
			if BadgeLabel then BadgeLabel.Text = tostring(text); BadgeLabel.Visible = text ~= nil and text ~= "" end
		end
		function TabObj:Select() SelectTab() end

		return TabObj
	end

	--------------------------------------------------------------------
	-- CONTEXT MENU (Sağ tık menüsü)
	--------------------------------------------------------------------
	function WindowObj:ShowContextMenu(items)
		local existingMenu = ScreenGui:FindFirstChild("ContextMenu")
		if existingMenu then existingMenu:Destroy() end

		local mousePos = UserInputService:GetMouseLocation()
		local Menu = Instance.new("Frame", ScreenGui)
		Menu.Name = "ContextMenu"
		Menu.Size = UDim2.new(0, 160, 0, #items * 32 + 8)
		Menu.Position = UDim2.new(0, mousePos.X, 0, mousePos.Y)
		Menu.BackgroundColor3 = currentTheme.Background
		Menu.ZIndex = 500
		Instance.new("UICorner", Menu).CornerRadius = UDim.new(0, 6)
		local mStroke = Instance.new("UIStroke", Menu)
		mStroke.Color = currentTheme.Stroke; mStroke.Thickness = 1

		local MLayout = Instance.new("UIListLayout", Menu)
		MLayout.Padding = UDim.new(0, 2)
		local MPad = Instance.new("UIPadding", Menu)
		MPad.PaddingTop = UDim.new(0, 4); MPad.PaddingBottom = UDim.new(0, 4)
		MPad.PaddingLeft = UDim.new(0, 4); MPad.PaddingRight = UDim.new(0, 4)

		for _, item in pairs(items) do
			if item.separator then
				local Sep = Instance.new("Frame", Menu)
				Sep.Size = UDim2.new(1, 0, 0, 1)
				Sep.BackgroundColor3 = currentTheme.Stroke
				Sep.BorderSizePixel = 0
				Sep.ZIndex = 501
			else
				local MItem = Instance.new("TextButton", Menu)
				MItem.Size = UDim2.new(1, 0, 0, 28)
				MItem.BackgroundColor3 = currentTheme.TabSelected
				MItem.BackgroundTransparency = 1
				MItem.Text = ""
				MItem.AutoButtonColor = false
				MItem.ZIndex = 501
				Instance.new("UICorner", MItem).CornerRadius = UDim.new(0, 4)

				if item.icon then
					local MIIcon = Instance.new("ImageLabel", MItem)
					MIIcon.Size = UDim2.new(0, 14, 0, 14)
					MIIcon.Position = UDim2.new(0, 6, 0.5, -7)
					MIIcon.BackgroundTransparency = 1
					MIIcon.ImageColor3 = item.color or currentTheme.TextMuted
					MIIcon.ZIndex = 502
					LoadIcon(MIIcon, item.icon)
				end

				local MILabel = Instance.new("TextLabel", MItem)
				MILabel.Size = UDim2.new(1, -30, 1, 0)
				MILabel.Position = UDim2.new(0, (item.icon and 24 or 8), 0, 0)
				MILabel.BackgroundTransparency = 1
				MILabel.Text = item.text
				MILabel.TextColor3 = item.color or currentTheme.Text
				MILabel.TextSize = 12
				MILabel.Font = Enum.Font.GothamMedium
				MILabel.TextXAlignment = Enum.TextXAlignment.Left
				MILabel.ZIndex = 502

				MItem.MouseEnter:Connect(function() Tween(MItem, 0.15, {BackgroundTransparency = 0.5}) end)
				MItem.MouseLeave:Connect(function() Tween(MItem, 0.15, {BackgroundTransparency = 1}) end)
				MItem.MouseButton1Click:Connect(function()
					Menu:Destroy()
					if item.callback then item.callback() end
				end)
			end
		end

		-- Dışarı tıklayınca kapat
		local closeConn
		closeConn = UserInputService.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then
				task.wait()
				if Menu and Menu.Parent then Menu:Destroy() end
				if closeConn then closeConn:Disconnect() end
			end
		end)
	end

	return WindowObj
end

return EmoC
