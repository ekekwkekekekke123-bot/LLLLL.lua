--== Blind people and vision ==
local P=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local RS=game:GetService("RunService")
local LP=P.LocalPlayer
local F={TrPos="顶部"}

local function parent()
	local ok,g=pcall(function() return gethui and gethui() end)
	if ok and g then return g end
	return LP:WaitForChild("PlayerGui")
end

local ALLOW={[112270456220062]=true}
if not ALLOW[game.PlaceId] then
	local sg=Instance.new("ScreenGui")
	sg.Name="blind_gate" sg.ResetOnSpawn=false sg.IgnoreGuiInset=true sg.DisplayOrder=9999
	sg.Parent=parent()
	local f=Instance.new("Frame")
	f.Size=UDim2.fromOffset(210,86) f.Position=UDim2.new(0.5,-105,0.5,-43)
	f.BackgroundColor3=Color3.fromRGB(20,20,24) f.Parent=sg
	local c=Instance.new("UICorner") c.CornerRadius=UDim.new(0,10) c.Parent=f
	local l=Instance.new("TextLabel")
	l.Size=UDim2.new(1,-16,1,-16) l.Position=UDim2.fromOffset(8,8) l.BackgroundTransparency=1
	l.Text="此脚本不支持当前游戏\nPlaceId: "..tostring(game.PlaceId)
	l.Font=Enum.Font.GothamBold l.TextSize=11 l.TextColor3=Color3.fromRGB(255,120,120)
	l.TextWrapped=true l.Parent=f
	task.delay(7,function() pcall(function() sg:Destroy() end) end)
	return
end

local gui=Instance.new("ScreenGui")
gui.Name="blind_"..tostring(math.random(100000,999999))
gui.ResetOnSpawn=false gui.IgnoreGuiInset=true gui.DisplayOrder=999
gui.Parent=parent()

local main=Instance.new("Frame")
main.Size=UDim2.fromOffset(260,260)
main.Position=UDim2.new(0.5,-130,0.5,-130)
main.BackgroundColor3=Color3.fromRGB(20,20,24)
main.Active=true main.Parent=gui
local cr=Instance.new("UICorner") cr.CornerRadius=UDim.new(0,12) cr.Parent=main
local sk=Instance.new("UIStroke") sk.Color=Color3.fromRGB(58,58,68) sk.Thickness=1 sk.Parent=main

local bar=Instance.new("Frame")
bar.Size=UDim2.new(1,0,0,30) bar.BackgroundColor3=Color3.fromRGB(30,30,36) bar.Parent=main
local cb=Instance.new("UICorner") cb.CornerRadius=UDim.new(0,12) cb.Parent=bar
local ttl=Instance.new("TextLabel")
ttl.Size=UDim2.new(1,-48,1,0) ttl.Position=UDim2.fromOffset(10,0) ttl.BackgroundTransparency=1
ttl.Text="Blind people and vision" ttl.Font=Enum.Font.GothamBold ttl.TextSize=12
ttl.TextColor3=Color3.fromRGB(235,235,240) ttl.TextXAlignment=Enum.TextXAlignment.Left ttl.Parent=bar
local cls=Instance.new("TextButton")
cls.Size=UDim2.fromOffset(22,22) cls.Position=UDim2.new(1,-28,0.5,-11)
cls.BackgroundColor3=Color3.fromRGB(200,60,60) cls.Text="×" cls.Font=Enum.Font.GothamBold
cls.TextSize=14 cls.TextColor3=Color3.new(1,1,1) cls.AutoButtonColor=false cls.Parent=bar
local cc=Instance.new("UICorner") cc.CornerRadius=UDim.new(0,6) cc.Parent=cls

local side=Instance.new("Frame")
side.Size=UDim2.new(0,76,1,-64) side.Position=UDim2.fromOffset(8,34)
side.BackgroundTransparency=1 side.Parent=main
local sl=Instance.new("UIListLayout") sl.Padding=UDim.new(0,6) sl.Parent=side

local function tab(nm)
	local b=Instance.new("TextButton")
	b.Size=UDim2.new(1,0,0,30) b.BackgroundColor3=Color3.fromRGB(32,32,38)
	b.Text=nm b.Font=Enum.Font.GothamBold b.TextSize=11
	b.TextColor3=Color3.fromRGB(215,215,220) b.AutoButtonColor=false b.Parent=side
	local c=Instance.new("UICorner") c.CornerRadius=UDim.new(0,7) c.Parent=b
	return b
end
local function page()
	local s=Instance.new("ScrollingFrame")
	s.Size=UDim2.new(1,-100,1,-70) s.Position=UDim2.fromOffset(92,64)
	s.BackgroundTransparency=1 s.BorderSizePixel=0 s.ScrollBarThickness=2
	s.CanvasSize=UDim2.new(0,0,0,0) s.AutomaticCanvasSize=Enum.AutomaticSize.Y
	s.Visible=false s.Parent=main
	local l=Instance.new("UIListLayout") l.Padding=UDim.new(0,5) l.SortOrder=Enum.SortOrder.LayoutOrder l.Parent=s
	return s
end
local function hd(pg,txt)
	local l=Instance.new("TextLabel")
	l.Size=UDim2.new(1,0,0,18) l.BackgroundTransparency=1 l.Text=txt
	l.Font=Enum.Font.GothamMedium l.TextSize=10 l.TextColor3=Color3.fromRGB(120,170,255)
	l.TextXAlignment=Enum.TextXAlignment.Left l.Parent=pg
	return l
end
local function row(pg,nm)
	local r=Instance.new("TextButton")
	r.Size=UDim2.new(1,0,0,28) r.BackgroundColor3=Color3.fromRGB(32,32,38)
	r.Text="" r.AutoButtonColor=false r.Parent=pg
	local c=Instance.new("UICorner") c.CornerRadius=UDim.new(0,7) c.Parent=r
	local l=Instance.new("TextLabel")
	l.Size=UDim2.new(1,-58,1,0) l.Position=UDim2.fromOffset(8,0) l.BackgroundTransparency=1
	l.Text=nm l.Font=Enum.Font.GothamMedium l.TextSize=9
	l.TextColor3=Color3.fromRGB(226,226,231) l.TextXAlignment=Enum.TextXAlignment.Left
	l.TextWrapped=true l.Parent=r
	return r
end
local function tg(pg,nm,key)
	local r=row(pg,nm)
	local b=Instance.new("TextButton")
	b.Size=UDim2.fromOffset(34,18) b.Position=UDim2.new(1,-42,0.5,-9)
	b.BackgroundColor3=Color3.fromRGB(45,45,52) b.Text="关" b.Font=Enum.Font.GothamBold
	b.TextSize=9 b.TextColor3=Color3.new(1,1,1) b.AutoButtonColor=false b.Parent=r
	local c=Instance.new("UICorner") c.CornerRadius=UDim.new(0,6) c.Parent=b
	b.MouseButton1Click:Connect(function()
		F[key]=not F[key]
		b.Text=F[key] and "开" or "关"
		b.BackgroundColor3=F[key] and Color3.fromRGB(60,160,90) or Color3.fromRGB(45,45,52)
		if F["_on_"..key] then pcall(F["_on_"..key],F[key]) end
	end)
	return b
end
local function cy(pg,nm,key,list)
	local r=row(pg,nm)
	local b=Instance.new("TextButton")
	b.Size=UDim2.fromOffset(34,18) b.Position=UDim2.new(1,-42,0.5,-9)
	b.BackgroundColor3=Color3.fromRGB(45,45,52) b.Text=F[key] or list[1]
	b.Font=Enum.Font.GothamBold b.TextSize=9 b.TextColor3=Color3.new(1,1,1)
	b.AutoButtonColor=false b.Parent=r
	local c=Instance.new("UICorner") c.CornerRadius=UDim.new(0,6) c.Parent=b
	b.MouseButton1Click:Connect(function()
		local i=1
		for k,v in ipairs(list) do if v==F[key] then i=k break end end
		i=(i%#list)+1 F[key]=list[i] b.Text=F[key]
	end)
	return b
end

local pg1=page() local pg2=page()
local t1=tab("ESP") local t2=tab("基础功能")
local function sel(p)
	pg1.Visible=(p==1) pg2.Visible=(p==2)
	t1.BackgroundColor3=(p==1) and Color3.fromRGB(60,90,255) or Color3.fromRGB(32,32,38)
	t2.BackgroundColor3=(p==2) and Color3.fromRGB(60,90,255) or Color3.fromRGB(32,32,38)
end
t1.MouseButton1Click:Connect(function() sel(1) end)
t2.MouseButton1Click:Connect(function() sel(2) end)
sel(1)

hd(pg1,"基础 ESP")
tg(pg1,"名称（失明者看不到）","eNm")
tg(pg1,"射线（通用）","eTr")
cy(pg1,"射线位置","TrPos",{"顶部","底部","头部","跟随"})
tg(pg1,"方框（通用）","eBx")
tg(pg1,"距离（失明者看不到）","eDs")
tg(pg1,"高亮（失明者看不到）","eHl")
hd(pg1,"其他 ESP")
tg(pg1,"香蕉 ESP","eBan")
tg(pg1,"陷阱 ESP","eTrp")

hd(pg2,"基础功能")
tg(pg2,"防滑","antiSlip")
tg(pg2,"防布娃娃","noRag")

local ESPG=Instance.new("ScreenGui")
ESPG.Name="blind_esp_"..tostring(math.random(100000,999999))
ESPG.ResetOnSpawn=false ESPG.IgnoreGuiInset=true ESPG.DisplayOrder=998
ESPG.Parent=parent()

local ES={} local cam=nil
local function newText()
	local t=Instance.new("TextLabel")
	t.BackgroundTransparency=1 t.Font=Enum.Font.GothamBold t.TextSize=12
	t.TextStrokeTransparency=0.45 t.TextColor3=Color3.new(1,1,1)
	t.Size=UDim2.fromOffset(180,14) t.AnchorPoint=Vector2.new(0.5,0)
	t.Visible=false t.Parent=ESPG
	return t
end
local function getES(inst)
	local d=ES[inst]
	if d then return d end
	d={}
	d.n=newText() d.d=newText()
	d.b=Instance.new("Frame")
	d.b.BackgroundTransparency=1 d.b.BorderSizePixel=0 d.b.Visible=false
	d.b.AnchorPoint=Vector2.new(0.5,0) d.b.Parent=ESPG
	local s=Instance.new("UIStroke") s.Thickness=1.2 s.Parent=d.b d.bs=s
	d.t=Instance.new("Frame")
	d.t.BorderSizePixel=0 d.t.Visible=false d.t.AnchorPoint=Vector2.new(0.5,0.5) d.t.Parent=ESPG
	d.hl=nil
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
		local h=Instance.new("Highlight")
		h.Name="blindhl" h.FillTransparency=0.72 h.OutlineTransparency=0
		h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
		h.Adornee=inst h.Parent=inst
		d.hl=h
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
		d.d.Text=math.floor((cam.CFrame.Position-rp).Magnitude).."m"
		d.d.TextColor3=col
		d.d.Position=UDim2.fromOffset(cx,(F.eNm and a.Y-16) or (a.Y-30)) d.d.Visible=true
	end
	if F.eBx and on and b.Z>0 then
		local h=math.max(math.abs(b.Y-a.Y),10)
		local w=math.max(h*0.62,6)
		d.b.Size=UDim2.fromOffset(w,h)
		d.b.Position=UDim2.fromOffset(cx,math.min(a.Y,b.Y))
		d.bs.Color=col d.b.Visible=true
	else d.b.Visible=false end
	if F.eTr and on then
		local vp=cam.ViewportSize local ax,ay=vp.X/2,vp.Y
		if F.TrPos=="顶部" then ax,ay=vp.X/2,0
		elseif F.TrPos=="底部" then ax,ay=vp.X/2,vp.Y
		elseif F.TrPos=="头部" then
			local hd=LP.Character and LP.Character:FindFirstChild("Head")
			if hd then local s=cam:WorldToViewportPoint(hd.Position) ax,ay=s.X,s.Y end
		else ax,ay=F.TX or vp.X/2,F.TY or vp.Y end
		local tx,ty=cx,(a.Y+b.Y)/2
		local dx,dy=tx-ax,ty-ay
		d.t.Size=UDim2.new(0,math.sqrt(dx*dx+dy*dy),0,1.2)
		d.t.Position=UDim2.new(0,(ax+tx)/2,0,(ay+ty)/2)
		d.t.Rotation=math.deg(math.atan2(dy,dx))
		d.t.BackgroundColor3=col d.t.Visible=true
	else d.t.Visible=false end
end

local BAN={} local TRA={}
local function reg(o)
	if not (o:IsA("BasePart") or o:IsA("Model")) then return end
	local n=string.lower(o.Name)
	if string.find(n,"banana",1,true) then BAN[o]=true end
	if string.find(n,"trap",1,true) then TRA[o]=true end
end
workspace.DescendantAdded:Connect(reg)
for _,o in ipairs(workspace:GetDescendants()) do reg(o) end

local function posOf(o)
	if o:IsA("BasePart") then return o.Position,o.Position end
	local h=o:FindFirstChild("Head") or o.PrimaryPart
	local r=o:FindFirstChild("HumanoidRootPart") or o.PrimaryPart or h
	if not r then return nil end
	return (h and h.Position) or r.Position,r.Position
end
local function tickSet(set,on,col,label)
	for inst in pairs(set) do
		if not inst.Parent then
			set[inst]=nil dropES(inst)
		else
			local d=ES[inst]
			if not on then hideES(d) else
				local hp,rp=posOf(inst)
				if hp then
					d=getES(inst)
					draw(inst,hp,rp,d,col,label)
					setHL(inst,d,col)
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
			local mv=hu.MoveDirection
			local v=hr.AssemblyLinearVelocity
			local sp=hu.WalkSpeed
			hr.AssemblyLinearVelocity=Vector3.new(mv.X*sp,v.Y,mv.Z*sp)
		end
		if F.noRag and hu then
			if hu.PlatformStand then hu.PlatformStand=false end
			if hu:GetState()==Enum.HumanoidStateType.Physics then
				pcall(function() hu:ChangeState(Enum.HumanoidStateType.Running) end)
			end
		end
	end
end)
F["_on_noRag"]=function(on)
	local function ap(c)
		local hu=c and c:FindFirstChildOfClass("Humanoid")
		if not hu then return end
		pcall(function() hu:SetStateEnabled(Enum.HumanoidStateType.Physics,not on) end)
		pcall(function() hu:SetStateEnabled(Enum.HumanoidStateType.FallingDown,not on) end)
		pcall(function() hu:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,not on) end)
		hu.PlatformStand=false
	end
	ap(LP.Character)
	if not F._rdC then F._rdC=LP.CharacterAdded:Connect(function(c) task.wait(0.6) ap(c) end) end
end

local drag=false local d0=nil local dP=nil
bar.InputBegan:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then
		drag=true d0=i.Position dP=main.Position
	end
end)
UIS.InputChanged:Connect(function(i)
	if not drag then return end
	if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseMovement then
		local d=i.Position-d0
		main.Position=UDim2.new(dP.X.Scale,dP.X.Offset+d.X,dP.Y.Scale,dP.Y.Offset+d.Y)
	end
end)
UIS.InputEnded:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then drag=false end
end)
cls.MouseButton1Click:Connect(function()
	for inst in pairs(ES) do dropES(inst) end
	ESPG:Destroy() gui:Destroy()
end)
