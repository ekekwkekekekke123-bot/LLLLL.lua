--[[
	flingdiag.lua — 甩飞测距仪（独立脚本，不改 wx / mm2）
	用途：甩飞进行时，逐帧记录"你"和"最近那个玩家"的真实坐标与距离，
	     并检测瞬移有没有被服务端顶回来（snapback），把最小值/平均值打在屏幕上。
	原理：你自己看到的是本地模拟结果；别人看到的是服务端同步结果。
	     如果本地距离 ~0 而服务端把你拉回 4~6 格，表现就是"我看贴合了，别人看没贴上"。
	     这个脚本只能读客户端数据，所以它测的是"本地实际距离"和"瞬移后有没有被拉回"。
]]

local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer

local ST = { rec=false, tEnd=0, n=0, dmin=1e9, dsum=0, tname="", last=nil, jump=0, snap=0, touch=0, tmove=0, tmovn=0 }

local function parent()
	local ok, h = pcall(function() return gethui() end)
	if ok and typeof(h) == "Instance" then return h end
	local ok2, c = pcall(function() return game:GetService("CoreGui") end)
	if ok2 and typeof(c) == "Instance" then return c end
	return LP:WaitForChild("PlayerGui")
end

local function B(cls, props)
	local o = Instance.new(cls)
	for k, v in pairs(props) do o[k] = v end
	return o
end

local gui = B("ScreenGui", {Name="flingdiag", ResetOnSpawn=false, IgnoreGuiInset=true, DisplayOrder=999999, Parent=parent()})
local frm = B("Frame", {Size=UDim2.fromOffset(268, 196), Position=UDim2.fromOffset(14, 150), BackgroundColor3=Color3.fromRGB(18,18,22), BorderSizePixel=0, Active=true, Parent=gui})
local cr = Instance.new("UICorner") cr.CornerRadius = UDim.new(0, 8) cr.Parent = frm

local bar = B("Frame", {Size=UDim2.new(1,0,0,24), BackgroundColor3=Color3.fromRGB(38,40,48), BorderSizePixel=0, Parent=frm})
local cb = Instance.new("UICorner") cb.CornerRadius = UDim.new(0, 8) cb.Parent = bar

local ttl = B("TextLabel", {Size=UDim2.new(1,-60,1,0), Position=UDim2.fromOffset(10,0), BackgroundTransparency=1, Text="甩飞测距仪", Font=Enum.Font.GothamBold, TextSize=12, TextColor3=Color3.fromRGB(235,235,240), TextXAlignment=Enum.TextXAlignment.Left, Parent=bar})
local cls = B("TextButton", {Size=UDim2.fromOffset(24,18), Position=UDim2.new(1,-30,0,3), BackgroundColor3=Color3.fromRGB(58,60,70), BorderSizePixel=0, Text="×", Font=Enum.Font.GothamBold, TextSize=13, TextColor3=Color3.fromRGB(235,235,240), Parent=bar})
cls.MouseButton1Click:Connect(function() gui:Destroy() end)

local st1 = B("TextLabel", {Size=UDim2.new(1,-20,0,16), Position=UDim2.fromOffset(10,30), BackgroundTransparency=1, Text="状态：等待瞬移（甩飞会自动开始记录）", Font=Enum.Font.GothamMedium, TextSize=10, TextColor3=Color3.fromRGB(150,220,170), TextXAlignment=Enum.TextXAlignment.Left, Parent=frm})
local st2 = B("TextLabel", {Size=UDim2.new(1,-20,0,16), Position=UDim2.fromOffset(10,48), BackgroundTransparency=1, Text="实时：-", Font=Enum.Font.GothamMedium, TextSize=10, TextColor3=Color3.fromRGB(220,220,228), TextXAlignment=Enum.TextXAlignment.Left, Parent=frm})
local st3 = B("TextLabel", {Size=UDim2.new(1,-20,0,16), Position=UDim2.fromOffset(10,66), BackgroundTransparency=1, Text="本帧拉回：-", Font=Enum.Font.GothamMedium, TextSize=10, TextColor3=Color3.fromRGB(220,220,228), TextXAlignment=Enum.TextXAlignment.Left, Parent=frm})
local st4 = B("TextLabel", {Size=UDim2.new(1,-20,0,58), Position=UDim2.fromOffset(10,86), BackgroundTransparency=1, Text="结果：还没有记录", Font=Enum.Font.GothamMedium, TextSize=10, TextWrapped=true, TextYAlignment=Enum.TextYAlignment.Top, TextColor3=Color3.fromRGB(255,220,150), TextXAlignment=Enum.TextXAlignment.Left, Parent=frm})

local manual = B("TextButton", {Size=UDim2.fromOffset(120,24), Position=UDim2.fromOffset(10,150), BackgroundColor3=Color3.fromRGB(46,110,70), BorderSizePixel=0, Text="手动记录 2 秒", Font=Enum.Font.GothamBold, TextSize=10, TextColor3=Color3.new(1,1,1), Parent=frm})
local cbtn = B("TextButton", {Size=UDim2.fromOffset(100,24), Position=UDim2.fromOffset(140,150), BackgroundColor3=Color3.fromRGB(70,70,80), BorderSizePixel=0, Text="清空结果", Font=Enum.Font.GothamBold, TextSize=10, TextColor3=Color3.new(1,1,1), Parent=frm})

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

local function myHrp()
	local c = LP.Character
	if not c then return nil end
	return c:FindFirstChild("HumanoidRootPart") or c.PrimaryPart
end

local function nearest()
	local me = myHrp()
	if not me then return nil, nil end
	local best, bd, bname = nil, 1e9, ""
	for _, pl in ipairs(Players:GetPlayers()) do
		if pl ~= LP then
			local c = pl.Character
			local h = c and (c:FindFirstChild("HumanoidRootPart") or c.PrimaryPart)
			if h then
				local d = (h.Position - me.Position).Magnitude
				if d < bd then bd = d best = h bname = pl.Name end
			end
		end
	end
	return best, bd, bname
end

local function reset()
	ST.rec=false ST.n=0 ST.dmin=1e9 ST.dsum=0 ST.tname="" ST.touch=0 ST.tmove=0 ST.tmovn=0
	st4.Text = "结果：还没有记录"
end

local function startRec(secs)
	reset()
	ST.rec = true
	ST.tEnd = os.clock() + (secs or 2)
	st1.Text = "状态：记录中…"
end

manual.MouseButton1Click:Connect(function() startRec(2) end)
cbtn.MouseButton1Click:Connect(function() reset() st1.Text = "状态：等待瞬移（甩飞会自动开始记录）" end)

local lastMy, lastT = nil, nil

RS.RenderStepped:Connect(function()
	local me = myHrp()
	if not me then return end
	local cur, d, nm = nearest()

	-- 本帧位移（判断瞬移/被拉回都用它）
	if ST.last and me then
		ST.snap = (me.Position - ST.last).Magnitude
	end

	-- 检测瞬移：一帧内自己位置跳 > 30 格 → 认为在甩飞，自动开始记录
	if lastMy then
		local jump = (me.Position - lastMy).Magnitude
		ST.jump = jump
		if jump > 30 and not ST.rec then startRec(2) end
	end
	lastMy = me.Position

	-- 目标的移动速度（判断延迟/他在跑）
	if cur and lastT then
		local mv = (cur.Position - lastT).Magnitude * 60
		ST.tmove = ST.tmove + mv
		ST.tmovn = ST.tmovn + 1
	end
	lastT = cur and cur.Position or nil

	if ST.rec and cur then
		ST.n = ST.n + 1
		ST.dsum = ST.dsum + d
		if d < ST.dmin then ST.dmin = d ST.tname = nm end
		if d < 3 then ST.touch = ST.touch + 1 end
		-- 记录我这一帧"设过的位置"，下一帧用它算纠正量
		ST.last = me.Position
		if os.clock() > ST.tEnd then
			ST.rec = false
			local avg = (ST.n > 0) and (ST.dsum / ST.n) or 0
			local touchT = ST.touch / 60
			local tmv = (ST.tmovn > 0) and (ST.tmove / ST.tmovn) or 0
			st4.Text = string.format("结果：%d 帧\n最小距离 %.1f 格（%s）\n平均距离 %.1f 格\n贴合(<3格) %.2f 秒\n目标移动 %.0f 格/秒",
				ST.n, ST.dmin, ST.tname, avg, touchT, tmv)
			st1.Text = "状态：记录完成（按手动记录可再来一次）"
		end
	end

	if cur then
		st2.Text = string.format("实时：自己 %.0f,%.0f,%.0f ｜ %s 距 %.2f 格", me.Position.X, me.Position.Y, me.Position.Z, nm, d)
		st3.Text = string.format("本帧位移：%.2f 格（突然很大=瞬移或被抓回）", ST.snap)
	else
		st2.Text = "实时：附近没有别的玩家"
	end
end)
