--== Blind people and vision ==
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
local RS=game:GetService("RunService")
local UIS=game:GetService("UserInputService")
local LP=P.LocalPlayer
local function B(c,p) local o=Instance.new(c) for k,v in pairs(p) do if k~="Parent" then o[k]=v end end if p.Parent then o.Parent=p.Parent end return o end
local function SP()
	local ok,h=pcall(function() return gethui() end)
	if ok and typeof(h)=="Instance" then return h end
	local ok2,c=pcall(function() return game:GetService("CoreGui") end)
	if ok2 and typeof(c)=="Instance" then return c end
	return LP.PlayerGui
end

if game.PlaceId~=112270456220062 then
	local sg=B("ScreenGui",{IgnoreGuiInset=true,ResetOnSpawn=false,DisplayOrder=9000,Parent=SP()})
	B("TextLabel",{Size=UDim2.fromScale(1,0.12),Position=UDim2.fromScale(0,0.44),BackgroundColor3=Color3.fromRGB(20,20,24),TextColor3=Color3.fromRGB(255,140,140),Font=Enum.Font.GothamBold,TextSize=16,Text="此脚本不支持当前游戏 · "..tostring(game.PlaceId),Parent=sg})
	task.delay(6,function() pcall(function() sg:Destroy() end) end)
	return
end

local C={bg=Color3.fromRGB(238,233,223),row=Color3.fromRGB(243,237,227),off=Color3.fromRGB(212,204,191),accent=Color3.fromRGB(190,74,64),txt=Color3.fromRGB(38,38,38),dim=Color3.fromRGB(108,103,95)}
local F={TrPos="顶部"}
local gui=B("ScreenGui",{Name="blind_ui",IgnoreGuiInset=true,ResetOnSpawn=false,DisplayOrder=60})
gui.Parent=SP()
local vp=workspace.CurrentCamera.ViewportSize
local PW,PH=340,250
local pn=B("Frame",{Size=UDim2.fromOffset(PW,PH),Position=UDim2.fromOffset(math.floor((vp.X-PW)/2),math.floor((vp.Y-PH)/2)),BackgroundColor3=C.bg,BackgroundTransparency=0.03,BorderSizePixel=0,ZIndex=100,Parent=gui})
B("UIStroke",{Color=Color3.fromRGB(120,110,98),Transparency=0.5,Parent=pn})
local bar=B("Frame",{Size=UDim2.new(1,0,0,32),BackgroundTransparency=1,ZIndex=120,Parent=pn})
B("TextLabel",{Size=UDim2.new(1,-80,1,0),Position=UDim2.fromOffset(14,0),BackgroundTransparency=1,Text="Blind people and vision",Font=Enum.Font.GothamBold,TextSize=13,TextColor3=C.accent,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=122,Parent=bar})
local minBtn=B("TextButton",{Size=UDim2.fromOffset(34,32),Position=UDim2.new(1,-68,0.5,0),AnchorPoint=Vector2.new(0,0.5),BackgroundTransparency=1,Text="－",Font=Enum.Font.GothamBold,TextSize=16,TextColor3=C.dim,ZIndex=125,Parent=bar})
local close=B("TextButton",{Size=UDim2.fromOffset(34,32),Position=UDim2.new(1,-34,0.5,0),AnchorPoint=Vector2.new(0,0.5),BackgroundTransparency=1,Text="×",Font=Enum.Font.GothamBold,TextSize=18,TextColor3=C.dim,ZIndex=125,Parent=bar})
B("Frame",{Size=UDim2.new(1,0,0,1),Position=UDim2.fromOffset(0,32),BackgroundColor3=C.off,BackgroundTransparency=0.1,BorderSizePixel=0,ZIndex=118,Parent=pn})
local side=B("Frame",{Size=UDim2.new(0,74,1,-33),Position=UDim2.fromOffset(0,33),BackgroundColor3=Color3.fromRGB(230,222,210),BorderSizePixel=0,ZIndex=300,Parent=pn})
local slay=Instance.new("UIListLayout") slay.Padding=UDim.new(0,4) slay.SortOrder=Enum.SortOrder.LayoutOrder slay.Parent=side
local spad=Instance.new("UIPadding") spad.PaddingLeft=UDim.new(0,6) spad.PaddingRight=UDim.new(0,6) spad.PaddingTop=UDim.new(0,6) spad.Parent=side
local function mkPageBtn(txt,order)
	return B("TextButton",{Size=UDim2.new(1,0,0,26),BackgroundColor3=C.row,BorderSizePixel=0,Text=txt,Font=Enum.Font.GothamMedium,TextSize=10,TextColor3=C.txt,AutoButtonColor=false,LayoutOrder=order,ZIndex=301,Parent=side})
end
local espBtn=mkPageBtn("ESP",1)
local baseBtn=mkPageBtn("基础功能",2)
local function mkPage()
	return B("ScrollingFrame",{Size=UDim2.new(1,-84,1,-44),Position=UDim2.fromOffset(80,38),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=2,ScrollBarImageColor3=C.off,CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,ScrollingDirection=Enum.ScrollingDirection.Y,ZIndex=108,Visible=false,Parent=pn})
end
local bodyE=mkPage()
local bodyB=mkPage()
local cur=bodyE
local function showPage(p,btn)
	bodyE.Visible=(p==bodyE) bodyB.Visible=(p==bodyB) cur=p
	for _,x in ipairs({espBtn,baseBtn}) do
		x.BackgroundColor3=(x==btn) and C.accent or C.row
		x.TextColor3=(x==btn) and Color3.new(1,1,1) or C.txt
	end
end
espBtn.MouseButton1Click:Connect(function() showPage(bodyE,espBtn) end)
baseBtn.MouseButton1Click:Connect(function() showPage(bodyB,baseBtn) end)
showPage(bodyE,espBtn)

local function title(par,txt,yRef)
	B("TextLabel",{Size=UDim2.new(1,0,0,14),Position=UDim2.fromOffset(10,yRef.v),BackgroundTransparency=1,Text=txt,Font=Enum.Font.GothamMedium,TextSize=9,TextColor3=C.dim,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=131,Parent=par})
	yRef.v=yRef.v+18
end
local function rowToggle(par,yRef,label,key,cb)
	local row=B("TextButton",{Size=UDim2.new(1,0,0,30),Position=UDim2.fromOffset(0,yRef.v),BackgroundColor3=C.row,BorderSizePixel=0,Text="",AutoButtonColor=false,ZIndex=130,Parent=par})
	yRef.v=yRef.v+34
	B("UIStroke",{Color=Color3.fromRGB(150,140,128),Transparency=0.4,Parent=row})
	B("TextLabel",{Size=UDim2.new(1,-56,1,0),Position=UDim2.fromOffset(10,0),BackgroundTransparency=1,Text=label,Font=Enum.Font.GothamMedium,TextSize=10,TextColor3=C.txt,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=131,Parent=row})
	local sw=B("Frame",{Size=UDim2.fromOffset(32,18),Position=UDim2.new(1,-42,0.5,-9),BackgroundColor3=F[key] and C.accent or C.off,BorderSizePixel=0,ZIndex=131,Parent=row})
	B("UIStroke",{Color=Color3.fromRGB(95,88,80),Transparency=0.3,Parent=sw})
	local kn=B("Frame",{Size=UDim2.fromOffset(14,14),Position=UDim2.fromOffset(F[key] and 16 or 2,2),BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,ZIndex=132,Parent=sw})
	row.MouseButton1Click:Connect(function()
		F[key]=not F[key]
		sw.BackgroundColor3=F[key] and C.accent or C.off
		TS:Create(kn,TweenInfo.new(0.18,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Position=UDim2.fromOffset(F[key] and 16 or 2,2)}):Play()
		if cb then pcall(cb,F[key]) end
	end)
end

local yE={v=4} local yB={v=4}
title(bodyE,"基础 ESP",yE)
rowToggle(bodyE,yE,"名称（失明者看不到）","eNm")
rowToggle(bodyE,yE,"射线（通用）","eTr")
local pRow=B("TextButton",{Size=UDim2.new(1,0,0,30),Position=UDim2.fromOffset(0,yE.v),BackgroundColor3=C.row,BorderSizePixel=0,Text="",AutoButtonColor=false,ZIndex=130,Parent=bodyE})
yE.v=yE.v+34
B("UIStroke",{Color=Color3.fromRGB(150,140,128),Transparency=0.4,Parent=pRow})
B("TextLabel",{Size=UDim2.new(1,-56,1,0),Position=UDim2.fromOffset(10,0),BackgroundTransparency=1,Text="射线位置",Font=Enum.Font.GothamMedium,TextSize=10,TextColor3=C.txt,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=131,Parent=pRow})
local pVal=B("TextLabel",{Size=UDim2.new(0,52,1,0),Position=UDim2.new(1,-58,0,0),BackgroundTransparency=1,Text=F.TrPos,Font=Enum.Font.GothamMedium,TextSize=10,TextColor3=C.accent,TextXAlignment=Enum.TextXAlignment.Right,ZIndex=131,Parent=pRow})
rowToggle(bodyE,yE,"方框（通用）","eBx")
rowToggle(bodyE,yE,"距离（失明者看不到）","eDs")
rowToggle(bodyE,yE,"高亮（失明者看不到）","eHl")
title(bodyE,"其他 ESP",yE)
rowToggle(bodyE,yE,"香蕉 ESP","eBan")
rowToggle(bodyE,yE,"陷阱 ESP","eTrp")
title(bodyB,"基础功能",yB)
rowToggle(bodyB,yB,"防滑","antiSlip")
rowToggle(bodyB,yB,"防布娃娃","noRag")

local pickGui=B("ScreenGui",{Name="blind_pick",IgnoreGuiInset=true,ResetOnSpawn=false,DisplayOrder=9000,Enabled=false,Parent=SP()})
gui.Destroying:Connect(function() pcall(function() pickGui:Destroy() end) end)
local shade=B("TextButton",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="",AutoButtonColor=false,ZIndex=1,Parent=pickGui})
local box=B("Frame",{Size=UDim2.fromOffset(130,216),Position=UDim2.fromScale(0.5,0.5),AnchorPoint=Vector2.new(0.5,0.5),BackgroundColor3=C.bg,BackgroundTransparency=1,BorderSizePixel=0,ZIndex=2,Parent=pickGui})
B("UIStroke",{Color=Color3.fromRGB(150,140,128),Transparency=0.35,Parent=box})
local opts={}
local function closePick()
	TS:Create(box,TweenInfo.new(0.15,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{BackgroundTransparency=1}):Play()
	for _,b in ipairs(opts) do TS:Create(b,TweenInfo.new(0.13),{BackgroundTransparency=1,TextTransparency=1}):Play() end
	task.delay(0.16,function() pickGui.Enabled=false end)
end
local function mkOpt(nm,val,order)
	local b=B("TextButton",{Size=UDim2.new(1,-16,0,44),Position=UDim2.fromOffset(8,order*50+8),BackgroundColor3=C.row,BorderSizePixel=0,Text=nm,Font=Enum.Font.GothamMedium,TextSize=12,TextColor3=(F.TrPos==val) and C.accent or C.txt,AutoButtonColor=false,BackgroundTransparency=1,TextTransparency=1,ZIndex=3,Parent=box})
	B("UIStroke",{Color=Color3.fromRGB(150,140,128),Transparency=0.4,Parent=b})
	table.insert(opts,b)
	b.MouseButton1Click:Connect(function()
		F.TrPos=val pVal.Text=val
		for _,o in ipairs(opts) do o.TextColor3=(o==b) and C.accent or C.txt end
		closePick()
	end)
end
mkOpt("顶部","顶部",0) mkOpt("底部","底部",1) mkOpt("头部","头部",2) mkOpt("跟随","跟随",3)
shade.MouseButton1Click:Connect(closePick)
pRow.MouseButton1Click:Connect(function()
	pickGui.Enabled=true
	box.BackgroundTransparency=1
	for _,b in ipairs(opts) do b.BackgroundTransparency=1 b.TextTransparency=1 end
	TS:Create(box,TweenInfo.new(0.24,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{BackgroundTransparency=0.03}):Play()
	task.delay(0.04,function()
		for _,b in ipairs(opts) do TS:Create(b,TweenInfo.new(0.2),{BackgroundTransparency=0,TextTransparency=0}):Play() end
	end)
end)

local ESPG=B("ScreenGui",{Name="blind_esp_"..tostring(math.random(100000,999999)),ResetOnSpawn=false,IgnoreGuiInset=true,DisplayOrder=998,Parent=SP()})
local ES={} local cam=nil
local function newText()
	return B("TextLabel",{BackgroundTransparency=1,Font=Enum.Font.GothamBold,TextSize=12,TextStrokeTransparency=0.45,TextColor3=Color3.new(1,1,1),Size=UDim2.fromOffset(180,14),AnchorPoint=Vector2.new(0.5,0),Visible=false,Parent=ESPG})
end
local function anchorOf(o)
	if o:IsA("BasePart") then return o end
	return o:FindFirstChild("Handle") or o.PrimaryPart or o:FindFirstChild("Head")
end
local function getES(inst)
	local d=ES[inst]
	if d then return d end
	d={}
	d.n=newText() d.d=newText()
	d.b=B("Frame",{BackgroundTransparency=1,BorderSizePixel=0,Visible=false,AnchorPoint=Vector2.new(0.5,0),Parent=ESPG})
	d.bs=B("UIStroke",{Thickness=1.2,Parent=d.b})
	d.t=B("Frame",{BorderSizePixel=0,Visible=false,AnchorPoint=Vector2.new(0.5,0.5),Parent=ESPG})
	ES[inst]=d
	return d
end
local function dropES(inst)
	local d=ES[inst]
	if not d then return end
	for _,o in pairs(d) do pcall(function() o:Destroy() end) end
	ES[inst]=nil
end
local function hideES(d)
	if not d then return end
	d.n.Visible=false d.d.Visible=false d.b.Visible=false d.t.Visible=false
	if d.hl then pcall(function() d.hl:Destroy() end) d.hl=nil end
end
local function setHL(inst,d,col)
	if d.hl and not d.hl.Parent then d.hl=nil end
	if not d.hl then
		local ad=anchorOf(inst) or inst
		d.hl=B("Highlight",{Name="blindhl",FillTransparency=0.72,OutlineTransparency=0,DepthMode=Enum.HighlightDepthMode.AlwaysOnTop,Adornee=ad,Parent=ad})
	end
	d.hl.Enabled=true d.hl.FillColor=col d.hl.OutlineColor=col
end
local function draw(inst,hp,rp,d,col,label)
	local a=cam:WorldToViewportPoint(hp)
	local b=cam:WorldToViewportPoint(rp)
	local cx=(a.X+b.X)/2 local on=(a.Z>0)
	d.n.Visible=false d.d.Visible=false
	if F.eNm and on then
		d.n.Text=label d.n.TextColor3=col
		d.n.Position=UDim2.fromOffset(cx,a.Y-30) d.n.Visible=true
	end
	if F.eDs and on then
		d.d.Text=math.floor((cam.CFrame.Position-rp).Magnitude).."m" d.d.TextColor3=col
		d.d.Position=UDim2.fromOffset(cx,(F.eNm and a.Y-16) or (a.Y-30)) d.d.Visible=true
	end
	if F.eBx and on and b.Z>0 then
		local h=math.max(math.abs(b.Y-a.Y),10) local w=math.max(h*0.62,6)
		d.b.Size=UDim2.fromOffset(w,h) d.b.Position=UDim2.fromOffset(cx,math.min(a.Y,b.Y))
		d.bs.Color=col d.b.Visible=true
	else d.b.Visible=false end
	if F.eTr and on then
		local vv=cam.ViewportSize local ax,ay=vv.X/2,vv.Y
		if F.TrPos=="顶部" then ax,ay=vv.X/2,0
		elseif F.TrPos=="底部" then ax,ay=vv.X/2,vv.Y
		elseif F.TrPos=="头部" then
			local hd=LP.Character and LP.Character:FindFirstChild("Head")
			if hd then local s=cam:WorldToViewportPoint(hd.Position) ax,ay=s.X,s.Y end
		else ax,ay=F.TX or vv.X/2,F.TY or vv.Y end
		local tx,ty=cx,(a.Y+b.Y)/2 local dx,dy=tx-ax,ty-ay
		d.t.Size=UDim2.new(0,math.sqrt(dx*dx+dy*dy),0,1.2)
		d.t.Position=UDim2.new(0,(ax+tx)/2,0,(ay+ty)/2)
		d.t.Rotation=math.deg(math.atan2(dy,dx))
		d.t.BackgroundColor3=col d.t.Visible=true
	else d.t.Visible=false end
end

local BAN={} local TRA={}
local KB={"banana","banane","peel","skin"}
local KT={"trap","piege","piège","blindman","bear"}
local SKIP={"apercu","viewmodel"}
local function hasAny(n,t)
	for _,k in ipairs(t) do if string.find(n,k,1,true) then return true end end
	return false
end
local function reg(o)
	if not (o:IsA("BasePart") or o:IsA("Model") or o:IsA("Tool")) then return end
	local n=string.lower(o.Name)
	if hasAny(n,SKIP) then return end
	if hasAny(n,KB) then BAN[o]=true end
	if hasAny(n,KT) then TRA[o]=true end
end
workspace.DescendantAdded:Connect(reg)
for _,o in ipairs(workspace:GetDescendants()) do reg(o) end
local function posOf(o)
	local h=anchorOf(o)
	if not h then return nil end
	local r=o:FindFirstChild("HumanoidRootPart") or h
	if not r:IsA("BasePart") then r=h end
	return h.Position,r.Position
end
local function tickSet(set,on,col,label)
	for inst in pairs(set) do
		if not inst.Parent then
			set[inst]=nil dropES(inst)
		elseif inst:IsDescendantOf(workspace.CurrentCamera) then
			hideES(ES[inst])
		else
			local d=ES[inst]
			if not on then hideES(d) else
				local hp,rp=posOf(inst)
				if hp then
					d=getES(inst) draw(inst,hp,rp,d,col,label) setHL(inst,d,col)
				end
			end
		end
	end
end

RS.RenderStepped:Connect(function()
	if not gui.Parent then return end
	cam=workspace.CurrentCamera
	if not cam then return end
	for _,p in ipairs(P:GetPlayers()) do
		if p~=LP then
			local ch=p.Character
			local hd=ch and ch:FindFirstChild("Head")
			local rt=ch and (ch:FindFirstChild("HumanoidRootPart") or ch:FindFirstChild("Torso"))
			local hu=ch and ch:FindFirstChildOfClass("Humanoid")
			if hd and rt and hu and hu.Health>0 then
				local d=getES(p)
				draw(p,hd.Position,rt.Position,d,Color3.fromRGB(255,255,255),p.Name)
				if F.eHl then setHL(ch,d,Color3.fromRGB(255,255,255))
				elseif d.hl then pcall(function() d.hl:Destroy() end) d.hl=nil end
			else hideES(ES[p]) end
		end
	end
	tickSet(BAN,F.eBan,Color3.fromRGB(250,238,150),"banana")
	tickSet(TRA,F.eTrp,Color3.fromRGB(0,200,255),"trap")
	for inst in pairs(ES) do
		if inst:IsA("Player") and not inst.Parent then dropES(inst) end
	end
end)

UIS.InputBegan:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then
		F.TX,F.TY=i.Position.X,i.Position.Y
	end
end)

task.spawn(function()
	while gui.Parent do
		task.wait(0.03)
		local ch=LP.Character
		local hu=ch and ch:FindFirstChildOfClass("Humanoid")
		local hr=ch and ch:FindFirstChild("HumanoidRootPart")
		if F.antiSlip and hu and hr then
			local mv=hu.MoveDirection local v=hr.AssemblyLinearVelocity local sp=hu.WalkSpeed
			hr.AssemblyLinearVelocity=Vector3.new(mv.X*sp,v.Y,mv.Z*sp)
		end
	end
end)
F["_on_noRag"]=function(on)
	local hu=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
	if hu then
		pcall(function() hu:SetStateEnabled(Enum.HumanoidStateType.Physics,not on) end)
		pcall(function() hu:SetStateEnabled(Enum.HumanoidStateType.FallingDown,not on) end)
		pcall(function() hu:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,not on) end)
	end
end
RS.RenderStepped:Connect(function()
	if not F.noRag then return end
	local ch=LP.Character
	local hum=ch and ch:FindFirstChildOfClass("Humanoid")
	if not hum then return end
	if hum.PlatformStand then pcall(function() hum.PlatformStand=false end) end
	local st=hum:GetState()
	if st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.FallingDown then
		pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
	end
	for _,d in ipairs(ch:GetDescendants()) do
		if d:IsA("Attachment") and string.find(d.Name,"RagA",1,true) then pcall(function() d:Destroy() end) end
	end
end)

local icon=B("TextButton",{Size=UDim2.fromOffset(46,46),Position=pn.Position,BackgroundColor3=Color3.fromRGB(255,255,255),BackgroundTransparency=0.58,BorderSizePixel=0,ZIndex=100,Visible=false,Text="",AutoButtonColor=false,Parent=gui})
B("UICorner",{CornerRadius=UDim.new(0.5,0),Parent=icon})
B("UIStroke",{Color=Color3.fromRGB(255,255,255),Transparency=0.4,Thickness=1.4,Parent=icon})
B("TextLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="B",Font=Enum.Font.GothamBold,TextSize=17,TextColor3=C.accent,Parent=icon})
local idrag=false local i0=nil local iP=nil
icon.InputBegan:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then
		idrag=true i0=i.Position iP=icon.Position
	end
end)
UIS.InputChanged:Connect(function(i)
	if not idrag then return end
	if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseMovement then
		local d=i.Position-i0
		icon.Position=UDim2.new(iP.X.Scale,iP.X.Offset+d.X,iP.Y.Scale,iP.Y.Offset+d.Y)
	end
end)
UIS.InputEnded:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then idrag=false end
end)
local minOn=false
minBtn.MouseButton1Click:Connect(function()
	if minOn then return end
	minOn=true
	side.Visible=false bodyE.Visible=false bodyB.Visible=false bar.Visible=false
	TS:Create(pn,TweenInfo.new(0.22,Enum.EasingStyle.Back,Enum.EasingDirection.In),{Size=UDim2.fromOffset(4,4),BackgroundTransparency=1}):Play()
	task.delay(0.22,function()
		pn.Visible=false
		icon.Position=pn.Position icon.Size=UDim2.fromOffset(6,6) icon.Visible=true
		TS:Create(icon,TweenInfo.new(0.24,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Size=UDim2.fromOffset(46,46)}):Play()
	end)
end)
icon.MouseButton1Click:Connect(function()
	if not minOn then return end
	icon.Visible=false
	pn.Position=icon.Position
	pn.Visible=true pn.BackgroundTransparency=0.03 pn.Size=UDim2.fromOffset(4,4)
	bar.Visible=true side.Visible=true
	TS:Create(pn,TweenInfo.new(0.26,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Size=UDim2.fromOffset(PW,PH)}):Play()
	task.delay(0.08,function() if cur==bodyE then bodyE.Visible=true else bodyB.Visible=true end end)
	minOn=false
end)

local drag=false local d0=nil local dP=nil
bar.InputBegan:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then
		drag=true d0=i.Position dP=pn.Position
	end
end)
UIS.InputChanged:Connect(function(i)
	if not drag then return end
	if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseMovement then
		local d=i.Position-d0
		pn.Position=UDim2.new(dP.X.Scale,dP.X.Offset+d.X,dP.Y.Scale,dP.Y.Offset+d.Y)
	end
end)
UIS.InputEnded:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then drag=false end
end)
close.MouseButton1Click:Connect(function()
	for inst in pairs(ES) do dropES(inst) end
	pcall(function() ESPG:Destroy() end) pcall(function() pickGui:Destroy() end) gui:Destroy()
end)
