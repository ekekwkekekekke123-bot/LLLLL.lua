--===== MM2 · LLL 单文件 =====
do
	local G=_G
	local function isfn(k) local ok,v=pcall(function() return G[k] end) return ok and type(v)=="function" end
	if not isfn("gethui") then
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
local MM2_ID=142823291
if game.PlaceId~=MM2_ID then
	local sg=Instance.new("ScreenGui")
	if not pcall(function() sg.Parent=game:GetService("CoreGui") end) then
		sg.Parent=LP:WaitForChild("PlayerGui")
	end
	local t=Instance.new("TextLabel")
	t.Size=UDim2.fromScale(1,0.16) t.Position=UDim2.fromScale(0,0.42)
	t.BackgroundColor3=Color3.fromRGB(20,20,24) t.BackgroundTransparency=0.1
	t.TextColor3=Color3.fromRGB(255,140,140) t.Font=Enum.Font.GothamBold
	t.TextSize=16 t.Text="此脚本仅支持 Murder Mystery 2"
	t.Parent=sg
	task.delay(5,function() pcall(function() sg:Destroy() end) end)
	return
end
local function B(c,p) local o=Instance.new(c) for k,v in pairs(p) do if k~="Parent" then o[k]=v end end if p.Parent then o.Parent=p.Parent end return o end
local function safeParent()
	local ok,h=pcall(function() return gethui() end)
	if ok and typeof(h)=="Instance" then return h end
	local ok2,c=pcall(function() return game:GetService("CoreGui") end)
	if ok2 and typeof(c)=="Instance" then return c end
	return LP.PlayerGui
end
local C={
	bg=Color3.fromRGB(238,233,223),
	row=Color3.fromRGB(246,241,232),
	off=Color3.fromRGB(212,204,191),
	accent=Color3.fromRGB(190,74,64),
	txt=Color3.fromRGB(38,38,38),
	dim=Color3.fromRGB(108,103,95)
}
local gui=B("ScreenGui",{Name="mm2_ui",IgnoreGuiInset=true,ResetOnSpawn=false,DisplayOrder=60})
gui.Parent=safeParent()
local vp0=workspace.CurrentCamera.ViewportSize
local PW,PH=340,250
local x0=math.floor((vp0.X-PW)/2)
local y0=math.floor((vp0.Y-PH)/2)
local pn=B("Frame",{Size=UDim2.fromOffset(math.floor(PW*0.92),math.floor(PH*0.92)),Position=UDim2.fromOffset(x0+math.floor(PW*0.04),y0+math.floor(PH*0.04)),BackgroundColor3=C.bg,BackgroundTransparency=1,ZIndex=10,Parent=gui})
local st=Instance.new("UIStroke") st.Color=Color3.fromRGB(120,110,98) st.Transparency=0.55 st.Parent=pn
local bar=B("Frame",{Size=UDim2.new(1,0,0,32),BackgroundTransparency=1,ZIndex=11,Parent=pn})
B("TextLabel",{Size=UDim2.new(1,-80,1,0),Position=UDim2.fromOffset(14,0),BackgroundTransparency=1,Text="MM2 · LLL",Font=Enum.Font.GothamBold,TextSize=13,TextColor3=C.accent,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=12,Parent=bar})
local minBtn=B("TextButton",{Size=UDim2.fromOffset(30,30),Position=UDim2.new(1,-64,0.5,0),AnchorPoint=Vector2.new(0,0.5),BackgroundTransparency=1,Text="－",Font=Enum.Font.GothamBold,TextSize=16,TextColor3=C.dim,ZIndex=12,Parent=bar})
local miniMade=false
minBtn.MouseButton1Click:Connect(function()
	TS:Create(pn,TweenInfo.new(0.16,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Size=UDim2.fromOffset(math.floor(PW*0.92),math.floor(PH*0.92)),BackgroundTransparency=1}):Play()
	task.wait(0.18)
	pn.Visible=false
	if miniMade then return end
	miniMade=true
	local ig=B("ScreenGui",{IgnoreGuiInset=true,ResetOnSpawn=false,DisplayOrder=70,Parent=safeParent()})
	local ib=B("TextButton",{Size=UDim2.fromOffset(34,34),Position=UDim2.fromOffset(18,18),BackgroundColor3=Color3.fromRGB(255,255,255),BackgroundTransparency=0.5,Text="M",Font=Enum.Font.GothamBold,TextSize=12,TextColor3=Color3.fromRGB(70,70,70),AutoButtonColor=false,Parent=ig})
	local ir=Instance.new("UICorner") ir.CornerRadius=UDim.new(1,0) ir.Parent=ib
	local is=Instance.new("UIStroke") is.Color=Color3.fromRGB(255,255,255) is.Transparency=0.3 is.Thickness=1 is.Parent=ib
	local gr=Instance.new("UIGradient") gr.Rotation=120 gr.Color=ColorSequence.new(Color3.fromRGB(255,255,255),Color3.fromRGB(198,208,224)) gr.Parent=ib
	local drag=false
	local moved=0
	ib.InputBegan:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then
			drag=true moved=0
		end
	end)
	ib.InputChanged:Connect(function(i)
		if drag and (i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseMovement) then
			moved=moved+math.abs(i.Delta.X)+math.abs(i.Delta.Y)
			ib.Position=UDim2.new(0,ib.Position.X.Offset+i.Delta.X,0,ib.Position.Y.Offset+i.Delta.Y)
		end
	end)
	ib.InputEnded:Connect(function()
		if not drag then return end
		drag=false
		if moved<6 then
			pn.Visible=true
			pn.BackgroundTransparency=1
			TS:Create(pn,TweenInfo.new(0.22,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Size=UDim2.fromOffset(PW,PH),Position=UDim2.fromOffset(x0,y0),BackgroundTransparency=0.05}):Play()
		end
	end)
end)
local close=B("TextButton",{Size=UDim2.fromOffset(30,30),Position=UDim2.new(1,-34,0.5,0),AnchorPoint=Vector2.new(0,0.5),BackgroundTransparency=1,Text="×",Font=Enum.Font.GothamBold,TextSize=18,TextColor3=C.dim,ZIndex=12,Parent=bar})
B("Frame",{Size=UDim2.new(1,0,0,1),Position=UDim2.fromOffset(0,32),BackgroundColor3=C.off,BackgroundTransparency=0.15,ZIndex=11,Parent=pn})
local side=B("ScrollingFrame",{Size=UDim2.new(0,74,1,-33),Position=UDim2.fromOffset(0,33),BackgroundColor3=C.row,BackgroundTransparency=0.05,BorderSizePixel=0,ScrollBarThickness=2,CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,ZIndex=12,Parent=pn})
local slay=Instance.new("UIListLayout") slay.Padding=UDim.new(0,3) slay.SortOrder=Enum.SortOrder.LayoutOrder slay.Parent=side
local spad=Instance.new("UIPadding") spad.PaddingLeft=UDim.new(0,6) spad.PaddingRight=UDim.new(0,6) spad.PaddingTop=UDim.new(0,5) spad.Parent=side
local ebtn=B("TextButton",{Size=UDim2.new(1,0,0,24),BackgroundColor3=C.accent,Text="ESP",Font=Enum.Font.GothamMedium,TextSize=10,TextColor3=Color3.new(1,1,1),AutoButtonColor=false,LayoutOrder=1,Parent=side})
local body=B("ScrollingFrame",{Size=UDim2.new(1,-84,1,-44),Position=UDim2.fromOffset(80,38),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=2,CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,ZIndex=11,Parent=pn})
local lay=Instance.new("UIListLayout") lay.Padding=UDim.new(0,4) lay.SortOrder=Enum.SortOrder.LayoutOrder lay.Parent=body
TS:Create(pn,TweenInfo.new(0.22,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{
	Size=UDim2.fromOffset(PW,PH),
	Position=UDim2.fromOffset(x0,y0),
	BackgroundTransparency=0.05
}):Play()
close.MouseButton1Click:Connect(function()
	TS:Create(pn,TweenInfo.new(0.16,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{
		Size=UDim2.fromOffset(math.floor(PW*0.92),math.floor(PH*0.92)),
		BackgroundTransparency=1
	}):Play()
	task.wait(0.18)
	pcall(function() gui:Destroy() end)
end)
-- ↓↓↓ 功能往这里加（body 是滚动容器）↓↓↓
--==== MM2 · ESP 一栏 ====
local ES={Killer=false,Police=false,Civ=false,Trap=false,Gun=false,Time=false}
local CLR={Killer=Color3.fromRGB(255,60,60),Police=Color3.fromRGB(60,140,255),Civ=Color3.fromRGB(60,220,110),Trap=Color3.fromRGB(255,232,120),Gun=Color3.fromRGB(90,220,255)}
local function mkToggle(name,key)
	local row=B("TextButton",{Size=UDim2.new(1,0,0,30),BackgroundColor3=Color3.fromRGB(236,230,220),BorderSizePixel=0,Text="",AutoButtonColor=false,Parent=body})
	local rs=Instance.new("UIStroke") rs.Color=Color3.fromRGB(150,140,128) rs.Transparency=0.45 rs.Parent=row
	B("TextLabel",{Size=UDim2.new(1,-56,1,0),Position=UDim2.fromOffset(10,0),BackgroundTransparency=1,Text=name,Font=Enum.Font.GothamMedium,TextSize=11,TextColor3=Color3.fromRGB(38,38,38),TextXAlignment=Enum.TextXAlignment.Left,Parent=row})
	local sw=B("Frame",{Size=UDim2.fromOffset(32,18),Position=UDim2.new(1,-42,0.5,-9),BackgroundColor3=Color3.fromRGB(168,160,148),BorderSizePixel=0,Parent=row})
	local ss=Instance.new("UIStroke") ss.Color=Color3.fromRGB(95,88,80) ss.Transparency=0.3 ss.Parent=sw
	local kn=B("Frame",{Size=UDim2.fromOffset(14,14),Position=UDim2.fromOffset(2,2),BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,Parent=sw})
	row.MouseButton1Click:Connect(function()
		ES[key]=not ES[key]
		sw.BackgroundColor3=ES[key] and C.accent or Color3.fromRGB(168,160,148)
		local ti=TweenInfo.new(0.18,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
		TS:Create(kn,ti,{Position=UDim2.fromOffset(ES[key] and 16 or 2,2)}):Play()
	end)
end
mkToggle("杀手ESP","Killer")
mkToggle("警察ESP","Police")
mkToggle("平民ESP","Civ")
mkToggle("陷阱ESP","Trap")
mkToggle("枪ESP","Gun")
mkToggle("时间ESP","Time")
local function mmToast(msg)
	local g=B("ScreenGui",{IgnoreGuiInset=true,ResetOnSpawn=false,DisplayOrder=7000,Parent=safeParent()})
	local f=B("Frame",{Size=UDim2.fromOffset(168,28),Position=UDim2.new(1,-180,0,58),BackgroundColor3=C.bg,BackgroundTransparency=1,Parent=g})
	local s=Instance.new("UIStroke") s.Color=Color3.fromRGB(25,25,25) s.Transparency=1 s.Parent=f
	local t=B("TextLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text=msg,Font=Enum.Font.GothamMedium,TextSize=10,TextColor3=Color3.fromRGB(190,150,60),TextTransparency=1,Parent=f})
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
local HL={}
local function hl(obj,col,on)
	if not obj then return end
	local h=HL[obj]
	if not h then
		h=Instance.new("Highlight")
		h.FillTransparency=1
		h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
		h.Parent=obj
		HL[obj]=h
	end
	h.OutlineColor=col
	h.Enabled=on
end
local timeGui=B("ScreenGui",{IgnoreGuiInset=true,ResetOnSpawn=false,DisplayOrder=65,Parent=safeParent()})
local timeLbl=B("TextLabel",{Size=UDim2.fromOffset(180,22),Position=UDim2.new(0.5,-90,0,4),BackgroundTransparency=1,Text="",Font=Enum.Font.GothamBold,TextSize=16,TextColor3=C.txt,TextStrokeTransparency=0.5,Visible=false,Parent=timeGui})
local roundEnd=0
local lastGun=false
task.spawn(function()
	local lastState=0
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
						if pl~=LP then hl(c,CLR.Killer,ES.Killer) end
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
			if lastGun and not ES.Gun then lastGun=false end
			if not workspace:FindFirstChildWhichIsA("Tool") then
				if lastGun then
					lastGun=false
					mmToast("枪械已被拾取")
				end
			end
			if ES.Time then
				if roundEnd==0 or (LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") and LP.Character:FindFirstChildOfClass("Humanoid").Health>0 and roundEnd-os.clock()<-5) then
					roundEnd=os.clock()+180
				end
				local left=math.max(0,math.floor(roundEnd-os.clock()))
				timeLbl.Text=string.format("%d:%02d",math.floor(left/60),left%60)
				timeLbl.Visible=true
			else
				timeLbl.Visible=false
			end
		end)
	end
end)
