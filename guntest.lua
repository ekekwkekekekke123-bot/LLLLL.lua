--[[
	guntest.lua v4 — 终点形态矩阵实验
	用法：自己是警长、装备 Gun
	  · 「切换模式」在 5 种落点形态之间循环（关 / 终点=HRP / 终点=头 / 终点=身体表面 / 起点终点都在他身上）
	  · 「视线诊断」告诉你：离目标多少格、枪口到目标之间有没有遮挡
	  · 「Activate开枪」已验证能真开枪 → 用这个打
	  一局只有一发子弹，测一个模式换一局，四种形态的结果一比就知道服务端校验什么。
	每枪输出：拦截 Shoot N 次 · 广播 M 次 · 血量 a→b
	  广播 0 次 = 这一枪被服务端丢了（参数不合规）
	  广播 ≥1 次但没掉血 = 服务端接受了这一枪，但判定没命中
]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer
local unpack = table.unpack or unpack

local logs = {}
local shootRem, gunFiredRem = nil, nil
local MODES = {
	{k = "off",     n = "关（原样）"},
	{k = "hrp",     n = "终点=身体HRP"},
	{k = "head",    n = "终点=头"},
	{k = "surface", n = "终点=身体朝我1.5格"},
	{k = "both",    n = "起点终点都在他身上"},
}
local mi = 1
local hookHits, broadcast = 0, 0
local target = nil
local hpBefore = 100
local oldNC = nil

local function modeKey() return MODES[mi].k end
local function modeName() return MODES[mi].n end

local function parent()
	local ok, h = pcall(function() return gethui() end)
	if ok and typeof(h) == "Instance" then return h end
	local ok2, c = pcall(function() return game:GetService("CoreGui") end)
	if ok2 and typeof(c) == "Instance" then return c end
	return LP:WaitForChild("PlayerGui")
end
local function B(cls, props) local o = Instance.new(cls) for k, v in pairs(props) do o[k] = v end return o end

local gui = B("ScreenGui", {Name="guntest4", ResetOnSpawn=false, IgnoreGuiInset=true, DisplayOrder=999997, Parent=parent()})
local frm = B("Frame", {Size=UDim2.fromOffset(320, 336), Position=UDim2.fromOffset(14, 160), BackgroundColor3=Color3.fromRGB(16,17,21), BorderSizePixel=0, Active=true, Parent=gui})
local cr = Instance.new("UICorner") cr.CornerRadius = UDim.new(0,8) cr.Parent = frm
local bar = B("Frame", {Size=UDim2.new(1,0,0,24), BackgroundColor3=Color3.fromRGB(38,40,48), BorderSizePixel=0, Parent=frm})
local cb = Instance.new("UICorner") cb.CornerRadius = UDim.new(0,8) cb.Parent = bar
B("TextLabel", {Size=UDim2.new(1,-60,1,0), Position=UDim2.fromOffset(10,0), BackgroundTransparency=1, Text="子弹实验 v4（终点矩阵）", Font=Enum.Font.GothamBold, TextSize=12, TextColor3=Color3.fromRGB(235,235,240), TextXAlignment=Enum.TextXAlignment.Left, Parent=bar})
local cls = B("TextButton", {Size=UDim2.fromOffset(24,18), Position=UDim2.new(1,-30,0,3), BackgroundColor3=Color3.fromRGB(58,60,70), BorderSizePixel=0, Text="×", Font=Enum.Font.GothamBold, TextSize=13, TextColor3=Color3.fromRGB(235,235,240), Parent=bar})
cls.MouseButton1Click:Connect(function() gui:Destroy() end)

local stat = B("TextLabel", {Size=UDim2.new(1,-20,0,16), Position=UDim2.fromOffset(10,30), BackgroundTransparency=1, Text="模式：" .. modeName(), Font=Enum.Font.GothamMedium, TextSize=10, TextColor3=Color3.fromRGB(255,220,150), TextXAlignment=Enum.TextXAlignment.Left, Parent=frm})

local body = B("Frame", {Size=UDim2.new(1,-20,1,-160), Position=UDim2.fromOffset(10,152), BackgroundColor3=Color3.fromRGB(24,25,30), BorderSizePixel=0, ClipsDescendants=true, Parent=frm})
local bc = Instance.new("UICorner") bc.CornerRadius = UDim.new(0,6) bc.Parent = body
local txt = B("TextLabel", {Size=UDim2.new(1,-12,1,-8), Position=UDim2.fromOffset(6,4), BackgroundTransparency=1, Text="", Font=Enum.Font.Code, TextSize=9, TextWrapped=true, TextXAlignment=Enum.TextXAlignment.Left, TextYAlignment=Enum.TextYAlignment.Top, TextColor3=Color3.fromRGB(200,210,220), Parent=body})

local function render()
	local s = {}
	for i = math.max(1, #logs - 14), #logs do s[#s+1] = logs[i] end
	txt.Text = (#s == 0) and "（先点「视线诊断」，再点「Activate开枪」）" or table.concat(s, "\n")
end
local function add(l) logs[#logs+1] = l if #logs > 200 then table.remove(logs,1) end render() end

local function mkBtn(x, y, w, text, color, cbFn)
	local b = B("TextButton", {Size=UDim2.fromOffset(w,24), Position=UDim2.fromOffset(x,y), BackgroundColor3=color, BorderSizePixel=0, Text=text, Font=Enum.Font.GothamBold, TextSize=10, TextColor3=Color3.new(1,1,1), Parent=frm})
	b.MouseButton1Click:Connect(function() pcall(cbFn) end)
	return b
end

local function findRemotes()
	shootRem, gunFiredRem = nil, nil
	local rs = game:GetService("ReplicatedStorage")
	for _, d in ipairs(rs:GetDescendants()) do
		if d:IsA("RemoteEvent") then
			local n = string.lower(d.Name)
			if n == "shoot" then shootRem = d end
			if n == "gunfired" then gunFiredRem = d end
		end
	end
	if not gunFiredRem then
		pcall(function()
			for _, d in ipairs(game:GetDescendants()) do
				if d:IsA("RemoteEvent") and string.lower(d.Name) == "gunfired" then gunFiredRem = d break end
			end
		end)
	end
	if gunFiredRem then
		pcall(function()
			gunFiredRem.OnClientEvent:Connect(function() broadcast = broadcast + 1 end)
		end)
	end
end

local function myChar() return LP.Character end
local function myGun()
	local c = myChar()
	local t = c and c:FindFirstChild("Gun")
	if t and t:IsA("Tool") then return t end
end
local function gunHandle()
	local g = myGun()
	if not g then return nil end
	local h = g:FindFirstChild("Handle") or g:FindFirstChild("Barrel") or g:FindFirstChild("Blade")
	if h and h:IsA("BasePart") then return h end
end
local function myHrp()
	local c = myChar()
	if not c then return nil end
	return c:FindFirstChild("HumanoidRootPart") or c.PrimaryPart
end
local function targetPart(pl)
	local c = pl and pl.Character
	if not c then return nil end
	return c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("Head")
end
local function targetHead(pl)
	local c = pl and pl.Character
	if not c then return nil end
	return c:FindFirstChild("Head") or c:FindFirstChild("HumanoidRootPart")
end
local function hpOf(pl)
	local c = pl and pl.Character
	local h = c and c:FindFirstChildOfClass("Humanoid")
	return h and h.Health or -1
end
local function nearest(maxd)
	local r = myHrp()
	if not r then return nil end
	local best, bd = nil, maxd or 400
	for _, pl in ipairs(Players:GetPlayers()) do
		if pl ~= LP and pl.Character then
			local tr = targetPart(pl)
			local th = pl.Character:FindFirstChildOfClass("Humanoid")
			if tr and th and th.Health > 0 then
				local d = (tr.Position - r.Position).Magnitude
				if d <= bd then bd = d best = pl end
			end
		end
	end
	return best
end

local function installHook()
	if oldNC then return true end
	local ok = pcall(function()
		local hookf = hookmetamethod
		local getm = getnamecallmethod
		local nc = newcclosure or function(f) return f end
		oldNC = hookf(game, "__namecall", nc(function(self, ...)
			local m = getm()
			if m == "FireServer" and typeof(self) == "Instance" and tostring(self.Name) == "Shoot" then
				hookHits = hookHits + 1
				local args = {...}
				local k = modeKey()
				if k ~= "off" and args[1] then
					local tr = targetPart(target)
					if tr then
						if k == "hrp" then
							return oldNC(self, args[1], CFrame.new(tr.Position))
						elseif k == "head" then
							local hd = targetHead(target)
							if hd then return oldNC(self, args[1], CFrame.new(hd.Position)) end
						elseif k == "surface" then
							local gp = gunHandle()
							local p0 = gp and gp.Position or (myHrp() and myHrp().Position)
							if p0 then
								local dir = (p0 - tr.Position)
								if dir.Magnitude > 0.01 then dir = dir.Unit else dir = Vector3.new(0,0,1) end
								return oldNC(self, args[1], CFrame.new(tr.Position + dir * 1.5))
							end
						elseif k == "both" then
							return oldNC(self, tr.CFrame * CFrame.new(0,0,2.5), CFrame.new(tr.Position))
						end
					end
				end
				return oldNC(self, unpack(args))
			end
			return oldNC(self, ...)
		end))
	end)
	return ok
end

local function report(secs)
	task.delay(secs or 1.1, function()
		local hpAfter = hpOf(target)
		local dealt = hpBefore - hpAfter
		add(string.format("  拦截 %d 次 · 广播 %d 次 · 血 %.0f→%.0f（掉 %.0f）", hookHits, broadcast, hpBefore, hpAfter, dealt))
		stat.Text = "模式：" .. modeName()
	end)
end

local function prep(label)
	findRemotes()
	hookHits, broadcast = 0, 0
	target = nearest(400)
	if not myGun() then add("✗ 手里没有 Gun（先装备）") return false end
	if not target then add("✗ 附近没有活人") return false end
	installHook()
	hpBefore = hpOf(target)
	add("== " .. label .. " · 模式:" .. modeName() .. " → " .. target.Name)
	return true
end

mkBtn(10, 50, 150, "切换模式", Color3.fromRGB(110,90,50), function()
	mi = mi + 1
	if mi > #MODES then mi = 1 end
	stat.Text = "模式：" .. modeName()
	add("模式 → " .. modeName())
end)

mkBtn(166, 50, 144, "视线诊断", Color3.fromRGB(60,90,130), function()
	findRemotes()
	target = nearest(400)
	if not target then add("✗ 附近没有活人") return end
	local tr = targetPart(target)
	local gp = gunHandle()
	local hr = myHrp()
	local p0 = gp and gp.Position or (hr and hr.Position)
	if not (tr and p0) then add("✗ 取不到坐标") return end
	local dist = (tr.Position - p0).Magnitude
	local rp = RaycastParams.new()
	rp.FilterType = Enum.RaycastFilterType.Exclude
	local fl = {LP.Character}
	if target.Character then fl[#fl+1] = target.Character end
	rp.FilterDescendantsInstances = fl
	local hit = workspace:Raycast(p0, tr.Position - p0, rp)
	add(string.format("诊断：%s 距 %.0f 格 · %s", target.Name, dist, hit and ("中间有遮挡 " .. tostring(hit.Instance.Name)) or "无遮挡（视线通）"))
end)

mkBtn(10, 80, 150, "Activate开枪", Color3.fromRGB(46,110,70), function()
	if not prep("Activate开枪") then return end
	pcall(function() myGun():Activate() end)
	report(1.1)
end)

mkBtn(166, 80, 144, "模拟点击开枪", Color3.fromRGB(46,110,70), function()
	if not prep("模拟点击开枪") then return end
	local done = false
	pcall(function() if typeof(mouse1click) == "function" then mouse1click() done = true end end)
	if not done then
		pcall(function()
			local vim = game:GetService("VirtualInputManager")
			local cam = workspace.CurrentCamera
			local vp = cam and cam.ViewportSize or Vector2.new(800,450)
			vim:SendMouseButtonEvent(math.floor(vp.X/2), math.floor(vp.Y/2), 0, true, game, 0)
			task.wait(0.06)
			vim:SendMouseButtonEvent(math.floor(vp.X/2), math.floor(vp.Y/2), 0, false, game, 0)
		end)
	end
	report(1.1)
end)

mkBtn(10, 110, 150, "手动FireServer", Color3.fromRGB(70,70,80), function()
	findRemotes()
	if not shootRem then
		local gun = myGun()
		for _, d in ipairs((gun and gun:GetDescendants()) or {}) do
			if d:IsA("RemoteEvent") and string.lower(d.Name) == "shoot" then shootRem = d break end
		end
	end
	if not shootRem then add("✗ 没找到 Shoot 远程") return end
	target = nearest(400)
	if not target then add("✗ 附近没有活人") return end
	local tr = targetPart(target)
	if not tr then return end
	hookHits, broadcast = 0, 0
	hpBefore = hpOf(target)
	add("== 手动FireServer → " .. target.Name)
	pcall(function() shootRem:FireServer(tr.CFrame * CFrame.new(0,0,2.5), CFrame.new(tr.Position)) end)
	report(1.1)
end)

mkBtn(166, 110, 144, "卸载钩子", Color3.fromRGB(70,70,80), function()
	if oldNC then
		pcall(function() hookmetamethod(game, "__namecall", oldNC) end)
		oldNC = nil
		add("钩子已卸载")
	else
		add("没有安装钩子")
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

findRemotes()
render()
