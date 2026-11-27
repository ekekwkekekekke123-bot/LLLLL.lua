-- 执行器兼容层：有些执行器/沙箱里 task 是 nil，用 wait/spawn/delay 兜底，再不行用 RunService
local tSpawn=(task and task.spawn) or spawn or function(f,...) local a={...} coroutine.wrap(function() f(table.unpack(a)) end)() end
local tWait=(task and task.wait) or wait or function(n) local t0=os.clock() local RS=game:GetService("RunService") while (n==nil) or (os.clock()-t0<n) do RS.Heartbeat:Wait() end end
local tDelay=(task and task.delay) or delay or function(n,f) tSpawn(function() tWait(n) f() end) end
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
	tDelay(5,function() pcall(function() sg:Destroy() end) end)
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
local ES={Killer=false,Police=false,Civ=false,Trap=false,Gun=false,Time=false,Line=false,offScr=false,Coin=false,TrapLine=false,GunLine=false,CoinLine=false}
local SCRIPT_T0=os.clock()
local CLR={Killer=Color3.fromRGB(255,60,60),Police=Color3.fromRGB(60,140,255),Civ=Color3.fromRGB(60,220,110),Trap=Color3.fromRGB(255,232,120),Gun=Color3.fromRGB(90,220,255),Coin=Color3.fromRGB(255,205,60)}
-- 每个颜色的透明度（0=全透明 1=完全不透明），调色盘的 Alpha 滑条写这里
local ALPHA={Killer=1,Police=1,Civ=1,Trap=1,Gun=1,Coin=1}
local yv=0
local openCVP
local function mkToggle(name,key)
	local row=B("TextButton",{Size=UDim2.new(1,0,0,30),Position=UDim2.fromOffset(0,yv),BackgroundColor3=C.row,BorderSizePixel=0,Text="",AutoButtonColor=false,ZIndex=130,Parent=body})
	yv=yv+34
	B("UIStroke",{Color=Color3.fromRGB(150,140,128),Transparency=0.4,Parent=row})
	B("TextLabel",{Size=UDim2.new(1,-86,1,0),Position=UDim2.fromOffset(10,0),BackgroundTransparency=1,Text=name,Font=Enum.Font.GothamMedium,TextSize=11,TextColor3=C.txt,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=131,Parent=row})
	-- 调色块（这个 ESP 有对应颜色才显示）
	local swatch=nil
	if CLR[key] then
		swatch=B("TextButton",{Size=UDim2.fromOffset(20,14),Position=UDim2.new(1,-70,0.5,-7),BackgroundColor3=CLR[key],BorderSizePixel=0,Text="",AutoButtonColor=false,ZIndex=132,Parent=row})
		B("UIStroke",{Color=Color3.fromRGB(120,112,102),Transparency=0.25,Parent=swatch})
		swatch.MouseButton1Click:Connect(function()
			if openCVP then pcall(openCVP,key,swatch) end
		end)
	end
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
mkToggle("金币ESP","Coin")
-- 金币 ESP 距离限制（5~120 米，超出不画框也不画射线），默认 50
ES.CoinRange=50
do
	local r=B("TextButton",{Size=UDim2.new(1,0,0,30),Position=UDim2.fromOffset(0,yv),BackgroundColor3=C.row,BorderSizePixel=0,Text="",AutoButtonColor=false,ZIndex=130,Parent=body})
	yv=yv+34
	B("UIStroke",{Color=Color3.fromRGB(150,140,128),Transparency=0.4,Parent=r})
	B("TextLabel",{Size=UDim2.new(1,-104,1,0),Position=UDim2.fromOffset(10,0),BackgroundTransparency=1,Text="金币ESP范围限制",Font=Enum.Font.Gotham,TextSize=11,TextStrokeTransparency=1,TextColor3=C.txt,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=131,Parent=r})
	-- 输入框只在你按完（失去焦点）时才纠正数值；
	-- 以前每敲一个字符就被强行夹一次，"100" 永远打不进去 —— 这就是那个 bug。
	local tb=B("TextBox",{Size=UDim2.fromOffset(72,20),Position=UDim2.new(1,-84,0.5,0),AnchorPoint=Vector2.new(0,0.5),BackgroundColor3=Color3.fromRGB(238,232,222),Text="50",PlaceholderText="5-120m",PlaceholderColor3=Color3.fromRGB(178,170,158),Font=Enum.Font.Gotham,TextSize=11,TextStrokeTransparency=1,TextColor3=Color3.fromRGB(92,88,82),ClearTextOnFocus=false,ZIndex=132,Parent=r})
	local tb=B("TextBox",{Size=UDim2.fromOffset(72,20),Position=UDim2.new(1,-84,0.5,0),AnchorPoint=Vector2.new(0,0.5),BackgroundColor3=Color3.fromRGB(238,232,222),BorderSizePixel=0,Text="50",PlaceholderText="5-120m",PlaceholderColor3=Color3.fromRGB(178,170,158),Font=Enum.Font.GothamMedium,TextSize=11,TextStrokeTransparency=1,TextColor3=Color3.fromRGB(92,88,82),ClearTextOnFocus=false,ZIndex=132,Parent=r})
	-- 边打边生效：只在数值合法范围内才写进去，不修改你正在输入的文本
	tb:GetPropertyChangedSignal("Text"):Connect(function()
		local v=tonumber(string.match(tostring(tb.Text) or "","(%d+%.?%d*)"))
		if v and v>=5 and v<=120 then ES.CoinRange=v end
	end)
	-- 打完离开输入框：夹到 5~120 并回写
	tb.FocusLost:Connect(function()
		local v=tonumber(string.match(tostring(tb.Text) or "","(%d+%.?%d*)"))
		if not v then v=ES.CoinRange end
		v=math.clamp(v,5,120)
		ES.CoinRange=v
		tb.Text=tostring(math.floor(v+0.5))
	end)
	tb.Text="50"
end
mkToggle("超出屏幕也绘制","OffScr")
local posV="顶部"
B("TextLabel",{Size=UDim2.new(1,0,0,14),Position=UDim2.fromOffset(10,yv),BackgroundTransparency=1,Text="射线的颜色取决于ESP颜色",Font=Enum.Font.GothamMedium,TextSize=9,TextColor3=C.dim,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=131,Parent=body})
yv=yv+18
local pRow=B("TextButton",{Size=UDim2.new(1,0,0,28),Position=UDim2.fromOffset(0,yv),BackgroundColor3=C.row,BorderSizePixel=0,Text="",AutoButtonColor=false,ZIndex=130,Parent=body})
B("UIStroke",{Color=Color3.fromRGB(150,140,128),Transparency=0.4,Parent=pRow})
B("TextLabel",{Size=UDim2.new(1,-56,1,0),Position=UDim2.fromOffset(10,0),BackgroundTransparency=1,Text="射线位置",Font=Enum.Font.GothamMedium,TextSize=11,TextColor3=C.txt,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=131,Parent=pRow})
local pVal=B("TextLabel",{Size=UDim2.new(0,52,1,0),Position=UDim2.new(1,-58,0,0),BackgroundTransparency=1,Text=posV,Font=Enum.Font.GothamMedium,TextSize=11,TextColor3=C.accent,TextXAlignment=Enum.TextXAlignment.Right,ZIndex=131,Parent=pRow})
yv=yv+32
-- 射线粗细滑条（0.85 ~ 3），拖动立即生效：drawLine 每帧都读 ES.LineW
ES.LineW=1.2
;(function()
	local wRow=B("TextButton",{Size=UDim2.new(1,0,0,28),Position=UDim2.fromOffset(0,yv),BackgroundColor3=C.row,BorderSizePixel=0,Text="",AutoButtonColor=false,ZIndex=130,Parent=body})
	B("UIStroke",{Color=Color3.fromRGB(150,140,128),Transparency=0.4,Parent=wRow})
	B("TextLabel",{Size=UDim2.new(1,-86,1,0),Position=UDim2.fromOffset(10,0),BackgroundTransparency=1,Text="射线粗细",Font=Enum.Font.GothamMedium,TextSize=11,TextColor3=C.txt,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=131,Parent=wRow})
	local wVal=B("TextLabel",{Size=UDim2.new(0,52,1,0),Position=UDim2.new(1,-58,0,0),BackgroundTransparency=1,Text=string.format("%.2f",ES.LineW),Font=Enum.Font.GothamMedium,TextSize=11,TextColor3=C.accent,TextXAlignment=Enum.TextXAlignment.Right,ZIndex=131,Parent=wRow})
	yv=yv+32
	local trk=B("TextButton",{Size=UDim2.new(1,-20,0,14),Position=UDim2.fromOffset(10,yv),BackgroundColor3=C.off,BorderSizePixel=0,Text="",AutoButtonColor=false,ZIndex=130,Parent=body})
	B("UIStroke",{Color=Color3.fromRGB(95,88,80),Transparency=0.35,Parent=trk})
	local fill=B("Frame",{Size=UDim2.new(0,0,1,0),BackgroundColor3=C.accent,BorderSizePixel=0,ZIndex=131,Parent=trk})
	local grip=B("Frame",{Size=UDim2.fromOffset(16,16),AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(0,0,0.5,0),BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,ZIndex=132,Parent=trk})
	local mnW,mxW=0.85,3
	local function setW(v)
		local w=math.clamp(tonumber(v) or 1.2,mnW,mxW)
		ES.LineW=w
		local f=(w-mnW)/(mxW-mnW)
		fill.Size=UDim2.fromScale(f,1)
		grip.Position=UDim2.fromScale(f,0.5)
		wVal.Text=string.format("%.2f",w)
	end
	local dragW=false
	local function fromX(x)
		local ax=trk.AbsolutePosition.X
		local aw=math.max(trk.AbsoluteSize.X,1)
		setW(mnW+math.clamp((x-ax)/aw,0,1)*(mxW-mnW))
	end
	trk.InputBegan:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
			dragW=true fromX(i.Position.X)
		end
	end)
	local UISw=game:GetService("UserInputService")
	UISw.InputChanged:Connect(function(i)
		if dragW and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
			fromX(i.Position.X)
		end
	end)
	UISw.InputEnded:Connect(function() dragW=false end)
	setW(ES.LineW)
	yv=yv+22
end)()
-- 三条专用射线，位置统一由上面那个「射线位置」决定，且分别跟 陷阱ESP / 枪ESP / 金币ESP 绑定
mkToggle("陷阱ESP射线","TrapLine")
mkToggle("枪ESP射线","GunLine")
mkToggle("金币ESP射线","CoinLine")
--==== ESP 调色盘（CVP）====
-- DisplayOrder 顶格 + ZIndex 大，保证调色期间盖住面板和所有 ESP 层；
-- 点空白处 = 保留当前颜色关闭，点「取消」= 还原成打开前的颜色；
-- 拖动即时写 CLR[key]，射线和描边每帧都读 CLR，所以立刻跟着变。
;(function()
	local cg=B("ScreenGui",{Name="mm2_cvp",IgnoreGuiInset=true,ResetOnSpawn=false,DisplayOrder=2147483647,Enabled=false,Parent=SP()})
	local shade=B("TextButton",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="",AutoButtonColor=false,ZIndex=1,Parent=cg})
	local box=B("Frame",{Size=UDim2.fromOffset(248,190),AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),BackgroundColor3=C.bg,BorderSizePixel=0,Active=true,ZIndex=2,Parent=cg})
	B("UIStroke",{Color=Color3.fromRGB(150,140,128),Transparency=0.15,Parent=box})
	local title=B("TextLabel",{Size=UDim2.new(1,-20,0,20),Position=UDim2.fromOffset(10,4),BackgroundTransparency=1,Text="颜色",Font=Enum.Font.GothamMedium,TextSize=11,TextColor3=C.txt,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=3,Parent=box})
	local sv=B("TextButton",{Size=UDim2.fromOffset(150,120),Position=UDim2.fromOffset(10,26),BackgroundColor3=Color3.fromRGB(255,0,0),BorderSizePixel=0,ClipsDescendants=true,Text="",AutoButtonColor=false,ZIndex=3,Parent=box})
	local wf=B("Frame",{Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,ZIndex=4,Parent=sv})
	B("UIGradient",{Transparency=NumberSequence.new{NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(1,1)},Parent=wf})
	local bf=B("Frame",{Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.new(0,0,0),BorderSizePixel=0,ZIndex=5,Parent=sv})
	B("UIGradient",{Rotation=90,Transparency=NumberSequence.new{NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(1,0)},Parent=bf})
	local dot=B("Frame",{Size=UDim2.fromOffset(10,10),AnchorPoint=Vector2.new(0.5,0.5),BackgroundTransparency=1,ZIndex=6,Parent=sv})
	B("UIStroke",{Color=Color3.new(1,1,1),Thickness=2,Parent=dot})
	local hue=B("TextButton",{Size=UDim2.fromOffset(18,120),Position=UDim2.fromOffset(168,26),BackgroundColor3=Color3.fromRGB(255,0,0),BorderSizePixel=0,ClipsDescendants=true,Text="",AutoButtonColor=false,ZIndex=3,Parent=box})
	B("UIGradient",{Rotation=90,Color=ColorSequence.new{
		ColorSequenceKeypoint.new(0,Color3.fromRGB(255,0,0)),
		ColorSequenceKeypoint.new(0.17,Color3.fromRGB(255,255,0)),
		ColorSequenceKeypoint.new(0.33,Color3.fromRGB(0,255,0)),
		ColorSequenceKeypoint.new(0.5,Color3.fromRGB(0,255,255)),
		ColorSequenceKeypoint.new(0.67,Color3.fromRGB(0,0,255)),
		ColorSequenceKeypoint.new(0.83,Color3.fromRGB(255,0,255)),
		ColorSequenceKeypoint.new(1,Color3.fromRGB(255,0,0))},Parent=hue})
	local hdot=B("Frame",{Size=UDim2.new(1,0,0,4),AnchorPoint=Vector2.new(0,0.5),BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,ZIndex=6,Parent=hue})
	local prev=B("Frame",{Size=UDim2.fromOffset(60,22),Position=UDim2.fromOffset(10,154),BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,ZIndex=3,Parent=box})
	B("UIStroke",{Color=Color3.fromRGB(120,112,102),Transparency=0.25,Parent=prev})
	local cBtn=B("TextButton",{Size=UDim2.fromOffset(60,22),Position=UDim2.fromOffset(78,154),BackgroundColor3=C.off,BorderSizePixel=0,Text="取消",Font=Enum.Font.GothamMedium,TextSize=10,TextColor3=C.txt,AutoButtonColor=false,ZIndex=3,Parent=box})
	local aBtn=B("TextButton",{Size=UDim2.fromOffset(60,22),Position=UDim2.fromOffset(146,154),BackgroundColor3=C.accent,BorderSizePixel=0,Text="确定",Font=Enum.Font.GothamMedium,TextSize=10,TextColor3=Color3.new(1,1,1),AutoButtonColor=false,ZIndex=3,Parent=box})
	local Uc=game:GetService("UserInputService")
	local cvKey,cvSw=nil,nil
	local origC=Color3.new(1,1,1)
	local hh,sx,vy=0,1,0
	local function refresh()
		local col=Color3.fromHSV(hh,math.clamp(sx,0,1),math.clamp(1-vy,0,1))
		pcall(function()
			sv.BackgroundColor3=Color3.fromHSV(hh,1,1)
			dot.Position=UDim2.fromScale(math.clamp(sx,0,1),math.clamp(vy,0,1))
			hdot.Position=UDim2.new(0,0,math.clamp(hh,0,1),0)
			prev.BackgroundColor3=col
		end)
		if cvKey then
			CLR[cvKey]=col
			if cvSw and cvSw.Parent then cvSw.BackgroundColor3=col end
		end
	end
	local function closeC(keep)
		if (not keep) and cvKey and origC then
			CLR[cvKey]=origC
			if cvSw and cvSw.Parent then cvSw.BackgroundColor3=origC end
		end
		cvKey=nil
		cg.Enabled=false
	end
	openCVP=function(key,sw2)
		cvKey=key
		cvSw=sw2
		origC=CLR[key] or Color3.new(1,1,1)
		local h0,s0,v0=origC:ToHSV()
		hh=h0 sx=s0 vy=1-v0
		title.Text="颜色 · "..tostring(key)
		cg.Enabled=true
		refresh()
	end
	local d1,d2=false,false
	local function svPick(x,y)
		sx=(x-sv.AbsolutePosition.X)/math.max(sv.AbsoluteSize.X,1)
		vy=(y-sv.AbsolutePosition.Y)/math.max(sv.AbsoluteSize.Y,1)
		refresh()
	end
	local function huePick(y)
		hh=(y-hue.AbsolutePosition.Y)/math.max(hue.AbsoluteSize.Y,1)
		refresh()
	end
	sv.InputBegan:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
			d1=true svPick(i.Position.X,i.Position.Y)
		end
	end)
	hue.InputBegan:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
			d2=true huePick(i.Position.Y)
		end
	end)
	Uc.InputChanged:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then
			if d1 then svPick(i.Position.X,i.Position.Y) end
			if d2 then huePick(i.Position.Y) end
		end
	end)
	Uc.InputEnded:Connect(function() d1=false d2=false end)
	shade.MouseButton1Click:Connect(function() closeC(true) end)
	cBtn.MouseButton1Click:Connect(function() closeC(false) end)
	aBtn.MouseButton1Click:Connect(function() closeC(true) end)
end)()

--==== ESP 调色盘（照搬 wx 主脚本那个，SV 方块 + 色相条 + Hex/RGB + 新旧对比）====
--==== ESP 调色盘（外观按 wx 主脚本那套统一：SV 方块 + 色相条 + 透明条 + Hex/RGB 数值 + 新旧对比）====
;(function()
	local function R2(o,r) local u=Instance.new("UICorner") u.CornerRadius=(r>1) and UDim.new(0,r) or UDim.new(r,0) u.Parent=o return u end
	local function SK2(o,c,t) local s=Instance.new("UIStroke") s.Color=c s.Thickness=1 s.Transparency=t or 0 s.Parent=o return s end
	local cpG=B("ScreenGui",{Name="mm2_cp2",ResetOnSpawn=false,IgnoreGuiInset=true,DisplayOrder=2147483647,Enabled=false,Parent=SP()})
	local shade=B("TextButton",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="",AutoButtonColor=false,ZIndex=4,Parent=cpG})
	local cpF=B("Frame",{Size=UDim2.fromOffset(304,232),Position=UDim2.new(0.5,-152,0.5,-116),BackgroundColor3=Color3.fromRGB(15,15,17),BorderSizePixel=0,Active=true,ZIndex=6,Parent=cpG})
	R2(cpF,18) SK2(cpF,Color3.fromRGB(236,230,220),0.12).Thickness=2
	local ttl=B("TextLabel",{Size=UDim2.new(1,-24,0,20),Position=UDim2.fromOffset(12,6),BackgroundTransparency=1,Text="颜色",Font=Enum.Font.GothamBold,TextSize=13,TextColor3=Color3.new(1,1,1),TextXAlignment=Enum.TextXAlignment.Left,ZIndex=7,Parent=cpF})
	local sv=B("Frame",{Size=UDim2.fromOffset(130,116),Position=UDim2.fromOffset(12,30),BackgroundColor3=Color3.fromRGB(255,0,0),ClipsDescendants=true,ZIndex=7,Parent=cpF})
	R2(sv,8)
	local sat=B("Frame",{Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,ZIndex=8,Parent=sv})
	R2(sat,8)
	B("UIGradient",{Transparency=NumberSequence.new{NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(1,1)},Parent=sat})
	local vdk=B("Frame",{Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.new(0,0,0),BorderSizePixel=0,ZIndex=9,Parent=sv})
	R2(vdk,8)
	B("UIGradient",{Rotation=90,Transparency=NumberSequence.new{NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(1,0)},Parent=vdk})
	local dot=B("Frame",{Size=UDim2.fromOffset(16,16),AnchorPoint=Vector2.new(0.5,0.5),BackgroundTransparency=1,ZIndex=14,Parent=cpF})
	R2(dot,0.5) SK2(dot,Color3.new(1,1,1),0).Thickness=2
	local hb=B("TextButton",{Size=UDim2.fromOffset(12,116),Position=UDim2.fromOffset(152,30),BackgroundColor3=Color3.new(1,1,1),ClipsDescendants=true,ZIndex=13,Parent=cpF}) Text="" AutoButtonColor=false
	R2(hb,6)
	B("UIGradient",{Rotation=90,Color=ColorSequence.new{
		ColorSequenceKeypoint.new(0,Color3.fromRGB(255,0,0)),
		ColorSequenceKeypoint.new(0.17,Color3.fromRGB(255,255,0)),
		ColorSequenceKeypoint.new(0.33,Color3.fromRGB(0,255,0)),
		ColorSequenceKeypoint.new(0.5,Color3.fromRGB(0,255,255)),
		ColorSequenceKeypoint.new(0.67,Color3.fromRGB(0,0,255)),
		ColorSequenceKeypoint.new(0.83,Color3.fromRGB(255,0,255)),
		ColorSequenceKeypoint.new(1,Color3.fromRGB(255,0,0))},Parent=hb})
	local hmark=B("Frame",{Size=UDim2.fromOffset(16,16),AnchorPoint=Vector2.new(0.5,0.5),BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,ZIndex=14,Parent=cpF})
	R2(hmark,0.5) SK2(hmark,Color3.fromRGB(40,40,48),0)
	-- 透明度滑条（竖条：下=全透明 上=完全不透明），条身用当前颜色渲染
	local ab=B("TextButton",{Size=UDim2.fromOffset(12,116),Position=UDim2.fromOffset(170,30),BackgroundColor3=Color3.fromRGB(255,0,0),ClipsDescendants=true,Text="",AutoButtonColor=false,ZIndex=13,Parent=cpF})
	R2(ab,6)
	B("UIGradient",{Rotation=90,Transparency=NumberSequence.new{NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(1,1)},Parent=ab})
	local amark=B("Frame",{Size=UDim2.fromOffset(16,16),AnchorPoint=Vector2.new(0.5,0.5),BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,ZIndex=14,Parent=cpF})
	R2(amark,0.5) SK2(amark,Color3.fromRGB(40,40,48),0)
	local fields={}
	local labels={"Hex","Red","Green","Blue","Alpha"}
	for i=1,5 do
		local tx=B("TextLabel",{Size=UDim2.fromOffset(96,24),Position=UDim2.fromOffset(196,30+(i-1)*24),BackgroundColor3=Color3.fromRGB(26,26,30),Text="",Font=Enum.Font.GothamMedium,TextSize=10,TextColor3=Color3.new(1,1,1),TextXAlignment=Enum.TextXAlignment.Left,ZIndex=8,Parent=cpF})
		R2(tx,7)
		B("UIPadding",{PaddingLeft=UDim.new(0,6),Parent=tx})
		B("TextLabel",{Size=UDim2.fromOffset(38,24),Position=UDim2.new(1,-40,0,0),BackgroundTransparency=1,Text=labels[i],Font=Enum.Font.GothamMedium,TextSize=9,TextColor3=Color3.fromRGB(110,110,118),TextXAlignment=Enum.TextXAlignment.Right,ZIndex=9,Parent=tx})
		fields[i]=tx
	end
	local swA=B("Frame",{Size=UDim2.fromOffset(62,26),Position=UDim2.fromOffset(12,156),BackgroundColor3=Color3.new(1,1,1),ZIndex=7,Parent=cpF})
	R2(swA,7) SK2(swA,Color3.fromRGB(70,70,80),0.5)
	local swB=B("Frame",{Size=UDim2.fromOffset(62,26),Position=UDim2.fromOffset(80,156),BackgroundColor3=Color3.new(1,1,1),ZIndex=7,Parent=cpF})
	R2(swB,7) SK2(swB,Color3.fromRGB(70,70,80),0.5)
	local cB=B("TextButton",{Size=UDim2.fromOffset(130,32),Position=UDim2.fromOffset(12,190),BackgroundColor3=Color3.fromRGB(26,26,30),BorderSizePixel=0,Text="Cancel",Font=Enum.Font.GothamBold,TextSize=11,TextColor3=Color3.new(1,1,1),AutoButtonColor=false,ZIndex=8,Parent=cpF})
	R2(cB,8)
	local aB=B("TextButton",{Size=UDim2.fromOffset(146,32),Position=UDim2.fromOffset(148,190),BackgroundColor3=C.accent,BorderSizePixel=0,Text="›  Apply",Font=Enum.Font.GothamBold,TextSize=11,TextColor3=Color3.new(1,1,1),AutoButtonColor=false,ZIndex=8,Parent=cpF})
	R2(aB,8)
	local hV,sV,vV=0,1,1
	local cpA=1
	local oldA=1
	local cpT=nil
	local cpBlk=nil
	local oldC=Color3.new(1,1,1)
	local function sync()
		local col=Color3.fromHSV(hV,sV,vV)
		sv.BackgroundColor3=Color3.fromHSV(hV,1,1)
		-- 小球一律夹在方块/滑条内部，不会再探出去半个
		dot.Position=UDim2.fromOffset(12+math.clamp(sV*130,8,122),30+math.clamp((1-vV)*116,8,108))
		hmark.Position=UDim2.fromOffset(158,30+math.clamp(hV*116,8,108))
		amark.Position=UDim2.fromOffset(176,30+math.clamp((1-cpA)*116,8,108))
		ab.BackgroundColor3=col

		swB.BackgroundColor3=col
		fields[1].Text=string.format("#%02x%02x%02x",math.floor(col.R*255),math.floor(col.G*255),math.floor(col.B*255))
		fields[2].Text=tostring(math.floor(col.R*255+0.5))
		fields[3].Text=tostring(math.floor(col.G*255+0.5))
		fields[4].Text=tostring(math.floor(col.B*255+0.5))
		fields[5].Text=tostring(math.floor(cpA*100+0.5)).."%"
	end
	local function closeC(keep)
		if (not keep) and cpT then
			CLR[cpT]=oldC
			ALPHA[cpT]=oldA
			if cpBlk and cpBlk.Parent then cpBlk.BackgroundColor3=oldC end
		end
		cpT=nil
		cpG.Enabled=false
	end
	openCVP=function(key,sw2)
		cpT=key
		cpBlk=sw2
		ttl.Text="颜色 · "..tostring(key)
		local col=CLR[key] or Color3.new(1,1,1)
		oldC=col
		cpA=ALPHA[key] or 1
		oldA=cpA
		swA.BackgroundColor3=col
		hV,sV,vV=Color3.toHSV(col)
		cpG.Enabled=true
		sync()
	end
	local d1,d2,d3=false,false,false
	local Uc=game:GetService("UserInputService")
	local function pickSV(x,y)
		sV=math.clamp((x-sv.AbsolutePosition.X)/math.max(sv.AbsoluteSize.X,1),0,1)
		vV=math.clamp(1-(y-sv.AbsolutePosition.Y)/math.max(sv.AbsoluteSize.Y,1),0,1)
		sync()
	end
	local function pickHue(y)
		hV=math.clamp((y-hb.AbsolutePosition.Y)/math.max(hb.AbsoluteSize.Y,1),0,1)
		sync()
	end
	local function pickA(y)
		cpA=math.clamp(1-(y-ab.AbsolutePosition.Y)/math.max(ab.AbsoluteSize.Y,1),0,1)
		sync()
	end
	sv.InputBegan:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
			d1=true pickSV(i.Position.X,i.Position.Y)
		end
	end)
	hb.InputBegan:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
			d2=true pickHue(i.Position.Y)
		end
	end)
	ab.InputBegan:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
			d3=true pickA(i.Position.Y)
		end
	end)
	Uc.InputChanged:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then
			if d1 then pickSV(i.Position.X,i.Position.Y) end
			if d2 then pickHue(i.Position.Y) end
			if d3 then pickA(i.Position.Y) end
		end
	end)
	Uc.InputEnded:Connect(function() d1=false d2=false d3=false end)
	cB.MouseButton1Click:Connect(function() closeC(false) end)
	aB.MouseButton1Click:Connect(function()
		local c=Color3.fromHSV(hV,sV,vV)
		if cpT then CLR[cpT]=c ALPHA[cpT]=cpA end
		if cpBlk and cpBlk.Parent then pcall(function() cpBlk.BackgroundColor3=c end) end
		if keyRefresh then pcall(keyRefresh) end
		pcall(function() mmToast(string.format("已应用 #%02x%02x%02x",math.floor(c.R*255),math.floor(c.G*255),math.floor(c.B*255))) end)
		closeC(true)
	end)
	shade.MouseButton1Click:Connect(function() closeC(true) end)
	-- 把旧那套调色盘的残留 GUI 清掉
	pcall(function()
		for _,g in ipairs(SP():GetChildren()) do
			if g.Name=="mm2_cvp" then pcall(function() g:Destroy() end) end
		end
	end)
end)()

local pickGui=B("ScreenGui",{Name="mm2_pick",IgnoreGuiInset=true,ResetOnSpawn=false,DisplayOrder=9000,Enabled=false,Parent=SP()})
gui.Destroying:Connect(function() pcall(function() pickGui:Destroy() end) end)
local shade=B("TextButton",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="",AutoButtonColor=false,ZIndex=1,Parent=pickGui})
local box=B("Frame",{Size=UDim2.fromOffset(120,176),Position=UDim2.fromScale(0.5,0.5),AnchorPoint=Vector2.new(0.5,0.5),BackgroundColor3=C.bg,BackgroundTransparency=1,BorderSizePixel=0,Active=true,ZIndex=2,Parent=pickGui})
B("UIStroke",{Color=Color3.fromRGB(150,140,128),Transparency=0.35,Parent=box})
local optBtns={}
local closePick
local function openPick()
	pickGui.Enabled=true
	box.Size=UDim2.fromOffset(70,70)
	for _,b in ipairs(optBtns) do b.BackgroundTransparency=1 b.TextTransparency=1 end
	TS:Create(box,TweenInfo.new(0.26,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Size=UDim2.fromOffset(120,176),BackgroundTransparency=0.03}):Play()
	tDelay(0.05,function()
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
	tDelay(0.15,function() pickGui.Enabled=false end)
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
mkOpt("头部","头部",2)
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
	tDelay(2.6,function()
		TS:Create(f,TweenInfo.new(0.22),{BackgroundTransparency=1}):Play()
		TS:Create(s,TweenInfo.new(0.22),{Transparency=1}):Play()
		TS:Create(t,TweenInfo.new(0.22),{TextTransparency=1}):Play()
	end)
	tDelay(3.0,function() pcall(function() g:Destroy() end) end)
end
-- 屏幕日志（手机端看不到控制台，用它看诊断，10 秒无新消息自动隐藏）
local DBG={lines={},shown=0}
local function mmDbg(msg)
	pcall(function()
		msg=tostring(msg)
		DBG.lines[#DBG.lines+1]=msg
		if #DBG.lines>16 then table.remove(DBG.lines,1) end
		DBG.shown=os.clock()
		if not DBG.gui then
			local sg=B("ScreenGui",{Name="mm2_dbg",IgnoreGuiInset=true,ResetOnSpawn=false,DisplayOrder=9500,Parent=SP()})
			local f=B("Frame",{Size=UDim2.fromOffset(360,170),Position=UDim2.new(0,8,1,-178),BackgroundColor3=Color3.fromRGB(18,18,18),BorderSizePixel=0,ZIndex=9000,Parent=sg})
			B("UIStroke",{Color=Color3.fromRGB(210,210,210),Transparency=0.35,Parent=f})
			DBG.label=B("TextLabel",{Size=UDim2.new(1,-26,1,-10),Position=UDim2.fromOffset(8,6),BackgroundTransparency=1,Text="",Font=Enum.Font.Code,TextSize=11,TextColor3=Color3.fromRGB(235,235,235),TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,TextWrapped=true,ZIndex=9001,Parent=f})
			local xb=B("TextButton",{Size=UDim2.fromOffset(20,20),Position=UDim2.new(1,-23,0,2),BackgroundTransparency=1,Text="×",Font=Enum.Font.GothamBold,TextSize=14,TextColor3=Color3.fromRGB(205,205,205),AutoButtonColor=false,ZIndex=9002,Parent=f})
			xb.MouseButton1Click:Connect(function() pcall(function() sg.Enabled=false end) end)
			DBG.gui=sg
		end
		DBG.gui.Enabled=true
		DBG.label.Text=table.concat(DBG.lines,"\n")
	end)
end
-- ============================================================
-- [新增] 警长功能 / 杀手功能
-- 依赖本文件已有: B TS C pn side body LP P mmToast
-- 道具判定: Tool 名 "Knife" = 杀手, "Gun" = 警长 (与第170行逻辑一致)
-- ============================================================
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

local CFG = { ShLoop = false, FastKnife = false, MeleeBox = false, MeleeSz = 2, PullSlash = false, PullRange = 20 }
-- 世代号：重复 loadstring 时，旧实例的循环必须自己停手，否则会出现"老版本还在放大别人身体"这种鬼事
local GEN = (_G.__mm2gen or 0) + 1
_G.__mm2gen = GEN
local function stale() return _G.__mm2gen ~= GEN end


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
			local c = math.clamp(v, mn, mx)
			CFG[key] = c
			if c ~= v then
				-- 超出范围：输入框直接改回边界值（比如写 100 会立刻变成 80）
				tb.Text = tostring(c)
				return
			end
			if cb then pcall(cb, c) end
		end
	end)
end

-- ---------- 1. 子弹追踪（已按用户要求删除）----------

-- ---------- 2. 甩飞 ----------
-- 说明：客户端没法直接改别的玩家的位置/速度（他的人体是他自己的客户端在算），
-- 所以"焊接 + 给自己 6e4 速度"这套原来的写法只会把你自己甩上天摔死，目标纹丝不动。
-- 这里改成：反复钻到他身上 + 临时放大自己的体积，让"他的客户端"把他顶出去。
-- 不敢保证一定能飞，但至少不会把你送走。
local function flingOne(pl, tag)
	-- 四面八方甩飞：以目标为中心，周围 8 个方向 + 头顶各贴一次；
	-- 每次贴住 0.12 秒（每帧重写 CFrame，所以目标一直动也跑不掉），推完立刻归位 + 清零。
	-- 8 秒还没释放就视为上一次卡死（自己也可能中途死了），强制放行，避免"死了以后永远甩不了"
	if RT.flingC and (os.clock() - (RT.flingT or 0) < 8) then mmToast("甩飞进行中") return end
	RT.flingC = nil
	-- 出局后角色可能没有 Humanoid，但尸体/旁观角色的部件还在，能拿到哪个用哪个
	local c, h, r = myChar()
	if not (c and r) then
		c = LP.Character
		r = c and (c:FindFirstChild("HumanoidRootPart") or c.PrimaryPart or c:FindFirstChild("Torso") or c:FindFirstChild("UpperTorso"))
	end
	local tc = pl and pl.Character
	local tr = tc and (tc:FindFirstChild("HumanoidRootPart") or tc.PrimaryPart)
	if not (c and r and r:IsA("BasePart")) then mmToast("甩飞失败 · 你已出局且没有可用身体") return end
	if not (tr and tr:IsA("BasePart")) then mmToast("甩飞失败 · 目标无效") return end
	local back = r.CFrame
	RT.flingC = true
	RT.flingT = os.clock()
	tSpawn(function()
		local saved = {}
		for _, d in ipairs(c:GetDescendants()) do
			if d:IsA("BasePart") then
				local skip = false
				local a = d.Parent
				for _ = 1, 3 do
					if not a or a == c then break end
					if a:IsA("Accessory") or a:IsA("Tool") or a:IsA("Accoutrement") then skip = true break end
					a = a.Parent
				end
				if not skip then
					saved[d] = { c = d.CanCollide, a = d.Anchored }
					pcall(function() d.CanCollide = true d.Anchored = false end)
				end
			end
		end
		local V = 4200
		local R = 1.2
		local LEAD = 0.15   -- 预测提前量（秒）：补偿对方看到的延迟
		-- 方向按"目标的朝向"算：第 1 个就是他正身前（0,0,-1 是正前方）
		local DIRS = {}
		for k = 0, 7 do
			local an = k * math.pi / 4
			DIRS[#DIRS+1] = Vector3.new(math.sin(an), 0, -math.cos(an))
		end
		DIRS[#DIRS+1] = Vector3.new(0, 1, 0)
		pcall(function() r:SetNetworkOwner(LP) end)
		local bv = Instance.new("BodyVelocity")
		bv.Name = "WX_FL"
		bv.MaxForce = Vector3.new(1e18,1e18,1e18)
		bv.Velocity = Vector3.zero
		bv.Parent = r
		local touched = false
		for i = 1, #DIRS do
			local ts = os.clock()
			while os.clock() - ts < 0.12 do
				local _, _, r2 = myChar()
				local tch = pl and pl.Character
				local cur = tch and (tch:FindFirstChild("HumanoidRootPart") or tch.PrimaryPart)
				if not (r2 and cur) then break end
				if r2 ~= r then pcall(function() bv.Parent = r2 end) r = r2 end
				local gap = 999
				pcall(function() gap = (r2.Position - cur.Position).Magnitude end)
				if gap < 8 then touched = true end
				-- 相对目标朝向的方向（世界坐标）
				local dirW = (cur.CFrame - cur.Position) * DIRS[i]
				local vel = Vector3.zero
				pcall(function() vel = cur.AssemblyLinearVelocity end)
				if vel.Magnitude > 60 then vel = vel.Unit * 60 end
				pcall(function()
					r2.CFrame = CFrame.new(cur.Position + dirW * R + vel * LEAD)
					r2.AssemblyLinearVelocity = -dirW * V
					bv.Velocity = -dirW * V
				end)
				tWait()
			end
			pcall(function()
				bv.Velocity = Vector3.zero
				if r then
					r.AssemblyLinearVelocity = Vector3.zero
					r.AssemblyAngularVelocity = Vector3.zero
					r.CFrame = back
				end
			end)
			tWait(0.05)
		end
		pcall(function() bv:Destroy() end)
		for d, v in pairs(saved) do
			if d and d.Parent then
				pcall(function()
					d.CanCollide = v.c
					d.Anchored = v.a
				end)
			end
		end
		local _, _, r3 = myChar()
		if r3 then
			pcall(function()
				r3.CFrame = back
				r3.AssemblyLinearVelocity = Vector3.zero
				r3.AssemblyAngularVelocity = Vector3.zero
			end)
		end
		local h3 = c:FindFirstChildOfClass("Humanoid")
		if h3 then pcall(function() h3:ChangeState(Enum.HumanoidStateType.GettingUp) end) end
		RT.flingC = nil
		if not touched then
			mmToast((tag or "目标") .. " · 没贴上（距离太远或被弹开）")
		else
			mmToast((tag or "目标") .. " · 已甩飞")
		end
	end)
end

-- 一次点击连甩三回：单次太短 + 同步延迟，目标一直跑的时候要多来几次才稳
local function flingMulti(pl, tag, times)
	times = tonumber(times) or 3
	tSpawn(function()
		for i = 1, times do
			if not (pl and pl.Character) then break end
			-- 等上一次甩飞结束（flingOne 会占住 RT.flingC）
			local t0 = os.clock()
			while RT.flingC and os.clock() - t0 < 4 do tWait(0.05) end
			pcall(flingOne, pl, i == 1 and tag or (tostring(tag) .. " " .. i))
			local t1 = os.clock()
			while RT.flingC and os.clock() - t1 < 4 do tWait(0.05) end
			tWait(0.06)
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

local function suckKill(list, label)
	if not isMurderer() then mmToast("你不是杀手") return end
	local c, h, r = myChar()
	local tool = myKnife()
	if not (r and tool) then mmToast("手里没刀") return end

	local spot = r.Position + r.CFrame.LookVector * 2
	local live = {}
	for _, pl in ipairs(list) do
		local tc = pl and pl.Character
		local tr = tc and tc:FindFirstChild("HumanoidRootPart")
		local th = tc and tc:FindFirstChildOfClass("Humanoid")
		if tr and th and th.Health > 0 then
			live[#live + 1] = {tr = tr, th = th}
		end
	end
	if #live == 0 then mmToast("附近没人") return end

	local hold = os.clock() + 1
	local con
	con = RS.RenderStepped:Connect(function()
		local okk = false
		for _, o in ipairs(live) do
			if o.tr and o.tr.Parent then
				o.tr.CFrame = CFrame.new(spot)
				o.tr.AssemblyLinearVelocity = Vector3.zero
				o.tr.AssemblyAngularVelocity = Vector3.zero
				okk = true
			end
		end
		if not okk or os.clock() >= hold then
			con:Disconnect()
		end
	end)

	tSpawn(function()
		while os.clock() < hold do
			pcall(function() tool:Activate() end)
			tWait(0.09)
		end
	end)
	mmToast((label or "吸取击杀") .. " · " .. #live .. " 人")
end

local function killAll()
	if not isMurderer() then mmToast("你不是杀手") return end
	local list = {}
	for _, pl in ipairs(P:GetPlayers()) do
		if pl ~= LP then list[#list + 1] = pl end
	end
	suckKill(list, "吸取击杀全部")
end

local function killSheriff()
	if not isMurderer() then mmToast("你不是杀手") return end
	local pl = findSheriff()
	if not pl then mmToast("没找到警长") return end
	suckKill({pl}, "吸取击杀警长")
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
	suckKill({best}, "吸取击杀最近")
end

local function flingSheriff()
	local pl = findSheriff()
	if not pl then mmToast("没找到警长") return end
	flingMulti(pl, "警长", 3)
end

-- （原「5. 修改飞刀范围」整块已删除：它靠"猜名字叫 Part 的隐形零件"来放大判定盒，
--   猜不中就完全无效，猜中还可能误放大地图几何体；配套的 namecall 重定向也只是改方向、
--   并不延长距离。经确认收益不可靠，按用户要求连面板入口一起删掉。）

-- ---------- 5.1 快速扔刀 ----------
-- 旧写法有两个问题：
--   1. 只调 tr.Speed，而 AnimationTrack 该用 AdjustSpeed()；
--   2. 只在"点击那一瞬间"扫一次正在播的动画 —— 可投掷动画往往是点击之后才开始的，
--      那一刻列表是空的，等于什么都没加速。
-- 现在改成：点击后 0.6 秒内持续反复压速度，投掷动画什么时候开始播都能被抓住。
local FK = { tool=nil, conn=nil, busy=false, apConn=nil, anim=nil }
local function fkAnim(ch)
	local hum = ch and ch:FindFirstChildOfClass("Humanoid")
	return hum and hum:FindFirstChildOfClass("Animator")
end
local function fkBoost(ch, secs)
	if FK.busy then return end
	FK.busy = true
	tSpawn(function()
		local t0 = os.clock()
		while os.clock() - t0 < secs do
			local an = fkAnim(ch)
			if an then
				for _, tr in ipairs(an:GetPlayingAnimationTracks()) do
					pcall(function() tr:AdjustSpeed(6) end)
				end
			end
			tWait(0.03)
		end
		local an = fkAnim(ch)
		if an then
			for _, tr in ipairs(an:GetPlayingAnimationTracks()) do
				pcall(function() tr:AdjustSpeed(1) end)
			end
		end
		FK.busy = false
	end)
end
local function fkAttach()
	local ch = LP.Character
	if not ch then return end
	local t = ch:FindFirstChild("Knife") or ch:FindFirstChild("knife")
	if not (t and t:IsA("Tool")) then return end
	-- 第二套：直接监听"任何新动画开始播放"。只要有刀在手，就把新播的动画提速。
	-- 这样不依赖 Activated 的时机，游戏什么时候播投掷动画都能抓住。
	local an = fkAnim(ch)
	if an and FK.anim ~= an then
		if FK.apConn then pcall(function() FK.apConn:Disconnect() end) FK.apConn = nil end
		FK.anim = an
		FK.apConn = an.AnimationPlayed:Connect(function(tr)
			if not CFG.FastKnife then return end
			local c2 = LP.Character
			if not (c2 and (c2:FindFirstChild("Knife") or c2:FindFirstChild("knife"))) then return end
			pcall(function() tr:AdjustSpeed(8) end)
			tDelay(1.0, function() pcall(function() tr:AdjustSpeed(1) end) end)
		end)
	end
	if FK.tool == t and FK.conn then return end
	if FK.conn then pcall(function() FK.conn:Disconnect() end) FK.conn = nil end
	FK.tool = t
	FK.conn = t.Activated:Connect(function()
		if not CFG.FastKnife then return end
		fkBoost(ch, 0.6)
	end)
end
LP.CharacterAdded:Connect(function()
	tWait(0.4)
	if CFG.FastKnife then pcall(fkAttach) end
end)
tSpawn(function()
	while true do
		tWait(1)
		if CFG.FastKnife then pcall(fkAttach) end
	end
end)
-- （原 namecall 钩子已删除：它只服务于「修改飞刀范围」，功能删掉后钩子就只剩开销 ——
--   每一次 namecall 都要过一遍游戏里的实例调用，纯属拖慢手机。）


-- ---------- 面板构建 ----------
local ySh = {v = 0}
local yMu = {v = 0}

rowButton(bodySh, ySh, "甩飞杀手", function()
	local pl = findKiller()
	if not pl then mmToast("没找到杀手") return end
	flingMulti(pl, "杀手", 3)
end)
rowButton(bodySh, ySh, "传送到杀手身后", function()
	local pl = findKiller()
	if not pl then mmToast("没找到杀手") return end
	tpBehind(pl)
end)
rowToggle(bodySh, ySh, "循环传送到杀手身后", "ShLoop", tpLoopSet)
rowToggle(bodySh, ySh, "锁死杀手（子弹穿墙）", "PierceS")
-- 小字提示：这一项只负责"显示射击键"，真正开火要点屏幕上的按钮
;(function()
	local wr=B("Frame",{Size=UDim2.new(1,0,0,14),Position=UDim2.fromOffset(0,ySh.v),BackgroundTransparency=1,ZIndex=130,Parent=bodySh})
	B("TextLabel",{Size=UDim2.new(1,0,1,0),Position=UDim2.fromOffset(10,0),BackgroundTransparency=1,Text="必须点屏幕上那个「射击」按钮才会生效",Font=Enum.Font.Gotham,TextSize=9,TextStrokeTransparency=1,TextColor3=C.dim,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=131,Parent=wr})
	ySh.v=ySh.v+16
end)()
rowToggle(bodySh, ySh, "固定射击按钮", "PierceFix")
-- ---------- 锁死杀手（穿墙）----------
-- 抓包 + 实测：开枪是 Shoot:FireServer(起点CF, 终点CF)，两个点都由客户端给；
-- 直接发 "杀手身前2.5格 → 杀手位置" 能隔墙命中（测试里已验证有效）。
-- 这里把那一发做成屏幕上的一个「射击」按钮：按一次开一枪，时机由你控制。
local ShootRem = nil
local function findShootRem()
	if ShootRem and ShootRem.Parent then return ShootRem end
	ShootRem = nil
	local ok, rs = pcall(function() return game:GetService("ReplicatedStorage") end)
	if ok and rs then
		for _, d in ipairs(rs:GetDescendants()) do
			if d:IsA("RemoteEvent") and string.lower(d.Name) == "shoot" then ShootRem = d break end
		end
	end
	if not ShootRem then
		local c = LP.Character
		local g = c and c:FindFirstChild("Gun")
		if g then
			pcall(function()
				for _, d in ipairs(g:GetDescendants()) do
					if d:IsA("RemoteEvent") and string.lower(d.Name) == "shoot" then ShootRem = d break end
				end
			end)
		end
	end
	return ShootRem
end
local function pierceFireAt(tr)
	local rem = findShootRem()
	if not rem then return false end
	local ok = pcall(function() rem:FireServer(tr.CFrame * CFrame.new(0, 0, 2.5), CFrame.new(tr.Position)) end)
	return ok
end
-- 目标：优先"有 Knife 的那个人"（杀手），没有就退到最近的活人
local function pierceTarget()
	local kpl, kch = findKiller()
	if kch then
		local kh = kch:FindFirstChildOfClass("Humanoid")
		local tr = kch:FindFirstChild("HumanoidRootPart") or kch:FindFirstChild("Head")
		if kh and tr and kh.Health > 0 then return tr, kpl end
	end
	local _, _, r = myChar()
	if not r then return nil end
	local best, bd = nil, 1e9
	for _, pl in ipairs(P:GetPlayers()) do
		if pl ~= LP and pl.Character then
			local tr = pl.Character:FindFirstChild("HumanoidRootPart")
			local th = pl.Character:FindFirstChildOfClass("Humanoid")
			if tr and th and th.Health > 0 then
				local d = (tr.Position - r.Position).Magnitude
				if d < bd then bd = d best = tr end
			end
		end
	end
	return best
end
-- 屏幕上的「射击」键：黑边 + 暖白底，可拖动
local PIERCE_BTN = nil
tSpawn(function()
	local ok = pcall(function()
		local host = SP()
		local sg = B("ScreenGui", {Name="mm2_pierce", ResetOnSpawn=false, IgnoreGuiInset=true, DisplayOrder=9990, Parent=host})
		local btn = B("TextButton", {Size=UDim2.fromOffset(112,34), Position=UDim2.new(0,14,0.5,-17), BackgroundColor3=Color3.fromRGB(246,241,230), BorderSizePixel=0, Text="射击", Font=Enum.Font.GothamMedium, TextSize=15, TextStrokeTransparency=1, TextColor3=Color3.fromRGB(22,22,22), AutoButtonColor=false, ZIndex=9990, Visible=false, Parent=sg})
		local st = Instance.new("UIStroke") st.Color = Color3.fromRGB(18,18,18) st.Thickness = 2 st.Parent = btn
		local cr = Instance.new("UICorner") cr.CornerRadius = UDim.new(0,12) cr.Parent = btn
		PIERCE_BTN = btn
		-- 拖动
		local Uc = game:GetService("UserInputService")
		local drag, ds, ps = false, nil, nil
		btn.InputBegan:Connect(function(i)
			if CFG.PierceFix then return end   -- 固定模式：不许拖，只保留点击
			if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
				drag = true ds = i.Position ps = btn.AbsolutePosition
			end
		end)
		Uc.InputChanged:Connect(function(i)
			if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
				local d = i.Position - ds
				if math.abs(d.X) + math.abs(d.Y) > 8 then btn:SetAttribute("dragged", true) end
				btn.Position = UDim2.fromOffset(ps.X + d.X, ps.Y + d.Y)
			end
		end)
		Uc.InputEnded:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = false end
		end)
		-- 点一下 = 开一枪
		btn.MouseButton1Click:Connect(function()
			if (btn:GetAttribute("dragged")) then btn:SetAttribute("dragged", false) return end   -- 拖动过就不开火
			local tr, pl = pierceTarget()
			if not tr then mmToast("锁死杀手 · 附近没有目标") return end
			if pierceFireAt(tr) then
				mmToast("穿墙开枪 → " .. tostring(pl and pl.Name or (tr.Parent and tr.Parent.Name)))
			else
				mmToast("锁死杀手 · 没找到 Shoot 远程")
			end
		end)
	end)
	if not ok then mmToast("射击键创建失败") end
end)
-- 开关只管显示/隐藏这个键
tSpawn(function()
	while true do
		tWait(0.25)
		if PIERCE_BTN then PIERCE_BTN.Visible = (CFG.PierceS == true) end
	end
end)
-- ---------- 开枪音效替换 ----------
-- ===== 内置音效（把音频直接塞进脚本，不用上传、不怕私有化）=====
-- Roblox 强制音频私有：别人上传的 rbxassetid 你没权限，选了也是静音。
-- 别人脚本能做"内置音效"，靠的是执行器给的 writefile + getcustomasset：
--   音频字节写成手机里的本地文件 → 换成本地资源 ID → 直接播，完全不用上传
-- 下面两段都是脚本自带的音频，执行器支持就自动出现在「开枪音效」列表里
local SND_DATA = {
	{ n = "MC开门/关门", f = "mm2_snd_door.mp3", b64 = {
			"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",
	} },
	{ n = "MC箱子开/关", f = "mm2_snd_chest.mp3", b64 = {
			"SUQzBAAAAAAASVRDT1AAAAACAAADAFRYWFgAAAAQAAADY29weXJpZ2h0LWVuZwAAVFNTRQAAAA8AAANMYXZmNjMuMTYuMTAwAAAAAAAAAAAAAAD/84DEAAAAAAAAAAAASW5mbwAAAA8AAABhAABP/wAFBwoNDxIUFxocHyEkJyksLzE0Njk8PkFDRklLTlBTVlhYW15gY2Voa21wcnV4en1/goWHio2PkpSXmpyfoaSnqaysr7G0trm8vsHDxsnLztDT1tjb3uDj5ejr7fDy9fj6/f8AAAAATGF2YzYzLjI0AAAAAAAAAAAAAAAAAvL3AAAAAAAAT//MbCIRAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA//OAxAAAAANIAAAAAExBTUU0LjBVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVMQU1FNC4wVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVf/zgsQ7AAADSAAAAABVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV",
			"VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVUxBTUU0LjBVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV//OCxDsAAANIAAAAAFVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVTEFNRTQuMFVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVX/84LEOwAAA0gAAAAAVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVMQU1FNC4wVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVf/zgsQ7AAADSAAAAABVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV",
			"VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVUxBTUU0LjBVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV//OCxDsAAANIAAAAAFVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVTEFNRTQuMFVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVX/84LEOwAAA0gAAAAAVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVMQU1FNC4wVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVf/zgsQ7AAADSAAAAABVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV",
			"VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVUxBTUU0LjBVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV//OCxDsAAANIAAAAAFVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVTEFNRTQuMFVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVX/84LEOwAAA0gAAAAAVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVMQU1FNC4wVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVf/zgsQ7AAADSAAAAABVVVVVVVVV",
			"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",
			"AEWVuQkaxqgY9E0jM//01USvNk5lz5x8O84d6SJbXbY13mZ///846LkTcuTUVvKbH/1F+bH0TbLGXHQpvKLW/GKqHIrj6mL4BSEAEIzhkzAqKyCTTgGpNWuGT0KwSiAH24lMVrpWWgipCUoFcApwvjOTEkllpl1aPJqdEo+hMVtbbWBd/TVl2WjJ8kntGVtCW//vM4cSSZIUmidpRKyNgFQMAlgqBIoBHhMJHb/VPM+t5yUtXqpn0SSNI4aVqJxLfpxLe//zgsSCJyth8ABhhaxRjGQCN83t/6tvlbM3MZQpcFTtYaQeqDpVwK0D7UMFAjOqc9SbJIg8HGObBDovc8xJMnWjRmc4iHMkajtZQ0swIns09DTcQYOT2gzwkDiLQMXj0yQKQ4OhAKMhJ80oPjldGAD6OOm4ysfTIwLHQUYbBgwfBwRdYwHKAirjEEQLIO+oM89BRgwEU25wt2ZxWGIWDmefhFw49w4IxkRhzBlxCVzzqYoqpErFh6hdlyXdh2zlWpbIqEFHQgp+I1VMQU1FNC4w//OCxKkoUSk8UN80jVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVTEFNRTQuMFVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV",
			"VVVVVVVVVVVVVVVVVVX/84LEOwAAA0gAAAAAVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVMQU1FNC4wVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVf/zgsQ7AAADSAAAAABVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVUxBTUU0LjBVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV//OCxDsAAANIAAAAAFVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVTEFNRTQuMFVVVVVVVVVVVVVV",
			"VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVX/84LEOwAAA0gAAAAAVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVMQU1FNC4wVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVf/zgsQ7AAADSAAAAABVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVUxBTUU0LjBVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV//OCxDsAAANIAAAAAFVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV",
			"VVVVVVVVVVVVTEFNRTQuMFVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVX/84LEOwAAA0gAAAAAVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVMQU1FNC4wVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVf/zgsQ7AAADSAAAAABVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVUxBTUU0LjBVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV//OCxDsAAANIAAAAAFVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV",
			"VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVTEFNRTQuMFVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVX/84LEOwAAA0gAAAAAVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVMQU1FNC4wVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVf/zgsQ7AAADSAAAAABVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVUxBTUU0LjBVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV//OCxDsAAANIAAAAAFVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV",
			"VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVTEFNRTQuMFVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVX/84LEOwAAA0gAAAAAVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVUxBTUU0LjBVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVf/zgMQ8AAADSAAAAABVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVTEFNRTQuMFVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVX/84LEOwAAA0gAAAAAVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV",
			"VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVMQU1FNC4wVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVf/zgsQ7AAADSAAAAABVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVUxBTUU0LjBVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV//OCxDsAAANIAAAAAFVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVTEFNRTQuMFVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVX/84LEOwAAA0gAAAAAVVVVVVVVVVVVVVVVVVVVVVVVVVVV",
			"VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVWkXxgoYTOYDILIGL/CF5luo66ZUkevGB0IW5kq5KcZkMJWmdbkA5k+pdaYHYXmGVbBdJnSJR6Yy8VYGP/zgsQ7AAADSAAAAACCQqCYkmA8mBsAKxgsQKMZFYHEWxk1OeTHmPqxyDsY0em6tZkI0bWwmQjhpCEYgHmamJhYMZMTAoNMVEw4RMPFQwGMQFkkTBQdJIwIGTNMEBk+QKAreLgLhL/rfUwWepQxRL9oacjUE52ppfueuRtGBtu0gDAdgYDsPw4DwOxeEg+BIPg5juPA6D2I5cCspDoXx3LhYK5bL5bSExDJ6ETGRISk9CJiGZwHkB4yZtGDJnYzaMGTNo8qvqvssqvscVMKr7LK//OCxP9OqzjNYP7Yua/1lllV/rOX+v9ZzfsUu5f2Ob9jmOb9jm/o+xE39Ov9/pTX2HIkeBHkgR4GcOBHgR48CPAiI4EfDDPCOmwgUBmHRWYbPpxWHmJWscmMB237nKyuZsIBuT3H2mAYUHhiQDCwQiau4u19+6SMcfdy4aLqGtYCev9SgtgWkRQaZQs4cSzT1nAUAUEcSXvu5cjbgX8LSJWMzMAgcBzHDYnI30dyy7DuTm6eNxun7nlUsXYbcuLvomOuuRyiHL0rl8oZ2/dx/Jb/84LEiEqb",
			"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",
			"//OCxDsAAANIAAAAAKqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqTEFNRTQuMKqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqr/84LEOwAAA0gAAAAAqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqpMQU1FNC4wqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqv/zgsQ7AAADSAAAAACqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqkxBTUU0LjCqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq",
			"qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq//OCxDsAAANIAAAAAKqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqTEFNRTQuMKqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqr/84LEOwAAA0gAAAAAqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqpMQU1FNC4wqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqv/zgsQ7AAADSAAAAACqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqkxBTUU0",
			"LjCqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq//OCxDsAAANIAAAAAKqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqTEFNRTQuMKqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqr/84LEOwAAA0gAAAAAqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqpMQU1FNC4wqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqv/zgsQ7AAADSAAAAACqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq",
			"qqqqqqqqqqqqqqqqqqqqqqqqqqqqqkxBTUU0LjCqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq//OCxDsAAANIAAAAAKqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqTEFNRTQuMKqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqr/84LEOwAAA0gAAAAAqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqpMQU1FNC4wqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqv/zgsQ7AAADSAAAAACqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq",
			"qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqkxBTUU0LjCqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq//OCxDsAAANIAAAAAKqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqTEFNRTQuMKqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqr/84LEOwAAA0gAAAAAqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqpMQU1FNC4wqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqv/zgsQ7AAADSAAAAACqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq",
			"qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqkxBTUU0LjCqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq//OCxDsAAANIAAAAAKqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqTEFNRTQuMKqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqr/84LEOwAAA0gAAAAAqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqpMQU1FNC4wqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqv/zgsQ7AAADSAAAAACqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq",
			"qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq",
	} },
}
local function mmB64Dec(s)
	local A="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
	local rv={} for i=1,#A do rv[string.byte(A,i)]=i-1 end
	local out={} local b,n=0,0
	for i=1,#s do
		local v=rv[string.byte(s,i)]
		if v then
			b=b*64+v n=n+6
			if n>=8 then
				n=n-8
				local sh=2^n
				out[#out+1]=string.char(math.floor(b/sh)%256)
				b=b%sh
			end
		end
	end
	return table.concat(out)
end
-- 写文件 + 换成本地资源 ID；执行器不支持（很多手机执行器不支持）就返回 nil，界面上也不会出现这一项
-- 不同执行器叫法不一样：getcustomasset / getsynasset / getasset，全都试一遍
local function mmLocalSound(entry)
	local id=nil
	pcall(function()
		local mk=nil
		if type(getcustomasset)=="function" then mk=getcustomasset
		elseif type(getsynasset)=="function" then mk=getsynasset
		elseif type(getasset)=="function" then mk=getasset end
		if type(writefile)=="function" and mk then
			local data=mmB64Dec(table.concat(entry.b64))
			local exists=false
			if type(isfile)=="function" then pcall(function() exists=isfile(entry.f) end) end
			if not exists then writefile(entry.f,data) end
			local ok,res=pcall(function() return mk(entry.f) end)
			if ok then id=res end
		end
	end)
	return id
end


local SNDS = {
	{ n = "静音",   id = "rbxassetid://0" },
}
CFG.SndOn = false
CFG.SndIdx = 1
-- 脚本内置的音频挂进列表（执行器支持 writefile/getcustomasset 才出现）
do
	local any=false
	for _,e in ipairs(SND_DATA) do
		local sid=mmLocalSound(e)
		if sid then
			SNDS[#SNDS+1]={ n=e.n, id=sid }
			any=true
		end
	end
	if not any then
		tDelay(3, function() pcall(mmToast, "内置音效不可用：这个执行器没有 getcustomasset") end)
	else
		-- 默认选中第一个内置音效（别默认成静音，那样一开开关枪就没声了）
		CFG.SndIdx = 2
	end
end
local sndOrig = setmetatable({}, {__mode = "k"})
-- 加载可用性缓存：加载不出来的 ID 绝不用来替换，否则枪会彻底变哑巴
local sndGood = {}
local SILENT_ID = "rbxassetid://0"
local poolSeen = {}
local function sndCur() return SNDS[CFG.SndIdx] or SNDS[1] end
local function sndPoolAdd(name, id)
	if id == nil then return end
	id = tostring(id)
	if id == "" or id == "rbxassetid://" or poolSeen[id] then return end
	if #SNDS >= 14 then return end
	poolSeen[id] = true
	SNDS[#SNDS+1] = { n = "·"..tostring(name):sub(1,10), id = id }
end
local function sndTest(id, cb)
	if id == SILENT_ID then sndGood[id] = true cb(true) return end
	if sndGood[id] ~= nil then cb(sndGood[id]) return end
	local ok, snd = pcall(function() return Instance.new("Sound") end)
	if not ok or not snd then cb(false) return end
	local done = false
	local conn
	local function fin(good)
		if done then return end
		done = true
		sndGood[id] = good
		pcall(function() if conn then conn:Disconnect() end end)
		pcall(function() snd:Destroy() end)
		cb(good)
	end
	pcall(function()
		snd.Volume = 0
		snd.SoundId = id
		snd.Parent = game:GetService("SoundService")
	end)
	pcall(function() conn = snd.Loaded:Connect(function() fin(true) end) end)
	pcall(function() snd:Play() end)
	tDelay(6, function()
		if done then return end
		local loaded = false
		pcall(function() loaded = (snd.IsLoaded == true) or ((snd.TimeLength or 0) > 0.01) end)
		fin(loaded == true)
	end)
end
local function sndPreview()
	local it = sndCur()
	if not it then return end
	if it.id == SILENT_ID then mmToast("当前是静音档，当然没声") return end
	sndTest(it.id, function(good)
		if not good then mmToast("试听失败：这个音效加载不出来") return end
		local o, sn = pcall(function() return Instance.new("Sound") end)
		if not o then return end
		sn.Volume = 4
		sn.SoundId = it.id
		sn.Parent = game:GetService("SoundService")
		pcall(function() sn:Play() end)
		tDelay(6, function() pcall(function() sn:Destroy() end) end)
		mmToast("试听 · "..it.n)
	end)
end

local function sndBack()
	for d, v in pairs(sndOrig) do
		if d.Parent then pcall(function() d.SoundId = v end) end
	end
	sndOrig = setmetatable({}, {__mode = "k"})
end

local GUN_PAT = {"gun","shoot","fire","shot","pistol","revolver","fusil","pompe","tir","beretta","deagle","rifle","smg","枪"}
local CAP = {}   -- 已抓到的枪声素材 SoundId
local function isGunNm(n)
	n = string.lower(tostring(n))
	for i = 1, #GUN_PAT do if string.find(n, GUN_PAT[i], 1, true) then return true end end
	return false
end
local function looksGun(s)
	if isGunNm(s.Name) then return true end
	local ok, anc = pcall(function() return s:FindFirstAncestorOfClass("Tool") end)
	if ok and anc and isGunNm(anc.Name) then return true end
	-- 只按"名字"和"所在的工具"判断，不再按 SoundId 判断。
	-- 按 ID 判断的话，一旦你选的替换音效跟脚步声/按钮音效共用同一个资源，
	-- 那些声音会被一起当成枪声替换掉 —— 这就是"别人走路声音也变了"。
	return false
end
local function sndOne(s)
	if not s:IsA("Sound") then return end
	-- 界面上的按钮音效一律不碰：点一下按钮就响，就是因为它被误判成枪声然后重启了
	local pg=LP and LP:FindFirstChild("PlayerGui")
	if pg and s:IsDescendantOf(pg) then return end
	if not looksGun(s) then return end
	local sid = tostring(s.SoundId)
	if CAP[sid] == nil and sndOrig[s] == nil then
		CAP[sid] = true
	end
	if not CFG.SndOn then return end
	if sndOrig[s] == nil then sndOrig[s] = s.SoundId end
	local curSnd = sndCur()
	local id = curSnd and curSnd.id
	if id and s.SoundId ~= id then pcall(function() local was=s.Playing if was then s:Stop() end s.SoundId=id if was then s:Play() end end) end
end

local function sndScan()
	for _, p in ipairs(P:GetPlayers()) do
		local c = p.Character
		if c then
			for _, d in ipairs(c:GetDescendants()) do sndOne(d) end
		end
		local bk = p:FindFirstChild("Backpack")
		if bk then
			for _, d in ipairs(bk:GetDescendants()) do sndOne(d) end
		end
	end
end

tSpawn(function()
	while gui.Parent do
		tWait(0.4)
		if CFG.SndOn then pcall(sndScan) end
	end
end)

-- ---------- 后台静默抓取：新出现的枪声一冒头就判定，开着替换就当场换掉 ----------
local function sndWatch(o)
	if not o:IsA("Sound") then return end
	pcall(function()
		o:GetPropertyChangedSignal("Playing"):Connect(function()
			if not o.Playing then return end
			if o.IsLoaded and not looksGun(o) then pcall(sndPoolAdd, o.Name, o.SoundId) end
			pcall(sndOne, o)
		end)
	end)
	pcall(sndOne, o)
end
pcall(function() workspace.DescendantAdded:Connect(sndWatch) end)
for _, o in ipairs(workspace:GetDescendants()) do pcall(sndWatch, o) end
-- 本地播放通道（有些枪声走 SoundService:PlayLocalSound，不落在 workspace 里）
pcall(function()
	local SS = game:GetService("SoundService")
	if hookfunction then
		local old = SS.PlayLocalSound
		hookfunction(old, function(snd, ...)
			pcall(sndOne, snd)
			return old(snd, ...)
		end)
	else
		local old = SS.PlayLocalSound
		SS.PlayLocalSound = function(snd, ...)
			pcall(sndOne, snd)
			return old(snd, ...)
		end
	end
end)

-- 开关行
local sndRow = B("TextButton",{Size=UDim2.new(1,0,0,30),Position=UDim2.fromOffset(0,ySh.v),BackgroundColor3=C.row,BorderSizePixel=0,Text="",AutoButtonColor=false,ZIndex=130,Parent=bodySh})
ySh.v = ySh.v + 34
B("UIStroke",{Color=Color3.fromRGB(150,140,128),Transparency=0.4,Parent=sndRow})
B("TextLabel",{Size=UDim2.new(1,-56,1,0),Position=UDim2.fromOffset(10,0),BackgroundTransparency=1,Text="修改开枪音效",Font=Enum.Font.Gotham,TextSize=11,TextStrokeTransparency=1,TextColor3=C.txt,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=131,Parent=sndRow})
local ssw = B("Frame",{Size=UDim2.fromOffset(32,18),Position=UDim2.new(1,-42,0.5,-9),BackgroundColor3=C.off,BorderSizePixel=0,ZIndex=131,Parent=sndRow})
B("UIStroke",{Color=Color3.fromRGB(95,88,80),Transparency=0.3,Parent=ssw})
local skn = B("Frame",{Size=UDim2.fromOffset(14,14),Position=UDim2.fromOffset(2,2),BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,ZIndex=132,Parent=ssw})
sndRow.MouseButton1Click:Connect(function()
	if CFG.SndOn then
		CFG.SndOn = false
		ssw.BackgroundColor3 = C.off
		TS:Create(skn,TweenInfo.new(0.18,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Position=UDim2.fromOffset(2,2)}):Play()
		sndBack()
		mmToast("开枪音效已关闭")
		return
	end
	local it = sndCur()
	if not it then return end
	mmToast("检测音效…")
	sndTest(it.id, function(good)
		if not good then
			mmToast("这个音效加载不出来，保持原声")
			return
		end
		CFG.SndOn = true
		ssw.BackgroundColor3 = C.accent
		TS:Create(skn,TweenInfo.new(0.18,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Position=UDim2.fromOffset(16,2)}):Play()
		for _, o in ipairs(workspace:GetDescendants()) do pcall(sndOne, o) end
		tSpawn(sndScan)
		mmToast("开枪音效 · "..it.n)
	end)
end)

-- 音效选择行
local sndPick = B("TextButton",{Size=UDim2.new(1,0,0,28),Position=UDim2.fromOffset(0,ySh.v),BackgroundColor3=C.row,BorderSizePixel=0,Text="",AutoButtonColor=false,ZIndex=130,Parent=bodySh})
ySh.v = ySh.v + 32
local sndTryRow = B("TextButton",{Size=UDim2.new(1,0,0,26),Position=UDim2.fromOffset(0,ySh.v),BackgroundColor3=C.row,BorderSizePixel=0,Text="试听当前音效",Font=Enum.Font.Gotham,TextSize=11,TextStrokeTransparency=1,TextColor3=C.accent,AutoButtonColor=false,ZIndex=130,Parent=bodySh})
B("UIStroke",{Color=Color3.fromRGB(150,140,128),Transparency=0.4,Parent=sndTryRow})
sndTryRow.MouseButton1Click:Connect(function() pcall(sndPreview) end)
ySh.v = ySh.v + 30
B("UIStroke",{Color=Color3.fromRGB(150,140,128),Transparency=0.4,Parent=sndPick})
B("TextLabel",{Size=UDim2.new(1,-86,1,0),Position=UDim2.fromOffset(10,0),BackgroundTransparency=1,Text="开枪音效",Font=Enum.Font.Gotham,TextSize=11,TextStrokeTransparency=1,TextColor3=C.txt,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=131,Parent=sndPick})
local sndVal = B("TextLabel",{Size=UDim2.new(0,72,1,0),Position=UDim2.new(1,-78,0,0),BackgroundTransparency=1,Text=SNDS[CFG.SndIdx].n,Font=Enum.Font.Gotham,TextSize=11,TextStrokeTransparency=1,TextColor3=C.accent,TextXAlignment=Enum.TextXAlignment.Right,ZIndex=131,Parent=sndPick})
-- （原「自定义音效ID」输入框已按用户要求删除：填别人上传的音频基本都没权限，留着没用）
local sg2 = B("ScreenGui",{Name="mm2_sndpick",IgnoreGuiInset=true,ResetOnSpawn=false,DisplayOrder=9200,Enabled=false,Parent=SP()})
gui.Destroying:Connect(function() pcall(function() sg2:Destroy() end) end)
local sh2 = B("TextButton",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="",AutoButtonColor=false,ZIndex=1,Parent=sg2})
-- 最多露 4 项（4×30 + 间距 + 内边距），超出的靠滑动看
local bx2 = B("ScrollingFrame",{Size=UDim2.fromOffset(200,4*30+4*3+14),Position=UDim2.fromScale(0.5,0.5),AnchorPoint=Vector2.new(0.5,0.5),BackgroundColor3=C.bg,BorderSizePixel=0,Active=true,ScrollBarThickness=3,ScrollBarImageColor3=C.accent,ScrollBarImageTransparency=0.35,CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,ScrollingDirection=Enum.ScrollingDirection.Y,ElasticBehavior=Enum.ElasticBehavior.Never,ZIndex=2,Parent=sg2})
B("UIStroke",{Color=Color3.fromRGB(150,140,128),Transparency=0.3,Parent=bx2})
local lay2 = Instance.new("UIListLayout") lay2.Padding=UDim.new(0,4) lay2.SortOrder=Enum.SortOrder.LayoutOrder lay2.Parent=bx2
local pad2 = Instance.new("UIPadding") pad2.PaddingTop=UDim.new(0,7) pad2.PaddingBottom=UDim.new(0,7) pad2.PaddingLeft=UDim.new(0,7) pad2.PaddingRight=UDim.new(0,7) pad2.Parent=bx2

local buildPick = function()
	for _, o in ipairs(bx2:GetChildren()) do
		if o:IsA("TextButton") then o:Destroy() end
	end
	for i, it in ipairs(SNDS) do
		local on = (i == CFG.SndIdx)
		local b2 = B("TextButton",{Size=UDim2.new(1,0,0,30),BackgroundColor3=on and C.accent or C.row,BorderSizePixel=0,Text=it.n,Font=Enum.Font.GothamMedium,TextSize=11,TextColor3=on and Color3.new(1,1,1) or C.txt,AutoButtonColor=false,LayoutOrder=i,ZIndex=3,Parent=bx2})
		B("UIStroke",{Color=Color3.fromRGB(150,140,128),Transparency=0.45,Parent=b2})
		-- 自动体检：加载不出来的直接在列表里打个 ✕，省得一个个试
		tSpawn(function()
			sndTest(it.id,function(ok)
				if b2 and b2.Parent and not ok then
					pcall(function()
						b2.Text=it.n.."  ✕ 不可用"
						b2.TextColor3=Color3.fromRGB(150,150,150)
					end)
				end
			end)
		end)
		b2.MouseButton1Click:Connect(function()
			CFG.SndIdx = i
			sndVal.Text = it.n
			for _, o in ipairs(bx2:GetChildren()) do
				if o:IsA("TextButton") then
					local sel = (o.LayoutOrder == i)
					o.BackgroundColor3 = sel and C.accent or C.row
					o.TextColor3 = sel and Color3.new(1,1,1) or C.txt
				end
			end
			sg2.Enabled = false
			if CFG.SndOn then
				sndTest(it.id, function(good)
					if not good then
						CFG.SndOn = false
						sndBack()
						ssw.BackgroundColor3 = C.off
						TS:Create(skn,TweenInfo.new(0.15,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Position=UDim2.fromOffset(2,2)}):Play()
						mmToast(it.n.." 加载不出来，已回退原声")
						return
					end
					sndBack()
					tSpawn(sndScan)
					mmToast("开枪音效 · "..it.n)
				end)
			end
		end)
	end
end
buildPick()
sndPick.MouseButton1Click:Connect(function() buildPick() sg2.Enabled = true end)
sh2.MouseButton1Click:Connect(function() sg2.Enabled = false end)
-- 警长子弹追踪（把 Shoot Remote 的落点改成持刀者位置）已按用户要求整段删除
-- ---------- 1c. 投掷物穿墙（子弹实体）----------
-- 只留子弹：飞行中的子弹部件在本地不再和墙碰撞，穿墙照样有机会命中。
-- （飞刀那一套已按用户要求整块删除：判定盒不读客户端尺寸，改了也没用。）
local PT_WORD = {"bullet","dart","tracer","ammo"}
local function ptWord(nm)
	local l = string.lower(tostring(nm))
	for _,k in ipairs(PT_WORD) do
		if string.find(l,k,1,true) then return true end
	end
	return false
end
local function ptChain(o, fn)
	local a = o
	for _ = 1, 7 do
		if not a or a == workspace then break end
		if fn(a) then return true end
		a = a.Parent
	end
	return false
end
local function ptOn(o)
	if not o:IsA("BasePart") then return end
	if not o:IsDescendantOf(workspace) then return end
	if ptChain(o, function(a) return a:FindFirstChildOfClass("Humanoid") ~= nil end) then return end
	if CFG.PierceS and ptChain(o, function(a) return ptWord(a.Name) end) then
		o.CanCollide = false
	end
end
workspace.DescendantAdded:Connect(function(o)
	if not CFG.PierceS then return end
	pcall(ptOn, o)
end)
-- ---------- 1e. 身份监听（刀/枪刚进背包就判出身份）----------
-- Roblox 会把每个玩家的 Backpack 内容复制给所有客户端，所以"刀/枪 Tool 一出现"我们就能看到，
-- 比轮询 ESP 更早、也是客户端能拿到的最早时机（别人的身份服务端不会单独下发）。
RT.roles = RT.roles or {}
RT.watched = RT.watched or {}
RT.bound = RT.bound or {}
local function roleTag(pl, nm)
	local tag
	if nm == "Knife" then tag = "杀手"
	elseif nm == "Gun" then tag = "警长"
	else return end
	if RT.roles[pl] == tag then return end
	RT.roles[pl] = tag
	if CFG.RoleLog then mmDbg("身份 " .. pl.Name .. " = " .. tag) end
end
local function roleScan(pl, root)
	if not root then return end
	for _, c in ipairs(root:GetChildren()) do
		if c:IsA("Tool") then pcall(roleTag, pl, c.Name) end
	end
end
local function roleBind(pl, root)
	if not root then return end
	local key = tostring(pl) .. "|" .. root:GetFullName()
	if RT.bound[key] then return end
	RT.bound[key] = true
	roleScan(pl, root)
	root.ChildAdded:Connect(function(c)
		if c:IsA("Tool") then pcall(roleTag, pl, c.Name) end
	end)
end
local function roleHook(pl)
	if RT.watched[pl] then return end
	RT.watched[pl] = true
	local function onChar(ch)
		roleBind(pl, ch)
		roleBind(pl, pl:FindFirstChild("Backpack"))
	end
	onChar(pl.Character)
	pl.CharacterAdded:Connect(onChar)
	pl.ChildAdded:Connect(function(c)
		if c.Name == "Backpack" then roleBind(pl, c) end
	end)
end
for _, pl in ipairs(P:GetPlayers()) do pcall(roleHook, pl) end
P.PlayerAdded:Connect(function(pl) pcall(roleHook, pl) end)
rowButton(bodyMu, yMu, "一键击杀所有人", killAll)
rowButton(bodyMu, yMu, "击杀警长", killSheriff)
rowButton(bodyMu, yMu, "击杀最近的人", killNearest)
rowButton(bodyMu, yMu, "甩飞警长", flingSheriff)
rowToggle(bodyMu, yMu, "快速扔刀", "FastKnife", function() if CFG.FastKnife then pcall(fkAttach) end end)
-- ---------- 近战范围 ----------
-- 要求：判定盒撑大，但"自己视角里人不变形" + "自己不会被挡住"。
-- 做法：只动两个看不见的东西 ——
--   1) HumanoidRootPart（本来 Transparency 就是 1，看不见）撑成 N³；
--   2) 在他角色里塞一块全透明、不碰撞、锚定的判定块（RootHitBox），跟着躯干走。
-- 可见的 Torso / 手脚一概不动，所以人不会变大坨；所有碰撞一律 CanCollide=false，
-- 你从他身体里穿过去都行，不会再有空气墙。
-- 铁律：自己的部件绝对不碰。
local MB={ t=0, orig=setmetatable({}, {__mode="k"}), px=setmetatable({}, {__mode="k"}) }
local function mbProxy(pl, ch, follow, v)
	local px=MB.px[pl]
	if not (px and px.Parent) then
		px=Instance.new("Part")
		px.Name="RootHitBox"
		px.Transparency=1
		px.CanCollide=false
		px.CanQuery=false
		px.CanTouch=true
		px.Anchored=true
		px.Massless=true
		px.Size=v
		px.CFrame=follow.CFrame
		pcall(function() px.Parent=ch end)
		MB.px[pl]=px
	end
	px.Size=v
	px.CFrame=follow.CFrame
end
local function mbApply(force)
	if not (CFG.MeleeBox or force) then return end
	local sz=math.clamp(tonumber(CFG.MeleeSz) or 2,1,30)
	local v=Vector3.new(sz,sz,sz)
	for _,pl in ipairs(P:GetPlayers()) do
		if pl~=LP then
			local ch=pl.Character
			local hum=ch and ch:FindFirstChildOfClass("Humanoid")
			local h=ch and ch:FindFirstChild("HumanoidRootPart")
			if h and h:IsA("BasePart") and hum then
				if hum.Health<=0 then
					-- 死亡瞬间：引擎会把碰撞恢复，这时候超大盒子压在我们身上就会把人顶飞。
					-- 所以一看到血量为 0 立刻把尺寸/碰撞还原回原值。
					local o=MB.orig[h]
					if o then
						local rs=o.s
						if rs.Magnitude>4 then rs=Vector3.new(2,2,1) end
						pcall(function()
							h.Size=rs
							h.CanCollide=o.c
						end)
						MB.orig[h]=nil
					end
				else
					if not MB.orig[h] then MB.orig[h]={s=h.Size,c=h.CanCollide,t=h.CanTouch} end
					if h.Size~=v then pcall(function() h.Size=v end) end
					-- 每帧都重新压一遍碰撞，不只在改尺寸那一次，防止游戏中途把 CanCollide 打开
					if h.CanCollide then pcall(function() h.CanCollide=false end) end
					if not h.CanTouch then pcall(function() h.CanTouch=true end) end
				end
				local f=ch:FindFirstChild("Torso") or ch:FindFirstChild("UpperTorso") or h
				pcall(mbProxy, pl, ch, f, v)
			end
		end
	end
end
local function mbRestore()
	for p,o in pairs(MB.orig) do
		if p and p.Parent then
			pcall(function()
				p.Size=o.s
				p.CanCollide=o.c
				p.CanTouch=o.t
			end)
		end
		MB.orig[p]=nil
	end
	for pl,px in pairs(MB.px) do
		if px then pcall(function() px:Destroy() end) end
		MB.px[pl]=nil
	end
end
local function mbTick()
	if stale() then return end
	if not CFG.MeleeBox then MB.t=0 return end
	pcall(mbApply)
	-- 兜底：万一还是被顶了一下，速度超过 200 就直接刹住（正常走路到不了这个数）
	local _,_,r = myChar()
	if r then
		local v = r.AssemblyLinearVelocity
		if v.Magnitude > 200 then
			pcall(function()
				r.AssemblyLinearVelocity = Vector3.zero
				r.AssemblyAngularVelocity = Vector3.zero
			end)
		end
	end
end
RS.RenderStepped:Connect(mbTick)
RS.Stepped:Connect(mbTick)
P.PlayerAdded:Connect(function()
	tSpawn(function() tWait(1.2) pcall(mbApply) end)
end)
rowToggle(bodyMu, yMu, "近战范围", "MeleeBox", function(on)
	MB.t=0
	if on then pcall(mbApply, true) else pcall(mbRestore) end
end)
rowNum(bodyMu, yMu, "修改近战范围", "MeleeSz", "1-30", 1, 30, function() MB.t=0 pcall(mbApply) end)

-- ---------- 挥刀自动拉人（精准版）----------
-- 触发源只有一个：自己手里那把 Knife 的 Activated（也就是你真按了攻击的那一下）。
-- 没拿刀 / 不是杀手 / 没按攻击 —— 一个像素都不会动别人的角色。
-- 按下的瞬间把范围内最近的活人钉到你脸前 0.4 秒，覆盖这一刀的判定窗口。
local KP = { c=nil, pick=nil, untilT=0 }
local KBOUND = setmetatable({}, {__mode="k"})
local function kpAlive(pl)
	local ch = pl and pl.Character
	if not ch then return nil end
	local tr = ch:FindFirstChild("HumanoidRootPart")
	local th = ch:FindFirstChildOfClass("Humanoid")
	if tr and th and th.Health > 0 then return tr end
end
local function kpPick()
	local _,_,r = myChar()
	if not r then return nil end
	local maxd = math.clamp(tonumber(CFG.PullRange) or 20, 1, 80)
	local bd = math.huge
	for _,pl in ipairs(P:GetPlayers()) do
		if pl ~= LP then
			local tr = kpAlive(pl)
			if tr then
				local d = (tr.Position - r.Position).Magnitude
				if d <= maxd and d < bd then bd = d end
			end
		end
	end
	if bd == math.huge then return nil end
	local cand = {}
	for _,pl in ipairs(P:GetPlayers()) do
		if pl ~= LP then
			local tr = kpAlive(pl)
			if tr then
				local d = (tr.Position - r.Position).Magnitude
				if d <= maxd and d <= bd + 0.5 then cand[#cand+1] = pl end
			end
		end
	end
	if #cand == 0 then return nil end
	return cand[math.random(1, #cand)]
end
local function kpTick()
	if stale() then return end
	if not CFG.PullSlash then
		if KP.c then pcall(function() KP.c:Disconnect() end) KP.c=nil end
		return
	end
	if os.clock() > KP.untilT then
		if KP.c then pcall(function() KP.c:Disconnect() end) KP.c=nil end
		KP.pick = nil
		return
	end
	local _,_,r = myChar()
	if not r then return end
	local tr = kpAlive(KP.pick)
	if not tr then
		KP.pick = kpPick()
		tr = kpAlive(KP.pick)
		if not tr then return end
	end
	pcall(function()
		tr.CFrame = r.CFrame * CFrame.new(0, 0, -2.2)
		tr.AssemblyLinearVelocity = Vector3.zero
		tr.AssemblyAngularVelocity = Vector3.zero
	end)
end
local function kpSwing()
	if not CFG.PullSlash then return end
	if not isMurderer() then return end
	local _,_,r = myChar()
	if not r then return end
	KP.pick = kpPick()
	if not KP.pick then return end
	KP.untilT = os.clock() + 0.4
	if not KP.c then KP.c = RS.RenderStepped:Connect(function() pcall(kpTick) end) end
end
local function kpBind()
	local c = LP.Character
	local t = c and (c:FindFirstChild("Knife") or c:FindFirstChild("knife"))
	if not (t and t:IsA("Tool")) then return end
	if KBOUND[t] then return end
	KBOUND[t] = true
	t.Activated:Connect(function() pcall(kpSwing) end)
end
tSpawn(function()
	while true do
		tWait(0.4)
		if CFG.PullSlash then pcall(kpBind) end
	end
end)
rowToggle(bodyMu, yMu, "挥刀自动拉人", "PullSlash", function(on) KP.untilT = 0 if on then pcall(kpBind) end end)
rowNum(bodyMu, yMu, "拉人范围", "PullRange", "0-80", 1, 80, function() KP.pick = nil end)

-- ---------- 1d. 远程侦查（刀是怎么"命中"的）----------
-- 目的：找出 MM2 里"扔刀/命中"用的 RemoteEvent 名字与参数顺序，
-- 找到之后就能直接对着人伪造命中，而不是靠改飞行轨迹。


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
		tDelay(0.14,function() pcall(function() holder:Destroy() end) end)
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
local function hl(obj,col,on,alpha)
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
		pcall(function() h.OutlineTransparency=1-math.clamp(tonumber(alpha) or 1,0,1) end)
		h.Enabled=true
	elseif h then
		h:Destroy()
		HL[obj]=nil
	end
end
-- 不用 Highlight 画框（全局数量有限，跟玩家 ESP 抢位置会互相顶掉）。
-- BoxHandleAdornment 在 gethui() 里可能渲染不出来，所以改成挂在零件上的 BillboardGui，
-- 这条路径跟枪的距离牌是同一套，确认能显示。
local ADORN=setmetatable({},{__mode="k"})
local function boxAd(part,col,on,dist,px,alpha)
	if not part then return end
	local rec=ADORN[part]
	if (not on) or (not part.Parent) then
		if rec then pcall(function() rec.g:Destroy() end) ADORN[part]=nil end
		return
	end
	if not rec or not rec.g.Parent then
		local bg=B("BillboardGui",{Name="mm2_cbox",Size=UDim2.fromOffset(16,16),AlwaysOnTop=true,LightInfluence=0,Parent=part})
		local fr=B("Frame",{Name="F",Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Parent=bg})
		local st=B("UIStroke",{Color=col,Thickness=1.5,Parent=fr})
		local tx=B("TextLabel",{Name="T",Size=UDim2.new(1,0,0,12),Position=UDim2.new(0,0,0,-13),BackgroundTransparency=1,Text="",Font=Enum.Font.GothamBold,TextSize=9,TextColor3=col,Parent=bg})
		rec={g=bg,st=st,tx=tx}
		ADORN[part]=rec
	end
	rec.st.Color=col
	rec.tx.TextColor3=col
	do
		local a=math.clamp(tonumber(alpha) or 1,0,1)
		pcall(function() rec.st.Transparency=1-a rec.tx.TextTransparency=1-a end)
	end
	rec.tx.Text=dist and (tostring(math.floor(dist)).."m") or ""
	-- 方框按"这个零件在屏幕上实际多大"来定，正好包住金币，不会一大坨
	local s=math.clamp(tonumber(px) or 16,7,90)
	rec.g.Size=UDim2.fromOffset(s,s)
	rec.tx.Position=UDim2.new(0,0,0,-s*0.5-12)
	rec.g.Enabled=true
end
local timeGui=B("ScreenGui",{IgnoreGuiInset=true,ResetOnSpawn=false,DisplayOrder=65,Parent=SP()})
local timeLbl=B("TextLabel",{Size=UDim2.fromOffset(200,26),Position=UDim2.new(0.5,-100,0,34),BackgroundTransparency=1,Text="",Font=Enum.Font.GothamBlack,TextSize=18,TextColor3=Color3.fromRGB(255,255,255),TextStrokeTransparency=0.3,Visible=false,Parent=timeGui})
local roundEnd=0
local lastGun=false
local REALLEFT=nil local REALAT=nil local REALSTUCK=nil local PRELABEL=nil local ROUNDHOOK=nil local ROUNDLEN=180 local RSTART2=nil local TSCAN=0 local rStart=0 local wasW=false local gpT=0 local lastLookup=0 local coinCache={} local lastScan=0 local lastTp=0
local COINBAD=setmetatable({},{__mode="k"})
local function wxCoin(o)
	if not o:IsA("BasePart") then return false end
	local nm=string.lower(o.Name)
	local pnm=string.lower((o.Parent and o.Parent.Name) or "")
	return (string.find(nm,"coin") or string.find(nm,"cash") or string.find(nm,"money") or string.find(nm,"gold") or string.find(pnm,"coin"))~=nil
end
-- 判定"这是不是金币/钱"：Model 也要能判 —— 以前只判 BasePart，
-- 金币装在一个 Model 里当掉落物时就被漏过去，捡枪会把它当成枪传过去。
local COINKEY={"coin","cash","money","gold","buck","token"}
local function isCoinLike(o)
	local function nmhit(s)
		s=string.lower(tostring(s or ""))
		for i=1,#COINKEY do if string.find(s,COINKEY[i],1,true) then return true end end
		return false
	end
	if nmhit(o.Name) then return true end
	if o:IsA("BasePart") then return wxCoin(o) end
	local hit=false
	pcall(function()
		for _,d in ipairs(o:GetDescendants()) do
			if d:IsA("BasePart") and (nmhit(d.Name) or nmhit(d.Parent and d.Parent.Name)) then hit=true return end
		end
	end)
	return hit
end
for _,o in ipairs(workspace:GetDescendants()) do if wxCoin(o) then table.insert(coinCache,o) end end
workspace.DescendantAdded:Connect(function(o) if wxCoin(o) then table.insert(coinCache,o) end end)
local timerLabel=nil
local function findTimerLabel()
	local best=nil
	local function scanRoot(root)
		if not root then return end
		pcall(function()
			for _,d in ipairs(root:GetDescendants()) do
				if d:IsA("TextLabel") and d.Visible and d.Text~="" then
					local t=d.Text
					local okFmt=(string.match(t,"^%s*%d+:%d%d%s*$")~=nil)
					if okFmt then
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
								best=d
								return
							end
							local p=d.AbsolutePosition
							if p.Y<170 then
								if not best or p.Y<best.AbsolutePosition.Y then best=d end
							end
						end
					end
				end
			end
		end)
	end
	scanRoot(LP:FindFirstChild("PlayerGui"))
	if best then return best end
	local ok,h=pcall(function() return gethui and gethui() end)
	if ok and typeof(h)=="Instance" then scanRoot(h) end
	if best then return best end
	local ok2,c=pcall(function() return game:GetService("CoreGui") end)
	if ok2 and typeof(c)=="Instance" then scanRoot(c) end
	return best
end
local roundT=os.clock()
LP.CharacterAdded:Connect(function() roundT=os.clock() end)
local LN={}
local function drawLine(idx,from,to,col,on,alpha)
	local f=LN[idx]
	if not f then
		f=B("Frame",{AnchorPoint=Vector2.new(0.5,0.5),BackgroundColor3=col,BorderSizePixel=0,ZIndex=90,Parent=gui})
		LN[idx]=f
	end
	if not on then f.Visible=false return end
	local dx,dy=to.X-from.X,to.Y-from.Y
	f.Size=UDim2.new(0,math.sqrt(dx*dx+dy*dy),0,math.max(1,tonumber(ES.LineW) or 1.2))
	f.Position=UDim2.new(0,(from.X+to.X)/2,0,(from.Y+to.Y)/2)
	f.Rotation=math.deg(math.atan2(dy,dx))
	f.BackgroundColor3=col
	pcall(function() f.BackgroundTransparency=1-math.clamp(tonumber(alpha) or 1,0,1) end)
	f.Visible=true
end
local gunOn=false
local gunPts,trapPts,coinPts={},{},{}
local scanT=0
tSpawn(function()
	while tWait(0.016) do
		pcall(function()
			local sawRole=false
			local cam=workspace.CurrentCamera
			local vps=cam.ViewportSize
			-- 屏幕外目标：把终点钳到屏幕边缘，而不是甩到画布外的一个荒唐坐标
			local function edgePoint(pos)
				local rel=cam.CFrame:PointToObjectSpace(pos)
				local d=Vector2.new(rel.X,-rel.Y)
				if rel.Z>0 then d=-d end
				if d.Magnitude<1e-3 then d=Vector2.new(0,-1) end
				d=d.Unit
				local cx,cy=vps.X/2,vps.Y/2
				local hw,hh=math.max(cx-18,1),math.max(cy-18,1)
				local s=math.min(hw/math.max(math.abs(d.X),1e-4),hh/math.max(math.abs(d.Y),1e-4))
				return Vector2.new(cx+d.X*s,cy+d.Y*s)
			end
						local fromP
			if posV=="顶部" then fromP=Vector2.new(vps.X/2,0)
			elseif posV=="头部" then
				local hh=LP.Character and LP.Character:FindFirstChild("Head")
				local sp2=hh and cam:WorldToViewportPoint(hh.Position)
				fromP=sp2 and Vector2.new(sp2.X,sp2.Y) or Vector2.new(vps.X/2,0)
			else fromP=Vector2.new(vps.X/2,vps.Y) end
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
					local acol=1
					if not anyW then
						col=CLR.Civ acol=ALPHA.Civ
						hl(c,CLR.Civ,ES.Civ,ALPHA.Civ)
					elseif killerP[pl] then
						col=CLR.Killer acol=ALPHA.Killer
						hl(c,CLR.Killer,ES.Killer,ALPHA.Killer)
					elseif policeP[pl] then
						col=CLR.Police acol=ALPHA.Police
						hl(c,CLR.Police,ES.Police,ALPHA.Police)
					else
						col=CLR.Civ acol=ALPHA.Civ
						hl(c,CLR.Civ,ES.Civ,ALPHA.Civ)
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
								local ep=nil
								if onv then ep=Vector2.new(sp.X,sp.Y)
								elseif ES.OffScr then ep=edgePoint(hr.Position) end
								drawLine(li,fromP,ep or fromP,col,(ep~=nil),acol)
							else
								drawLine(li,fromP,fromP,col,false)
							end
						end
					end
				end
			end
			for i=li+1,#LN do if LN[i] then LN[i].Visible=false end end
			-- 扫枪 / 扫陷阱 / 扫金币这几段不需要每帧跑，压到大约每秒 8 次，省手机 CPU。
			-- 射线每帧都会重画，用的是上一次扫出来的坐标，所以线不会顿。
			local doScan=(os.clock()-scanT>0.12)
			if doScan then
			scanT=os.clock()
			gunOn=false
			gunPts={} trapPts={} coinPts={}
			local myHRg=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
			local gList={}
			for _,pl in ipairs(P:GetPlayers()) do
				local ch=pl.Character
			end
											local function ownerPlr(x)
							for _,pl in ipairs(P:GetPlayers()) do
								local c=pl.Character
								if c and (x==c or x:IsDescendantOf(c)) then return pl,"char" end
								local b=pl.Backpack
								if b and (x==b or x:IsDescendantOf(b)) then return pl,"bp" end
							end
							return nil
						end
					for _,o in ipairs(workspace:GetChildren()) do
				gList[#gList+1]=o
				for _,c in ipairs(o:GetChildren()) do gList[#gList+1]=c end
			end
			-- 判定"这是不是展示用的假枪"：坐姿/等待时玩家身上的枪会被复制到 WeaponDisplays / GunDisplay / GunBelt 之类
			local function isDisplayish(x)
				local n2=string.lower(tostring(x.Name))
				if string.find(n2,"display",1,true) or string.find(n2,"belt",1,true) or string.find(n2,"refgun",1,true)
					or string.find(n2,"rack",1,true) or string.find(n2,"holder",1,true) or string.find(n2,"weapondisplay",1,true) then
					return true
				end
				local q=x
				for _=1,4 do
					q=q and q.Parent
					if not q then break end
					local pn=string.lower(tostring(q.Name))
					if string.find(pn,"weapondisplay",1,true) or string.find(pn,"display",1,true) then return true end
				end
				return false
			end
			for _,o in ipairs(gList) do
				local nm=string.lower(o.Name)
																local isGun=false
								if string.find(nm,"gun") and not isDisplayish(o) then
									local owner=ownerPlr(o)
									if not owner then
										local inHum=false
										local pp=o
										for _=1,6 do
											pp=pp and pp.Parent
											if pp and pp:IsA("Model") and pp:FindFirstChildOfClass("Humanoid") then inHum=true break end
										end
										local welded=false
										for _,w in ipairs(o:GetChildren()) do
											if w:IsA("Weld") or w:IsA("WeldConstraint") or w:IsA("Motor6D") then
												local a=w.Part0 or w.Part1
												local m=a and a:FindFirstAncestorOfClass("Model")
												if m and m:FindFirstChildOfClass("Humanoid") then welded=true break end
											end
										end
										if not inHum and not welded then
											local hdT=o:FindFirstChild("Handle") or (o:IsA("BasePart") and o) or (o:IsA("Model") and o.PrimaryPart) or nil
											local pos0=hdT and hdT.Position
											local far=true
											if pos0 then
												for _,pl in ipairs(P:GetPlayers()) do
													local c=pl.Character
													local hr=c and c:FindFirstChild("HumanoidRootPart")
													if hr and (hr.Position-pos0).Magnitude<3 then far=false break end
												end
											else
												far=false
											end
											isGun=far and hdT~=nil and hdT.Transparency<0.95 and hdT.LocalTransparencyModifier<0.95
										end
									end
								end
								if isGun then
									local hd=o:FindFirstChild("Handle")
									if not hd and o:IsA("BasePart") then hd=o end
									if not hd and o:IsA("Model") then hd=o.PrimaryPart end
									gunOn=true
									if hd then gunPts[#gunPts+1]=hd end
									hl(o,CLR.Gun,ES.Gun,ALPHA.Gun)
									local bg=hd and hd:FindFirstChild("mm2_gdist")
									if ES.Gun and myHRg and hd then
										if not bg then
											bg=B("BillboardGui",{Name="mm2_gdist",Size=UDim2.fromOffset(70,18),StudsOffset=Vector3.new(0,1.8,0),AlwaysOnTop=true,Parent=hd})
											B("TextLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="",Font=Enum.Font.GothamBold,TextSize=11,TextColor3=CLR.Gun,Parent=bg})
										end
										bg.Enabled=true
										local tl=bg:FindFirstChildOfClass("TextLabel")
										if tl then
											tl.Text=math.floor((hd.Position-myHRg.Position).Magnitude).."m"
											tl.TextColor3=CLR.Gun
										end
									elseif bg then
										bg.Enabled=false
									end
					elseif (string.find(nm,"trap") or string.find(nm,"beartrap")) and not ptChain(o, function(a) return a:FindFirstChildOfClass("Humanoid") ~= nil or a:IsA("Accessory") end) then
					if ES.Trap then
						local function isBox(d)
							local n=string.lower(d.Name)
							if string.find(n,"hitbox") or string.find(n,"touch") or string.find(n,"trigger") or string.find(n,"zone") or string.find(n,"detect") or string.find(n,"region") or string.find(n,"collider") or string.find(n,"sensor") then return true end
							return false
						end
						local ps={}
						if o:IsA("BasePart") then ps[#ps+1]=o end
						for _,d in ipairs(o:GetDescendants()) do if d:IsA("BasePart") then ps[#ps+1]=d end end
						if ps[1] then trapPts[#trapPts+1]=ps[1] end
						local shown=0
						-- 夹子对非杀手是完全隐形的（只有放的人看得见），所以不能只按"原本可见"来判断。
						-- 爪子一定是 MeshPart；外面那个透明触发箱一般是普通 Part，名字还带 hitbox/touch 之类，跳过。
						for _,d in ipairs(ps) do
							pcall(function() d.CanCollide=false end)
							if not isBox(d) and (d:IsA("MeshPart") or d.Transparency<0.9) then
								pcall(function() d.Transparency=0 d.LocalTransparencyModifier=0 end)
								hl(d,CLR.Trap,true,ALPHA.Trap)
								shown=shown+1
							end
						end
						if shown==0 then
							for _,d in ipairs(ps) do
								if not isBox(d) then
									pcall(function() d.Transparency=0 d.LocalTransparencyModifier=0 end)
									hl(d,CLR.Trap,true,ALPHA.Trap)
									shown=shown+1
								end
							end
						end
						if shown==0 then hl(o,CLR.Trap,true,ALPHA.Trap) end
					else
						hl(o,CLR.Trap,false)
						for _,d in ipairs(o:GetDescendants()) do
							if d:IsA("BasePart") then hl(d,CLR.Trap,false) end
						end
					end
				elseif wxCoin(o) then
					-- 金币统一在下面用 coinCache 处理（跟自动收集共用同一份列表）
				end
			end
			-- 金币 ESP：直接用自动收集那边的 coinCache，能捡到的就一定能看到
			local coinReady = (os.clock()-(SCRIPT_T0 or 0))>10   -- 开局 10 秒内不画：那批是还没刷出来的占位金币
			if ES.Coin and coinReady then
				local myP=myHRg and myHRg.Position
				local camC=workspace.CurrentCamera
				local vhC=camC and camC.ViewportSize.Y or 720
				local tanHalf=math.tan(math.rad((camC and camC.FieldOfView or 70))*0.5)
				for i=#coinCache,1,-1 do
					local co=coinCache[i]
					if not co or not co.Parent then
						table.remove(coinCache,i)
					else
						local pb=co:IsA("BasePart") and co or co.PrimaryPart or co:FindFirstChildWhichIsA("BasePart")
						-- 全透明的（占位/还没激活的）不画
						if pb and (pb.Transparency or 0) < 0.95 and not (COINDONE and COINDONE[co]) then
							local dd=myP and (pb.Position-myP).Magnitude or nil
							local rng=tonumber(ES.CoinRange) or 50
							if (not dd) or dd<=rng then
								-- 屏幕像素尺寸 = 世界尺寸 × 视口高 / (2 × 距离 × tan(fov/2))
								local px=16
								if camC then
									local distC=(camC.CFrame.Position-pb.Position).Magnitude
									if distC<0.1 then distC=0.1 end
									local ws=math.max(pb.Size.X,pb.Size.Y,pb.Size.Z)*0.6
									px=(ws*vhC)/(2*distC*tanHalf)
								end
								boxAd(pb,CLR.Coin,true,dd,px,ALPHA.Coin)
								coinPts[#coinPts+1]=pb
							else
								-- 超出范围：框收掉，也不进射线列表
								boxAd(pb,CLR.Coin,false)
							end
						elseif pb then
							boxAd(pb,CLR.Coin,false)
						end
					end
				end
			else
				for p,rec in pairs(ADORN) do
					pcall(function() rec.g:Destroy() end)
					ADORN[p]=nil
				end
			end
			end

			-- 陷阱 / 枪 的专用射线：位置跟上面的「射线位置」走，开关跟各自的 ESP 绑定
			do
				local function rayTo(part,col,alpha)
					if not part or not part.Parent then return end
					li=li+1
					local sp,onv=cam:WorldToViewportPoint(part.Position)
					local ep=nil
					if onv then ep=Vector2.new(sp.X,sp.Y)
					elseif ES.OffScr then ep=edgePoint(part.Position) end
					drawLine(li,fromP,ep or fromP,col,(ep~=nil),alpha)
				end
				if ES.Trap and ES.TrapLine then
					for i=1,#trapPts do rayTo(trapPts[i],CLR.Trap,ALPHA.Trap) end
				end
				if ES.Gun and ES.GunLine then
					for i=1,#gunPts do rayTo(gunPts[i],CLR.Gun,ALPHA.Gun) end
				end
				if ES.Coin and ES.CoinLine then
					for i=1,#coinPts do rayTo(coinPts[i],CLR.Coin,ALPHA.Coin) end
				end
				-- 把多余的旧线全部关掉，不留残影
				for i=li+1,#LN do if LN[i] then LN[i].Visible=false end end
			end
						if gunOn~=lastGun then gunTG=os.clock() end
			if gunOn~=lastGun and os.clock()-(gunTG or 0)>0.9 then
				lastGun=gunOn
				if ES.Gun then
					if gunOn then mmToast("枪械已出现") else mmToast("枪械已消失") end
				end
			end
			if anyW and not wasW then rStart=os.clock() _G.MM2ROUND=rStart end
			if not anyW then rStart=0 _G.MM2ROUND=0 REALLEFT=nil REALAT=nil REALSTUCK=nil end
			wasW=anyW
			if os.clock()-lastLookup>1 then
				lastLookup=os.clock()
				if not timerLabel or not timerLabel.Parent then
					timerLabel=findTimerLabel()
				else
					-- 当前标签还能用就别换（换来换去会导致数字来回跳）
					local cur=tostring(timerLabel.Text or "")
					local stillTime=(string.match(cur,"(%d+):(%d%d)")~=nil) or ((string.match(cur,"^%s*%d%d?%d?%s*$")~=nil))
					if not stillTime then timerLabel=findTimerLabel() end
				end
			end
			-- 最简单版：每 0.1 秒扫一遍所有玩家背包/身上，谁有 Knife 或 Gun 就算回合开始
			-- 有 → 从 3:00 开始递减；全都没有 → 立刻归零
			if os.clock()-(TSCAN or 0) > 0.1 then
				TSCAN = os.clock()
				local has=false
				for _,p2 in ipairs(P:GetPlayers()) do
					local bp=p2:FindFirstChild("Backpack")
					local ch=p2.Character
					if (bp and (bp:FindFirstChild("Knife") or bp:FindFirstChild("Gun")))
						or (ch and (ch:FindFirstChild("Knife") or ch:FindFirstChild("Gun"))) then
						has=true
						break
					end
				end
				if has then
					if not RSTART2 then RSTART2=os.clock() end
				else
					RSTART2=nil
				end
			end
			local txt="0:00"
			if RSTART2 then
				local left=math.max(0,math.ceil(180-(os.clock()-RSTART2)))
				txt=string.format("%d:%02d",math.floor(left/60),left%60)
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
local AU={Coin=false,GunPick=false,Crazy=false}
-- 掉落物关键词：捡枪认的就是这些词（原来写死只认 "gun"，枪要是叫别的名字就永远找不到）
CFG.GunKeys = CFG.GunKeys or "gun,knife,weapon,fusil,pompe,pistol,revolver,sheriff,colt,deagle,rifle,smg,sniper,beretta,firearm"
function gunKeyHit(nm)
	local s=string.lower(tostring(nm or ""))
	for k in string.gmatch(string.lower(tostring(CFG.GunKeys or "gun")),"([^,，%s]+)") do
		if k~="" and string.find(s,k,1,true) then return true end
	end
	return false
end
--==== 自动传送捡枪（新版 v2）====
-- 掉落枪的真实结构：枪外面套了一个白色透明碰撞箱，玩家碰到那个箱子才触发拾取。
-- 所以：① 候选要按"箱子/容器"来找，不能只看枪本身 ② 触碰必须打在箱子那个零件上，
-- 打枪的 Handle 是没用的 ③ 拾取成功的判据是"背包/身上的 Tool 数量变多"，不是名字匹配。
do
	local GUNKEY={"gun","fusil","pompe","shotgun","枪","pistol","revolver","deagle","rifle","smg","sniper","beretta","sheriff","colt","firearm","weapon","drop"}
	local function sub(s)
		local x=string.lower(tostring(s))
		for i=1,#GUNKEY do if string.find(x,GUNKEY[i],1,true) then return true end end
		return false
	end
	local POOL=setmetatable({},{__mode="k"})
	local BAD=setmetatable({},{__mode="k"})
	local nxt=0

	local function rootOf()
		local c=LP.Character
		return c and c:FindFirstChild("HumanoidRootPart"), c
	end
	local function toolCount()
		local n=0
		local c=LP.Character
		if c then for _,o in ipairs(c:GetChildren()) do if o:IsA("Tool") then n=n+1 end end end
		local bp=LP.Backpack
		if bp then for _,o in ipairs(bp:GetChildren()) do if o:IsA("Tool") then n=n+1 end end end
		return n
	end
	local function partsOf(o)
		local list={}
		if o:IsA("BasePart") then list[#list+1]=o end
		pcall(function()
			for _,d in ipairs(o:GetDescendants()) do
				if d:IsA("BasePart") then list[#list+1]=d end
				if #list>=12 then break end
			end
		end)
		return list
	end
	local function centerOf(o,ps)
		if o:IsA("BasePart") then return o.Position end
		local ok,p=pcall(function() return o:GetPivot().Position end)
		if ok and p then return p end
		if ps and ps[1] and ps[1].Parent then return ps[1].Position end
		return nil
	end
	local function onPlayer(par)
		if not par then return false end
		local function alive(pl)
			local ch=pl.Character
			if not ch then return false end
			local hu=ch:FindFirstChildOfClass("Humanoid")
			if not hu then return false end
			return hu.Health>0
		end
		local p0=P:GetPlayerFromCharacter(par)
		-- 关键：尸体旁边掉的枪，父级还是那个玩家（已死）。死人身上的东西不能算"别人拿着"
		if p0 then return alive(p0) end
		for _,pl in ipairs(P:GetPlayers()) do
			if pl.Backpack==par then return alive(pl) end
			local ch=pl.Character
			if ch and (par==ch or par:IsDescendantOf(ch)) then return alive(pl) end
		end
		return false
	end
	local function feed(par,depth)
		for _,o in ipairs(par:GetChildren()) do
			if (o:IsA("Tool") or o:IsA("Model") or o:IsA("BasePart")) and sub(o.Name) then POOL[o]=true end
			if (o:IsA("Model") or o:IsA("Tool")) and not POOL[o] then
				for _,d in ipairs(o:GetChildren()) do
					if sub(d.Name) then POOL[o]=true break end
				end
			end
			if depth<2 and (o:IsA("Folder") or o:IsA("Model")) then feed(o,depth+1) end
		end
	end

	tSpawn(function()
		feed(workspace,0)
		pcall(function()
			workspace.DescendantAdded:Connect(function(o)
				if not sub(o.Name) then return end
				if o:IsA("Tool") or o:IsA("Model") or o:IsA("BasePart") then POOL[o]=true end
				local p=o
				for _=1,4 do
					p=p.Parent
					if not p or p==workspace then break end
					if p:IsA("Tool") or p:IsA("Model") or p:IsA("BasePart") then POOL[p]=true end
				end
			end)
		end)
		while gui.Parent do
			tWait(0.1)
					if (not _G.MM2SNATCH) and (AU.GunPick or (PICKREQ and os.clock()-PICKREQ<3)) then
				-- 兜底识别：名字里没有 gun 的掉落物也要能抓到
				-- 特征 = 一个小模型，既有"透明(>=0.6)且 CanTouch"的碰撞箱，又有实心可见部件
				GWNEXT=GWNEXT or 0
				if os.clock()>=GWNEXT then
					GWNEXT=os.clock()+1.0
					pcall(function()
						for _,o in ipairs(workspace:GetChildren()) do
							if (o:IsA("Model") or o:IsA("Tool")) and not POOL[o] then
								local nvis,nbox,tot=0,0,0
								for _,d in ipairs(o:GetDescendants()) do
									tot=tot+1
									if tot>40 then break end
									if d:IsA("BasePart") then
										if d.Transparency>=0.6 then
											if d.CanTouch then nbox=nbox+1 end
										else
											nvis=nvis+1
										end
									end
								end
								if nvis>0 and nbox>0 and tot<=14 then POOL[o]=true end
							end
						end
					end)
				end
				local now=os.clock()
				local forced=(PICKREQ and now-PICKREQ<3) and true or false
				if forced or (now>=nxt and now-(TPBusy or 0)>=1.0 and now>=(COINLOCK or 0)) then
					local r=rootOf()
					if r then
						local n0=toolCount()
							-- ==== 简化识别（按游戏规则）====
							-- 这游戏地上的掉落物只有两种：枪 和 金币，而且枪同时最多只有一把。
							-- 规则：把所有"像掉落物"的东西找出来 → 恰好 1 个才当成枪；2 个及以上一律当金币，不动。
							local cands={}
							local gList={}
							for _,o in ipairs(workspace:GetChildren()) do
								gList[#gList+1]=o
								for _,c in ipairs(o:GetChildren()) do gList[#gList+1]=c end
							end
							for i=1,#gList do
								local o=gList[i]
								if not isCoinLike(o) then
									local own=false
									for _,pl in ipairs(P:GetPlayers()) do
										local c=pl.Character
										local b=pl.Backpack
										if (c and (o==c or o:IsDescendantOf(c))) or (b and (o==b or o:IsDescendantOf(b))) then own=true break end
									end
									if not own and not (o:IsA("Model") and o:FindFirstChildOfClass("Humanoid")) then
										local h=o:FindFirstChild("Handle") or (o:IsA("BasePart") and o) or (o:IsA("Model") and o.PrimaryPart)
										if h then
											local sz=h.Size
											if math.max(sz.X,sz.Y,sz.Z)<=10 then
												local nvis,nbox,tot=0,0,0
												for _,d in ipairs(o:GetDescendants()) do
													tot=tot+1
													if tot>30 then break end
													if d:IsA("BasePart") then
														if d.Transparency>=0.5 then
															if d.CanTouch then nbox=nbox+1 end
														else
															nvis=nvis+1
														end
													end
												end
												if nvis>0 and nbox>0 and tot<=16 then
													cands[#cands+1]={o=o,h=h}
												end
											end
										end
									end
								end
							end
							local go,bpts=nil,nil
							if #cands==1 then
								local c1=cands[1]
								if not (GUNTRY and GUNTRY[c1.o] and (os.clock()-GUNTRY[c1.o])<8) and not (BAD[c1.o] and os.clock()-BAD[c1.o]<6) then
									go=c1.o
									bpts={c1.h}
									for _,dp in ipairs(partsOf(c1.o)) do
										if dp~=c1.h and #bpts<12 then bpts[#bpts+1]=dp end
									end
								end
							end
						if go and bpts then
							pcall(function() mmToast("捡枪 · "..tostring(go.Name)) end)
							PICKREQ=nil
							nxt=now+1.6
							GUNTRY=GUNTRY or setmetatable({},{__mode="k"})
							GUNTRY[go]=os.clock()
							local origin=r.CFrame
							local c0=bpts[1] and bpts[1].Position or centerOf(go,bpts)
							if c0 then r.CFrame=CFrame.new(c0) end
							tSpawn(function()
								local got=false
								for i=1,10 do
									if not go.Parent then got=true break end
									if toolCount()>n0 then got=true break end
									local cc=LP.Character
									local rr=cc and cc:FindFirstChild("HumanoidRootPart")
									if not rr then break end
									for _,pp in ipairs(bpts) do
										if pp.Parent and pp.CanTouch~=false and firetouchinterest then
											pcall(firetouchinterest,pp,rr,0)
											pcall(firetouchinterest,pp,rr,1)
										end
									end
									for _,d in ipairs(go:GetChildren()) do
										if d:IsA("ProximityPrompt") then
											pcall(function() d.Enabled=true d.MaxActivationDistance=math.max(tonumber(d.MaxActivationDistance) or 10,16) end)
											pcall(function() d:InputHoldBegin() d:InputHoldEnd() end)
										end
									end
									tWait(0.07)
								end
								if not got then BAD[go]=os.clock() end
								if not got then BAD[go]=os.clock() pcall(function() mmToast("没捡到 · "..tostring(go.Name)) end) end
								local r2=c2 and c2:FindFirstChild("HumanoidRootPart")
								if r2 and not (AU.Coin or AU.Crazy) then pcall(function() r2.CFrame=origin end) end
							end)
						end
					end
				end
			else
				nxt=0
			end
		end
	end)
end
autoBtn=B("TextButton",{Size=UDim2.new(1,0,0,26),BackgroundColor3=C.row,BorderSizePixel=0,Text="自动",Font=Enum.Font.GothamMedium,TextSize=10,TextColor3=C.txt,AutoButtonColor=false,LayoutOrder=4,ZIndex=301,Parent=side})
bodyAuto=B("ScrollingFrame",{Size=UDim2.new(1,-84,1,-44),Position=UDim2.fromOffset(80,38),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=2,ScrollBarImageColor3=C.off,CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,ScrollingDirection=Enum.ScrollingDirection.Y,ZIndex=108,Visible=false,Parent=pn})
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
mkToggle2("疯狂收集金币模式（容易被踢）","Crazy")
-- 两个模式中间的小字提示
;(function()
	local wr=B("Frame",{Size=UDim2.new(1,0,0,16),Position=UDim2.fromOffset(0,ay),BackgroundTransparency=1,ZIndex=130,Parent=bodyAuto})
	B("TextLabel",{Size=UDim2.new(1,0,1,0),Position=UDim2.fromOffset(10,0),BackgroundTransparency=1,Text="别和下面的一起开，会冲突",Font=Enum.Font.Gotham,TextSize=9,TextStrokeTransparency=1,TextColor3=C.dim,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=131,Parent=wr})
	ay=ay+18
end)()
mkToggle2("自动拾取金币","Coin")
-- 金币收集速度（个/秒）：跟着自动拾取走，调高更快但更容易被服务器判定异常踢人
ES.CoinRate=2.0
;(function()
	local sRow=B("TextButton",{Size=UDim2.new(1,0,0,28),Position=UDim2.fromOffset(0,ay),BackgroundColor3=C.row,BorderSizePixel=0,Text="",AutoButtonColor=false,ZIndex=130,Parent=bodyAuto})
	B("UIStroke",{Color=Color3.fromRGB(150,140,128),Transparency=0.4,Parent=sRow})
	B("TextLabel",{Size=UDim2.new(1,-92,1,0),Position=UDim2.fromOffset(10,0),BackgroundTransparency=1,Text="金币收集速度",Font=Enum.Font.GothamMedium,TextSize=11,TextColor3=C.txt,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=131,Parent=sRow})
	local sVal=B("TextLabel",{Size=UDim2.new(0,58,1,0),Position=UDim2.new(1,-62,0,0),BackgroundTransparency=1,Text=string.format("%.1f/秒",ES.CoinRate),Font=Enum.Font.GothamMedium,TextSize=11,TextColor3=C.accent,TextXAlignment=Enum.TextXAlignment.Right,ZIndex=131,Parent=sRow})
	ay=ay+32
	local sTrk=B("TextButton",{Size=UDim2.new(1,-20,0,14),Position=UDim2.fromOffset(10,ay),BackgroundColor3=C.off,BorderSizePixel=0,Text="",AutoButtonColor=false,ZIndex=130,Parent=bodyAuto})
	B("UIStroke",{Color=Color3.fromRGB(95,88,80),Transparency=0.35,Parent=sTrk})
	local sFill=B("Frame",{Size=UDim2.new(0,0,1,0),BackgroundColor3=C.accent,BorderSizePixel=0,ZIndex=131,Parent=sTrk})
	local sGrip=B("Frame",{Size=UDim2.fromOffset(16,16),AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(0,0,0.5,0),BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,ZIndex=132,Parent=sTrk})
	local mnR,mxR=0.3,8
	local function setR(v)
		local w=math.clamp(tonumber(v) or 2,mnR,mxR)
		ES.CoinRate=w
		local f=(w-mnR)/(mxR-mnR)
		sFill.Size=UDim2.fromScale(f,1)
		sGrip.Position=UDim2.fromScale(f,0.5)
		sVal.Text=string.format("%.1f/秒",w)
	end
	local dragR=false
	local function fromXR(x)
		local ax=sTrk.AbsolutePosition.X
		local aw=math.max(sTrk.AbsoluteSize.X,1)
		setR(mnR+math.clamp((x-ax)/aw,0,1)*(mxR-mnR))
	end
	sTrk.InputBegan:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragR=true fromXR(i.Position.X) end
	end)
	local UISr=game:GetService("UserInputService")
	UISr.InputChanged:Connect(function(i)
		if dragR and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then fromXR(i.Position.X) end
	end)
	UISr.InputEnded:Connect(function() dragR=false end)
	setR(ES.CoinRate)
	ay=ay+20
	local hint=B("TextLabel",{Size=UDim2.new(1,0,0,14),Position=UDim2.fromOffset(10,ay),BackgroundTransparency=1,Text="速度越高，每 5 个的停顿越短；越快越容易被踢，被踢就往左调",Font=Enum.Font.GothamMedium,TextSize=9,TextColor3=C.dim,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=131,Parent=bodyAuto})
	ay=ay+18
end)()
mkToggle2("自动传送捡枪","GunPick")

--==== 瞬移捡枪 v3：检测到掉落判定盒 → 0.1 秒内瞬移过去 → 触发触碰 → 立刻回原位 ====
-- 依据抓包：掉落枪的判定盒叫 GunDrop（1x1x1、CanTouch=true、锚定、带 TouchTransmitter），
-- 刀掉出来叫 KnifeDrop。碰到它才算捡到，碰枪身没用。
_G.MM2SNATCH = true
do
	local busy = false
	local function myCharR()
		local c = LP.Character
		return c, c and (c:FindFirstChild("HumanoidRootPart") or c.PrimaryPart)
	end
	local function isDropPart(o)
		if not o or not o:IsA("BasePart") then return false end
		local n = string.lower(tostring(o.Name))
		if n == "gundrop" or n == "knifedrop" then return true end
		if string.find(n, "drop", 1, true) and o.CanTouch then return true end
		return false
	end
	local function onPlayer(o)
		local p2 = o.Parent
		if not p2 then return false end
		for _, pl in ipairs(P:GetPlayers()) do
			local pc = pl.Character
			if pc and (p2 == pc or p2:IsDescendantOf(pc)) then return true end
		end
		return false
	end
	local function findDrop()
		local _, r = myCharR()
		if not r then return nil end
		local best, bd = nil, 1e9
		local function scan(par, depth)
			if depth > 3 then return end
			local ok, kids = pcall(function() return par:GetChildren() end)
			if not ok then return end
			for _, o in ipairs(kids) do
				if isDropPart(o) then
					if not onPlayer(o) then
						local d = 0
						pcall(function() d = (o.Position - r.Position).Magnitude end)
						if d < bd then bd = d best = o end
					end
				elseif o:IsA("Folder") or o:IsA("Model") then
					scan(o, depth + 1)
				end
			end
		end
		scan(workspace, 0)
		return best
	end
	local function snatch(part)
		if busy then return end
		busy = true
		tSpawn(function()
			local c, r = myCharR()
			if not (r and part and part.Parent) then busy = false return end
			local back = r.CFrame
			local parts = {}
			for _, bp in ipairs(c:GetDescendants()) do
				if bp:IsA("BasePart") then parts[#parts + 1] = bp end
			end
			pcall(function() r.CFrame = CFrame.new(part.Position) end)
			for _ = 1, 6 do
				for i = 1, #parts do
					local bp = parts[i]
					if bp and bp.Parent and firetouchinterest then
						pcall(firetouchinterest, part, bp, 0)
						pcall(firetouchinterest, part, bp, 1)
					end
				end
				tWait()
			end
			local _, r2 = myCharR()
			if r2 then pcall(function() r2.CFrame = back end) end
			busy = false
		end)
	end
	tSpawn(function()
		while true do
			tWait(0.1)
			if AU.GunPick or (PICKREQ and os.clock() - PICKREQ < 3) then
				local part = findDrop()
				if part then
					snatch(part)
					-- 手动点「捡枪」只来回传送一次，不再重复
					if (not AU.GunPick) and PICKREQ then PICKREQ = nil end
					tWait(0.4)
				else
					if (not AU.GunPick) and PICKREQ then PICKREQ = nil end
				end
			end
		end
	end)
end

-- 一次性捡枪：点一下才捡一次（走的是同一套识别/触碰逻辑，只是不常驻）
local function mkBtn2(name,cb)
	local row=B("TextButton",{Size=UDim2.new(1,0,0,30),Position=UDim2.fromOffset(0,ay),BackgroundColor3=C.row,BorderSizePixel=0,Text="",AutoButtonColor=false,ZIndex=130,Parent=bodyAuto})
	ay=ay+34
	B("UIStroke",{Color=Color3.fromRGB(150,140,128),Transparency=0.4,Parent=row})
	B("TextLabel",{Size=UDim2.new(1,-16,1,0),Position=UDim2.fromOffset(10,0),BackgroundTransparency=1,Text=name,Font=Enum.Font.GothamMedium,TextSize=11,TextColor3=C.txt,TextXAlignment=Enum.TextXAlignment.Center,ZIndex=131,Parent=row})
	row.MouseButton1Click:Connect(function() if cb then pcall(cb) end end)
	return row
end
mkBtn2("捡枪", function() PICKREQ=os.clock() local t0=PICKREQ tDelay(1.5,function() if PICKREQ==t0 then pcall(function() mmToast("没找到掉落枪") end) end end) end)
tSpawn(function()
	while true do
		tWait(0.05)
		local ch=LP.Character
		local hr=ch and ch:FindFirstChild("HumanoidRootPart")
		if hr then
			if false and AU.Crazy then
				--==== 疯狂收集（老版本那套最快的：0.08 秒一个 + 全身每个零件都补 touch）====
				-- 这个就是当初被服务器踢的那套，速度最快、也最容易被判定，别跟下面的普通模式一起开
				pcall(function()
					local now=os.clock()
					for i=#coinCache,1,-1 do
						local c=coinCache[i]
						if not c or not c.Parent then table.remove(coinCache,i) end
					end
					if now-(lastTpC or 0)>=0.08 and #coinCache>0 and os.clock()>=(GUNLOCK or 0) then
						local best,bi,bd=nil,nil,300
						for i,o in ipairs(coinCache) do
							if o.Parent and not (COINDONE and COINDONE[o]) then
								local d=(o.Position-hr.Position).Magnitude
								if d<bd then bd=d best=o bi=i end
							end
						end
						if best then
							lastTpC=now
							COINDONE=COINDONE or setmetatable({},{__mode="k"})
							COINDONE[best]=true
							if bi then table.remove(coinCache,bi) end
							hr.CFrame=CFrame.new(best.Position)
							pcall(function()
								if firetouchinterest then
									local cc=LP.Character
									if cc then
										for _,bp in ipairs(cc:GetDescendants()) do
											if bp:IsA("BasePart") and bp.Parent then
												firetouchinterest(best,bp,0) firetouchinterest(best,bp,1)
											end
										end
									end
								end
							end)
						end
					end
				end)
			end
			if AU.Coin and not AU.Crazy then
				pcall(function()
					local now=os.clock()
					-- 开局 10 秒内金币还没真正刷出来：这时候满地图乱传送只会白送踢人，直接不动
					local rt=tonumber(_G.MM2ROUND) or 0
					if rt<=0 or (now-rt)<10 then return end
					for i=#coinCache,1,-1 do
						local c=coinCache[i]
						if not c or not c.Parent then table.remove(coinCache,i) end
					end
					-- 节奏闸门：按「金币收集速度」算下一次的间隔，抖动能打散固定节拍
					if COINNEXT and now<COINNEXT then return end
					if COINREST and now<COINREST then return end
					if now-lastTp>=0.08 and #coinCache>0 and (os.clock()-(TPBusy or 0)>1.6) and os.clock()>=(GUNLOCK or 0) then
						local best,bi,bd=nil,nil,300
						for i,o in ipairs(coinCache) do
							if o.Parent and not (COINBAD[o] and (os.clock()-COINBAD[o])<0.8) then
								-- 已经被吃掉、正在"飘上天消失"的金币不要再碰：它们通常已经不受碰撞也能被扫到
								if not (COINDONE and COINDONE[o]) then
									local d=(o.Position-hr.Position).Magnitude
									if d<bd then bd=d best=o bi=i end
								end
							end
						end
						if best then
							lastTp=now
							-- 速度换算成间隔，±35% 随机抖动；每捡 5~7 个强制歇 1~2.6 秒
							local rate=math.clamp(tonumber(ES.CoinRate) or 2,0.3,8)
							COINNEXT=now+(1/rate)*(0.65+math.random()*0.7)
							COINCNT=(COINCNT or 0)+1
							if COINCNT>=4 then
								-- 每吃满 4 个就停下来歇一会儿（5 个一歇太激进，容易被踢）
								COINCNT=0
								-- 停顿时长跟着速度走：速度调高，歇得也短；否则 5 个一歇就把滑条的效果全吃掉了
								local restBase=math.clamp(7.0-rate*0.75,1.0,6.0)
								COINREST=now+restBase*(0.85+math.random()*0.3)
							end
							-- 关键：捡起来就直接从候选里摘掉，别等它播上升动画。
							-- 否则这 0.5 秒里扫描还会扫到它，人就被反复传送过去。
							COINDONE=COINDONE or setmetatable({},{__mode="k"})
							COINDONE[best]=true
							if bi then table.remove(coinCache,bi) end
							-- 落在金币本体上，不是悬在头顶
							hr.CFrame=CFrame.new(best.Position)
							-- 主动补一次触碰，省掉“站在原地等服务器结算”的那几秒
							-- 只对 HumanoidRootPart 补一次触碰。全身每个零件都打 touch 是明显的异常行为
							pcall(function()
								if firetouchinterest then
									local cc=LP.Character
									local rp=cc and cc:FindFirstChild("HumanoidRootPart")
									if rp then firetouchinterest(best,rp,0) firetouchinterest(best,rp,1) end
								end
							end)
						end
					end
				end)
			end
			if false and AU.GunPick then -- 旧版捡枪已停用（每次递归扫全地图导致巨卡），新实现在文件末尾
				pcall(function()
					local GUNKEY={"gun","fusil","pompe","shotgun","枪","pistol","revolver","deagle","rifle","smg","sniper","beretta","sheriff","colt","firearm","weapon","drop"}
					local function sub(s) local x=string.lower(tostring(s)) for i=1,#GUNKEY do if string.find(x,GUNKEY[i],1,true) then return true end end return false end
					local function isGunObj(o) if sub(o.Name) then return true end local ok,c=pcall(function() return o:FindFirstChild("ClientFusil",true) end) return ok and c~=nil end
					GWSnap=true
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
							-- 抓包确认：掉落枪的判定盒名字就叫 GunDrop（1x1x1、CanTouch=true、锚定、挂 TouchTransmitter）
							-- 刀掉出来多半叫 KnifeDrop，一起认。这是最可靠的一条路，优先于按名字猜。
							local nmx=string.lower(tostring(o.Name))
							if o:IsA("BasePart") and (nmx=="gundrop" or nmx=="knifedrop") and not GWBAD[o] then
								local par3=o.Parent
								local onPx=false
								if par3 then
									for _,pl in ipairs(P:GetPlayers()) do
										local pc3=pl.Character
										if pc3 and (par3==pc3 or par3:IsDescendantOf(pc3)) then onPx=true break end
									end
								end
								if not onPx then
									found={o=o,p=o}
									return true
								end
							end
							if (o:IsA("Tool") or o:IsA("Model")) and isGunObj(o) and not GWBAD[o] then
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
									if hb and hb.Transparency<0.95 and hb.LocalTransparencyModifier<0.95 then
										found={o=o,p=hb}
										return true
									end
								end
							end
							if (o:IsA("Folder") or o:IsA("Model")) and look(o) then return true end
						end
					end
					look(workspace)
					if not found then if os.clock()-(GPSay or 0)>60 then GPSay=os.clock() mmDbg("[捡枪] 未识别到掉落枪") end return end

					gpT=os.clock()
					local origin=hr.CFrame
					local go=found.o
					local gp=found.p TPBusy=os.clock() pcall(function() mmDbg("[捡枪] "..tostring(go.Name).." 距离"..tostring(math.floor((gp.Position-hr.Position).Magnitude)).."格") hr.CFrame=CFrame.new(gp.Position) end)

					tSpawn(function()
						for _,d in ipairs(go:GetDescendants()) do
							if d:IsA("ProximityPrompt") then
								pcall(function() d.Enabled=true d:InputHoldBegin() tWait((d.HoldDuration or 0)+0.15) d:InputHoldEnd() end)
							end
						end
						local parts={} local t0=os.clock() pcall(function() local ccx=LP.Character if ccx then for _,bp in ipairs(ccx:GetDescendants()) do if bp:IsA("BasePart") then parts[#parts+1]=bp end end end end) while os.clock()-t0<1.2 and gp and gp.Parent and not isHeldVis() do for i=1,#parts do local bp=parts[i] if bp and bp.Parent and firetouchinterest then pcall(firetouchinterest,gp,bp,0) pcall(firetouchinterest,gp,bp,1) end end for _,d in ipairs(go:GetDescendants()) do if d:IsA("ProximityPrompt") then pcall(function() d.Enabled=true d:InputHoldBegin() end) end end tWait(0.05) end
						if not isHeldVis() then local cc2=LP.Character local rr3=nil end
						if not isHeldVis() then GWBAD[go]=true pcall(function() mmDbg("[捡枪] 失败 "..tostring(go.Name).." 距离"..tostring(math.floor((gp.Position-hr.Position).Magnitude)).."格") end) end
						local c2=LP.Character
						local r2=c2 and (c2:FindFirstChild("HumanoidRootPart") or c2:FindFirstChild("Torso"))
								if r2 and not (AU.Coin or AU.Crazy) then pcall(function() r2.CFrame=origin end) end
					end)
				end)
			end
		end
	end
end)

--==== 疯狂收集 · 每帧一个（比 20Hz 主循环快 3 倍，但仍然每帧只动一次，稳）=====
do
	local done=false
	tSpawn(function()
		while true do
			local ok,err=pcall(function()
				tWait()
				if not AU.Crazy then return end
				local ch=LP.Character
				local hr=ch and ch:FindFirstChild("HumanoidRootPart")
				if not hr then return end
				if os.clock()<(GUNLOCK or 0) then return end
				for i=#coinCache,1,-1 do
					local c=coinCache[i]
					if not c or not c.Parent then table.remove(coinCache,i) end
				end
				local best,bi,bd=nil,nil,400
				for i,o in ipairs(coinCache) do
					if o.Parent and not (COINDONE and COINDONE[o]) then
						local d=(o.Position-hr.Position).Magnitude
						if d<bd then bd=d best=o bi=i end
					end
				end
				if not best then return end
				COINDONE=COINDONE or setmetatable({},{__mode="k"})
				COINDONE[best]=true
				if bi then table.remove(coinCache,bi) end
				hr.CFrame=CFrame.new(best.Position)
				if firetouchinterest then
					local cc=LP.Character
					local rp=cc and cc:FindFirstChild("HumanoidRootPart")
					if rp then
						pcall(firetouchinterest,best,rp,0)
						pcall(firetouchinterest,best,rp,1)
					end
				end
			end)
			if not ok and not done then
				done=true
				-- 出错只提示一次，别刷屏
				pcall(function() mmToast("疯狂收集出错: "..tostring(err)) end)
			end
		end
	end)
end
