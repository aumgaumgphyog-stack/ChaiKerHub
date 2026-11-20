local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

-- ลบ UI เก่าทิ้งหากเคยรันไปแล้ว
if CoreGui:FindFirstChild("ChaiKerHubUI") then
	CoreGui.ChaiKerHubUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ChaiKerHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui

-- สีธีมสไตล์ Redz Hub
local Theme = {
	BgMain = Color3.fromRGB(16, 16, 20),
	BgTop = Color3.fromRGB(24, 18, 22),
	BgSide = Color3.fromRGB(21, 21, 26),
	Card = Color3.fromRGB(28, 28, 35),
	CardHover = Color3.fromRGB(36, 36, 45),
	InputBg = Color3.fromRGB(14, 14, 18),
	Accent = Color3.fromRGB(225, 38, 62),
	AccentSoft = Color3.fromRGB(130, 24, 38),
	Success = Color3.fromRGB(38, 175, 110),
	TextMain = Color3.fromRGB(242, 242, 247),
	TextMuted = Color3.fromRGB(165, 165, 178),
	Border = Color3.fromRGB(65, 24, 32)
}

-- ฟังก์ชันช่วยให้ Frame / Button ลากเคลื่อนไหวได้ทั้งเมาส์และทัชสกรีน
local function makeDraggable(guiObject, dragHandle)
	dragHandle = dragHandle or guiObject
	local dragging = false
	local dragInput, dragStart, startPos

	local function update(input)
		local delta = input.Position - dragStart
		guiObject.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end

	dragHandle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = guiObject.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	dragHandle.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)
end

-- ปุ่มลอยเปิด/ปิด UI ของ Chai Ker Hub
local ToggleFloatBtn = Instance.new("TextButton")
ToggleFloatBtn.Name = "ChaiKerToggleButton"
ToggleFloatBtn.Size = UDim2.new(0, 128, 0, 36)
ToggleFloatBtn.Position = UDim2.new(0.03, 0, 0.18, 0)
ToggleFloatBtn.BackgroundColor3 = Theme.BgTop
ToggleFloatBtn.Text = "CHAI KER HUB"
ToggleFloatBtn.TextColor3 = Theme.TextMain
ToggleFloatBtn.Font = Enum.Font.GothamBold
ToggleFloatBtn.TextSize = 12
ToggleFloatBtn.Parent = ScreenGui
Instance.new("UICorner", ToggleFloatBtn).CornerRadius = UDim.new(0, 8)

local floatStroke = Instance.new("UIStroke")
floatStroke.Color = Theme.Accent
floatStroke.Thickness = 1.6
floatStroke.Parent = ToggleFloatBtn

-- หน้าต่างหลักของ Chai Ker Hub
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 390, 0, 340)
MainFrame.Position = UDim2.new(0.5, -195, 0.5, -170)
MainFrame.BackgroundColor3 = Theme.BgMain
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Theme.Accent
mainStroke.Thickness = 1.5
mainStroke.Parent = MainFrame

-- แถบหัวด้านบน
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Theme.BgTop
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 10)
TopCorner.Parent = TopBar

local AccentLine = Instance.new("Frame")
AccentLine.Size = UDim2.new(1, 0, 0, 2)
AccentLine.Position = UDim2.new(0, 0, 1, -2)
AccentLine.BackgroundColor3 = Theme.Accent
AccentLine.BorderSizePixel = 0
AccentLine.Parent = TopBar

local HubTitle = Instance.new("TextLabel")
HubTitle.Size = UDim2.new(1, -90, 1, 0)
HubTitle.Position = UDim2.new(0, 14, 0, 0)
HubTitle.BackgroundTransparency = 1
HubTitle.Text = "CHAI KER HUB  •  TD EDITION"
HubTitle.TextColor3 = Theme.TextMain
HubTitle.Font = Enum.Font.GothamBold
HubTitle.TextSize = 14
HubTitle.TextXAlignment = Enum.TextXAlignment.Left
HubTitle.Parent = TopBar

-- ปุ่มย่อ/ขยายหน้าต่าง (-)
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 28, 0, 24)
MinBtn.Position = UDim2.new(1, -66, 0.5, -12)
MinBtn.BackgroundColor3 = Theme.Card
MinBtn.Text = "-"
MinBtn.TextColor3 = Theme.TextMain
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 16
MinBtn.Parent = TopBar
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)

-- ปุ่มซ่อน/ปิดหน้าต่าง (×)
local HideBtn = Instance.new("TextButton")
HideBtn.Size = UDim2.new(0, 28, 0, 24)
HideBtn.Position = UDim2.new(1, -34, 0.5, -12)
HideBtn.BackgroundColor3 = Theme.AccentSoft
HideBtn.Text = "×"
HideBtn.TextColor3 = Theme.TextMain
HideBtn.Font = Enum.Font.GothamBold
HideBtn.TextSize = 16
HideBtn.Parent = TopBar
Instance.new("UICorner", HideBtn).CornerRadius = UDim.new(0, 6)

-- แถบด้านข้างซ้ายสไตล์ Redz Hub
local SideBar = Instance.new("Frame")
SideBar.Size = UDim2.new(0, 105, 1, -40)
SideBar.Position = UDim2.new(0, 0, 0, 40)
SideBar.BackgroundColor3 = Theme.BgSide
SideBar.BorderSizePixel = 0
SideBar.Parent = MainFrame

local SideTag = Instance.new("TextLabel")
SideTag.Size = UDim2.new(1, -12, 0, 28)
SideTag.Position = UDim2.new(0, 6, 0, 10)
SideTag.BackgroundColor3 = Theme.Accent
SideTag.Text = "CHAI KER"
SideTag.TextColor3 = Theme.TextMain
SideTag.Font = Enum.Font.GothamBold
SideTag.TextSize = 11
SideTag.Parent = SideBar
Instance.new("UICorner", SideTag).CornerRadius = UDim.new(0, 6)

local StatusInfo = Instance.new("TextLabel")
StatusInfo.Size = UDim2.new(1, -14, 0, 90)
StatusInfo.Position = UDim2.new(0, 7, 1, -98)
StatusInfo.BackgroundColor3 = Theme.Card
StatusInfo.Text = "Chai Ker Hub\nSmooth Font\nDrag UI Anytime"
StatusInfo.TextColor3 = Theme.TextMuted
StatusInfo.Font = Enum.Font.GothamMedium
StatusInfo.TextSize = 11
StatusInfo.LineHeight = 1.25
StatusInfo.Parent = SideBar
Instance.new("UICorner", StatusInfo).CornerRadius = UDim.new(0, 8)

-- พื้นที่เนื้อหาเลื่อนได้ทางขวา
local ContentScroll = Instance.new("ScrollingFrame")
ContentScroll.Size = UDim2.new(1, -115, 1, -48)
ContentScroll.Position = UDim2.new(0, 110, 0, 44)
ContentScroll.BackgroundTransparency = 1
ContentScroll.BorderSizePixel = 0
ContentScroll.ScrollBarThickness = 4
ContentScroll.ScrollBarImageColor3 = Theme.Accent
ContentScroll.CanvasSize = UDim2.new(0, 0, 0, 430)
ContentScroll.Parent = MainFrame

local UIList = Instance.new("UIListLayout")
UIList.Padding = UDim.new(0, 8)
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Parent = ContentScroll

local UIPad = Instance.new("UIPadding")
UIPad.PaddingTop = UDim.new(0, 4)
UIPad.PaddingBottom = UDim.new(0, 8)
UIPad.PaddingRight = UDim.new(0, 6)
UIPad.Parent = ContentScroll

-- ระบบย่อ/ขยาย และเปิด/ปิดหน้าต่าง
local isMinimized = false
MinBtn.MouseButton1Click:Connect(function()
	isMinimized = not isMinimized
	if isMinimized then
		MainFrame.Size = UDim2.new(0, 390, 0, 40)
		SideBar.Visible = false
		ContentScroll.Visible = false
		MinBtn.Text = "+"
	else
		MainFrame.Size = UDim2.new(0, 390, 0, 340)
		SideBar.Visible = true
		ContentScroll.Visible = true
		MinBtn.Text = "-"
	end
end)

HideBtn.MouseButton1Click:Connect(function()
	MainFrame.Visible = false
end)

ToggleFloatBtn.MouseButton1Click:Connect(function()
	MainFrame.Visible = not MainFrame.Visible
	if MainFrame.Visible and isMinimized then
		isMinimized = false
		MainFrame.Size = UDim2.new(0, 390, 0, 340)
		SideBar.Visible = true
		ContentScroll.Visible = true
		MinBtn.Text = "-"
	end
end)

makeDraggable(MainFrame, TopBar)
makeDraggable(ToggleFloatBtn, ToggleFloatBtn)

-- ตัวช่วยสร้างการ์ดแถวฟังก์ชันที่อ่านสบายตา
local function createRowCard(order, labelText, placeholder, defaultVal, actionText, hasInput)
	local card = Instance.new("Frame")
	card.LayoutOrder = order
	card.Size = UDim2.new(1, 0, 0, 44)
	card.BackgroundColor3 = Theme.Card
	card.BorderSizePixel = 0
	card.Parent = ContentScroll
	Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)

	local stroke = Instance.new("UIStroke")
	stroke.Color = Theme.Border
	stroke.Thickness = 1
	stroke.Parent = card

	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(0.42, -6, 1, 0)
	lbl.Position = UDim2.new(0, 10, 0, 0)
	lbl.BackgroundTransparency = 1
	lbl.Text = labelText
	lbl.TextColor3 = Theme.TextMain
	lbl.Font = Enum.Font.GothamMedium
	lbl.TextSize = 12
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.TextTruncate = Enum.TextTruncate.AtEnd
	lbl.Parent = card

	local box = nil
	if hasInput then
		box = Instance.new("TextBox")
		box.Size = UDim2.new(0.22, 0, 0, 28)
		box.Position = UDim2.new(0.42, 0, 0.5, -14)
		box.BackgroundColor3 = Theme.InputBg
		box.Text = defaultVal or ""
		box.PlaceholderText = placeholder or ""
		box.TextColor3 = Theme.TextMain
		box.PlaceholderColor3 = Theme.TextMuted
		box.Font = Enum.Font.GothamMedium
		box.TextSize = 11
		box.ClearTextOnFocus = false
		box.Parent = card
		Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
	end

	local btn = Instance.new("TextButton")
	if hasInput then
		btn.Size = UDim2.new(0.31, 0, 0, 28)
		btn.Position = UDim2.new(0.66, 0, 0.5, -14)
	else
		btn.Size = UDim2.new(0.53, 0, 0, 28)
		btn.Position = UDim2.new(0.44, 0, 0.5, -14)
	end
	btn.BackgroundColor3 = Theme.Accent
	btn.Text = actionText
	btn.TextColor3 = Theme.TextMain
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 11
	btn.TextTruncate = Enum.TextTruncate.AtEnd
	btn.Parent = card
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

	return card, box, btn
end

local function getHumanoid()
	local char = LocalPlayer.Character
	return char and char:FindFirstChildOfClass("Humanoid")
end

-- 1. วิ่งเร็ว
local _, SpeedBox, SpeedBtn = createRowCard(1, "วิ่งเร็ว", "Speed", "50", "ตั้งค่า", true)
local customSpeed = 50
local speedLockConn

SpeedBtn.MouseButton1Click:Connect(function()
	local val = tonumber(SpeedBox.Text)
	if val and val > 0 then
		customSpeed = val
		local hum = getHumanoid()
		if hum then
			hum.WalkSpeed = customSpeed
		end
		if not speedLockConn then
			speedLockConn = RunService.Stepped:Connect(function()
				local h = getHumanoid()
				if h and h.WalkSpeed ~= customSpeed then
					h.WalkSpeed = customSpeed
				end
			end)
		end
		SpeedBtn.Text = "วิ่ง " .. customSpeed
		SpeedBtn.BackgroundColor3 = Theme.Success
	end
end)

-- 2. กระโดดสูง
local _, JumpBox, JumpBtn = createRowCard(2, "กระโดดสูง", "Jump", "100", "ตั้งค่า", true)

JumpBtn.MouseButton1Click:Connect(function()
	local val = tonumber(JumpBox.Text)
	local hum = getHumanoid()
	if val and val > 0 and hum then
		hum.UseJumpPower = true
		hum.JumpPower = val
		JumpBtn.Text = "กระโดด " .. val
		JumpBtn.BackgroundColor3 = Theme.Success
	end
end)

-- 3. เสกของ
local _, SpawnBox, SpawnBtn = createRowCard(3, "เสกของ", "ชื่อของ", "", "เสกเลย", true)

SpawnBtn.MouseButton1Click:Connect(function()
	local char = LocalPlayer.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not root then return end

	local targetName = SpawnBox.Text
	local found = targetName ~= "" and ReplicatedStorage:FindFirstChild(targetName, true)

	if found and found:IsA("Tool") then
		found:Clone().Parent = LocalPlayer.Backpack
	elseif found and (found:IsA("BasePart") or found:IsA("Model")) then
		local clone = found:Clone()
		clone.Parent = workspace
		if clone:IsA("BasePart") then
			clone.CFrame = root.CFrame * CFrame.new(0, 0, -5)
		elseif clone.PrimaryPart then
			clone:SetPrimaryPartCFrame(root.CFrame * CFrame.new(0, 0, -5))
		end
	else
		local part = Instance.new("Part")
		part.Size = Vector3.new(3, 3, 3)
		part.Position = root.Position + (root.CFrame.LookVector * 5)
		part.Anchored = false
		part.Material = Enum.Material.Neon
		part.Color = Theme.Accent
		part.Parent = workspace
	end

	SpawnBtn.Text = "เสกแล้ว"
	task.delay(1.2, function()
		SpawnBtn.Text = "เสกเลย"
	end)
end)

-- 4. เดินทะลุ
local noclipEnabled = false
local _, _, NoclipBtn = createRowCard(4, "เดินทะลุ", nil, nil, "OFF", false)
NoclipBtn.BackgroundColor3 = Theme.CardHover

RunService.Stepped:Connect(function()
	if noclipEnabled and LocalPlayer.Character then
		for _, obj in ipairs(LocalPlayer.Character:GetDescendants()) do
			if obj:IsA("BasePart") and obj.CanCollide then
				obj.CanCollide = false
			end
		end
	end
end)

NoclipBtn.MouseButton1Click:Connect(function()
	noclipEnabled = not noclipEnabled
	NoclipBtn.Text = noclipEnabled and "ON" or "OFF"
	NoclipBtn.BackgroundColor3 = noclipEnabled and Theme.Success or Theme.CardHover
end)

-- 5. โจมตีแรง
local strongAttackEnabled = false
local _, _, AttackBtn = createRowCard(5, "โจมตีแรง", nil, nil, "OFF", false)
AttackBtn.BackgroundColor3 = Theme.CardHover

task.spawn(function()
	while task.wait(0.5) do
		if strongAttackEnabled then
			for _, model in ipairs(workspace:GetChildren()) do
				if model:IsA("Model") and model ~= LocalPlayer.Character then
					local hrp = model:FindFirstChild("HumanoidRootPart")
					local hum = model:FindFirstChildOfClass("Humanoid")
					if hrp and hum and hum.Health > 0 then
						hrp.Size = Vector3.new(12, 12, 12)
						hrp.Transparency = 0.7
						hrp.CanCollide = false
					end
				end
			end

			local char = LocalPlayer.Character
			if char then
				for _, tool in ipairs(char:GetChildren()) do
					if tool:IsA("Tool") then
						for _, v in ipairs(tool:GetDescendants()) do
							if v:IsA("NumberValue") and (v.Name:lower():find("speed") or v.Name:lower():find("cooldown")) then
								v.Value = v.Name:lower():find("cooldown") and 0.05 or 5
							end
						end
					end
				end
			end
		end
	end
end)

AttackBtn.MouseButton1Click:Connect(function()
	strongAttackEnabled = not strongAttackEnabled
	AttackBtn.Text = strongAttackEnabled and "ON" or "OFF"
	AttackBtn.BackgroundColor3 = strongAttackEnabled and Theme.Accent or Theme.CardHover
end)

-- 6. ดูปเข้ากล่องเก็บยูนิต (ไม่ต้องมีไฟล์ยูนิตล่วงหน้า)
local _, DupeUnitBox, DupeBoxBtn = createRowCard(6, "ดูปเข้ากล่อง", "ชื่อ/ว่าง", "", "ดูปยูนิต", true)

local function findUnitInventoryFolder()
	local keywords = { "unit", "inventory", "storage", "box", "owned", "bag", "deck" }
	local searchRoots = { LocalPlayer, LocalPlayer:FindFirstChild("PlayerGui"), ReplicatedStorage }

	for _, root in ipairs(searchRoots) do
		if root then
			for _, desc in ipairs(root:GetDescendants()) do
				if desc:IsA("Folder") or desc:IsA("Configuration") then
					local lowerName = desc.Name:lower()
					for _, kw in ipairs(keywords) do
						if lowerName:find(kw) then
							return desc
						end
					end
				end
			end
		end
	end
	return nil
end

local function findTargetUnitModel(rootPos, ignoreChar, filterName)
	local bestModel = nil
	local bestDist = math.huge

	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("Model") and obj ~= ignoreChar and not Players:GetPlayerFromCharacter(obj) then
			if obj:FindFirstChildOfClass("Humanoid") or obj.PrimaryPart then
				if filterName == "" or obj.Name == filterName then
					local pivotPos = obj.PrimaryPart and obj.PrimaryPart.Position
						or (obj:FindFirstChild("HumanoidRootPart") and obj.HumanoidRootPart.Position)
					if pivotPos then
						local dist = (pivotPos - rootPos).Magnitude
						if dist < bestDist then
							bestDist = dist
							bestModel = obj
						end
					end
				end
			end
		end
	end

	return bestModel
end

DupeBoxBtn.MouseButton1Click:Connect(function()
	local char = LocalPlayer.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not root then return end

	local unitName = DupeUnitBox.Text
	local targetModel = findTargetUnitModel(root.Position, char, unitName)
	local resolvedName = targetModel and targetModel.Name or (unitName ~= "" and unitName or nil)

	if not resolvedName then
		DupeBoxBtn.Text = "ไม่พบยูนิต"
		task.delay(1.2, function()
			DupeBoxBtn.Text = "ดูปยูนิต"
		end)
		return
	end

	local invFolder = findUnitInventoryFolder()
	if not invFolder then
		invFolder = LocalPlayer:FindFirstChild("UnitBox") or Instance.new("Folder")
		if not invFolder.Parent then
			invFolder.Name = "UnitBox"
			invFolder.Parent = LocalPlayer
		end
	end

	if targetModel then
		local clonedUnit = targetModel:Clone()
		clonedUnit.Name = resolvedName .. "_Duped"
		clonedUnit.Parent = invFolder
	else
		local entry = Instance.new("StringValue")
		entry.Name = resolvedName .. "_Duped"
		entry.Value = resolvedName
		entry.Parent = invFolder
	end

	DupeBoxBtn.Text = "เข้ากล่องแล้ว"
	DupeBoxBtn.BackgroundColor3 = Theme.Success
	task.delay(1.4, function()
		DupeBoxBtn.Text = "ดูปยูนิต"
		DupeBoxBtn.BackgroundColor3 = Theme.Accent
	end)
end)
