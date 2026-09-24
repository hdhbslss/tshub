--[[ TS Hub | loadstring(game:HttpGet("YOUR_RAW_URL"))() ]]
if _G.__TSH then return end _G.__TSH=true

local P=game:GetService("Players")
local RS=game:GetService("RunService")
local UI=game:GetService("UserInputService")
local HS=game:GetService("HttpService")
local LT=game:GetService("Lighting")
local TS=game:GetService("TeleportService")
local SS=game:GetService("SoundService")
local CG=game:GetService("CoreGui")
local VIM=game:GetService("VirtualInputManager")
local LP=P.LocalPlayer

local E={
 dg=type(Drawing)~="nil",
 mm=type(mousemoverel)=="function",
 m1=type(mouse1click)=="function",
 hk=type(hookmetamethod)=="function",
 nc=type(getnamecallmethod)=="function",
 cc=type(checkcaller)=="function",
 gm=type(getrawmetatable)=="function",
 sr=type(setreadonly)=="function",
 nwc=type(newcclosure)=="function",
 id=type(getthreadidentity)=="function" or type(getidentity)=="function",
 si=type(setthreadidentity)=="function" or type(setidentity)=="function",
 wf=type(writefile)=="function",
 rf=type(readfile)=="function",
 iff=type(isfile)=="function",
}
do local ok,n=pcall(function() return identifyexecutor and identifyexecutor() or "unknown" end) E.ex=ok and tostring(n) or "unknown" end
print("[TS Hub] ENV:")
for k,v in pairs(E) do print("  "..k.."="..tostring(v)) end

local repo='https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local L=loadstring(game:HttpGet(repo..'Library.lua'))()
local TM=loadstring(game:HttpGet(repo..'addons/ThemeManager.lua'))()
local SM=loadstring(game:HttpGet(repo..'addons/SaveManager.lua'))()
L.AccentColor=Color3.fromRGB(120,200,255)
L.BackgroundColor=Color3.fromRGB(18,18,22)
L.MainColor=Color3.fromRGB(28,28,34)
L.OutlineColor=Color3.fromRGB(60,60,72)
L.FontColor=Color3.fromRGB(230,230,235)
pcall(function() L:UpdateColorsUsingRegistry() end)

local W=L:CreateWindow({Title='TS Hub | Rivals',Center=true,AutoShow=true,TabPadding=6,MenuFadeTime=0.12})
local T={
 C=W:AddTab('Combat'),
 V=W:AddTab('Visual'),
 M=W:AddTab('Movement'),
 AR=W:AddTab('Anti-Rage'),
 ST=W:AddTab('Stealth'),
 AD=W:AddTab('Advanced'),
 CF=W:AddTab('Config'),
 SE=W:AddTab('Settings'),
}

local CFG={
 aim=false,fov=150,sm=15,part="Head",tc=true,wc=false,
 sil=false,rage=false,raf=true,trg=false,
 ia=false,rapid=false,rm=3,nr=false,
 esp=false,box=true,nm=true,hp=true,dist=true,trc=false,skel=false,maxd=1000,
 fovring=false,fovr=150,
 nf=false,nofog=false,fb=false,fovch=false,fovv=90,
 fly=false,fs=80,spd=false,spv=60,nc=false,ij=false,bh=false,
 ar=false,arvs=false,ari=0.25,arr=15,arhl=true,
 aaen=false,aap="None",aat="None",aas=1500,aar=45,
 vjen=false,vje=15,
 snd="None",sv=1,
 ab=true,abj=true,
 hub="YOUR_RAW_URL",
}

local C={}
local function KC(k) if C[k] then pcall(function() C[k]:Disconnect() end) C[k]=nil end end

local ESPFolder
local function getESPFolder()
 if ESPFolder and ESPFolder.Parent then return ESPFolder end
 ESPFolder=Instance.new("Folder")
 ESPFolder.Name="TSHubESP"
 ESPFolder.Parent=CG
 return ESPFolder
end
local function clearESP()
 if ESPFolder then
  for _,c in ipairs(ESPFolder:GetChildren()) do c:Destroy() end
 end
end

local FOVGui,FOVFrame
local function makeFOVRing()
 if FOVGui and FOVGui.Parent then return end
 FOVGui=Instance.new("ScreenGui")
 FOVGui.Name="TSHubFOV"
 FOVGui.ResetOnSpawn=false
 FOVGui.IgnoreGuiInset=true
 FOVGui.Parent=CG
 FOVFrame=Instance.new("Frame")
 FOVFrame.Size=UDim2.new(0,0,0,0)
 FOVFrame.Position=UDim2.new(0.5,0,0.5,0)
 FOVFrame.AnchorPoint=Vector2.new(0.5,0.5)
 FOVFrame.BackgroundTransparency=1
 FOVFrame.BorderSizePixel=0
 FOVFrame.Parent=FOVGui
 local stroke=Instance.new("UIStroke")
 stroke.Name="stroke"
 stroke.Color=Color3.fromRGB(120,200,255)
 stroke.Thickness=1
 stroke.Transparency=0.3
 stroke.Parent=FOVFrame
 local corner=Instance.new("UICorner")
 corner.CornerRadius=UDim.new(1,0)
 corner.Parent=FOVFrame
end
local function updateFOVRing()
 if not CFG.fovring then
  if FOVFrame then FOVFrame.Visible=false end
  return
 end
 if not FOVFrame then makeFOVRing() end
 FOVFrame.Visible=true
 FOVFrame.Size=UDim2.new(0,CFG.fovr*2,0,CFG.fovr*2)
end

local R={}
function R.tm()
 if not LP.Character then return "" end
 local p=LP.Character.Parent
 return p and p.Name or ""
end
function R.en(pl)
 if pl==LP then return false end
 if not pl.Character or not pl.Character.Parent then return false end
 local m=R.tm()
 if m=="" then return true end
 return pl.Character.Parent.Name~=m
end
function R.cp(pl)
 local c=pl.Character
 if not c then return nil end
 return c:FindFirstChildOfClass("Humanoid"),
        c:FindFirstChild("HumanoidRootPart"),
        c:FindFirstChild("Head")
end
function R.w2s(p)
 local c=workspace.CurrentCamera
 local s,o=c:WorldToViewportPoint(p)
 return Vector2.new(s.X,s.Y),o,s.Z
end
function R.tl()
 local c=LP.Character
 if not c then return nil end
 return c:FindFirstChildOfClass("Tool")
end
function R.am(t)
 if not t then return nil,nil end
 local a=t:FindFirstChild("Ammo") or t:FindFirstChild("CurrentAmmo") or t:FindFirstChild("Mag")
 local m=t:FindFirstChild("MaxAmmo") or t:FindFirstChild("MaxAmmoValue")
 return a,m
end
function R.nt(m,d) L:Notify(tostring(m),d or 2) end

local function sESP()
 if C.esp then return end
 C.esp=RS.RenderStepped:Connect(function()
  clearESP()
  if not CFG.esp then return end
  local cam=workspace.CurrentCamera
  local folder=getESPFolder()
  for _,pl in ipairs(P:GetPlayers()) do
   if pl==LP then continue end
   local h,r,hd=R.cp(pl)
   if not h or not r or not hd then continue end
   if h.Health<=0 then continue end
   local dist=(cam.CFrame.Position-r.Position).Magnitude
   if dist>CFG.maxd then continue end
   local en=R.en(pl)
   local col=en and Color3.fromRGB(255,70,70) or Color3.fromRGB(70,255,120)
   if CFG.box then
    local hl=Instance.new("Highlight")
    hl.Name="box"
    hl.FillColor=col
    hl.OutlineColor=col
    hl.FillTransparency=1
    hl.OutlineTransparency=0
    hl.Adornee=pl.Character
    hl.Parent=folder
   end
   if CFG.nm or CFG.hp or CFG.dist then
    local bg=Instance.new("BillboardGui")
    bg.Name="info"
    bg.Size=UDim2.new(0,180,0,40)
    bg.StudsOffsetWorldSpace=Vector3.new(0,3,0)
    bg.AlwaysOnTop=true
    bg.Adornee=r
    bg.Parent=folder
    if CFG.nm then
     local lbl=Instance.new("TextLabel")
     lbl.Size=UDim2.new(1,0,0,16)
     lbl.BackgroundTransparency=1
     lbl.Text=pl.Name
     lbl.TextColor3=col
     lbl.TextStrokeTransparency=0
     lbl.TextSize=14
     lbl.Font=Enum.Font.GothamBold
     lbl.Parent=bg
    end
    if CFG.hp then
     local barBg=Instance.new("Frame")
     barBg.Size=UDim2.new(0.8,0,0,4)
     barBg.Position=UDim2.new(0.1,0,0,18)
     barBg.BackgroundColor3=Color3.fromRGB(40,40,40)
     barBg.BorderSizePixel=0
     barBg.Parent=bg
     local bar=Instance.new("Frame")
     local hp=math.clamp(h.Health/h.MaxHealth,0,1)
     bar.Size=UDim2.new(hp,0,1,0)
     bar.BackgroundColor3=Color3.fromRGB(80,255,80)
     bar.BorderSizePixel=0
     bar.Parent=barBg
    end
    if CFG.dist then
     local lbl=Instance.new("TextLabel")
     lbl.Size=UDim2.new(1,0,0,14)
     lbl.Position=UDim2.new(0,0,0,24)
     lbl.BackgroundTransparency=1
     lbl.Text=string.format("[%d]",math.floor(dist))
     lbl.TextColor3=Color3.fromRGB(200,200,200)
     lbl.TextStrokeTransparency=0.5
     lbl.TextSize=12
     lbl.Font=Enum.Font.Gotham
     lbl.Parent=bg
    end
   end
  end
 end)
end
local function stESP() KC("esp") clearESP() end

local fovConn
local function sFOVRing()
 if fovConn then return end
 makeFOVRing()
 fovConn=RS.RenderStepped:Connect(function() updateFOVRing() end)
end
local function stFOVRing()
 if fovConn then fovConn:Disconnect() fovConn=nil end
 if FOVFrame then FOVFrame.Visible=false end
end

local function tgt(fov,igf)
 local cam=workspace.CurrentCamera
 local ctr=Vector2.new(cam.ViewportSize.X/2,cam.ViewportSize.Y/2)
 local ms=UI:GetMouseLocation()
 local best,bd=nil,igf and math.huge or (fov or 150)
 for _,pl in ipairs(P:GetPlayers()) do
  if pl==LP then continue end
  if CFG.tc and not R.en(pl) then continue end
  local h,r,hd=R.cp(pl)
  if not h or not r or h.Health<=0 then continue end
  local pt=CFG.part=="Head" and hd or r
  if CFG.part=="Random" then pt=math.random()<0.5 and hd or r end
  if not pt then continue end
  if CFG.wc then
   local o=cam.CFrame.Position
   local dr=pt.Position-o
   local hit=workspace:FindPartOnRayWithIgnoreList(Ray.new(o,dr),{LP.Character})
   if hit and not hit:IsDescendantOf(pl.Character) then continue end
  end
  local s,o=R.w2s(pt.Position)
  if not o then continue end
  local d=(s-ms).Magnitude
  if d<bd then bd=d best=pt end
 end
 return best
end

local function sAIM()
 if C.aim then return end
 C.aim=RS.RenderStepped:Connect(function()
  if not CFG.aim then return end
  local t=tgt(CFG.fov,false)
  if not t then return end
  local cam=workspace.CurrentCamera
  local ctr=Vector2.new(cam.ViewportSize.X/2,cam.ViewportSize.Y/2)
  local s=R.w2s(t.Position)
  local d=s-ctr
  local sm=CFG.sm/100
  cam.CFrame=cam.CFrame*CFrame.new(d.X*sm*0.01,d.Y*sm*0.01,0)
 end)
end
local function stAIM() KC("aim") end

local function sSIL()
 if C.sil then return end
 C.sil=RS.RenderStepped:Connect(function()
  if not CFG.sil then return end
  if not UI:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then return end
  local t=tgt(nil,true)
  if not t then return end
  local cam=workspace.CurrentCamera
  cam.CFrame=CFrame.lookAt(cam.CFrame.Position,t.Position)
 end)
end
local function stSIL() KC("sil") end

local function sTRG()
 if C.trg then return end
 C.trg=RS.RenderStepped:Connect(function()
  if not CFG.trg then return end
  local t=tgt(20,true)
  if t then
   pcall(function() VIM:SendMouseButtonEvent(0,0,0,true,game,0) end)
   task.wait(0.02)
   pcall(function() VIM:SendMouseButtonEvent(0,0,0,false,game,0) end)
  end
 end)
end
local function stTRG() KC("trg") end

local function sRG()
 if C.rage then return end
 C.rage=RS.RenderStepped:Connect(function()
  if not CFG.rage then return end
  local t=tgt(nil,true)
  if not t then return end
  local cam=workspace.CurrentCamera
  cam.CFrame=CFrame.lookAt(cam.CFrame.Position,t.Position)
  if CFG.raf then
   pcall(function() VIM:SendMouseButtonEvent(0,0,0,true,game,0) end)
   pcall(function() VIM:SendMouseButtonEvent(0,0,0,false,game,0) end)
  end
 end)
end
local function stRG() KC("rage") end

local function sIA()
 if C.ia then return end
 C.ia=RS.Heartbeat:Connect(function()
  if not CFG.ia then return end
  local t=R.tl()
  if not t then return end
  local a,m=R.am(t)
  if a and m and a.Value<m.Value then a.Value=m.Value end
 end)
end
local function stIA() KC("ia") end

local function sRP()
 if C.rp then return end
 C.rp=RS.Heartbeat:Connect(function()
  if not CFG.rapid then return end
  if not UI:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then return end
  local t=R.tl()
  if not t then return end
  for _=1,CFG.rm do pcall(function() t:Activate() end) end
 end)
end
local function stRP() KC("rp") end

local function sNR()
 if C.nr then return end
 C.nr=RS.RenderStepped:Connect(function()
  if not CFG.nr then return end
  local t=R.tl()
  if not t then return end
  for _,c in ipairs(t:GetChildren()) do
   if c:IsA("NumberValue") and (c.Name:lower():find("recoil") or c.Name:lower():find("spread")) then
    c.Value=0
   end
  end
 end)
end
local function stNR() KC("nr") end

local fv,fg
local function sFLY()
 if C.fly then return end
 local ch=LP.Character
 if not ch then return end
 local r=ch:FindFirstChild("HumanoidRootPart")
 if not r then return end
 fv=Instance.new("BodyVelocity")
 fv.MaxForce=Vector3.new(1e5,1e5,1e5)
 fv.Velocity=Vector3.zero
 fv.Parent=r
 fg=Instance.new("BodyGyro")
 fg.MaxTorque=Vector3.new(1e5,1e5,1e5)
 fg.P=1e4
 fg.Parent=r
 C.fly=RS.RenderStepped:Connect(function()
  if not CFG.fly then
   if fv then fv.Velocity=Vector3.zero end
   return
  end
  local ch2=LP.Character
  if not ch2 then return end
  local r2=ch2:FindFirstChild("HumanoidRootPart")
  if not r2 then return end
  if fv.Parent~=r2 then fv.Parent=r2 end
  if fg.Parent~=r2 then fg.Parent=r2 end
  local cam=workspace.CurrentCamera
  local d=Vector3.zero
  if UI:IsKeyDown(Enum.KeyCode.W) then d+=cam.CFrame.LookVector end
  if UI:IsKeyDown(Enum.KeyCode.S) then d-=cam.CFrame.LookVector end
  if UI:IsKeyDown(Enum.KeyCode.A) then d-=cam.CFrame.RightVector end
  if UI:IsKeyDown(Enum.KeyCode.D) then d+=cam.CFrame.RightVector end
  if UI:IsKeyDown(Enum.KeyCode.Space) then d+=Vector3.new(0,1,0) end
  if UI:IsKeyDown(Enum.KeyCode.LeftControl) then d-=Vector3.new(0,1,0) end
  if d.Magnitude>0 then d=d.Unit*CFG.fs end
  fv.Velocity=d
  fg.CFrame=cam.CFrame
 end)
end
local function stFLY()
 KC("fly")
 if fv then fv:Destroy() fv=nil end
 if fg then fg:Destroy() fg=nil end
end

local function sSPD()
 if C.spd then return end
 C.spd=RS.Heartbeat:Connect(function()
  if not CFG.spd then return end
  local ch=LP.Character
  if not ch then return end
  local h=ch:FindFirstChildOfClass("Humanoid")
  if h then
   h.WalkSpeed=CFG.abj and (CFG.spv+(math.random()-0.5)*2) or CFG.spv
  end
 end)
end
local function stSPD()
 KC("spd")
 local ch=LP.Character
 if ch then
  local h=ch:FindFirstChildOfClass("Humanoid")
  if h then h.WalkSpeed=16 end
 end
end

local function sNC()
 if C.nc then return end
 C.nc=RS.Stepped:Connect(function()
  if not CFG.nc then return end
  local ch=LP.Character
  if not ch then return end
  for _,p in ipairs(ch:GetDescendants()) do
   if p:IsA("BasePart") and p.CanCollide then p.CanCollide=false end
  end
 end)
end
local function stNC() KC("nc") end

local function sIJ()
 if C.ij then return end
 C.ij=UI.JumpRequest:Connect(function()
  if not CFG.ij then return end
  local ch=LP.Character
  if not ch then return end
  local h=ch:FindFirstChildOfClass("Humanoid")
  if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
 end)
end
local function stIJ() KC("ij") end

local function sBH()
 if C.bh then return end
 C.bh=RS.Heartbeat:Connect(function()
  if not CFG.bh then return end
  local ch=LP.Character
  if not ch then return end
  local h=ch:FindFirstChildOfClass("Humanoid")
  if h and h.FloorMaterial~=Enum.Material.Air then
   h:ChangeState(Enum.HumanoidStateType.Jumping)
  end
 end)
end
local function stBH() KC("bh") end

local function sNF()
 if C.nf then return end
 C.nf=RS.RenderStepped:Connect(function()
  if not CFG.nf then return end
  for _,c in ipairs(LT:GetChildren()) do
   if c:IsA("ColorCorrectionEffect") then
    c.Brightness=0 c.Contrast=0 c.Saturation=0
   end
  end
 end)
end
local function stNF() KC("nf") end

local function sNG()
 if C.nog then return end
 C.nog=RS.Heartbeat:Connect(function()
  if CFG.nofog then LT.FogEnd=1e6 LT.FogStart=1e6 end
 end)
end
local function stNG() KC("nog") end

local function sFB()
 if C.fb then return end
 C.fb=RS.Heartbeat:Connect(function()
  if CFG.fb then
   LT.Ambient=Color3.fromRGB(178,178,178)
   LT.OutdoorAmbient=Color3.fromRGB(178,178,178)
   LT.Brightness=3
  end
 end)
end
local function stFB() KC("fb") end

local function aFOV()
 workspace.CurrentCamera.FieldOfView=CFG.fovch and CFG.fovv or 70
end

local function sAR()
 if C.ar then return end
 C.ar=RS.Heartbeat:Connect(function()
  if not CFG.ar then return end
  if CFG.arhl then
   local ch=LP.Character
   if ch then
    local h=ch:FindFirstChildOfClass("Humanoid")
    if h and h.Health<h.MaxHealth then h.Health=h.MaxHealth end
   end
  end
 end)
end
local function stAR() KC("ar") end

local VS={act=false,orig=nil,lt=0}
local function sVS()
 if VS.act then return end
 local ch=LP.Character
 if not ch then return end
 local h=ch:FindFirstChild("HumanoidRootPart")
 if not h then return end
 VS.act=true
 VS.orig=h.Position
 C.vs=RS.Heartbeat:Connect(function()
  if not VS.act then return end
  local ch2=LP.Character
  if not ch2 then return end
  local h2=ch2:FindFirstChild("HumanoidRootPart")
  if not h2 then return end
  local n=tick()
  if n-VS.lt<CFG.ari then return end
  VS.lt=n
  local o=VS.orig or h2.Position
  local a=math.random()*math.pi*2
  local d=math.random(2,CFG.arr)
  local tx=o+Vector3.new(math.cos(a)*d,0,math.sin(a)*d)
  h2.CFrame=CFrame.new(h2.Position:Lerp(tx,0.4))
 end)
end
local function stVS()
 KC("vs") VS.act=false
 local ch=LP.Character
 if ch and VS.orig then
  local h=ch:FindFirstChild("HumanoidRootPart")
  if h then h.CFrame=CFrame.new(VS.orig) end
 end
end

local BW={vo=nil,anga=0,sw=1,el=0}
local SND={None=nil,Whoosh="rbxasset://sounds/impact_water.mp3",Glitch="rbxasset://sounds/electronicpingshort.wav",Bass="rbxasset://sounds/swoosh.wav",Pulse="rbxasset://sounds/switch.wav",Static="rbxasset://sounds/collision.wav"}
local aS={}
local function wS()
 for _,s in ipairs(aS) do
  pcall(function() s:Stop() s:Destroy() end)
 end
 aS={}
end
local function sBS()
 wS()
 if CFG.snd=="None" then return end
 local id=SND[CFG.snd]
 if not id then return end
 local s=Instance.new("Sound")
 s.SoundId=id
 s.Volume=CFG.sv
 s.Looped=true
 s.Parent=SS
 s:Play()
 table.insert(aS,s)
end

local function sVJ()
 if C.vj then return end
 C.vj=RS.Heartbeat:Connect(function(dt)
  if not CFG.vjen then return end
  local ch=LP.Character
  if not ch then return end
  local h=ch:FindFirstChild("HumanoidRootPart")
  if not h then return end
  if not BW.vo then BW.vo=h.Position end
  BW.el=BW.el+dt
  local a=BW.el*5
  local r=math.min(CFG.vje,20)
  h.CFrame=CFrame.new(BW.vo or h.Position)+Vector3.new(math.cos(a)*r,0,math.sin(a)*r)
 end)
end
local function stVJ()
 KC("vj")
 local ch=LP.Character
 if ch and BW.vo then
  local h=ch:FindFirstChild("HumanoidRootPart")
  if h then h.CFrame=CFrame.new(BW.vo) end
 end
 BW.vo=nil
end

local function sAA()
 if C.aa then return end
 C.aa=RS.RenderStepped:Connect(function(dt)
  if not CFG.aaen then return end
  local ch=LP.Character
  if not ch then return end
  local h=ch:FindFirstChild("HumanoidRootPart")
  if not h then return end
  local pit=0
  local p=CFG.aap
  if p=="Up" then pit=math.rad(-89)
  elseif p=="Down" then pit=math.rad(89)
  elseif p=="Flip" then pit=math.rad((math.random()>0.5) and -89 or 89) end
  local yw=0
  local t=CFG.aat
  local sp=CFG.aas
  local rt=CFG.aar
  if t=="Spin" then
   BW.anga=(BW.anga+sp*dt*0.1)%360
   yw=math.rad(BW.anga)
  elseif t=="Jitter" then
   yw=math.rad((math.random()>0.5 and 1 or -1)*rt)
  elseif t=="Sway" then
   BW.anga=BW.anga+sp*dt*0.05*BW.sw
   if BW.anga>=rt then BW.anga=rt BW.sw=-1
   elseif BW.anga<=-rt then BW.anga=-rt BW.sw=1 end
   yw=math.rad(BW.anga)
  end
  h.CFrame=CFrame.new(h.Position)*CFrame.Angles(pit,yw,0)
 end)
end
local function stAA() KC("aa") end

local AB={oi=0,hm=false}
pcall(function()
 if getthreadidentity then AB.oi=getthreadidentity()
 elseif getidentity then AB.oi=getidentity() end
end)
function AB.ri()
 if AB.oi>0 then
  if setthreadidentity then pcall(setthreadidentity,AB.oi)
  elseif setidentity then pcall(setidentity,AB.oi) end
 end
end
if E.hk and E.gm and E.sr and E.nwc and E.nc and E.cc then
 pcall(function()
  local mt=getrawmetatable(game)
  local o=mt.__namecall
  setreadonly(mt,false)
  mt.__namecall=newcclosure(function(self,...)
   local m=getnamecallmethod()
   if m=="Kick" then
    if not checkcaller() then return nil end
   end
   return o(self,...)
  end)
  setreadonly(mt,true)
  AB.hm=true
 end)
end
task.spawn(function()
 while task.wait(5+math.random()*3) do
  AB.ri()
 end
end)

local CDIR="TSHub/configs"
local ALF="TSHub/_autoload.txt"
local CM={}
local has_wf=E.wf
local has_rf=E.rf
local has_iff=E.iff
function CM.ed()
 if not has_wf then return end
 pcall(function()
  if makefolder and not isfolder("TSHub") then makefolder("TSHub") end
  if makefolder and not isfolder(CDIR) then makefolder(CDIR) end
 end)
end
function CM.ls()
 local o={}
 if not listfiles then return o end
 CM.ed()
 pcall(function()
  for _,f in ipairs(listfiles(CDIR)) do
   local n=f:match("([^/\\]+)%.json$")
   if n then table.insert(o,n) end
  end
 end)
 return o
end
function CM.sv(n)
 if not has_wf then R.nt("No writefile",2) return end
 if not n or n=="" then R.nt("Name required",2) return end
 n=n:gsub("%s+","_"):gsub("[^%w_%-]","")
 CM.ed()
 local cf={}
 for k,v in pairs(CFG) do cf[k]=v end
 local ok=pcall(function()
  writefile(CDIR.."/"..n..".json", HS:JSONEncode(cf))
 end)
 R.nt(ok and ("Saved: "..n) or "Save failed",2)
end
function CM.ld(n)
 if not has_rf or not has_iff then R.nt("No readfile",2) return end
 if not n or n=="" then return end
 local p=CDIR.."/"..n..".json"
 if not isfile(p) then R.nt("Not found",2) return end
 local ok,c=pcall(function() return readfile(p) end)
 if not ok or not c then R.nt("Read failed",2) return end
 local ok2,data=pcall(function() return HS:JSONDecode(c) end)
 if not ok2 or not data then R.nt("Parse failed",2) return end
 for k,v in pairs(data) do
  if CFG[k]~=nil then CFG[k]=v end
 end
 R.nt("Loaded: "..n,2)
end
function CM.dl(n)
 if not n or n=="" then return end
 local p=CDIR.."/"..n..".json"
 pcall(function()
  if delfile and isfile and isfile(p) then delfile(p) end
 end)
 R.nt("Deleted: "..n,2)
end
function CM.sl(n)
 if not has_wf then return end
 CM.ed()
 pcall(function() writefile(ALF,n or "") end)
 R.nt(n=="" and "Cleared" or ("Auto load: "..n),2)
end
function CM.gl()
 if not has_rf or not has_iff then return "" end
 if not isfile(ALF) then return "" end
 local ok,c=pcall(function() return readfile(ALF) end)
 if not ok or not c then return "" end
 return c:gsub("%s","")
end
function CM.al()
 local n=CM.gl()
 if n=="" then return end
 task.defer(function() task.wait(0.5) CM.ld(n) end)
end

local CL=T.C:AddLeftGroupbox('Aimbot')
CL:AddToggle('a1',{Text='Enable Aimbot',Default=false,Callback=function(v) CFG.aim=v if v then sAIM() else stAIM() end end})
CL:AddToggle('a2',{Text='Team Check',Default=true,Callback=function(v) CFG.tc=v end})
CL:AddToggle('a3',{Text='Wall Check',Default=false,Callback=function(v) CFG.wc=v end})
CL:AddDropdown('a4',{Values={'Head','Torso','Random'},Default=1,Text='Part',Callback=function(v) CFG.part=v end})
CL:AddSlider('a5',{Text='FOV',Default=150,Min=10,Max=500,Rounding=0,Callback=function(v) CFG.fov=v end})
CL:AddSlider('a6',{Text='Smooth',Default=15,Min=1,Max=100,Rounding=0,Callback=function(v) CFG.sm=v end})

local CR=T.C:AddRightGroupbox('Silent / Rage / Trigger')
CR:AddToggle('b1',{Text='Silent Aim',Default=false,Callback=function(v) CFG.sil=v if v then sSIL() else stSIL() end end})
CR:AddToggle('b2',{Text='Ragebot',Default=false,Callback=function(v) CFG.rage=v if v then sRG() else stRG() end end})
CR:AddToggle('b3',{Text='AutoFire',Default=true,Callback=function(v) CFG.raf=v end})
CR:AddToggle('b5',{Text='Trigger Bot',Default=false,Callback=function(v) CFG.trg=v if v then sTRG() else stTRG() end end})

local WL=T.C:AddLeftGroupbox('Weapon')
WL:AddToggle('c1',{Text='Inf Ammo',Default=false,Callback=function(v) CFG.ia=v if v then sIA() else stIA() end end})
WL:AddToggle('c2',{Text='Rapid Fire',Default=false,Callback=function(v) CFG.rapid=v if v then sRP() else stRP() end end})
WL:AddSlider('c3',{Text='Rapid Mult',Default=3,Min=1,Max=10,Rounding=0,Callback=function(v) CFG.rm=v end})
WL:AddToggle('c4',{Text='No Recoil',Default=false,Callback=function(v) CFG.nr=v if v then sNR() else stNR() end end})

local VL=T.V:AddLeftGroupbox('ESP')
VL:AddToggle('d1',{Text='Enable ESP',Default=false,Callback=function(v) CFG.esp=v if v then sESP() else stESP() end end})
VL:AddToggle('d2',{Text='Box',Default=true,Callback=function(v) CFG.box=v end})
VL:AddToggle('d3',{Text='Name',Default=true,Callback=function(v) CFG.nm=v end})
VL:AddToggle('d4',{Text='Health',Default=true,Callback=function(v) CFG.hp=v end})
VL:AddToggle('d5',{Text='Distance',Default=true,Callback=function(v) CFG.dist=v end})
VL:AddToggle('d6',{Text='Tracers',Default=false,Callback=function(v) CFG.trc=v end})
VL:AddToggle('d7',{Text='Skeleton',Default=false,Callback=function(v) CFG.skel=v end})
VL:AddSlider('d8',{Text='Max Dist',Default=1000,Min=100,Max=5000,Rounding=0,Callback=function(v) CFG.maxd=v end})

local VR=T.V:AddRightGroupbox('Environment')
VR:AddToggle('e1',{Text='No Flash',Default=false,Callback=function(v) CFG.nf=v if v then sNF() else stNF() end end})
VR:AddToggle('e2',{Text='No Fog',Default=false,Callback=function(v) CFG.nofog=v if v then sNG() else stNG() end end})
VR:AddToggle('e3',{Text='Fullbright',Default=false,Callback=function(v) CFG.fb=v if v then sFB() else stFB() end end})
VR:AddToggle('e4',{Text='FOV Changer',Default=false,Callback=function(v) CFG.fovch=v aFOV() end})
VR:AddSlider('e5',{Text='FOV Value',Default=90,Min=60,Max=140,Rounding=0,Callback=function(v) CFG.fovv=v aFOV() end})
VR:AddToggle('e6',{Text='FOV Ring',Default=false,Callback=function(v) CFG.fovring=v if v then sFOVRing() else stFOVRing() end end})
VR:AddSlider('e7',{Text='Ring Size',Default=150,Min=50,Max=500,Rounding=0,Callback=function(v) CFG.fovr=v end})

local ML=T.M:AddLeftGroupbox('Fly / Speed')
ML:AddToggle('f1',{Text='Fly',Default=false,Callback=function(v) CFG.fly=v if v then sFLY() else stFLY() end end})
ML:AddSlider('f2',{Text='Fly Speed',Default=80,Min=20,Max=400,Rounding=0,Callback=function(v) CFG.fs=v end})
ML:AddToggle('f3',{Text='Speed',Default=false,Callback=function(v) CFG.spd=v if v then sSPD() else stSPD() end end})
ML:AddSlider('f4',{Text='Walk Speed',Default=60,Min=16,Max=300,Rounding=0,Callback=function(v) CFG.spv=v end})

local MR=T.M:AddRightGroupbox('Noclip / Jump')
MR:AddToggle('g1',{Text='Noclip',Default=false,Callback=function(v) CFG.nc=v if v then sNC() else stNC() end end})
MR:AddToggle('g2',{Text='Inf Jump',Default=false,Callback=function(v) CFG.ij=v if v then sIJ() else stIJ() end end})
MR:AddToggle('g3',{Text='BHop',Default=false,Callback=function(v) CFG.bh=v if v then sBH() else stBH() end end})

local ALG=T.AR:AddLeftGroupbox('Anti-Rage')
ALG:AddToggle('h1',{Text='Enable Anti-Rage',Default=false,Callback=function(v) CFG.ar=v if v then sAR() else stAR() end end})
ALG:AddToggle('h2',{Text='Health Lock',Default=true,Callback=function(v) CFG.arhl=v end})

local ARR=T.AR:AddRightGroupbox('Void Spam')
ARR:AddToggle('i1',{Text='Enable Void Spam',Default=false,Callback=function(v) if v then sVS() R.nt('VS ON',2) else stVS() R.nt('VS OFF',2) end end})
ARR:AddSlider('i2',{Text='Interval (ms)',Default=250,Min=50,Max=1000,Rounding=0,Callback=function(v) CFG.ari=v/1000 end})
ARR:AddSlider('i3',{Text='Range (studs)',Default=15,Min=2,Max=100,Rounding=0,Callback=function(v) CFG.arr=v end})

local SJL=T.ST:AddLeftGroupbox('Void Jitter')
SJL:AddToggle('k1',{Text='Enable Void Jitter',Default=false,Callback=function(v) CFG.vjen=v if v then sVJ() sBS() else stVJ() wS() end end})
SJL:AddSlider('k2',{Text='Radius',Default=15,Min=0,Max=20,Rounding=0,Callback=function(v) CFG.vje=v end})
SJL:AddDropdown('k3',{Values={'None','Whoosh','Glitch','Bass','Pulse','Static'},Default=1,Text='Sound',Callback=function(v) CFG.snd=v if CFG.vjen then sBS() end end})

local SJR=T.ST:AddRightGroupbox('Anti-Aim')
SJR:AddToggle('l4',{Text='Anti-Aim',Default=false,Callback=function(v) CFG.aaen=v if v then sAA() else stAA() end end})
SJR:AddDropdown('l6',{Values={'None','Up','Down','Flip'},Default=1,Text='Pitch',Callback=function(v) CFG.aap=v end})
SJR:AddDropdown('l7',{Values={'None','Spin','Jitter','Sway'},Default=1,Text='Type',Callback=function(v) CFG.aat=v end})
SJR:AddSlider('l8',{Text='Speed',Default=1500,Min=0,Max=20000,Rounding=0,Callback=function(v) CFG.aas=v end})
SJR:AddSlider('l9',{Text='Rotate Amount',Default=45,Min=0,Max=360,Rounding=0,Callback=function(v) CFG.aar=v end})

local ADL=T.AD:AddLeftGroupbox('Auto Load / Hop')
ADL:AddInput('m1',{Text='Hub URL',Default=CFG.hub,Placeholder='raw github url',Callback=function(v) CFG.hub=v end})
ADL:AddToggle('m2',{Text='Install Auto Load',Default=false,Callback=function(v)
 if v then
  if not has_wf then R.nt("Need writefile",3) return end
  pcall(function()
   if makefolder and not isfolder("autoexec") then makefolder("autoexec") end
   writefile("autoexec/tshub.lua",string.format([[loadstring(game:HttpGet("%s"))()]],CFG.hub))
  end)
  R.nt("Installed",2)
 else
  pcall(function()
   if delfile and isfile and isfile("autoexec/tshub.lua") then
    delfile("autoexec/tshub.lua")
   end
  end)
  R.nt("Removed",2)
 end
end})
ADL:AddButton('Server Hop',function()
 local url="https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
 local ok,res=pcall(function() return HS:JSONDecode(game:HttpGet(url)) end)
 if not ok or not res or not res.data then R.nt("Hop failed",3) return end
 local lst={}
 for _,s in ipairs(res.data) do
  if s.playing<s.maxPlayers and s.id~=game.JobId then
   table.insert(lst,s.id)
  end
 end
 if #lst==0 then R.nt("No servers",3) return end
 local tg=lst[math.random(1,#lst)]
 local ld=string.format([[loadstring(game:HttpGet("%s"))()]],CFG.hub)
 if queue_on_teleport then
  pcall(function() queue_on_teleport(ld) end)
 elseif queueonteleport then
  pcall(function() queueonteleport(ld) end)
 end
 R.nt("Hopping...",2)
 task.wait(0.5)
 TS:TeleportToPlaceInstance(game.PlaceId,tg,LP)
end)

local ADR=T.AD:AddRightGroupbox('Anti-Ban')
ADR:AddToggle('n1',{Text='Enable Anti-Ban',Default=true,Callback=function(v)
 CFG.ab=v
 if v then AB.ri() R.nt('AB ON',2) end
end})
ADR:AddToggle('n2',{Text='Walkspeed Jitter',Default=true,Callback=function(v) CFG.abj=v end})
ADR:AddButton('Restore Identity',function() AB.ri() R.nt('Identity: '..tostring(AB.oi),2) end)

local SL=T.CF:AddLeftGroupbox('Config Manager')
SL:AddInput('o1',{Text='Config Name',Default='',Placeholder='my_config'})
local i0=CM.ls()
SL:AddDropdown('o2',{Values=#i0>0 and i0 or {'(none)'},Default=1,Text='Saved'})
SL:AddButton('Refresh',function()
 local l=CM.ls()
 pcall(function()
  if Options.o2 and Options.o2.SetValues then
   Options.o2:SetValues(#l>0 and l or {'(none)'})
  end
 end)
 R.nt("Found "..#l,2)
end)
SL:AddButton('Save',function() CM.sv(Options.o1 and Options.o1.Value or '') end)
SL:AddButton('Load',function()
 local n=Options.o2 and Options.o2.Value or ''
 if n=='(none)' then R.nt("None",2) return end
 CM.ld(n)
end)
SL:AddButton('Delete',function()
 local n=Options.o2 and Options.o2.Value or ''
 if n=='(none)' then return end
 CM.dl(n)
end)
SL:AddButton('Set Auto Load',function()
 local n=Options.o2 and Options.o2.Value or ''
 if n=='(none)' then R.nt("None",2) return end
 CM.sl(n)
end)
SL:AddButton('Clear Auto Load',function() CM.sl("") end)
SL:AddLabel(function()
 local n=CM.gl()
 return n=="" and 'Auto: (none)' or ('Auto: '..n)
end)

local SR=T.CF:AddRightGroupbox('UI')
SR:AddLabel('Menu'):AddKeyPicker('p1',{Default='RightShift',Text='Menu',Mode='Toggle',NoUI=false})
L.ToggleKeybind=Options.p1
SR:AddButton('Unload',function()
 stESP() stAIM() stSIL() stTRG() stRG() stIA() stRP() stNR()
 stFLY() stSPD() stNC() stIJ() stBH() stNF() stNG() stFB()
 stAR() stVS() stVJ() stAA() stFOVRing() wS() clearESP()
 pcall(function() if FOVGui then FOVGui:Destroy() end end)
 L:Unload() _G.__TSH=false
end)

TM:SetLibrary(L)
SM:SetLibrary(L)
TM:SetFolder('TSHub')
SM:SetFolder('TSHub/configs')
SM:IgnoreThemeSettings()
SM:SetIgnoreIndexes({'p1'})
pcall(function() SM:BuildConfigSection(T.SE) end)
pcall(function() TM:ApplyToTab(T.SE) end)
task.spawn(function() CM.al() end)
print("[TS Hub] Loaded")
