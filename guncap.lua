--[[
	guncap.lua — 开枪链路抓取器（独立脚本，不动 wx / mm2）
	目的：搞清楚 MM2 的"枪打中人"到底是谁说了算。
	用法：跑本脚本 → 点「开始抓取(8秒)」→ 这 8 秒里正常开几枪（对着墙和对着人各开一次）→ 看面板日志。
	日志会记录：
	  · 客户端发给服务端的每个 remote（名字 + 参数，向量/实例会格式化）
	  · 服务端广播回来的 GunFired 之类事件
	如果开枪时出现 FireServer(起点, 终点) 这种带坐标的 remote → 说明命中位置由客户端指定，能伪造穿墙；
	如果只有"我开了一枪"这种无坐标通知 → 命中是服务端自己算的，那就得换思路。
]]

local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer

local MAXL = 200
local logs = {}
local capturing = false
local capEnd = 0

local function parent()
	local ok, h = pcall(function() return gethui() end)
	if ok and typeof(h) == "Instance" then return h end
	local ok2, c = pcall(function() return game:GetService("CoreGui") end)
	if ok2 and typeof(c) == "Instance" then return c end
	return LP:WaitForChild("PlayerGui")
end
local function B(cls, props) local o = Instance.new(cls) for k, v in pairs(props) do o[k] = v end return o end

local gui = B("ScreenGui", {Name="guncap", ResetOnSpawn=false, IgnoreGuiInset=true, DisplayOrder=999998, Parent=parent()})
local frm = B("Frame", {Size=UDim2.fromOffset(340, 300), Position=UDim2.fromOffset(14, 360), BackgroundColor3=Color3.fromRGB(16,17,21), BorderSizePixel=0, Active=true, Parent=gui})
local cr = Instance.new("UICorner") cr.CornerRadius = UDim.new(0,8) cr.Parent = frm
local bar = B("Frame", {Size=UDim2.new(1,0,0,24), BackgroundColor3=Color3.fromRGB(38,40,48), BorderSizePixel=0, Parent=frm})
local cb = Instance.new("UICorner") cb.CornerRadius = UDim.new(0,8) cb.Parent = bar
B("TextLabel", {Size=UDim2.new(1,-60,1,0), Position=UDim2.fromOffset(10,0), BackgroundTransparency=1, Text="开枪链路抓取", Font=Enum.Font.GothamBold, TextSize=12, TextColor3=Color3.fromRGB(235,235,240), TextXAlignment=Enum.TextXAlignment.Left, Parent=bar})
local cls = B("TextButton", {Size=UDim2.fromOffset(24,18), Position=UDim2.new(1,-30,0,3), BackgroundColor3=Color3.fromRGB(58,60,70), BorderSizePixel=0, Text="×", Font=Enum.Font.GothamBold, TextSize=13, TextColor3=Color3.fromRGB(235,235,240), Parent=bar})
cls.MouseButton1Click:Connect(function() gui:Destroy() end)

local status = B("TextLabel", {Size=UDim2.new(1,-20,0,16), Position=UDim2.fromOffset(10,30), BackgroundTransparency=1, Text="状态：待机", Font=Enum.Font.GothamMedium, TextSize=10, TextColor3=Color3.fromRGB(150,220,170), TextXAlignment=Enum.TextXAlignment.Left, Parent=frm})

local goBtn = B("TextButton", {Size=UDim2.fromOffset(120,26), Position=UDim2.fromOffset(10,50), BackgroundColor3=Color3.fromRGB(46,110,70), BorderSizePixel=0, Text="开始抓取(8秒)", Font=Enum.Font.GothamBold, TextSize=10, TextColor3=Color3.new(1,1,1), Parent=frm})
local clrBtn = B("TextButton", {Size=UDim2.fromOffset(70,26), Position=UDim2.fromOffset(136,50), BackgroundColor3=Color3.fromRGB(70,70,80), BorderSizePixel=0, Text="清空", Font=Enum.Font.GothamBold, TextSize=10, TextColor3=Color3.new(1,1,1), Parent=frm})
local prevBtn = B("TextButton", {Size=UDim2.fromOffset(30,26), Position=UDim2.fromOffset(212,50), BackgroundColor3=Color3.fromRGB(70,70,80), BorderSizePixel=0, Text="<", Font=Enum.Font.GothamBold, TextSize=11, TextColor3=Color3.new(1,1,1), Parent=frm})
local nextBtn = B("TextButton", {Size=UDim2.fromOffset(30,26), Position=UDim2.fromOffset(246,50), BackgroundColor3=Color3.fromRGB(70,70,80), BorderSizePixel=0, Text=">", Font=Enum.Font.GothamBold, TextSize=11, TextColor3=Color3.new(1,1,1), Parent=frm})
local pageLbl = B("TextLabel", {Size=UDim2.fromOffset(56,26), Position=UDim2.fromOffset(280,50), BackgroundTransparency=1, Text="1/1", Font=Enum.Font.GothamMedium, TextSize=10, TextColor3=Color3.fromRGB(200,200,210), Parent=frm})

local body = B("Frame", {Size=UDim2.new(1,-20,1,-90), Position=UDim2.fromOffset(10,82), BackgroundColor3=Color3.fromRGB(24,25,30), BorderSizePixel=0, ClipsDescendants=true, Parent=frm})
local bc = Instance.new("UICorner") bc.CornerRadius = UDim.new(0,6) bc.Parent = body
local txtLbl = B("TextLabel", {Size=UDim2.new(1,-12,1,-8), Position=UDim2.fromOffset(6,4), BackgroundTransparency=1, Text="", Font=Enum.Font.Code, TextSize=9, TextWrapped=true, TextXAlignment=Enum.TextXAlignment.Left, TextYAlignment=Enum.TextYAlignment.Top, TextColor3=Color3.fromRGB(200,210,220), Parent=body})

local PER = 12
local page = 1
local function render()
	local pages = math.max(1, math.ceil(#logs / PER))
	if page > pages then page = pages end
	local s = {}
	local start = #logs - (pages - page) * PER - PER + 1
	if start < 1 then start = 1 end
	local stop = math.min(#logs, start + PER - 1)
	for i = start, stop do s[#s+1] = logs[i] end
	txtLbl.Text = (#s == 0) and "（还没有记录）" or table.concat(s, "\n")
	pageLbl.Text = page .. "/" .. pages
end

local function add(line)
	logs[#logs+1] = line
	if #logs > MAXL then table.remove(logs, 1) end
	if page >= math.max(1, math.ceil(#logs / PER)) then page = math.max(1, math.ceil(#logs / PER)) end
	render()
end

local function fmt(v)
	local t = typeof(v)
	if t == "Instance" then
		return "Inst:" .. v.ClassName .. "(" .. v.Name .. ")"
	elseif t == "Vector3" then
		return string.format("V3(%.1f,%.1f,%.1f)", v.X, v.Y, v.Z)
	elseif t == "CFrame" then
		local p = v.Position
		return string.format("CF(%.1f,%.1f,%.1f)", p.X, p.Y, p.Z)
	elseif t == "table" then
		return "tbl#" .. tostring(#v)
	end
	return tostring(v)
end

-- ===== 抓取：临时钩住 namecall，只在抓取窗口内记录 =====
local oldNC = nil
local hookOK = false
local function installHook()
	if oldNC then return true end
	local ok = pcall(function()
		local hookf = hookmetamethod
		local getm = getnamecallmethod
		local nc = newcclosure or function(f) return f end
		oldNC = hookf(game, "__namecall", nc(function(self, ...)
			local m = getm()
			if capturing and (m == "FireServer" or m == "InvokeServer") then
				local args = {...}
				local nm = tostring(self.Name)
				pcall(function()
					local parts = {}
					for i = 1, math.min(#args, 6) do parts[#parts+1] = fmt(args[i]) end
					add("-> " .. nm .. " :" .. m .. "(" .. table.concat(parts, " , ") .. ")")
				end)
			end
			return oldNC(self, ...)
		end))
	end)
	hookOK = ok
	return ok
end

local function restoreHook()
	if not oldNC then return end
	pcall(function() hookmetamethod(game, "__namecall", oldNC) end)
	oldNC = nil
end

-- 服务端广播（GunFired 等）
task.spawn(function()
	local rs = game:GetService("ReplicatedStorage")
	for _, d in ipairs(rs:GetDescendants()) do
		if d:IsA("RemoteEvent") then
			pcall(function()
				d.OnClientEvent:Connect(function(...)
					if not capturing then return end
					local args = {...}
					local parts = {}
					for i = 1, math.min(#args, 6) do parts[#parts+1] = fmt(args[i]) end
					add("← " .. tostring(d.Name) .. "(" .. table.concat(parts, " , ") .. ")")
				end)
			end)
		end
	end
end)

goBtn.MouseButton1Click:Connect(function()
	if capturing then return end
	local ok = installHook()
	status.Text = ok and "状态：抓取中（对着墙/人各开一枪）" or "状态：钩子安装失败（执行器不支持 hookmetamethod）"
	capturing = true
	capEnd = os.clock() + 8
	add("=== 开始抓取 ===")
end)

clrBtn.MouseButton1Click:Connect(function() logs = {} page = 1 render() end)
prevBtn.MouseButton1Click:Connect(function() page = math.max(1, page - 1) render() end)
nextBtn.MouseButton1Click:Connect(function() page = page + 1 render() end)

-- 拖动
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

RS.Heartbeat:Connect(function()
	if capturing and os.clock() > capEnd then
		capturing = false
		restoreHook()
		status.Text = "状态：抓取完成，翻页看日志"
		add("=== 抓取结束 ===")
	end
end)

render()
