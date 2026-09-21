--[[ TS Hub | loadstring(game:HttpGet("https://raw.githubusercontent.com/hdhbslss/tshub/refs/heads/main/tshub.lua"))() ]]
if _G.__TSH then return end _G.__TSH = true

local P=game:GetService("Players") local RS=game:GetService("RunService")
local UI=game:GetService("UserInputService") local HS=game:GetService("HttpService")
local LT=game:GetService("Lighting") local TS=game:GetService("TeleportService")
local LP=P.LocalPlayer
local repo='https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local L=loadstring(game:HttpGet(repo..'Library.lua'))()
local TM=loadstring(game:HttpGet(repo..'addons/ThemeManager.lua'))()
local SM=loadstring(game:HttpGet(repo..'addons/SaveManager.lua'))()
L.AccentColor=Color3.fromRGB(120,200,255) L.BackgroundColor=Color3.fromRGB(18,18,22)
L.MainColor=Color3.fromRGB(28,28,34) L.OutlineColor=Color3.fromRGB(60,60,72)
L.FontColor=Color3.fromRGB(230,230,235) pcall(function() L:UpdateColorsUsingRegistry() end)
local W=L:CreateWindow({Title='TS Hub | Rivals',Center=true,AutoShow=true,TabPadding=6,MenuFadeTime=0.12})
local T={C=W:AddTab('Combat'),V=W:AddTab('Visual'),M=W:AddTab('Movement'),
AR=W:AddTab('Anti-Rage'),SK=W:AddTab('Skin'),BW=W:AddTab('Banware'),
AD=W:AddTab('Advanced'),ST=W:AddTab('Settings')}

local C={} local function KC(k) if C[k] then pcall(function() C[k]:Disconnect() end) C[k]=nil end end
local D={} local function CD() for _,d in pairs(D) do pcall(function() d:Remove() end) end D={} end
local function ND(c,p) local d=Drawing.new(c) for k,v in pairs(p) do d[k]=v end d.Visible=false return d end
local F={} local function KF(k) if F[k] then pcall(function() F[k]:Disconnect() end) F[k]=nil end end

local CFG={
 aim=false,fov=150,sm=15,part="Head",tc=true,wc=false,
 sil=false,rage=false,raf=true,rrange=800,trig=false,
 ia=false,rapid=false,rm=3,nr=false,
 esp=false,box=true,nm=true,hp=true,dist=true,trc=false,skel=false,maxd=1000,
 nf=false,nofog=false,fb=false,fovch=false,fovv=90,
 fly=false,fs=80,spd=false,spv=60,nc=false,ij=false,bh=false,
 ar=false,arvs=false,ari=0.08,arr=300,arhl=true,
 ab=true,abj=true,abt=true,
 hub="YOUR_RAW_URL",
}
local R={}
function R.team() if not LP.Character then return "" end local p=LP.Character.Parent return p and p.Name or "" end
function R.enemy(pl) if pl==LP then return false end if not pl.Character or not pl.Character.Parent then return false end local m=R.team() if m=="" then return true end return pl.Character.Parent.Name~=m end
function R.cp(pl) local c=pl.Character if not c then return nil end return c:FindFirstChildOfClass("Humanoid"),c:FindFirstChild("HumanoidRootPart"),c:FindFirstChild("Head") end
function R.w2s(p) local c=workspace.CurrentCamera local s,o=c:WorldToViewportPoint(p) return Vector2.new(s.X,s.Y),o,s.Z end
function R.tool() local c=LP.Character if not c then return nil end return c:FindFirstChildOfClass("Tool") end
function R.ammo(t) if not t then return nil,nil end local a=t:FindFirstChild("Ammo") or t:FindFirstChild("CurrentAmmo") or t:FindFirstChild("Mag") local m=t:FindFirstChild("MaxAmmo") or t:FindFirstChild("MaxAmmoValue") return a,m end
function R.nt(m,d) L:Notify(tostring(m),d or 2) end

--=========== ESP ===========
local function sESP() if C.esp then return end
C.esp=RS.RenderStepped:Connect(function()
 CD() if not CFG.esp then return end
 local cam=workspace.CurrentCamera
 for _,pl in ipairs(P:GetPlayers()) do
  if pl==LP then continue end
  local h,r,hd=R.cp(pl) if not h or not r or not hd then continue end
  if h.Health<=0 then continue end
  local d=(cam.CFrame.Position-r.Position).Magnitude
  if d>CFG.maxd then continue end
  local e=R.enemy(pl) local col=e and Color3.fromRGB(255,70,70) or Color3.fromRGB(70,255,120)
  local tp,to=R.w2s(r.Position+Vector3.new(0,3,0))
  local bp,bo=R.w2s(r.Position-Vector3.new(0,3,0))
  if not(to and bo) then continue end
  local H=math.abs(bp.Y-tp.Y) local Wd=H*0.5
  if CFG.box then table.insert(D,ND("Square",{Size=Vector2.new(Wd,H),Position=Vector2.new(tp.X-Wd/2,tp.Y),Color=col,Thickness=1,Filled=false,Visible=true})) end
  if CFG.nm then table.insert(D,ND("Text",{Text=pl.Name,Position=Vector2.new(tp.X,tp.Y-16),Size=14,Center=true,Color=Color3.fromRGB(255,255,255),Outline=true,Visible=true})) end
  if CFG.hp then local hp=math.clamp(h.Health/h.MaxHealth,0,1) table.insert(D,ND("Square",{Size=Vector2.new(3,H*hp),Position=Vector2.new(tp.X-Wd/2-6,bp.Y-H*hp),Color=Color3.fromRGB(80,255,80),Thickness=1,Filled=true,Visible=true})) end
  if CFG.dist then table.insert(D,ND("Text",{Text=string.format("[%d]",math.floor(d)),Position=Vector2.new(tp.X,bp.Y+4),Size=12,Center=true,Color=Color3.fromRGB(200,200,200),Outline=true,Visible=true})) end
  if CFG.trc then table.insert(D,ND("Line",{From=Vector2.new(cam.ViewportSize.X/2,cam.ViewportSize.Y),To=Vector2.new(tp.X,tp.Y),Color=col,Thickness=1,Visible=true})) end
  if CFG.skel then
   local names={"Head","UpperTorso","LowerTorso","LeftHand","RightHand","LeftFoot","RightFoot"}
   local pts={}
   for _,n in ipairs(names) do local p=pl.Character:FindFirstChild(n) if p then local s,o=R.w2s(p.Position) if o then pts[n]=s end end end
   for _,pr in ipairs({{"Head","UpperTorso"},{"UpperTorso","LowerTorso"},{"UpperTorso","LeftHand"},{"UpperTorso","RightHand"},{"LowerTorso","LeftFoot"},{"LowerTorso","RightFoot"}}) do
    local a,b=pts[pr[1]],pts[pr[2]] if a and b then table.insert(D,ND("Line",{From=a,To=b,Color=col,Thickness=1,Visible=true})) end
   end
  end
 end
end) end
local function stESP() KC("esp") CD() end

--=========== target ===========
local function tgt(fov,igf)
 local cam=workspace.CurrentCamera
 local ctr=Vector2.new(cam.ViewportSize.X/2,cam.ViewportSize.Y/2)
 local ms=UI:GetMouseLocation()
 local best,bd=nil,igf and math.huge or (fov or 150)
 for _,pl in ipairs(P:GetPlayers()) do
  if pl==LP then continue end
  if CFG.tc and not R.enemy(pl) then continue end
  local h,r,hd=R.cp(pl) if not h or not r or h.Health<=0 then continue end
  local pt=CFG.part=="Head" and hd or r
  if CFG.part=="Random" then pt=math.random()<0.5 and hd or r end
  if not pt then continue end
  if CFG.wc then
   local o=cam.CFrame.Position local dr=pt.Position-o
   local hit=workspace:FindPartOnRayWithIgnoreList(Ray.new(o,dr),{LP.Character})
   if hit and not hit:IsDescendantOf(pl.Character) then continue end
  end
  local s,o=R.w2s(pt.Position) if not o then continue end
  local d=(s-ms).Magnitude
  if d<bd then bd=d best=pt end
 end
 return best
end

--=========== aimbot ===========
local function sAIM() if C.aim then return end
C.aim=RS.RenderStepped:Connect(function()
 if not CFG.aim then return end
 local t=tgt(CFG.fov,false) if not t then return end
 local cam=workspace.CurrentCamera
 local ctr=Vector2.new(cam.ViewportSize.X/2,cam.ViewportSize.Y/2)
 local s=R.w2s(t.Position) local d=s-ctr local sm=CFG.sm/100
 cam.CFrame=cam.CFrame*CFrame.new(d.X*sm*0.01,d.Y*sm*0.01,0)
end) end
local function stAIM() KC("aim") end

--=========== silent ===========
local function sSIL() if C.sil then return end
C.sil=RS.RenderStepped:Connect(function()
 if not CFG.sil then return end
 if not UI:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then return end
 local t=tgt(nil,true) if not t then return end
 local cam=workspace.CurrentCamera
 local ctr=Vector2.new(cam.ViewportSize.X/2,cam.ViewportSize.Y/2)
 local s=R.w2s(t.Position) local d=s-ctr
 if mousemoverel then mousemoverel(d.X,d.Y) end
end) end
local function stSIL() KC("sil") end

--=========== trigger ===========
local function sTRG() if C.trg then return end
C.trg=RS.RenderStepped:Connect(function()
 if not CFG.trig then return end
 local t=tgt(20,true) if t and mouse1click then mouse1click() end
end) end
local function stTRG() KC("trg") end

--=========== ragebot ===========
local RG={orig=nil}
local function sRG() if C.rage then return end
local ch=LP.Character if ch then local h=ch:FindFirstChild("HumanoidRootPart") if h then RG.orig=h.Position end end
C.rage=RS.Heartbeat:Connect(function()
 if not CFG.rage then return end
 local ch2=LP.Character if not ch2 then return end
 local h=ch2:FindFirstChild("HumanoidRootPart") if not h then return end
 local o=RG.orig or h.Position local a=math.random()*math.pi*2 local d=CFG.rrange
 h.CFrame=CFrame.new(o+Vector3.new(math.cos(a)*d,0,math.sin(a)*d))
 h.AssemblyLinearVelocity=Vector3.zero h.AssemblyAngularVelocity=Vector3.zero
 local t=tgt(nil,true)
 if t then
  local cam=workspace.CurrentCamera
  local ctr=Vector2.new(cam.ViewportSize.X/2,cam.ViewportSize.Y/2)
  local s=R.w2s(t.Position) local dl=s-ctr
  if mousemoverel then mousemoverel(dl.X,dl.Y) end
  if CFG.raf and mouse1click then mouse1click() end
 end
end) end
local function stRG() KC("rage") local ch=LP.Character if ch and RG.orig then local h=ch:FindFirstChild("HumanoidRootPart") if h then h.CFrame=CFrame.new(RG.orig) end end end

--=========== weapon ===========
local function sIA() if C.ia then return end
C.ia=RS.Heartbeat:Connect(function()
 if not CFG.ia then return end
 local t=R.tool() if not t then return end
 local a,m=R.ammo(t) if a and m and a.Value<m.Value then a.Value=m.Value end
end) end
local function stIA() KC("ia") end

local function sRP() if C.rp then return end
C.rp=RS.Heartbeat:Connect(function()
 if not CFG.rapid then return end
 if not UI:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then return end
 local t=R.tool() if not t then return end
 for _=1,CFG.rm do pcall(function() t:Activate() end) end
end) end
local function stRP() KC("rp") end

local function sNR() if C.nr then return end
C.nr=RS.RenderStepped:Connect(function()
 if not CFG.nr then return end
 local t=R.tool() if not t then return end
 for _,c in ipairs(t:GetChildren()) do if c:IsA("NumberValue") and (c.Name:lower():find("recoil") or c.Name:lower():find("spread")) then c.Value=0 end end
end) end
local function stNR() KC("nr") end

--=========== movement ===========
local fv,fg
local function sFLY() if C.fly then return end
local ch=LP.Character if not ch then return end
local r=ch:FindFirstChild("HumanoidRootPart") if not r then return end
fv=Instance.new("BodyVelocity") fv.MaxForce=Vector3.new(1e5,1e5,1e5) fv.Velocity=Vector3.zero fv.Parent=r
fg=Instance.new("BodyGyro") fg.MaxTorque=Vector3.new(1e5,1e5,1e5) fg.P=1e4 fg.Parent=r
C.fly=RS.RenderStepped:Connect(function()
 if not CFG.fly then if fv then fv.Velocity=Vector3.zero end return end
 local ch2=LP.Character if not ch2 then return end
 local r2=ch2:FindFirstChild("HumanoidRootPart") if not r2 then return end
 if fv.Parent~=r2 then fv.Parent=r2 end if fg.Parent~=r2 then fg.Parent=r2 end
 local cam=workspace.CurrentCamera local d=Vector3.zero
 if UI:IsKeyDown(Enum.KeyCode.W) then d+=cam.CFrame.LookVector end
 if UI:IsKeyDown(Enum.KeyCode.S) then d-=cam.CFrame.LookVector end
 if UI:IsKeyDown(Enum.KeyCode.A) then d-=cam.CFrame.RightVector end
 if UI:IsKeyDown(Enum.KeyCode.D) then d+=cam.CFrame.RightVector end
 if UI:IsKeyDown(Enum.KeyCode.Space) then d+=Vector3.new(0,1,0) end
 if UI:IsKeyDown(Enum.KeyCode.LeftControl) then d-=Vector3.new(0,1,0) end
 if d.Magnitude>0 then d=d.Unit*CFG.fs end
 fv.Velocity=d fg.CFrame=cam.CFrame
end) end
local function stFLY() KC("fly") if fv then fv:Destroy() fv=nil end if fg then fg:Destroy() fg=nil end end

local function sSPD() if C.spd then return end
C.spd=RS.Heartbeat:Connect(function()
 if not CFG.spd then return end
 local ch=LP.Character if not ch then return end
 local h=ch:FindFirstChildOfClass("Humanoid")
 if h then h.WalkSpeed=CFG.abj and (CFG.spv+(math.random()-0.5)*2) or CFG.spv end
end) end
local function stSPD() KC("spd") local ch=LP.Character if ch then local h=ch:FindFirstChildOfClass("Humanoid") if h then h.WalkSpeed=16 end end end

local function sNC() if C.nc then return end
C.nc=RS.Stepped:Connect(function()
 if not CFG.nc then return end
 local ch=LP.Character if not ch then return end
 for _,p in ipairs(ch:GetDescendants()) do if p:IsA("BasePart") and p.CanCollide then p.CanCollide=false end end
end) end
local function stNC() KC("nc") end

local function sIJ() if C.ij then return end
C.ij=UI.JumpRequest:Connect(function()
 if not CFG.ij then return end
 local ch=LP.Character if not ch then return end
 local h=ch:FindFirstChildOfClass("Humanoid")
 if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
end) end
local function stIJ() KC("ij") end

local function sBH() if C.bh then return end
C.bh=RS.Heartbeat:Connect(function()
 if not CFG.bh then return end
 local ch=LP.Character if not ch then return end
 local h=ch:FindFirstChildOfClass("Humanoid")
 if h and h.FloorMaterial~=Enum.Material.Air then h:ChangeState(Enum.HumanoidStateType.Jumping) end
end) end
local function stBH() KC("bh") end

--=========== visual ===========
local function sNF() if C.nf then return end
C.nf=RS.RenderStepped:Connect(function()
 if not CFG.nf then return end
 for _,c in ipairs(LT:GetChildren()) do if c:IsA("ColorCorrectionEffect") then c.Brightness=0 c.Contrast=0 c.Saturation=0 end end
end) end
local function stNF() KC("nf") end

local function sNG() if C.nog then return end
C.nog=RS.Heartbeat:Connect(function()
 if CFG.nofog then LT.FogEnd=1e6 LT.FogStart=1e6 end
end) end
local function stNG() KC("nog") end

local function sFB() if C.fb then return end
C.fb=RS.Heartbeat:Connect(function()
 if CFG.fb then LT.Ambient=Color3.fromRGB(178,178,178) LT.OutdoorAmbient=Color3.fromRGB(178,178,178) LT.Brightness=3 end
end) end
local function stFB() KC("fb") end

local function aFOV() workspace.CurrentCamera.FieldOfView=CFG.fovch and CFG.fovv or 70 end

--=========== antirage + voidspam ===========
local VS={act=false,orig=nil,lt=0,tg=false}
local function sVS() if VS.act then return end
local ch=LP.Character if not ch then return end
local h=ch:FindFirstChild("HumanoidRootPart") if not h then return end
VS.act=true VS.orig=h.Position VS.tg=false
C.vs=RS.Heartbeat:Connect(function()
 if not VS.act then return end
 local ch2=LP.Character if not ch2 then return end
 local h2=ch2:FindFirstChild("HumanoidRootPart") if not h2 then return end
 local n=tick() if n-VS.lt<CFG.ari then return end
 VS.lt=n VS.tg=not VS.tg
 if VS.tg then
  local o=VS.orig or h2.Position local a=math.random()*math.pi*2 local d=math.random(50,CFG.arr)
  h2.CFrame=CFrame.new(o+Vector3.new(math.cos(a)*d,math.random(-20,20),math.sin(a)*d))
 else if VS.orig then h2.CFrame=CFrame.new(VS.orig) end end
 h2.AssemblyLinearVelocity=Vector3.zero h2.AssemblyAngularVelocity=Vector3.zero
end) end
local function stVS() KC("vs") VS.act=false
local ch=LP.Character if ch and VS.orig then local h=ch:FindFirstChild("HumanoidRootPart") if h then h.CFrame=CFrame.new(VS.orig) end end end

local function sAR() if C.ar then return end
if CFG.arvs then sVS() end
C.ar=RS.Heartbeat:Connect(function()
 if not CFG.ar then return end
 if CFG.arhl then
  local ch=LP.Character if ch then local h=ch:FindFirstChildOfClass("Humanoid") if h and h.Health<h.MaxHealth then h.Health=h.MaxHealth end end
 end
end) end
local function stAR() KC("ar") if CFG.arvs then stVS() end end

--=========== skin changer ===========
local SC={eq={},fav={},fc={},rdy=false}
pcall(function()
 local reps=game:GetService("ReplicatedStorage") local lps=LP.PlayerScripts local ctrls=lps.Controllers local rmods=reps.Modules
 local elib=require(rmods:WaitForChild("EnumLibrary",10)) if elib then elib:WaitForEnumBuilder() end
 local clib=require(rmods:WaitForChild("CosmeticLibrary",10))
 local ilib=require(rmods:WaitForChild("ItemLibrary",10))
 local dctrl=require(ctrls:WaitForChild("PlayerDataController",10))
 local coss=clib.Cosmetics
 local cdata=dctrl.CurrentData
 local function ban(n) if type(n)~="string" then return true end return n:find("MISSING_") or n:find("Bubblegum") or n:find("Ragdoll") or n:find("Fall Apart") or n:find("Every Finisher Ever") end
 local function te(n) if not elib then return nil end local ok,id=pcall(elib.ToEnum,elib,n) return ok and id or nil end
 local function cc(name,ctype,inv,fav)
  if ban(name) then return nil end
  local base=coss[name] if not base then return nil end
  local d=table.clone(base) d.Name=name d.Type=d.Type or ctype d.Seed=d.Seed or math.random(1,1000000)
  local eid=te(name) if eid then d.Enum=eid d.ObjectID=d.ObjectID or eid end
  if inv~=nil then d.Inverted=inv end if fav~=nil then d.OnlyUseFavorites=fav end
  return d
 end
 local sf="SkinChanger/config.json"
 local function sc()
  if not writefile then return end
  pcall(function()
   local cf={equipped={},favorites=SC.fav}
   for w,c in pairs(SC.eq) do local s={} cf.equipped[w]=s for ct,cd in pairs(c) do if cd and cd.Name and not ban(cd.Name) then s[ct]={name=cd.Name,seed=cd.Seed,inverted=cd.Inverted} end end end
   if makefolder and not isfolder("SkinChanger") then makefolder("SkinChanger") end
   writefile(sf,HS:JSONEncode(cf))
  end)
 end
 local function lc()
  if not readfile or not isfile or not isfile(sf) then return end
  pcall(function()
   local cf=HS:JSONDecode(readfile(sf))
   if cf.equipped then for w,c in pairs(cf.equipped) do SC.eq[w]={} for ct,cd in pairs(c) do if not ban(cd.name) then local cl=cc(cd.name,ct,cd.inverted) if cl then cl.Seed=cd.seed SC.eq[w][ct]=cl end end end end end
   SC.fav=cf.favorites or {}
  end)
 end
 local finv={}
 local function ri() table.clear(finv) for n in pairs(coss) do if not ban(n) then finv[n]=true end end for _,c in pairs(SC.eq) do for _,cd in pairs(c) do if cd and cd.Name and not ban(cd.Name) then finv[cd.Name]=true end end end end
 ri()
 local og=dctrl.Get
 dctrl.Get=function(self,key)
  local data=og(self,key)
  if key=="CosmeticInventory" then local px={} if data then for k,v in pairs(data) do if not ban(k) then px[k]=v end end end for n in pairs(finv) do px[n]=true end return px end
  if key=="FavoritedCosmetics" then local res=data and table.clone(data) or {} for w,f in pairs(SC.fav) do local s=res[w] or {} res[w]=s for n,if_ in pairs(f) do if not ban(n) then s[n]=if_ end end end return res end
  return data
 end
 local ogw=dctrl.GetWeaponData
 dctrl.GetWeaponData=function(self,wn)
  local d=ogw(self,wn) if not d then return nil end
  local m=table.clone(d) m.Name=wn local we=SC.eq[wn] if we then for ct,cd in pairs(we) do m[ct]=cd end end return m
 end
 local function sr(k) pcall(function() if not cdata and dctrl.CurrentData then cdata=dctrl.CurrentData end if cdata then cdata:Replicate(k) end end) end
 local fc pcall(function() fc=require(ctrls:WaitForChild("FighterController",10)) end)
 if hookmetamethod then
  local rems=reps:FindFirstChild("Remotes") local dr=rems and rems:FindFirstChild("Data")
  local eq=dr and dr:FindFirstChild("EquipCosmetic") local fv=dr and dr:FindFirstChild("FavoriteCosmetic")
  if eq then
   local oc
   oc=hookmetamethod(game,"__namecall",function(self,...)
    if getnamecallmethod()~="FireServer" then return oc(self,...) end
    local ar={...}
    if self==eq then
     local wn,ct,cn,op=ar[1],ar[2],ar[3],ar[4] or {}
     if not cn or cn=="None" or cn=="" then SC.eq[wn]=SC.eq[wn] or {} SC.eq[wn][ct]=nil if not next(SC.eq[wn]) then SC.eq[wn]=nil end ri() task.defer(function() sr("WeaponInventory") task.wait(0.2) sc() end) return oc(self,...) end
     if ban(cn) then return oc(self,...) end
     SC.eq[wn]=SC.eq[wn] or {}
     local cl=cc(cn,ct,op.IsInverted,op.OnlyUseFavorites) if cl then SC.eq[wn][ct]=cl end
     if ct=="Finisher" then SC.fc[wn]=cn end
     ri() task.defer(function() sr("WeaponInventory") task.wait(0.2) sc() end) return
    end
    if self==fv then local fw,fn,fs=ar[1],ar[2],ar[3] if not fn or fn=="None" or fn=="" then return oc(self,...) end if ban(fn) then return oc(self,...) end SC.fav[fw]=SC.fav[fw] or {} SC.fav[fw][fn]=fs or nil sc() task.spawn(sr,"FavoritedCosmetics") return end
    return oc(self,...)
   end)
  end
 end
 lc() ri() SC.rdy=true
end)

--=========== impersonate ===========
local IMP={act=false,uid=0,dn="",orig=nil}
local function clearImp()
 local ch=LP.Character if not ch then return end
 for _,a in ipairs(IMP.applied or {}) do pcall(function() a:Destroy() end) end
 IMP.applied={}
 local h=ch:FindFirstChildOfClass("Humanoid") if h and IMP.orig then h.DisplayName=IMP.orig IMP.orig=nil end
 IMP.act=false
end
local function applyImp(uid,dn)
 clearImp() if uid<=0 then return end
 local ch=LP.Character if not ch then return end
 local h=ch:FindFirstChildOfClass("Humanoid") if not h then return end
 IMP.orig=h.DisplayName IMP.uid=uid if dn and dn~="" then h.DisplayName=dn IMP.dn=dn end
 IMP.applied=IMP.applied or {}
 task.spawn(function()
  local ok,app=pcall(function() return P:GetCharacterAppearanceAsync(uid) end)
  if not ok or not app then return end
  for _,c in ipairs(ch:GetChildren()) do
   if c:IsA("Accessory") or c:IsA("Shirt") or c:IsA("Pants") or c:IsA("ShirtGraphic") or c.ClassName=="BodyColors" then
    IMP.applied[#IMP.applied+1]=c c.Parent=nil
   end
  end
  for _,inst in ipairs(app) do
   if inst:IsA("Accessory") or inst:IsA("Shirt") or inst:IsA("Pants") or inst:IsA("ShirtGraphic") or inst.ClassName=="BodyColors" then
    local cl=inst:Clone() cl.Parent=ch IMP.applied[#IMP.applied+1]=cl
   end
  end
  IMP.act=true
 end)
end

--=========== banware ===========
local BW={v_en=false,vd=1.0,sx=1e7,sy=0,sz=1e7,vm="Static",vmp="None",vms=10,vef=10000,
 r_en=false,rd=10,rh=0,rur=0.5,
 aa_en=false,aap="None",aar=45,aat="None",aas=1500,
 snd="None",sv=1,hud=true,
 vo=nil,rt=nil,rlt=0,anga=0,sw=1,el=0}
local SS={None=nil,Whoosh="rbxasset://sounds/impact_water.mp3",Glitch="rbxasset://sounds/electronicpingshort.wav",Bass="rbxasset://sounds/swoosh.wav",Pulse="rbxasset://sounds/switch.wav",Static="rbxasset://sounds/collision.wav"}
local SSvc=game:GetService("SoundService") local aS={} local sKA=false local sLC=nil
local function wS() for _,s in ipairs(aS) do pcall(function() s:Stop() s:Destroy() end) end aS={} if sLC then pcall(function() sLC:Disconnect() end) sLC=nil end sKA=false end
local function sBS()
 wS() if BW.snd=="None" then return end
 local id=SS[BW.snd] if not id then return end
 sKA=true
 local s=Instance.new("Sound") s.SoundId=id s.Volume=BW.sv s.Looped=true s.Parent=SSvc s:Play() table.insert(aS,s)
 sLC=RS.Heartbeat:Connect(function() if sKA and s and s.Parent and not s.IsPlaying then pcall(function() s:Play() end) end end)
end
local function sV()
 if C.v then return end
 C.v=RS.Heartbeat:Connect(function(dt)
  if not BW.v_en then return end
  local ch=LP.Character if not ch then return end
  local h=ch:FindFirstChild("HumanoidRootPart") if not h then return end
  if not BW.vo then BW.vo=h.Position end
  BW.el=BW.el+dt
  local pct=math.clamp(BW.vd,0,1)
  local xm=math.clamp(math.abs(BW.sx)*pct,0,1e7) local ym=math.clamp(math.abs(BW.sy)*pct,0,1e7) local zm=math.clamp(math.abs(BW.sz)*pct,0,1e7)
  local ox,oy,oz=0,0,0
  local m=BW.vm
  if m=="Fixed" then ox=BW.sx*BW.vd oy=BW.sy*BW.vd oz=BW.sz*BW.vd
  elseif m=="Endpoints" then ox=(math.random(0,1)==1 and 1 or -1)*xm oy=(ym>0) and ((math.random(0,1)==1 and 1 or -1)*ym) or 0 oz=(math.random(0,1)==1 and 1 or -1)*zm
  elseif m=="Quantum" then local s=math.random(0,1)==1 and 1 or -1 ox=s*xm*(0.7+math.random()*0.3) oy=(math.random()*2-1)*ym oz=s*zm*(0.7+math.random()*0.3)
  elseif m=="Drift" then ox=math.noise(BW.el*0.2,1.1)*2*xm oy=math.noise(2.2,BW.el*0.15)*2*ym oz=math.noise(BW.el*0.18,BW.el*0.12)*2*zm
  elseif m=="Loop" then local r=math.max(xm,zm) ox=math.cos(BW.el*3)*r oy=math.sin(BW.el*1.5)*ym oz=math.sin(BW.el*3)*r
  elseif m=="Spiral" then local r=math.max(xm,zm)*(0.25+0.75*math.abs(math.sin(BW.el*0.5))) ox=math.cos(BW.el*4)*r oy=math.sin(BW.el*0.8)*ym oz=math.sin(BW.el*4)*r
  else ox=(math.random()*2-1)*xm oy=(math.random()*2-1)*ym oz=(math.random()*2-1)*zm end
  local b=BW.vo or Vector3.zero
  local tp=Vector3.new(b.X+ox,b.Y+oy,b.Z+oz)
  local pt=BW.vmp
  if pt=="Spin" then local a=BW.el*BW.vms*0.08 local r=math.min(BW.vef,1e5) tp=tp+Vector3.new(math.cos(a)*r,0,math.sin(a)*r)
  elseif pt=="Orbit" then local a=BW.el*BW.vms*0.05 local r=math.min(BW.vef,2e5) tp=tp+Vector3.new(math.cos(a)*r,math.sin(a*0.4)*r*0.2,math.sin(a)*r)
  elseif pt=="Random" then local r=math.min(BW.vef,3e5) tp=tp+Vector3.new((math.random()-0.5)*r,(math.random()-0.5)*r*0.4,(math.random()-0.5)*r)
  elseif pt=="Desync" then local a=BW.el*BW.vms*0.12 local r=math.min(BW.vef,25e4) tp=tp+Vector3.new(math.sin(a)*r,math.cos(a*1.4)*r*0.35,math.sin(a*0.6)*r)
  elseif pt=="Erratic" then local r=math.min(BW.vef*1.5,5e5) tp=tp+Vector3.new((math.random()-0.5)*r,(math.random()-0.5)*r*0.5,(math.random()-0.5)*r) end
  h.CFrame=CFrame.new(tp)
  h.AssemblyLinearVelocity=Vector3.zero h.AssemblyAngularVelocity=Vector3.zero
 end)
end
local function stV() KC("v") local ch=LP.Character if ch and BW.vo then local h=ch:FindFirstChild("HumanoidRootPart") if h then h.CFrame=CFrame.new(BW.vo) end end BW.vo=nil end

local function gCE()
 local ch=LP.Character if not ch then return nil end
 local r=ch:FindFirstChild("HumanoidRootPart") if not r then return nil end
 local best,bd=nil,math.huge
 for _,pl in ipairs(P:GetPlayers()) do if pl==LP then continue end local h,t=R.cp(pl) if h and t and h.Health>0 then local d=(r.Position-t.Position).Magnitude if d<bd then bd=d best=pl end end end
 return best
end
local function sR()
 if C.r then return end
 BW.rlt=0 BW.rt=nil
 C.r=RS.RenderStepped:Connect(function()
  if not BW.r_en then return end if BW.v_en then return end
  local ch=LP.Character if not ch then return end
  local h=ch:FindFirstChild("HumanoidRootPart") if not h then return end
  local n=tick()
  if (n-BW.rlt)>=BW.rur or not BW.rt or not BW.rt.Parent then BW.rt=gCE() BW.rlt=n end
  if not BW.rt then return end
  local tc=BW.rt.Character if not tc then return end
  local tr=tc:FindFirstChild("HumanoidRootPart") local th=tc:FindFirstChildOfClass("Humanoid")
  if not tr or not th or th.Health<=0 then BW.rt=nil return end
  local lk=tr.CFrame.LookVector
  local bh=Vector3.new(-lk.X,0,-lk.Z)
  if bh.Magnitude<0.05 then bh=Vector3.new(0,0,-1) else bh=bh.Unit end
  local tp=tr.Position+bh*BW.rd+Vector3.new(0,BW.rh,0)
  h.CFrame=CFrame.new(tp,tr.Position)
  h.AssemblyLinearVelocity=Vector3.zero h.AssemblyAngularVelocity=Vector3.zero
  local hm=ch:FindFirstChildOfClass("Humanoid") if hm then hm.WalkSpeed=0 hm.JumpPower=0 hm.JumpHeight=0 end
 end)
end
local function stR() KC("r") BW.rt=nil local ch=LP.Character if ch then local h=ch:FindFirstChildOfClass("Humanoid") if h then h.WalkSpeed=16 h.JumpPower=50 h.JumpHeight=7.2 end end end

local function sAA()
 if C.aa then return end
 BW.anga=0 BW.sw=1
 C.aa=RS.RenderStepped:Connect(function(dt)
  if not BW.aa_en then return end
  local ch=LP.Character if not ch then return end
  local h=ch:FindFirstChild("HumanoidRootPart") if not h then return end
  if BW.v_en or BW.r_en then return end
  local pit=0 local p=BW.aap
  if p=="Up" then pit=math.rad(-89) elseif p=="Down" then pit=math.rad(89) elseif p=="Flip" then pit=math.rad((math.random()>0.5) and -89 or 89) end
  local yw=0 local t=BW.aat local sp=BW.aas local rt=BW.aar
  if t=="Spin" then BW.anga=(BW.anga+sp*dt*0.1)%360 yw=math.rad(BW.anga)
  elseif t=="Jitter" then yw=math.rad((math.random()>0.5 and 1 or -1)*rt)
  elseif t=="Sway" then BW.anga=BW.anga+sp*dt*0.05*BW.sw if BW.anga>=rt then BW.anga=rt BW.sw=-1 elseif BW.anga<=-rt then BW.anga=-rt BW.sw=1 end yw=math.rad(BW.anga)
  elseif t=="Inverter" then BW.anga=BW.anga+sp*dt*0.08 yw=math.rad((BW.anga%2<1) and rt or (rt+180)) end
  h.CFrame=CFrame.new(h.Position)*CFrame.Angles(pit,yw,0)
 end)
end
local function stAA() KC("aa") end

--=========== antiban ===========
local AB={oi=0,hm=false}
pcall(function() if getthreadidentity then AB.oi=getthreadidentity() elseif getidentity then AB.oi=getidentity() end end)
function AB.ri() if AB.oi>0 then if setthreadidentity then pcall(setthreadidentity,AB.oi) elseif setidentity then pcall(setidentity,AB.oi) end end end
function AB.sw(t) return t+(math.random()-0.5)*2 end
if hookmetamethod and getrawmetatable and setreadonly and newcclosure and getnamecallmethod and checkcaller then
 pcall(function()
  local mt=getrawmetatable(game) local o=mt.__namecall setreadonly(mt,false)
  mt.__namecall=newcclosure(function(self,...)
   local m=getnamecallmethod()
   if m=="Kick" or m=="Teleport" then if not checkcaller() then return nil end end
   return o(self,...)
  end)
  setreadonly(mt,true) AB.hm=true
 end)
end
task.spawn(function() while task.wait(5+math.random()*3) do AB.ri() end end)

--=========== autoload / hop ===========
local CDIR="TSHub/configs" local ALF="TSHub/_autoload.txt"
local function sAL()
 if not writefile or not isfile then R.nt("Need writefile",3); return end
 pcall(function() if makefolder and not isfolder("autoexec") then makefolder("autoexec") end writefile("autoexec/tshub.lua",string.format([[loadstring(game:HttpGet("%s"))()]],CFG.hub)) end)
 R.nt("Auto load installed",2)
end
local function rAL() pcall(function() if delfile and isfile and isfile("autoexec/tshub.lua") then delfile("autoexec/tshub.lua") end end) R.nt("Removed",2) end
local function hop()
 local url="https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
 local ok,res=pcall(function() return HS:JSONDecode(game:HttpGet(url)) end)
 if not ok or not res or not res.data then R.nt("Hop failed",3); return end
 local lst={} for _,s in ipairs(res.data) do if s.playing<s.maxPlayers and s.id~=game.JobId then table.insert(lst,s.id) end end
 if #lst==0 then R.nt("No servers",3); return end
 local tg=lst[math.random(1,#lst)]
 local ld=string.format([[loadstring(game:HttpGet("%s"))()]],CFG.hub)
 if queue_on_teleport then pcall(function() queue_on_teleport(ld) end) elseif queueonteleport then pcall(function() queueonteleport(ld) end) end
 R.nt("Hopping...",2) task.wait(0.5)
 TS:TeleportToPlaceInstance(game.PlaceId,tg,LP)
end

--=========== config ===========
local CM={}
function CM.ed() if not makefolder then return end pcall(function() if not isfolder("TSHub") then makefolder("TSHub") end if not isfolder(CDIR) then makefolder(CDIR) end end) end
function CM.ls()
 local o={} if not listfiles then return o end CM.ed()
 pcall(function() for _,f in ipairs(listfiles(CDIR)) do local n=f:match("([^/\\]+)%.json$") if n then table.insert(o,n) end end end)
 return o
end
function CM.sv(n) if not n or n=="" then R.nt("Name required",2); return end n=n:gsub("%s+","_"):gsub("[^%w_%-]","") CM.ed() local ok=pcall(function() SM:Save(n) end) R.nt(ok and ("Saved: "..n) or "Save failed",2) end
function CM.ld(n) if not n or n=="" then return end local ok=pcall(function() SM:Load(n) end) R.nt(ok and ("Loaded: "..n) or "Load failed",2) end
function CM.dl(n) if not n or n=="" then return end pcall(function() if SM.Delete then SM:Delete(n) elseif delfile and isfile then local p=CDIR.."/"..n..".json" if isfile(p) then delfile(p) end end end) if CM.gl()==n then CM.sl("") end R.nt("Deleted: "..n,2) end
function CM.sl(n) if not writefile then return end CM.ed() pcall(function() writefile(ALF,n or "") end) R.nt(n=="" and "Cleared" or ("Auto load: "..n),2) end
function CM.gl() if not readfile or not isfile then return "" end if not isfile(ALF) then return "" end local ok,c=pcall(function() return readfile(ALF) end) if not ok or not c then return "" end return c:gsub("%s","") end
function CM.al() local n=CM.gl() if n=="" then return end task.defer(function() task.wait(0.5) CM.ld(n) end) end

--=========== UI ===========
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
CR:AddSlider('b4',{Text='Void Range',Default=800,Min=100,Max=5000,Rounding=0,Callback=function(v) CFG.rrange=v end})
CR:AddToggle('b5',{Text='Trigger Bot',Default=false,Callback=function(v) CFG.trig=v if v then sTRG() else stTRG() end end})

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

local ML=T.M:AddLeftGroupbox('Fly / Speed')
ML:AddToggle('f1',{Text='Fly',Default=false,Callback=function(v) CFG.fly=v if v then sFLY() else stFLY() end end})
ML:AddSlider('f2',{Text='Fly Speed',Default=80,Min=20,Max=400,Rounding=0,Callback=function(v) CFG.fs=v end})
ML:AddToggle('f3',{Text='Speed',Default=false,Callback=function(v) CFG.spd=v if v then sSPD() else stSPD() end end})
ML:AddSlider('f4',{Text='Walk Speed',Default=60,Min=16,Max=300,Rounding=0,Callback=function(v) CFG.spv=v end})

local MR=T.M:AddRightGroupbox('Noclip / Jump')
MR:AddToggle('g1',{Text='Noclip',Default=false,Callback=function(v) CFG.nc=v if v then sNC() else stNC() end end})
MR:AddToggle('g2',{Text='Inf Jump',Default=false,Callback=function(v) CFG.ij=v if v then sIJ() else stIJ() end end})
MR:AddToggle('g3',{Text='BHop',Default=false,Callback=function(v) CFG.bh=v if v then sBH() else stBH() end end})

local AL=T.AR:AddLeftGroupbox('Anti-Rage')
AL:AddToggle('h1',{Text='Enable Anti-Rage',Default=false,Callback=function(v) CFG.ar=v if v then sAR() else stAR() end end})
AL:AddToggle('h2',{Text='Health Lock',Default=true,Callback=function(v) CFG.arhl=v end})
AL:AddToggle('h3',{Text='Auto Void Spam',Default=false,Callback=function(v) CFG.arvs=v end})

local ARR=T.AR:AddRightGroupbox('Void Spam')
ARR:AddToggle('i1',{Text='Enable Void Spam',Default=false,Callback=function(v) if v then sVS() R.nt('VS ON',2) else stVS() R.nt('VS OFF',2) end end})
ARR:AddSlider('i2',{Text='Interval (ms)',Default=80,Min=10,Max=500,Rounding=0,Callback=function(v) CFG.ari=v/1000 end})
ARR:AddSlider('i3',{Text='Range',Default=300,Min=50,Max=2000,Rounding=0,Callback=function(v) CFG.arr=v end})

local SKL=T.SK:AddLeftGroupbox('Impersonate (local)')
SKL:AddInput('j1',{Text='User ID',Default='',Placeholder='12345678',Numeric=true})
SKL:AddInput('j2',{Text='Display Name',Default='',Placeholder='optional'})
SKL:AddButton('Apply',function() local id=tonumber(Options.j1 and Options.j1.Value or '0') or 0 local dn=Options.j2 and Options.j2.Value or '' if id<=0 then R.nt("Enter userId",2) return end applyImp(id,dn) end)
SKL:AddButton('Clear',function() clearImp() R.nt("Cleared",2) end)

local BWL=T.BW:AddLeftGroupbox('Void Hide')
BWL:AddToggle('k1',{Text='Enable Void',Default=false,Callback=function(v) BW.v_en=v if v then sV() sBS() else stV() wS() end end})
BWL:AddSlider('k2',{Text='Void Distance %',Default=100,Min=0,Max=100,Rounding=0,Callback=function(v) BW.vd=v/100 end})
BWL:AddSlider('k3',{Text='Set X',Default=1e7,Min=-1e7,Max=1e7,Rounding=0,Callback=function(v) BW.sx=v end})
BWL:AddSlider('k4',{Text='Set Y',Default=0,Min=-1e7,Max=1e7,Rounding=0,Callback=function(v) BW.sy=v end})
BWL:AddSlider('k5',{Text='Set Z',Default=1e7,Min=-1e7,Max=1e7,Rounding=0,Callback=function(v) BW.sz=v end})
BWL:AddDropdown('k6',{Values={'Static','Fixed','Endpoints','Random','Chaos','Quantum','Drift','Loop','Spiral'},Default=1,Text='Method',Callback=function(v) BW.vm=v end})

local BWR=T.BW:AddRightGroupbox('Motion / Riot / AA')
BWR:AddDropdown('l1',{Values={'None','Spin','Orbit','Random','Desync','Erratic'},Default=1,Text='Motion',Callback=function(v) BW.vmp=v end})
BWR:AddSlider('l2',{Text='Motion Speed',Default=10,Min=0,Max=10000,Rounding=0,Callback=function(v) BW.vms=v end})
BWR:AddSlider('l3',{Text='Effect Radius',Default=10000,Min=0,Max=214748364,Rounding=0,Callback=function(v) BW.vef=v end})
BWR:AddToggle('l4',{Text='Riot Abuser',Default=false,Callback=function(v) BW.r_en=v if v then sR() else stR() end end})
BWR:AddToggle('l5',{Text='Anti-Aim',Default=false,Callback=function(v) BW.aa_en=v if v then sAA() else stAA() end end})
BWR:AddDropdown('l6',{Values={'None','Up','Down','Flip'},Default=1,Text='AA Pitch',Callback=function(v) BW.aap=v end})
BWR:AddDropdown('l7',{Values={'None','Spin','Jitter','Sway','Inverter'},Default=1,Text='AA Type',Callback=function(v) BW.aat=v end})
BWR:AddSlider('l8',{Text='AA Speed',Default=1500,Min=0,Max=20000,Rounding=0,Callback=function(v) BW.aas=v end})
BWR:AddDropdown('l9',{Values={'None','Whoosh','Glitch','Bass','Pulse','Static'},Default=1,Text='Sound',Callback=function(v) BW.snd=v if BW.v_en then sBS() end end})

local ADL=T.AD:AddLeftGroupbox('Auto Load / Hop')
ADL:AddInput('m1',{Text='Hub URL',Default=CFG.hub,Placeholder='raw github url',Callback=function(v) CFG.hub=v end})
ADL:AddToggle('m2',{Text='Install Auto Load',Default=false,Callback=function(v) if v then sAL() else rAL() end end})
ADL:AddButton('Server Hop',function() hop() end)

local ADR=T.AD:AddRightGroupbox('Anti-Ban')
ADR:AddToggle('n1',{Text='Enable Anti-Ban',Default=true,Callback=function(v) CFG.ab=v if v then AB.ri() R.nt('AB ON',2) end end})
ADR:AddToggle('n2',{Text='Walkspeed Jitter',Default=true,Callback=function(v) CFG.abj=v end})
ADR:AddButton('Restore Identity',function() AB.ri() R.nt('Identity: '..tostring(AB.oi),2) end)

local SL=T.ST:AddLeftGroupbox('Config Manager')
SL:AddInput('o1',{Text='Config Name',Default='',Placeholder='my_config'})
local i0=CM.ls()
SL:AddDropdown('o2',{Values=#i0>0 and i0 or {'(none)'},Default=1,Text='Saved'})
SL:AddButton('Refresh',function() local l=CM.ls() pcall(function() if Options.o2 and Options.o2.SetValues then Options.o2:SetValues(#l>0 and l or {'(none)'}) end end) R.nt("Found "..#l,2) end)
SL:AddButton('Save',function() CM.sv(Options.o1 and Options.o1.Value or '') end)
SL:AddButton('Load',function() local n=Options.o2 and Options.o2.Value or '' if n=='(none)' then R.nt("None",2) return end CM.ld(n) end)
SL:AddButton('Delete',function() local n=Options.o2 and Options.o2.Value or '' if n=='(none)' then return end CM.dl(n) end)
SL:AddButton('Set Auto Load',function() local n=Options.o2 and Options.o2.Value or '' if n=='(none)' then R.nt("None",2) return end CM.sl(n) end)
SL:AddButton('Clear Auto Load',function() CM.sl("") end)
SL:AddLabel(function() local n=CM.gl() return n=="" and 'Auto: (none)' or ('Auto: '..n) end)

local SR=T.ST:AddRightGroupbox('UI')
SR:AddLabel('Menu'):AddKeyPicker('p1',{Default='RightShift',Text='Menu',Mode='Toggle',NoUI=false})
L.ToggleKeybind=Options.p1
SR:AddButton('Unload',function()
 stESP() stAIM() stSIL() stTRG() stRG() stIA() stRP() stNR()
 stFLY() stSPD() stNC() stIJ() stBH() stNF() stNG() stFB() stAR() stVS()
 stV() stR() stAA() wS() CD()
 L:Unload() _G.__TSH=false
end)

TM:SetLibrary(L) SM:SetLibrary(L)
TM:SetFolder('TSHub') SM:SetFolder('TSHub/configs')
SM:IgnoreThemeSettings() SM:SetIgnoreIndexes({'p1'})
pcall(function() SM:BuildConfigSection(T.ST) end)
pcall(function() TM:ApplyToTab(T.ST) end)
task.spawn(function() CM.al() end)
print("[TS Hub] Loaded")
