--[[
	guntest.lua v2 — 子弹命中对照实验（每个按钮都真的扣一次扳机）
	用法：自己是警长、手里装备 Gun → 开脚本 → 每点一个按钮都会真的开一枪（会消耗子弹！）
	     一局只有一两发，所以建议每测一个换一局。
	按钮：
	  · 真开枪·不改        —— 对照组，原样开枪
	  · 真开枪·改终点      —— 真开枪，但把这一枪的终点换成目标位置
	  · 真开枪·起点终点都改 —— 起点换成目标身前 2.5 格，终点换成目标
	  · 手动FireServer     —— 直接发远程（上一版那种，做对照）
	每个按钮都会打印：拦截到的 Shoot 次数、服务端广播次数、目标血量变化。
	  拦截 0 次 → Activate() 没触发游戏自己的射击逻辑，要换触发方式
	  拦截到但没广播 → 参数被服务端拒绝
	  有广播且掉血 → 方案可用
]]

local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer
local unpack = table.unpack or unpack

local logs = {}
local shootRem = nil
local gunFiredRem = nil
local MODE = "pass"          -- pass | end | both
local hookHits = 0
local broadcast = 0
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

local gui = B("ScreenGui", {Name="guntest2", ResetOnSpawn=false, IgnoreGuiInset=true, DisplayOrder=999997, Parent=parent()})
local frm = B("Frame", {Size=UDim2.fromOffset(310, 330), Position=UDim2.fromOffset(14, 170), BackgroundColor3=Color3.fromRGB(16,17,21), BorderSizePixel=0, Active=true, Parent=gui})
local cr = Instance.new("UICorner") cr.CornerRadius = UDim.new(0,8) cr.Parent = frm
local bar = B("Frame", {Size=UDim2.new(1,0,0,24), BackgroundColor3=Color3.fromRGB(38,40,48), BorderSizePixel=0, Parent=frm})
local cb = Instance.new("UICorner") cb.CornerRadius = UDim.new(0,8) cb.Parent = bar
B("TextLabel", {Size=UDim2.new(1,-60,1,0), Position=UDim2.fromOffset(10,0), BackgroundTransparency=1, Text="子弹实验 v2（真开枪）", Font=Enum.Font.GothamBold, TextSize=12, TextColor3=Color3.fromRGB(235,235,240), TextXAlignment=Enum.TextXAlignment.Left, Parent=bar})
local cls = B("TextButton", {Size=UDim2.fromOffset(24,18), Position=UDim2.new(1,-30,0,3), BackgroundColor3=Color3.fromRGB(58,60,70), BorderSizePixel=0, Text="×", Font=Enum.Font.GothamBold, TextSize=13, TextColor3=Color3.fromRGB(235,235,240), Parent=bar})
cls.MouseButton1Click:Connect(function() gui:Destroy() end)

local stat = B("TextLabel", {Size=UDim2.new(1,-20,0,16), Position=UDim2.fromOffset(10,30), BackgroundTransparency=1, Text="状态：待机（记得先装备 Gun）", Font=Enum.Font.GothamMedium, TextSize=10, TextColor3=Color3.fromRGB(150,220,170), TextXAlignment=Enum.TextXAlignment.Left, Parent=frm})

local body = B("Frame", {Size=UDim2.new(1,-20,1,-150), Position=UDim2.fromOffset(10,142), BackgroundColor3=Color3.fromRGB(24,25,30), BorderSizePixel=0, ClipsDescendants=true, Parent=frm})
local bc = Instance.new("UICorner") bc.CornerRadius = UDim.new(0,6) bc.Parent = body
local txt = B("TextLabel", {Size=UDim2.new(1,-12,1,-8), Position=UDim2.fromOffset(6,4), BackgroundTransparency=1, Text="", Font=Enum.Font.Code, TextSize=9, TextWrapped=true, TextXAlignment=Enum.TextXAlignment.Left, TextYAlignment=Enum.TextYAlignment.Top, TextColor3=Color3.fromRGB(200,210,220), Parent=body})

local function render()
	local s = {}
	for i = math.max(1, #logs - 13), #logs do s[#s+1] = logs[i] end
	txt.Text = (#s == 0) and "（点按钮开始，每次都会真的开一枪）" or table.concat(s, "\n")
end
local function add(l) logs[#logs+1] = l if #logs > 150 then table.remove(logs,1) end render() end

local function mkBtn(x, y, text, cbFn)
	local b = B("TextButton", {Size=UDim2.fromOffset(142,26), Position=UDim2.fromOffset(x,y), BackgroundColor3=Color3.fromRGB(46,110,70), BorderSizePixel=0, Text=text, Font=Enum.Font.GothamBold, TextSize=10, TextColor3=Color3.new(1,1,1), Parent=frm})
	b.MouseButton1Click:Connect(function() pcall(cbFn) end)
	return b
end

-- ===== 找远程 + 钩子 =====
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
	local function scan(c, tag)
		if not c then return end
		pcall(function()
			for _, d in ipairs(c:GetDescendants()) do
				if d:IsA("RemoteEvent") and string.lower(d.Name) == "shoot" and not shootRem then
					shootRem = d
					add("Shoot: 在「" .. tag .. "」里找到")
				end
			end
		end)
	end
	scan(LP.Character, "角色")
	scan(LP:FindFirstChild("Backpack"), "背包")
	scan(workspace, "场景")
	add("Shoot 远程: " .. (shootRem and ("OK(父:" .. tostring(shootRem.Parent and shootRem.Parent.Name) .. ")") or "没找到"))
	if gunFiredRem then
		pcall(function()
			gunFiredRem.OnClientEvent:Connect(function() broadcast = broadcast + 1 end)
		end)
	end
end

local function targetPart(pl)
	local c = pl and pl.Character
	if not c then return nil end
	return c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("Head")
end

local function myGun()
	local c = LP.Character
	local t = c and c:FindFirstChild("Gun")
	if t and t:IsA("Tool") then return t end
end

local function myHrp()
	local c = LP.Character
	if not c then return nil end
	return c:FindFirstChild("HumanoidRootPart") or c.PrimaryPart
end

local function nearest(maxd)
	local r = myHrp()
	if not r then return nil end
	local best, bd = nil, maxd or 400
	for _, pl in ipairs(Players:GetPlayers()) do
		if pl ~= LP and pl.Character then
			local tr = pl.Character:FindFirstChild("HumanoidRootPart")
			local th = pl.Character:FindFirstChildOfClass("Humanoid")
			if tr and th and th.Health > 0 then
				local d = (tr.Position - r.Position).Magnitude
				if d <= bd then bd = d best = pl end
			end
		end
	end
	return best
end

local function hpOf(pl)
	local c = pl and pl.Character
	local h = c and c:FindFirstChildOfClass("Humanoid")
	return h and h.Health or -1
end

local function installHook()
	if oldNC then return true end
	local ok = pcall(function()
		local hookf = hookmetamethod
		local getm = getnamecallmethod
		local nc = newcclosure or function(f) return f end
		oldNC = hookf(game, "__namecall", nc(function(self, ...)
			local m = getm()
			if m == "FireServer" and MODE ~= "pass" and typeof(self) == "Instance" and tostring(self.Name) == "Shoot" then
				local args = {...}
				hookHits = hookHits + 1
				local tr = targetPart(target)
				if tr then
					if MODE == "both" then
						return oldNC(self, tr.CFrame * CFrame.new(0,0,2.5), tr.CFrame)
					else
						return oldNC(self, args[1], tr.CFrame)
					end
				end
				return oldNC(self, unpack(args))
			end
			if m == "FireServer" and typeof(self) == "Instance" and tostring(self.Name) == "Shoot" then
				hookHits = hookHits + 1
			end
			return oldNC(self, ...)
		end))
	end)
	return ok
end

local function report(label, secs)
	task.delay(secs or 1.0, function()
		local hpAfter = hpOf(target)
		add(string.format("  拦截 Shoot %d 次 · 广播 %d 次", hookHits, broadcast))
		add(string.format("  血量 %.0f → %.0f（掉 %.0f）%s", hpBefore, hpAfter, hpBefore - hpAfter,
			((hpBefore - hpAfter) > 0) and "  打中" or "  没打中"))
		stat.Text = ((hpBefore - hpAfter) > 0) and "状态：这一枪打中了" or "状态：这一枪没打中"
	end)
end

local function prepare(label, mode)
	findRemotes()
	MODE = mode
	hookHits, broadcast = 0, 0
	target = nearest(400)
	local gun = myGun()
	if not gun then add("✗ 手里没有 Gun（先装备）") return nil end
	if not target then add("✗ 附近没有活人") return nil end
	installHook()
	hpBefore = hpOf(target)
	add("== " .. label .. " → " .. target.Name .. " 血" .. string.format("%.0f", hpBefore) .. " 模式:" .. mode)
	return gun
end

-- 真开枪（不改）
mkBtn(10, 50, "真开枪·不改", function()
	local gun = prepare("真开枪·不改", "pass")
	if not gun then return end
	local ok, err = pcall(function() gun:Activate() end)
	if not ok then add("  Activate 失败: " .. tostring(err)) end
	report("pass", 1.0)
end)

-- 真开枪 + 改终点
mkBtn(158, 50, "真开枪·改终点", function()
	local gun = prepare("真开枪·改终点", "end")
	if not gun then return end
	local ok, err = pcall(function() gun:Activate() end)
	if not ok then add("  Activate 失败: " .. tostring(err)) end
	report("end", 1.0)
end)

-- 真开枪 + 起点终点都改
mkBtn(10, 80, "真开枪·起点终点都改", function()
	local gun = prepare("真开枪·起点终点都改", "both")
	if not gun then return end
	local ok, err = pcall(function() gun:Activate() end)
	if not ok then add("  Activate 失败: " .. tostring(err)) end
	report("both", 1.0)
end)

-- 手动 FireServer（对照）
mkBtn(158, 80, "手动FireServer", function()
	findRemotes()
	if not shootRem then add("✗ 没找到 Shoot 远程") return end
	target = nearest(400)
	if not target then add("✗ 附近没有活人") return end
	local tr = targetPart(target)
	if not tr then return end
	hookHits, broadcast = 0, 0
	hpBefore = hpOf(target)
	add("== 手动FireServer → " .. target.Name .. " 血" .. string.format("%.0f", hpBefore))
	for _ = 1, 2 do
		pcall(function() shootRem:FireServer(tr.CFrame * CFrame.new(0,0,2.5), tr.CFrame) end)
		task.wait(0.15)
	end
	report("manual", 1.0)
end)

mkBtn(10, 110, "卸载钩子", function()
	if oldNC then
		pcall(function() hookmetamethod(game, "__namecall", oldNC) end)
		oldNC = nil
		add("钩子已卸载")
	else
		add("没有安装钩子")
	end
end)

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

findRemotes()
render()
