if game.PlaceId == 132508978828159 then end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Rayfield Made By Zeetuan",
   Icon = 0,
   LoadingTitle = "Rayfield",
   LoadingSubtitle = "by Zeetuan",
   ShowText = "Rayfield", 
   Theme = "Default", 

   ToggleUIKeybind = "K", 

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, 

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, 
      FileName = "BIG HUB"
   },

   Discord = {
      Enabled = false, 
      Invite = "noinvitelink", 
      RememberJoins = true 
   },

   KeySystem = false, 
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", 
      FileName = "Key", 
      SaveKey = true, 
      GrabKeyFromSite = false, 
      Key = {"Hello"} 
   }
})

-- ==================== MAIN CATEGORY: AUTO TAB ====================
local MainTab = Window:CreateTab("Auto", nil) 
local MainSection = MainTab:CreateSection("Main Operations")

Rayfield:Notify({
   Title = "You Executed the scripted",
   Content = "Good luck",
   Duration = 4.5,
   Image = nil,
})

-- TOGGLE 2: UPGRADED ANIMATION-SKIP AUTO ROLL
local Toggle2 = MainTab:CreateToggle({
   Name = "Auto Roll (Instant Skip)",
   CurrentValue = false,
   Flag = "Toggle2", 
   Callback = function(Value)
       _G.AutoRollActive = Value 

       if Value then
           task.spawn(function()
               local player = game.Players.LocalPlayer
               local Event = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RollWeapon")
               
               local playerGui = player:WaitForChild("PlayerGui", 5)
               local handlers = playerGui and playerGui:WaitForChild("Handlers", 5)
               local rollAnimScript = handlers and handlers:FindFirstChild("RollAnimation")

               while _G.AutoRollActive do
                   if rollAnimScript and rollAnimScript:IsA("LocalScript") then
                       rollAnimScript.Disabled = true
                   end

                   task.spawn(function() Event:FireServer(3) end)
                   task.spawn(function() Event:FireServer(3) end)
                   task.spawn(function() Event:FireServer(3) end)
                   
                   task.wait(0.03) 
               end
               
               if rollAnimScript and rollAnimScript:IsA("LocalScript") then
                   rollAnimScript.Disabled = false
               end
           end)
       end
   end,
})

-- TOGGLE 1: AUTO POTION
local Toggle1 = MainTab:CreateToggle({
   Name = "Auto Collect Potion",
   CurrentValue = false,
   Flag = "Toggle1", 
   Callback = function(Value)
      _G.AutoPotionActive = Value
      if Value then
          task.spawn(function()
              while _G.AutoPotionActive do
                  local player = game.Players.LocalPlayer
                  local character = player.Character
                  local root = character and character:FindFirstChild("HumanoidRootPart")

                  if root then
                      local orb = workspace:FindFirstChild("DropOrb")
                      if orb and orb:IsA("BasePart") then
                          local originalPos = root.CFrame
                          root.CFrame = orb.CFrame
                          task.wait(0.1)
                          root.CFrame = originalPos
                      end
                  end
                  task.wait(0.2)
              end
          end)
      end
   end,
})

-- ==================== UTILITY CATEGORY: UTILITY TAB ====================
local UtilityTab = Window:CreateTab("Utility", nil) 
local UtilitySection = UtilityTab:CreateSection("Movement Modification")

-- Global States for Utilities
_G.WalkSpeedEnabled = false
_G.WalkSpeedValue = 16
_G.NoclipActive = false
_G.InfiniteJumpActive = false
_G.FlyActive = false
_G.FlySpeed = 50 

-- SERVICE HOOKS FOR UTILITIES
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- WalkSpeed Execution Loop
task.spawn(function()
    while true do
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid", 5)
        if humanoid then
            if not _G.FlyActive and _G.WalkSpeedEnabled then
                humanoid.WalkSpeed = _G.WalkSpeedValue
            elseif not _G.FlyActive and not _G.WalkSpeedEnabled then
                humanoid.WalkSpeed = 16 
            end
        end
        task.wait(0.1)
    end
end)

-- Noclip Thread Execution Loop
RunService.Stepped:Connect(function()
    if _G.NoclipActive or _G.FlyActive then 
        local character = LocalPlayer.Character
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end
end)

-- Infinite Jump Listener Connection
UserInputService.JumpRequest:Connect(function()
    if _G.InfiniteJumpActive then
        local character = LocalPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Real Admin Fly Engine
local flyConnection
local function StartFlight()
    local character = LocalPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    
    if not root or not humanoid then return end
    
    local workspaceGravity = workspace.Gravity
    workspace.Gravity = 0 
    
    local keysPressed = {W = false, A = false, S = false, D = false, Space = false, LeftShift = false}
    
    local inputBegan = UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == Enum.KeyCode.W then keysPressed.W = true
        elseif input.KeyCode == Enum.KeyCode.S then keysPressed.S = true
        elseif input.KeyCode == Enum.KeyCode.A then keysPressed.A = true
        elseif input.KeyCode == Enum.KeyCode.D then keysPressed.D = true
        elseif input.KeyCode == Enum.KeyCode.Space then keysPressed.Space = true
        elseif input.KeyCode == Enum.KeyCode.LeftShift then keysPressed.LeftShift = true end
    end)
    
    local inputEnded = UserInputService.InputEnded:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.W then keysPressed.W = false
        elseif input.KeyCode == Enum.KeyCode.S then keysPressed.S = false
        elseif input.KeyCode == Enum.KeyCode.A then keysPressed.A = false
        elseif input.KeyCode == Enum.KeyCode.D then keysPressed.D = false
        elseif input.KeyCode == Enum.KeyCode.Space then keysPressed.Space = false
        elseif input.KeyCode == Enum.KeyCode.LeftShift then keysPressed.LeftShift = false end
    end)
    
    humanoid:ChangeState(Enum.HumanoidStateType.Physics)
    
    flyConnection = RunService.RenderStepped:Connect(function()
        if not _G.FlyActive or not root or not root.Parent then
            if flyConnection then flyConnection:Disconnect() end
            inputBegan:Disconnect()
            inputEnded:Disconnect()
            workspace.Gravity = workspaceGravity 
            if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.GettingUp) end
            return
        end
        
        root.Velocity = Vector3.new(0, 0, 0)
        root.RotVelocity = Vector3.new(0, 0, 0)
        
        local cameraCFrame = Camera.CFrame
        local moveVector = Vector3.new(0, 0, 0)
        
        if keysPressed.W then moveVector = moveVector + cameraCFrame.LookVector end
        if keysPressed.S then moveVector = moveVector - cameraCFrame.LookVector end
        if keysPressed.D then moveVector = moveVector + cameraCFrame.RightVector end
        if keysPressed.A then moveVector = moveVector - cameraCFrame.RightVector end
        if keysPressed.Space then moveVector = moveVector + Vector3.new(0, 1, 0) end
        if keysPressed.LeftShift then moveVector = moveVector - Vector3.new(0, 1, 0) end
        
        if moveVector.Magnitude > 0 then
            root.CFrame = CFrame.new(root.Position + (moveVector.Unit * (_G.FlySpeed / 25))) * CFrame.Angles(cameraCFrame:ToEulerAnglesXYZ())
        else
            root.CFrame = CFrame.new(root.Position) * CFrame.Angles(cameraCFrame:ToEulerAnglesXYZ())
        end
    end)
end

LocalPlayer.CharacterAdded:Connect(function()
    if flyConnection then flyConnection:Disconnect() end
    _G.FlyActive = false
end)

-- TOGGLE: ACTIVATE WALKSPEED
local SpeedToggle = UtilityTab:CreateToggle({
   Name = "Enable WalkSpeed",
   CurrentValue = false,
   Flag = "SpeedToggleFlag",
   Callback = function(Value)
       _G.WalkSpeedEnabled = Value
   end,
})

-- SLIDER: WALKSPEED ADJUSTMENT
local SpeedSlider = UtilityTab:CreateSlider({
   Name = "WalkSpeed Velocity",
   Range = {16, 250},
   Increment = 1,
   Suffix = "Studs",
   CurrentValue = 16,
-- ==================== UTILITY CATEGORY: UTILITY TAB ====================
local UtilityTab = Window:CreateTab("Utility", nil) 
local UtilitySection = UtilityTab:CreateSection("Movement Modification")

-- Global States for Utilities
_G.WalkSpeedEnabled = false
_G.WalkSpeedValue = 16
_G.NoclipActive = false
_G.InfiniteJumpActive = false
_G.FlyActive = false
_G.FlySpeed = 50 

-- SERVICE HOOKS FOR UTILITIES
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- WalkSpeed Execution Loop
task.spawn(function()
    while true do
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid", 5)
        if humanoid then
            if not _G.FlyActive and _G.WalkSpeedEnabled then
                humanoid.WalkSpeed = _G.WalkSpeedValue
            elseif not _G.FlyActive and not _G.WalkSpeedEnabled then
                humanoid.WalkSpeed = 16 
            end
        end
        task.wait(0.1)
    end
end)

-- Noclip Thread Execution Loop
RunService.Stepped:Connect(function()
    if _G.NoclipActive or _G.FlyActive then 
        local character = LocalPlayer.Character
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end
end)

-- Infinite Jump Listener Connection
UserInputService.JumpRequest:Connect(function()
    if _G.InfiniteJumpActive then
        local character = LocalPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Mobile Compatible Real Admin Fly Engine
local flyConnection
local function StartFlight()
    local character = LocalPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    
    if not root or not humanoid then return end
    
    local workspaceGravity = workspace.Gravity
    workspace.Gravity = 0 
    
    -- Keyboard tracking fallbacks
    local keysPressed = {W = false, A = false, S = false, D = false, Space = false, LeftShift = false}
    
    local inputBegan = UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == Enum.KeyCode.W then keysPressed.W = true
        elseif input.KeyCode == Enum.KeyCode.S then keysPressed.S = true
        elseif input.KeyCode == Enum.KeyCode.A then keysPressed.A = true
        elseif input.KeyCode == Enum.KeyCode.D then keysPressed.D = true
        elseif input.KeyCode == Enum.KeyCode.Space then keysPressed.Space = true
        elseif input.KeyCode == Enum.KeyCode.LeftShift then keysPressed.LeftShift = true end
    end)
    
    local inputEnded = UserInputService.InputEnded:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.W then keysPressed.W = false
        elseif input.KeyCode == Enum.KeyCode.S then keysPressed.S = false
        elseif input.KeyCode == Enum.KeyCode.A then keysPressed.A = false
        elseif input.KeyCode == Enum.KeyCode.D then keysPressed.D = false
        elseif input.KeyCode == Enum.KeyCode.Space then keysPressed.Space = false
        elseif input.KeyCode == Enum.KeyCode.LeftShift then keysPressed.LeftShift = false end
    end)
    
    humanoid:ChangeState(Enum.HumanoidStateType.Physics)
    
    flyConnection = RunService.RenderStepped:Connect(function()
        if not _G.FlyActive or not root or not root.Parent then
            if flyConnection then flyConnection:Disconnect() end
            inputBegan:Disconnect()
            inputEnded:Disconnect()
            workspace.Gravity = workspaceGravity 
            if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.GettingUp) end
            return
        end
        
        root.Velocity = Vector3.new(0, 0, 0)
        root.RotVelocity = Vector3.new(0, 0, 0)
        
        local cameraCFrame = Camera.CFrame
        local moveVector = Vector3.new(0, 0, 0)
        
        -- Cross-platform system: Detects Mobile Joystick input or PC Keyboard input
        if humanoid.MoveDirection.Magnitude > 0 then
            moveVector = humanoid.MoveDirection
        else
            if keysPressed.W then moveVector = moveVector + cameraCFrame.LookVector end
            if keysPressed.S then moveVector = moveVector - cameraCFrame.LookVector end
            if keysPressed.D then moveVector = moveVector + cameraCFrame.RightVector end
            if keysPressed.A then moveVector = moveVector - cameraCFrame.RightVector end
            if keysPressed.Space then moveVector = moveVector + Vector3.new(0, 1, 0) end
            if keysPressed.LeftShift then moveVector = moveVector - Vector3.new(0, 1, 0) end
        end
        
        if moveVector.Magnitude > 0 then
            if humanoid.MoveDirection.Magnitude > 0 then
                -- Mobile flight uses camera view vector orientation paired with joystick force vectors
                root.CFrame = CFrame.new(root.Position + (moveVector * (_G.FlySpeed / 25))) * CFrame.Angles(cameraCFrame:ToEulerAnglesXYZ())
            else
                root.CFrame = CFrame.new(root.Position + (moveVector.Unit * (_G.FlySpeed / 25))) * CFrame.Angles(cameraCFrame:ToEulerAnglesXYZ())
            end
        else
            root.CFrame = CFrame.new(root.Position) * CFrame.Angles(cameraCFrame:ToEulerAnglesXYZ())
        end
    end)
end

LocalPlayer.CharacterAdded:Connect(function()
    if flyConnection then flyConnection:Disconnect() end
    _G.FlyActive = false
end)

-- TOGGLE: ACTIVATE WALKSPEED
local SpeedToggle = UtilityTab:CreateToggle({
   Name = "Enable WalkSpeed",
   CurrentValue = false,
   Flag = "SpeedToggleFlag",
   Callback = function(Value)
       _G.WalkSpeedEnabled = Value
   end,
})

-- SLIDER: WALKSPEED ADJUSTMENT
local SpeedSlider = UtilityTab:CreateSlider({
   Name = "WalkSpeed Velocity",
   Range = {16, 250},
   Increment = 1,
   Suffix = "Studs",
   CurrentValue = 16,
   Flag = "SpeedSliderFlag", 
   Callback = function(Value)
       _G.WalkSpeedValue = Value
   end,
})

-- TOGGLE: ADMIN COMMAND FLY MODE
local FlyToggle = UtilityTab:CreateToggle({
   Name = "Fly (Admin Style)",
   CurrentValue = false,
   Flag = "FlyToggleFlag",
   Callback = function(Value)
       _G.FlyActive = Value
       if Value then
           StartFlight()
       end
   end,
})

-- SLIDER: FLIGHT ACCELERATION SPEED
local FlySpeedSlider = UtilityTab:CreateSlider({
   Name = "Flight Speed Multiplier",
   Range = {10, 300},
   Increment = 5,
   Suffix = "Speed",
   CurrentValue = 50,
   Flag = "FlySpeedSliderFlag", 
   Callback = function(Value)
       _G.FlySpeed = Value
   end,
})

-- TOGGLE: NOCLIP
local NoclipToggle = UtilityTab:CreateToggle({
   Name = "Noclip (Pass Through Walls)",
   CurrentValue = false,
   Flag = "NoclipToggleFlag",
   Callback = function(Value)
       _G.NoclipActive = Value
   end,
})

-- TOGGLE: INFINITE JUMP
local InfJumpToggle = UtilityTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Flag = "InfJumpToggleFlag",
   Callback = function(Value)
       _G.InfiniteJumpActive = Value
   end,
})
