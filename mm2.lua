--===== MM2 · LLL =====
do
	local G=_G
	if type(G.gethui)~="function" then
		G.getgenv=G.getgenv or function() return G end
		G.gethui=function()
			local ok,h=pcall(function() return game:GetService("CoreGui") end)
			if ok and h then return h end
			return game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui",5)
		end
	end
end
local P=game:GetService("Players")
local TS=game:GetService("TweenService")
local LP=P.LocalPlayer
if game.PlaceId~=142823291 then
	local sg=Instance.new("ScreenGui")
	if not pcall(function() sg.Parent=game:GetService("CoreGui") end) then sg.Parent=LP:WaitForChild("PlayerGui") end
	local t=Instance.new("TextLabel")
	t.Size=UDim2.fromScale(1,0.12) t.Position=UDim2.fromScale(0,0.44)
	t.BackgroundColor3=Color3.fromRGB(20,20,24) t.TextColor3=Color3.fromRGB(255,140,140)
	t.Font=Enum.Font.GothamBold t.TextSize=16 t.Text="此脚本仅支持 Murder Mystery 2" t.Parent=sg
	task.delay(5,function() pcall(function() sg:Destroy() end) end)
	return
end
local function B(c,p) local o=Instance.new(c) for k,v in pairs(p) do if k~="Parent" then o[k]=v end end if p.Parent then o.Parent=p.Parent end return o end
local function SP()
	local ok,h=pcall(function() return gethui() end)
	if ok and typeof(h)=="Instance" then return h end
	local ok2,c=pcall(function() return game:GetService("CoreGui") end)
	if ok2 and typeof(c)=="Instance" then return c end
	return LP.PlayerGui
end
local C={bg=Color3.fromRGB(238,233,223),row=Color3.fromRGB(243,237,227),off=Color3.fromRGB(212,204,191),accent=Color3.fromRGB(190,74,64),txt=Color3.fromRGB(38,38,38),dim=Color3.fromRGB(108,103,95)}
local gui=B("ScreenGui",{Name="mm2_ui",IgnoreGuiInset=true,ResetOnSpawn=false,DisplayOrder=60})
gui.Parent=SP()
local vp=workspace.CurrentCamera.ViewportSize
local PW,PH=340,250
local x0=math.floor((vp.X-PW)/2)
local y0=math.floor((vp.Y-PH)/2)
local pn=B("Frame",{Size=UDim2.fromOffset(PW,PH),Position=UDim2.fromOffset(x0,y0),BackgroundColor3=C.bg,BackgroundTransparency=0.03,BorderSizePixel=0,ZIndex=100,Parent=gui})
B("UIStroke",{Color=Color3.fromRGB(120,110,98),Transparency=0.5,Parent=pn})
local bar=B("Frame",{Size=UDim2.new(1,0,0,32),BackgroundTransparency=1,ZIndex=120,Parent=pn})
B("TextLabel",{Size=UDim2.new(1,-80,1,0),Position=UDim2.fromOffset(14,0),BackgroundTransparency=1,Text="MM2 · LLL",Font=Enum.Font.GothamBold,TextSize=13,TextColor3=C.accent,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=122,Parent=bar})
local minBtn=B("TextButton",{Size=UDim2.fromOffset(34,32),Position=UDim2.new(1,-68,0.5,0),AnchorPoint=Vector2.new(0,0.5),BackgroundTransparency=1,Text="－",Font=Enum.Font.GothamBold,TextSize=16,TextColor3=C.dim,ZIndex=125,Parent=bar})
local close=B("TextButton",{Size=UDim2.fromOffset(34,32),Position=UDim2.new(1,-34,0.5,0),AnchorPoint=Vector2.new(0,0.5),BackgroundTransparency=1,Text="×",Font=Enum.Font.GothamBold,TextSize=18,TextColor3=C.dim,ZIndex=125,Parent=bar})
B("Frame",{Size=UDim2.new(1,0,0,1),Position=UDim2.fromOffset(0,32),BackgroundColor3=C.off,BackgroundTransparency=0.1,BorderSizePixel=0,ZIndex=118,Parent=pn})
local side=B("Frame",{Size=UDim2.new(0,74,1,-33),Position=UDim2.fromOffset(0,33),BackgroundColor3=Color3.fromRGB(230,222,210),BorderSizePixel=0,ZIndex=300,Parent=pn})
local slay=Instance.new("UIListLayout") slay.Padding=UDim.new(0,4) slay.SortOrder=Enum.SortOrder.LayoutOrder slay.Parent=side
local spad=Instance.new("UIPadding") spad.PaddingLeft=UDim.new(0,6) spad.PaddingRight=UDim.new(0,6) spad.PaddingTop=UDim.new(0,6) spad.Parent=side
B("TextButton",{Size=UDim2.new(1,0,0,26),BackgroundColor3=C.accent,BorderSizePixel=0,Text="ESP",Font=Enum.Font.GothamMedium,TextSize=10,TextColor3=Color3.new(1,1,1),AutoButtonColor=false,LayoutOrder=1,ZIndex=301,Parent=side})
local body=B("Frame",{Size=UDim2.new(1,-84,1,-44),Position=UDim2.fromOffset(80,38),BackgroundTransparency=1,ZIndex=108,Parent=pn})
local ES={Killer=false,Police=false,Civ=false,Trap=false,Gun=false,Time=false}
local CLR={Killer=Color3.fromRGB(255,60,60),Police=Color3.fromRGB(60,140,255),Civ=Color3.fromRGB(60,220,110),Trap=Color3.fromRGB(255,232,120),Gun=Color3.fromRGB(90,220,255)}
local yv=0
local function mkToggle(name,key)
	local row=B("TextButton",{Size=UDim2.new(1,0,0,30),Position=UDim2.fromOffset(0,yv),BackgroundColor3=C.row,BorderSizePixel=0,Text="",AutoButtonColor=false,ZIndex=130,Parent=body})
	yv=yv+34
	B("UIStroke",{Color=Color3.fromRGB(150,140,128),Transparency=0.4,Parent=row})
	B("TextLabel",{Size=UDim2.new(1,-56,1,0),Position=UDim2.fromOffset(10,0),BackgroundTransparency=1,Text=name,Font=Enum.Font.GothamMedium,TextSize=11,TextColor3=C.txt,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=131,Parent=row})
	local sw=B("Frame",{Size=UDim2.fromOffset(32,18),Position=UDim2.new(1,-42,0.5,-9),BackgroundColor3=C.off,BorderSizePixel=0,ZIndex=131,Parent=row})
	B("UIStroke",{Color=Color3.fromRGB(95,88,80),Transparency=0.3,Parent=sw})
	local kn=B("Frame",{Size=UDim2.fromOffset(14,14),Position=UDim2.fromOffset(2,2),BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,ZIndex=132,Parent=sw})
	row.MouseButton1Click:Connect(function()
		ES[key]=not ES[key]
		sw.BackgroundColor3=ES[key] and C.accent or C.off
		TS:Create(kn,TweenInfo.new(0.18,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Position=UDim2.fromOffset(ES[key] and 16 or 2,2)}):Play()
	end)
end
mkToggle("杀手ESP","Killer")
mkToggle("警察ESP","Police")
mkToggle("平民ESP","Civ")
mkToggle("陷阱ESP","Trap")
mkToggle("枪ESP","Gun")
mkToggle("时间ESP","Time")
local function mmToast(msg)
	local g=B("ScreenGui",{IgnoreGuiInset=true,ResetOnSpawn=false,DisplayOrder=7000,Parent=SP()})
	local f=B("Frame",{Size=UDim2.fromOffset(168,28),Position=UDim2.new(1,-180,0,58),BackgroundColor3=C.bg,BackgroundTransparency=1,ZIndex=10,Parent=g})
	local s=B("UIStroke",{Color=Color3.fromRGB(25,25,25),Transparency=1,Parent=f})
	local t=B("TextLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text=msg,Font=Enum.Font.GothamMedium,TextSize=10,TextColor3=Color3.fromRGB(190,150,60),TextTransparency=1,ZIndex=11,Parent=f})
	TS:Create(f,TweenInfo.new(0.22),{BackgroundTransparency=0.05}):Play()
	TS:Create(s,TweenInfo.new(0.22),{Transparency=0}):Play()
	TS:Create(t,TweenInfo.new(0.22),{TextTransparency=0}):Play()
	task.delay(1.3,function()
		TS:Create(f,TweenInfo.new(0.22),{BackgroundTransparency=1}):Play()
		TS:Create(s,TweenInfo.new(0.22),{Transparency=1}):Play()
		TS:Create(t,TweenInfo.new(0.22),{TextTransparency=1}):Play()
	end)
	task.delay(1.65,function() pcall(function() g:Destroy() end) end)
end
-- ============================================================
-- [新增] 警长功能 / 杀手功能
-- 依赖本文件已有: B TS C pn side body LP P mmToast
-- 道具判定: Tool 名 "Knife" = 杀手, "Gun" = 警长 (与第170行逻辑一致)
-- ============================================================
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

local CFG = { ShAim = false, ShLoop = false, KnOn = false, KnR = 20 }
local RT = {}

-- ---------- 角色 / 道具 ----------
local function toolOf(pl, nm)
	local c = pl and pl.Character
	local bp = pl and pl:FindFirstChild("Backpack")
	if c then
		local t = c:FindFirstChild(nm)
		if t and t:IsA("Tool") then return t end
	end
	if bp then
		local t = bp:FindFirstChild(nm)
		if t and t:IsA("Tool") then return t end
	end
end
local function findKiller()
	for _, pl in ipairs(P:GetPlayers()) do
		if pl ~= LP and pl.Character and toolOf(pl, "Knife") then
			return pl, pl.Character
		end
	end
end
local function findSheriff()
	for _, pl in ipairs(P:GetPlayers()) do
		if pl ~= LP and pl.Character and toolOf(pl, "Gun") then
			return pl, pl.Character
		end
	end
end
local function myKnife() return toolOf(LP, "Knife") end
local function myGun() return toolOf(LP, "Gun") end
local function isMurderer() return myKnife() ~= nil end
local function isSheriff() return myGun() ~= nil end
local function myChar()
	local c = LP.Character
	if not c then return end
	local h = c:FindFirstChildOfClass("Humanoid")
	local r = c:FindFirstChild("HumanoidRootPart")
	if h and r then return c, h, r end
end

-- ---------- 页面 ----------
local espBtn
for _, ch in ipairs(side:GetChildren()) do
	if ch:IsA("TextButton") and ch.Text == "ESP" then espBtn = ch break end
end
local function mkPageBtn(txt, order)
	return B("TextButton",{Size=UDim2.new(1,0,0,26),BackgroundColor3=C.row,BorderSizePixel=0,Text=txt,Font=Enum.Font.GothamMedium,TextSize=10,TextColor3=C.txt,AutoButtonColor=false,LayoutOrder=order,ZIndex=301,Parent=side})
end
local shBtn = mkPageBtn("警长功能", 2)
local muBtn = mkPageBtn("杀手功能", 3)

local function mkPage()
	return B("ScrollingFrame",{Size=UDim2.new(1,-84,1,-44),Position=UDim2.fromOffset(80,38),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=2,ScrollBarImageColor3=C.off,CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,ScrollingDirection=Enum.ScrollingDirection.Y,ZIndex=108,Visible=false,Parent=pn})
end
local bodySh = mkPage()
local bodyMu = mkPage()

local function showPage(p, btn)
	body.Visible = (p == body)
	bodySh.Visible = (p == bodySh)
	bodyMu.Visible = (p == bodyMu)
	for _, x in ipairs({espBtn, shBtn, muBtn}) do
		if x then
			x.BackgroundColor3 = (x == btn) and C.accent or C.row
			x.TextColor3 = (x == btn) and Color3.new(1,1,1) or C.txt
		end
	end
end
if espBtn then espBtn.MouseButton1Click:Connect(function() showPage(body, espBtn) end) end
shBtn.MouseButton1Click:Connect(function() showPage(bodySh, shBtn) end)
muBtn.MouseButton1Click:Connect(function() showPage(bodyMu, muBtn) end)

-- ---------- 控件 ----------
local function rowToggle(par, yRef, label, key, cb)
	local row = B("TextButton",{Size=UDim2.new(1,0,0,30),Position=UDim2.fromOffset(0,yRef.v),BackgroundColor3=C.row,BorderSizePixel=0,Text="",AutoButtonColor=false,ZIndex=130,Parent=par})
	yRef.v = yRef.v + 34
	B("UIStroke",{Color=Color3.fromRGB(150,140,128),Transparency=0.4,Parent=row})
	B("TextLabel",{Size=UDim2.new(1,-56,1,0),Position=UDim2.fromOffset(10,0),BackgroundTransparency=1,Text=label,Font=Enum.Font.GothamMedium,TextSize=11,TextColor3=C.txt,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=131,Parent=row})
	local sw = B("Frame",{Size=UDim2.fromOffset(32,18),Position=UDim2.new(1,-42,0.5,-9),BackgroundColor3=CFG[key] and C.accent or C.off,BorderSizePixel=0,ZIndex=131,Parent=row})
	B("UIStroke",{Color=Color3.fromRGB(95,88,80),Transparency=0.3,Parent=sw})
	local kn = B("Frame",{Size=UDim2.fromOffset(14,14),Position=UDim2.fromOffset(CFG[key] and 16 or 2,2),BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,ZIndex=132,Parent=sw})
	row.MouseButton1Click:Connect(function()
		CFG[key] = not CFG[key]
		sw.BackgroundColor3 = CFG[key] and C.accent or C.off
		TS:Create(kn,TweenInfo.new(0.18,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Position=UDim2.fromOffset(CFG[key] and 16 or 2,2)}):Play()
		if cb then pcall(cb, CFG[key]) end
	end)
end

local function rowButton(par, yRef, label, cb)
	local row = B("TextButton",{Size=UDim2.new(1,0,0,28),Position=UDim2.fromOffset(0,yRef.v),BackgroundColor3=C.row,BorderSizePixel=0,Text=label,Font=Enum.Font.GothamMedium,TextSize=11,TextColor3=C.txt,AutoButtonColor=false,ZIndex=130,Parent=par})
	yRef.v = yRef.v + 32
	B("UIStroke",{Color=Color3.fromRGB(150,140,128),Transparency=0.4,Parent=row})
	row.MouseButton1Click:Connect(function() pcall(cb) end)
end

local function rowNum(par, yRef, label, key, ph, mn, mx, cb)
	local row = B("Frame",{Size=UDim2.new(1,0,0,30),Position=UDim2.fromOffset(0,yRef.v),BackgroundColor3=C.row,BorderSizePixel=0,ZIndex=130,Parent=par})
	yRef.v = yRef.v + 34
	B("UIStroke",{Color=Color3.fromRGB(150,140,128),Transparency=0.4,Parent=row})
	B("TextLabel",{Size=UDim2.new(1,-86,1,0),Position=UDim2.fromOffset(10,0),BackgroundTransparency=1,Text=label,Font=Enum.Font.GothamMedium,TextSize=11,TextColor3=C.txt,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=131,Parent=row})
	local tb = B("TextBox",{Size=UDim2.fromOffset(64,20),Position=UDim2.new(1,-72,0.5,-10),BackgroundColor3=C.off,BorderSizePixel=0,Text=tostring(CFG[key] or ""),PlaceholderText=ph or "",PlaceholderColor3=C.dim,Font=Enum.Font.GothamMedium,TextSize=11,TextColor3=C.txt,ClearTextOnFocus=false,ZIndex=131,Parent=row})
	tb:GetPropertyChangedSignal("Text"):Connect(function()
		local v = tonumber(tb.Text)
		if v then
			CFG[key] = math.clamp(v, mn, mx)
			if cb then pcall(cb, CFG[key]) end
		end
	end)
end

-- ---------- 1. 子弹追踪(杀手) ----------
-- hook __namecall, 拦截 Raycast / FireServer 的攻击参数,
-- 把目标点替换成杀手 Head, 无 FOV 全向强锁
local shTgt = nil
task.spawn(function()
	while true do
		task.wait(0.2)
		pcall(function()
			if CFG.ShAim then
				local _, ch = findKiller()
				shTgt = ch
			else
				shTgt = nil
			end
		end)
	end
end)

-- ---------- 2. 甩飞 ----------
local function flingOne(pl, tag)
	if RT.flingC then mmToast("甩飞进行中") return end
	local c, h, r = myChar()
	local tc = pl and pl.Character
	local tr = tc and tc:FindFirstChild("HumanoidRootPart")
	if not (r and tr) then mmToast("甩飞失败 · 目标无效") return end
	RT.flingSave = r.CFrame
	local endT = os.clock() + 0.85
	RT.flingC = RS.RenderStepped:Connect(function()
		local c2, h2, r2 = myChar()
		if not r2 then
			if RT.flingC then RT.flingC:Disconnect() RT.flingC = nil end
			return
		end
		local cur = pl.Character and pl.Character:FindFirstChild("HumanoidRootPart")
		if cur then
			r2.CFrame = cur.CFrame
			r2.AssemblyAngularVelocity = Vector3.new(6e4, 6e4, 6e4)
			r2.AssemblyLinearVelocity = Vector3.new(0, 4e3, 0)
		end
		if os.clock() >= endT then
			RT.flingC:Disconnect() RT.flingC = nil
			local c3, h3, r3 = myChar()
			if r3 and RT.flingSave then
				r3.CFrame = RT.flingSave
				r3.AssemblyLinearVelocity = Vector3.zero
				r3.AssemblyAngularVelocity = Vector3.zero
			end
			RT.flingSave = nil
			mmToast((tag or "目标") .. " 已甩飞")
		end
	end)
end

-- ---------- 3. 传送到身后 ----------
local function tpBehind(pl)
	local c, h, r = myChar()
	local tc = pl and pl.Character
	local tr = tc and tc:FindFirstChild("HumanoidRootPart")
	if not (r and tr) then mmToast("传送失败 · 目标无效") return end
	r.CFrame = tr.CFrame * CFrame.new(0, 0, 3)
	r.AssemblyLinearVelocity = Vector3.zero
	r.AssemblyAngularVelocity = Vector3.zero
	mmToast("已传送到 " .. pl.Name .. " 身后")
end

-- ---------- 4. 循环传送到身后(穿墙) ----------
local function tpLoopSet(on)
	if RT.tplC then RT.tplC:Disconnect() RT.tplC = nil end
	if RT.tplClip then RT.tplClip:Disconnect() RT.tplClip = nil end
	if not on then
		local c, h, r = myChar()
		if RT.tplSave and r then
			r.CFrame = RT.tplSave
			r.AssemblyLinearVelocity = Vector3.zero
			r.AssemblyAngularVelocity = Vector3.zero
		end
		RT.tplSave = nil
		if RT.tplCols then
			for p, o in pairs(RT.tplCols) do
				if p and p.Parent then pcall(function() p.CanCollide = o end) end
			end
			RT.tplCols = nil
		end
		mmToast("已回到原位")
		return
	end
	local c, h, r = myChar()
	if not r then return end
	RT.tplSave = r.CFrame
	RT.tplCols = {}
	-- 穿墙: 身体部件 CanCollide 全关
	RT.tplClip = RS.RenderStepped:Connect(function()
		local cc = LP.Character
		if not cc then return end
		for _, d in ipairs(cc:GetDescendants()) do
			if d:IsA("BasePart") and RT.tplCols[d] == nil then
				RT.tplCols[d] = d.CanCollide
				d.CanCollide = false
			end
		end
	end)
	-- 每帧跟到杀手背后 3.2 格
	RT.tplC = RS.RenderStepped:Connect(function()
		local cc, hh, rr = myChar()
		if not rr then return end
		local kpl, kch = findKiller()
		local tr = kch and kch:FindFirstChild("HumanoidRootPart")
		if tr then
			rr.CFrame = tr.CFrame * CFrame.new(0, 0, 3.2)
			rr.AssemblyLinearVelocity = Vector3.zero
		end
	end)
	mmToast("循环跟随已开启")
end

-- ---------- 击杀核心 ----------
-- MM2 刀是 Tool.Activated 复制到服务器 + Handle 距离判定,
-- 所以"贴脸 + Activate"是有效路径
local function stabOne(pl)
	local c, h, r = myChar()
	local tool = myKnife()
	local tr = pl and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart")
	if not (r and tool and tr) then return false end
	r.CFrame = tr.CFrame
	pcall(function() tool:Activate() end)
	pcall(function() tool:Activate() end)
	return true
end

local function killAll()
	if not isMurderer() then mmToast("你不是杀手") return end
	local c, h, r = myChar()
	local tool = myKnife()
	if not (r and tool) then mmToast("手里没刀") return end
	local save = r.CFrame
	local n = 0
	for _, pl in ipairs(P:GetPlayers()) do
		if pl ~= LP and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
			r.CFrame = pl.Character.HumanoidRootPart.CFrame
			pcall(function() tool:Activate() end)
			n = n + 1
			task.wait(0.06)
		end
	end
	r.CFrame = save
	r.AssemblyLinearVelocity = Vector3.zero
	r.AssemblyAngularVelocity = Vector3.zero
	mmToast("一键击杀 · " .. n .. " 人")
end

local function killSheriff()
	if not isMurderer() then mmToast("你不是杀手") return end
	local pl = findSheriff()
	if not pl then mmToast("没找到警长") return end
	stabOne(pl)
	mmToast("已击杀警长 " .. pl.Name)
end

local function killNearest()
	if not isMurderer() then mmToast("你不是杀手") return end
	local c, h, r = myChar()
	if not r then return end
	local best, bd = nil, math.huge
	for _, pl in ipairs(P:GetPlayers()) do
		if pl ~= LP and pl.Character then
			local tr = pl.Character:FindFirstChild("HumanoidRootPart")
			if tr then
				local d = (tr.Position - r.Position).Magnitude
				if d < bd then bd = d best = pl end
			end
		end
	end
	if not best then mmToast("附近没人") return end
	stabOne(best)
	mmToast("已击杀最近 " .. best.Name)
end
	if not isMurderer() then mmToast("你不是杀手") return end
	local pl = findSheriff()
	if not pl then mmToast("没找到警长") return end
	flingOne(pl, "警长")
end

-- ---------- 5. 修改飞刀范围 ----------
local KN = {}
local function knifeRangeSet()
	if not CFG.KnOn then
		for p, o in pairs(KN) do
			if p and p.Parent then pcall(function() p.Size = o end) end
		end
		KN = {}
		return
	end
	local range = math.clamp(tonumber(CFG.KnR) or 20, 10, 60)
	local mult = math.max(1, range / 4)
	local function blow(t)
		if not t then return end
		for _, d in ipairs(t:GetDescendants()) do
			if d:IsA("BasePart") and KN[d] == nil then
				KN[d] = d.Size
				d.Size = d.Size * mult
				d.CanTouch = true
			end
		end
	end
	blow(myKnife())
	local cc = LP.Character
	if cc then
		for _, d in ipairs(cc:GetDescendants()) do
			if d:IsA("Tool") then blow(d) end
		end
	end
	local bp = LP:FindFirstChild("Backpack")
	if bp then
		for _, d in ipairs(bp:GetChildren()) do
			if d:IsA("Tool") then blow(d) end
		end
	end
end
workspace.DescendantAdded:Connect(function(d)
	if not (CFG.KnOn and CFG.KnR) then return end
	if not d:IsA("BasePart") then return end
	local nm = string.lower(d.Name or "")
	if string.find(nm, "knife") or string.find(nm, "blade") or string.find(nm, "throw") then
		task.delay(0.15, function()
			if not CFG.KnOn then return end
			if KN[d] == nil and d.Parent then
				KN[d] = d.Size
				local range = math.clamp(tonumber(CFG.KnR) or 20, 10, 60)
				d.Size = Vector3.new(range * 0.5, range * 0.5, range * 0.5)
				d.CanTouch = true
			end
		end)
	end
end)

-- ---------- 统一 namecall hook: 子弹追踪 + 飞刀方向修正 ----------
pcall(function()
	local old
	old = hookmetamethod(game, "__namecall", function(self, ...)
		local m = getnamecallmethod()
		local cam = workspace.CurrentCamera
		local cp = (cam and cam.CFrame.Position) or Vector3.zero
		-- 子弹追踪
		if CFG.ShAim and shTgt and shTgt.Parent then
			local head = shTgt:FindFirstChild("Head") or shTgt:FindFirstChild("HumanoidRootPart")
			if head then
				local aim = (head.Position - cp).Unit * 1000
				if m == "Raycast" then
					local a = {...}
					if #a >= 2 and typeof(a[1]) == "Vector3" and typeof(a[2]) == "Vector3" then
						a[1] = cp a[2] = aim
						return old(self, table.unpack(a))
					end
				elseif m == "FireServer" then
					local a = {...}
					local n = #a
					if n >= 2 and typeof(a[n-1]) == "Vector3" and typeof(a[n]) == "Vector3" then
						a[n-1] = cp a[n] = aim
						return old(self, table.unpack(a))
					end
				end
			end
		end
		-- 飞刀方向修正(保持原速度大小, 只改方向到范围内最近敌人)
		if CFG.KnOn and (m == "FireServer" or m == "InvokeServer") then
			local nm = string.lower(self.Name or "")
			if string.find(nm, "throw") or string.find(nm, "knife") or string.find(nm, "blade") then
				local range = math.clamp(tonumber(CFG.KnR) or 20, 10, 60)
				local c, h, r = myChar()
				if r then
					local best, bd = nil, range
					for _, pl in ipairs(P:GetPlayers()) do
						if pl ~= LP and pl.Character then
							local tr = pl.Character:FindFirstChild("HumanoidRootPart")
							if tr then
								local d = (tr.Position - r.Position).Magnitude
								if d < bd then bd = d best = tr end
							end
						end
					end
					if best then
						local a = {...}
						for i = #a, 1, -1 do
							if typeof(a[i]) == "Vector3" then
								local mag = a[i].Magnitude
								if mag > 0.01 then
									a[i] = (best.Position - cp).Unit * mag
									return old(self, table.unpack(a))
								end
								break
							end
						end
					end
				end
			end
		end
		return old(self, ...)
	end)
end)

-- ---------- 面板构建 ----------
local ySh = {v = 0}
local yMu = {v = 0}

rowToggle(bodySh, ySh, "子弹追踪（杀手）", "ShAim")
rowButton(bodySh, ySh, "甩飞杀手", function()
	local pl = findKiller()
	if not pl then mmToast("没找到杀手") return end
	flingOne(pl, "杀手")
end)
rowButton(bodySh, ySh, "传送到杀手身后", function()
	local pl = findKiller()
	if not pl then mmToast("没找到杀手") return end
	tpBehind(pl)
end)
rowToggle(bodySh, ySh, "循环传送到杀手身后", "ShLoop", tpLoopSet)

rowButton(bodyMu, yMu, "一键击杀所有人", killAll)
rowButton(bodyMu, yMu, "击杀警长", killSheriff)
rowButton(bodyMu, yMu, "击杀最近的人", killNearest)
rowButton(bodyMu, yMu, "甩飞警长", flingSheriff)
rowToggle(bodyMu, yMu, "修改飞刀范围", "KnOn", function() knifeRangeSet() end)
rowNum(bodyMu, yMu, "飞刀范围", "KnR", "10-60", 10, 60, function() knifeRangeSet() end)
minBtn.MouseButton1Click:Connect(function()
	pn.Visible=false
	if gui:FindFirstChild("iconHolder") then return end
	local holder=B("Frame",{Name="iconHolder",Size=UDim2.fromOffset(64,64),Position=UDim2.fromOffset(14,14),BackgroundTransparency=1,ZIndex=900,Parent=gui})
	local hit=B("TextButton",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="",AutoButtonColor=false,Active=true,Selectable=true,ZIndex=901,Parent=holder})
	local ib=B("TextButton",{Size=UDim2.fromOffset(36,36),Position=UDim2.fromScale(0.5,0.5),AnchorPoint=Vector2.new(0.5,0.5),BackgroundColor3=Color3.fromRGB(255,255,255),BackgroundTransparency=0.55,Text="wx",Font=Enum.Font.GothamBold,TextSize=12,TextColor3=Color3.fromRGB(60,60,60),AutoButtonColor=false,Active=false,ZIndex=902,Parent=holder})
	B("UICorner",{CornerRadius=UDim.new(1,0),Parent=ib})
	local isk=B("UIStroke",{Color=Color3.fromRGB(255,255,255),Transparency=0.2,Thickness=1.5,Parent=ib})
	B("UIGradient",{Rotation=125,Color=ColorSequence.new(Color3.fromRGB(255,255,255),Color3.fromRGB(190,205,225)),Parent=ib})
	local sc=Instance.new("UIScale") sc.Scale=0.4 sc.Parent=holder
	TS:Create(sc,TweenInfo.new(0.22,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Scale=1}):Play()
	local drag=false
	local off=Vector2.zero
	local moved=0
	hit.InputBegan:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then
			drag=true moved=0
			off=holder.AbsolutePosition-Vector2.new(i.Position.X,i.Position.Y)
		end
	end)
	hit.InputChanged:Connect(function(i)
		if drag and (i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseMovement) then
			moved=moved+math.abs(i.Delta.X)+math.abs(i.Delta.Y)
			holder.Position=UDim2.fromOffset(i.Position.X+off.X,i.Position.Y+off.Y)
		end
	end)
	hit.InputEnded:Connect(function()
		if not drag then return end
		drag=false
		if moved>=8 then return end
		local s2=holder:FindFirstChildOfClass("UIScale")
		if s2 then TS:Create(s2,TweenInfo.new(0.12,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Scale=0.3}):Play() end
		task.delay(0.12,function() pcall(function() holder:Destroy() end) end)
		pn.Visible=true
		pn.Size=UDim2.fromOffset(math.floor(PW*0.92),math.floor(PH*0.92))
		pn.Position=UDim2.fromOffset(x0+math.floor(PW*0.04),y0+math.floor(PH*0.04))
		pn.BackgroundTransparency=1
		TS:Create(pn,TweenInfo.new(0.22,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Size=UDim2.fromOffset(PW,PH),Position=UDim2.fromOffset(x0,y0),BackgroundTransparency=0.03}):Play()
	end)
end)
close.MouseButton1Click:Connect(function()
	for _,d in ipairs(workspace:GetDescendants()) do
		if d.Name=="mm2hl" then pcall(function() d:Destroy() end) end
	end
	pcall(function()
		for _,g in ipairs(SP():GetChildren()) do
			if g.Name=="mm2_ui" or g.Name=="mm2_icon" then g:Destroy() end
		end
	end)
end)
local HL={}
local function hl(obj,col,on)
	if not obj then return end
	local h=HL[obj]
	if not h then
		h=Instance.new("Highlight")
				h.Name="mm2hl"
		h.FillTransparency=1
		h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
		h.Parent=obj
		HL[obj]=h
	end
	h.OutlineColor=col
	h.Enabled=on
end
local timeGui=B("ScreenGui",{IgnoreGuiInset=true,ResetOnSpawn=false,DisplayOrder=65,Parent=SP()})
local timeLbl=B("TextLabel",{Size=UDim2.fromOffset(180,22),Position=UDim2.new(0.5,-90,0,4),BackgroundTransparency=1,Text="",Font=Enum.Font.GothamBold,TextSize=16,TextColor3=C.txt,TextStrokeTransparency=0.5,Visible=false,Parent=timeGui})
local roundEnd=0
local lastGun=false
task.spawn(function()
	while task.wait(0.6) do
		pcall(function()
			local sawRole=false
			for _,pl in ipairs(P:GetPlayers()) do
				local c=pl.Character
				if c and c:FindFirstChildOfClass("Humanoid") then
					local hasKnife=(c:FindFirstChild("Knife")~=nil) or (pl.Backpack and pl.Backpack:FindFirstChild("Knife"))
					local hasGun=(c:FindFirstChild("Gun")~=nil) or (pl.Backpack and pl.Backpack:FindFirstChild("Gun"))
					if hasKnife then
						sawRole=true
						hl(c,CLR.Killer,ES.Killer)
					elseif hasGun then
						sawRole=true
						hl(c,CLR.Police,ES.Police)
					elseif sawRole and pl~=LP then
						hl(c,CLR.Civ,ES.Civ)
					else
						hl(c,CLR.Civ,false)
					end
				end
			end
			for _,o in ipairs(workspace:GetChildren()) do
				local nm=string.lower(o.Name)
				if o:IsA("Tool") and string.find(nm,"gun") then
					hl(o,CLR.Gun,ES.Gun)
					if ES.Gun and not lastGun then mmToast("枪械已掉落") end
					lastGun=true
				elseif string.find(nm,"trap") or string.find(nm,"beartrap") then
					hl(o,CLR.Trap,ES.Trap)
				end
			end
			if lastGun and not workspace:FindFirstChildWhichIsA("Tool") then
				lastGun=false
				mmToast("枪械已被拾取")
			end
			if ES.Time then
				if roundEnd==0 or roundEnd-os.clock()<-5 then roundEnd=os.clock()+180 end
				local left=math.max(0,math.floor(roundEnd-os.clock()))
				timeLbl.Text=string.format("%d:%02d",math.floor(left/60),left%60)
				timeLbl.Visible=true
			else
				timeLbl.Visible=false
			end
		end)
	end
end)
--==== 自动 栏目 ====
local AU={Coin=false,GunPick=false}
local autoBtn=B("TextButton",{Size=UDim2.new(1,0,0,26),BackgroundColor3=C.row,BorderSizePixel=0,Text="自动",Font=Enum.Font.GothamMedium,TextSize=10,TextColor3=C.txt,AutoButtonColor=false,LayoutOrder=4,ZIndex=301,Parent=side})
local bodyAuto=B("Frame",{Size=UDim2.new(1,-84,1,-44),Position=UDim2.fromOffset(80,38),BackgroundTransparency=1,Visible=false,ZIndex=108,Parent=pn})
autoBtn.MouseButton1Click:Connect(function()
	local v=not bodyAuto.Visible
	bodyAuto.Visible=v
	body.Visible=not v
	autoBtn.BackgroundColor3=v and C.accent or C.row
	autoBtn.TextColor3=v and Color3.new(1,1,1) or C.txt
end)
local ay=0
local function mkToggle2(name,key)
	local row=B("TextButton",{Size=UDim2.new(1,0,0,30),Position=UDim2.fromOffset(0,ay),BackgroundColor3=C.row,BorderSizePixel=0,Text="",AutoButtonColor=false,ZIndex=130,Parent=bodyAuto})
	ay=ay+34
	B("UIStroke",{Color=Color3.fromRGB(150,140,128),Transparency=0.4,Parent=row})
	B("TextLabel",{Size=UDim2.new(1,-56,1,0),Position=UDim2.fromOffset(10,0),BackgroundTransparency=1,Text=name,Font=Enum.Font.GothamMedium,TextSize=11,TextColor3=C.txt,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=131,Parent=row})
	local sw=B("Frame",{Size=UDim2.fromOffset(32,18),Position=UDim2.new(1,-42,0.5,-9),BackgroundColor3=C.off,BorderSizePixel=0,ZIndex=131,Parent=row})
	B("UIStroke",{Color=Color3.fromRGB(95,88,80),Transparency=0.3,Parent=sw})
	local kn=B("Frame",{Size=UDim2.fromOffset(14,14),Position=UDim2.fromOffset(2,2),BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,ZIndex=132,Parent=sw})
	row.MouseButton1Click:Connect(function()
		AU[key]=not AU[key]
		sw.BackgroundColor3=AU[key] and C.accent or C.off
		TS:Create(kn,TweenInfo.new(0.18,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Position=UDim2.fromOffset(AU[key] and 16 or 2,2)}):Play()
	end)
end
mkToggle2("自动拾取金币","Coin")
mkToggle2("自动传送捡枪","GunPick")
task.spawn(function()
	while true do
		task.wait(0.1)
		if AU.Coin then
			pcall(function()
				local ch=LP.Character
				local hr=ch and ch:FindFirstChild("HumanoidRootPart")
				if not hr then return end
				local best,bd=nil,1e9
				for _,o in ipairs(workspace:GetChildren()) do
					local nm=string.lower(o.Name)
					if string.find(nm,"coin") or string.find(nm,"金币") then
						local p=o:IsA("BasePart") and o or o.PrimaryPart
						if p and p.Parent then
							local d=(p.Position-hr.Position).Magnitude
							if d<bd then best=p bd=d end
						end
					end
				end
				if best then
					hr.CFrame=CFrame.new(best.Position+Vector3.new(0,3,0))
					task.wait(0.03)
				end
			end)
		end
	end
end)
task.spawn(function()
	while true do
		task.wait(0.1)
		if AU.GunPick then
			pcall(function()
				local ch=LP.Character
				local hr=ch and ch:FindFirstChild("HumanoidRootPart")
				if not hr then return end
				local gun=nil
				for _,o in ipairs(workspace:GetChildren()) do
					if o:IsA("Tool") and string.find(string.lower(o.Name),"gun") then gun=o break end
				end
				if gun and gun.Parent then
					local origin=hr.CFrame
					hr.CFrame=CFrame.new(gun.Position+Vector3.new(0,3,0))
					task.wait(0.04)
					hr.CFrame=origin
				end
			end)
		end
	end
end)
