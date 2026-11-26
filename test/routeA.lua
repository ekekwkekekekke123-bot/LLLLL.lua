--[[
	routeA.lua — 判定块吸附测试（独立测试脚本，不改 mm2 主脚本）
	目的：验证「完全不移动对方角色，只把一块归属他的隐形判定块搬到自己刀前」能否照样击杀。
	如果这个能砍死人 => 说明服务端不校验距离，主脚本可以做成"零视觉变化"的吸人。
	如果砍不死 => 说明服务端按真实坐标校验，只能老老实实把人拉过来（看得见那种）。
]]

local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer

local CFG = { on = false, size = 8, range = 30 }
local box, boxOwner, lastPick, statusText = nil, nil, 0, nil

-- ---------------- UI ----------------
local gui = Instance.new("ScreenGui")
gui.Name = "RouteATest"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
if not pcall(function() gui.Parent = game:GetService("CoreGui") end) then
	gui.Parent = LP:WaitForChild("PlayerGui")
end

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(250, 206)
frame.Position = UDim2.fromOffset(18, 120)
frame.BackgroundColor3 = Color3.fromRGB(26, 27, 32)
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

local bar = Instance.new("Frame")
bar.Size = UDim2.new(1, 0, 0, 26)
bar.BackgroundColor3 = Color3.fromRGB(40, 42, 50)
bar.BorderSizePixel = 0
bar.Parent = frame
Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -80, 1, 0)
title.Position = UDim2.fromOffset(10, 0)
title.BackgroundTransparency = 1
title.Text = "判定块吸附测试"
title.Font = Enum.Font.GothamBold
title.TextSize = 12
title.TextColor3 = Color3.fromRGB(235, 235, 240)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = bar

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(24, 20)
close.Position = UDim2.new(1, -30, 0, 3)
close.BackgroundColor3 = Color3.fromRGB(58, 60, 70)
close.BorderSizePixel = 0
close.Text = "×"
close.Font = Enum.Font.GothamBold
close.TextSize = 14
close.TextColor3 = Color3.fromRGB(235, 235, 240)
close.Parent = bar
Instance.new("UICorner", close).CornerRadius = UDim.new(0, 5)
close.MouseButton1Click:Connect(function() gui:Destroy() end)

local function makeRow(y, label)
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, -20, 0, 30)
	row.Position = UDim2.fromOffset(10, y)
	row.BackgroundColor3 = Color3.fromRGB(34, 35, 41)
	row.BorderSizePixel = 0
	row.Parent = frame
	Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)
	local lb = Instance.new("TextLabel")
	lb.Size = UDim2.new(1, -74, 1, 0)
	lb.Position = UDim2.fromOffset(8, 0)
	lb.BackgroundTransparency = 1
	lb.Text = label
	lb.Font = Enum.Font.GothamMedium
	lb.TextSize = 11
	lb.TextColor3 = Color3.fromRGB(220, 220, 228)
	lb.TextXAlignment = Enum.TextXAlignment.Left
	lb.Parent = row
	return row
end

-- 开关
local rowSw = makeRow(34, "吸判定块（隐形）")
local sw = Instance.new("TextButton")
sw.Size = UDim2.fromOffset(48, 20)
sw.Position = UDim2.new(1, -56, 0, 5)
sw.BackgroundColor3 = Color3.fromRGB(70, 70, 78)
sw.BorderSizePixel = 0
sw.Text = "关"
sw.Font = Enum.Font.GothamBold
sw.TextSize = 11
sw.TextColor3 = Color3.fromRGB(235, 235, 240)
sw.Parent = rowSw
Instance.new("UICorner", sw).CornerRadius = UDim.new(0, 5)

-- 块大小
local rowSz = makeRow(68, "块大小 1-40")
local tbSz = Instance.new("TextBox")
tbSz.Size = UDim2.fromOffset(54, 20)
tbSz.Position = UDim2.new(1, -62, 0, 5)
tbSz.BackgroundColor3 = Color3.fromRGB(52, 54, 62)
tbSz.BorderSizePixel = 0
tbSz.Text = tostring(CFG.size)
tbSz.Font = Enum.Font.GothamMedium
tbSz.TextSize = 11
tbSz.TextColor3 = Color3.fromRGB(235, 235, 240)
tbSz.ClearTextOnFocus = false
tbSz.Parent = rowSz
Instance.new("UICorner", tbSz).CornerRadius = UDim.new(0, 5)
tbSz:GetPropertyChangedSignal("Text"):Connect(function()
	local v = tonumber(tbSz.Text)
	if v then
		v = math.clamp(v, 1, 40)
		CFG.size = v
		if tostring(v) ~= tbSz.Text then tbSz.Text = tostring(v) end
	end
end)

-- 范围
local rowRg = makeRow(102, "选择范围 1-80")
local tbRg = Instance.new("TextBox")
tbRg.Size = UDim2.fromOffset(54, 20)
tbRg.Position = UDim2.new(1, -62, 0, 5)
tbRg.BackgroundColor3 = Color3.fromRGB(52, 54, 62)
tbRg.BorderSizePixel = 0
tbRg.Text = tostring(CFG.range)
tbRg.Font = Enum.Font.GothamMedium
tbRg.TextSize = 11
tbRg.TextColor3 = Color3.fromRGB(235, 235, 240)
tbRg.ClearTextOnFocus = false
tbRg.Parent = rowRg
Instance.new("UICorner", tbRg).CornerRadius = UDim.new(0, 5)
tbRg:GetPropertyChangedSignal("Text"):Connect(function()
	local v = tonumber(tbRg.Text)
	if v then
		v = math.clamp(v, 1, 80)
		CFG.range = v
		if tostring(v) ~= tbRg.Text then tbRg.Text = tostring(v) end
	end
end)

statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, -20, 0, 34)
statusText.Position = UDim2.fromOffset(10, 136)
statusText.BackgroundTransparency = 1
statusText.Text = "状态：待机"
statusText.Font = Enum.Font.GothamMedium
statusText.TextSize = 10
statusText.TextWrapped = true
statusText.TextXAlignment = Enum.TextXAlignment.Left
statusText.TextYAlignment = Enum.TextYAlignment.Top
statusText.TextColor3 = Color3.fromRGB(150, 200, 160)
statusText.Parent = frame

local tip = Instance.new("TextLabel")
tip.Size = UDim2.new(1, -20, 0, 26)
tip.Position = UDim2.fromOffset(10, 174)
tip.BackgroundTransparency = 1
tip.Text = "开开关后照常挥刀；对方原地不动就是对的"
tip.Font = Enum.Font.Gotham
tip.TextSize = 9
tip.TextWrapped = true
tip.TextXAlignment = Enum.TextXAlignment.Left
tip.TextColor3 = Color3.fromRGB(140, 140, 150)
tip.Parent = frame

-- 拖动
local dragging, dragStart, startPos = false, nil, nil
bar.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = i.Position
		startPos = frame.Position
	end
end)
UIS.InputChanged:Connect(function(i)
	if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
		local d = i.Position - dragStart
		frame.Position = UDim2.fromOffset(startPos.X.Offset + d.X, startPos.Y.Offset + d.Y)
	end
end)
UIS.InputEnded:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

-- ---------------- 核心 ----------------
local function myChar()
	local c = LP.Character
	if not c then return nil end
	local h = c:FindFirstChildOfClass("Humanoid")
	local r = c:FindFirstChild("HumanoidRootPart")
	if h and r then return c, h, r end
end

local function myKnife()
	local c = LP.Character
	if not c then return nil end
	local t = c:FindFirstChild("Knife") or c:FindFirstChild("knife")
	if t and t:IsA("Tool") then return t end
end

local function handleCF()
	local t = myKnife()
	local hd = t and (t:FindFirstChild("Handle") or t:FindFirstChild("Blade"))
	if hd and hd:IsA("BasePart") then return hd.CFrame end
	local _, _, r = myChar()
	if r then return r.CFrame * CFrame.new(0, 0, -2.4) end
end

local function aliveHrp(pl)
	local ch = pl and pl.Character
	if not ch then return nil end
	local tr = ch:FindFirstChild("HumanoidRootPart")
	local th = ch:FindFirstChildOfClass("Humanoid")
	if tr and th and th.Health > 0 then return tr end
end

local function pickNearest()
	local _, _, r = myChar()
	if not r then return nil end
	local best, bd = nil, math.huge
	for _, pl in ipairs(Players:GetPlayers()) do
		if pl ~= LP then
			local tr = aliveHrp(pl)
			if tr then
				local d = (tr.Position - r.Position).Magnitude
				if d <= CFG.range and d < bd then bd = d best = pl end
			end
		end
	end
	return best
end

local function dropBox()
	if box then pcall(function() box:Destroy() end) box = nil end
	boxOwner = nil
end

local function makeBox(pl)
	local ch = pl and pl.Character
	if not ch then return false end
	local p = Instance.new("Part")
	p.Name = "RootHitBox"
	p.Size = Vector3.new(CFG.size, CFG.size, CFG.size)
	p.Transparency = 1
	p.CanCollide = false
	p.CanQuery = false
	p.CanTouch = true
	p.Anchored = true
	p.Massless = true
	p.CastShadow = false
	p.CFrame = handleCF() or CFrame.new()
	if not pcall(function() p.Parent = ch end) then
		p:Destroy()
		return false
	end
	box = p
	boxOwner = pl
	return true
end

-- 开关
sw.MouseButton1Click:Connect(function()
	CFG.on = not CFG.on
	sw.Text = CFG.on and "开" or "关"
	sw.BackgroundColor3 = CFG.on and Color3.fromRGB(70, 150, 95) or Color3.fromRGB(70, 70, 78)
	if not CFG.on then dropBox() end
end)

-- 主循环
RS.RenderStepped:Connect(function()
	if not CFG.on then
		if box then dropBox() end
		return
	end
	local _, _, r = myChar()
	if not r then dropBox() return end

	local stillOK = false
	if box and box.Parent and boxOwner then
		local tr = aliveHrp(boxOwner)
		stillOK = (tr ~= nil)
	end
	if not stillOK then
		dropBox()
		local n = os.clock()
		if n - lastPick < 0.2 then return end
		lastPick = n
		local pl = pickNearest()
		if not pl then return end
		if not makeBox(pl) then return end
	end

	local cf = handleCF()
	if cf and box and box.Parent then
		pcall(function()
			box.Size = Vector3.new(CFG.size, CFG.size, CFG.size)
			box.CFrame = cf
		end)
	end
end)

-- 状态
task.spawn(function()
	while gui.Parent do
		task.wait(0.3)
		local _, _, r = myChar()
		local kn = myKnife()
		local line = "刀：" .. (kn and "有" or "无")
		if r then
			local pl = boxOwner
			if pl and aliveHrp(pl) then
				local tr = aliveHrp(pl)
				line = line .. "｜目标：" .. pl.Name .. " 真实距离" .. math.floor((tr.Position - r.Position).Magnitude) .. "格"
			else
				line = line .. "｜无目标"
			end
			line = line .. "｜块：" .. (box and "已吸附" or "无")
		end
		statusText.Text = "状态：" .. line
	end
end)
