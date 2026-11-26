--[[
	gunsweep.lua — 掉落枪 / 判定盒扫描器（独立脚本，不动 wx / mm2）
	用法：
	  1) 跑脚本（面板可拖动）
	  2) 「扫描一次」：把场上所有像枪的实例列出来（名字/类/尺寸/透明度/碰/触/锚/距离/父级/内含提示器）
	  3) 「监视10秒」：这 10 秒里新出现的枪和部件会被实时记录（掉枪是动态生成的，用这个抓）
	  4) 「画框」：给扫到的部件套绿框，你能直接看到是哪一个
	日志行示例：
	  [G] Gun [Model] 父:workspace ▶ProximityPrompt
	  [G] Handle [Part] 1.0,0.6,0.4 透0.00 碰true 触true 锚false 距12 父:Gun
]]

local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer

local logs, page, PER, MAXL = {}, 1, 12, 400
local watching, watchEnd = false, 0
local drawBoxes = false
local boxes = {}
local seen = {}

local GUN_PAT = {"gun", "shoot", "fire", "shot", "pistol", "revolver", "weapon", "fusil", "pompe", "beretta", "deagle", "rifle", "smg", "枪"}
local function isGunName(s)
	local l = string.lower(tostring(s or ""))
	for i = 1, #GUN_PAT do
		if string.find(l, GUN_PAT[i], 1, true) then return true end
	end
	return false
end

local function parent()
	local ok, h = pcall(function() return gethui() end)
	if ok and typeof(h) == "Instance" then return h end
	local ok2, c = pcall(function() return game:GetService("CoreGui") end)
	if ok2 and typeof(c) == "Instance" then return c end
	return LP:WaitForChild("PlayerGui")
end
local function B(cls, props) local o = Instance.new(cls) for k, v in pairs(props) do o[k] = v end return o end

local gui = B("ScreenGui", {Name="gunsweep", ResetOnSpawn=false, IgnoreGuiInset=true, DisplayOrder=999996, Parent=parent()})
local frm = B("Frame", {Size=UDim2.fromOffset(336, 322), Position=UDim2.fromOffset(14, 120), BackgroundColor3=Color3.fromRGB(16,17,21), BorderSizePixel=0, Active=true, Parent=gui})
local cr = Instance.new("UICorner") cr.CornerRadius = UDim.new(0,8) cr.Parent = frm
local bar = B("Frame", {Size=UDim2.new(1,0,0,24), BackgroundColor3=Color3.fromRGB(38,40,48), BorderSizePixel=0, Parent=frm})
local cb = Instance.new("UICorner") cb.CornerRadius = UDim.new(0,8) cb.Parent = bar
B("TextLabel", {Size=UDim2.new(1,-60,1,0), Position=UDim2.fromOffset(10,0), BackgroundTransparency=1, Text="掉落枪 / 判定盒扫描", Font=Enum.Font.GothamBold, TextSize=12, TextColor3=Color3.fromRGB(235,235,240), TextXAlignment=Enum.TextXAlignment.Left, Parent=bar})
local cls = B("TextButton", {Size=UDim2.fromOffset(24,18), Position=UDim2.new(1,-30,0,3), BackgroundColor3=Color3.fromRGB(58,60,70), BorderSizePixel=0, Text="×", Font=Enum.Font.GothamBold, TextSize=13, TextColor3=Color3.fromRGB(235,235,240), Parent=bar})
cls.MouseButton1Click:Connect(function() gui:Destroy() end)

local stat = B("TextLabel", {Size=UDim2.new(1,-20,0,16), Position=UDim2.fromOffset(10,30), BackgroundTransparency=1, Text="状态：待机", Font=Enum.Font.GothamMedium, TextSize=10, TextColor3=Color3.fromRGB(150,220,170), TextXAlignment=Enum.TextXAlignment.Left, Parent=frm})

local body = B("Frame", {Size=UDim2.new(1,-20,1,-104), Position=UDim2.fromOffset(10,96), BackgroundColor3=Color3.fromRGB(24,25,30), BorderSizePixel=0, ClipsDescendants=true, Parent=frm})
local bc = Instance.new("UICorner") bc.CornerRadius = UDim.new(0,6) bc.Parent = body
local txt = B("TextLabel", {Size=UDim2.new(1,-12,1,-8), Position=UDim2.fromOffset(6,4), BackgroundTransparency=1, Text="", Font=Enum.Font.Code, TextSize=8, TextWrapped=true, TextXAlignment=Enum.TextXAlignment.Left, TextYAlignment=Enum.TextYAlignment.Top, TextColor3=Color3.fromRGB(200,210,220), Parent=body})
local pageLbl = B("TextLabel", {Size=UDim2.fromOffset(56,20), Position=UDim2.fromOffset(272,52), BackgroundTransparency=1, Text="1/1", Font=Enum.Font.GothamMedium, TextSize=10, TextColor3=Color3.fromRGB(200,200,210), Parent=frm})

local function render()
	local pages = math.max(1, math.ceil(#logs / PER))
	if page > pages then page = pages end
	if page < 1 then page = 1 end
	local s = {}
	local start = #logs - (pages - page) * PER - PER + 1
	if start < 1 then start = 1 end
	for i = start, math.min(#logs, start + PER - 1) do s[#s+1] = logs[i] end
	txt.Text = (#s == 0) and "（点「扫描一次」）" or table.concat(s, "\n")
	pageLbl.Text = page .. "/" .. pages
end
local function add(l)
	logs[#logs+1] = l
	if #logs > MAXL then table.remove(logs, 1) end
	page = math.max(1, math.ceil(#logs / PER))
	render()
end
local function mkBtn(x, y, w, text, color, cbFn)
	local b = B("TextButton", {Size=UDim2.fromOffset(w,24), Position=UDim2.fromOffset(x,y), BackgroundColor3=color, BorderSizePixel=0, Text=text, Font=Enum.Font.GothamBold, TextSize=10, TextColor3=Color3.new(1,1,1), Parent=frm})
	b.MouseButton1Click:Connect(function() pcall(cbFn) end)
	return b
end

local function myPos()
	local c = LP.Character
	local r = c and (c:FindFirstChild("HumanoidRootPart") or c.PrimaryPart)
	return r and r.Position or nil
end

local function extras(inst)
	local out = {}
	pcall(function()
		for _, d in ipairs(inst:GetDescendants()) do
			local cn = d.ClassName
			if cn == "ProximityPrompt" or cn == "ClickDetector" or cn == "TouchTransmitter" then out[#out+1] = cn end
		end
	end)
	if #out == 0 then return "" end
	return " ▶" .. table.concat(out, "/")
end

local function addBox(p)
	if not drawBoxes or boxes[p] then return end
	local bg = B("BillboardGui", {Name="gs_box", Size=UDim2.fromOffset(20,20), AlwaysOnTop=true, LightInfluence=0, Parent=p})
	local fr = B("Frame", {Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Parent=bg})
	local st = Instance.new("UIStroke") st.Color = Color3.fromRGB(90,255,120) st.Thickness = 1.5 st.Parent = fr
	B("TextLabel", {Size=UDim2.new(1,0,0,10), Position=UDim2.new(0,0,0,-11), BackgroundTransparency=1, Text=tostring(p.Name), Font=Enum.Font.GothamBold, TextSize=8, TextColor3=Color3.fromRGB(90,255,120), Parent=bg})
	boxes[p] = bg
end

local function clearBoxes()
	for p, g in pairs(boxes) do pcall(function() g:Destroy() end) boxes[p] = nil end
end

local function isGunLike(inst)
	local ok, d = pcall(function() return inst:IsDescendantOf(workspace) end)
	if not ok or not d then return false end
	if isGunName(inst.Name) then return true end
	if inst:IsA("BasePart") then
		local p = inst.Parent
		for _ = 1, 3 do
			if not p or p == workspace then break end
			if isGunName(p.Name) then return true end
			p = p.Parent
		end
	end
	return false
end

local function report(inst, tag)
	local key = tostring(inst)
	if seen[key] then return end
	seen[key] = true
	local line
	if inst:IsA("BasePart") then
		local me = myPos()
		local ds = ""
		if me then
			local ok, dd = pcall(function() return (inst.Position - me).Magnitude end)
			if ok then ds = string.format(" 距%.0f", dd) end
		end
		line = string.format("%s %s [%s] %.1f,%.1f,%.1f 透%.2f 碰%s 触%s 锚%s%s 父:%s%s",
			tag, tostring(inst.Name), inst.ClassName, inst.Size.X, inst.Size.Y, inst.Size.Z, inst.Transparency,
			tostring(inst.CanCollide), tostring(inst.CanTouch), tostring(inst.Anchored), ds,
			tostring(inst.Parent and inst.Parent.Name), extras(inst))
		addBox(inst)
	else
		line = string.format("%s %s [%s] 父:%s%s", tag, tostring(inst.Name), inst.ClassName, tostring(inst.Parent and inst.Parent.Name), extras(inst))
	end
	add(line)
end

local function scanOnce()
	seen = {}
	local n = 0
	add("=== 扫描开始 ===")
	pcall(function()
		for _, d in ipairs(workspace:GetDescendants()) do
			if d and isGunLike(d) then
				report(d, "[G]")
				n = n + 1
				if n > 120 then break end
			end
		end
	end)
	stat.Text = "状态：扫描完成，共 " .. n .. " 条"
end

local function startWatch()
	watching = true
	watchEnd = os.clock() + 10
	seen = {}
	add("=== 开始监视 10 秒（现在让枪掉出来） ===")
	stat.Text = "状态：监视中…"
end

mkBtn(10, 50, 96, "扫描一次", Color3.fromRGB(46,110,70), scanOnce)
mkBtn(112, 50, 108, "监视10秒", Color3.fromRGB(46,110,70), startWatch)
mkBtn(226, 50, 34, "<", Color3.fromRGB(70,70,80), function() page = page - 1 render() end)
mkBtn(264, 50, 34, ">", Color3.fromRGB(70,70,80), function() page = page + 1 render() end)
local boxBtn = mkBtn(10, 76, 96, "画框：关", Color3.fromRGB(70,70,80), function()
	drawBoxes = not drawBoxes
	boxBtn.Text = drawBoxes and "画框：开" or "画框：关"
	boxBtn.BackgroundColor3 = drawBoxes and Color3.fromRGB(46,110,70) or Color3.fromRGB(70,70,80)
	if not drawBoxes then clearBoxes() end
end)
mkBtn(112, 76, 108, "清空", Color3.fromRGB(70,70,80), function() logs = {} page = 1 render() end)

workspace.DescendantAdded:Connect(function(d)
	if not watching or not d then return end
	if isGunLike(d) then report(d, "[NEW]") end
end)

RS.Heartbeat:Connect(function()
	if watching and os.clock() > watchEnd then
		watching = false
		add("=== 监视结束 ===")
		stat.Text = "状态：监视结束（翻页看新出现的）"
	end
end)

local dragging, dStart, pStart = false, nil, nil
bar.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
		dragging = true dStart = i.Position pStart = frm.Position
	end
end)
UIS.InputChanged:Connect(function(i)
	if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
		local d = i.Position - dStart
		frm.Position = UDim2.fromOffset(pStart.X.Offset + d.X, pStart.Y.Offset + d.Y)
	end
end)
UIS.InputEnded:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)

render()
