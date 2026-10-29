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
local espBtn=B("TextButton",{Size=UDim2.new(1,0,0,26),BackgroundColor3=C.accent,BorderSizePixel=0,Text="ESP",Font=Enum.Font.GothamMedium,TextSize=10,TextColor3=Color3.new(1,1,1),AutoButtonColor=false,LayoutOrder=1,ZIndex=301,Parent=side})
local body=B("ScrollingFrame",{Size=UDim2.new(1,-84,1,-44),Position=UDim2.fromOffset(80,38),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=2,CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,ScrollBarImageColor3=C.off,ZIndex=108,Parent=pn})
local ES={Killer=false,Police=false,Civ=false,Trap=false,Gun=false,Time=false,Line=false}
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
		local ti=TweenInfo.new(0.22,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
		TS:Create(kn,ti,{Position=UDim2.fromOffset(ES[key] and 16 or 2,2)}):Play()
		TS:Create(sw,TweenInfo.new(0.22,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{BackgroundColor3=ES[key] and C.accent or C.off}):Play()
	end)
end
mkToggle("杀手ESP","Killer")
mkToggle("警察ESP","Police")
mkToggle("平民ESP","Civ")
mkToggle("陷阱ESP","Trap")
mkToggle("枪ESP","Gun")
mkToggle("时间ESP","Time")
mkToggle("射线ESP","Line")
local posV="顶部"
B("TextLabel",{Size=UDim2.new(1,0,0,14),Position=UDim2.fromOffset(10,yv),BackgroundTransparency=1,Text="射线的颜色取决于ESP颜色",Font=Enum.Font.GothamMedium,TextSize=9,TextColor3=C.dim,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=131,Parent=body})
yv=yv+18
local pRow=B("TextButton",{Size=UDim2.new(1,0,0,28),Position=UDim2.fromOffset(0,yv),BackgroundColor3=C.row,BorderSizePixel=0,Text="",AutoButtonColor=false,ZIndex=130,Parent=body})
B("UIStroke",{Color=Color3.fromRGB(150,140,128),Transparency=0.4,Parent=pRow})
B("TextLabel",{Size=UDim2.new(1,-56,1,0),Position=UDim2.fromOffset(10,0),BackgroundTransparency=1,Text="射线位置",Font=Enum.Font.GothamMedium,TextSize=11,TextColor3=C.txt,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=131,Parent=pRow})
local pVal=B("TextLabel",{Size=UDim2.new(0,52,1,0),Position=UDim2.new(1,-58,0,0),BackgroundTransparency=1,Text=posV,Font=Enum.Font.GothamMedium,TextSize=11,TextColor3=C.accent,TextXAlignment=Enum.TextXAlignment.Right,ZIndex=131,Parent=pRow})
yv=yv+32

local pickGui=B("ScreenGui",{Name="mm2_pick",IgnoreGuiInset=true,ResetOnSpawn=false,DisplayOrder=9000,Enabled=false,Parent=SP()})
gui.Destroying:Connect(function() pcall(function() pickGui:Destroy() end) end)
local shade=B("TextButton",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="",AutoButtonColor=false,ZIndex=1,Parent=pickGui})
local box=B("Frame",{Size=UDim2.fromOffset(120,120),Position=UDim2.fromScale(0.5,0.5),AnchorPoint=Vector2.new(0.5,0.5),BackgroundColor3=C.bg,BackgroundTransparency=1,BorderSizePixel=0,Active=true,ZIndex=2,Parent=pickGui})
B("UIStroke",{Color=Color3.fromRGB(150,140,128),Transparency=0.35,Parent=box})
local optBtns={}
local closePick
local function openPick()
	pickGui.Enabled=true
	box.Size=UDim2.fromOffset(70,70)
	for _,b in ipairs(optBtns) do b.BackgroundTransparency=1 b.TextTransparency=1 end
	TS:Create(box,TweenInfo.new(0.26,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Size=UDim2.fromOffset(120,120),BackgroundTransparency=0.03}):Play()
	task.delay(0.05,function()
		for _,b in ipairs(optBtns) do
			TS:Create(b,TweenInfo.new(0.2),{BackgroundTransparency=0,TextTransparency=0}):Play()
		end
	end)
end
closePick=function()
	TS:Create(box,TweenInfo.new(0.15,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{Size=UDim2.fromOffset(70,70),BackgroundTransparency=1}):Play()
	for _,b in ipairs(optBtns) do
		TS:Create(b,TweenInfo.new(0.13),{BackgroundTransparency=1,TextTransparency=1}):Play()
	end
	task.delay(0.15,function() pickGui.Enabled=false end)
end
local function mkOpt(name,val,order)
	local b=B("TextButton",{Size=UDim2.new(1,-16,0,44),Position=UDim2.fromOffset(8,order*50+8),BackgroundColor3=C.row,BorderSizePixel=0,Text=name,Font=Enum.Font.GothamMedium,TextSize=12,TextColor3=(posV==val) and C.accent or C.txt,AutoButtonColor=false,BackgroundTransparency=1,TextTransparency=1,ZIndex=3,Parent=box})
	B("UIStroke",{Color=Color3.fromRGB(150,140,128),Transparency=0.4,Parent=b})
	table.insert(optBtns,b)
	b.MouseButton1Click:Connect(function()
		posV=val
		pVal.Text=posV
		for _,o in ipairs(optBtns) do o.TextColor3=(o==b) and C.accent or C.txt end
		closePick()
	end)
end
mkOpt("顶部","顶部",0)
mkOpt("底部","底部",1)
shade.MouseButton1Click:Connect(function() closePick() end)
pRow.MouseButton1Click:Connect(function() openPick() end)
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
local autoBtn
local bodyAuto

local function mkPage()
	return B("ScrollingFrame",{Size=UDim2.new(1,-84,1,-44),Position=UDim2.fromOffset(80,38),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=2,ScrollBarImageColor3=C.off,CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,ScrollingDirection=Enum.ScrollingDirection.Y,ZIndex=108,Visible=false,Parent=pn})
end
local bodySh = mkPage()
local bodyMu = mkPage()

local function showPage(p, btn)
	body.Visible = (p == body)
	bodySh.Visible = (p == bodySh)
	bodyMu.Visible = (p == bodyMu)
	if bodyAuto then bodyAuto.Visible = (p == bodyAuto) end
	local all={espBtn,shBtn,muBtn,autoBtn}
	for _,x in ipairs(all) do
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
	RT.flingSize = r.Size
	pcall(function() r.Size = Vector3.new(10, 10, 10) end)
	local endT = os.clock() + 1.25
	RT.flingC = RS.RenderStepped:Connect(function()
		local c2, h2, r2 = myChar()
		if not r2 then
			if RT.flingC then RT.flingC:Disconnect() RT.flingC = nil end
			return
		end
		local cur = pl.Character and pl.Character:FindFirstChild("HumanoidRootPart")
		if cur then
			r2.CFrame = cur.CFrame
			r2.AssemblyLinearVelocity = Vector3.new(0, 6e4, 0)
			r2.AssemblyAngularVelocity = Vector3.new(6e4, 6e4, 6e4)
		end
		if os.clock() >= endT then
			RT.flingC:Disconnect() RT.flingC = nil
			local c3, h3, r3 = myChar()
			if r3 then
				if RT.flingSave then r3.CFrame = RT.flingSave end
				if RT.flingSize then pcall(function() r3.Size = RT.flingSize end) end
				r3.AssemblyLinearVelocity = Vector3.zero
				r3.AssemblyAngularVelocity = Vector3.zero
			end
			RT.flingSave = nil
			RT.flingSize = nil
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

local function flingSheriff()
	if not isMurderer() then mmToast("你不是杀手") return end
	local pl = findSheriff()
	if not pl then mmToast("没找到警长") return end
	flingOne(pl, "警长")
end

-- ---------- 5. 飞刀范围：隐形判定盒（原部件不动） ----------
local KN = {}
local function knClear()
	for _, p in pairs(KN) do
		if p then pcall(function() p:Destroy() end) end
	end
	KN = {}
end
local function knApply()
	local s = math.clamp(tonumber(CFG.KnR) or 20, 10, 60) / 4 * 6
	for pl, box in pairs(KN) do
		if not pl.Character or not pl.Character.Parent or not box.Parent then
			if box then pcall(function() box:Destroy() end) end
			KN[pl] = nil
		end
	end
	for _, pl in ipairs(P:GetPlayers()) do
		if pl ~= LP and pl.Character then
			local hr = pl.Character:FindFirstChild("HumanoidRootPart")
			if hr then
				local box = KN[pl]
				if not box or not box.Parent then
					box = Instance.new("Part")
					box.Name = "wx_hitbox"
					box.Transparency = 1
					box.CanCollide = false
					box.CanTouch = true
					box.CanQuery = false
					box.Massless = true
					box.Anchored = true
					box.Parent = pl.Character
					KN[pl] = box
				end
				box.Size = Vector3.new(s, s, s)
				box.CFrame = hr.CFrame
			end
		end
	end
end
local function knifeRangeSet()
	if not CFG.KnOn then knClear() else knApply() end
end
RS.RenderStepped:Connect(function()
	if CFG.KnOn then knApply() end
end)

-- ---------- 统一 namecall hook（已修复语法错误） ----------
pcall(function()
	local atkKeys = {"shoot", "fire", "bullet", "gun", "hit", "attack", "damage", "ray", "swing", "stab", "slash"}
	local function isAtkRemote(nm)
		nm = string.lower(nm or "")
		for _, k in ipairs(atkKeys) do
			if string.find(nm, k, 1, true) then return true end
		end
		return false
	end
	local cam, camT = nil, 0
	local function getCamPos()
		local now = os.clock()
		if not cam or now - camT > 0.25 then
			cam = workspace.CurrentCamera
			camT = now
		end
		return (cam and cam.CFrame.Position) or Vector3.zero
	end
	local old
	old = hookmetamethod(game, "__namecall", function(self, ...)
		if not (CFG.ShAim or CFG.KnOn) then return old(self, ...) end
		local m = getnamecallmethod()
		if m ~= "Raycast" and m ~= "FireServer" and m ~= "InvokeServer" then return old(self, ...) end

		local args = {...}

		local ok, newArgs = pcall(function()
			if CFG.ShAim and shTgt and shTgt.Parent then
				local head = shTgt:FindFirstChild("Head") or shTgt:FindFirstChild("HumanoidRootPart")
				if head then
					local cp = getCamPos()
					local aim = (head.Position - cp).Unit * 1000
					if m == "Raycast" and self == workspace then
						if #args >= 2 and typeof(args[1]) == "Vector3" and typeof(args[2]) == "Vector3" then
							args[1] = cp
							args[2] = aim
							return args
						end
					elseif m == "FireServer" and isAtkRemote(self.Name) then
						local n = #args
						if n >= 2 and typeof(args[n - 1]) == "Vector3" and typeof(args[n]) == "Vector3" then
							args[n - 1] = cp
							args[n] = aim
							return args
						end
					end
				end
			end
			if CFG.KnOn and (m == "FireServer" or m == "InvokeServer") then
				local nm = string.lower(self.Name or "")
				if string.find(nm, "throw") or string.find(nm, "knife") or string.find(nm, "blade") then
					local range = math.clamp(tonumber(CFG.KnR) or 20, 10, 60)
					local c, h, r = myChar()
					if r then
						local cp = getCamPos()
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
							for i = #args, 1, -1 do
								if typeof(args[i]) == "Vector3" then
									local mag = args[i].Magnitude
									if mag > 0.01 then
										args[i] = (best.Position - cp).Unit * mag
										return args
									end
									break
								end
							end
						end
					end
				end
			end
			return nil
		end)

		if ok and newArgs then
			return old(self, table.unpack(newArgs))
		end
		return old(self, table.unpack(args))
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
local iconPos=Vector2.new(12,12)
minBtn.MouseButton1Click:Connect(function()
	pn.Visible=false
	if gui:FindFirstChild("iconHolder") then return end
	local holder=B("Frame",{Name="iconHolder",Size=UDim2.fromOffset(64,64),Position=UDim2.fromOffset(iconPos.X,iconPos.Y),BackgroundTransparency=1,ZIndex=900,Parent=gui})
	local hit=B("TextButton",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="",AutoButtonColor=false,Active=true,Selectable=true,ZIndex=901,Parent=holder})
	local ib=B("TextButton",{Size=UDim2.fromOffset(36,36),Position=UDim2.fromScale(0.5,0.5),AnchorPoint=Vector2.new(0.5,0.5),BackgroundColor3=Color3.fromRGB(255,255,255),BackgroundTransparency=1,Text="wx",Font=Enum.Font.GothamBold,TextSize=12,TextColor3=Color3.fromRGB(60,60,60),AutoButtonColor=false,Active=false,ZIndex=902,Parent=holder})
	B("UICorner",{CornerRadius=UDim.new(1,0),Parent=ib})
	local isk=B("UIStroke",{Color=Color3.fromRGB(255,255,255),Transparency=1,Thickness=1.5,Parent=ib})
	B("UIGradient",{Rotation=125,Color=ColorSequence.new(Color3.fromRGB(255,255,255),Color3.fromRGB(190,205,225)),Parent=ib})
	local sc=Instance.new("UIScale") sc.Scale=0.4 sc.Parent=holder
	TS:Create(sc,TweenInfo.new(0.24,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Scale=1}):Play()
	TS:Create(ib,TweenInfo.new(0.24),{BackgroundTransparency=0.45}):Play()
	TS:Create(isk,TweenInfo.new(0.24),{Transparency=0.25}):Play()
	local drag=false
	local moved=0
	hit.InputBegan:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then
			drag=true moved=0
		end
	end)
	hit.InputChanged:Connect(function(i)
		if drag and (i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseMovement) then
			moved=moved+math.abs(i.Delta.X)+math.abs(i.Delta.Y)
			local p=holder.Position
			holder.Position=UDim2.fromOffset(p.X.Offset+i.Delta.X,p.Y.Offset+i.Delta.Y)
			iconPos=Vector2.new(holder.Position.X.Offset,holder.Position.Y.Offset)
		end
	end)
	hit.InputEnded:Connect(function()
		if not drag then return end
		drag=false
		if moved>=8 then return end
		local s2=holder:FindFirstChildOfClass("UIScale")
		if s2 then TS:Create(s2,TweenInfo.new(0.14,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Scale=0.3}):Play() end
		TS:Create(ib,TweenInfo.new(0.14),{BackgroundTransparency=1}):Play()
		TS:Create(isk,TweenInfo.new(0.14),{Transparency=1}):Play()
		task.delay(0.14,function() pcall(function() holder:Destroy() end) end)
		pn.Visible=true
		pn.Size=UDim2.fromOffset(math.floor(PW*0.92),math.floor(PH*0.92))
		pn.Position=UDim2.fromOffset(x0+math.floor(PW*0.04),y0+math.floor(PH*0.04))
		pn.BackgroundTransparency=1
		TS:Create(pn,TweenInfo.new(0.24,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Size=UDim2.fromOffset(PW,PH),Position=UDim2.fromOffset(x0,y0),BackgroundTransparency=0.03}):Play()
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
	if h and not h.Parent then h=nil HL[obj]=nil end
	if on then
		if not h then
			h=Instance.new("Highlight")
			h.Name="mm2hl"
			h.FillTransparency=1
			h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
			h.Parent=obj
			HL[obj]=h
		end
		h.OutlineColor=col
		h.Enabled=true
	elseif h then
		h:Destroy()
		HL[obj]=nil
	end
end
local timeGui=B("ScreenGui",{IgnoreGuiInset=true,ResetOnSpawn=false,DisplayOrder=65,Parent=SP()})
local timeLbl=B("TextLabel",{Size=UDim2.fromOffset(200,26),Position=UDim2.new(0.5,-100,0,34),BackgroundTransparency=1,Text="",Font=Enum.Font.GothamBlack,TextSize=18,TextColor3=Color3.fromRGB(255,232,150),TextStrokeTransparency=0.3,Visible=false,Parent=timeGui})
local roundEnd=0
local lastGun=false
local rStart=0 local wasW=false local gpT=0 local lastLookup=0 local coinCache={} local lastScan=0 local lastTp=0
local function wxCoin(o)
	if not o:IsA("BasePart") then return false end
	local nm=string.lower(o.Name)
	local pnm=string.lower((o.Parent and o.Parent.Name) or "")
	return (string.find(nm,"coin") or string.find(nm,"cash") or string.find(nm,"money") or string.find(nm,"gold") or string.find(pnm,"coin"))~=nil
end
for _,o in ipairs(workspace:GetDescendants()) do if wxCoin(o) then table.insert(coinCache,o) end end
workspace.DescendantAdded:Connect(function(o) if wxCoin(o) then table.insert(coinCache,o) end end)
local timerLabel=nil
local function findTimerLabel()
	local pg=LP:FindFirstChild("PlayerGui")
	if not pg then return nil end
	local best=nil
	for _,d in ipairs(pg:GetDescendants()) do
		if d:IsA("TextLabel") and d.Visible and d.Text~="" and string.match(d.Text,"^%s*%d+:%d%d%s*$") then
			local nm=string.lower(d.Name)
			local isChat=false
			local par=d
			for i=1,5 do
				par=par.Parent
				if not par or par:IsA("ScreenGui") then break end
				if string.find(string.lower(par.Name),"chat") then isChat=true break end
			end
			if not isChat then
				if string.find(nm,"time") or string.find(nm,"timer") or string.find(nm,"round") or string.find(nm,"clock") or string.find(nm,"count") then
					return d
				end
				local p=d.AbsolutePosition
				if p.Y<160 then
					if not best or p.Y<best.AbsolutePosition.Y then best=d end
				end
			end
		end
	end
	return best
end
local roundT=os.clock()
LP.CharacterAdded:Connect(function() roundT=os.clock() end)
local LN={}
local function drawLine(idx,from,to,col,on)
	local f=LN[idx]
	if not f then
		f=B("Frame",{AnchorPoint=Vector2.new(0.5,0.5),BackgroundColor3=col,BorderSizePixel=0,ZIndex=90,Parent=gui})
		LN[idx]=f
	end
	if not on then f.Visible=false return end
	local dx,dy=to.X-from.X,to.Y-from.Y
	f.Size=UDim2.new(0,math.sqrt(dx*dx+dy*dy),0,1.2)
	f.Position=UDim2.new(0,(from.X+to.X)/2,0,(from.Y+to.Y)/2)
	f.Rotation=math.deg(math.atan2(dy,dx))
	f.BackgroundColor3=col
	f.Visible=true
end
task.spawn(function()
	while task.wait(0.016) do
		pcall(function()
			local sawRole=false
			local cam=workspace.CurrentCamera
			local vps=cam.ViewportSize
			local fromP=(posV=="顶部") and Vector2.new(vps.X/2,0) or Vector2.new(vps.X/2,vps.Y)
			local anyW=false
			for _,p2 in ipairs(P:GetPlayers()) do
				local c2=p2.Character
				if c2 and (c2:FindFirstChild("Knife") or c2:FindFirstChild("Gun") or (p2.Backpack and (p2.Backpack:FindFirstChild("Knife") or p2.Backpack:FindFirstChild("Gun")))) then
					anyW=true break
				end
			end
			local killerP,policeP={},{}
			for _,pl in ipairs(P:GetPlayers()) do
				local c=pl.Character
				if c then
					if c:FindFirstChild("Knife") or (pl.Backpack and pl.Backpack:FindFirstChild("Knife")) then
						killerP[pl]=true
					elseif c:FindFirstChild("Gun") or (pl.Backpack and pl.Backpack:FindFirstChild("Gun")) then
						policeP[pl]=true
					end
				end
			end
			local li=0
			local myHR=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
			local myPos=myHR and myHR.Position
			for _,pl in ipairs(P:GetPlayers()) do
				local c=pl.Character
				if c and c:FindFirstChildOfClass("Humanoid") then
					local col=nil
					if not anyW then
						col=CLR.Civ
						hl(c,CLR.Civ,ES.Civ)
					elseif killerP[pl] then
						col=CLR.Killer
						hl(c,CLR.Killer,ES.Killer)
					elseif policeP[pl] then
						col=CLR.Police
						hl(c,CLR.Police,ES.Police)
					else
						col=CLR.Civ
						hl(c,CLR.Civ,ES.Civ)
					end
					local hr=c:FindFirstChild("HumanoidRootPart")
					local far=(hr and myPos) and ((hr.Position-myPos).Magnitude>1500) or false
					if pl~=LP and col then
						if far then
							hl(c,col,false)
						else
							li=li+1
							if hr and ES.Line then
								local sp,onv=cam:WorldToViewportPoint(hr.Position)
								drawLine(li,fromP,Vector2.new(sp.X,sp.Y),col,onv)
							else
								drawLine(li,fromP,fromP,col,false)
							end
						end
					end
				end
			end
			for i=li+1,#LN do if LN[i] then LN[i].Visible=false end end
			local gunOn=false
			local myHRg=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
			local gList={}
			for _,pl in ipairs(P:GetPlayers()) do
				local ch=pl.Character
				if ch then for _,c in ipairs(ch:GetChildren()) do gList[#gList+1]=c end end
				if pl.Backpack then for _,c in ipairs(pl.Backpack:GetChildren()) do gList[#gList+1]=c end end
			end
			for _,o in ipairs(workspace:GetChildren()) do
				gList[#gList+1]=o
				for _,c in ipairs(o:GetChildren()) do gList[#gList+1]=c end
			end
			for _,o in ipairs(gList) do
				local nm=string.lower(o.Name)
				if (o:IsA("Tool") or o:IsA("Model") or o:IsA("BasePart")) and string.find(nm,"gun") then
					local hd=o:FindFirstChild("Handle")
					if not hd and o:IsA("BasePart") then hd=o end
					local vis=false
					if hd then
						vis=(hd.Transparency<0.95 and hd.LocalTransparencyModifier<0.95)
					end
					if vis then
						gunOn=true
						hl(o,CLR.Gun,ES.Gun)
						if ES.Gun and hd then
							local bg=hd:FindFirstChild("mm2_gdist")
							if not bg then
								bg=B("BillboardGui",{Name="mm2_gdist",Size=UDim2.fromOffset(70,18),StudsOffset=Vector3.new(0,1.8,0),AlwaysOnTop=true,Parent=hd})
								B("TextLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="",Font=Enum.Font.GothamBold,TextSize=11,TextColor3=CLR.Gun,Parent=bg})
							end
							bg.Enabled=true
							local tl=bg:FindFirstChildOfClass("TextLabel")
							if tl and myHRg then
								tl.Text=math.floor((hd.Position-myHRg.Position).Magnitude).."m"
							end
						end
					end
				elseif string.find(nm,"trap") or string.find(nm,"beartrap") then
					if ES.Trap then
						for _,d in ipairs(o:GetDescendants()) do
							if d:IsA("BasePart") then d.Transparency=0 d.CanCollide=false end
						end
						if o:IsA("BasePart") then o.Transparency=0 end
					end
					hl(o,CLR.Trap,ES.Trap)
				end
			end
			if ES.Gun and gunOn and not lastGun then mmToast("枪械已掉落") end
			if ES.Gun and not gunOn and lastGun then mmToast("枪械已被拾取") end
			lastGun=gunOn
			if anyW and not wasW then rStart=os.clock() end
			if not anyW then rStart=0 end
			wasW=anyW
			if os.clock()-lastLookup>1 then
				lastLookup=os.clock()
				if not timerLabel or not timerLabel.Parent then timerLabel=findTimerLabel() end
			end
			local txt=nil
			if timerLabel and timerLabel.Parent then
				txt=string.match(timerLabel.Text,"(%d+:%d%d)")
			end
			if not txt then
				if anyW and rStart>0 then
					local left=math.max(0,math.ceil(180-(os.clock()-rStart)))
					txt=string.format("%d:%02d",math.floor(left/60),left%60)
				else
					txt="0:00"
				end
			end
			if ES.Time then
				timeLbl.Text=txt
				timeLbl.Visible=true
			else
				timeLbl.Text=""
				timeLbl.Visible=false
			end
		end)
	end
end)
--==== 自动 栏目 ====
local AU={Coin=false,GunPick=false,NoFling=false}
autoBtn=B("TextButton",{Size=UDim2.new(1,0,0,26),BackgroundColor3=C.row,BorderSizePixel=0,Text="自动",Font=Enum.Font.GothamMedium,TextSize=10,TextColor3=C.txt,AutoButtonColor=false,LayoutOrder=4,ZIndex=301,Parent=side})
bodyAuto=B("Frame",{Size=UDim2.new(1,-84,1,-44),Position=UDim2.fromOffset(80,38),BackgroundTransparency=1,Visible=false,ZIndex=108,Parent=pn})
autoBtn.MouseButton1Click:Connect(function()
	showPage(bodyAuto, autoBtn)
end)
local ay=0
local function mkToggle2(name,key,cb)
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
		if cb then pcall(cb, AU[key]) end
	end)
end
-- ---------- 防甩飞 ----------
local nfMode="持续关闭"
local NF={cols={},parts={},loopC=nil,watchC=nil}
local function nfRefresh()
	NF.parts={}
	local c=LP.Character
	if c then
		for _,d in ipairs(c:GetDescendants()) do
			if d:IsA("BasePart") then NF.parts[#NF.parts+1]=d end
		end
	end
end
local function nfRestore()
	if NF.loopC then pcall(task.cancel,NF.loopC) NF.loopC=nil end
	if NF.watchC then NF.watchC:Disconnect() NF.watchC=nil end
	for p,o in pairs(NF.cols) do
		if p and p.Parent then pcall(function() p.CanCollide=o end) end
	end
	NF.cols={}
	NF.parts={}
end
local function nfApply()
	local ch=LP.Character
	if not ch then return end
	if nfMode=="持续关闭" then
		nfRefresh()
		NF.loopC=task.spawn(function()
			while AU.NoFling and nfMode=="持续关闭" do
				for i=1,#NF.parts do
					local d=NF.parts[i]
					if d and d.Parent and d.CanCollide then
						if NF.cols[d]==nil then NF.cols[d]=true end
						d.CanCollide=false
					end
				end
				task.wait(0.05)
			end
		end)
	else
		local function kill(d)
			if d:IsA("BasePart") then
				if NF.cols[d]==nil then NF.cols[d]=d.CanCollide end
				d.CanCollide=false
			end
		end
		for _,d in ipairs(ch:GetDescendants()) do kill(d) end
		NF.watchC=ch.DescendantAdded:Connect(function(d)
			task.wait(0.05)
			if AU.NoFling and nfMode=="完全关闭" then kill(d) end
		end)
	end
end
local function nfSet(on)
	nfRestore()
	if on then nfApply() end
end
mkToggle2("自动拾取金币","Coin")
mkToggle2("自动传送捡枪","GunPick")
mkToggle2("防甩飞","NoFling", nfSet)
local nfRow=B("TextButton",{Size=UDim2.new(1,0,0,28),Position=UDim2.fromOffset(0,ay),BackgroundColor3=C.row,BorderSizePixel=0,Text="",AutoButtonColor=false,ZIndex=130,Parent=bodyAuto})
ay=ay+32
B("UIStroke",{Color=Color3.fromRGB(150,140,128),Transparency=0.4,Parent=nfRow})
B("TextLabel",{Size=UDim2.new(1,-110,1,0),Position=UDim2.fromOffset(10,0),BackgroundTransparency=1,Text="防甩飞模式",Font=Enum.Font.GothamMedium,TextSize=11,TextColor3=C.txt,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=131,Parent=nfRow})
local nfVal=B("TextLabel",{Size=UDim2.new(0,96,1,0),Position=UDim2.new(1,-106,0,0),BackgroundTransparency=1,Text=nfMode,Font=Enum.Font.GothamMedium,TextSize=11,TextColor3=C.accent,TextXAlignment=Enum.TextXAlignment.Right,ZIndex=131,Parent=nfRow})
nfRow.MouseButton1Click:Connect(function()
	nfMode=(nfMode=="持续关闭") and "完全关闭" or "持续关闭"
	nfVal.Text=nfMode
	if AU.NoFling then nfSet(true) end
end)
LP.CharacterAdded:Connect(function()
	task.wait(0.3)
	if AU.NoFling then nfSet(true) end
end)
task.spawn(function()
	while true do
		task.wait(0.2)
		local ch=LP.Character
		local hr=ch and ch:FindFirstChild("HumanoidRootPart")
		if hr then
			if AU.Coin then
				pcall(function()
					local now=os.clock()
					for i=#coinCache,1,-1 do
						local c=coinCache[i]
						if not c or not c.Parent then table.remove(coinCache,i) end
					end
					if now-lastTp>=0.5 and #coinCache>0 then
						local best,bd=nil,300
						for _,o in ipairs(coinCache) do
							if o.Parent then
								local d=(o.Position-hr.Position).Magnitude
								if d<bd then bd=d best=o end
							end
						end
						if best then
							lastTp=now
							hr.CFrame=CFrame.new(best.Position+Vector3.new(0,1.5,0))
						end
					end
				end)
			end
			if AU.GunPick then
				pcall(function()
					local function sub(s) return string.find(string.lower(tostring(s)),"gun")~=nil end
					local function isHeldVis()
						local ch=LP.Character
						if ch then
							for _,o in ipairs(ch:GetChildren()) do
								if o:IsA("Tool") and sub(o.Name) then
									local h=o:FindFirstChild("Handle")
									if h and h.Transparency<0.95 and h.LocalTransparencyModifier<0.95 then return true end
								end
							end
						end
						return false
					end

					GWI=GWI or setmetatable({},{__mode="k"})
					GWBAD=GWBAD or setmetatable({},{__mode="k"})
					if not GWSnap then
						GWSnap=true
						for _,o in ipairs(workspace:GetDescendants()) do
							if (o:IsA("Tool") or o:IsA("Model")) and sub(o.Name) then GWI[o]=true end
						end
					end

					if os.clock()-gpT<1.2 then return end
					GPScan=GPScan or 0
					local now2=os.clock()
					if now2-GPScan<0.25 then return end
					GPScan=now2

					local found=nil
					local function look(par)
						for _,o in ipairs(par:GetChildren()) do
							if (o:IsA("Tool") or o:IsA("Model")) and sub(o.Name) and not GWI[o] and not GWBAD[o] then
								local par2=o.Parent
								local onP=false
								if par2 then
									for _,pl in ipairs(P:GetPlayers()) do
										local pc2=pl.Character
										if pc2 and (par2==pc2 or par2:IsDescendantOf(pc2)) then onP=true break end
										local bp=pl.Backpack
										if bp and (par2==bp or par2:IsDescendantOf(bp)) then onP=true break end
									end
								end
								if not onP then
									local hb=o:IsA("BasePart") and o or o.PrimaryPart or o:FindFirstChild("Handle") or o:FindFirstChildWhichIsA("BasePart")
									if hb and (not hb.Anchored) and hb.Transparency<0.95 and hb.LocalTransparencyModifier<0.95 then
										found={o=o,p=hb}
										return true
									end
								end
							end
							if (o:IsA("Folder") or o:IsA("Model")) and look(o) then return true end
						end
					end
					look(workspace)
					if not found then return end

					gpT=os.clock()
					local origin=hr.CFrame
					local go=found.o
					hr.CFrame=CFrame.new(found.p.Position+Vector3.new(0,1.5,0))

					task.spawn(function()
						for _,d in ipairs(go:GetDescendants()) do
							if d:IsA("ProximityPrompt") then
								pcall(function() d.InputHoldBegin() task.wait(0.05) d.InputHoldEnd() end)
							end
						end
						task.wait(0.45)
						if not isHeldVis() then GWBAD[go]=true end
						local c2=LP.Character
						local r2=c2 and (c2:FindFirstChild("HumanoidRootPart") or c2:FindFirstChild("Torso"))
						if r2 then pcall(function() r2.CFrame=origin end) end
					end)
				end)
			end
		end
	end
end)
