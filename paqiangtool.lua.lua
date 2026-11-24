-- ============================================================================
--  paqiangtool.lua  ·  MM2 / 通用 爬墙工具（独立小工具）
--  用法：主脚本点「加载爬墙工具」→ 屏幕右上出现一个椭圆开关 → 点开就能爬墙
--        右上角小 × 关闭整个工具（想再用就回主脚本重新加载）
--  原理：把"贴着你的那个面"当成地板
--    1. BodyForce 抵消真实重力，改成压向这个面 → 墙面变地板
--    2. BodyVelocity 沿着面走，速度取 WalkSpeed
--    3. 不加 BodyGyro，人始终直立，用游戏自带跑步动画
-- ============================================================================
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local P = game:GetService("Players")
local LP = P.LocalPlayer

-- 防止重复加载：已有实例先清掉
if getgenv and getgenv().__paqiang_tool then
	pcall(function() getgenv().__paqiang_tool() end)
end

local parentGui = (gethui and gethui()) or game:GetService("CoreGui")
local gui = Instance.new("ScreenGui")
gui.Name = "paqiang_tool"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 9000
gui.Parent = parentGui

--============================ 界面：椭圆开关 ============================
local W, H = 128, 40
local pill = Instance.new("Frame")
pill.Name = "pill"
pill.Size = UDim2.fromOffset(W, H)
pill.Position = UDim2.new(1, -W - 16, 0, 92)
pill.BackgroundColor3 = Color3.fromRGB(238, 232, 220)   -- 暖白底
pill.BorderSizePixel = 0
pill.Active = true
pill.Parent = gui

local pc = Instance.new("UICorner")
pc.CornerRadius = UDim.new(0.5, 0)                       -- 椭圆
pc.Parent = pill

local ps = Instance.new("UIStroke")
ps.Color = Color3.fromRGB(20, 20, 20)                    -- 黑边
ps.Thickness = 2
ps.Parent = pill

local drag = Instance.new("UIPadding")
drag.PaddingLeft = UDim.new(0, 14)
drag.Parent = pill

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -58, 1, 0)
title.Position = UDim2.fromOffset(14, 0)
title.BackgroundTransparency = 1
title.Text = "爬墙"
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextColor3 = Color3.fromRGB(28, 28, 28)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = pill

-- 开关轨道
local track = Instance.new("Frame")
track.Size = UDim2.fromOffset(34, 18)
track.Position = UDim2.new(1, -46, 0.5, -9)
track.BackgroundColor3 = Color3.fromRGB(205, 198, 186)
track.BorderSizePixel = 0
track.Parent = pill
local tc = Instance.new("UICorner") tc.CornerRadius = UDim.new(0.5,0) tc.Parent = track
local tst = Instance.new("UIStroke") tst.Color = Color3.fromRGB(90,86,80) tst.Thickness = 1 tst.Parent = track

local knob = Instance.new("Frame")
knob.Size = UDim2.fromOffset(14, 14)
knob.Position = UDim2.fromOffset(2, 2)
knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
knob.BorderSizePixel = 0
knob.Parent = track
local kc = Instance.new("UICorner") kc.CornerRadius = UDim.new(0.5,0) kc.Parent = knob
local kst = Instance.new("UIStroke") kst.Color = Color3.fromRGB(120,114,106) kst.Thickness = 1 kst.Parent = knob

-- 右上角小 ×
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.fromOffset(18, 18)
closeBtn.Position = UDim2.new(1, -6, 0, -6)
closeBtn.AnchorPoint = Vector2.new(0.5, 0.5)
closeBtn.BackgroundColor3 = Color3.fromRGB(238, 232, 220)
closeBtn.Text = "×"
closeBtn.TextSize = 13
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextColor3 = Color3.fromRGB(28, 28, 28)
closeBtn.AutoButtonColor = false
closeBtn.BorderSizePixel = 0
closeBtn.ZIndex = 5
closeBtn.Parent = pill
local cc = Instance.new("UICorner") cc.CornerRadius = UDim.new(0.5,0) cc.Parent = closeBtn
local cst = Instance.new("UIStroke") cst.Color = Color3.fromRGB(20,20,20) cst.Thickness = 1.5 cst.Parent = closeBtn

--============================ 爬墙逻辑 ============================
local on = false
local FG, BV
local surfN = nil          -- 当前贴着的面法线
local lostT, outT = 0, 0
local jumpCd = 0
local conn = nil
local ray = RaycastParams.new()
ray.FilterType = Enum.RaycastFilterType.Exclude
local UP0 = Vector3.new(0, 1, 0)

local function clearP()
	if FG then pcall(function() FG:Destroy() end) FG = nil end
	if BV then pcall(function() BV:Destroy() end) BV = nil end
end

local function attachP(r)
	if not FG or FG.Parent ~= r then
		clearP()
		FG = Instance.new("BodyForce")
		FG.Name = "pqF"
		FG.Force = Vector3.zero
		FG.Parent = r
		BV = Instance.new("BodyVelocity")
		BV.Name = "pqV"
		BV.MaxForce = Vector3.new(4e5, 4e5, 4e5)
		BV.P = 3000
		BV.Parent = r
	end
end

local function stopAll(resetRotate)
	surfN = nil
	lostT, outT = 0, 0
	clearP()
	local ch = LP.Character
	local h = ch and ch:FindFirstChildOfClass("Humanoid")
	if h and resetRotate ~= false then pcall(function() h.AutoRotate = true end) end
end

local function step(dt)
	local ch = LP.Character
	local h = ch and ch:FindFirstChildOfClass("Humanoid")
	local r = ch and ch:FindFirstChild("HumanoidRootPart")
	if not on or not (h and r and h.Health > 0) then
		if FG then stopAll(true) end
		return
	end
	if dt > 0.2 then dt = 0.2 end
	local cam = workspace.CurrentCamera
	ray.FilterDescendantsInstances = { ch }
	local pos = r.Position
	local look = cam and cam.CFrame.LookVector or r.CFrame.LookVector
	local flat = Vector3.new(look.X, 0, look.Z)
	if flat.Magnitude < 0.05 then flat = Vector3.new(0, 0, -1) end
	flat = flat.Unit
	local mv = h.MoveDirection
	local up = surfN or UP0

	-- 1) 探面
	local cand, candD = nil, 99
	local dirs = {}
	if mv.Magnitude > 0.05 then dirs[#dirs+1] = mv.Unit end
	dirs[#dirs+1] = -up
	dirs[#dirs+1] = flat
	dirs[#dirs+1] = -flat
	dirs[#dirs+1] = up
	for i = 1, #dirs do
		local hit = workspace:Raycast(pos, dirs[i] * 4.0, ray)
		if hit then
			local dd = (hit.Position - pos).Magnitude
			if dd < 0.8 then dd = 0.8 end
			if dd < candD then cand = hit candD = dd end
		end
	end

	-- 2) 定面（贴住了就沿用，并用"从墙外往回打"来防丢）
	local tgt = surfN
	if not surfN then
		tgt = nil
		if cand and mv.Magnitude > 0.1 and mv:Dot(-cand.Normal) > 0.25 and cand.Normal:Dot(UP0) < 0.96 then
			tgt = cand.Normal
		end
	else
		local ok = false
		local e1 = UP0 - up * (UP0:Dot(up))
		if e1.Magnitude > 0.15 then e1 = e1.Unit else e1 = flat end
		for k = -1, 1 do
			local hh = workspace:Raycast(pos + up * 2.2 + e1 * (k * 1.4), -up * 7.0, ray)
			if hh and math.abs(hh.Normal:Dot(up)) > 0.45 then ok = true break end
		end
		if not ok then
			local hh = workspace:Raycast(pos + up * 2.2, -up * 7.0, ray)
			if hh and math.abs(hh.Normal:Dot(up)) > 0.45 then ok = true end
		end
		if ok then
			tgt = surfN
		else
			local hh = workspace:Raycast(pos, e1 * 3.6, ray)
			if hh and math.abs(hh.Normal:Dot(up)) < 0.55 then
				tgt = hh.Normal
			elseif lostT < 0.9 and mv.Magnitude > 0.1 and mv:Dot(-up) > 0.2 then
				tgt = surfN
			else
				tgt = nil
			end
		end
	end
	if not tgt then
		lostT = lostT + dt
		if lostT > 0.25 and FG then stopAll(true) end
		return
	end
	lostT = 0
	if not surfN then surfN = tgt attachP(r) end
	surfN = tgt
	up = tgt

	-- 3) 往外推 = 下来
	if mv.Magnitude > 0.1 and mv:Dot(up) > 0.5 then
		outT = outT + dt
		if outT > 0.15 then
			stopAll(true)
			outT = 0
			return
		end
	else
		outT = 0
	end

	-- 4) 抵消重力，把它变成"往面里压"
	local mass = r.AssemblyMass or r:GetMass()
	local g = workspace.Gravity
	FG.Force = mass * g * (UP0 - up)

	-- 5) 沿面走
	local spill = mv - up * (mv:Dot(up))
	local speed = h.WalkSpeed
	if speed < 4 then speed = 16 end
	local want = Vector3.zero
	if spill.Magnitude > 0.08 then
		want = spill.Unit * speed
	elseif mv.Magnitude > 0.1 then
		local e1 = UP0 - up * (UP0:Dot(up))
		if e1.Magnitude < 0.2 then e1 = flat - up * (flat:Dot(up)) end
		if e1.Magnitude > 0.2 then want = e1.Unit * speed end
	end
	if want.Magnitude > 0.5 then
		local wd = want.Unit
		local obs = workspace:Raycast(pos + up * 0.3, wd * 2.0, ray)
		if obs and math.abs(obs.Normal:Dot(up)) < 0.7 and wd:Dot(obs.Normal) < -0.15 then
			local t = wd - obs.Normal * (wd:Dot(obs.Normal))
			if t.Magnitude > 0.2 then want = t.Unit * speed end
		end
	end

	-- 6) 跳 = 蹬开
	local wantJump = (h.Jump == true) or UIS:IsKeyDown(Enum.KeyCode.Space)
	if wantJump and os.clock() >= jumpCd then
		jumpCd = os.clock() + 0.45
		h.Jump = false
		r.AssemblyLinearVelocity = up * math.max(g * 0.42, 45)
		stopAll(true)
		return
	end
	h.Jump = false

	-- 7) 输出：不转身体、不换动画
	BV.MaxForce = Vector3.new(4e5, 4e5, 4e5)
	BV.Velocity = want - UP0 * 3
	h.AutoRotate = true
	if want.Magnitude > 0.5 then
		pcall(function() h:ChangeState(Enum.HumanoidStateType.Running) end)
	end
end

--============================ 开关与关闭 ============================
local function setUI(v)
	TS:Create(knob, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Position = UDim2.fromOffset(v and 18 or 2, 2)
	}):Play()
	TS:Create(track, TweenInfo.new(0.2), {
		BackgroundColor3 = v and Color3.fromRGB(120, 170, 120) or Color3.fromRGB(205, 198, 186)
	}):Play()
	TS:Create(title, TweenInfo.new(0.2), {
		TextColor3 = v and Color3.fromRGB(20, 70, 20) or Color3.fromRGB(28, 28, 28)
	}):Play()
end

local function setOn(v)
	on = v
	setUI(v)
	if not v then stopAll(true) end
end

-- 覆盖整块的全透明按钮：直接点 pill 时，里面的文字/开关会吞掉点击，所以用这一层接管
local hit = Instance.new("TextButton")
hit.Size = UDim2.fromScale(1,1)
hit.Position = UDim2.fromOffset(0,0)
hit.BackgroundTransparency = 1
hit.Text = ""
hit.ZIndex = 3
hit.AutoButtonColor = false
hit.Parent = pill
hit.MouseButton1Click:Connect(function()
	setOn(not on)
end)

local function destroyTool()
	on = false
	pcall(stopAll)
	if conn then pcall(function() conn:Disconnect() end) conn = nil end
	pcall(function() gui:Destroy() end)
	if getgenv then getgenv().__paqiang_tool = nil end
end

closeBtn.MouseButton1Click:Connect(function()
	destroyTool()
end)

conn = RS.RenderStepped:Connect(function(dt)
	local ok, err = pcall(step, dt)
	if not ok then
		-- 出错就自己收手，别把人卡住
		pcall(stopAll)
	end
end)

LP.CharacterAdded:Connect(function()
	task.wait(0.3)
	stopAll(true)
end)

getgenv().__paqiang_tool = destroyTool
if _G.__pq_notify then pcall(_G.__pq_notify, "爬墙工具已加载") end
