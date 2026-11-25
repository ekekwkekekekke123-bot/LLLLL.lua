-- 甩飞观测器（独立脚本，不依赖 wx / mm2，不 hook 任何东西）
-- 用法：先执行本脚本 → 再执行夜脚本 → 进游戏 → 点夜脚本的「甩飞」→ 看左上角黑框
-- 它只做两件事：每帧采样自己角色的物理数值；记录窗口内新出现的部件/约束

local Players=game:GetService("Players")
local RS=game:GetService("RunService")
local LP=Players.LocalPlayer

local function SP()
	local ok,h=pcall(function() return gethui() end)
	if ok and typeof(h)=="Instance" then return h end
	local ok2,c=pcall(function() return game:GetService("CoreGui") end)
	if ok2 and typeof(c)=="Instance" then return c end
	return LP:WaitForChild("PlayerGui")
end

local LINES={}
local gui,label
local function log(s)
	s=tostring(s)
	LINES[#LINES+1]=s
	while #LINES>14 do table.remove(LINES,1) end
	if not label then
		pcall(function()
			gui=Instance.new("ScreenGui")
			gui.Name="ye_observe"
			gui.IgnoreGuiInset=true
			gui.ResetOnSpawn=false
			gui.DisplayOrder=9900
			gui.Parent=SP()
			local f=Instance.new("Frame")
			f.Size=UDim2.fromOffset(392,250)
			f.Position=UDim2.fromOffset(8,86)
			f.BackgroundColor3=Color3.fromRGB(14,14,14)
			f.BackgroundTransparency=0.12
			f.BorderSizePixel=0
			f.Parent=gui
			local st=Instance.new("UIStroke")
			st.Color=Color3.fromRGB(200,200,200)
			st.Transparency=0.35
			st.Parent=f
			label=Instance.new("TextLabel")
			label.Size=UDim2.new(1,-16,1,-12)
			label.Position=UDim2.fromOffset(8,6)
			label.BackgroundTransparency=1
			label.Font=Enum.Font.Code
			label.TextSize=11
			label.TextColor3=Color3.fromRGB(235,235,235)
			label.TextXAlignment=Enum.TextXAlignment.Left
			label.TextYAlignment=Enum.TextYAlignment.Top
			label.TextWrapped=true
			label.Parent=f
		end)
	end
	if label then label.Text=table.concat(LINES,"\n") end
end

local MAXJ,MAXA,MAXL=0,0,0
local WIN=0          -- 观测窗口剩余时间（秒）
local hrp=nil
local prevPos=nil
local newStuff={}
local lastReport=0
local clock=os.clock

local CONSTRAINT_TYPES={
	RopeConstraint=true,RodConstraint=true,AlignOrientation=true,AlignPosition=true,
	BodyAngularVelocity=true,BodyVelocity=true,BodyPosition=true,BodyGyro=true,
	WeldConstraint=true,HingeConstraint=true,VectorForce=true,LinearVelocity=true,
	AlignOrientation=true,Attachment=true
}

local function trackNew(o)
	if not o or not o.Name then return end
	local nm=o.Name
	local cls=o.ClassName
	if CONSTRAINT_TYPES[cls] then
		newStuff[#newStuff+1]=cls..":"..nm
	elseif o:IsA("BasePart") then
		if #newStuff<10 then newStuff[#newStuff+1]="Part:"..nm end
	end
end

local function report()
	local near,nv=-1,-1
	pcall(function()
		local best=1e9
		for _,pl in ipairs(Players:GetPlayers()) do
			if pl~=LP and pl.Character then
				local h=pl.Character:FindFirstChild("HumanoidRootPart")
				if h and hrp then
					local d=(h.Position-hrp.Position).Magnitude
					if d<best then
						best=d
						near=d
						nv=h.AssemblyLinearVelocity.Magnitude
					end
				end
			end
		end
	end)
	local stuff=#newStuff>0 and table.concat(newStuff,",") or "无"
	log(string.format("── 观测 #%d ──", math.floor(clock())))
	log(string.format("单帧最大位移 %.1f 格", MAXJ))
	log(string.format("角速度峰值 %.0f", MAXA))
	log(string.format("线速度峰值 %.0f", MAXL))
	log("新增: "..stuff)
	if near>=0 then log(string.format("最近玩家 距%.1f 速%.0f", near, nv)) end
	MAXJ,MAXA,MAXL=0,0,0
	newStuff={}
end

local function bind(ch)
	if not ch then return end
	hrp=ch:FindFirstChild("HumanoidRootPart")
	prevPos=hrp and hrp.Position or nil
	local ok=pcall(function()
		ch.DescendantAdded:Connect(function(d) pcall(trackNew, d) end)
	end)
	if ok then log("已挂角色: "..ch.Name) end
end

bind(LP.Character)
LP.CharacterAdded:Connect(function(ch) bind(ch) end)

pcall(function()
	workspace.DescendantAdded:Connect(function(d)
		if WIN>0 then pcall(trackNew, d) end
	end)
end)

log("甩飞观测器已就绪")
log("→ 现在去点夜脚本的「甩飞」")

local lastTick=clock()
RS.RenderStepped:Connect(function()
	local now=clock()
	local dt=now-lastTick
	lastTick=now
	if not hrp or not hrp.Parent then return end
	local p=hrp.Position
	if prevPos then
		local d=(p-prevPos).Magnitude
		if d>MAXJ then MAXJ=d end
		if d>3 and WIN<=0 then
			WIN=2.0
			newStuff={}
			log("检测到位移跳变 "..string.format("%.1f", d).." 格，开始采集")
		end
	end
	prevPos=p
	local av=hrp.AssemblyAngularVelocity
	local lv=hrp.AssemblyLinearVelocity
	if av.Magnitude>MAXA then MAXA=av.Magnitude end
	if lv.Magnitude>MAXL then MAXL=lv.Magnitude end
	if WIN>0 then
		WIN=WIN-dt
		if WIN<=0 and (now-lastReport)>1 then
			lastReport=now
			pcall(report)
		end
	end
end)
