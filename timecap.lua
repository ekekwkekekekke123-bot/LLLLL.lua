--[[
	timecap.lua — 抓游戏倒计时标签（独立脚本，不动 wx / mm2）
	用法：进游戏（最好回合进行中）→ 跑脚本 → 点「开始抓取(15秒)」→ 等它跑完 → 翻页看结果
	它做两件事：
	  1) 立刻列出所有"长得像倒计时"的文字（M:SS 或纯数字）；
	  2) 15 秒内持续观察所有文字标签，把"会变化"的挑出来 —— 真正的倒计时一定每秒都在变。
	结果每行：变化次数 | 当前文字 | 名字 [类] | 父级链 | 位置
	把「变化次数最多」的那几行发我，我按真实名字/路径去读。
]]

local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer

local logs = {}
local page = 1
local PER = 10
local capturing = false
local capEnd = 0
local watch = {}      -- [inst] = {txt=..., n=0, t=os.clock()}
local watched = 0

local function parent()
	local ok, h = pcall(function() return gethui() end)
	if ok and typeof(h) == "Instance" then return h end
	local ok2, c = pcall(function() return game:GetService("CoreGui") end)
	if ok2 and typeof(c) == "Instance" then return c end
	return LP:WaitForChild("PlayerGui")
end
local function B(cls, props) local o = Instance.new(cls) for k, v in pairs(props) do o[k] = v end return o end

local gui = B("ScreenGui", {Name="timecap", ResetOnSpawn=false, IgnoreGuiInset=true, DisplayOrder=999995, Parent=parent()})
local frm = B("Frame", {Size=UDim2.fromOffset(340, 300), Position=UDim2.fromOffset(14, 120), BackgroundColor3=Color3.fromRGB(16,17,21), BorderSizePixel=0, Active=true, Parent=gui})
local cr = Instance.new("UICorner") cr.CornerRadius = UDim.new(0,8) cr.Parent = frm
local bar = B("Frame", {Size=UDim2.new(1,0,0,24), BackgroundColor3=Color3.fromRGB(38,40,48), BorderSizePixel=0, Parent=frm})
local cb = Instance.new("UICorner") cb.CornerRadius = UDim.new(0,8) cb.Parent = bar
B("TextLabel", {Size=UDim2.new(1,-60,1,0), Position=UDim2.fromOffset(10,0), BackgroundTransparency=1, Text="倒计时标签抓取", Font=Enum.Font.GothamBold, TextSize=12, TextColor3=Color3.fromRGB(235,235,240), TextXAlignment=Enum.TextXAlignment.Left, Parent=bar})
local cls = B("TextButton", {Size=UDim2.fromOffset(24,18), Position=UDim2.new(1,-30,0,3), BackgroundColor3=Color3.fromRGB(58,60,70), BorderSizePixel=0, Text="×", Font=Enum.Font.GothamBold, TextSize=13, TextColor3=Color3.fromRGB(235,235,240), Parent=bar})
cls.MouseButton1Click:Connect(function() gui:Destroy() end)

local stat = B("TextLabel", {Size=UDim2.new(1,-20,0,16), Position=UDim2.fromOffset(10,30), BackgroundTransparency=1, Text="状态：待机（回合进行中最好）", Font=Enum.Font.GothamMedium, TextSize=10, TextColor3=Color3.fromRGB(150,220,170), TextXAlignment=Enum.TextXAlignment.Left, Parent=frm})

local body = B("Frame", {Size=UDim2.new(1,-20,1,-104), Position=UDim2.fromOffset(10,96), BackgroundColor3=Color3.fromRGB(24,25,30), BorderSizePixel=0, ClipsDescendants=true, Parent=frm})
local bc = Instance.new("UICorner") bc.CornerRadius = UDim.new(0,6) bc.Parent = body
local txt = B("TextLabel", {Size=UDim2.new(1,-12,1,-8), Position=UDim2.fromOffset(6,4), BackgroundTransparency=1, Text="", Font=Enum.Font.Code, TextSize=8, TextWrapped=true, TextXAlignment=Enum.TextXAlignment.Left, TextYAlignment=Enum.TextYAlignment.Top, TextColor3=Color3.fromRGB(200,210,220), Parent=body})
local pageLbl = B("TextLabel", {Size=UDim2.fromOffset(56,20), Position=UDim2.fromOffset(276,52), BackgroundTransparency=1, Text="1/1", Font=Enum.Font.GothamMedium, TextSize=10, TextColor3=Color3.fromRGB(200,200,210), Parent=frm})

local function render()
	local pages = math.max(1, math.ceil(#logs / PER))
	if page > pages then page = pages end
	if page < 1 then page = 1 end
	local s = {}
	local start = #logs - (pages - page) * PER - PER + 1
	if start < 1 then start = 1 end
	for i = start, math.min(#logs, start + PER - 1) do s[#s+1] = logs[i] end
	txt.Text = (#s == 0) and "（点「开始抓取」）" or table.concat(s, "\n")
	pageLbl.Text = page .. "/" .. pages
end
local function add(l)
	logs[#logs+1] = l
	if #logs > 400 then table.remove(logs, 1) end
	page = math.max(1, math.ceil(#logs / PER))
	render()
end
local function mkBtn(x, y, w, text, color, cbFn)
	local b = B("TextButton", {Size=UDim2.fromOffset(w,24), Position=UDim2.fromOffset(x,y), BackgroundColor3=color, BorderSizePixel=0, Text=text, Font=Enum.Font.GothamBold, TextSize=10, TextColor3=Color3.new(1,1,1), Parent=frm})
	b.MouseButton1Click:Connect(function() pcall(cbFn) end)
	return b
end

local function roots()
	local t = {}
	local a = LP:FindFirstChild("PlayerGui")
	if a then t[#t+1] = a end
	local ok, h = pcall(function() return gethui() end)
	if ok and typeof(h) == "Instance" then t[#t+1] = h end
	local ok2, c = pcall(function() return game:GetService("CoreGui") end)
	if ok2 and typeof(c) == "Instance" then t[#t+1] = c end
	return t
end

local function pathOf(o)
	local parts = {}
	local p = o
	for _ = 1, 5 do
		if not p or p == game then break end
		parts[#parts+1] = tostring(p.Name)
		p = p.Parent
	end
	local rev = {}
	for i = #parts, 1, -1 do rev[#rev+1] = parts[i] end
	return table.concat(rev, "/")
end

local function looksLikeTime(t)
	return (string.match(t, "^%s*%d+:%d%d%s*$") ~= nil) or (string.match(t, "^%s*%d%d?%d?%s*$") ~= nil)
end

local function collect()
	local n = 0
	for _, root in ipairs(roots()) do
		pcall(function()
			for _, d in ipairs(root:GetDescendants()) do
				if (d:IsA("TextLabel") or d:IsA("TextButton")) and d.Text ~= "" then
					local t = tostring(d.Text)
					if looksLikeTime(t) then
						watch[d] = { txt = t, n = 0 }
						n = n + 1
						if n <= 25 then
							add(string.format("候选 %s | %s [%s] | %s | 位置%.0f,%.0f", t, tostring(d.Name), d.ClassName, pathOf(d), d.AbsolutePosition.X, d.AbsolutePosition.Y))
						end
					end
				end
			end
		end)
	end
	watched = n
	add(string.format("=== 初次扫描：%d 个像时间的标签 ===", n))
end

mkBtn(10, 50, 150, "开始抓取(15秒)", Color3.fromRGB(46,110,70), function()
	watch = {}
	logs = {} page = 1
	collect()
	if watched == 0 then
		-- 没找到像时间的，就把所有文字标签都盯上（有可能会变的是计时）
		for _, root in ipairs(roots()) do
			pcall(function()
				for _, d in ipairs(root:GetDescendants()) do
					if (d:IsA("TextLabel") or d:IsA("TextButton")) and d.Text ~= "" then
						watch[d] = { txt = tostring(d.Text), n = 0 }
					end
				end
			end)
		end
		add("没有像时间的标签，改为盯住全部文字标签")
	end
	capturing = true
	capEnd = os.clock() + 15
	stat.Text = "状态：抓取中…（15 秒）"
end)

mkBtn(166, 50, 40, "<", Color3.fromRGB(70,70,80), function() page = page - 1 render() end)
mkBtn(210, 50, 40, ">", Color3.fromRGB(70,70,80), function() page = page + 1 render() end)
mkBtn(10, 76, 150, "清空", Color3.fromRGB(70,70,80), function() logs = {} page = 1 render() end)
mkBtn(166, 76, 90, "再扫一次", Color3.fromRGB(60,90,130), function() collect() end)

RS.Heartbeat:Connect(function()
	if not capturing then return end
	local now = os.clock()
	for inst, rec in pairs(watch) do
		if inst and inst.Parent then
			local t = tostring(inst.Text)
			if t ~= rec.txt then
				rec.txt = t
				rec.n = (rec.n or 0) + 1
			end
		end
	end
	if now > capEnd then
		capturing = false
		local list = {}
		for inst, rec in pairs(watch) do
			if rec.n and rec.n > 0 then list[#list+1] = {inst = inst, rec = rec} end
		end
		table.sort(list, function(a, b) return a.rec.n > b.rec.n end)
		add(string.format("=== 15 秒内会变化的标签：%d 个（按变化次数排序） ===", #list))
		for i = 1, math.min(#list, 20) do
			local it = list[i]
			local d = it.inst
			add(string.format("%d次 | %s | %s | %s | 位置%.0f,%.0f",
				it.rec.n, tostring(d.Text), tostring(d.Name), pathOf(d),
				(d.Parent and d.AbsolutePosition.X or 0), (d.Parent and d.AbsolutePosition.Y or 0)))
		end
		stat.Text = "状态：抓取完成（变化最多的在最上面）"
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
