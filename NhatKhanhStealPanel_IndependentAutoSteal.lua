local ENV=(getgenv and getgenv())or _G local Players=game:GetService("Players")local ReplicatedStorage=game:GetService("ReplicatedStorage")local LocalPlayer=Players.LocalPlayer local PlayerGui=LocalPlayer:WaitForChild("PlayerGui")if type(ENV.__NK_STEAL_PANEL_STOP)== "function"then pcall(ENV.__NK_STEAL_PANEL_STOP)end local previous=PlayerGui:FindFirstChild("NhatKhanhStealPanel")if previous then previous:Destroy()end local alive=true local connections={}local function connect(signal,callback)local c=signal:Connect(callback)table.insert(connections,c)return c end local function make(className,properties,parent)local obj=Instance.new(className)for key,value in pairs(properties or{})do obj[key]=value end obj.Parent=parent return obj end local IMAGE_URL= "https://raw.githubusercontent.com/khanhdep41-tech/Nhat-Khanh-SAE/refs/heads/main/IMG_9880.jpeg"local IMAGE_FOLDER= "NhatKhanhHub"local IMAGE_PATH=IMAGE_FOLDER .. "/IMG_9880.jpeg"local function getLocalImageAsset()if type(writefile)~= "function"then return nil end local assetFn=getcustomasset or getsynasset if type(assetFn)~= "function"then return nil end pcall(function()if type(makefolder)== "function"and type(isfolder)== "function"and not isfolder(IMAGE_FOLDER)then makefolder(IMAGE_FOLDER)elseif type(makefolder)== "function"then makefolder(IMAGE_FOLDER)end end)local data if type(isfile)== "function"and isfile(IMAGE_PATH)and type(readfile)== "function"then local ok,value=pcall(readfile,IMAGE_PATH)if ok and type(value)== "string"and#value>0 then data=value end end if not data then local ok,value=pcall(function()return game:HttpGet(IMAGE_URL)end)if ok and type(value)== "string"and#value>0 then data=value pcall(writefile,IMAGE_PATH,data)end end if not data then return nil end local ok,asset=pcall(assetFn,IMAGE_PATH)if ok and type(asset)== "string"then return asset end return nil end local COLORS={background=Color3.fromRGB(10,14,27),row=Color3.fromRGB(22,30,48),blue=Color3.fromRGB(0,210,255),red=Color3.fromRGB(113,66,255),green=Color3.fromRGB(0,220,145),white=Color3.fromRGB(246,248,255),muted=Color3.fromRGB(150,164,185),queued=Color3.fromRGB(35,125,82),}local imageAsset=getLocalImageAsset()local gui=make("ScreenGui",{Name= "NhatKhanhStealPanel",ResetOnSpawn=false,IgnoreGuiInset=true,DisplayOrder=999,ZIndexBehavior=Enum.ZIndexBehavior.Sibling,},PlayerGui)local panel=make("Frame",{Name= "Panel",AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-5,0.5,0),Size=UDim2.new(0,310,0.90,0),BackgroundColor3=COLORS.background,BorderSizePixel=0,Visible=false,ZIndex=5,},gui)make("UICorner",{CornerRadius=UDim.new(0,12)},panel)make("UIStroke",{Color=COLORS.blue,Thickness=1.8,Transparency=0.08},panel)if imageAsset then make("ImageLabel",{Name= "BackgroundImage",Size=UDim2.fromScale(1,1),Position=UDim2.fromScale(0,0),BackgroundTransparency=1,Image=imageAsset,ImageTransparency=0,ScaleType=Enum.ScaleType.Crop,ZIndex=5,},panel)make("Frame",{Name= "ImageShade",Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.fromRGB(16,10,24),BackgroundTransparency=0.32,BorderSizePixel=0,ZIndex=5,},panel)else make("UIGradient",{Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(18,24,44)),ColorSequenceKeypoint.new(1,Color3.fromRGB(7,10,20))}),Rotation=35},panel)end make("UISizeConstraint",{MinSize=Vector2.new(240,280),MaxSize=Vector2.new(360,900),},panel)local icon=make("ImageButton",{Name= "ThiefIcon",AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-8,0.20,0),Size=UDim2.fromOffset(48,48),BackgroundColor3=Color3.fromRGB(20,13,29),BackgroundTransparency=imageAsset and 1 or 0,BorderSizePixel=0,Image=imageAsset or "",ImageTransparency=imageAsset and 0 or 1,ScaleType=Enum.ScaleType.Crop,AutoButtonColor=false,ZIndex=20,},gui)make("UICorner",{CornerRadius=UDim.new(1,0)},icon)if not imageAsset then icon.ImageTransparency=1 icon.BackgroundTransparency=0 icon.BackgroundColor3=COLORS.background icon:FindFirstChildOfClass("UICorner").CornerRadius=UDim.new(1,0)make("TextLabel",{Name= "IconFallback",Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text= "🥷",TextColor3=COLORS.white,TextSize=24,Font=Enum.Font.GothamBold,ZIndex=21,},icon)end make("UIStroke",{Color=COLORS.blue,Thickness=2,Transparency=0.05},icon)connect(icon.Activated,function()panel.Visible=not panel.Visible end)local header=make("Frame",{Name= "Header",Size=UDim2.new(1,0,0,44),BackgroundColor3=COLORS.red,BorderSizePixel=0,ZIndex=6,},panel)make("UICorner",{CornerRadius=UDim.new(0,12)},header)make("UIGradient",{Color=ColorSequence.new(Color3.fromRGB(0,190,255),Color3.fromRGB(106,54,255)),Rotation=0},header)make("TextLabel",{Position=UDim2.fromOffset(10,0),Size=UDim2.new(1,-104,1,0),BackgroundTransparency=1,Text= "Steal Panel By Nhat Khanh",TextColor3=COLORS.white,TextSize=12,Font=Enum.Font.Fantasy,TextXAlignment=Enum.TextXAlignment.Left,TextScaled=false,TextStrokeColor3=Color3.fromRGB(0,190,255),TextStrokeTransparency=0.65,ZIndex=7,},header)local toggleArrow=make("TextButton",{Name= "ToggleArrow",AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(0,0,0.5,0),Size=UDim2.fromOffset(25,40),BackgroundColor3=COLORS.red,BorderSizePixel=0,Text= "▶",TextColor3=COLORS.white,TextSize=16,Font=Enum.Font.GothamBold,ZIndex=12,},panel)make("UICorner",{CornerRadius=UDim.new(0,5)},toggleArrow)make("UIStroke",{Color=COLORS.blue,Thickness=1},toggleArrow)connect(toggleArrow.Activated,function()panel.Visible=false end)local sortMode= "rarity"local sortButton=make("TextButton",{AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,-8,0,9),Size=UDim2.fromOffset(82,25),BackgroundColor3=COLORS.green,BorderSizePixel=0,Text= "Sort Rarity",TextColor3=COLORS.white,TextSize=9,Font=Enum.Font.GothamBold,ZIndex=6,},panel)make("UICorner",{CornerRadius=UDim.new(0,5)},sortButton)local status=make("TextLabel",{Position=UDim2.fromOffset(11,51),Size=UDim2.new(1,-22,0,20),BackgroundTransparency=1,Text= "Independent egg engine ready",TextColor3=COLORS.muted,TextSize=10,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,ZIndex=6,},panel)
-- Standalone protection toggles: Anti Ragdoll + Anti Trap
local antiRagEnabled=false
local antiTrapEnabled=false
local ragConnections={}
local trapConnection=nil
local savedTrapParts={}
local function disconnectRag()
    for _,c in ipairs(ragConnections) do pcall(function() c:Disconnect() end) end
    table.clear(ragConnections)
end
local function restoreTraps()
    if trapConnection then pcall(function() trapConnection:Disconnect() end) trapConnection=nil end
    for part,wasTouch in pairs(savedTrapParts) do
        if part and part.Parent then pcall(function() part.CanTouch=wasTouch end) end
    end
    table.clear(savedTrapParts)
end
local function protectTrap(trap)
    if not trap or trap:GetAttribute("Owner")==LocalPlayer.Name then return end
    for _,obj in ipairs({trap,table.unpack(trap:GetDescendants())}) do
        if obj:IsA("BasePart") and savedTrapParts[obj]==nil then
            savedTrapParts[obj]=obj.CanTouch
            obj.CanTouch=false
        end
    end
end
local function antiRagdollBurst()
    if not antiRagEnabled then return end
    task.spawn(function()
        for _=1,15 do
            if not alive or not antiRagEnabled then break end
            pcall(function()
                local character=LocalPlayer.Character
                local humanoid=character and character:FindFirstChildOfClass("Humanoid")
                if not character or not humanoid then return end
                local root=character:FindFirstChild("HumanoidRootPart")
                local velocity=root and root.AssemblyLinearVelocity
                local ragdollModule
                local shared=ReplicatedStorage:FindFirstChild("Shared")
                local modules=shared and shared:FindFirstChild("Modules")
                local module=modules and modules:FindFirstChild("Ragdoll")
                if module then
                    local ok,result=pcall(require,module)
                    if ok then ragdollModule=result end
                end
                if ragdollModule then
                    pcall(ragdollModule.ClearClientRagdoll)
                    pcall(ragdollModule.Unragdoll,character)
                end
                if root and velocity then
                    root.AssemblyLinearVelocity=Vector3.new(velocity.X,math.min(velocity.Y,0),velocity.Z)
                end
                for _,d in ipairs(character:GetDescendants()) do
                    if d:IsA("BallSocketConstraint") or d:IsA("NoCollisionConstraint") or d:IsA("HingeConstraint") then
                        d:Destroy()
                    elseif (d:IsA("Motor6D") or d:IsA("AnimationConstraint")) and not d.Enabled then
                        d.Enabled=true
                    end
                end
                local state=humanoid:GetState()
                if state==Enum.HumanoidStateType.Physics or state==Enum.HumanoidStateType.Ragdoll or state==Enum.HumanoidStateType.FallingDown then
                    humanoid:ChangeState(Enum.HumanoidStateType.Running)
                end
                humanoid.PlatformStand=false
                if workspace.CurrentCamera then workspace.CurrentCamera.CameraSubject=humanoid end
            end)
            task.wait(0.033)
        end
    end)
end
local function setAntiRagdoll(enabled)
    antiRagEnabled=enabled
    disconnectRag()
    if enabled then
        table.insert(ragConnections,LocalPlayer:GetAttributeChangedSignal("RagdollEndTime"):Connect(antiRagdollBurst))
        local remote
        local shared=ReplicatedStorage:FindFirstChild("Shared")
        local modules=shared and shared:FindFirstChild("Modules")
        local module=modules and modules:FindFirstChild("Ragdoll")
        if module then
            local ok,result=pcall(require,module)
            if ok and result then remote=result.ClientRagdollRemote end
        end
        if remote and remote.OnClientEvent then
            table.insert(ragConnections,remote.OnClientEvent:Connect(antiRagdollBurst))
        end
    end
end
local function setAntiTrap(enabled)
    antiTrapEnabled=enabled
    restoreTraps()
    if not enabled then return end
    local CollectionService=game:GetService("CollectionService")
    for _,trap in ipairs(CollectionService:GetTagged("PlacedTrap")) do pcall(protectTrap,trap) end
    trapConnection=CollectionService:GetInstanceAddedSignal("PlacedTrap"):Connect(function(trap)
        task.defer(function() if antiTrapEnabled then pcall(protectTrap,trap) end end)
    end)
end
local function protectionButton(text,x,callback)
    local b=make("TextButton",{Position=UDim2.fromOffset(x,75),Size=UDim2.new(0.5,-12,0,25),BackgroundColor3=Color3.fromRGB(35,48,70),BorderSizePixel=0,Text=text..": OFF",TextColor3=COLORS.white,TextSize=9,Font=Enum.Font.GothamBold,ZIndex=7,},panel)
    make("UICorner",{CornerRadius=UDim.new(0,5)},b)
    make("UIStroke",{Color=COLORS.blue,Thickness=1,Transparency=0.3},b)
    connect(b.Activated,function()
        local on=b.Text:find("OFF",1,true)~=nil
        callback(on)
        b.Text=text..(on and ": ON" or ": OFF")
        b.BackgroundColor3=on and COLORS.queued or Color3.fromRGB(35,48,70)
    end)
    return b
end
protectionButton("Anti Ragdoll",8,setAntiRagdoll)
protectionButton("Anti Trap",158,setAntiTrap)
local list=make("ScrollingFrame",{Name= "TargetList",Position=UDim2.fromOffset(8,139),Size=UDim2.new(1,-16,1,-147),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=3,ScrollBarImageColor3=COLORS.blue,CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,ScrollingEnabled=true,ZIndex=6,},panel)make("UIListLayout",{Padding=UDim.new(0,5),SortOrder=Enum.SortOrder.LayoutOrder,},list)connect(sortButton.Activated,function()sortMode=sortMode== "rarity"and "money"or "rarity"sortButton.Text=sortMode== "rarity"and "Sort Rarity"or "Sort Value"end)local EggState,Assets,AssetEarnings local function loadModules()pcall(function()EggState=require(ReplicatedStorage:WaitForChild("Client"):WaitForChild("EggState"))end)pcall(function()Assets=require(ReplicatedStorage:WaitForChild("Data"):WaitForChild("Assets"))end)pcall(function()AssetEarnings=require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Util"):WaitForChild("AssetEarnings"))end)end loadModules()local rarityFallback={Common=1,Uncommon=2,Rare=3,Epic=4,Legendary=5,Mythic=6,Divine=7,Secret=8,Cosmic=9,Transcendent=10,}local rarityColors={Common=Color3.fromRGB(205,210,220),Uncommon=Color3.fromRGB(105,220,125),Rare=Color3.fromRGB(75,165,255),Epic=Color3.fromRGB(190,105,255),Legendary=Color3.fromRGB(255,190,65),Mythic=Color3.fromRGB(255,85,115),Divine=Color3.fromRGB(255,225,100),Secret=Color3.fromRGB(245,80,245),Cosmic=Color3.fromRGB(80,225,255),Transcendent=Color3.fromRGB(255,120,210),}local function getRarityColor(rarityName)local key=tostring(rarityName or ""):lower()for rarity,color in pairs(rarityColors)do if key==rarity:lower()or key:find(rarity:lower(),1,true)then return color end end return COLORS.white end local function getImage(config)if type(config)~= "table"then return nil end local holders={config}if type(config.Egg)== "table"then table.insert(holders,config.Egg)end if type(config.Pet)== "table"then table.insert(holders,config.Pet)end local imageKeys={ "Image","Icon","Thumbnail","ImageId","IconId","Texture","DisplayImage",}for _,holder in ipairs(holders)do for _,key in ipairs(imageKeys)do local value=holder[key]if type(value)== "number"and value>0 then return "rbxassetid://".. tostring(value)elseif type(value)== "string"and value~= ""then if value:match("^%d+$")then return "rbxassetid://".. value elseif value:find("rbxassetid://",1,true)or value:find("rbxthumb://",1,true)then return value end end end end return nil end local function getRate(record)if not AssetEarnings or type(AssetEarnings.LiveRatePerSecond)~= "function"then return 0 end local category=record.AssetCategory or record.Category local item={AssetCategory=category,Category=category,AssetScale=record.AssetScale or record.Scale or 1,Scale=record.AssetScale or record.Scale or 1,Mutations=record.Mutations or{},}local ok,value=pcall(AssetEarnings.LiveRatePerSecond,item)return ok and(tonumber(value)or 0)or 0 end local function moneyText(value)local n=tonumber(value)or 0 local a=math.abs(n)if a>=1e12 then return string.format("$%.2fT/s",n/1e12)end if a>=1e9 then return string.format("$%.2fB/s",n/1e9)end if a>=1e6 then return string.format("$%.2fM/s",n/1e6)end if a>=1e3 then return string.format("$%.2fK/s",n/1e3)end return string.format("$%.0f/s",n)end local function scanWorld()if not EggState or not Assets or type(Assets.Directory)~= "table"then loadModules()end if not EggState or not Assets or type(Assets.Directory)~= "table"then return nil,"EggState/Assets module not available"end local snapshot local ok=pcall(function()if type(EggState.GetAreaEggSnapshot)== "function"then snapshot=EggState.GetAreaEggSnapshot()end if(not snapshot or type(snapshot.Records)~= "table")and type(EggState.ReadFieldEggs)== "function"then snapshot=EggState.ReadFieldEggs()end end)if not ok or type(snapshot)~= "table"or type(snapshot.Records)~= "table"then return nil,"Could not read spawned map targets"end local rows,seen={},{}for _,record in ipairs(snapshot.Records)do if type(record)== "table"and record.Uid~=nil and record.BottomCFrame and record.State~= "Claimed"and record.State~= "Carried"and not record.CarrierUserId and not tostring(record.Uid):find("FirstAreaEgg")then local category=record.AssetCategory local config=category and Assets.Directory[category]if config then local rarityName,rank= "?",0 if type(config.Rarity)== "table"then rarityName=tostring(config.Rarity.DisplayName or config.Rarity._id or "?")rank=tonumber(config.Rarity.Rank)or rarityFallback[rarityName]or 0 elseif type(config.Rarity)== "string"then rarityName=config.Rarity rank=rarityFallback[rarityName]or 0 end local uidKey=tostring(record.Uid)if not seen[uidKey]then seen[uidKey]=true rows[#rows+1]={uid=record.Uid,name=tostring(config.DisplayName or category or "Unknown"),rarity=rarityName,rank=rank,rate=getRate(record),image=getImage(config),}end end end end table.sort(rows,function(a,b)if sortMode== "rarity"then if a.rank~=b.rank then return a.rank>b.rank end if a.rate~=b.rate then return a.rate>b.rate end else if a.rate~=b.rate then return a.rate>b.rate end if a.rank~=b.rank then return a.rank>b.rank end end return a.name<b.name end)return rows end local stealBusy=false
local autoStealEnabled=false
local instantPickupEnabled=true
local moveToEggMode="Teleport"
local deliveryMode="Walk"
local function getEggModule()
    local client=ReplicatedStorage:FindFirstChild("Client")
    local module=client and client:FindFirstChild("EggState")
    if not module then return nil,"Client.EggState not found" end
    local ok,result=pcall(require,module)
    if not ok or type(result)~="table" then return nil,"Could not load EggState" end
    return result
end
local function readRecords()
    local egg,err=getEggModule()
    if not egg then return nil,err end
    local ok,snapshot=pcall(function()
        if type(egg.GetAreaEggSnapshot)=="function" then
            local value=egg.GetAreaEggSnapshot()
            if type(value)=="table" and type(value.Records)=="table" then return value end
        end
        return egg.ReadFieldEggs()
    end)
    if not ok or type(snapshot)~="table" or type(snapshot.Records)~="table" then
        return nil,"Could not read field egg records"
    end
    return snapshot.Records
end
local function findEggRecord(uid)
    local records=readRecords()
    if not records then return nil end
    for _,record in pairs(records) do
        if type(record)=="table" and tostring(record.Uid)==tostring(uid) then return record end
    end
end
local function getEggModel(uid)
    local model=workspace:FindFirstChild(tostring(uid))
    if model and model:IsA("Model") then return model end
    return nil
end
local function setCharacterAtEgg(record)
    local character=LocalPlayer.Character
    local root=character and character:FindFirstChild("HumanoidRootPart")
    if not root then return false,"Character/root not ready" end
    local target
    if typeof(record.BottomCFrame)=="CFrame" then
        target=record.BottomCFrame
    else
        local model=getEggModel(record.Uid)
        if model then target=model:GetPivot() end
    end
    if not target then return false,"Egg position unavailable" end
    if moveToEggMode=="Teleport" then
        root.CFrame=target+Vector3.new(0,3,0)
        root.AssemblyLinearVelocity=Vector3.zero
    else
        local humanoid=character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid:MoveTo(target.Position) end
        local deadline=os.clock()+8
        repeat task.wait(0.1) until not alive or not root.Parent or (root.Position-target.Position).Magnitude<7 or os.clock()>deadline
        if not root.Parent or (root.Position-target.Position).Magnitude>=10 then return false,"Could not reach egg" end
    end
    return true
end
local function isCarriedByLocal(uid)
    local record=findEggRecord(uid)
    return record and record.State=="Carried" and tonumber(record.CarrierUserId)==LocalPlayer.UserId,record
end
local function requestCarry(uid,slot)
    local egg,err=getEggModule()
    if not egg then return false,err end
    if type(egg.CarryFieldEgg)~="function" then return false,"CarryFieldEgg API unavailable" end
    local ok,result,message=pcall(function()
        if slot~=nil then return egg.CarryFieldEgg(uid,slot) end
        return egg.CarryFieldEgg(uid)
    end)
    if not ok then return false,tostring(result) end
    if result==false then return false,tostring(message or "Server rejected pickup") end
    return true,tostring(message or "Pickup request sent")
end
local function queueSteal(uid)
    if stealBusy then return false,"Another egg pickup is already running" end
    stealBusy=true
    task.spawn(function()
        local ok,err=xpcall(function()
            local record=findEggRecord(uid)
            if not record then status.Text="Egg no longer exists" return end
            if record.State=="Carried" then status.Text="Egg is already carried" return end
            if record.State=="Claimed" or record.State=="Slot" then status.Text="Egg is no longer available" return end
            local moved,moveErr=setCharacterAtEgg(record)
            if not moved then status.Text=moveErr return end
            local attempts=instantPickupEnabled and 5 or 2
            for attempt=1,attempts do
                if not alive then break end
                local hasEgg=findEggRecord(uid)
                if hasEgg and hasEgg.State=="Carried" and tonumber(hasEgg.CarrierUserId)==LocalPlayer.UserId then
                    status.Text="Carrying egg: "..tostring(uid).." | delivery route needs base locator"
                    return
                end
                local success,message=requestCarry(uid,record.Slot or record.slot)
                if not success and attempt==attempts then status.Text="Pickup failed: "..tostring(message) end
                task.wait(instantPickupEnabled and 0.12 or 0.35)
            end
            local carried,latest=isCarriedByLocal(uid)
            if carried then
                status.Text="Egg picked up: "..tostring(uid).." | ready for delivery"
            elseif latest then
                status.Text="Pickup not confirmed (state: "..tostring(latest.State)..")"
            end
        end,function(e) return tostring(e) end)
        if not ok then status.Text="STEAL error: "..tostring(err) end
        stealBusy=false
    end)
    return true,"Starting independent pickup..."
end
local function autoStealStep()
    if not autoStealEnabled or stealBusy then return end
    local rows=scanWorld()
    if rows and rows[1] then queueSteal(rows[1].uid) end
end
local autoButton=make("TextButton",{Position=UDim2.fromOffset(8,106),Size=UDim2.new(0.5,-12,0,25),BackgroundColor3=Color3.fromRGB(35,48,70),BorderSizePixel=0,Text="Auto Steal: OFF",TextColor3=COLORS.white,TextSize=9,Font=Enum.Font.GothamBold,ZIndex=7},panel)
make("UICorner",{CornerRadius=UDim.new(0,5)},autoButton)
make("UIStroke",{Color=COLORS.blue,Thickness=1,Transparency=0.3},autoButton)
connect(autoButton.Activated,function()
    autoStealEnabled=not autoStealEnabled
    autoButton.Text=autoStealEnabled and "Auto Steal: ON" or "Auto Steal: OFF"
    autoButton.BackgroundColor3=autoStealEnabled and COLORS.queued or Color3.fromRGB(35,48,70)
    status.Text=autoStealEnabled and "Independent Auto Steal enabled" or "Auto Steal disabled"
end)
local instantButton=make("TextButton",{Position=UDim2.new(0.5,4,0,106),Size=UDim2.new(0.5,-12,0,25),BackgroundColor3=COLORS.queued,BorderSizePixel=0,Text="Instant Pickup: ON",TextColor3=COLORS.white,TextSize=9,Font=Enum.Font.GothamBold,ZIndex=7},panel)
make("UICorner",{CornerRadius=UDim.new(0,5)},instantButton)
make("UIStroke",{Color=COLORS.blue,Thickness=1,Transparency=0.3},instantButton)
connect(instantButton.Activated,function()
    instantPickupEnabled=not instantPickupEnabled
    instantButton.Text=instantPickupEnabled and "Instant Pickup: ON" or "Instant Pickup: OFF"
    instantButton.BackgroundColor3=instantPickupEnabled and COLORS.queued or Color3.fromRGB(35,48,70)
end)
task.spawn(function()
    while alive and gui.Parent do
        if autoStealEnabled then autoStealStep() end
        task.wait(0.6)
    end
end) local function clearRows()for _,child in ipairs(list:GetChildren())do if child:IsA("Frame")then child:Destroy()end end end local function addRow(data,order)local row=make("Frame",{Size=UDim2.new(1,-2,0,67),BackgroundColor3=COLORS.row,BorderSizePixel=0,LayoutOrder=order,ZIndex=7,},list)make("UICorner",{CornerRadius=UDim.new(0,8)},row)make("UIStroke",{Color=Color3.fromRGB(53,83,125),Thickness=1,Transparency=0.35},row)make("UIGradient",{Color=ColorSequence.new(Color3.fromRGB(30,42,66),Color3.fromRGB(17,23,38)),Rotation=0},row)local thumbnail=make("ImageLabel",{Position=UDim2.fromOffset(5,5),Size=UDim2.fromOffset(56,57),BackgroundColor3=COLORS.background,BorderSizePixel=0,Image=data.image or "",ScaleType=Enum.ScaleType.Fit,ZIndex=8,},row)make("UICorner",{CornerRadius=UDim.new(0,4)},thumbnail)make("UIStroke",{Color=COLORS.blue,Thickness=1},thumbnail)if not data.image then make("TextLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text= "🥚",TextSize=23,ZIndex=9,},thumbnail)end make("TextLabel",{Position=UDim2.fromOffset(67,7),Size=UDim2.new(1,-142,0,19),BackgroundTransparency=1,Text=data.name,TextColor3=getRarityColor(data.rarity),TextSize=10,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,ZIndex=8,},row)make("TextLabel",{Position=UDim2.fromOffset(67,27),Size=UDim2.new(1,-142,0,16),BackgroundTransparency=1,Text=data.rarity,TextColor3=getRarityColor(data.rarity),TextSize=9,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,ZIndex=8,},row)make("TextLabel",{Position=UDim2.fromOffset(67,43),Size=UDim2.new(1,-142,0,17),BackgroundTransparency=1,Text=moneyText(data.rate),TextColor3=Color3.fromRGB(65,255,105),TextSize=10,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,ZIndex=8,},row)local steal=make("TextButton",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-5,0.5,0),Size=UDim2.fromOffset(58,27),BackgroundColor3=COLORS.green,BorderSizePixel=0,Text= "STEAL",TextColor3=COLORS.white,TextSize=9,Font=Enum.Font.GothamBold,ZIndex=8,},row)make("UICorner",{CornerRadius=UDim.new(0,7)},steal)make("UIGradient",{Color=ColorSequence.new(Color3.fromRGB(0,235,155),Color3.fromRGB(0,155,110)),Rotation=90},steal)connect(steal.Activated,function()local success,message=queueSteal(data.uid)status.Text=message if success then steal.Text= "QUEUED"steal.BackgroundColor3=COLORS.queued end end)end local function render()local rows,err=scanWorld()if not rows then status.Text=err return end clearRows()for index,data in ipairs(rows)do addRow(data,index)end status.Text=("Targets on map: %d"):format(#rows)end task.spawn(function()while alive and gui.Parent do local ok,err=pcall(render)if not ok then status.Text= "Scan error: ".. tostring(err)end task.wait(2)end end)ENV.__NK_STEAL_PANEL_STOP=function()alive=false setAntiRagdoll(false) setAntiTrap(false) for _,c in ipairs(connections)do pcall(function()c:Disconnect()end)end if gui and gui.Parent then gui:Destroy()end ENV.__NK_STEAL_PANEL_STOP=nil end

-- AUTO RE-EXECUTE AFTER TELEPORT
local REEXEC_URL="https://raw.githubusercontent.com/khanhdep41-tech/Nam-Khanh/refs/heads/main/hi.lua"
local queueTeleport=queue_on_teleport or queueonteleport or (syn and syn.queue_on_teleport)
if type(queueTeleport)=="function" then
    local teleportCode='task.wait(2); local u="'..REEXEC_URL..'"; local ok,src=pcall(function() return game:HttpGet(u) end); if ok and type(src)=="string" and #src>0 then local fn,err=loadstring(src); if fn then fn() else warn("[Steal Panel] Load error:",err) end else warn("[Steal Panel] Download failed") end'
    local ok,err=pcall(function() queueTeleport(teleportCode) end)
    if ok then
        print("[Steal Panel] Auto re-execute registered")
    else
        warn("[Steal Panel] Queue failed:",err)
    end
else
    warn("[Steal Panel] Executor does not support queue_on_teleport")
end

print("[NhatKhanh Steal Panel] Loaded. Auto re-execute configured.")
