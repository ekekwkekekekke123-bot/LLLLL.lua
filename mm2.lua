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
minBtn.MouseButton1Click:Connect(function()
	pn.Visible=false
	if gui:FindFirstChild("iconHolder") then return end
	local holder=B("Frame",{Name="iconHolder",Size=UDim2.fromOffset(60,60),Position=UDim2.fromOffset(12,12),BackgroundTransparency=1,ZIndex=400,Parent=gui})
	local hit=B("TextButton",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="",AutoButtonColor=false,ZIndex=401,Parent=holder})
	local ib=B("TextButton",{Size=UDim2.fromOffset(34,34),Position=UDim2.fromScale(0.5,0.5),AnchorPoint=Vector2.new(0.5,0.5),BackgroundColor3=Color3.fromRGB(255,255,255),BackgroundTransparency=1,Text="wx",Font=Enum.Font.GothamBold,TextSize=12,TextColor3=Color3.fromRGB(70,70,70),AutoButtonColor=false,ZIndex=402,Parent=holder})
	B("UICorner",{CornerRadius=UDim.new(1,0),Parent=ib})
	local isk=B("UIStroke",{Color=Color3.fromRGB(255,255,255),Transparency=1,Thickness=1.2,Parent=ib})
	B("UIGradient",{Rotation=120,Color=ColorSequence.new(Color3.fromRGB(255,255,255),Color3.fromRGB(200,212,228)),Parent=ib})
	local sc=Instance.new("UIScale") sc.Scale=0.5 sc.Parent=holder
	TS:Create(sc,TweenInfo.new(0.2,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Scale=1}):Play()
	TS:Create(ib,TweenInfo.new(0.2),{BackgroundTransparency=0.45}):Play()
	TS:Create(isk,TweenInfo.new(0.2),{Transparency=0.25}):Play()
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
	hit.InputEnded:Connect(function() drag=false end)
	ib.MouseButton1Click:Connect(function()
		if moved>=8 then return end
		local s2=holder:FindFirstChildOfClass("UIScale")
		if s2 then TS:Create(s2,TweenInfo.new(0.12,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Scale=0.3}):Play() end
		TS:Create(ib,TweenInfo.new(0.12),{BackgroundTransparency=1}):Play()
		TS:Create(isk,TweenInfo.new(0.12),{Transparency=1}):Play()
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
