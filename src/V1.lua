local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Library = {}

--------------------------------------------------------------------
-- İKON SİSTEMİ (ImageRectOffset Hatası Giderildi)
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
		-- Buraya kendi dosyadaki tüm listeyi kopyalayabilirsin. Örnek olarak birkaç tane ekledim:
		["home"] = { Image = 4, ImageRectPosition = Vector2.new(512, 256), ImageRectSize = Vector2.new(128, 128) },
		["settings-gear"] = { Image = 6, ImageRectPosition = Vector2.new(512, 768), ImageRectSize = Vector2.new(128, 128) },
		["user"] = { Image = 7, ImageRectPosition = Vector2.new(640, 896), ImageRectSize = Vector2.new(128, 128) },
		["box"] = { Image = 1, ImageRectPosition = Vector2.new(640, 768), ImageRectSize = Vector2.new(128, 128) },
		["shield-check"] = { Image = 6, ImageRectPosition = Vector2.new(384, 896), ImageRectSize = Vector2.new(128, 128) },
		["code"] = { Image = 2, ImageRectPosition = Vector2.new(768, 640), ImageRectSize = Vector2.new(128, 128) },
		["play"] = { Image = 6, ImageRectPosition = Vector2.new(0, 384), ImageRectSize = Vector2.new(128, 128) },
		["power"] = { Image = 6, ImageRectPosition = Vector2.new(768, 384), ImageRectSize = Vector2.new(128, 128) }
	}
}

-- İkon Yükleme Yardımcısı
local function LoadIcon(imageLabel, iconName)
	local iconData = IconSystem.Icons[iconName]
	if iconData then
		imageLabel.Image = IconSystem.Spritesheets[tostring(iconData.Image)]
		-- DÜZELTİLEN KISIM: Roblox'ta bu özelliğin adı ImageRectOffset'tir.
		imageLabel.ImageRectOffset = iconData.ImageRectPosition 
		imageLabel.ImageRectSize = iconData.ImageRectSize
		imageLabel.BackgroundTransparency = 1
		imageLabel.Visible = true
	else
		imageLabel.Visible = false
	end
end

-- ANA PENCERE OLUŞTURUCU
function Library:CreateWindow(mainTitle, subTitleText, config)
	config = config or {}
	local minWidth = config.minWidth or 350
	local maxWidth = config.maxWidth or 800
	
	local currentTheme = {
		Background = Color3.fromRGB(14, 14, 14),
		Topbar = Color3.fromRGB(18, 18, 18),
		Accent = Color3.fromRGB(46, 204, 113),
		Stroke = Color3.fromRGB(30, 30, 30),
		Text = Color3.fromRGB(255, 255, 255),
		TextMuted = Color3.fromRGB(120, 120, 120),
		TabSelected = Color3.fromRGB(28, 28, 28)
	}

	if config.customTheme and config.theme then
		for key, value in pairs(config.theme) do currentTheme[key] = value end
	end

	local ScreenGui = Instance.new("ScreenGui")
	pcall(function() ScreenGui.Parent = CoreGui end)
	if not ScreenGui.Parent then ScreenGui.Parent = PlayerGui end
	ScreenGui.Name = "WindUiUltimate"
	ScreenGui.ResetOnSpawn = false

	local isMinimized = false
	local isMaximized = false
	local originalSize = UDim2.new(0, math.clamp(520, minWidth, maxWidth), 0, 360)
	local originalPos = UDim2.new(0.5, -260, 0.5, -180)
	local normalSizeBeforeMaximize = originalSize
	local normalPosBeforeMaximize = originalPos

	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "MainFrame"
	MainFrame.Size = originalSize
	MainFrame.Position = originalPos
	MainFrame.BackgroundColor3 = currentTheme.Background
	MainFrame.BorderSizePixel = 0
	MainFrame.ClipsDescendants = false
	MainFrame.Parent = ScreenGui

	local MainCorner = Instance.new("UICorner", MainFrame)
	MainCorner.CornerRadius = UDim.new(0, 10)
	local MainStroke = Instance.new("UIStroke", MainFrame)
	MainStroke.Color = currentTheme.Stroke; MainStroke.Thickness = 1.5

	-- ÜST BAR & PENCERE İKONU
	local Topbar = Instance.new("Frame", MainFrame)
	Topbar.Size = UDim2.new(1, 0, 0, 55)
	Topbar.BackgroundTransparency = 1

	local hasWindowIcon = config.icon ~= nil
	local titleOffsetX = hasWindowIcon and 45 or 15

	if hasWindowIcon then
		local WindowIcon = Instance.new("ImageLabel", Topbar)
		WindowIcon.Size = UDim2.new(0, 22, 0, 22)
		WindowIcon.Position = UDim2.new(0, 15, 0, 15)
		WindowIcon.ImageColor3 = currentTheme.Accent
		LoadIcon(WindowIcon, config.icon)
	end

	local Title = Instance.new("TextLabel", Topbar)
	Title.Size = UDim2.new(0.6, 0, 0, 25)
	Title.Position = UDim2.new(0, titleOffsetX, 0, 10)
	Title.BackgroundTransparency = 1
	Title.Text = mainTitle or "WIND UI"
	Title.TextColor3 = currentTheme.Text
	Title.Font = Enum.Font.GothamBold
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.TextScaled = true
	local TitleSizeConstraint = Instance.new("UITextSizeConstraint", Title)
	TitleSizeConstraint.MaxTextSize = 16; TitleSizeConstraint.MinTextSize = 12

	local SubTitle = Instance.new("TextLabel", Topbar)
	SubTitle.Size = UDim2.new(0.6, 0, 0, 15)
	SubTitle.Position = UDim2.new(0, titleOffsetX, 0, 32)
	SubTitle.BackgroundTransparency = 1
	SubTitle.Text = subTitleText or "Premium UI System"
	SubTitle.TextColor3 = currentTheme.TextMuted
	SubTitle.Font = Enum.Font.GothamMedium
	SubTitle.TextXAlignment = Enum.TextXAlignment.Left
	SubTitle.TextScaled = true
	local SubTitleSizeConstraint = Instance.new("UITextSizeConstraint", SubTitle)
	SubTitleSizeConstraint.MaxTextSize = 11; SubTitleSizeConstraint.MinTextSize = 9

	-- KONTROL BUTONLARI
	local ButtonContainer = Instance.new("Frame", Topbar)
	ButtonContainer.Size = UDim2.new(0, 60, 0, 30)
	ButtonContainer.Position = UDim2.new(1, -70, 0, 12)
	ButtonContainer.BackgroundTransparency = 1
	local BtnLayout = Instance.new("UIListLayout", ButtonContainer)
	BtnLayout.FillDirection = Enum.FillDirection.Horizontal
	BtnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	BtnLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	BtnLayout.Padding = UDim.new(0, 8)

	local function createControlBtn(name, color, symbol)
		local Btn = Instance.new("TextButton", ButtonContainer)
		Btn.Name = name; Btn.Size = UDim2.new(0, 22, 0, 22); Btn.BackgroundColor3 = currentTheme.TabSelected
		Btn.Text = symbol; Btn.TextColor3 = color; Btn.TextSize = 10; Btn.Font = Enum.Font.GothamBold; Btn.AutoButtonColor = false
		Instance.new("UICorner", Btn).CornerRadius = UDim.new(1, 0)
		local bs = Instance.new("UIStroke", Btn); bs.Color = currentTheme.Stroke
		Btn.MouseEnter:Connect(function() TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = color, TextColor3 = currentTheme.Background}):Play() end)
		Btn.MouseLeave:Connect(function() TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = currentTheme.TabSelected, TextColor3 = color}):Play() end)
		return Btn
	end
	local MinimizeBtn = createControlBtn("Minimize", Color3.fromRGB(241, 196, 15), "-")
	local MaximizeBtn = createControlBtn("Maximize", currentTheme.Accent, "+")

	-- SÜRÜKLEME SİSTEMİ
	local DragHandleArea = Instance.new("TextButton", MainFrame)
	DragHandleArea.Size = UDim2.new(0, 25, 0, 120); DragHandleArea.Position = UDim2.new(0, -33, 0.5, -60)
	DragHandleArea.BackgroundTransparency = 1; DragHandleArea.Text = ""
	local DragBar = Instance.new("Frame", DragHandleArea)
	DragBar.Size = UDim2.new(0, 4, 0, 50); DragBar.Position = UDim2.new(0.5, -2, 0.5, -25)
	DragBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60); DragBar.BorderSizePixel = 0
	Instance.new("UICorner", DragBar).CornerRadius = UDim.new(1, 0)

	DragHandleArea.MouseEnter:Connect(function() TweenService:Create(DragBar, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(255, 255, 255), Size = UDim2.new(0, 4, 0, 80), Position = UDim2.new(0.5, -2, 0.5, -40)}):Play() end)
	DragHandleArea.MouseLeave:Connect(function() TweenService:Create(DragBar, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(60, 60, 60), Size = UDim2.new(0, 4, 0, 50), Position = UDim2.new(0.5, -2, 0.5, -25)}):Play() end)

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
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
	end)

	-- BOYUTLANDIRMA (RESIZE) SİSTEMİ
	local ResizeHandle = Instance.new("TextButton", MainFrame)
	ResizeHandle.Size = UDim2.new(0, 15, 1, -20); ResizeHandle.Position = UDim2.new(1, -10, 0, 10)
	ResizeHandle.BackgroundTransparency = 1; ResizeHandle.Text = ""; ResizeHandle.AutoButtonColor = false
	local ResizeVisual = Instance.new("Frame", ResizeHandle)
	ResizeVisual.Size = UDim2.new(0, 2, 0.3, 0); ResizeVisual.Position = UDim2.new(0.5, -1, 0.35, 0)
	ResizeVisual.BackgroundColor3 = currentTheme.Stroke; ResizeVisual.BorderSizePixel = 0

	ResizeHandle.MouseEnter:Connect(function() TweenService:Create(ResizeVisual, TweenInfo.new(0.2), {BackgroundColor3 = currentTheme.Accent, Size = UDim2.new(0, 3, 0.4, 0), Position = UDim2.new(0.5, -1.5, 0.3, 0)}):Play() end)
	ResizeHandle.MouseLeave:Connect(function() TweenService:Create(ResizeVisual, TweenInfo.new(0.2), {BackgroundColor3 = currentTheme.Stroke, Size = UDim2.new(0, 2, 0.3, 0), Position = UDim2.new(0.5, -1, 0.35, 0)}):Play() end)

	local resizing = false; local resizeStartSize, resizeStartMousePos
	ResizeHandle.InputBegan:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not isMaximized and not isMinimized then
			resizing = true; resizeStartMousePos = input.Position; resizeStartSize = MainFrame.Size
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - resizeStartMousePos
			local newWidth = math.clamp(resizeStartSize.X.Offset + delta.X, minWidth, maxWidth)
			MainFrame.Size = UDim2.new(0, newWidth, MainFrame.Size.Y.Scale, MainFrame.Size.Y.Offset)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then resizing = false end
	end)

	local Sidebar = Instance.new("ScrollingFrame", MainFrame)
	Sidebar.Size = UDim2.new(0, 140, 1, -55); Sidebar.Position = UDim2.new(0, 0, 0, 55)
	Sidebar.BackgroundTransparency = 1; Sidebar.ScrollBarThickness = 0
	local SidebarLayout = Instance.new("UIListLayout", Sidebar)
	SidebarLayout.Padding = UDim.new(0, 6); SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
	local SidebarPadding = Instance.new("UIPadding", Sidebar)
	SidebarPadding.PaddingLeft = UDim.new(0, 8); SidebarPadding.PaddingRight = UDim.new(0, 8); SidebarPadding.PaddingTop = UDim.new(0, 5)
	SidebarLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() Sidebar.CanvasSize = UDim2.new(0, 0, 0, SidebarLayout.AbsoluteContentSize.Y + 20) end)

	local VerticalDivider = Instance.new("Frame", MainFrame)
	VerticalDivider.Size = UDim2.new(0, 1, 1, -55); VerticalDivider.Position = UDim2.new(0, 140, 0, 55); VerticalDivider.BackgroundColor3 = currentTheme.Stroke; VerticalDivider.BorderSizePixel = 0

	local ContentArea = Instance.new("Frame", MainFrame)
	ContentArea.Size = UDim2.new(1, -141, 1, -55); ContentArea.Position = UDim2.new(0, 141, 0, 55); ContentArea.BackgroundTransparency = 1

	-- KÜÇÜLTME VE BÜYÜTME İŞLEMLERİ
	MinimizeBtn.MouseButton1Click:Connect(function()
		if isMaximized then return end
		isMinimized = not isMinimized
		if isMinimized then
			originalSize = MainFrame.Size
			Sidebar.Visible = false; VerticalDivider.Visible = false; ContentArea.Visible = false; ResizeHandle.Visible = false; DragHandleArea.Visible = false
			TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, MainFrame.Size.X.Offset, 0, 55)}):Play()
		else
			TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = originalSize}):Play()
			task.delay(0.2, function()
				if not isMinimized then Sidebar.Visible = true; VerticalDivider.Visible = true; ContentArea.Visible = true; ResizeHandle.Visible = true; DragHandleArea.Visible = true end
			end)
		end
	end)

	MaximizeBtn.MouseButton1Click:Connect(function()
		if isMinimized then return end
		isMaximized = not isMaximized
		if isMaximized then
			normalSizeBeforeMaximize = MainFrame.Size; normalPosBeforeMaximize = MainFrame.Position
			ResizeHandle.Visible = false; DragHandleArea.Visible = false
			TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0, 0, 0, 0)}):Play()
		else
			ResizeHandle.Visible = true; DragHandleArea.Visible = true
			TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = normalSizeBeforeMaximize, Position = normalPosBeforeMaximize}):Play()
		end
	end)

	--------------------------------------------------------------------
	-- TAB SİSTEMİ
	--------------------------------------------------------------------
	local WindowObj = { CurrentTab = nil }

	function WindowObj:CreateTab(tabName, tabDescription, iconName)
		local hasDesc = (tabDescription ~= nil and tabDescription ~= "")
		local hasIcon = (iconName ~= nil and iconName ~= "")
		local btnHeight = hasDesc and 44 or 34

		local TabButton = Instance.new("TextButton", Sidebar)
		TabButton.Size = UDim2.new(1, 0, 0, btnHeight)
		TabButton.BackgroundColor3 = currentTheme.Accent
		TabButton.BackgroundTransparency = 1
		TabButton.ClipsDescendants = true; TabButton.Text = ""; TabButton.AutoButtonColor = false
		Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0, 6)

		local contentOffsetX = hasIcon and 32 or 8

		if hasIcon then
			local TabIcon = Instance.new("ImageLabel", TabButton)
			TabIcon.Size = UDim2.new(0, 16, 0, 16)
			TabIcon.Position = UDim2.new(0, 8, 0.5, -8)
			TabIcon.ImageColor3 = currentTheme.TextMuted
			LoadIcon(TabIcon, iconName)
		end

		local TabTitle = Instance.new("TextLabel", TabButton)
		TabTitle.Size = UDim2.new(1, -contentOffsetX - 8, 0, hasDesc and 20 or btnHeight)
		TabTitle.Position = UDim2.new(0, contentOffsetX, 0, hasDesc and 4 or 0)
		TabTitle.BackgroundTransparency = 1; TabTitle.Text = tabName
		TabTitle.TextColor3 = currentTheme.TextMuted; TabTitle.TextSize = 13; TabTitle.Font = Enum.Font.GothamMedium
		TabTitle.TextXAlignment = Enum.TextXAlignment.Left; TabTitle.TextWrapped = true; TabTitle.TextTruncate = Enum.TextTruncate.AtEnd

		if hasDesc then
			local TabDesc = Instance.new("TextLabel", TabButton)
			TabDesc.Size = UDim2.new(1, -contentOffsetX - 8, 0, 16)
			TabDesc.Position = UDim2.new(0, contentOffsetX, 0, 22)
			TabDesc.BackgroundTransparency = 1; TabDesc.Text = tabDescription
			TabDesc.TextColor3 = Color3.fromRGB(80, 80, 80); TabDesc.TextSize = 10; TabDesc.Font = Enum.Font.Gotham
			TabDesc.TextXAlignment = Enum.TextXAlignment.Left; TabDesc.TextWrapped = true; TabDesc.TextTruncate = Enum.TextTruncate.AtEnd
		end

		local TabPage = Instance.new("ScrollingFrame", ContentArea)
		TabPage.Size = UDim2.new(1, 0, 1, 0); TabPage.BackgroundTransparency = 1; TabPage.Visible = false
		TabPage.ScrollBarThickness = 2; TabPage.ScrollBarImageColor3 = currentTheme.Accent; TabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
		local PageLayout = Instance.new("UIListLayout", TabPage)
		PageLayout.Padding = UDim.new(0, 8); PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
		local PagePadding = Instance.new("UIPadding", TabPage)
		PagePadding.PaddingTop = UDim.new(0, 15); PagePadding.PaddingLeft = UDim.new(0, 15); PagePadding.PaddingRight = UDim.new(0, 15)
		PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() TabPage.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 30) end)

		local function SelectTab()
			if WindowObj.CurrentTab then
				WindowObj.CurrentTab.Button.BackgroundTransparency = 1
				WindowObj.CurrentTab.Title.TextColor3 = currentTheme.TextMuted
				if WindowObj.CurrentTab.Icon then WindowObj.CurrentTab.Icon.ImageColor3 = currentTheme.TextMuted end
				WindowObj.CurrentTab.Page.Visible = false
			end
			WindowObj.CurrentTab = {Button = TabButton, Title = TabTitle, Icon = TabButton:FindFirstChildOfClass("ImageLabel"), Page = TabPage}
			TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.92}):Play()
			TweenService:Create(TabTitle, TweenInfo.new(0.2), {TextColor3 = currentTheme.Accent}):Play()
			if WindowObj.CurrentTab.Icon then TweenService:Create(WindowObj.CurrentTab.Icon, TweenInfo.new(0.2), {ImageColor3 = currentTheme.Accent}):Play() end
			TabPage.Visible = true
		end

		TabButton.MouseButton1Click:Connect(SelectTab)
		if #Sidebar:GetChildren() == 3 then SelectTab() end

		local TabOperations = {}

		--------------------------------------------------------------------
		-- BUTTON SİSTEMİ
		--------------------------------------------------------------------
		function TabOperations:CreateButton(btnName, btnDescription, iconName, callback)
			local hasDesc = (btnDescription ~= nil and btnDescription ~= "")
			local hasIcon = (iconName ~= nil and iconName ~= "")
			local rowHeight = hasDesc and 48 or 36

			local ButtonFrame = Instance.new("TextButton", TabPage)
			ButtonFrame.Size = UDim2.new(1, 0, 0, rowHeight)
			ButtonFrame.BackgroundColor3 = currentTheme.TabSelected
			ButtonFrame.BackgroundTransparency = 0.6; ButtonFrame.Text = ""; ButtonFrame.AutoButtonColor = false
			Instance.new("UICorner", ButtonFrame).CornerRadius = UDim.new(0, 6)
			local btnStroke = Instance.new("UIStroke", ButtonFrame)
			btnStroke.Color = currentTheme.Stroke; btnStroke.Thickness = 1

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
			TextContainer.Size = UDim2.new(1, -contentOffsetX - 35, 1, 0); TextContainer.Position = UDim2.new(0, contentOffsetX, 0, 0); TextContainer.BackgroundTransparency = 1

			local TitleLbl = Instance.new("TextLabel", TextContainer)
			TitleLbl.Size = UDim2.new(1, 0, 0, hasDesc and 22 or rowHeight); TitleLbl.Position = UDim2.new(0, 0, 0, hasDesc and 5 or 0)
			TitleLbl.BackgroundTransparency = 1; TitleLbl.Text = btnName; TitleLbl.TextColor3 = currentTheme.Text
			TitleLbl.TextSize = 13; TitleLbl.Font = Enum.Font.GothamMedium; TitleLbl.TextXAlignment = Enum.TextXAlignment.Left

			if hasDesc then
				local DescLbl = Instance.new("TextLabel", TextContainer)
				DescLbl.Size = UDim2.new(1, 0, 0, 16); DescLbl.Position = UDim2.new(0, 0, 0, 24)
				DescLbl.BackgroundTransparency = 1; DescLbl.Text = btnDescription; DescLbl.TextColor3 = currentTheme.TextMuted
				DescLbl.TextSize = 10; DescLbl.Font = Enum.Font.Gotham; DescLbl.TextXAlignment = Enum.TextXAlignment.Left
			end

			ButtonFrame.MouseEnter:Connect(function()
				TweenService:Create(btnStroke, TweenInfo.new(0.2), {Color = currentTheme.Accent}):Play()
				TweenService:Create(PointerIcon, TweenInfo.new(0.2), {ImageColor3 = currentTheme.Accent, Position = UDim2.new(1, -22, 0.5, -8)}):Play()
			end)
			ButtonFrame.MouseLeave:Connect(function()
				TweenService:Create(btnStroke, TweenInfo.new(0.2), {Color = currentTheme.Stroke}):Play()
				TweenService:Create(PointerIcon, TweenInfo.new(0.2), {ImageColor3 = currentTheme.TextMuted, Position = UDim2.new(1, -26, 0.5, -8)}):Play()
			end)
			ButtonFrame.MouseButton1Click:Connect(function()
				ButtonFrame.BackgroundColor3 = currentTheme.Accent
				TweenService:Create(ButtonFrame, TweenInfo.new(0.3), {BackgroundColor3 = currentTheme.TabSelected}):Play()
				if callback then callback() end
			end)
		end

		--------------------------------------------------------------------
		-- TOGGLE SİSTEMİ
		--------------------------------------------------------------------
		function TabOperations:CreateToggle(toggleName, toggleDescription, iconName, defaultState, useCircleStyle, callback)
			local toggleActive = defaultState or false
			local hasDesc = (toggleDescription ~= nil and toggleDescription ~= "")
			local hasIcon = (iconName ~= nil and iconName ~= "")
			local rowHeight = hasDesc and 48 or 36

			local ToggleFrame = Instance.new("TextButton", TabPage)
			ToggleFrame.Size = UDim2.new(1, 0, 0, rowHeight)
			ToggleFrame.BackgroundColor3 = currentTheme.TabSelected
			ToggleFrame.BackgroundTransparency = 0.6; ToggleFrame.Text = ""; ToggleFrame.AutoButtonColor = false
			Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 6)
			local tfStroke = Instance.new("UIStroke", ToggleFrame)
			tfStroke.Color = currentTheme.Stroke; tfStroke.Thickness = 1

			local contentOffsetX = hasIcon and 38 or 12

			if hasIcon then
				local TglIcon = Instance.new("ImageLabel", ToggleFrame)
				TglIcon.Size = UDim2.new(0, 18, 0, 18)
				TglIcon.Position = UDim2.new(0, 10, 0.5, -9)
				TglIcon.ImageColor3 = currentTheme.Text
				LoadIcon(TglIcon, iconName)
			end

			local TextContainer = Instance.new("Frame", ToggleFrame)
			TextContainer.Size = UDim2.new(1, -contentOffsetX - 60, 1, 0); TextContainer.Position = UDim2.new(0, contentOffsetX, 0, 0); TextContainer.BackgroundTransparency = 1

			local TitleLbl = Instance.new("TextLabel", TextContainer)
			TitleLbl.Size = UDim2.new(1, 0, 0, hasDesc and 22 or rowHeight); TitleLbl.Position = UDim2.new(0, 0, 0, hasDesc and 5 or 0)
			TitleLbl.BackgroundTransparency = 1; TitleLbl.Text = toggleName; TitleLbl.TextColor3 = currentTheme.Text
			TitleLbl.TextSize = 13; TitleLbl.Font = Enum.Font.GothamMedium; TitleLbl.TextXAlignment = Enum.TextXAlignment.Left

			if hasDesc then
				local DescLbl = Instance.new("TextLabel", TextContainer)
				DescLbl.Size = UDim2.new(1, 0, 0, 16); DescLbl.Position = UDim2.new(0, 0, 0, 24)
				DescLbl.BackgroundTransparency = 1; DescLbl.Text = toggleDescription; DescLbl.TextColor3 = currentTheme.TextMuted
				DescLbl.TextSize = 10; DescLbl.Font = Enum.Font.Gotham; DescLbl.TextXAlignment = Enum.TextXAlignment.Left
			end

			local IndicatorContainer = Instance.new("Frame", ToggleFrame)
			IndicatorContainer.BackgroundTransparency = 1
			local IndicatorCorner = Instance.new("UICorner", IndicatorContainer)
			IndicatorCorner.CornerRadius = UDim.new(1, 0)
			local IndicatorStroke = Instance.new("UIStroke", IndicatorContainer)
			
			local MovingPart = Instance.new("Frame", IndicatorContainer)
			MovingPart.BorderSizePixel = 0
			local MovingCorner = Instance.new("UICorner", MovingPart)
			MovingCorner.CornerRadius = UDim.new(1, 0)

			if useCircleStyle then
				IndicatorContainer.Size = UDim2.new(0, 22, 0, 22)
				IndicatorContainer.Position = UDim2.new(1, -34, 0.5, -11)
				IndicatorStroke.Thickness = 1.5
				MovingPart.BackgroundColor3 = currentTheme.Text

				local function updateVisuals(animate)
					local duration = animate and 0.2 or 0
					if toggleActive then
						TweenService:Create(IndicatorContainer, TweenInfo.new(duration), {BackgroundColor3 = currentTheme.Accent}):Play()
						TweenService:Create(IndicatorStroke, TweenInfo.new(duration), {Color = currentTheme.Accent}):Play()
						TweenService:Create(MovingPart, TweenInfo.new(duration), {Size = UDim2.new(0, 10, 0, 10), Position = UDim2.new(0.5, -5, 0.5, -5)}):Play()
					else
						TweenService:Create(IndicatorContainer, TweenInfo.new(duration), {BackgroundColor3 = Color3.fromRGB(0,0,0)}):Play()
						TweenService:Create(IndicatorStroke, TweenInfo.new(duration), {Color = currentTheme.Stroke}):Play()
						TweenService:Create(MovingPart, TweenInfo.new(duration), {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
					end
				end
				updateVisuals(false)
				ToggleFrame.MouseButton1Click:Connect(function() toggleActive = not toggleActive; updateVisuals(true); if callback then callback(toggleActive) end end)
			else
				IndicatorContainer.Size = UDim2.new(0, 42, 0, 22)
				IndicatorContainer.Position = UDim2.new(1, -54, 0.5, -11)
				IndicatorStroke.Thickness = 1
				MovingPart.Size = UDim2.new(0, 16, 0, 16)
				MovingPart.BackgroundColor3 = currentTheme.Text

				local function updateVisuals(animate)
					local duration = animate and 0.2 or 0
					if toggleActive then
						TweenService:Create(IndicatorContainer, TweenInfo.new(duration), {BackgroundColor3 = currentTheme.Accent}):Play()
						TweenService:Create(IndicatorStroke, TweenInfo.new(duration), {Color = currentTheme.Accent}):Play()
						TweenService:Create(MovingPart, TweenInfo.new(duration), {Position = UDim2.new(1, -19, 0.5, -8)}):Play()
					else
						TweenService:Create(IndicatorContainer, TweenInfo.new(duration), {BackgroundColor3 = Color3.fromRGB(24, 24, 24)}):Play()
						TweenService:Create(IndicatorStroke, TweenInfo.new(duration), {Color = currentTheme.Stroke}):Play()
						TweenService:Create(MovingPart, TweenInfo.new(duration), {Position = UDim2.new(0, 3, 0.5, -8)}):Play()
					end
				end
				updateVisuals(false)
				ToggleFrame.MouseButton1Click:Connect(function() toggleActive = not toggleActive; updateVisuals(true); if callback then callback(toggleActive) end end)
			end

			ToggleFrame.MouseEnter:Connect(function() TweenService:Create(tfStroke, TweenInfo.new(0.2), {Color = currentTheme.TextMuted}):Play() end)
			ToggleFrame.MouseLeave:Connect(function() TweenService:Create(tfStroke, TweenInfo.new(0.2), {Color = currentTheme.Stroke}):Play() end)
		end

		return TabOperations
	end

	return WindowObj
end

