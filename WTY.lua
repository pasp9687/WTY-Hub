local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "WTY Hub",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "로딩중...",
   LoadingSubtitle = "제작 : 승호",
   Theme = "DarkBlue", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Big Hub"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

local MainTab = Window:CreateTab("실력", nil) -- Title, Image
local MainSection = MainTab:CreateSection("ESP")

Rayfield:Notify({
   Title = "스크립트 정상 실행 완료!",
   Content = "Thank you for using our script.",
   Duration = 5,
   Image = nil,
 })

local Button = MainTab:CreateButton({
   Name = "플레이어(몸,윤곽선) ESP",
   Callback = function()
local Players = game:GetService("Players")

-- 캐릭터에 윤곽선 강조 추가
local function updateHighlight(character, team)
    -- 기존 강조 삭제
    local existingHighlight = character:FindFirstChild("TeamHighlight")
    if existingHighlight then
        existingHighlight:Destroy()
    end

    if team then
        local teamColor = team.TeamColor.Color
        local highlight = Instance.new("Highlight")
        highlight.Name = "TeamHighlight"
        highlight.Parent = character
        highlight.FillTransparency = 0.6
        highlight.OutlineTransparency = 0.2
        highlight.FillColor = teamColor  -- 팀 색상
        highlight.OutlineColor = Color3.fromRGB(255, 255, 0)  -- 윤곽선 노란색
    end
end

-- 캐릭터 생성 시 윤곽선 강조 추가
local function onCharacterAdded(player, character)
    if player.Team then
        updateHighlight(character, player.Team)
    end

    -- 팀 변경 감지하여 강조 업데이트
    player:GetPropertyChangedSignal("Team"):Connect(function()
        updateHighlight(character, player.Team)
    end)
end

-- 플레이어 추가 시 처리
local function onPlayerAdded(player)
    player.CharacterAdded:Connect(function(character)
        onCharacterAdded(player, character)
    end)

    if player.Character then
        onCharacterAdded(player, player.Character)
    end
end

-- 기존 플레이어들에게 적용
for _, player in ipairs(Players:GetPlayers()) do
    onPlayerAdded(player)
end

Players.PlayerAdded:Connect(onPlayerAdded)

   end,
})

local Button = MainTab:CreateButton({
   Name = "플레이어 닉네임,거리(m) ESP",
   Callback = function()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- 닉네임 & 거리 강조 추가
local function ensureTextHighlight(player)
    RunService.RenderStepped:Connect(function()
        if player.Character and player.Character.PrimaryPart then
            local character = player.Character
            local primaryPart = character.PrimaryPart

            -- 기존 BillboardGui 확인 (없으면 생성)
            local existingBillboard = primaryPart:FindFirstChild("PlayerInfoBillboard")
            if not existingBillboard then
                local billboard = Instance.new("BillboardGui")
                billboard.Name = "PlayerInfoBillboard"
                billboard.Size = UDim2.new(0, 200, 0, 50)
                billboard.StudsOffset = Vector3.new(0, 2, 0)
                billboard.Adornee = primaryPart
                billboard.Parent = primaryPart
                billboard.AlwaysOnTop = true

                local textLabel = Instance.new("TextLabel")
                textLabel.Size = UDim2.new(1, 0, 1, 0)
                textLabel.BackgroundTransparency = 1
                textLabel.TextColor3 = Color3.new(1, 1, 1)  -- 흰색 텍스트
                textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)  -- 검정 윤곽선
                textLabel.TextStrokeTransparency = 0.5
                textLabel.TextScaled = false  -- 크기 고정
                textLabel.TextSize = 14  -- 텍스트 크기
                textLabel.TextXAlignment = Enum.TextXAlignment.Center
                textLabel.TextYAlignment = Enum.TextYAlignment.Center
                textLabel.Parent = billboard
            end

            -- 거리 업데이트
            local localPlayer = Players.LocalPlayer
            if localPlayer and localPlayer.Character and localPlayer.Character.PrimaryPart then
                local distance = (primaryPart.Position - localPlayer.Character.PrimaryPart.Position).Magnitude
                local roundedDistance = math.floor(distance)

                -- 텍스트 갱신
                local billboard = primaryPart:FindFirstChild("PlayerInfoBillboard")
                if billboard then
                    local textLabel = billboard:FindFirstChildOfClass("TextLabel")
                    if textLabel then
                        textLabel.Text = string.format("닉네임 : %s 거리 : %dm", player.Name, roundedDistance)
                    end
                end
            end
        end
    end)
end

-- 플레이어 추가 시 처리
local function onPlayerAdded(player)
    player.CharacterAdded:Connect(function()
        ensureTextHighlight(player)
    end)

    if player.Character then
        ensureTextHighlight(player)
    end
end

-- 기존 플레이어 적용
for _, player in ipairs(Players:GetPlayers()) do
    onPlayerAdded(player)
end

-- 새로 들어오는 플레이어 감지
Players.PlayerAdded:Connect(onPlayerAdded)

   end,
})

local Button = MainTab:CreateButton({
   Name = "플레이어 HP바(체력) ESP",
   Callback = function()
 local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

            local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- 체력에 따른 색상 반환 함수
local function getHealthColor(healthPercent)
    if healthPercent > 0.75 then
        return Color3.fromRGB(0, 255, 0) -- 초록색
    elseif healthPercent > 0.5 then
        return Color3.fromRGB(255, 200, 0) -- 노란색
    elseif healthPercent > 0.25 then
        return Color3.fromRGB(255, 100, 0) -- 주황색
    else
        return Color3.fromRGB(255, 0, 0) -- 빨간색
    end
end

-- 모든 플레이어의 HP 바를 갱신하는 함수
local function createHealthBar(character)
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not rootPart then return end

    -- 기존 HP 바 제거 후 다시 생성 (중복 방지)
    local oldBar = rootPart:FindFirstChild("HealthBar")
    if oldBar then oldBar:Destroy() end

    -- BillboardGui 생성
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "HealthBar"
    billboard.Adornee = rootPart
    billboard.Size = UDim2.new(3.5, 0, 0.3, 0)
    billboard.StudsOffset = Vector3.new(0, -3.5, 0)
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = 2000
    billboard.Parent = rootPart

    -- 바 배경
    local bgFrame = Instance.new("Frame")
    bgFrame.Size = UDim2.new(1, 0, 1, 0)
    bgFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    bgFrame.BackgroundTransparency = 0.3
    bgFrame.BorderSizePixel = 0
    bgFrame.Parent = billboard

    -- HP 바
    local healthBar = Instance.new("Frame")
    local healthPercent = humanoid.Health / humanoid.MaxHealth
    healthBar.Size = UDim2.new(healthPercent, 0, 1, 0) -- **현재 체력 비율 반영**
    healthBar.BackgroundColor3 = getHealthColor(healthPercent) -- **체력 색상 반영**
    healthBar.BorderSizePixel = 0
    healthBar.Parent = bgFrame

    -- **플레이어 강조 (Outline) 추가**
    local highlight = rootPart:FindFirstChild("Highlight")
    if not highlight then
        highlight = Instance.new("Highlight")
        highlight.Name = "Highlight"
        highlight.FillTransparency = 0.7
        highlight.OutlineTransparency = 0
        highlight.Parent = rootPart
    end
    highlight.OutlineColor = getHealthColor(healthPercent) -- **체력에 따라 강조 색 변경**

    -- HP 실시간 업데이트
    humanoid.HealthChanged:Connect(function()
        local newHealthPercent = humanoid.Health / humanoid.MaxHealth

        -- 크기 업데이트
        local tween = TweenService:Create(healthBar, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {Size = UDim2.new(math.clamp(newHealthPercent, 0, 1), 0, 1, 0)})
        tween:Play()

        -- 색상 변화
        local newColor = getHealthColor(newHealthPercent)
        local colorTween = TweenService:Create(healthBar, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {BackgroundColor3 = newColor})
        colorTween:Play()

        -- 강조 색도 동기화
        highlight.OutlineColor = newColor
    end)
end

-- **3초마다 HP 바 강조 갱신 (현재 체력 반영)**
local function updateHealthBars()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                createHealthBar(player.Character) -- **현재 체력 기반으로 강조 업데이트**
            end
        end
    end
end

-- **플레이어 추가 및 재설정 처리**
local function onCharacterAdded(player)
    if not player then return end

    player.CharacterAppearanceLoaded:Connect(function(character)
        createHealthBar(character)
    end)

    if player.Character then
        createHealthBar(player.Character)
    end
end

-- **팀 변경 & 캐릭터 죽음 감지 후 HP 바 자동 적용**
local function ensureHealthBars()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            createHealthBar(player.Character)
        end
    end
end

-- **기존 플레이어 처리**
for _, player in pairs(Players:GetPlayers()) do
    onCharacterAdded(player)
end

-- **새로운 플레이어 감지**
Players.PlayerAdded:Connect(function(player)
    onCharacterAdded(player)
end)

-- **3초마다 HP 바 자동 갱신 (현재 체력 유지)**
while true do
    updateHealthBars()
    wait(3)
end

Players.PlayerAdded:Connect(onPlayerAdded)


   end,
})


local MainSection = MainTab:CreateSection("에임")

local Button = MainTab:CreateButton({
   Name = "에임봇",  -- 버튼 이름
   Callback = function()
            local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local camera = workspace.CurrentCamera
local localPlayer = Players.LocalPlayer
local currentTarget = nil
local isRightMouseDown = false

-- FOV 설정
local FOV_RADIUS = 100  -- FOV 크기 설정 (적당한 크기)
local FOV_CIRCLE = Drawing.new("Circle")
FOV_CIRCLE.Radius = FOV_RADIUS
FOV_CIRCLE.Color = Color3.new(1, 1, 1)  -- 흰색 테두리
FOV_CIRCLE.Thickness = 2
FOV_CIRCLE.NumSides = 30
FOV_CIRCLE.Filled = false  -- 내부를 비워서 테두리만 보이게 수정
FOV_CIRCLE.Visible = false

-- 우클릭 감지
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        isRightMouseDown = true
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        isRightMouseDown = false
    end
end)

-- 특정 방향에 있는 가장 가까운 플레이어 찾기 (FOV 안에 들어와야 함)
local function getClosestPlayerInFOV()
    local closestPlayer = nil
    local minDistance = math.huge
    local screenCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)  -- 화면 중앙

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("Head") then
            -- 같은 팀인 플레이어는 제외
            if player.Team == localPlayer.Team then
                continue  -- 같은 팀은 넘어가고
            end

            -- 죽은 플레이어는 제외
            if player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                local head = player.Character.Head
                local headPos, onScreen = camera:WorldToViewportPoint(head.Position)  -- 3D 위치 → 2D 화면 좌표 변환

                if onScreen then
                    local distanceFromCenter = (Vector2.new(headPos.X, headPos.Y) - screenCenter).Magnitude
                    if distanceFromCenter <= FOV_RADIUS then  -- FOV 원 안에 들어왔는지 확인
                        local distance = (camera.CFrame.Position - head.Position).Magnitude
                        if distance < minDistance then
                            minDistance = distance
                            closestPlayer = player
                        end
                    end
                end
            end
        end
    end

    return closestPlayer
end

-- 1인칭인지 확인하는 함수 (Shift Lock 포함)
local function isFirstPerson()
    return UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter
end

-- 카메라 고정
RunService.RenderStepped:Connect(function()
    local inFirstPerson = isFirstPerson()

    -- FOV 원을 1인칭에서만 보이게 하고 Shift Lock에서는 보이지 않게 처리
    if inFirstPerson then
        FOV_CIRCLE.Visible = true
        FOV_CIRCLE.Position = UserInputService:GetMouseLocation()
    else
        FOV_CIRCLE.Visible = false
    end

    -- 우클릭을 눌렀고, 1인칭 상태일 때만 작동
    if isRightMouseDown and inFirstPerson then
        local targetPlayer = getClosestPlayerInFOV()

        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Head") then
            local head = targetPlayer.Character.Head

            -- 에임을 대상 머리에 고정
            camera.CFrame = CFrame.new(camera.CFrame.Position, head.Position)

            currentTarget = targetPlayer
        else
            currentTarget = nil
        end
    else
        currentTarget = nil
    end
end)
   end,
})

local Section = MainTab:CreateSection("능력")

local Button = MainTab:CreateButton({
   Name = "Speed Hub (스피드 핵)",
   Callback = function()
  loadstring(game:HttpGet("https://raw.githubusercontent.com/pasp9687/Spedd-Hub/main/Speed%20Hub.lua"))()
   end,
})

local Button = MainTab:CreateButton({
   Name = "어드민 권한",
   Callback = function()
   loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
   end,
})

local Button = MainTab:CreateButton({
   Name = "TP툴 아이템",
   Callback = function()
   local Tele = Instance.new("Tool", game.Players.LocalPlayer.Backpack)
Tele.RequiresHandle = false
Tele.RobloxLocked = true
Tele.Name = "TPTool"
Tele.ToolTip = "아이템을 들고 원하는곳을 클릭하세요."
Tele.Equipped:connect(function(Mouse)
	Mouse.Button1Down:connect(function()
		if Mouse.Target then
			game.Workspace:FindFirstChild(game.Players.LocalPlayer.Name).HumanoidRootPart.CFrame = (CFrame.new(Mouse.Hit.x, Mouse.Hit.y + 5, Mouse.Hit.z))
		end
	end)
end)
   end,
})

local Button = MainTab:CreateButton({
   Name = "벽 통과",
   Callback = function()
   --[[
	MIT License

	Copyright (c) 2019 WeAreDevs wearedevs.net

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.
--]]

_G.noclip = not _G.noclip
print(_G.noclip)

if not game:GetService('Players').LocalPlayer.Character:FindFirstChild("LowerTorso") then
	while _G.noclip do
		game:GetService("RunService").Stepped:wait()
		game.Players.LocalPlayer.Character.Head.CanCollide = false
		game.Players.LocalPlayer.Character.Torso.CanCollide = false
	end
else
	if _G.InitNC ~= true then     
		_G.NCFunc = function(part)      
			local pos = game:GetService('Players').LocalPlayer.Character.LowerTorso.Position.Y  
			if _G.noclip then             
				if part.Position.Y > pos then                 
					part.CanCollide = false             
				end        
			end    
		end      
		_G.InitNC = true 
	end 
	 
	game:GetService('Players').LocalPlayer.Character.Humanoid.Touched:connect(_G.NCFunc) 
end
   end,
})

local Button = MainTab:CreateButton({
   Name = "연속 무한 점프(딜레이 X)",
   Callback = function()
   --[[
	MIT License

	Copyright (c) 2019 WeAreDevs wearedevs.net

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.
--]]

_G.infinjump = not _G.infinjump

local plr = game:GetService'Players'.LocalPlayer
local m = plr:GetMouse()
m.KeyDown:connect(function(k)
	if _G.infinjump then
		if k:byte() == 32 then
		plrh = game:GetService'Players'.LocalPlayer.Character:FindFirstChildOfClass'Humanoid'
		plrh:ChangeState('Jumping')
		wait()
		plrh:ChangeState('Seated')
		end
	end
end)
   end,
})

local MainTab = Window:CreateTab("기타 텔레포트", nil) -- Title, Image

local Section = MainTab:CreateSection("좌표")

local Toggle = MainTab:CreateToggle({
   Name = "좌표 표시",
   CurrentValue = false,
   Flag = "CoordinateToggle", -- 설정 파일에서 구분되는 플래그
   Callback = function(Value)
       local player = game.Players.LocalPlayer
       local character = player.Character or player.CharacterAdded:Wait()
       local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

       -- UI가 리셋되어도 유지되도록 설정
       local screenGui = player:FindFirstChild("PlayerGui"):FindFirstChild("CoordinateUI")

       if not screenGui then
           screenGui = Instance.new("ScreenGui")
           screenGui.Name = "CoordinateUI"
           screenGui.ResetOnSpawn = false -- 🟢 리셋되어도 UI 유지
           screenGui.Parent = player:FindFirstChild("PlayerGui")
       end

       -- 프레임 (배경)
       local frame = screenGui:FindFirstChild("CoordinateFrame")
       if not frame then
           frame = Instance.new("Frame")
           frame.Name = "CoordinateFrame"
           frame.Size = UDim2.new(0, 200, 0, 100)
           frame.Position = UDim2.new(0.05, 0, 0.05, 0) -- 왼쪽 상단
           frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
           frame.BackgroundTransparency = 0.3
           frame.Visible = false -- 기본적으로 숨김
           frame.Parent = screenGui
       end

       -- 텍스트 라벨 (좌표 표시)
       local textLabel = frame:FindFirstChild("CoordinateLabel")
       if not textLabel then
           textLabel = Instance.new("TextLabel")
           textLabel.Name = "CoordinateLabel"
           textLabel.Size = UDim2.new(1, 0, 1, 0)
           textLabel.TextScaled = true
           textLabel.TextColor3 = Color3.new(1, 1, 1)
           textLabel.BackgroundTransparency = 1
           textLabel.Parent = frame
       end

       -- 🟢 좌표 업데이트 함수
       local running = false
       local function updatePosition()
           running = true
           while running do
               local pos = humanoidRootPart.Position
               textLabel.Text = string.format("X: %d\nY: %d\nZ: %d", pos.X, pos.Y, pos.Z)
               wait(0.1)  -- 0.1초마다 갱신
           end
       end

       -- 캐릭터 리스폰 시 다시 감지 (UI 유지)
       player.CharacterAdded:Connect(function(newCharacter)
           character = newCharacter
           humanoidRootPart = character:WaitForChild("HumanoidRootPart")
       end)

       -- 🟢 토글 기능 실행
       if Value then
           frame.Visible = true
           updatePosition()
       else
           frame.Visible = false
           running = false
       end
   end,
})


local Section = MainTab:CreateSection("텔레포트")

local Button = MainTab:CreateButton({
   Name = "중앙 캡쳐 포인트(깃발)",
   Callback = function()
   local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- 🟢 이동할 좌표 (여기에 원하는 좌표를 입력하세요)
local targetPosition = Vector3.new(-657, 121, -1256) -- X, Y, Z 값을 원하는 위치로 변경

-- 텔레포트 실행
humanoidRootPart.CFrame = CFrame.new(targetPosition)

   end,
})

local Section = MainTab:CreateSection("배럴")

local Button = MainTab:CreateButton({
   Name = "배럴 1",
   Callback = function()
   local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- 🟢 이동할 좌표 (여기에 원하는 좌표를 입력하세요)
local targetPosition = Vector3.new(670, 121, 781) -- X, Y, Z 값을 원하는 위치로 변경

-- 텔레포트 실행
humanoidRootPart.CFrame = CFrame.new(targetPosition)

   end,
})

local Button = MainTab:CreateButton({
   Name = "배럴 2",
   Callback = function()
   local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- 🟢 이동할 좌표 (여기에 원하는 좌표를 입력하세요)
local targetPosition = Vector3.new(-3533, 121, -2660) -- X, Y, Z 값을 원하는 위치로 변경

-- 텔레포트 실행
humanoidRootPart.CFrame = CFrame.new(targetPosition)

   end,
})

local Button = MainTab:CreateButton({
   Name = "배럴 3",
   Callback = function()
   local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- 🟢 이동할 좌표 (여기에 원하는 좌표를 입력하세요)
local targetPosition = Vector3.new(-1683, 121, -3529) -- X, Y, Z 값을 원하는 위치로 변경

-- 텔레포트 실행
humanoidRootPart.CFrame = CFrame.new(targetPosition)

   end,
})

local Button = MainTab:CreateButton({
   Name = "배럴 4",
   Callback = function()
   local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- 🟢 이동할 좌표 (여기에 원하는 좌표를 입력하세요)
local targetPosition = Vector3.new(-1212, 67, -1878) -- X, Y, Z 값을 원하는 위치로 변경

-- 텔레포트 실행
humanoidRootPart.CFrame = CFrame.new(targetPosition)

   end,
})

local Button = MainTab:CreateButton({
   Name = "배럴 5",
   Callback = function()
   local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- 🟢 이동할 좌표 (여기에 원하는 좌표를 입력하세요)
local targetPosition = Vector3.new(-971, 69, -808) -- X, Y, Z 값을 원하는 위치로 변경

-- 텔레포트 실행
humanoidRootPart.CFrame = CFrame.new(targetPosition)

   end,
})

local MainTab = Window:CreateTab("🏠 · 기지", nil) -- Title, Image

local Section = MainTab:CreateSection("TP")

    local Button = MainTab:CreateButton({
   Name = "Alpha 기지  TP",
   Callback = function()
   local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- 🟢 이동할 좌표 (여기에 원하는 좌표를 입력하세요)
local targetPosition = Vector3.new(-1167, 65, -4853) -- X, Y, Z 값을 원하는 위치로 변경

-- 텔레포트 실행
humanoidRootPart.CFrame = CFrame.new(targetPosition)

   end,
})

    local Button = MainTab:CreateButton({
   Name = "Bravo 기지  TP",
   Callback = function()
   local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- 🟢 이동할 좌표 (여기에 원하는 좌표를 입력하세요)
local targetPosition = Vector3.new(-175, 65, -4972) -- X, Y, Z 값을 원하는 위치로 변경

-- 텔레포트 실행
humanoidRootPart.CFrame = CFrame.new(targetPosition)

   end,
})

    local Button = MainTab:CreateButton({
   Name = "Charlie 기지  TP",
   Callback = function()
   local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- 🟢 이동할 좌표 (여기에 원하는 좌표를 입력하세요)
local targetPosition = Vector3.new(854, 65, -4779) -- X, Y, Z 값을 원하는 위치로 변경

-- 텔레포트 실행
humanoidRootPart.CFrame = CFrame.new(targetPosition)

   end,
})

    local Button = MainTab:CreateButton({
   Name = "Delta 기지  TP",
   Callback = function()
   local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- 🟢 이동할 좌표 (여기에 원하는 좌표를 입력하세요)
local targetPosition = Vector3.new(2114, 65, -3990) -- X, Y, Z 값을 원하는 위치로 변경

-- 텔레포트 실행
humanoidRootPart.CFrame = CFrame.new(targetPosition)

   end,
})

    local Button = MainTab:CreateButton({
   Name = "Echo 기지  TP",
   Callback = function()
   local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- 🟢 이동할 좌표 (여기에 원하는 좌표를 입력하세요)
local targetPosition = Vector3.new(2808, 65, -3012) -- X, Y, Z 값을 원하는 위치로 변경

-- 텔레포트 실행
humanoidRootPart.CFrame = CFrame.new(targetPosition)

   end,
})

    local Button = MainTab:CreateButton({
   Name = "Foxtrot 기지  TP",
   Callback = function()
   local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- 🟢 이동할 좌표 (여기에 원하는 좌표를 입력하세요)
local targetPosition = Vector3.new(3098, 65, -1743) -- X, Y, Z 값을 원하는 위치로 변경

-- 텔레포트 실행
humanoidRootPart.CFrame = CFrame.new(targetPosition)

   end,
})

    local Button = MainTab:CreateButton({
   Name = "Golf 기지  TP",
   Callback = function()
   local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- 🟢 이동할 좌표 (여기에 원하는 좌표를 입력하세요)
local targetPosition = Vector3.new(3430, 65, -516) -- X, Y, Z 값을 원하는 위치로 변경

-- 텔레포트 실행
humanoidRootPart.CFrame = CFrame.new(targetPosition)

   end,
})

    local Button = MainTab:CreateButton({
   Name = "Hotel 기지  TP",
   Callback = function()
   local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- 🟢 이동할 좌표 (여기에 원하는 좌표를 입력하세요)
local targetPosition = Vector3.new(3335, 65, 640) -- X, Y, Z 값을 원하는 위치로 변경

-- 텔레포트 실행
humanoidRootPart.CFrame = CFrame.new(targetPosition)

   end,
})

    local Button = MainTab:CreateButton({
   Name = "Juliet 기지  TP",
   Callback = function()
   local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- 🟢 이동할 좌표 (여기에 원하는 좌표를 입력하세요)
local targetPosition = Vector3.new(2995, 65, 1862) -- X, Y, Z 값을 원하는 위치로 변경

-- 텔레포트 실행
humanoidRootPart.CFrame = CFrame.new(targetPosition)

   end,
})

    local Button = MainTab:CreateButton({
   Name = "Kilo 기지  TP",
   Callback = function()
   local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- 🟢 이동할 좌표 (여기에 원하는 좌표를 입력하세요)
local targetPosition = Vector3.new(2593, 65, 2991) -- X, Y, Z 값을 원하는 위치로 변경

-- 텔레포트 실행
humanoidRootPart.CFrame = CFrame.new(targetPosition)

   end,
})

    local Button = MainTab:CreateButton({
   Name = "Lima 기지  TP",
   Callback = function()
   local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- 🟢 이동할 좌표 (여기에 원하는 좌표를 입력하세요)
local targetPosition = Vector3.new(1023, 65, 3480) -- X, Y, Z 값을 원하는 위치로 변경

-- 텔레포트 실행
humanoidRootPart.CFrame = CFrame.new(targetPosition)

   end,
})

    local Button = MainTab:CreateButton({
   Name = "Omega 기지  TP",
   Callback = function()
   local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- 🟢 이동할 좌표 (여기에 원하는 좌표를 입력하세요)
local targetPosition = Vector3.new(-364, 65, 3986) -- X, Y, Z 값을 원하는 위치로 변경

-- 텔레포트 실행
humanoidRootPart.CFrame = CFrame.new(targetPosition)

   end,
})

    local Button = MainTab:CreateButton({
   Name = "Romeo 기지  TP",
   Callback = function()
   local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- 🟢 이동할 좌표 (여기에 원하는 좌표를 입력하세요)
local targetPosition = Vector3.new(-1543, 65, 3751) -- X, Y, Z 값을 원하는 위치로 변경

-- 텔레포트 실행
humanoidRootPart.CFrame = CFrame.new(targetPosition)

   end,
})

    local Button = MainTab:CreateButton({
   Name = "Sierra 기지  TP",
   Callback = function()
   local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- 🟢 이동할 좌표 (여기에 원하는 좌표를 입력하세요)
local targetPosition = Vector3.new(-2597, 65, 2555) -- X, Y, Z 값을 원하는 위치로 변경

-- 텔레포트 실행
humanoidRootPart.CFrame = CFrame.new(targetPosition)

   end,
})

    local Button = MainTab:CreateButton({
   Name = "Tango 기지  TP",
   Callback = function()
   local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- 🟢 이동할 좌표 (여기에 원하는 좌표를 입력하세요)
local targetPosition = Vector3.new(-3088, 65, 1496) -- X, Y, Z 값을 원하는 위치로 변경

-- 텔레포트 실행
humanoidRootPart.CFrame = CFrame.new(targetPosition)

   end,
})

    local Button = MainTab:CreateButton({
   Name = "Victor 기지  TP",
   Callback = function()
   local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- 🟢 이동할 좌표 (여기에 원하는 좌표를 입력하세요)
local targetPosition = Vector3.new(-3656, 65, 621) -- X, Y, Z 값을 원하는 위치로 변경

-- 텔레포트 실행
humanoidRootPart.CFrame = CFrame.new(targetPosition)

   end,
})

    local Button = MainTab:CreateButton({
   Name = "Yankee 기지  TP",
   Callback = function()
   local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- 🟢 이동할 좌표 (여기에 원하는 좌표를 입력하세요)
local targetPosition = Vector3.new(-4020, 65, -316) -- X, Y, Z 값을 원하는 위치로 변경

-- 텔레포트 실행
humanoidRootPart.CFrame = CFrame.new(targetPosition)

   end,
})

    local Button = MainTab:CreateButton({
   Name = "Zulu 기지  TP",
   Callback = function()
   local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- 🟢 이동할 좌표 (여기에 원하는 좌표를 입력하세요)
local targetPosition = Vector3.new(-4102, 65, -1379) -- X, Y, Z 값을 원하는 위치로 변경

-- 텔레포트 실행
humanoidRootPart.CFrame = CFrame.new(targetPosition)

   end,
})

local MainTab = Window:CreateTab("⚙️ · 탱크 부품", nil) -- Title, Image

local MainSection = MainTab:CreateSection("탱크 부품 TP")

    local Button = MainTab:CreateButton({
   Name = "Alpha 기지  TP",
   Callback = function()
   local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- 🟢 이동할 좌표 (여기에 원하는 좌표를 입력하세요)
local targetPosition = Vector3.new(-971, 22, -4725) -- X, Y, Z 값을 원하는 위치로 변경

-- 텔레포트 실행
humanoidRootPart.CFrame = CFrame.new(targetPosition)

   end,
})

    local Button = MainTab:CreateButton({
   Name = "Bravo 기지  TP",
   Callback = function()
   local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- 🟢 이동할 좌표 (여기에 원하는 좌표를 입력하세요)
local targetPosition = Vector3.new(-22, 22, -4797) -- X, Y, Z 값을 원하는 위치로 변경

-- 텔레포트 실행
humanoidRootPart.CFrame = CFrame.new(targetPosition)

   end,
})

    local Button = MainTab:CreateButton({
   Name = "Charlie 기지  TP",
   Callback = function()
   local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- 🟢 이동할 좌표 (여기에 원하는 좌표를 입력하세요)
local targetPosition = Vector3.new(955, 22, -4571) -- X, Y, Z 값을 원하는 위치로 변경

-- 텔레포트 실행
humanoidRootPart.CFrame = CFrame.new(targetPosition)

   end,
})

    local Button = MainTab:CreateButton({
   Name = "Delta 기지  TP",
   Callback = function()
   local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- 🟢 이동할 좌표 (여기에 원하는 좌표를 입력하세요)
local targetPosition = Vector3.new(2095, 22, -3760) -- X, Y, Z 값을 원하는 위치로 변경

-- 텔레포트 실행
humanoidRootPart.CFrame = CFrame.new(targetPosition)

   end,
})

    local Button = MainTab:CreateButton({
   Name = "Echo 기지  TP",
   Callback = function()
   local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- 🟢 이동할 좌표 (여기에 원하는 좌표를 입력하세요)
local targetPosition = Vector3.new(2713, 22, -2803) -- X, Y, Z 값을 원하는 위치로 변경

-- 텔레포트 실행
humanoidRootPart.CFrame = CFrame.new(targetPosition)

   end,
})

    local Button = MainTab:CreateButton({
   Name = "Foxtrot 기지  TP",
   Callback = function()
   local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- 🟢 이동할 좌표 (여기에 원하는 좌표를 입력하세요)
local targetPosition = Vector3.new(2923, 22, -1591) -- X, Y, Z 값을 원하는 위치로 변경

-- 텔레포트 실행
humanoidRootPart.CFrame = CFrame.new(targetPosition)

   end,
})

    local Button = MainTab:CreateButton({
   Name = "Golf 기지  TP",
   Callback = function()
   local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- 🟢 이동할 좌표 (여기에 원하는 좌표를 입력하세요)
local targetPosition = Vector3.new(3254, 22, -366) -- X, Y, Z 값을 원하는 위치로 변경

-- 텔레포트 실행
humanoidRootPart.CFrame = CFrame.new(targetPosition)

   end,
})

    local Button = MainTab:CreateButton({
   Name = "Hotel 기지  TP",
   Callback = function()
   local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- 🟢 이동할 좌표 (여기에 원하는 좌표를 입력하세요)
local targetPosition = Vector3.new(3134, 22, 761) -- X, Y, Z 값을 원하는 위치로 변경

-- 텔레포트 실행
humanoidRootPart.CFrame = CFrame.new(targetPosition)

   end,
})

    local Button = MainTab:CreateButton({
   Name = "Juliet 기지  TP",
   Callback = function()
   local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- 🟢 이동할 좌표 (여기에 원하는 좌표를 입력하세요)
local targetPosition = Vector3.new(2786, 22, 1963) -- X, Y, Z 값을 원하는 위치로 변경

-- 텔레포트 실행
humanoidRootPart.CFrame = CFrame.new(targetPosition)

   end,
})

    local Button = MainTab:CreateButton({
   Name = "Kilo 기지  TP",
   Callback = function()
   local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- 🟢 이동할 좌표 (여기에 원하는 좌표를 입력하세요)
local targetPosition = Vector3.new(2363, 22, 3038) -- X, Y, Z 값을 원하는 위치로 변경

-- 텔레포트 실행
humanoidRootPart.CFrame = CFrame.new(targetPosition)

   end,
})

    local Button = MainTab:CreateButton({
   Name = "Lima 기지  TP",
   Callback = function()
   local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- 🟢 이동할 좌표 (여기에 원하는 좌표를 입력하세요)
local targetPosition = Vector3.new(806, 22, 3564) -- X, Y, Z 값을 원하는 위치로 변경

-- 텔레포트 실행
humanoidRootPart.CFrame = CFrame.new(targetPosition)

   end,
})

    local Button = MainTab:CreateButton({
   Name = "Omega 기지  TP",
   Callback = function()
   local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- 🟢 이동할 좌표 (여기에 원하는 좌표를 입력하세요)
local targetPosition = Vector3.new(-516, 22, 3810) -- X, Y, Z 값을 원하는 위치로 변경

-- 텔레포트 실행
humanoidRootPart.CFrame = CFrame.new(targetPosition)

   end,
})

    local Button = MainTab:CreateButton({
   Name = "Romeo 기지  TP",
   Callback = function()
   local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- 🟢 이동할 좌표 (여기에 원하는 좌표를 입력하세요)
local targetPosition = Vector3.new(-1607, 22, 3528) -- X, Y, Z 값을 원하는 위치로 변경

-- 텔레포트 실행
humanoidRootPart.CFrame = CFrame.new(targetPosition)

   end,
})

    local Button = MainTab:CreateButton({
   Name = "Sierra 기지  TP",
   Callback = function()
   local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- 🟢 이동할 좌표 (여기에 원하는 좌표를 입력하세요)
local targetPosition = Vector3.new(-2581, 22, 2323) -- X, Y, Z 값을 원하는 위치로 변경

-- 텔레포트 실행
humanoidRootPart.CFrame = CFrame.new(targetPosition)

   end,
})

    local Button = MainTab:CreateButton({
   Name = "Tango 기지  TP",
   Callback = function()
   local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- 🟢 이동할 좌표 (여기에 원하는 좌표를 입력하세요)
local targetPosition = Vector3.new(-3032, 22, 1271) -- X, Y, Z 값을 원하는 위치로 변경

-- 텔레포트 실행
humanoidRootPart.CFrame = CFrame.new(targetPosition)

   end,
})

    local Button = MainTab:CreateButton({
   Name = "Victor 기지  TP",
   Callback = function()
   local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- 🟢 이동할 좌표 (여기에 원하는 좌표를 입력하세요)
local targetPosition = Vector3.new(-3580, 22, 401) -- X, Y, Z 값을 원하는 위치로 변경

-- 텔레포트 실행
humanoidRootPart.CFrame = CFrame.new(targetPosition)

   end,
})

    local Button = MainTab:CreateButton({
   Name = "Yankee 기지  TP",
   Callback = function()
   local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- 🟢 이동할 좌표 (여기에 원하는 좌표를 입력하세요)
local targetPosition = Vector3.new(-3890, 23, -507) -- X, Y, Z 값을 원하는 위치로 변경

-- 텔레포트 실행
humanoidRootPart.CFrame = CFrame.new(targetPosition)

   end,
})
