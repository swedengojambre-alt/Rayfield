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
                          
                          -- 1. DEFINE THE OFFSET HERE
                          local downwardOffset = Vector3.new(0, -5, 0)
                          
                          -- 2. ADD THE OFFSET TO THE ORB'S POSITION HERE
                          root.CFrame = orb.CFrame + downwardOffset
                          
                          task.wait(0.0001)
                          root.CFrame = originalPos
                      end
                  end
                  task.wait(0.0001)
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
