-- 人物写入诊断（独立脚本）：检查"改自己角色位置/速度"到底能不能生效
-- 用法：执行后看左上角方框；每秒刷新一次
local Players=game:GetService("Players")
local LP=Players.LocalPlayer
local RS=game:GetService("RunService")

local function SP()
	local ok,h=pcall(function() return gethui() end)
	if ok and typeof(h)=="Instance" then return h end
	local ok2,c=pcall(function() return game:GetService("CoreGui") end)
	if ok2 and typeof(c)=="Instance" then return c end
	return LP:WaitForChild("PlayerGui")
end

local L={}
local label
local function log(s)
	L[#L+1]=tostring(s)
	while #L>16 do table.remove(L,1) end
	if not label then
		pcall(function()
			local g=Instance.new("ScreenGui")
			g.Name="wx_diag"
			g.IgnoreGuiInset=true
			g.ResetOnSpawn=false
			g.DisplayOrder=9950
			g.Parent=SP()
			local f=Instance.new("Frame")
			f.Size=UDim2.fromOffset(430,270)
			f.Position=UDim2.fromOffset(8,80)
			f.BackgroundColor3=Color3.fromRGB(12,12,12)
			f.BackgroundTransparency=0.1
			f.BorderSizePixel=0
			f.Parent=g
			local st=Instance.new("UIStroke") st.Color=Color3.fromRGB(0,220,120) st.Transparency=0.3 st.Parent=f
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
	if label then label.Text=table.concat(L,"\n") end
end

local hrp,ch

local function bind(c)
	ch=c
	hrp=c and c:FindFirstChild("HumanoidRootPart")
	log("绑定角色: "..tostring(c and c.Name))
end
bind(LP.Character)
LP.CharacterAdded:Connect(bind)

log("人物写入诊断 已启动")

task.spawn(function()
	while true do
		task.wait(1)
		if not hrp or not hrp.Parent then
			bind(LP.Character)
			if not hrp then log("没有 HumanoidRootPart") continue end
		end
		local own="?"
		pcall(function()
			local p=hrp:GetNetworkOwner()
			own=p and p.Name or "服务器"
		end)
		local hum=ch and ch:FindFirstChildOfClass("Humanoid")
		local anc=hrp.Anchored
		local hc=hum and hum.Health or -1
		local hst=hum and tostring(hum:GetState()) or "?"
		log(string.format("位置 %.0f,%.0f,%.0f | 锚定=%s | 归属=%s", hrp.Position.X, hrp.Position.Y, hrp.Position.Z, tostring(anc), own))
		log(string.format("血量=%s | 状态=%s", tostring(hc), hst))
	end
end)

-- 每 4 秒做一次"往上抬 3 格"的写入测试，看位置是否真的变了
task.spawn(function()
	while true do
		task.wait(4)
		if hrp and hrp.Parent then
			local before=hrp.Position
			pcall(function() hrp.CFrame=hrp.CFrame*CFrame.new(0,3,0) end)
			task.wait(0.25)
			local after=hrp.Position
			local d=(after-before).Magnitude
			if d>1 then
				log(string.format("写入测试: 生效 (移动 %.1f 格)", d))
			else
				log("写入测试: 无效 (角色被锁死/被服务器拉回)")
			end
			pcall(function()
				local hum=ch and ch:FindFirstChildOfClass("Humanoid")
				if hum then hum.Sit=false end
			end)
		end
	end
end)
