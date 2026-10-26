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
B("TextLabel",{Size=UDim2.new(1,-70,1,0),Position=UDim2.fromOffset(14,0),BackgroundTransparency=1,Text="MM2 · LLL",Font=Enum.Font.GothamBold,TextSize=13,TextColor3=C.accent,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=12,Parent=bar})
local close=B("TextButton",{Size=UDim2.fromOffset(30,30),Position=UDim2.new(1,-34,0.5,0),AnchorPoint=Vector2.new(0,0.5),BackgroundTransparency=1,Text="×",Font=Enum.Font.GothamBold,TextSize=18,TextColor3=C.dim,ZIndex=12,Parent=bar})
B("Frame",{Size=UDim2.new(1,0,0,1),Position=UDim2.fromOffset(0,32),BackgroundColor3=C.off,BackgroundTransparency=0.15,ZIndex=11,Parent=pn})
local body=B("ScrollingFrame",{Size=UDim2.new(1,-12,1,-44),Position=UDim2.fromOffset(6,38),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=2,CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,ZIndex=11,Parent=pn})
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
