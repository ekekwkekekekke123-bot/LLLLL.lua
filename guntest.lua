--[[
	guntest.lua v3 — 真开枪（模拟点击）+ 可选改落点
	用法：自己是警长、装备 Gun → 开脚本
	  1) 先用「模拟点击开枪」+「改落点：关」做对照（应该打中你瞄准的东西）
	  2) 再「改落点：开」+「模拟点击开枪」→ 看能不能隔墙打中目标
	  3) 若「拦截 Shoot 0 次」说明模拟点击没触发游戏开火（执行器不支持 mouse1click / VIM），
	     那就只剩「手动FireServer」这条路，而它会因起点校验被拒。
	每次都会打印：拦截到的 Shoot 次数、服务端广播次数、目标血量变化。
]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer
local unpack = table.unpack or unpack

local logs = {}
local shootRem, gunFiredRem = nil, nil
local REWRITE = false
local hookHits, broadcast = 0, 0
local target = nil
local hpBefore = 100
local oldNC = nil

local function parent()
	local ok, h = pcall(function() return gethui() end)
	if ok and typeof(h) == "Instance" then return h end
	local ok2, c = pcall(function() return game:GetService("CoreGui") end)
	if ok2 and typeof(c) == "Instance" then return c end
	return LP:WaitForChild("PlayerGui")
end
local function B(cls, props) local o = Instance.new(cls) for k, v in pairs(props) do o[k] = v end return o end

local gui = B("ScreenGui", {Name="guntest3", ResetOnSpawn=false, IgnoreGuiInset=true, DisplayOrder=999997, Parent=parent()})
local frm = B("Frame", {Size=UDim2.fromOffset(316, 320), Position=UDim2.fromOffset(14, 170), BackgroundColor3=Color3.fromRGB(16,17,21), BorderSizePixel=0, Active=true, Parent=gui})
local cr = Instance.new("UICorner") cr.CornerRadius = UDim.new(0,8) cr.Parent = frm
local bar = B("Frame", {Size=UDim2.new(1,0,0,24), BackgroundColor3=Color3.fromRGB(38,40,48), BorderSizePixel=0, Parent=frm})
local cb = Instance.new("UICorner") cb.CornerRadius = UDim.new(0,8) cb.Parent = bar
B("TextLabel", {Size=UDim2.new(1,-60,1,0), Position=UDim2.fromOffset(10,0), BackgroundTransparency=1, Text="子弹实验 v3（模拟点击）", Font=Enum.Font.GothamBold, TextSize=12, TextColor3=Color3.fromRGB(235,235,240), TextXAlignment=Enum.TextXAlignment.Left, Parent=bar})
local cls = B("TextButton", {Size=UDim2.fromOffset(24,18), Position=UDim2.new(1,-30,0,3), BackgroundColor3=Color3.fromRGB(58,60,70), BorderSizePixel=0, Text="×", Font=Enum.Font.GothamBold, TextSize=13, TextColor3=Color3.fromRGB(235,235,240), Parent=bar})
cls.MouseButton1Click:Connect(function() gui:Destroy() end)

local stat = B("TextLabel", {Size=UDim2.new(1,-20,0,16), Position=UDim2.fromOffset(10,30), BackgroundTransparency=1, Text="状态：待机（先装备 Gun）", Font=Enum.Font.GothamMedium, TextSize=10, TextColor3=Color3.fromRGB(150,220,170), TextXAlignment=Enum.TextXAlignment.Left, Parent=frm})

local body = B("Frame", {Size=UDim2.new(1,-20,1,-150), Position=UDim2.fromOffset(10,142), BackgroundColor3=Color3.fromRGB(24,25,30), BorderSizePixel=0, ClipsDescendants=true, Parent=frm})
local bc = Instance.new("UICorner") bc.CornerRadius = UDim.new(0,6) bc.Parent = body
local txt = B("TextLabel", {Size=UDim2.new(1,-12,1,-8), Position=UDim2.fromOffset(6,4), BackgroundTransparency=1, Text="", Font=Enum.Font.Code, TextSize=9, TextWrapped=true, TextXAlignment=Enum.TextXAlignment.Left, TextYAlignment=Enum.TextYAlignment.Top, TextColor3=Color3.fromRGB(200,210,220), Parent=body})

local function render()
	local s = {}
	for i = math.max(1, #logs - 13), #logs do s[#s+1] = logs[i] end
	txt.Text = (#s == 0) and "（先点「改落点：关」，再点「模拟点击开枪」）" or table.concat(s, "\n")
end
local function add(l) logs[#logs+1] = l if #logs > 150 then table.remove(logs,1) end render() end

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
				if REWRITE then
					local tr = targetPart(target)
					if tr and args[1] then
						return oldNC(self, args[1], tr.CFrame)
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
		add(string.format("  拦截 Shoot %d 次 · 广播 %d 次", hookHits, broadcast))
		add(string.format("  血量 %.0f → %.0f（掉 %.0f）%s", hpBefore, hpAfter, hpBefore - hpAfter,
			((hpBefore - hpAfter) > 0) and "  打中" or "  没打中"))
		stat.Text = ((hpBefore - hpAfter) > 0) and "状态：打中了" or "状态：没中"
	end)
end

local function prepare()
	findRemotes()
	hookHits, broadcast = 0, 0
	target = nearest(400)
	if not myGun() then add("✗ 手里没有 Gun（先装备）") return false end
	if not target then add("✗ 附近没有活人") return false end
	installHook()
	hpBefore = hpOf(target)
	return true
end

-- 模拟点击开火
local function simClick()
	local done = false
	pcall(function()
		if typeof(mouse1click) == "function" then
			mouse1click()
			done = true
		end
	end)
	if not done then
		pcall(function()
			if typeof(mouse1press) == "function" and typeof(mouse1release) == "function" then
				mouse1press()
				task.wait(0.06)
				mouse1release()
				done = true
			end
		end)
	end
	if not done then
		pcall(function()
			local vim = game:GetService("VirtualInputManager")
			local cam = workspace.CurrentCamera
			local vp = cam and cam.ViewportSize or Vector2.new(800, 450)
			vim:SendMouseButtonEvent(math.floor(vp.X/2), math.floor(vp.Y/2), 0, true, game, 0)
			task.wait(0.06)
			vim:SendMouseButtonEvent(math.floor(vp.X/2), math.floor(vp.Y/2), 0, false, game, 0)
			done = true
		end)
	end
	return done
end

mkBtn(10, 50, 140, "模拟点击开枪", Color3.fromRGB(46,110,70), function()
	if not prepare() then return end
	add("== 模拟点击（改落点:" .. tostring(REWRITE) .. "）→ " .. target.Name .. " 血" .. string.format("%.0f", hpBefore))
	local ok = simClick()
	if not ok then add("  ✗ 执行器不支持模拟点击（没有 mouse1click / VIM）") return end
	report(1.1)
end)

mkBtn(158, 50, 148, "Activate开枪", Color3.fromRGB(60,90,130), function()
	if not prepare() then return end
	add("== Activate（改落点:" .. tostring(REWRITE) .. "）→ " .. target.Name)
	pcall(function() myGun():Activate() end)
	report(1.1)
end)

mkBtn(10, 80, 140, "改落点：开/关", Color3.fromRGB(110,90,50), function()
	REWRITE = not REWRITE
	add("改落点 = " .. tostring(REWRITE) .. (REWRITE and "（这一枪的终点会换成目标）" or "（原样开枪）"))
end)

mkBtn(158, 80, 148, "手动FireServer", Color3.fromRGB(70,70,80), function()
	findRemotes()
	if not shootRem then add("✗ 没找到 Shoot 远程") return end
	target = nearest(400)
	if not target then add("✗ 附近没有活人") return end
	local tr = targetPart(target)
	if not tr then return end
	hookHits, broadcast = 0, 0
	hpBefore = hpOf(target)
	add("== 手动FireServer（起点=目标身前2.5）→ " .. target.Name)
	pcall(function() shootRem:FireServer(tr.CFrame * CFrame.new(0,0,2.5), tr.CFrame) end)
	report(1.1)
end)

mkBtn(10, 110, 140, "卸载钩子", Color3.fromRGB(70,70,80), function()
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
