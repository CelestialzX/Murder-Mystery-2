--[[
XYZ HUB 
Created by CelestialzX
https://github.com/CelestialzX | For more scripts!
--]]

local Debug=false
local obfs=true

local PS = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local RS = game:GetService("RunService")
local WS = game:GetService("Workspace")
local CG = game:GetService("CoreGui")
local SS = game:GetService("SoundService")
local LP=PS.LocalPlayer
if not LP then repeat task.wait() LP=PS.LocalPlayer until LP end
local ENV=(not Debug and typeof(getgenv)=="function" and getgenv()) or _G
local SES=ENV.XYZ_HUB_SESSION
if type(SES)~="table" then SES={Settings={}};ENV.XYZ_HUB_SESSION=SES end
if type(SES.Settings)~="table" then SES.Settings={} end
local FN,ST={},{}
if typeof(SES.Kill)=="function" then pcall(SES.Kill,true) end
local function UIRoots(PG) local T={};PG=PG or LP:FindFirstChild("PlayerGui");if PG then T[#T+1]=PG end;if not Debug then local H=CG:FindFirstChild("HUI");if H then T[#T+1]=H end end;return T end
local function ClearHubUI(PG) for _,R in ipairs(UIRoots(PG)) do for _,V in ipairs(R:GetChildren()) do if V:IsA("ScreenGui") and (V:GetAttribute("XYZ_HUB_UI") or V:GetAttribute("XYZ_HUB_KEY")) then V:Destroy() end end end end
ClearHubUI()
local function SV(K,D) local V=SES.Settings[K];if V==nil then return D end return V end
ST.obfs=obfs
ST.Killed=false
ST.CN={}
ST.RNG=Random.new()
ST.CHARS="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_+-=[]{};:,.<>?/|~"
local function RN()
	local L,T=ST.RNG:NextInteger(8,15),{}
	for i=1,L do
		local N=ST.RNG:NextInteger(1,#ST.CHARS)
		T[i]=ST.CHARS:sub(N,N)
	end
	return table.concat(T)
end
local function New(C,P,N)
	local O=Instance.new(C)
	local UIObj=O:IsA("GuiObject") or O:IsA("LayerCollector") or O:IsA("UIComponent")
	O.Name=(ST.obfs and UIObj) and RN() or (N or C)
	if P then O.Parent=P end
	return O
end
local function C(S,F)
	local X=S:Connect(F)
	table.insert(ST.CN,X)
	return X
end
local function FindTag(P,A)
	if not P then return end
	for _,V in P:GetChildren() do
		if V:GetAttribute(A) then return V end
	end
end
ST.Roles,ST.Guns,ST.DeadPlayers={},{},{}
ST.Hero=nil
ST.GunRoleState={Sheriff=nil}
ST.BoxESP,ST.SkeletonESP,ST.InnocentESP,ST.GunESP,ST.AutoPick,ST.Picking,ST.GunTracer,ST.PlayerTracers=SV("BoxESP",true),SV("SkeletonESP",true),SV("InnocentESP",false),SV("GunESP",true),SV("AutoPick",false),false,SV("GunTracer",false),SV("PlayerTracers",false)
ST.MurderLock,ST.AutoLock,ST.AutoShoot,ST.AimHeld,ST.AimTarget,ST.AimRecording=SV("MurderLock",false),SV("AutoLock",false),SV("AutoShoot",false),false,nil,false
ST.AntiFling=SV("AntiFling",false)
ST.LowGFX=SV("LowGFX",false)
ST.NoClip=SV("NoClip",false)
ST.KnifeReach=SV("KnifeReach",false)
ST.AutoWinMurder=false
ST.AUTO_WIN_DISTANCE=3.5 -- studs behind target
ST.AUTO_WIN_WAIT_DEPTH=15 -- studs below saved home point
ST.FOVCircle=SV("FOVCircle",true)
ST.FOVSize=SV("FOVSize",80)
ST.SelfMurder=false
ST.LastShot=0
ST.AimKey=SV("AimKey",Enum.UserInputType.MouseButton2)
ST.UIHotkey={Key=SV("UIKey",Enum.KeyCode.R),Button=nil,Recording=false}
ST.KnifeHandleSize=SV("KnifeHandleSize",1)
local CTRL={}
local COL={SheriffFill=Color3.fromRGB(28,96,255),SheriffOutline=Color3.fromRGB(181,181,181),SheriffText=Color3.fromRGB(30,127,255),MurderFill=Color3.fromRGB(255,39,39),MurderOutline=Color3.fromRGB(255,39,39),MurderText=Color3.fromRGB(255,67,67),HeroFill=Color3.fromRGB(237,255,34),HeroOutline=Color3.fromRGB(237,255,34),HeroText=Color3.fromRGB(237,255,34),GunText=Color3.fromRGB(255,208,38),InnocentFill=Color3.fromRGB(147,255,46),InnocentOutline=Color3.fromRGB(147,255,46),InnocentText=Color3.fromRGB(147,255,46),ToggleOn=Color3.fromRGB(28,96,255),ToggleOff=Color3.fromRGB(62,62,62),OrbColor=Color3.fromRGB(235,235,235),TI=TweenInfo.new(.18,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)}
local UX={TabButtons={},TabLines={},TabTexts={},TabIcons={},MainOpen=true,FULL_H=250,TOP_H=40,TAB_H=32,MAIN_SCALE=1.1,MainIn=TweenInfo.new(.18,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),MainOut=TweenInfo.new(.12,Enum.EasingStyle.Quad,Enum.EasingDirection.In),Killing=false,AimRenderName="XYZ_AIM_"..tostring(ST.RNG:NextInteger(100000,999999))}
UX.SMALL_CONTROL_SCALE=.95/UX.MAIN_SCALE
local AW={}
local Collapsed=SV("Collapsed",false)
FN.SaveSettings=function()
	local S=SES.Settings;S.BoxESP=ST.BoxESP;S.SkeletonESP=ST.SkeletonESP;S.InnocentESP=ST.InnocentESP;S.GunESP=ST.GunESP;S.AutoPick=ST.AutoPick;S.GunTracer=ST.GunTracer;S.PlayerTracers=ST.PlayerTracers;S.MurderLock=ST.MurderLock;S.AutoLock=ST.AutoLock;S.AutoShoot=ST.AutoShoot;S.AntiFling=ST.AntiFling;S.LowGFX=ST.LowGFX;S.NoClip=ST.NoClip;S.FOVCircle=ST.FOVCircle;S.FOVSize=ST.FOVSize;S.AimKey=ST.AimKey;S.UIKey=ST.UIHotkey.Key;S.KnifeHandleSize=ST.KnifeHandleSize;S.KnifeReach=ST.KnifeReach;S.Collapsed=Collapsed;S.AutoWin=ST.AutoWinMurder
end
FN.SetupUI=function()
	-- PAGE TAB SETTINGS - scoped so they do not consume main-chunk registers
	local PAGE_TAB_TEXT_SIZE=13
	local PAGE_TAB_ICON_SIZE=14
	local PAGE_TAB_ICON_GAP=4
	local PAGE_TAB_LINE_WIDTH=.58
	local PAGE_TAB_LINE_HEIGHT=2
	local PAGE_TAB_ACTIVE_COLOR=Color3.fromRGB(235,235,235)
	local PAGE_TAB_INACTIVE_COLOR=Color3.fromRGB(145,145,145)
	local PAGE_TAB_LINE_COLOR=Color3.fromRGB(28,96,255)
	local PAGE_TAB_ICONS={
		Misc="rbxassetid://123209731860167",
		Visuals="rbxassetid://121392469180052",
		Config="rbxassetid://84734552743396",
		Credits="rbxassetid://117407381692207"
	}
	local PG=LP:WaitForChild("PlayerGui")
	local Parent=PG
	if not Debug then
		UX.HUI=CG:FindFirstChild("HUI")
		if UX.HUI and not UX.HUI:IsA("Folder") then UX.HUI:Destroy() UX.HUI=nil end
		if not UX.HUI then
			UX.HUI=Instance.new("Folder");UX.HUI.Name="HUI";UX.HUI.Parent=CG
		end
		Parent=UX.HUI
	end
	ClearHubUI(PG)
	UX.UI=New("ScreenGui",nil,"XYZ Hub");UX.UI:SetAttribute("XYZ_HUB_UI",true);UX.UI.ResetOnSpawn=false;UX.UI.IgnoreGuiInset=true;UX.UI.ZIndexBehavior=Enum.ZIndexBehavior.Sibling;UX.UI.Parent=Parent
	UX.FOVRing=New("Frame",UX.UI,"FOV Circle");UX.FOVRing.AnchorPoint=Vector2.new(.5,.5);UX.FOVRing.Position=UDim2.fromScale(.5,.5);UX.FOVRing.Size=UDim2.fromOffset(ST.FOVSize*2,ST.FOVSize*2);UX.FOVRing.BackgroundTransparency=1;UX.FOVRing.BorderSizePixel=0;UX.FOVRing.Visible=ST.FOVCircle;UX.FOVRing.ZIndex=1
	New("UICorner",UX.FOVRing).CornerRadius=UDim.new(1,0)
	UX.FOVStroke=New("UIStroke",UX.FOVRing,"FOV Stroke");UX.FOVStroke.Color=Color3.fromRGB(255,255,255);UX.FOVStroke.Transparency=.15;UX.FOVStroke.Thickness=1
	UX.GunDropScreenTracer=New("Frame",UX.UI,"GunDrop Screen Tracer");UX.GunDropScreenTracer.AnchorPoint=Vector2.new(.5,.5);UX.GunDropScreenTracer.BackgroundColor3=COL.GunText;UX.GunDropScreenTracer.BorderSizePixel=0;UX.GunDropScreenTracer.Visible=false;UX.GunDropScreenTracer.ZIndex=1
	UX.Main=New("Frame",UX.UI,"Main");UX.Main.Size=UDim2.fromOffset(240,0);UX.Main.Position=UDim2.new(.5,-120*UX.MAIN_SCALE,.5,-(UX.FULL_H*UX.MAIN_SCALE)/2);UX.Main.BackgroundColor3=Color3.fromRGB(23,23,23);UX.Main.ClipsDescendants=true;UX.Main.BorderSizePixel=0
	New("UICorner",UX.Main).CornerRadius=UDim.new(0,4)
	local MS=New("UIScale",UX.Main,"Main Scale");MS.Scale=UX.MAIN_SCALE
	UX.Header=New("Frame",UX.Main,"TopBar");UX.Header.Size=UDim2.new(1,0,0,UX.TOP_H);UX.Header.BackgroundColor3=Color3.fromRGB(27,27,27);UX.Header.BackgroundTransparency=0;UX.Header.BorderSizePixel=0;UX.Header.Active=true;UX.Header.ClipsDescendants=false;UX.Header.ZIndex=100
	New("UICorner",UX.Header,"TopBarCorner").CornerRadius=UDim.new(0,7)
	local MAIN_ICON_SIZE,MAIN_TOGGLE_ICON_SIZE,MAIN_CLOSE_ICON_SIZE=25,18,22
	local MINUS,EXPAND,CLOSE_ICON="rbxassetid://81253841082995","rbxassetid://115994741693562","rbxassetid://133353640393861"
	local HubIcon=New("ImageLabel",UX.Header,"Hub Icon");HubIcon.Size=UDim2.fromOffset(MAIN_ICON_SIZE,MAIN_ICON_SIZE);HubIcon.Position=UDim2.fromOffset(8,7);HubIcon.BackgroundTransparency=1;HubIcon.Image="rbxassetid://73606263739240";HubIcon.ScaleType=Enum.ScaleType.Fit;HubIcon.ZIndex=101
	local Title=New("TextLabel",UX.Header,"Title");Title.Size=UDim2.new(1,-104,1,0);Title.Position=UDim2.fromOffset(39,0);Title.BackgroundTransparency=1;Title.Text="XYZ Hub";Title.TextXAlignment=Enum.TextXAlignment.Left;Title.TextColor3=Color3.fromRGB(240,240,240);Title.TextSize=15;Title.Font=Enum.Font.RobotoMono;Title.ZIndex=101;Title.TextStrokeTransparency=.5
	UX.Collapse=New("ImageButton",UX.Header,"Toggle");UX.Collapse.AnchorPoint=Vector2.zero;UX.Collapse.Size=UDim2.fromOffset(22,22);UX.Collapse.Position=UDim2.new(1,-52,0,9);UX.Collapse.BackgroundColor3=Color3.fromRGB(55,55,55);UX.Collapse.BackgroundTransparency=0;UX.Collapse.BorderSizePixel=0;UX.Collapse.AutoButtonColor=false;UX.Collapse.Active=true;UX.Collapse.Visible=true;UX.Collapse.Image="";UX.Collapse.ZIndex=110
	New("UICorner",UX.Collapse).CornerRadius=UDim.new(0,4)
	local CIcon=New("ImageLabel",UX.Collapse,"Icon");CIcon.AnchorPoint=Vector2.new(.5,.5);CIcon.Position=UDim2.fromScale(.5,.5);CIcon.Size=UDim2.fromOffset(MAIN_TOGGLE_ICON_SIZE,MAIN_TOGGLE_ICON_SIZE);CIcon.BackgroundTransparency=1;CIcon.Image=Collapsed and EXPAND or MINUS;CIcon.ScaleType=Enum.ScaleType.Fit;CIcon.ZIndex=111
	local CS=New("UIStroke",UX.Collapse);CS.Color=Color3.fromRGB(82,82,82);CS.Thickness=1
	UX.Close=New("ImageButton",UX.Header,"Close");UX.Close.AnchorPoint=Vector2.zero;UX.Close.Size=UDim2.fromOffset(22,22);UX.Close.Position=UDim2.new(1,-27,0,9);UX.Close.BackgroundColor3=Color3.fromRGB(55,55,55);UX.Close.BackgroundTransparency=0;UX.Close.BorderSizePixel=0;UX.Close.AutoButtonColor=false;UX.Close.Active=true;UX.Close.Visible=true;UX.Close.Image="";UX.Close.ZIndex=110
	New("UICorner",UX.Close).CornerRadius=UDim.new(0,4)
	local XIcon=New("ImageLabel",UX.Close,"Icon");XIcon.AnchorPoint=Vector2.new(.5,.5);XIcon.Position=UDim2.fromScale(.5,.5);XIcon.Size=UDim2.fromOffset(MAIN_CLOSE_ICON_SIZE,MAIN_CLOSE_ICON_SIZE);XIcon.BackgroundTransparency=1;XIcon.Image=CLOSE_ICON;XIcon.ScaleType=Enum.ScaleType.Fit;XIcon.ZIndex=111
	local XS=New("UIStroke",UX.Close);XS.Color=Color3.fromRGB(82,82,82);XS.Thickness=1
	UX.Line=New("Frame",UX.Header);UX.Line.AnchorPoint=Vector2.new(0,1);UX.Line.Position=UDim2.new(0,0,1,0);UX.Line.Size=UDim2.new(1,0,0,1);UX.Line.BackgroundColor3=Color3.fromRGB(40,40,40);UX.Line.BorderSizePixel=0;UX.Line.ZIndex=21
	UX.Tabs=New("Frame",UX.Main,"Tabs");UX.Tabs.Position=UDim2.fromOffset(0,UX.TOP_H);UX.Tabs.Size=UDim2.new(1,0,0,UX.TAB_H);UX.Tabs.BackgroundColor3=Color3.fromRGB(25,25,25);UX.Tabs.BorderSizePixel=0;UX.Tabs.ZIndex=20
	UX.PageHost=New("Frame",UX.Main,"PageHost");UX.PageHost.Position=UDim2.fromOffset(0,UX.TOP_H+UX.TAB_H);UX.PageHost.Size=UDim2.new(1,0,1,-(UX.TOP_H+UX.TAB_H));UX.PageHost.BackgroundTransparency=1;UX.PageHost.BorderSizePixel=0;UX.PageHost.ClipsDescendants=true;UX.PageHost.ZIndex=5
	local function MakePage(Name,CanvasY,StartX)
		local P=New("ScrollingFrame",UX.PageHost,Name);P.Position=UDim2.new(StartX or 1,0,0,0);P.Size=UDim2.fromScale(1,1);P.BackgroundTransparency=1;P.BorderSizePixel=0;P.CanvasSize=UDim2.fromOffset(0,CanvasY or 0);P.ScrollBarThickness=3;P.ScrollBarImageColor3=Color3.fromRGB(75,75,75);P.ScrollingDirection=Enum.ScrollingDirection.Y;P.ElasticBehavior=Enum.ElasticBehavior.Never;P.ZIndex=6
		return P
	end
	UX.VisualsPage=MakePage("Visuals Page",510,1)
	UX.MiscPage=MakePage("Misc Page",620,0)
	UX.ConfigPage=MakePage("Config Page",120,1)
	UX.CreditsPage=MakePage("Credits Page",0,1)
	UX.Content=UX.MiscPage
	UX.CurrentPage=UX.MiscPage
	local PageTween=TweenInfo.new(.22,Enum.EasingStyle.Quint,Enum.EasingDirection.Out)
	local TabFade=TweenInfo.new(.18,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
	local Switching=false
	local function PaintTabs(Selected)
		for Name,B in pairs(UX.TabButtons) do
			local On=Name==Selected
			local Col=On and PAGE_TAB_ACTIVE_COLOR or PAGE_TAB_INACTIVE_COLOR
			local T=UX.TabTexts[Name]
			local I=UX.TabIcons[Name]
			if T then TS:Create(T,TabFade,{TextColor3=Col}):Play() end
			if I then TS:Create(I,TabFade,{ImageColor3=Col}):Play() end
			local U=UX.TabLines[Name]
			if U then TS:Create(U,TabFade,{BackgroundTransparency=On and 0 or 1}):Play() end
		end
	end
	local function SwitchPage(Name,Target)
		if Switching or UX.CurrentPage==Target then PaintTabs(Name) return end
		Switching=true
		local Old=UX.CurrentPage
		Target.Visible=true;Target.Position=UDim2.new(1,0,0,0)
		local A=TS:Create(Old,PageTween,{Position=UDim2.new(-1,0,0,0)})
		local B=TS:Create(Target,PageTween,{Position=UDim2.new(0,0,0,0)})
		PaintTabs(Name)
		A:Play();B:Play()
		B.Completed:Once(function()
			if Old and Old.Parent then Old.Position=UDim2.new(1,0,0,0) end
			UX.CurrentPage=Target
			UX.Content=Target
			Switching=false
		end)
	end
	local TabNames={{"Misc",UX.MiscPage},{"Visuals",UX.VisualsPage},{"Config",UX.ConfigPage},{"Credits",UX.CreditsPage}}
	for I,D in ipairs(TabNames) do
		local Name,Target=D[1],D[2]
		local B=New("TextButton",UX.Tabs,Name.." Tab");B.Size=UDim2.new(1/#TabNames,0,1,0);B.Position=UDim2.new((I-1)/#TabNames,0,0,0);B.BackgroundColor3=Color3.fromRGB(45,45,45);B.BackgroundTransparency=1;B.BorderSizePixel=0;B.AutoButtonColor=false;B.Text="";B.ZIndex=22
		local H=New("Frame",B,Name.." Tab Content");H.AnchorPoint=Vector2.new(.5,.5);H.Position=UDim2.fromScale(.5,.5);H.Size=UDim2.new(1,-8,0,PAGE_TAB_ICON_SIZE+4);H.BackgroundTransparency=1;H.ZIndex=23
		local L=New("UIListLayout",H,Name.." Tab Layout");L.FillDirection=Enum.FillDirection.Horizontal;L.HorizontalAlignment=Enum.HorizontalAlignment.Center;L.VerticalAlignment=Enum.VerticalAlignment.Center;L.Padding=UDim.new(0,PAGE_TAB_ICON_GAP);L.SortOrder=Enum.SortOrder.LayoutOrder
		local IC
		local IconId=PAGE_TAB_ICONS[Name];if IconId then IC=New("ImageLabel",H,Name.." Icon");IC.LayoutOrder=1;IC.Size=UDim2.fromOffset(PAGE_TAB_ICON_SIZE,PAGE_TAB_ICON_SIZE);IC.BackgroundTransparency=1;IC.Image=IconId;IC.ImageColor3=PAGE_TAB_INACTIVE_COLOR;IC.ScaleType=Enum.ScaleType.Fit;IC.ZIndex=24 end
		local TX=New("TextLabel",H,Name.." Text");TX.LayoutOrder=2;TX.AutomaticSize=Enum.AutomaticSize.X;TX.Size=UDim2.new(0,0,1,0);TX.BackgroundTransparency=1;TX.Text=Name;TX.TextColor3=PAGE_TAB_INACTIVE_COLOR;TX.TextSize=PAGE_TAB_TEXT_SIZE;TX.Font=Enum.Font.RobotoMono;TX.TextXAlignment=Enum.TextXAlignment.Left;TX.TextYAlignment=Enum.TextYAlignment.Center;TX.ZIndex=24;TX.TextStrokeTransparency=.5
		local U=New("Frame",B,Name.." Underline");U.AnchorPoint=Vector2.new(.5,1);U.Position=UDim2.new(.5,0,1,0);U.Size=UDim2.new(PAGE_TAB_LINE_WIDTH,0,0,PAGE_TAB_LINE_HEIGHT);U.BackgroundColor3=PAGE_TAB_LINE_COLOR;U.BackgroundTransparency=1;U.BorderSizePixel=0;U.ZIndex=25
		New("UICorner",U).CornerRadius=UDim.new(1,0)
		UX.TabButtons[Name]=B
		UX.TabLines[Name]=U
		UX.TabTexts[Name]=TX
		UX.TabIcons[Name]=IC
		C(B.MouseButton1Click,function() SwitchPage(Name,Target) end)
	end
	PaintTabs("Misc")
	C(UX.Collapse.MouseEnter,function() TS:Create(UX.Collapse,TweenInfo.new(.12),{BackgroundColor3=Color3.fromRGB(72,72,72)}):Play() end)
	C(UX.Collapse.MouseLeave,function() TS:Create(UX.Collapse,TweenInfo.new(.12),{BackgroundColor3=Color3.fromRGB(55,55,55)}):Play() end)
	C(UX.Close.MouseEnter,function() TS:Create(UX.Close,TweenInfo.new(.12),{BackgroundColor3=Color3.fromRGB(72,72,72)}):Play() end)
	C(UX.Close.MouseLeave,function() TS:Create(UX.Close,TweenInfo.new(.12),{BackgroundColor3=Color3.fromRGB(55,55,55)}):Play() end)
	C(UX.Collapse.MouseButton1Click,function() if UX.MainOpen then UX.SetCollapsed(not Collapsed) end end)
	C(UX.Close.MouseButton1Click,function() UX.SetMenu(false) end)
	local Dragging,DragStart,StartPos,DragInput=false
	C(UX.Header.InputBegan,function(I)
		if I.UserInputType==Enum.UserInputType.MouseButton1 then
			Dragging=true
			DragStart=I.Position
			StartPos=UX.Main.Position
			C(I.Changed,function()
				if I.UserInputState==Enum.UserInputState.End then Dragging=false end
			end)
		end
	end)
	C(UX.Header.InputChanged,function(I)
		if I.UserInputType==Enum.UserInputType.MouseMovement then DragInput=I end
	end)
	C(UIS.InputChanged,function(I)
		if Dragging and I==DragInput then
			local D=I.Position-DragStart
			UX.Main.Position=UDim2.new(StartPos.X.Scale,StartPos.X.Offset+D.X,StartPos.Y.Scale,StartPos.Y.Offset+D.Y)
		end
	end)
end
UX.SetCollapsed=function(V,Instant)
	if ST.Killed or not UX.Main or not UX.Main.Parent or not UX.MainOpen then return end
	Collapsed=V
	local I=UX.Collapse and UX.Collapse:FindFirstChildWhichIsA("ImageLabel");if I then I.Image=V and "rbxassetid://115994741693562" or "rbxassetid://81253841082995" end
	if UX.MainTween then UX.MainTween:Cancel() end
	local H=V and UX.TOP_H or UX.FULL_H
	if UX.Line then TS:Create(UX.Line,V and UX.MainOut or UX.MainIn,{BackgroundTransparency=V and 1 or 0}):Play() end
	if Instant then UX.Main.Size=UDim2.fromOffset(240,H) if UX.Line then UX.Line.BackgroundTransparency=V and 1 or 0 end return end
	UX.MainTween=TS:Create(UX.Main,V and UX.MainOut or UX.MainIn,{Size=UDim2.fromOffset(240,H)})
	UX.MainTween:Play()
end
UX.SetMenu=function(Open,Instant)
	if ST.Killed or not UX.Main or not UX.Main.Parent then return end
	UX.MainOpen=Open
	if UX.MainTween then UX.MainTween:Cancel() end
	if Open then
		UX.Main.Visible=true
		local H=Collapsed and UX.TOP_H or UX.FULL_H
		if Instant then UX.Main.Size=UDim2.fromOffset(240,H) return end
		UX.Main.Size=UDim2.fromOffset(240,0)
		UX.MainTween=TS:Create(UX.Main,UX.MainIn,{Size=UDim2.fromOffset(240,H)})
		UX.MainTween:Play()
	else
		if Instant then UX.Main.Size=UDim2.fromOffset(240,0) UX.Main.Visible=false return end
		UX.MainTween=TS:Create(UX.Main,UX.MainOut,{Size=UDim2.fromOffset(240,0)})
		local T=UX.MainTween
		T:Play()
		T.Completed:Connect(function()
			if not UX.MainOpen and UX.Main and UX.Main.Parent and UX.MainTween==T then UX.Main.Visible=false end
		end)
	end
end
;(function()
	local NL={}
	local NW,NH,NG=225,30,6
	local NX,NY=-14,-16
	local NOFF=NW+25
	local NIn=TweenInfo.new(.34,Enum.EasingStyle.Sine,Enum.EasingDirection.Out)
	local NOut=TweenInfo.new(.38,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut)
	local function NTw(O,P,T)
		TS:Create(O,T or NIn,P):Play()
	end
	local function NUpdate()
		for i,N in ipairs(NL) do
			if N.Parent then NTw(N,{Position=UDim2.new(1,NX,1,NY-((#NL-i)*(NH+NG)))}) end
		end
	end
	local function NRemove(N,Fast)
		if not N or not N.Parent or N:GetAttribute("Removing") then return end
		N:SetAttribute("Removing",true)
		for i,V in ipairs(NL) do
			if V==N then table.remove(NL,i) break end
		end
		local YP=N.Position.Y
		local D=Fast and .22 or .38
		TS:Create(N,Fast and TweenInfo.new(D,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut) or NOut,{
			Position=UDim2.new(1,NOFF,YP.Scale,YP.Offset)
		}):Play()
		NUpdate()
		task.delay(D,function() if N.Parent then N:Destroy() end end)
	end
	local function PlayNotificationSound()
		local S=New("Sound",SS,"NotificationSound");S.SoundId="rbxassetid://104406737603900";S.Volume=.55;S:Play()
		S.Ended:Connect(function() if S and S.Parent then S:Destroy() end end)
		task.delay(6,function() if S and S.Parent then S:Destroy() end end)
	end
	UX.ShowNotification=function(Txt,Good,Dur,Root)
		local R=Root or UX.UI;if ST.Killed or not R or not R.Parent then return end
		PlayNotificationSound()
		if #NL>=6 then NRemove(NL[1],true) end
		local N=New("Frame",R);N.AnchorPoint=Vector2.new(1,1);N.Position=UDim2.new(1,NOFF,1,NY);N.Size=UDim2.fromOffset(NW,NH);N.BackgroundColor3=Color3.fromRGB(45,45,45);N.BorderSizePixel=0;N.ZIndex=999
		New("UICorner",N).CornerRadius=UDim.new(0,4);local NS=New("UIStroke",N,"Notification Stroke");NS.Color=Color3.fromRGB(9,9,9);NS.Thickness=1.5
		local SC=Good and Color3.fromRGB(55,220,95) or Color3.fromRGB(235,60,60)
		local NI=New("ImageLabel",N,"Notification Icon");NI.AnchorPoint=Vector2.new(1,.5);NI.Position=UDim2.new(1,-5,.5,0);NI.Size=UDim2.fromOffset(24,24);NI.BackgroundTransparency=1;NI.Image="rbxassetid://105153346819279";NI.ImageColor3=SC;NI.ScaleType=Enum.ScaleType.Fit;NI.ZIndex=1002
		local T=New("TextLabel",N);T.Position=UDim2.fromOffset(10,0);T.Size=UDim2.new(1,-46,1,0);T.BackgroundTransparency=1;T.Text=Txt;T.TextColor3=Color3.fromRGB(240,240,240);T.TextSize=14;T.Font=Enum.Font.GothamMedium;T.TextStrokeTransparency=.5;T.TextWrapped=true;T.TextXAlignment=Enum.TextXAlignment.Left;T.TextYAlignment=Enum.TextYAlignment.Center;T.ZIndex=1002
		table.insert(NL,N)
		NUpdate()
		task.delay(math.clamp(Dur or 4.5,.2,4.5),function() NRemove(N) end)
	end
	UX.ClearNotifications=function()
		table.clear(NL)
	end
end)()
FN.MakeBillboard=function(Parent,Text,Color)
	if ST.Killed then return end
	local Old=FindTag(Parent,"ESP_BG")
	if Old then Old:Destroy() end
	local BG=New("BillboardGui",Parent);BG:SetAttribute("ESP_BG",true);BG.Size=UDim2.new(4,0,1,0);BG.StudsOffset=Vector3.new(0,1.656,0);BG.LightInfluence=0;BG.AlwaysOnTop=true
	local UID=New("TextLabel",BG);UID.Size=UDim2.fromScale(1,1);UID.BackgroundTransparency=1;UID.Text=Text;UID.TextScaled=true;UID.TextColor3=Color;UID.TextStrokeColor3=Color3.new(0,0,0);UID.TextStrokeTransparency=0;UID.FontFace=Font.new("rbxasset://fonts/families/RobotoMono.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
end
FN.HasTool=function(P,N)
	return (P:FindFirstChild("Backpack") and P.Backpack:FindFirstChild(N)) or (P.Character and P.Character:FindFirstChild(N))
end
FN.IsSelfMurder=function()
	return FN.HasTool(LP,"Knife")~=nil
end
ST.AFOriginal,ST.AFConns,ST.AFTracked,ST.AFWatched={},{},{},{}
ST.AFR15Parts={Head=true,LeftFoot=true,LeftHand=true,LeftLowerArm=true,LeftLowerLeg=true,LeftUpperArm=true,LeftUpperLeg=true,LowerTorso=true,RightFoot=true,RightHand=true,RightLowerArm=true,RightLowerLeg=true,RightUpperArm=true,RightUpperLeg=true,UpperTorso=true,HumanoidRootPart=true}
ST.AFR6Parts={Head=true,Torso=true,["Left Arm"]=true,["Right Arm"]=true,["Left Leg"]=true,["Right Leg"]=true,HumanoidRootPart=true}
FN.AFClearConnections=function() for _,X in ipairs(ST.AFConns) do pcall(function() X:Disconnect() end) end;table.clear(ST.AFConns);table.clear(ST.AFWatched) end
FN.GetAntiFlingRig=function(V)
	if not V or not V:IsA("BasePart") or V:FindFirstAncestorOfClass("Tool") or V:FindFirstAncestorOfClass("Accessory") then return end
	local CH=V.Parent
	while CH and CH~=WS do if CH:IsA("Model") and CH:FindFirstChildOfClass("Humanoid") then break end;CH=CH.Parent end
	if not CH or CH==WS or CH==LP.Character then return end
	local H=CH:FindFirstChildOfClass("Humanoid");if not H then return end
	local Names=H.RigType==Enum.HumanoidRigType.R15 and ST.AFR15Parts or ST.AFR6Parts
	if not Names[V.Name] then return end
	return CH
end
FN.IsCharacterBodyPart=function(V) return FN.GetAntiFlingRig(V)~=nil end
FN.TrackAntiFlingPart=function(V)
	if not ST.AntiFling or ST.AFTracked[V] or not FN.GetAntiFlingRig(V) then return end
	ST.AFTracked[V]=true;if ST.AFOriginal[V]==nil then ST.AFOriginal[V]=V.CanCollide end;V.CanCollide=false
	local X=V:GetPropertyChangedSignal("CanCollide"):Connect(function() if ST.AntiFling and V.Parent and V.CanCollide then V.CanCollide=false end end);table.insert(ST.AFConns,X)
end
FN.WatchAntiFlingCharacter=function(CH)
	if not ST.AntiFling or not CH or CH==LP.Character or ST.AFWatched[CH] or not CH:FindFirstChildOfClass("Humanoid") then return end
	ST.AFWatched[CH]=true
	for _,V in ipairs(CH:GetDescendants()) do FN.TrackAntiFlingPart(V) end
	local X=CH.DescendantAdded:Connect(function(V) if ST.AntiFling then FN.TrackAntiFlingPart(V) end end);table.insert(ST.AFConns,X)
	task.defer(function() if ST.AntiFling and CH.Parent then for _,V in ipairs(CH:GetDescendants()) do FN.TrackAntiFlingPart(V) end end end)
end
FN.SetAntiFling=function(V)
	ST.AntiFling=V;FN.AFClearConnections()
	if V then
		table.clear(ST.AFTracked)
		for _,M in ipairs(WS:GetDescendants()) do if M:IsA("Model") and M~=LP.Character and M:FindFirstChildOfClass("Humanoid") then FN.WatchAntiFlingCharacter(M) end end
		local X=WS.DescendantAdded:Connect(function(O)
			if not ST.AntiFling then return end
			if O:IsA("Humanoid") then local CH=O.Parent;if CH and CH:IsA("Model") then task.defer(FN.WatchAntiFlingCharacter,CH) end elseif O:IsA("BasePart") then FN.TrackAntiFlingPart(O) end
		end);table.insert(ST.AFConns,X)
	else
		for Part,Old in pairs(ST.AFOriginal) do if Part and Part.Parent then pcall(function() Part.CanCollide=Old end) end end
		table.clear(ST.AFOriginal);table.clear(ST.AFTracked);table.clear(ST.AFWatched)
		if ST.NoClip and FN.UpdateNoClip then ST.NCLast=0;FN.UpdateNoClip(true) end
	end
end

-- Low GFX: strips world/Lighting detail but preserves original values for exact OFF restore.
ST.LowGFXOriginal=setmetatable({}, {__mode="k"});ST.LowGFXConn=nil;ST.LowGFXLightingConn=nil;ST.LowGFXLighting={Props=nil,Children={}};ST.Lighting=game:GetService("Lighting")
FN.ApplyLowGFXObject=function(O)
	if not ST.LowGFX or not O or ST.LowGFXOriginal[O] then return end
	local R={}
	local function P(K,V) local OK,Old=pcall(function() return O[K] end);if OK and Old~=V then R[K]=Old;pcall(function() O[K]=V end) end end
	local M=O:FindFirstAncestorOfClass("Model");local Avatar=M and M:FindFirstChildOfClass("Humanoid")~=nil;local Acc=O:FindFirstAncestorOfClass("Accessory")
	if O:IsA("Decal") then
		-- Keep avatar faces; hide other decals.
		if not (Avatar and O.Parent and O.Parent.Name=="Head" and O.Name:lower()=="face") then P("Transparency",1) end
	elseif O:IsA("Texture") then P("Transparency",1)
	elseif O:IsA("Shirt") then P("ShirtTemplate","")
	elseif O:IsA("Pants") then P("PantsTemplate","")
	elseif O:IsA("ShirtGraphic") then P("Graphic","")
	elseif O:IsA("MeshPart") then
		if Acc then P("Transparency",1) elseif not (Avatar and O.Name=="Head") then P("TextureID","") end
		P("Material",Enum.Material.SmoothPlastic);P("Reflectance",0);P("CastShadow",false)
	elseif O:IsA("SpecialMesh") then
		if not (Avatar and O.Parent and O.Parent.Name=="Head") then P("TextureId","") end
	elseif O:IsA("SurfaceAppearance") then
		if not (Avatar and O.Parent and O.Parent.Name=="Head") then P("ColorMap","");P("NormalMap","");P("MetalnessMap","");P("RoughnessMap","") end
	elseif O:IsA("BasePart") then
		if Acc then P("Transparency",1) end
		-- Never change Color/BrickColor, so avatar skin tones remain intact.
		P("Material",Enum.Material.SmoothPlastic);P("Reflectance",0);P("CastShadow",false)
	elseif O:IsA("ParticleEmitter") or O:IsA("Trail") or O:IsA("Beam") or O:IsA("Smoke") or O:IsA("Fire") or O:IsA("Sparkles") then P("Enabled",false) end
	if next(R) then ST.LowGFXOriginal[O]=R end
end
FN.ApplyLowGFXLighting=function()
	local L=ST.Lighting;if not L then return end
	if not ST.LowGFXLighting.Props then ST.LowGFXLighting.Props={Brightness=L.Brightness,Ambient=L.Ambient} end
	L.Brightness=1.75;L.Ambient=Color3.fromRGB(0,0,0)
	for _,O in ipairs(L:GetChildren()) do ST.LowGFXLighting.Children[O]=L;O.Parent=nil end
end
FN.RestoreLowGFXLighting=function()
	local L=ST.Lighting;local D=ST.LowGFXLighting;if not L or not D then return end
	if D.Props then pcall(function() L.Brightness=D.Props.Brightness;L.Ambient=D.Props.Ambient end) end
	for O,P in pairs(D.Children) do if O then pcall(function() O.Parent=P end) end end
	D.Props=nil;table.clear(D.Children)
end
FN.SetLowGFX=function(V)
	ST.LowGFX=V
	if ST.LowGFXConn then pcall(function() ST.LowGFXConn:Disconnect() end);ST.LowGFXConn=nil end
	if ST.LowGFXLightingConn then pcall(function() ST.LowGFXLightingConn:Disconnect() end);ST.LowGFXLightingConn=nil end
	if V then
		FN.ApplyLowGFXLighting()
		for _,O in ipairs(WS:GetDescendants()) do FN.ApplyLowGFXObject(O) end
		ST.LowGFXConn=WS.DescendantAdded:Connect(function(O) if ST.LowGFX then task.defer(FN.ApplyLowGFXObject,O) end end)
		ST.LowGFXLightingConn=ST.Lighting.ChildAdded:Connect(function(O) if ST.LowGFX then ST.LowGFXLighting.Children[O]=ST.Lighting;task.defer(function() if ST.LowGFX and O.Parent==ST.Lighting then O.Parent=nil end end) end end)
	else
		for O,R in pairs(ST.LowGFXOriginal) do if O then for K,Old in pairs(R) do pcall(function() O[K]=Old end) end end end
		table.clear(ST.LowGFXOriginal);FN.RestoreLowGFXLighting()
	end
end

-- Local NoClip: horizontal 15-stud X/Z area, extending upward but not through the floor below the player.
ST.NCOriginal=setmetatable({}, {__mode="k"});ST.NCActive=setmetatable({}, {__mode="k"});ST.NCLast=0;ST.NCParams=nil
FN.RestoreNoClipPart=function(P)
	local Old=ST.NCOriginal[P];if Old==nil then return end
	if P and P.Parent then pcall(function() if ST.AntiFling and ST.AFTracked[P] then P.CanCollide=false else P.CanCollide=Old end end) end
	ST.NCOriginal[P]=nil;ST.NCActive[P]=nil
end
FN.UpdateNoClip=function(Force)
	if not ST.NoClip or ST.Killed then return end
	local Now=os.clock();if not Force and Now-ST.NCLast<.08 then return end;ST.NCLast=Now
	local CH=LP.Character;local HRP=CH and CH:FindFirstChild("HumanoidRootPart");if not HRP then return end
	if not ST.NCParams then ST.NCParams=OverlapParams.new();ST.NCParams.FilterType=Enum.RaycastFilterType.Exclude;ST.NCParams.MaxParts=0 end
	ST.NCParams.FilterDescendantsInstances={CH}
	local Seen={}
	for _,P in ipairs(WS:GetPartBoundsInBox(CFrame.new(HRP.Position+Vector3.new(0,1024,0)),Vector3.new(30,2050,30),ST.NCParams)) do
		if P:IsA("BasePart") and P~=HRP and P.Position.Y+P.Size.Y*.5>=HRP.Position.Y-2 then
			local D=P.Position-HRP.Position;if math.abs(D.X)<=15 and math.abs(D.Z)<=15 then
				Seen[P]=true;if ST.NCOriginal[P]==nil then ST.NCOriginal[P]=P.CanCollide end;ST.NCActive[P]=true;if P.CanCollide then P.CanCollide=false end
			end
		end
	end
	for P in pairs(ST.NCActive) do if not Seen[P] then FN.RestoreNoClipPart(P) end end
end
FN.SetNoClip=function(V)
	ST.NoClip=V;ST.NCLast=0
	if V then FN.UpdateNoClip(true) else for P in pairs(ST.NCActive) do FN.RestoreNoClipPart(P) end;table.clear(ST.NCActive);table.clear(ST.NCOriginal) end
end
ST.PlayerVisuals={}
-- R15 skeleton: draw directly through the real body-part centers.
-- This is stable across animations and keeps the lines visually on the limbs.
ST.SkeletonLinks={
	{"Head","UpperTorso"},
	{"UpperTorso","LowerTorso"},
	{"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
	{"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
	{"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},
	{"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"}
}
ST.ESPBodyParts={
	R15={"Head","UpperTorso","LowerTorso","LeftUpperArm","LeftLowerArm","LeftHand","RightUpperArm","RightLowerArm","RightHand","LeftUpperLeg","LeftLowerLeg","LeftFoot","RightUpperLeg","RightLowerLeg","RightFoot"},
	R6={"Head","Torso","Left Arm","Right Arm","Left Leg","Right Leg"}
}
FN.SkeletonPoint=function(CH,Name)
	local P=CH and CH:FindFirstChild(Name)
	if P and P:IsA("BasePart") then return P.Position end
end
FN.RoleColor=function(Role)
	if Role=="Murder" then return COL.MurderText end
	if Role=="Sheriff" then return COL.SheriffText end
	if Role=="Hero" then return COL.HeroText end
	return COL.InnocentText
end
FN.DestroyPlayerVisual=function(P)
	local V=ST.PlayerVisuals[P]
	if not V then return end
	if V.Box and V.Box.Parent then V.Box:Destroy() end
	if V.Tracer and V.Tracer.Parent then V.Tracer:Destroy() end
	for _,L in ipairs(V.Lines or {}) do if L and L.Parent then L:Destroy() end end
	ST.PlayerVisuals[P]=nil
end
FN.EnsurePlayerVisual=function(P,Role)
	local V=ST.PlayerVisuals[P]
	if not V then
		V={Lines={}}
		local B=New("Frame",UX.UI,"ESP Box");B.AnchorPoint=Vector2.new(.5,.5);B.BackgroundTransparency=1;B.BorderSizePixel=0;B.Visible=false;B.ZIndex=900
		local Stroke=New("UIStroke",B,"ESP Box Stroke");Stroke.Thickness=1.4;Stroke.Transparency=0
		V.Box=B;V.Stroke=Stroke
		local TR=New("Frame",UX.UI,"Player Tracer");TR.AnchorPoint=Vector2.new(.5,.5);TR.BorderSizePixel=0;TR.Size=UDim2.fromOffset(0,1.5);TR.Visible=false;TR.ZIndex=899;V.Tracer=TR
		for I=1,#ST.SkeletonLinks do
			local L=New("Frame",UX.UI,"Skeleton Line");L.AnchorPoint=Vector2.new(.5,.5);L.BorderSizePixel=0;L.Size=UDim2.fromOffset(0,1.5);L.Visible=false;L.ZIndex=901
			V.Lines[I]=L
		end
		ST.PlayerVisuals[P]=V
	end
	V.Role=Role
	local Col=FN.RoleColor(Role)
	if V.Stroke then V.Stroke.Color=Col end
	if V.Tracer then V.Tracer.BackgroundColor3=Col end
	for _,L in ipairs(V.Lines) do L.BackgroundColor3=Col end
	return V
end
FN.HidePlayerVisual=function(V)
	if not V then return end
	if V.Box then V.Box.Visible=false end
	if V.Tracer then V.Tracer.Visible=false end
	for _,L in ipairs(V.Lines or {}) do L.Visible=false end
end
FN.DrawSkeletonLine=function(L,A,B)
	local D=B-A
	local Len=D.Magnitude
	if Len<1 then L.Visible=false return end
	L.Visible=true;L.Position=UDim2.fromOffset((A.X+B.X)*.5,(A.Y+B.Y)*.5);L.Size=UDim2.fromOffset(Len,1.5);L.Rotation=math.deg(math.atan2(D.Y,D.X))
end
FN.PlayerOnScreen=function(P,Cam)
	local CH=P and P.Character;local RP=CH and (CH:FindFirstChild("HumanoidRootPart") or CH:FindFirstChild("Head"));if not RP or not Cam then return false end
	local S,On=Cam:WorldToViewportPoint(RP.Position);return On and S.Z>0
end
FN.UpdatePlayerESP=function()
	if ST.Killed or not UX.UI or not UX.UI.Parent then return end
	local Cam=WS.CurrentCamera;if not Cam then return end
	for _,P in ipairs(PS:GetPlayers()) do
		if P==LP then continue end
		local CH=P.Character;local HUM=CH and CH:FindFirstChildOfClass("Humanoid");local Role=ST.Roles[P] or "Innocent";local TraceRole=Role=="Murder" or Role=="Sheriff" or Role=="Hero"
		local Allowed=((Role=="Innocent" and ST.InnocentESP or Role~="Innocent") and (ST.BoxESP or ST.SkeletonESP)) or (ST.PlayerTracers and TraceRole)
		if not CH or not HUM or HUM.Health<=0 or ST.DeadPlayers[P] or not Allowed or not FN.PlayerOnScreen(P,Cam) then if ST.PlayerVisuals[P] then FN.ClearPlayer(P,CH) end;continue end
		local V=ST.PlayerVisuals[P]
		if not V then FN.ApplyPlayer(P,Role);V=ST.PlayerVisuals[P];if not V then continue end end
		if V.Role~=Role then V.Role=Role;local Col=FN.RoleColor(Role);if V.Stroke then V.Stroke.Color=Col end;if V.Tracer then V.Tracer.BackgroundColor3=Col end;for _,L in ipairs(V.Lines) do L.BackgroundColor3=Col end end
		if V.Tracer then
			if ST.PlayerTracers and TraceRole then local RP=CH:FindFirstChild("HumanoidRootPart") or CH:FindFirstChild("Head");local SP,On;if RP then SP,On=Cam:WorldToViewportPoint(RP.Position) end;if SP and On and SP.Z>0 then V.Tracer.BackgroundColor3=FN.RoleColor(Role);FN.DrawSkeletonLine(V.Tracer,Vector2.new(Cam.ViewportSize.X*.5,Cam.ViewportSize.Y-1),Vector2.new(SP.X,SP.Y)) else V.Tracer.Visible=false end else V.Tracer.Visible=false end
		end
		if ST.BoxESP then
			local List=HUM.RigType==Enum.HumanoidRigType.R15 and ST.ESPBodyParts.R15 or ST.ESPBodyParts.R6;local MinX,MinY,MaxX,MaxY=math.huge,math.huge,-math.huge,-math.huge;local Any=false
			for _,Name in ipairs(List) do local Part=CH:FindFirstChild(Name);if Part and Part:IsA("BasePart") then local H=Part.Size*.5;for X=-1,1,2 do for Y=-1,1,2 do for Z=-1,1,2 do local W=Part.CFrame:PointToWorldSpace(Vector3.new(H.X*X,H.Y*Y,H.Z*Z));local S=Cam:WorldToViewportPoint(W);if S.Z>0 then Any=true;MinX=math.min(MinX,S.X);MinY=math.min(MinY,S.Y);MaxX=math.max(MaxX,S.X);MaxY=math.max(MaxY,S.Y) end end end end end end
			if Any and MaxX>MinX and MaxY>MinY then local Pad=2;V.Box.Visible=true;V.Box.Position=UDim2.fromOffset((MinX+MaxX)*.5,(MinY+MaxY)*.5);V.Box.Size=UDim2.fromOffset((MaxX-MinX)+Pad*2,(MaxY-MinY)+Pad*2) else V.Box.Visible=false end
		else V.Box.Visible=false end
		local R15=HUM.RigType==Enum.HumanoidRigType.R15
		if ST.SkeletonESP and R15 then for I,Pair in ipairs(ST.SkeletonLinks) do local WA,WB=FN.SkeletonPoint(CH,Pair[1]),FN.SkeletonPoint(CH,Pair[2]);local L=V.Lines[I];if WA and WB then local A,AO=Cam:WorldToViewportPoint(WA);local B,BO=Cam:WorldToViewportPoint(WB);if AO and BO and A.Z>0 and B.Z>0 then FN.DrawSkeletonLine(L,Vector2.new(A.X,A.Y),Vector2.new(B.X,B.Y)) else L.Visible=false end else L.Visible=false end end else for _,L in ipairs(V.Lines) do L.Visible=false end end
	end
end
FN.ClearPlayer=function(P,CH)
	CH=CH or P.Character
	FN.DestroyPlayerVisual(P)
	if not CH then return end
	local HL=FindTag(CH,"ESP_HL")
	if HL then HL:Destroy() end
	local HD=CH:FindFirstChild("Head")
	if HD then
		local BG=FindTag(HD,"ESP_BG")
		if BG then BG:Destroy() end
	end
end
FN.ApplyPlayer=function(P,Role)
	if ST.Killed then return end
	if Role=="Innocent" and not ST.InnocentESP then FN.ClearPlayer(P) return end
	if not ST.BoxESP and not ST.SkeletonESP and not (ST.PlayerTracers and Role~="Innocent") then FN.ClearPlayer(P) return end
	local CH=P.Character
	local HD=CH and CH:FindFirstChild("Head")
	if not CH or not HD then return end
	local Cam=WS.CurrentCamera;if not FN.PlayerOnScreen(P,Cam) then if ST.PlayerVisuals[P] then FN.ClearPlayer(P,CH) end;return end
	local V=FN.EnsurePlayerVisual(P,Role)
	if V and (V.BillboardRole~=Role or not FindTag(HD,"ESP_BG")) then
		V.BillboardRole=Role
		FN.MakeBillboard(HD,P.Name,FN.RoleColor(Role))
	end
end
FN.GunRoleFor=function(P)
	if not ST.GunRoleState.Sheriff then ST.GunRoleState.Sheriff=P end
	if P==ST.GunRoleState.Sheriff then return "Sheriff" end
	ST.Hero=P
	return "Hero"
end
FN.SyncGunRoleState=function()
	local Active=false
	for _,P in PS:GetPlayers() do
		if FN.HasTool(P,"Knife") or FN.HasTool(P,"Gun") then Active=true end
		if FN.HasTool(P,"Gun") and not ST.GunRoleState.Sheriff then ST.GunRoleState.Sheriff=P end
	end
	if not Active then ST.GunRoleState.Sheriff=nil;ST.Hero=nil end
end
FN.CheckHero=function()
	if ST.Killed then return end
	FN.SyncGunRoleState()
	ST.Hero=nil
	for _,P in PS:GetPlayers() do
		if P~=LP and not ST.DeadPlayers[P] and FN.HasTool(P,"Gun") then
			local R=FN.GunRoleFor(P);ST.Roles[P]=R;if R=="Hero" then ST.Hero=P end
			if ST.BoxESP or ST.SkeletonESP or ST.PlayerTracers then FN.ApplyPlayer(P,R) end
		end
	end
end
FN.DetectPlayer=function(P)
	if ST.Killed then return end
	if P==LP or ST.DeadPlayers[P] then return end
	local R
	if FN.HasTool(P,"Knife") then
		R="Murder"
	elseif FN.HasTool(P,"Gun") then
		R=FN.GunRoleFor(P)
	end
	if R then
		ST.Roles[P]=R
		if ST.BoxESP or ST.SkeletonESP or ST.PlayerTracers then FN.ApplyPlayer(P,R) else FN.ClearPlayer(P) end
		return
	end
	ST.Roles[P]=nil
	if ST.InnocentESP then FN.ApplyPlayer(P,"Innocent") else FN.ClearPlayer(P) end
end
FN.BindCharacter=function(P,CH)
	if ST.Killed then return end
	ST.Roles[P] = nil
	ST.DeadPlayers[P] = false
	local H = CH:WaitForChild("Humanoid",5)
	if H then
		C(H.Died,function()
			ST.Roles[P] = nil
			ST.DeadPlayers[P] = true
			FN.ClearPlayer(P,CH)
			task.delay(.15,FN.CheckHero)
		end)
	end
	C(CH.ChildAdded,function() FN.DetectPlayer(P) end)
	C(CH.ChildRemoved,function() task.defer(FN.DetectPlayer,P) end)
	if ST.AntiFling then FN.WatchAntiFlingCharacter(CH) end
	task.defer(function() task.wait(.1) if not ST.DeadPlayers[P] then FN.DetectPlayer(P) end end)
end
FN.BindPlayer=function(P)
	if ST.Killed then return end
	if P == LP then return end
	ST.DeadPlayers[P] = false
	C(P.CharacterRemoving,function(CH) ST.Roles[P]=nil;FN.ClearPlayer(P,CH) end)
	C(P.CharacterAdded,function(CH) task.spawn(FN.BindCharacter,P,CH) end)
	if P.Character then task.spawn(FN.BindCharacter,P,P.Character) end
	local BP = P:FindFirstChild("Backpack") or P:WaitForChild("Backpack",10)
	if BP then
		C(BP.ChildAdded,function() if not ST.DeadPlayers[P] then FN.DetectPlayer(P) end end)
		C(BP.ChildRemoved,function() task.defer(function() if not ST.DeadPlayers[P] then FN.DetectPlayer(P) end end) end)
	end
end
FN.RefreshPlayers=function()
	if ST.Killed then return end
	for _,P in PS:GetPlayers() do
		if P~=LP then
			if (ST.BoxESP or ST.SkeletonESP or ST.PlayerTracers) and not ST.DeadPlayers[P] then FN.DetectPlayer(P) else FN.ClearPlayer(P) end
		end
	end
end
FN.IsGun=function(V)
	return V and V:IsA("BasePart") and V.Name == "GunDrop" and V:IsDescendantOf(WS)
end
FN.ClearGun=function(G)
	if not G then return end
	local BG=FindTag(G,"ESP_BG")
	if BG then BG:Destroy() end
	for _,V in G:GetChildren() do
		if V:GetAttribute("XYZ_GUNDROP_MARK") then V:Destroy() end
	end
end
FN.ApplyGun=function(G)
	if ST.Killed then return end
	if not FN.IsGun(G) then return end
	FN.ClearGun(G)
	if ST.GunESP then
		FN.MakeBillboard(G,"Gun",COL.GunText)
	end
end
FN.FindGun=function(CachedOnly)
	if ST.Killed then return end
	local CH = LP.Character
	local HRP = CH and CH:FindFirstChild("HumanoidRootPart")
	local Best, Dist = nil, math.huge
	for G in ST.Guns do
		if FN.IsGun(G) then
			local D = HRP and (HRP.Position-G.Position).Magnitude or 0
			if D < Dist then Dist = D Best = G end
		else
			ST.Guns[G] = nil
		end
	end
	if Best or CachedOnly then return Best end
	for _,V in WS:GetDescendants() do
		if FN.IsGun(V) then
			ST.Guns[V] = true
			local D = HRP and (HRP.Position-V.Position).Magnitude or 0
			if D < Dist then Dist = D Best = V end
		end
	end
	return Best
end
FN.PickGun=function(G)
	if ST.Killed or ST.Picking or ST.SelfMurder then return end
	G=G or FN.FindGun()
	if not FN.IsGun(G) then return end
	local CH=LP.Character
	local HRP=CH and CH:FindFirstChild("HumanoidRootPart")
	local HUM=CH and CH:FindFirstChildOfClass("Humanoid")
	if not CH or not HRP or not HUM or HUM.Health<=0 then return end
	ST.Picking=true
	local OldCF=CH:GetPivot()
	local LV,AV=HRP.AssemblyLinearVelocity,HRP.AssemblyAngularVelocity
	CH:PivotTo(CFrame.new(G.Position)*OldCF.Rotation)
	if typeof(firetouchinterest)=="function" then
		pcall(function()
			firetouchinterest(HRP,G,0)
			firetouchinterest(HRP,G,1)
		end)
	end
	if CH.Parent and HRP.Parent and HUM.Health>0 then
		CH:PivotTo(OldCF)
		HRP.AssemblyLinearVelocity=LV;HRP.AssemblyAngularVelocity=AV
	end
	ST.Picking=false
end
FN.TrackGun=function(G)
	if ST.Killed then return end
	if not FN.IsGun(G) then return end
	if ST.Guns[G] then FN.ApplyGun(G) return end
	ST.Guns[G] = true
	FN.ApplyGun(G)
	C(G.AncestryChanged,function()
		if not G:IsDescendantOf(WS) then ST.Guns[G] = nil end
	end)
	if ST.AutoPick and not ST.SelfMurder and FN.IsGun(G) then FN.PickGun(G) end
end
FN.RefreshGuns=function()
	if ST.Killed then return end
	for G in ST.Guns do
		if not FN.IsGun(G) then
			ST.Guns[G] = nil
		elseif ST.GunESP then
			if not FindTag(G,"ESP_BG") then FN.ApplyGun(G) end
		else
			FN.ClearGun(G)
		end
	end
end
FN.CreateTracer=function()
	if ST.Killed then return end
	local CH=LP.Character
	local Gun=CH and CH:FindFirstChild("Gun")
	local Handle=Gun and Gun:FindFirstChild("Handle")
	if not Handle then return end
	local Murder
	for _,P in PS:GetPlayers() do
		if P~=LP and FN.HasTool(P,"Knife") and not ST.DeadPlayers[P] then Murder=P break end
	end
	local HRP=Murder and Murder.Character and Murder.Character:FindFirstChild("HumanoidRootPart")
	if not HRP then return end
	local Tracer=FindTag(Handle,"XYZ_TRACER")
	if Tracer and Tracer.Attachment1 and Tracer.Attachment1.Parent==HRP then return Tracer end
	if Tracer then Tracer:Destroy() end
	Tracer=New("Beam");Tracer:SetAttribute("XYZ_TRACER",true);Tracer.Attachment0=New("Attachment",Handle);Tracer.Attachment1=New("Attachment",HRP);Tracer.FaceCamera=true;Tracer.Width0=.05;Tracer.Width1=.05;Tracer.Color=ColorSequence.new(Color3.fromRGB(255,55,55));Tracer.Transparency=NumberSequence.new(0);Tracer.Parent=Handle
	return Tracer
end
FN.RemoveTracer=function()
	local CH = LP.Character
	if not CH then return end
	local Gun = CH:FindFirstChild("Gun") or LP.Backpack:FindFirstChild("Gun")
	if not Gun then return end
	local Handle = Gun:FindFirstChild("Handle")
	if Handle then
		local Tracer=FindTag(Handle,"XYZ_TRACER")
		if Tracer then Tracer:Destroy() end
	end
end
FN.ApplyKnifeHandleSize=function()
	if ST.Killed then return end
	local Knife = LP.Backpack:FindFirstChild("Knife") or (LP.Character and LP.Character:FindFirstChild("Knife"))
	if not Knife then return end
	local Handle = Knife:FindFirstChild("Handle")
	if not Handle then return end
	local O=Handle:GetAttribute("XYZ_KNIFE_ORIGINAL_SIZE")
	if ST.KnifeReach then
		if typeof(O)~="Vector3" then Handle:SetAttribute("XYZ_KNIFE_ORIGINAL_SIZE",Handle.Size) end
		Handle.Size=Vector3.new(ST.KnifeHandleSize,ST.KnifeHandleSize,ST.KnifeHandleSize)
	elseif typeof(O)=="Vector3" then
		Handle.Size=O;Handle:SetAttribute("XYZ_KNIFE_ORIGINAL_SIZE",nil)
	end
end
FN.CreateKnifeSelectionBox=function()
	if ST.Killed then return end
	local Knife = LP.Backpack:FindFirstChild("Knife") or (LP.Character and LP.Character:FindFirstChild("Knife"))
	if not Knife then return end
	local Handle = Knife:FindFirstChild("Handle")
	if not Handle then return end
	local Selection=FindTag(Handle,"XYZ_KNIFE_BOX")
	if not Selection then
		Selection=New("SelectionBox");Selection:SetAttribute("XYZ_KNIFE_BOX",true)
	end
	Selection.Adornee = Handle;Selection.LineThickness = 0.1;Selection.Color3 = Color3.fromRGB(255, 69, 69);Selection.SurfaceTransparency = 1;Selection.Transparency = 0;Selection.Parent = Handle
end
FN.RemoveKnifeSelectionBox=function()
	local Knife = LP.Backpack:FindFirstChild("Knife") or (LP.Character and LP.Character:FindFirstChild("Knife"))
	if not Knife then return end
	local Handle = Knife:FindFirstChild("Handle")
	if Handle then
		local Selection=FindTag(Handle,"XYZ_KNIFE_BOX")
		if Selection then Selection:Destroy() end
	end
end
FN.UpdateToolVisuals=function()
	if ST.Killed then return end
	local CH = LP.Character
	if not CH then return end
	if CH:FindFirstChild("Gun") then
		if ST.GunTracer then FN.CreateTracer() else FN.RemoveTracer() end
	else
		FN.RemoveTracer()
	end
	FN.ApplyKnifeHandleSize()
	if CH:FindFirstChild("Knife") and ST.KnifeReach then FN.CreateKnifeSelectionBox() else FN.RemoveKnifeSelectionBox() end
end
FN.Section=function(P,Y,Text)
	local H=New("Frame",P,Text.." Section");H.Position=UDim2.fromOffset(10,Y);H.Size=UDim2.new(1,-20,0,22);H.BackgroundTransparency=1
	local T=New("TextLabel",H,Text.." Section Title");T.Size=UDim2.new(1,0,0,17);T.BackgroundTransparency=1;T.Text=Text;T.TextColor3=Color3.fromRGB(165,165,165);T.TextSize=11;T.Font=Enum.Font.RobotoMono;T.TextXAlignment=Enum.TextXAlignment.Left;T.TextStrokeTransparency=.5
	local L=New("Frame",H,Text.." Section Line");L.Position=UDim2.new(0,0,1,-1);L.Size=UDim2.new(1,0,0,1);L.BackgroundColor3=Color3.fromRGB(47,47,47);L.BorderSizePixel=0
	return H
end
FN.Toggle=function(Y,Text,Default,Callback,P)
	P=P or UX.Content or UX.Main
	local Label=New("TextLabel");Label.Size=UDim2.new(1,-82,0,40);Label.Position=UDim2.fromOffset(14,Y);Label.BackgroundTransparency=1;Label.Text=Text;Label.TextXAlignment=Enum.TextXAlignment.Left;Label.TextColor3=Color3.fromRGB(220,220,220);Label.TextSize=13;Label.Font=Enum.Font.RobotoMono;Label.Parent=P;Label.TextStrokeTransparency=.5
	local Switch=New("TextButton");Switch.Size=UDim2.fromOffset(48,26);Switch.Position=UDim2.new(1,-50.48,0,Y+10.12);Switch.BackgroundColor3=Default and COL.ToggleOn or COL.ToggleOff;Switch.BorderSizePixel=0;Switch.AutoButtonColor=false;Switch.Text="";Switch.Parent=P
	local SSZ=New("UIScale",Switch,"Small Toggle Scale");SSZ.Scale=UX.SMALL_CONTROL_SCALE
	New("UICorner",Switch).CornerRadius=UDim.new(1,0)
	local Orb=New("Frame");Orb.Size=UDim2.fromOffset(20,20);Orb.Position=Default and UDim2.fromOffset(25,3) or UDim2.fromOffset(3,3);Orb.BackgroundColor3=COL.OrbColor;Orb.BorderSizePixel=0;Orb.Parent=Switch
	New("UICorner",Orb).CornerRadius=UDim.new(1,0)
	local State,Disabled=Default,false
	local DisabledMessage
	local API={}
	local function Paint(Tweened)
		local BG=Disabled and Color3.fromRGB(145,45,45) or (State and COL.ToggleOn or COL.ToggleOff)
		local LC=Disabled and Color3.fromRGB(255,105,105) or Color3.fromRGB(220,220,220)
		local OC=Disabled and Color3.fromRGB(185,150,150) or COL.OrbColor
		if Tweened then
			TS:Create(Switch,COL.TI,{BackgroundColor3=BG}):Play()
			TS:Create(Label,COL.TI,{TextColor3=LC}):Play()
			TS:Create(Orb,COL.TI,{BackgroundColor3=OC,Position=State and UDim2.fromOffset(25,3) or UDim2.fromOffset(3,3)}):Play()
		else
			Switch.BackgroundColor3=BG Label.TextColor3=LC Orb.BackgroundColor3=OC
			Orb.Position=State and UDim2.fromOffset(25,3) or UDim2.fromOffset(3,3)
		end
	end
	function API:SetDisabled(V,Message)
		DisabledMessage=Message or DisabledMessage
		if Disabled==V then Paint(true) return end
		Disabled=V
		if V and State then
			State=false
			task.spawn(Callback,false)
		end
		Paint(true)
	end
	function API:SetState(V,Silent)
		if Disabled and V then return end
		State=V
		Paint(true)
		task.spawn(Callback,State)
		if not Silent then UX.ShowNotification(Text..": "..(State and "ON" or "OFF"),State) end
	end
	function API:GetState() return State end
	C(Switch.MouseButton1Click,function()
		if Disabled then
			UX.ShowNotification(DisabledMessage or (Text.." unavailable while you are Murderer"),false,2.5)
			return
		end
		API:SetState(not State,false)
	end)
	return API
end
FN.CreateSlider=function(Y, Text, Min, Max, Default, Callback, P)
	P=P or UX.Content or UX.Main
	local Label=New("TextLabel");Label.Size=UDim2.new(1,-28,0,20);Label.Position=UDim2.fromOffset(14,Y);Label.BackgroundTransparency=1;Label.Text=Text..": "..tostring(Default);Label.TextXAlignment=Enum.TextXAlignment.Left;Label.TextColor3=Color3.fromRGB(220,220,220);Label.TextSize=12;Label.Font=Enum.Font.RobotoMono;Label.Parent=P;Label.TextStrokeTransparency=.5
	local SliderBG=New("Frame");SliderBG.AnchorPoint=Vector2.new(.5,0);SliderBG.Size=UDim2.new(1,-28,0,6);SliderBG.Position=UDim2.new(.5,0,0,Y+22.72);SliderBG.BackgroundColor3=Color3.fromRGB(38,38,38);SliderBG.BorderSizePixel=0;SliderBG.Parent=P
	local SSZ=New("UIScale",SliderBG,"Small Slider Scale");SSZ.Scale=UX.SMALL_CONTROL_SCALE
	New("UICorner",SliderBG).CornerRadius=UDim.new(1,0)
	local Fill=New("Frame");Fill.Size=UDim2.new(0,0,1,0);Fill.BackgroundColor3=COL.ToggleOn;Fill.BorderSizePixel=0;Fill.Parent=SliderBG
	New("UICorner",Fill).CornerRadius=UDim.new(1,0)
	local Orb=New("TextButton");Orb.Size=UDim2.fromOffset(14,14);Orb.Position=UDim2.new(0,0,.5,-6);Orb.BackgroundColor3=COL.OrbColor;Orb.BorderSizePixel=0;Orb.Text="";Orb.AutoButtonColor=false;Orb.ZIndex=2;Orb.Parent=SliderBG
	New("UICorner",Orb).CornerRadius=UDim.new(1,0)
	local DraggingSlider,Current,Disabled=false,Default,false
	local API={}
	local function Paint(Instant)
		local LC=Disabled and Color3.fromRGB(105,105,105) or Color3.fromRGB(220,220,220)
		local BG=Disabled and Color3.fromRGB(55,55,55) or Color3.fromRGB(38,38,38)
		local FC=Disabled and Color3.fromRGB(82,82,82) or COL.ToggleOn
		local OC=Disabled and Color3.fromRGB(135,135,135) or COL.OrbColor
		Orb.Active=not Disabled
		if Instant then Label.TextColor3=LC;SliderBG.BackgroundColor3=BG;Fill.BackgroundColor3=FC;Orb.BackgroundColor3=OC else TS:Create(Label,COL.TI,{TextColor3=LC}):Play();TS:Create(SliderBG,COL.TI,{BackgroundColor3=BG}):Play();TS:Create(Fill,COL.TI,{BackgroundColor3=FC}):Play();TS:Create(Orb,COL.TI,{BackgroundColor3=OC}):Play() end
	end
	local function UpdateFromPosition(InputPos)
		local RelativeX=math.clamp((InputPos.X-SliderBG.AbsolutePosition.X)/SliderBG.AbsoluteSize.X,0,1)
		local Value=Min+(Max-Min)*RelativeX;Value=math.floor(Value*10+.5)/10
		Fill.Size=UDim2.new(RelativeX,0,1,0);Orb.Position=UDim2.new(RelativeX,-9,.5,-6);Label.Text=Text..": "..tostring(Value)
		return Value
	end
	function API:SetDisabled(V,Instant) Disabled=V;DraggingSlider=false;Paint(Instant) end
	function API:GetDisabled() return Disabled end
	C(Orb.InputBegan,function(Input)
		if Disabled then return end
		if Input.UserInputType==Enum.UserInputType.MouseButton1 or Input.UserInputType==Enum.UserInputType.Touch then DraggingSlider=true;Current=UpdateFromPosition(Input.Position);Callback(Current) end
	end)
	C(Orb.InputEnded,function(Input)
		if Disabled then DraggingSlider=false return end
		if Input.UserInputType==Enum.UserInputType.MouseButton1 or Input.UserInputType==Enum.UserInputType.Touch then DraggingSlider=false;UX.ShowNotification(Text.." set to: "..tostring(Current),true) end
	end)
	C(UIS.InputChanged,function(Input)
		if not Disabled and DraggingSlider and (Input.UserInputType==Enum.UserInputType.MouseMovement or Input.UserInputType==Enum.UserInputType.Touch) then Current=UpdateFromPosition(Input.Position);Callback(Current) end
	end)
	local InitialRelative=math.clamp((Default-Min)/(Max-Min),0,1);Fill.Size=UDim2.new(InitialRelative,0,1,0);Orb.Position=UDim2.new(InitialRelative,-9,.5,-6);Label.Text=Text..": "..tostring(Default)
	return API
end
FN.SetGetDisabled=function(V)
	if not UX.Get or not UX.Get.Parent then return end
	UX.Get:SetAttribute("RoleDisabled",V)
	UX.Get.Text=V and "GET GUN - MURDER" or "GET GUN";UX.Get.BackgroundColor3=V and Color3.fromRGB(95,38,38) or Color3.fromRGB(38,38,38);UX.Get.TextColor3=V and Color3.fromRGB(255,105,105) or COL.GunText
end
FN.UpdateSelfMurder=function()
	local Now=FN.IsSelfMurder()
	local Changed=Now~=ST.SelfMurder
	ST.SelfMurder=Now
	if CTRL.GunESPControl then CTRL.GunESPControl:SetDisabled(Now) end
	if CTRL.AutoPickControl then CTRL.AutoPickControl:SetDisabled(Now) end
	if CTRL.GunTracerControl then CTRL.GunTracerControl:SetDisabled(Now) end
	if CTRL.MurderLockControl then CTRL.MurderLockControl:SetDisabled(Now) end
	if CTRL.AutoLockControl then CTRL.AutoLockControl:SetDisabled(Now) end
	if CTRL.AutoShootControl then CTRL.AutoShootControl:SetDisabled(Now) end
	if CTRL.AutoWinControl then CTRL.AutoWinControl:SetDisabled(not Now and not ST.AutoWinMurder,"You are not Murderer") end
	FN.SetGetDisabled(Now)
	if Now then
		ST.GunESP=false ST.AutoPick=false ST.GunTracer=false ST.MurderLock=false ST.AutoLock=false ST.AutoShoot=false
		ST.AimHeld=false ST.AimTarget=nil
		FN.RemoveTracer()
		if Changed then UX.ShowNotification("You are Murderer - gun features disabled",false,4.5) end
	elseif Changed then
		UX.ShowNotification("You are no longer Murderer",true,2.5)
	end
end
;(function()
	local AWHome,AWWaitCF,AWStartCharacter,AWTarget=nil,nil,nil,nil
	local AWQueue={}
	local AWIndex=1
	local AWWaiting=false
	local AWPlatform=nil
	local AWMove=nil
	local AWEnded=false
	local AWReleased=false
	local AWLastClick=0
	local AW_CLICK_DELAY=.06
	local AW_PLATFORM_SIZE=Vector3.new(15,2,15)
	local function AWDestroyPlatform()
		if AWPlatform and AWPlatform.Parent then AWPlatform:Destroy() end
		AWPlatform=nil
	end
	local function AWRestoreMove()
		local M=AWMove
		AWMove=nil
		if not M then return end
		local HUM=M.HUM
		if HUM and HUM.Parent then
			HUM.WalkSpeed=M.WS;HUM.AutoRotate=M.AR
			if M.UJP then HUM.JumpPower=M.JP else HUM.JumpHeight=M.JH end
		end
	end
	local function AWSaveMove(HUM)
		if AWMove and AWMove.HUM==HUM then return end
		AWRestoreMove()
		AWMove={HUM=HUM,WS=HUM.WalkSpeed,AR=HUM.AutoRotate,UJP=HUM.UseJumpPower,JP=HUM.JumpPower,JH=HUM.JumpHeight}
	end
	local function AWMakePlatform()
		if not AWHome then return end
		local Top=AWHome.Position+Vector3.new(0,-ST.AUTO_WIN_WAIT_DEPTH,0)
		local P=AWPlatform
		if not P or not P.Parent then
			P=New("Part",WS,"XYZ AutoWin Platform");P.Size=AW_PLATFORM_SIZE;P.Anchored=true;P.CanCollide=true;P.CanTouch=true;P.CanQuery=true;P.CastShadow=false;P.Material=Enum.Material.SmoothPlastic;P.Color=Color3.fromRGB(32,32,32);P.Transparency=.15
			AWPlatform=P
		end
		P.CFrame=CFrame.new(Top-Vector3.new(0,AW_PLATFORM_SIZE.Y*.5,0))
	end
	local function AWStand(CH,HUM,HRP,First)
		if not AWHome then return end
		AWSaveMove(HUM)
		AWMakePlatform()
		local Top=AWHome.Position+Vector3.new(0,-ST.AUTO_WIN_WAIT_DEPTH,0)
		local H=HUM.HipHeight+(HRP.Size.Y*.5)+.05
		AWWaitCF=CFrame.new(Top+Vector3.new(0,H,0))*AWHome.Rotation
		HUM.WalkSpeed=0;HUM.AutoRotate=false
		if HUM.UseJumpPower then HUM.JumpPower=0 else HUM.JumpHeight=0 end
		HUM.Jump=false
		HUM:Move(Vector3.zero,false)
		local D=(HRP.Position-AWWaitCF.Position).Magnitude
		if AWEnded and D>8 then
			AWReleased=true
			AWRestoreMove()
			AWDestroyPlatform()
			AWWaitCF=nil
			return
		end
		if First or D>2.5 then CH:PivotTo(AWWaitCF) end
		HRP.AssemblyLinearVelocity=Vector3.zero;HRP.AssemblyAngularVelocity=Vector3.zero
	end
	local function AWClick(CH,HUM)
		if AWWaiting then return end
		local BP=LP:FindFirstChild("Backpack")
		local K=(CH and CH:FindFirstChild("Knife")) or (BP and BP:FindFirstChild("Knife"))
		if not K or not K:IsA("Tool") then return end
		if K.Parent~=CH then pcall(function() HUM:EquipTool(K) end) end
		local T=os.clock()
		if T-AWLastClick<AW_CLICK_DELAY then return end
		AWLastClick=T
		pcall(function() K:Activate() end)
	end
	local function AWBuildQueue()
		table.clear(AWQueue)
		AWIndex=1
		AWTarget=nil
		for _,P in ipairs(PS:GetPlayers()) do
			if P~=LP then table.insert(AWQueue,P) end
		end
	end
	local function AWBeginRound(CH,Notify)
		local HRP=CH and CH:FindFirstChild("HumanoidRootPart")
		local HUM=CH and CH:FindFirstChildOfClass("Humanoid")
		if not CH or not HRP or not HUM or HUM.Health<=0 then return false end
		AWRestoreMove()
		AWDestroyPlatform()
		AWStartCharacter=CH
		AWHome=CH:GetPivot()
		AWWaitCF=nil
		AWWaiting=false
		AWEnded=false
		AWReleased=false
		AWLastClick=0
		AWBuildQueue()
		if Notify then UX.ShowNotification("New Murderer round - Auto Win resumed",true,2.5) end
		return true
	end
	AW.ClearAutoWinState=function()
		ST.AutoWinMurder=false
		AWRestoreMove()
		AWDestroyPlatform()
		AWHome=nil
		AWWaitCF=nil
		AWStartCharacter=nil
		AWTarget=nil
		table.clear(AWQueue)
		AWIndex=1
		AWWaiting=false
		AWEnded=false
		AWReleased=false
		AWLastClick=0
	end
	local function StartAutoWin()
		if ST.Killed then return false end
		if not ST.SelfMurder then
			UX.ShowNotification("You are not Murderer",false,3)
			return false
		end
		local CH=LP.Character
		if not AWBeginRound(CH,false) then
			UX.ShowNotification("Character is not ready",false,2.5)
			return false
		end
		ST.AutoWinMurder=true
		UX.ShowNotification("Auto Win (Murderer) started",true,2.5)
		return true
	end
	AW.SetAutoWin=function(V)
		if V then
			if not StartAutoWin() then
				task.defer(function()
					if CTRL.AutoWinControl and CTRL.AutoWinControl:GetState() then CTRL.AutoWinControl:SetState(false,true) end
				end)
			end
		else
			AW.ClearAutoWinState()
		end
	end
	AW.AutoWinStep=function()
		if not ST.AutoWinMurder or ST.Killed then return end
		local CH=LP.Character
		if not CH then return end
		if CH~=AWStartCharacter then
			AWStartCharacter=CH
			if AWWaiting then
				AWReleased=true
				AWEnded=true
				AWRestoreMove()
				AWDestroyPlatform()
				AWWaitCF=nil
			end
		end
		local HRP=CH:FindFirstChild("HumanoidRootPart")
		local HUM=CH:FindFirstChildOfClass("Humanoid")
		if not HRP or not HUM or HUM.Health<=0 then return end
		if AWWaiting then
			if not ST.SelfMurder then AWEnded=true end
			if AWEnded and ST.SelfMurder then
				if AWBeginRound(CH,true) then return end
			end
			if not AWReleased then AWStand(CH,HUM,HRP,false) end
			return
		end
		if AWTarget then
			local TCH=AWTarget.Character
			local TH=TCH and TCH:FindFirstChildOfClass("Humanoid")
			local TR=TCH and TCH:FindFirstChild("HumanoidRootPart")
			if not AWTarget.Parent or not TH or TH.Health<=0 or not TR then
				if TH and TH.Health<=0 then UX.ShowNotification("Target down: "..AWTarget.Name,true,2) end
				AWTarget=nil
				AWIndex+=1
			end
		end
		while not AWTarget and AWIndex<=#AWQueue do
			local P=AWQueue[AWIndex]
			local TCH=P and P.Parent and P.Character
			local TH=TCH and TCH:FindFirstChildOfClass("Humanoid")
			local TR=TCH and TCH:FindFirstChild("HumanoidRootPart")
			if P and P.Parent and TH and TH.Health>0 and TR then
				AWTarget=P
			else
				AWIndex+=1
			end
		end
		if AWTarget then
			local TCH=AWTarget.Character
			local TR=TCH and TCH:FindFirstChild("HumanoidRootPart")
			if TR then
				local Pos=TR.Position-(TR.CFrame.LookVector*ST.AUTO_WIN_DISTANCE)
				CH:PivotTo(CFrame.lookAt(Pos,TR.Position,Vector3.yAxis))
				HRP.AssemblyLinearVelocity=Vector3.zero;HRP.AssemblyAngularVelocity=Vector3.zero
				AWClick(CH,HUM)
			end
			return
		end
		AWWaiting=true
		AWEnded=not ST.SelfMurder
		AWReleased=false
		AWStand(CH,HUM,HRP,true)
		UX.ShowNotification("Queue finished - waiting 15 studs below home",true,3)
	end
	AW.AutoWinCharacterAdded=function(CH)
		if not ST.AutoWinMurder then return end
		AWStartCharacter=CH
		AWTarget=nil
		AWWaiting=true
		AWEnded=true
		AWReleased=true
		AWRestoreMove()
		AWDestroyPlatform()
		AWWaitCF=nil
	end
end)()
FN.KeyName=function(K)
	if K==Enum.UserInputType.MouseButton1 then return "LMB" end
	if K==Enum.UserInputType.MouseButton2 then return "RMB" end
	if K==Enum.UserInputType.MouseButton3 then return "MMB" end
	return K.Name
end
FN.InputKey=function(I)
	if I.UserInputType==Enum.UserInputType.Keyboard and I.KeyCode~=Enum.KeyCode.Unknown then return I.KeyCode end
	if I.UserInputType==Enum.UserInputType.MouseButton1 or I.UserInputType==Enum.UserInputType.MouseButton2 or I.UserInputType==Enum.UserInputType.MouseButton3 then return I.UserInputType end
end
FN.IsAimKey=function(I)
	return ST.AimKey.EnumType==Enum.KeyCode and I.KeyCode==ST.AimKey or ST.AimKey.EnumType==Enum.UserInputType and I.UserInputType==ST.AimKey
end
FN.IsUIKey=function(I)
	local K=ST.UIHotkey.Key;return K.EnumType==Enum.KeyCode and I.KeyCode==K or K.EnumType==Enum.UserInputType and I.UserInputType==K
end
FN.CanSeeTarget=function(CH,HRP)
	local Cam=WS.CurrentCamera
	if not Cam or not CH or not HRP then return false end
	local RP=RaycastParams.new()
	RP.FilterType=Enum.RaycastFilterType.Exclude;RP.FilterDescendantsInstances={LP.Character}
	local R=WS:Raycast(Cam.CFrame.Position,HRP.Position-Cam.CFrame.Position,RP)
	return not R or R.Instance:IsDescendantOf(CH)
end
FN.InFOV=function(P)
	local Cam=WS.CurrentCamera
	local CH=P and P.Character
	local HRP=CH and CH:FindFirstChild("HumanoidRootPart")
	if not Cam or not HRP then return false end
	local V,On=Cam:WorldToViewportPoint(HRP.Position)
	if not On or V.Z<=0 then return false end
	local VP=Cam.ViewportSize
	return (Vector2.new(V.X,V.Y)-Vector2.new(VP.X*.5,VP.Y*.5)).Magnitude<=ST.FOVSize
end
FN.GetLiveMurderer=function()
	for _,P in PS:GetPlayers() do
		if P~=LP and not ST.DeadPlayers[P] and (ST.Roles[P]=="Murder" or FN.HasTool(P,"Knife")) then
			local CH=P.Character
			local HUM=CH and CH:FindFirstChildOfClass("Humanoid")
			if HUM and HUM.Health>0 then return P end
		end
	end
end
FN.GetMurderTarget=function()
	local Cam=WS.CurrentCamera
	if not Cam then return end
	local VP=Cam.ViewportSize
	local Center=Vector2.new(VP.X*.5,VP.Y*.5)
	local Best,BD=nil,ST.FOVSize
	for _,P in PS:GetPlayers() do
		if P~=LP and not ST.DeadPlayers[P] and (ST.Roles[P]=="Murder" or FN.HasTool(P,"Knife")) then
			local CH=P.Character
			local HRP=CH and CH:FindFirstChild("HumanoidRootPart")
			local HUM=CH and CH:FindFirstChildOfClass("Humanoid")
			if HRP and HUM and HUM.Health>0 then
				local V,On=Cam:WorldToViewportPoint(HRP.Position)
				if On and V.Z>0 then
					local D=(Vector2.new(V.X,V.Y)-Center).Magnitude
					if D<BD and FN.CanSeeTarget(CH,HRP) then Best=P BD=D end
				end
			end
		end
	end
	return Best
end
FN.StartAimRecording=function()
	if ST.Killed or ST.AimRecording or not UX.AimKeyButton then return end
	ST.AimRecording=true
	UX.AimKeyButton.Text="REC";UX.AimKeyButton.BackgroundColor3=Color3.fromRGB(105,42,42);UX.AimKeyButton.TextColor3=Color3.fromRGB(255,105,105)
end
FN.StopAimRecording=function(K)
	ST.AimRecording=false
	if K then ST.AimKey=K end
	if UX.AimKeyButton and UX.AimKeyButton.Parent then
		UX.AimKeyButton.Text=FN.KeyName(ST.AimKey);UX.AimKeyButton.BackgroundColor3=Color3.fromRGB(48,48,48);UX.AimKeyButton.TextColor3=Color3.fromRGB(225,225,225)
	end
end
FN.CreateHotkey=function(Y,P)
	P=P or UX.Content or UX.Main
	local L=New("TextLabel",P,"Aimlock Hotkey Label");L.Size=UDim2.new(1,-96,0,40);L.Position=UDim2.fromOffset(14,Y);L.BackgroundTransparency=1;L.Text="AIMLOCK Hotkey";L.TextXAlignment=Enum.TextXAlignment.Left;L.TextColor3=Color3.fromRGB(220,220,220);L.TextSize=12;L.Font=Enum.Font.RobotoMono;L.TextStrokeTransparency=.5
	UX.AimKeyButton=New("TextButton",P,"Aimlock Hotkey");UX.AimKeyButton.Size=UDim2.fromOffset(64,26);UX.AimKeyButton.Position=UDim2.new(1,-78,0,Y+7);UX.AimKeyButton.BackgroundColor3=Color3.fromRGB(48,48,48);UX.AimKeyButton.BorderSizePixel=0;UX.AimKeyButton.AutoButtonColor=false;UX.AimKeyButton.Text=FN.KeyName(ST.AimKey);UX.AimKeyButton.TextColor3=Color3.fromRGB(225,225,225);UX.AimKeyButton.TextSize=12;UX.AimKeyButton.Font=Enum.Font.RobotoMono
	New("UICorner",UX.AimKeyButton).CornerRadius=UDim.new(0,5)
	C(UX.AimKeyButton.MouseEnter,function()
		if not ST.AimRecording then TS:Create(UX.AimKeyButton,TweenInfo.new(.12),{BackgroundColor3=Color3.fromRGB(62,62,62)}):Play() end
	end)
	C(UX.AimKeyButton.MouseLeave,function()
		if not ST.AimRecording then TS:Create(UX.AimKeyButton,TweenInfo.new(.12),{BackgroundColor3=Color3.fromRGB(48,48,48)}):Play() end
	end)
	C(UX.AimKeyButton.MouseButton1Click,FN.StartAimRecording)
end
FN.StopUIHotkeyRecording=function(K)
	ST.UIHotkey.Recording=false;if K then ST.UIHotkey.Key=K end
	local B=ST.UIHotkey.Button;if B and B.Parent then B.Text=FN.KeyName(ST.UIHotkey.Key);B.BackgroundColor3=Color3.fromRGB(48,48,48);B.TextColor3=Color3.fromRGB(225,225,225) end
end
FN.CreateUIHotkey=function(Y,P)
	local L=New("TextLabel",P,"UI Hotkey Label");L.Size=UDim2.new(1,-96,0,40);L.Position=UDim2.fromOffset(14,Y);L.BackgroundTransparency=1;L.Text="UI Hotkey";L.TextXAlignment=Enum.TextXAlignment.Left;L.TextColor3=Color3.fromRGB(220,220,220);L.TextSize=12;L.Font=Enum.Font.RobotoMono;L.TextStrokeTransparency=.5
	local B=New("TextButton",P,"UI Hotkey");B.Size=UDim2.fromOffset(64,26);B.Position=UDim2.new(1,-78,0,Y+7);B.BackgroundColor3=Color3.fromRGB(48,48,48);B.BorderSizePixel=0;B.AutoButtonColor=false;B.Text=FN.KeyName(ST.UIHotkey.Key);B.TextColor3=Color3.fromRGB(225,225,225);B.TextSize=12;B.Font=Enum.Font.RobotoMono;B.TextStrokeTransparency=.5;ST.UIHotkey.Button=B
	New("UICorner",B).CornerRadius=UDim.new(0,5)
	C(B.MouseEnter,function() if not ST.UIHotkey.Recording then TS:Create(B,TweenInfo.new(.12),{BackgroundColor3=Color3.fromRGB(62,62,62)}):Play() end end)
	C(B.MouseLeave,function() if not ST.UIHotkey.Recording then TS:Create(B,TweenInfo.new(.12),{BackgroundColor3=Color3.fromRGB(48,48,48)}):Play() end end)
	C(B.MouseButton1Click,function() if ST.Killed or ST.UIHotkey.Recording then return end;ST.UIHotkey.Recording=true;B.Text="REC";B.BackgroundColor3=Color3.fromRGB(105,42,42);B.TextColor3=Color3.fromRGB(255,105,105) end)
end
FN.TargetValid=function(P)
	if not P or P==LP or ST.DeadPlayers[P] or not FN.HasTool(P,"Knife") then return false end
	local CH=P.Character
	local HRP=CH and CH:FindFirstChild("HumanoidRootPart")
	local HUM=CH and CH:FindFirstChildOfClass("Humanoid")
	return HRP and HUM and HUM.Health>0 and FN.InFOV(P) and FN.CanSeeTarget(CH,HRP) or false
end
FN.TryAutoShoot=function(P)
	if not ST.AutoShoot or ST.SelfMurder or not FN.TargetValid(P) then return end
	local Now=os.clock()
	if Now-ST.LastShot<.12 then return end
	local CH=LP.Character
	local HUM=CH and CH:FindFirstChildOfClass("Humanoid")
	local BP=LP:FindFirstChild("Backpack")
	local Gun=(CH and CH:FindFirstChild("Gun")) or (BP and BP:FindFirstChild("Gun"))
	if not CH or not HUM or not Gun or not Gun:IsA("Tool") then return end
	if Gun.Parent~=CH then pcall(function() HUM:EquipTool(Gun) end) end
	ST.LastShot=Now
	pcall(function() Gun:Activate() end)
end
FN.UpdateFOVVisual=function()
	if not UX.FOVRing then return end
	UX.FOVRing.Visible=ST.FOVCircle and not ST.Killed;UX.FOVRing.Size=UDim2.fromOffset(ST.FOVSize*2,ST.FOVSize*2)
	if not UX.FOVStroke then return end
	local White=Color3.fromRGB(255,255,255)
	local Green=Color3.fromRGB(55,220,95)
	local Cam=WS.CurrentCamera
	if not ST.FOVCircle or not Cam then UX.FOVStroke.Color=White return end
	local VP=Cam.ViewportSize
	local Center=Vector2.new(VP.X*.5,VP.Y*.5)
	local Important=false
	for _,P in ipairs(PS:GetPlayers()) do
		if P~=LP and not ST.DeadPlayers[P] then
			local CH=P.Character
			local HRP=CH and CH:FindFirstChild("HumanoidRootPart")
			local HUM=CH and CH:FindFirstChildOfClass("Humanoid")
			if HRP and HUM and HUM.Health>0 then
				local V,On=Cam:WorldToViewportPoint(HRP.Position)
				if On and V.Z>0 and (Vector2.new(V.X,V.Y)-Center).Magnitude<=ST.FOVSize then
					local R=ST.Roles[P]
					if FN.HasTool(P,"Knife") or R=="Murder" or R=="Sheriff" then
						Important=true
						break
					end
				end
			end
		end
	end
	UX.FOVStroke.Color=Important and Green or White
end
FN.UpdateGunDropScreenTracer=function()
	if not UX.GunDropScreenTracer then return end
	if ST.Killed or ST.SelfMurder or not ST.GunESP then UX.GunDropScreenTracer.Visible=false return end
	local G=FN.FindGun(true)
	local Cam=WS.CurrentCamera
	if not FN.IsGun(G) or not Cam then UX.GunDropScreenTracer.Visible=false return end
	local P,On=Cam:WorldToViewportPoint(G.Position)
	if not On or P.Z<=0 then UX.GunDropScreenTracer.Visible=false return end
	local A=Vector2.new(Cam.ViewportSize.X*.5,0)
	local B=Vector2.new(P.X,P.Y)
	local D=B-A
	local L=D.Magnitude
	if L<1 then UX.GunDropScreenTracer.Visible=false return end
	UX.GunDropScreenTracer.Visible=true;UX.GunDropScreenTracer.Size=UDim2.fromOffset(L,2);UX.GunDropScreenTracer.Position=UDim2.fromOffset((A.X+B.X)*.5,(A.Y+B.Y)*.5);UX.GunDropScreenTracer.Rotation=math.deg(math.atan2(D.Y,D.X))
end
FN.UpdateAimTracer=function()
	if not ST.GunTracer then return end
	local CH=LP.Character
	local Gun=CH and CH:FindFirstChild("Gun")
	local Handle=Gun and Gun:FindFirstChild("Handle")
	if not Handle then return end
	local Murder
	for _,P in PS:GetPlayers() do
		if P~=LP and FN.HasTool(P,"Knife") and not ST.DeadPlayers[P] then Murder=P break end
	end
	local HRP=Murder and Murder.Character and Murder.Character:FindFirstChild("HumanoidRootPart")
	if not HRP then FN.RemoveTracer() return end
	local Tracer=FindTag(Handle,"XYZ_TRACER")
	if not Tracer or not Tracer.Attachment1 or Tracer.Attachment1.Parent~=HRP then
		FN.CreateTracer()
		Tracer=FindTag(Handle,"XYZ_TRACER")
	end
	if not Tracer then return end
	local CanLock=not ST.SelfMurder and (ST.MurderLock or ST.AutoLock) and not ST.AimRecording and FN.TargetValid(Murder)
	Tracer.Color=ColorSequence.new(CanLock and Color3.fromRGB(55,220,95) or Color3.fromRGB(235,60,60))
end
UX.KillScript=function()
	if ST.Killed then return end
	FN.SaveSettings()
	FN.SetNoClip(false)
	FN.SetAntiFling(false)
	FN.SetLowGFX(false)
	ST.KnifeReach=false;FN.ApplyKnifeHandleSize();FN.RemoveKnifeSelectionBox()
	AW.ClearAutoWinState()
	ST.Killed=true
	ST.BoxESP,ST.SkeletonESP,ST.InnocentESP,ST.GunESP,ST.AutoPick,ST.GunTracer,ST.PlayerTracers,ST.MurderLock,ST.AutoLock,ST.AutoShoot,ST.LowGFX,ST.NoClip=false,false,false,false,false,false,false,false,false,false,false,false
	ST.AimHeld,ST.AimTarget,ST.AimRecording=false,nil,false
	pcall(function() RS:UnbindFromRenderStep(UX.AimRenderName) end)
	for _,P in PS:GetPlayers() do
		if P~=LP then FN.ClearPlayer(P) end
	end
	for G in ST.Guns do FN.ClearGun(G) end
	FN.RemoveTracer()
	FN.RemoveKnifeSelectionBox()
	if UX.FOVRing then UX.FOVRing:Destroy() UX.FOVRing=nil end
	if UX.GunDropScreenTracer then UX.GunDropScreenTracer:Destroy() UX.GunDropScreenTracer=nil end
	for _,X in ipairs(ST.CN) do
		pcall(function() X:Disconnect() end)
	end
	table.clear(ST.CN)
	if UX.ClearNotifications then UX.ClearNotifications() end
	if UX.UI and UX.UI.Parent then UX.UI:Destroy() end
	ClearHubUI()
	if SES.Kill==UX.KillScript then SES.Kill=nil end
	if not Debug and UX.HUI and UX.HUI.Parent and #UX.HUI:GetChildren()==0 then UX.HUI:Destroy() end
end
SES.Kill=UX.KillScript
;(function()
	local MainStarted=false
	local function StartMain()
	if MainStarted or ST.Killed then return end
	MainStarted=true
	FN.SetupUI()
	UX.ShowNotification("Loading XYZ Hub",true,2.5)
	RS:BindToRenderStep(UX.AimRenderName,Enum.RenderPriority.Camera.Value+1,function()
		if ST.Killed then return end
		FN.UpdatePlayerESP()
		FN.UpdateNoClip()
		FN.UpdateGunDropScreenTracer()
		FN.UpdateFOVVisual()
		FN.UpdateAimTracer()
		AW.AutoWinStep()
		if ST.SelfMurder or ST.AimRecording then return end
		if not FN.GetLiveMurderer() then ST.AimHeld=false;ST.AimTarget=nil end
		if ST.AutoLock then
			if not FN.TargetValid(ST.AimTarget) then
				ST.AimTarget=FN.GetMurderTarget()
			end
			ST.AimHeld=ST.AimTarget~=nil
		end
		local Active=(ST.AutoLock and ST.AimTarget~=nil) or (ST.MurderLock and ST.AimHeld and ST.AimTarget~=nil)
		if not Active then return end
		if not FN.TargetValid(ST.AimTarget) then
			ST.AimHeld=false
			ST.AimTarget=nil
			return
		end
		local CH=ST.AimTarget.Character
		local HRP=CH and CH:FindFirstChild("HumanoidRootPart")
		local Cam=WS.CurrentCamera
		if not Cam or not HRP then return end
		Cam.CFrame=CFrame.lookAt(Cam.CFrame.Position,HRP.Position)
		FN.TryAutoShoot(ST.AimTarget)
	end)

	FN.SyncGunRoleState()
	for _,P in PS:GetPlayers() do task.spawn(FN.BindPlayer,P) end
	C(PS.PlayerAdded,function(P) task.spawn(FN.BindPlayer,P) end)
	C(PS.PlayerRemoving,function(P)
		FN.ClearPlayer(P)
		ST.Roles[P] = nil
		ST.DeadPlayers[P] = nil
		if ST.Hero==P then ST.Hero=nil end
		task.defer(FN.CheckHero)
	end)
	for _,V in WS:GetDescendants() do if FN.IsGun(V) then FN.TrackGun(V) end end
	C(WS.DescendantAdded,function(V)
		if V:IsA("BasePart") and V.Name == "GunDrop" then
			task.defer(function() task.wait() if FN.IsGun(V) then FN.TrackGun(V) end end)
		end
	end)
	C(WS.DescendantRemoving,function(V)
		if ST.Guns[V] then ST.Guns[V] = nil end
	end)
	-- CONFIG / SCRIPT
	FN.Section(UX.ConfigPage,6,"Script")
	FN.CreateUIHotkey(28,UX.ConfigPage)
	UX.Kill=New("TextButton",UX.ConfigPage,"Kill");UX.Kill.Size=UDim2.new(1,-28,0,34);UX.Kill.Position=UDim2.fromOffset(14,72);UX.Kill.BackgroundColor3=Color3.fromRGB(78,39,39);UX.Kill.BorderSizePixel=0;UX.Kill.AutoButtonColor=false;UX.Kill.Text="KILL SCRIPT";UX.Kill.TextColor3=Color3.fromRGB(255,105,105);UX.Kill.TextSize=11;UX.Kill.Font=Enum.Font.RobotoMono;UX.Kill.TextStrokeTransparency=.5;UX.Kill.ZIndex=10
	New("UICorner",UX.Kill).CornerRadius=UDim.new(0,4)
	local KS=New("UIStroke",UX.Kill);KS.Color=Color3.fromRGB(112,52,52);KS.Thickness=1
	C(UX.Kill.MouseEnter,function() TS:Create(UX.Kill,TweenInfo.new(.12),{BackgroundColor3=Color3.fromRGB(108,45,45),TextColor3=Color3.fromRGB(255,140,140)}):Play() end)
	C(UX.Kill.MouseLeave,function() TS:Create(UX.Kill,TweenInfo.new(.12),{BackgroundColor3=Color3.fromRGB(78,39,39),TextColor3=Color3.fromRGB(255,105,105)}):Play() end)
	C(UX.Kill.MouseButton1Click,function()
		if ST.Killed or UX.Killing then return end
		UX.Killing=true
		task.spawn(function()
			for I=3,1,-1 do UX.ShowNotification("Killing script in "..I.."...",false,1);task.wait(1) end
			UX.KillScript()
		end)
	end)
	-- VISUALS / PLAYER ESP
	FN.Section(UX.VisualsPage,6,"Player ESP")
	CTRL.BoxESPControl=FN.Toggle(28,"ESP Box",ST.BoxESP,function(V) ST.BoxESP=V FN.RefreshPlayers() end,UX.VisualsPage)
	CTRL.SkeletonESPControl=FN.Toggle(70,"Skeleton ESP",ST.SkeletonESP,function(V) ST.SkeletonESP=V FN.RefreshPlayers() end,UX.VisualsPage)
	CTRL.InnocentESPControl=FN.Toggle(112,"Innocent ESP",ST.InnocentESP,function(V) ST.InnocentESP=V FN.RefreshPlayers() end,UX.VisualsPage)
	CTRL.PlayerTracersControl=FN.Toggle(154,"Player Tracers",ST.PlayerTracers,function(V) ST.PlayerTracers=V FN.RefreshPlayers() end,UX.VisualsPage)
	-- VISUALS / WORLD
	FN.Section(UX.VisualsPage,200,"World Visuals")
	CTRL.GunESPControl=FN.Toggle(222,"Gun ESP",ST.GunESP,function(V) ST.GunESP=V FN.RefreshGuns() end,UX.VisualsPage)
	CTRL.GunTracerControl=FN.Toggle(264,"Gun Tracer",ST.GunTracer,function(V) ST.GunTracer=V FN.UpdateToolVisuals() end,UX.VisualsPage)
	CTRL.LowGFXControl=FN.Toggle(306,"LOW GFX",ST.LowGFX,function(V) FN.SetLowGFX(V) end,UX.VisualsPage)
	if ST.LowGFX then FN.SetLowGFX(true) end
	-- VISUALS / AIMING
	FN.Section(UX.VisualsPage,354,"Aiming")
	CTRL.FOVCircleControl=FN.Toggle(376,"FOV Circle",ST.FOVCircle,function(V) ST.FOVCircle=V FN.UpdateFOVVisual() end,UX.VisualsPage)
	FN.CreateSlider(422,"FOV Size",30,300,ST.FOVSize,function(V) ST.FOVSize=V FN.UpdateFOVVisual() end,UX.VisualsPage)
	-- MISC / GUN
	FN.Section(UX.MiscPage,6,"Gun")
	CTRL.AutoPickControl=FN.Toggle(28,"Auto Pick Gun",ST.AutoPick,function(V) ST.AutoPick=V if ST.AutoPick and not ST.SelfMurder then FN.PickGun() end end,UX.MiscPage)
	UX.Get=New("TextButton",UX.MiscPage,"Get Gun");UX.Get.Size=UDim2.new(1,-28,0,34);UX.Get.Position=UDim2.fromOffset(14,70);UX.Get.BackgroundColor3=Color3.fromRGB(38,38,38);UX.Get.BorderSizePixel=0;UX.Get.AutoButtonColor=false;UX.Get.Text="GET GUN";UX.Get.TextColor3=COL.GunText;UX.Get.TextSize=13;UX.Get.Font=Enum.Font.RobotoMono
	New("UICorner",UX.Get).CornerRadius=UDim.new(0,6)
	C(UX.Get.MouseEnter,function() if not UX.Get:GetAttribute("RoleDisabled") then TS:Create(UX.Get,TweenInfo.new(.12),{BackgroundColor3=Color3.fromRGB(48,48,48)}):Play() end end)
	C(UX.Get.MouseLeave,function() if not UX.Get:GetAttribute("RoleDisabled") then TS:Create(UX.Get,TweenInfo.new(.12),{BackgroundColor3=Color3.fromRGB(38,38,38)}):Play() end end)
	C(UX.Get.MouseButton1Click,function()
		if ST.Killed then return end
		if ST.SelfMurder then UX.ShowNotification("You are Murderer - gun unavailable",false,2.5) return end
		local G=FN.FindGun()
		if not FN.IsGun(G) then UX.ShowNotification("No Gun Found!",false,2.5) return end
		FN.PickGun(G)
		UX.ShowNotification("Getting gun...",true)
	end)
	FN.Section(UX.MiscPage,116,"Aiming")
	CTRL.MurderLockControl=FN.Toggle(138,"Murderer Lock",ST.MurderLock,function(V)
		ST.MurderLock=V
		if not V and not ST.AutoLock then ST.AimHeld=false ST.AimTarget=nil end
	end,UX.MiscPage)
	FN.CreateHotkey(180,UX.MiscPage)
	CTRL.AutoLockControl=FN.Toggle(222,"Auto Lock",ST.AutoLock,function(V)
		ST.AutoLock=V
		if not V and not ST.MurderLock then ST.AimHeld=false ST.AimTarget=nil end
	end,UX.MiscPage)
	CTRL.AutoShootControl=FN.Toggle(264,"Auto Shoot",ST.AutoShoot,function(V) ST.AutoShoot=V end,UX.MiscPage)
	FN.Section(UX.MiscPage,312,"Player")
	CTRL.KnifeReachControl=FN.Toggle(334,"Knife Reach",ST.KnifeReach,function(V) ST.KnifeReach=V;if CTRL.KnifeSliderControl then CTRL.KnifeSliderControl:SetDisabled(not V) end;FN.UpdateToolVisuals() end,UX.MiscPage)
	CTRL.KnifeSliderControl=FN.CreateSlider(378,"Knife Hitbox Size",1.5,250,ST.KnifeHandleSize,function(V) ST.KnifeHandleSize=V FN.UpdateToolVisuals() end,UX.MiscPage);CTRL.KnifeSliderControl:SetDisabled(not ST.KnifeReach,true)
	CTRL.AntiFlingControl=FN.Toggle(420,"Anti Fling",ST.AntiFling,function(V) FN.SetAntiFling(V) end,UX.MiscPage)
	CTRL.NoClipControl=FN.Toggle(462,"NoClip",ST.NoClip,function(V) FN.SetNoClip(V) end,UX.MiscPage)
	if ST.AntiFling then FN.SetAntiFling(true) end;if ST.NoClip then FN.SetNoClip(true) end
	FN.Section(UX.MiscPage,508,"Murderer")
	CTRL.AutoWinControl=FN.Toggle(530,"Auto Win (Murderer)",ST.AutoWinMurder,function(V) AW.SetAutoWin(V) end,UX.MiscPage)
	CTRL.AutoWinControl:SetDisabled(not ST.SelfMurder,"You are not Murderer")
	-- EASY CREDIT EDIT
	;(function()
		local CREDIT_TITLE="Credits"
		local CREDIT_TEXT="Credits to XYZMISH for creating this UI"
		local CreditSection=New("Frame",UX.CreditsPage,"Credits Section");CreditSection.AnchorPoint=Vector2.new(.5,.5);CreditSection.Position=UDim2.new(.5,0,.5,-4);CreditSection.Size=UDim2.new(1,-34,0,78);CreditSection.BackgroundTransparency=1
		local CreditTitle=New("TextLabel",CreditSection,"Credits Title");CreditTitle.Size=UDim2.new(1,0,0,24);CreditTitle.Position=UDim2.fromOffset(0,0);CreditTitle.BackgroundTransparency=1;CreditTitle.Text=CREDIT_TITLE;CreditTitle.TextColor3=Color3.fromRGB(205,205,205);CreditTitle.TextSize=14;CreditTitle.Font=Enum.Font.RobotoMono;CreditTitle.TextXAlignment=Enum.TextXAlignment.Center;CreditTitle.TextYAlignment=Enum.TextYAlignment.Center;CreditTitle.TextStrokeTransparency=.5
		local CreditLine=New("Frame",CreditSection,"Credits Line");CreditLine.AnchorPoint=Vector2.new(.5,0);CreditLine.Position=UDim2.new(.5,0,0,29);CreditLine.Size=UDim2.new(0,72,0,1);CreditLine.BackgroundColor3=Color3.fromRGB(70,70,70);CreditLine.BorderSizePixel=0
		local CreditBy=New("TextLabel",CreditSection,"Credits Text");CreditBy.Size=UDim2.new(1,-8,0,38);CreditBy.Position=UDim2.fromOffset(4,36);CreditBy.BackgroundTransparency=1;CreditBy.Text=CREDIT_TEXT;CreditBy.TextColor3=Color3.fromRGB(145,145,145);CreditBy.TextSize=11;CreditBy.Font=Enum.Font.RobotoMono;CreditBy.TextWrapped=true;CreditBy.TextXAlignment=Enum.TextXAlignment.Center;CreditBy.TextYAlignment=Enum.TextYAlignment.Top;CreditBy.TextStrokeTransparency=.5
	end)()
	C(UIS.InputBegan,function(I,GPE)
		if ST.Killed then return end
		if ST.UIHotkey.Recording then
			local K=FN.InputKey(I)
			if K then FN.StopUIHotkeyRecording(K);UX.ShowNotification("UI hotkey: "..KeyName(K),true,2.5) end
			return
		end
		if ST.AimRecording then
			local K=FN.InputKey(I)
			if K then
				FN.StopAimRecording(K)
				UX.ShowNotification("Aimlock hotkey: "..KeyName(K),true,2.5)
			end
			return
		end
		if not GPE and not ST.SelfMurder and ST.MurderLock and FN.IsAimKey(I) then
			if not FN.GetLiveMurderer() then ST.AimHeld=false;ST.AimTarget=nil;return end
			local T=FN.GetMurderTarget()
			if T then
				ST.AimTarget=T
				ST.AimHeld=true
				UX.ShowNotification("Locked: "..T.Name,true,1.5)
			else
				ST.AimHeld=false
				ST.AimTarget=nil
				UX.ShowNotification("Murderer not in view",false,1.5)
			end
			return
		end
		if not GPE and FN.IsUIKey(I) then UX.SetMenu(not UX.MainOpen) return end
	end)
	C(UIS.InputEnded,function(I)
		if not ST.AimRecording and FN.IsAimKey(I) and not ST.AutoLock then
			ST.AimHeld=false
			ST.AimTarget=nil
		end
	end)
	UX.SetMenu(true)
	local function BindLocalCharacter(CH)
		C(CH.ChildAdded,function() task.defer(FN.UpdateSelfMurder) task.defer(FN.UpdateToolVisuals) end)
		C(CH.ChildRemoved,function() task.defer(FN.UpdateSelfMurder) task.defer(FN.UpdateToolVisuals) end)
		task.defer(FN.UpdateSelfMurder)
	end
	C(LP.CharacterAdded,function(CH)
		if AW.AutoWinCharacterAdded then AW.AutoWinCharacterAdded(CH) end
		task.wait(.1)
		BindLocalCharacter(CH)
		FN.UpdateSelfMurder()
		FN.UpdateToolVisuals()
	end)
	if LP.Character then BindLocalCharacter(LP.Character) end
	C(LP.Backpack.ChildAdded,function() task.defer(FN.UpdateSelfMurder) task.defer(FN.UpdateToolVisuals) end)
	C(LP.Backpack.ChildRemoved,function() task.defer(FN.UpdateSelfMurder) task.defer(FN.UpdateToolVisuals) end)
	FN.UpdateSelfMurder()
	if SES.Settings.AutoWin and ST.SelfMurder and CTRL.AutoWinControl and not CTRL.AutoWinControl:GetState() then CTRL.AutoWinControl:SetState(true,true) end
	task.spawn(function()
		while not ST.Killed and task.wait(1) do
			FN.RefreshGuns()
			FN.SyncGunRoleState()
			for _,P in PS:GetPlayers() do
				if P ~= LP and not ST.DeadPlayers[P] then FN.DetectPlayer(P) end
			end
			FN.CheckHero()
			FN.UpdateSelfMurder()
			FN.UpdateToolVisuals()
		end
	end)
	task.wait(1)
end
;(function()
	local K="XYZCONTRIAL_C991"
	local URL="https://raw.githubusercontent.com/CelestialzX/Murder-Mystery-2/refs/heads/main/key.lua?token=GHSAT0AAAAAAEGY6W3WC6QVM2VWAFYRVLXU2UNOL3Q"
	local FULL,TOP=182,40
	local MINUS,EXPAND="rbxassetid://81253841082995","rbxassetid://115994741693562"
	local KEY_TOGGLE_ICON_SIZE=18 -- adjust toggle icon size
	local KEY_CLOSE_ICON_SIZE=22 -- adjust X icon size
	local Busy,Collapsed,ErrID=false,false,0
	local PG=LP:WaitForChild("PlayerGui")
	local Parent=PG
	if not Debug then
		UX.HUI=CG:FindFirstChild("HUI")
		if UX.HUI and not UX.HUI:IsA("Folder") then UX.HUI:Destroy();UX.HUI=nil end
		if not UX.HUI then UX.HUI=Instance.new("Folder");UX.HUI.Name="HUI";UX.HUI.Parent=CG end
		Parent=UX.HUI
	end
	ClearHubUI(PG)
	local KUI=New("ScreenGui",nil,"XYZ Hub Key System");KUI:SetAttribute("XYZ_HUB_KEY",true);KUI.ResetOnSpawn=false;KUI.IgnoreGuiInset=true;KUI.ZIndexBehavior=Enum.ZIndexBehavior.Sibling;KUI.DisplayOrder=999;KUI.Parent=Parent
	local H=New("Frame",KUI,"Key Main");H.AnchorPoint=Vector2.zero;H.Position=UDim2.new(.5,-140,.5,-FULL/2);H.Size=UDim2.fromOffset(280,0);H.BackgroundColor3=Color3.fromRGB(23,23,23);H.BorderSizePixel=0;H.ClipsDescendants=true
	New("UICorner",H).CornerRadius=UDim.new(0,4)
	local HD=New("Frame",H,"TopBar");HD.Size=UDim2.new(1,0,0,TOP);HD.BackgroundColor3=Color3.fromRGB(27,27,27);HD.BorderSizePixel=0;HD.Active=true;HD.ZIndex=10
	New("UICorner",HD).CornerRadius=UDim.new(0,7)
	local IC=New("ImageLabel",HD,"Hub Icon");IC.Size=UDim2.fromOffset(30,30);IC.Position=UDim2.fromOffset(6,5);IC.BackgroundTransparency=1;IC.Image="rbxassetid://105492433573203";IC.ScaleType=Enum.ScaleType.Fit;IC.ZIndex=11
	local TT=New("TextLabel",HD,"Title");TT.Size=UDim2.new(1,-104,1,0);TT.Position=UDim2.fromOffset(42,0);TT.BackgroundTransparency=1;TT.Text="XYZ Hub - Key System";TT.TextXAlignment=Enum.TextXAlignment.Left;TT.TextColor3=Color3.fromRGB(240,240,240);TT.TextSize=15;TT.TextStrokeTransparency=.5;TT.Font=Enum.Font.RobotoMono;TT.ZIndex=11
	local TG=New("ImageButton",HD,"Toggle");TG.Size=UDim2.fromOffset(22,22);TG.Position=UDim2.new(1,-52,0,9);TG.BackgroundColor3=Color3.fromRGB(55,55,55);TG.BorderSizePixel=0;TG.AutoButtonColor=false;TG.Image="";TG.ZIndex=12
	New("UICorner",TG).CornerRadius=UDim.new(0,4)
	local TGI=New("ImageLabel",TG,"Icon");TGI.AnchorPoint=Vector2.new(.5,.5);TGI.Position=UDim2.fromScale(.5,.5);TGI.Size=UDim2.fromOffset(KEY_TOGGLE_ICON_SIZE,KEY_TOGGLE_ICON_SIZE);TGI.BackgroundTransparency=1;TGI.Image=MINUS;TGI.ScaleType=Enum.ScaleType.Fit;TGI.ZIndex=13
	local CL=New("ImageButton",HD,"Close");CL.Size=UDim2.fromOffset(22,22);CL.Position=UDim2.new(1,-27,0,9);CL.BackgroundColor3=Color3.fromRGB(55,55,55);CL.BorderSizePixel=0;CL.AutoButtonColor=false;CL.Image="";CL.ZIndex=12
	New("UICorner",CL).CornerRadius=UDim.new(0,4)
	local CLI=New("ImageLabel",CL,"Icon");CLI.AnchorPoint=Vector2.new(.5,.5);CLI.Position=UDim2.fromScale(.5,.5);CLI.Size=UDim2.fromOffset(KEY_CLOSE_ICON_SIZE,KEY_CLOSE_ICON_SIZE);CLI.BackgroundTransparency=1;CLI.Image="rbxassetid://133353640393861";CLI.ScaleType=Enum.ScaleType.Fit;CLI.ZIndex=13
	local LN=New("Frame",HD,"Line");LN.AnchorPoint=Vector2.new(0,1);LN.Position=UDim2.new(0,0,1,0);LN.Size=UDim2.new(1,0,0,1);LN.BackgroundColor3=Color3.fromRGB(40,40,40);LN.BackgroundTransparency=1;LN.BorderSizePixel=0;LN.ZIndex=11
	local CT=New("Frame",H,"Content");CT.Position=UDim2.fromOffset(0,TOP);CT.Size=UDim2.new(1,0,0,FULL-TOP);CT.BackgroundTransparency=1;CT.BorderSizePixel=0;CT.ZIndex=2
	local BX=New("TextBox",CT,"Key Box");BX.Size=UDim2.new(1,-28,0,36);BX.Position=UDim2.fromOffset(14,17);BX.BackgroundColor3=Color3.fromRGB(31,31,31);BX.BorderSizePixel=0;BX.ClearTextOnFocus=false;BX.PlaceholderText="Enter Key";BX.PlaceholderColor3=Color3.fromRGB(135,135,135);BX.Text="";BX.TextColor3=Color3.fromRGB(230,230,230);BX.TextSize=13;BX.Font=Enum.Font.RobotoMono;BX.TextXAlignment=Enum.TextXAlignment.Center;BX.TextStrokeTransparency=.5;BX.MaxVisibleGraphemes=25;BX.ZIndex=3
	New("UICorner",BX).CornerRadius=UDim.new(0,6)
	local USE=New("TextButton",CT,"Enter Key");USE.Size=UDim2.new(.5,-19,0,34);USE.Position=UDim2.fromOffset(14,65);USE.BackgroundColor3=Color3.fromRGB(28,96,255);USE.BorderSizePixel=0;USE.AutoButtonColor=false;USE.Text="Use Key";USE.TextColor3=Color3.fromRGB(245,245,245);USE.TextSize=12;USE.Font=Enum.Font.RobotoMono;USE.TextStrokeTransparency=.5;USE.ZIndex=3
	New("UICorner",USE).CornerRadius=UDim.new(0,6)
	local GET=New("TextButton",CT,"Get Key");GET.Size=UDim2.new(.5,-19,0,34);GET.Position=UDim2.new(.5,5,0,65);GET.BackgroundColor3=Color3.fromRGB(38,38,38);GET.BorderSizePixel=0;GET.AutoButtonColor=false;GET.Text="Get Key";GET.TextColor3=Color3.fromRGB(220,220,220);GET.TextSize=12;GET.TextStrokeTransparency=.5;GET.Font=Enum.Font.RobotoMono;GET.ZIndex=3
	New("UICorner",GET).CornerRadius=UDim.new(0,6)
	local INFO=New("TextLabel",CT,"Info");INFO.Size=UDim2.new(1,-28,0,20);INFO.Position=UDim2.fromOffset(14,108);INFO.BackgroundTransparency=1;INFO.Text="Enter Key to load into the HUB";INFO.TextColor3=Color3.fromRGB(120,120,120);INFO.TextSize=11;INFO.Font=Enum.Font.RobotoMono;INFO.TextStrokeTransparency=.5;INFO.TextXAlignment=Enum.TextXAlignment.Center;INFO.ZIndex=3
	local function ToggleKey()
		if Busy then return end
		Collapsed=not Collapsed;TGI.Image=Collapsed and EXPAND or MINUS
		TS:Create(LN,Collapsed and UX.MainOut or UX.MainIn,{BackgroundTransparency=Collapsed and 1 or 0}):Play();TS:Create(H,Collapsed and UX.MainOut or UX.MainIn,{Size=UDim2.fromOffset(280,Collapsed and TOP or FULL)}):Play()
	end
	local function CopyKey()
		if Busy then return end
		local F=setclipboard or toclipboard
		local OK=typeof(F)=="function" and pcall(F,URL)
		GET.Text=OK and "Copied" or "Copy Failed";TS:Create(GET,COL.TI,{BackgroundColor3=OK and Color3.fromRGB(40,105,58) or Color3.fromRGB(95,38,38)}):Play();UX.ShowNotification(OK and "Copied Key Link" or "Copy Failed",OK,2.5,KUI)
		task.delay(1.5,function() if GET and GET.Parent and not Busy then GET.Text="Get Key";TS:Create(GET,COL.TI,{BackgroundColor3=Color3.fromRGB(38,38,38)}):Play() end end)
	end
	local function UseKey()
		if Busy or ST.Killed then return end
		if BX.Text:match("^%s*(.-)%s*$")==K then
			Busy=true;ErrID+=1;BX:ReleaseFocus();USE.Text="Accepted";TS:Create(USE,COL.TI,{BackgroundColor3=Color3.fromRGB(40,105,58)}):Play();TS:Create(LN,UX.MainOut,{BackgroundTransparency=1}):Play()
			local O=TS:Create(H,UX.MainOut,{Size=UDim2.fromOffset(280,0)});O:Play();O.Completed:Once(function() if KUI and KUI.Parent then KUI:Destroy() end if not ST.Killed then StartMain() end end)
			return
		end
		ErrID+=1;local ID=ErrID;BX.Text="";BX.PlaceholderText="Incorrect Key!";TS:Create(BX,COL.TI,{PlaceholderColor3=Color3.fromRGB(255,73,73)}):Play();UX.ShowNotification("Incorrect",false,2.5,KUI)
		task.delay(3,function() if ID~=ErrID or not BX or not BX.Parent then return end BX.PlaceholderText="Enter Key";TS:Create(BX,COL.TI,{PlaceholderColor3=Color3.fromRGB(135,135,135)}):Play() end)
	end
	C(BX:GetPropertyChangedSignal("Text"),function() local T=BX.Text;local N=utf8.len(T);if N and N>25 then local P=utf8.offset(T,26);if P then BX.Text=T:sub(1,P-1);BX.CursorPosition=#BX.Text+1 end end end)
	C(TG.MouseButton1Click,ToggleKey)
	C(CL.MouseButton1Click,function() if KUI and KUI.Parent then KUI:Destroy() end UX.KillScript() end)
	C(USE.MouseButton1Click,UseKey)
	C(GET.MouseButton1Click,CopyKey)
	C(BX.FocusLost,function(Enter) if Enter then UseKey() end end)
	C(TG.MouseEnter,function() TS:Create(TG,TweenInfo.new(.12),{BackgroundColor3=Color3.fromRGB(72,72,72)}):Play() end);C(TG.MouseLeave,function() TS:Create(TG,TweenInfo.new(.12),{BackgroundColor3=Color3.fromRGB(55,55,55)}):Play() end)
	C(CL.MouseEnter,function() TS:Create(CL,TweenInfo.new(.12),{BackgroundColor3=Color3.fromRGB(92,45,45)}):Play() end);C(CL.MouseLeave,function() TS:Create(CL,TweenInfo.new(.12),{BackgroundColor3=Color3.fromRGB(55,55,55)}):Play() end)
	C(USE.MouseEnter,function() if not Busy then TS:Create(USE,TweenInfo.new(.12),{BackgroundColor3=Color3.fromRGB(38,112,255)}):Play() end end);C(USE.MouseLeave,function() if not Busy then TS:Create(USE,TweenInfo.new(.12),{BackgroundColor3=Color3.fromRGB(28,96,255)}):Play() end end)
	C(GET.MouseEnter,function() if not Busy and GET.Text=="Get Key" then TS:Create(GET,TweenInfo.new(.12),{BackgroundColor3=Color3.fromRGB(48,48,48)}):Play() end end);C(GET.MouseLeave,function() if not Busy and GET.Text=="Get Key" then TS:Create(GET,TweenInfo.new(.12),{BackgroundColor3=Color3.fromRGB(38,38,38)}):Play() end end)
	local Drag,DS,SP,DI=false
	C(HD.InputBegan,function(I) if I.UserInputType==Enum.UserInputType.MouseButton1 then Drag=true;DS=I.Position;SP=H.Position;C(I.Changed,function() if I.UserInputState==Enum.UserInputState.End then Drag=false end end) end end)
	C(HD.InputChanged,function(I) if I.UserInputType==Enum.UserInputType.MouseMovement then DI=I end end)
	C(UIS.InputChanged,function(I) if Drag and I==DI then local D=I.Position-DS;H.Position=UDim2.new(SP.X.Scale,SP.X.Offset+D.X,SP.Y.Scale,SP.Y.Offset+D.Y) end end)
	TS:Create(H,UX.MainIn,{Size=UDim2.fromOffset(280,FULL)}):Play();TS:Create(LN,UX.MainIn,{BackgroundTransparency=0}):Play()
end)()
end)()
