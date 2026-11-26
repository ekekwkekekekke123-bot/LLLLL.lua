--[[
	guntest.lua — 子弹命中对照实验（独立测试脚本，不动 wx / mm2）
	用法：自己是警长、手里有枪 → 开脚本 → 依次点 A / B / C / D，每个按钮都会告诉你：
	      · 实际发了几次 Shoot
	      · 0.8 秒内收到几次服务端 GunFired 广播（收到 = 这一枪被服务端接受了）
	      · 目标的血量变化（掉血 = 打中了）
	判读：
	  A 掉血、B 不掉 → 服务端采信终点，但有"视野/距离"复核（穿墙要另想办法）
	  A、B 都掉血    → 那 mm2 里那次没生效是别的原因（比如不是同一把枪/冷却）
	  都不掉且没广播  → 服务端丢弃了我们伪造的请求（缺参数或校验枪手状态）
	  有广播但都不掉  → 广播只是特效，命中判定走另一条路
]]

local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer

local logs = {}
local shootRem, gunFiredRem
local fired, broadcast, lastEnd = 0, 0, nil
local watchUntil = 0
local target = nil
local hpBefore = nil

local function parent()
	local ok, h = pcall(function() return gethui() end)
	if ok and typeof(h) == "Instance" then return h end
	local ok2, c = pcall(function() return game:GetService("CoreGui") end)
	if ok2 and typeof(c) == "Instance" then return c end
	return LP:WaitForChild("PlayerGui")
end
local function B(cls, props) local o = Instance.new(cls) for k, v in pairs(props) do o[k] = v end return o end

local gui = B("ScreenGui", {Name="guntest", ResetOnSpawn=false, IgnoreGuiInset=true, DisplayOrder=999997, Parent=parent()})
local frm = B("Frame", {Size=UDim2.fromOffset(300, 296), Position=UDim2.fromOffset(14, 200), BackgroundColor3=Color3.fromRGB(16,17,21), BorderSizePixel=0, Active=true, Parent=gui})
local cr = Instance.new("UICorner") cr.CornerRadius = UDim.new(0,8) cr.Parent = frm
local bar = B("Frame", {Size=UDim2.new(1,0,0,24), BackgroundColor3=Color3.fromRGB(38,40,48), BorderSizePixel=0, Parent=frm})
local cb = Instance.new("UICorner") cb.CornerRadius = UDim.new(0,8) cb.Parent = bar
B("TextLabel", {Size=UDim2.new(1,-60,1,0), Position=UDim2.fromOffset(10,0), BackgroundTransparency=1, Text="子弹命中实验", Font=Enum.Font.GothamBold, TextSize=12, TextColor3=Color3.fromRGB(235,235,240), TextXAlignment=Enum.TextXAlignment.Left, Parent=bar})
local cls = B("TextButton", {Size=UDim2.fromOffset(24,18), Position=UDim2.new(1,-30,0,3), BackgroundColor3=Color3.fromRGB(58,60,70), BorderSizePixel=0, Text="×", Font=Enum.Font.GothamBold, TextSize=13, TextColor3=Color3.fromRGB(235,235,240), Parent=bar})
cls.MouseButton1Click:Connect(function() gui:Destroy() end)

local stat = B("TextLabel", {Size=UDim2.new(1,-20,0,16), Position=UDim2.fromOffset(10,30), BackgroundTransparency=1, Text="状态：待机", Font=Enum.Font.GothamMedium, TextSize=10, TextColor3=Color3.fromRGB(150,220,170), TextXAlignment=Enum.TextXAlignment.Left, Parent=frm})

local function mkBtn(x, y, text, cbFn)
	local b = B("TextButton", {Size=UDim2.fromOffset(136,26), Position=UDim2.fromOffset(x,y), BackgroundColor3=Color3.fromRGB(46,110,70), BorderSizePixel=0, Text=text, Font=Enum.Font.GothamBold, TextSize=10, TextColor3=Color3.new(1,1,1), Parent=frm})
	b.MouseButton1Click:Connect(function() pcall(cbFn) end)
	return b
end

local body = B("Frame", {Size=UDim2.new(1,-20,1,-124), Position=UDim2.fromOffset(10,116), BackgroundColor3=Color3.fromRGB(24,25,30), BorderSizePixel=0, ClipsDescendants=true, Parent=frm})
local bc = Instance.new("UICorner") bc.CornerRadius = UDim.new(0,6) bc.Parent = body
local txt = B("TextLabel", {Size=UDim2.new(1,-12,1,-8), Position=UDim2.fromOffset(6,4), BackgroundTransparency=1, Text="", Font=Enum.Font.Code, TextSize=9, TextWrapped=true, TextXAlignment=Enum.TextXAlignment.Left, TextYAlignment=Enum.TextYAlignment.Top, TextColor3=Color3.fromRGB(200,210,220), Parent=body})

local function render()
	local s = {}
	local start = math.max(1, #logs - 13)
	for i = start, #logs do s[#s+1] = logs[i] end
	txt.Text = (#s == 0) and "（点上面的按钮开始）" or table.concat(s, "\n")
end
local function add(l) logs[#logs+1] = l if #logs > 120 then table.remove(logs,1) end render() end

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
	-- 开枪远程经常是放在「枪这个工具」里面一起复制的，ReplicatedStorage 里根本找不到
	local function scan(container, tag)
		if not container or shootRem then return end
		local ok = pcall(function()
			for _, d in ipairs(container:GetDescendants()) do
				if d:IsA("RemoteEvent") and string.lower(d.Name) == "shoot" then
					shootRem = d
					add("Shoot 远程: 在「" .. tag .. "」里找到")
					return
				end
			end
		end)
		if not ok then add("扫描「" .. tag .. "」失败") end
	end
	scan(LP.Character, "我的角色")
	scan(LP:FindFirstChild("Backpack"), "我的背包")
	scan(workspace, "场景")
	if not shootRem then
		pcall(function()
			for _, d in ipairs(game:GetDescendants()) do
				if d:IsA("RemoteEvent") and string.lower(d.Name) == "shoot" then
					shootRem = d
					add("Shoot 远程: 全游戏扫描找到")
					break
				end
			end
		end)
	end
	add("Shoot 远程: " .. (shootRem and ("找到（父级:" .. tostring(shootRem.Parent and shootRem.Parent.Name) .. "）") or "没找到"))
	add("GunFired 广播: " .. (gunFiredRem and "已挂钩" or "没找到"))
	if gunFiredRem then
		pcall(function()
			gunFiredRem.OnClientEvent:Connect(function(a, b, c)
				broadcast = broadcast + 1
				local e = c
				if typeof(b) == "CFrame" and typeof(c) == "CFrame" then e = c end
				if typeof(e) == "CFrame" then
					local p = e.Position
					lastEnd = string.format("%.1f,%.1f,%.1f", p.X, p.Y, p.Z)
				end
			end)
		end)
	end
end

local function myHrp()
	local c = LP.Character
	if not c then return nil end
	return c:FindFirstChild("HumanoidRootPart") or c.PrimaryPart
end

local function myGun()
	local c = LP.Character
	local t = c and c:FindFirstChild("Gun")
	if t and t:IsA("Tool") then return t end
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

local function begin(name, tgt)
	if not shootRem then
		-- 允许多次尝试查找（有些 remote 是懒加载）
		findRemotes()
	end
	if not shootRem then add("✗ 没找到 Shoot 远程") return nil end
	if not myGun() then
		add("✗ 你手里没有 Gun（必须警长且装备）")
		return nil
	end
	target = tgt or nearest(400)
	if not target then add("✗ 附近没有活人") return nil end
	fired, broadcast, lastEnd = 0, 0, nil
	hpBefore = hpOf(target)
	watchUntil = os.clock() + 0.8
	add("== " .. name .. " → " .. target.Name .. "（血 " .. tostring(math.floor(hpBefore)) .. "）")
	return target
end

local function fire(startCF, endCF)
	fired = fired + 1
	local ok, err = pcall(function() shootRem:FireServer(startCF, endCF) end)
	if not ok then add("  发送失败: " .. tostring(err)) end
end

local function finish()
	task.delay(0.9, function()
		if not target then return end
		local hpAfter = hpOf(target)
		local dealt = (hpBefore or 0) - (hpAfter or 0)
		add(string.format("  发出 %d 次 · 收到广播 %d 次 · 广播终点 %s", fired, broadcast, tostring(lastEnd or "-")))
		add(string.format("  血量 %.0f → %.0f（掉 %.0f）%s", hpBefore or -1, hpAfter, dealt, (dealt > 0 and " 打中" or " 没打中")))
		stat.Text = (dealt > 0) and "状态：这一枪打中了" or "状态：这一枪没打中"
	end)
end

mkBtn(10, 50, "A 真起点→目标", function()
	local t = begin("A 真起点", nil)
	if not t then return end
	local tr = targetPart(t)
	local r = myHrp()
	if not tr or not r then return end
	local gun = myGun()
	local hd = gun and (gun:FindFirstChild("Handle") or gun:FindFirstChild("Blade"))
	local startCF = (hd and hd:IsA("BasePart") and hd.CFrame) or (r.CFrame * CFrame.new(0,0,-1))
	fire(startCF, CFrame.new(tr.Position))
	finish()
end)

mkBtn(154, 50, "B 假起点→目标", function()
	local t = begin("B 假起点", nil)
	if not t then return end
	local tr = targetPart(t)
	if not tr then return end
	fire(tr.CFrame * CFrame.new(0,0,2.5), CFrame.new(tr.Position))
	finish()
end)

mkBtn(10, 80, "C 连发3次B", function()
	local t = begin("C 连发3次假起点", nil)
	if not t then return end
	local tr = targetPart(t)
	if not tr then return end
	for _ = 1, 3 do
		fire(tr.CFrame * CFrame.new(0,0,2.5), CFrame.new(tr.Position))
		task.wait(0.12)
	end
	finish()
end)

mkBtn(154, 80, "D 对照：对天开枪", function()
	if not shootRem then findRemotes() end
	if not shootRem then add("✗ 没找到 Shoot 远程") return end
	local gun = myGun()
	if not gun then add("✗ 你手里没有 Gun") return end
	local hd = gun:FindFirstChild("Handle")
	local r = myHrp()
	local startCF = (hd and hd:IsA("BasePart") and hd.CFrame) or (r and r.CFrame * CFrame.new(0,0,-1))
	if not startCF then add("✗ 取不到起点") return end
	broadcast, lastEnd = 0, nil
	fired = 1
	pcall(function() shootRem:FireServer(startCF, CFrame.new(startCF.Position + Vector3.new(0, 200, 0))) end)
	add("== D 对照（对天）")
	task.delay(0.9, function()
		add(string.format("  发出 1 次 · 收到广播 %d 次 · 终点 %s", broadcast, tostring(lastEnd or "-")))
	end)
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
