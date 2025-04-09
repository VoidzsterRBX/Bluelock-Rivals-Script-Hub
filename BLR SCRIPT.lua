--getgenv().cancel_when_already_injected = false

if getrenv().Void_BLR_Script_Executed ~= false then
   warn("Script already executed on roblox instance.")
   --if getgenv().cancel_when_already_injected == true then
      warn("Stopping Script")
      return
   --end
end
pcall(function()
   getrenv().Void_BLR_Script_Executed = true
end)

local player = game.Players.LocalPlayer

local function getCharacter()
   local char = player.Character
   local hrp = char.HumanoidRootPart
   local hum = char.Humanoid
   return char,hrp,hum
end

local __char,__hrp,__hum = getCharacter()

local team = "Home"
local ball
local ballowner
local headering

--PLAYER STATS
getgenv()._player_speed = __hum.WalkSpeed
getgenv()._player_jump = __hum.JumpPower

--MAGNUS
getgenv()._magnus = false
getgenv()._magnus_speed = 500

--AUTOSCORE

--HITBOX
getgenv()._hitbox = false
getgenv()._hitbox_size = 4.93666

--VISUAL HITBOX
getgenv()._visual_hitbox = false
getgenv()._visual_hitbox_color = Color3.fromRGB(255,0,0)

--

local rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

task.spawn(function()
   while task.wait(5) do
      for i,v in pairs(workspace:GetDescendants()) do
         if v.Name == "Football" and v:IsA("MeshPart") then
            ball = v
         end
      end
   end
end)

--CONFIG


-- RAYFIELD --

local window = rayfield:CreateWindow({
   Name = "Blue Lock Rivals Script",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "blue lock",
   LoadingSubtitle = "void",
   Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = "VoidzsterScripts", -- Create a custom folder for your hub/game
      FileName = "Blue Lock Rivals Script"
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

--WELCOME
local welcome_tab = window:CreateTab("Welcome", "grid-2x2") -- Title, Image
local dropdown = welcome_tab:CreateDropdown({
   Name = "Current Team",
   Options = {"Home (Blue)","Away (White)"},
   CurrentOption = {"Home (Blue)"},
   MultipleOptions = false,
   Flag = "TeamDropDown",
   Callback = function(Options)
      warn(Options[1])
      if Options[1] == "Home (Blue)" then
         team = "Home"
      else
         team = "Away"
      end
   end,
})

local killswitch_divider = welcome_tab:CreateDivider()
local killswitch_section = welcome_tab:CreateSection("Kill Switch")
local killswitch = welcome_tab:CreateButton({
   Name = "Kill Switch",
   Callback = function()
      rayfield:Destroy()
   end,
})
local killswitch_label = welcome_tab:CreateLabel("Use kill switch if executing script again.", "skull") -- Title, Icon, Color, IgnoreTheme

--PLAYER
local player_tab = window:CreateTab("Player", "user") -- Title, Image

local playerstats_section = player_tab:CreateSection("Player Info")
local playerstats_label = player_tab:CreateLabel("IF SCRIPT IS EXECUTED TWICE CHANGING THESE SLIDERS WILL CRASH THE GAME.", "file-warning",Color3.fromRGB(255,0,0)) -- Title, Icon, Color, IgnoreTheme
local playerstats_walkspeed_slider = player_tab:CreateSlider({
   Name = "Speed",
   Range = {0, 65},
   Increment = 0.5,
   Suffix = "Walkspeed",
   CurrentValue = 10,
   Flag = "WalkSpeedSlider",
   Callback = function(Value)
      local char,hrp,hum = getCharacter()
      getgenv()._player_speed = Value
      hum.WalkSpeed = _player_speed
      hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function(newval)
         if Value ~= getgenv()._player_speed then return end
         if hum.WalkSpeed == Value then return end
         hum.WalkSpeed = getgenv()._player_speed
      end)
   end,
})
local playerstats_resetwalkspeed_button = player_tab:CreateButton({
   Name = "Reset Walkspeed",
   Callback = function()
      local char,hrp,hum = getCharacter()
      hum.JumpPower += 50
      playerstats_walkspeed_slider:Set(50)
   end,
})

local playerstats_divider = player_tab:CreateDivider()

local playerstats_jumppower_slider = player_tab:CreateSlider({
   Name = "Vert",
   Range = {0, 200},
   Increment = 1,
   Suffix = "Inches",
   CurrentValue = 50,
   Flag = "JumpPowerSlider",
   Callback = function(Value)
      local char,hrp,hum = getCharacter()
      hum.JumpPower = getgenv()._player_jump
      hum:GetPropertyChangedSignal("JumpPower"):Connect(function(newval)
         if Value ~= getgenv()._player_jump then return end
         if hum.JumpPower == Value then return end
         hum.JumpPower = getgenv()._player_jump
      end)
   end,
})

local teleporttoball_section = player_tab:CreateSection("Teleport to ball")
local teleporttoball_label = player_tab:CreateLabel("VERY BUGGY (DON'T USE WHEN FAR FROM BALL)", "file-warning",Color3.fromRGB(255,0,0)) -- Title, Icon, Color, IgnoreTheme
local teleporttoball_keybind = player_tab:CreateKeybind({
   Name = "Teleport to ball",
   CurrentKeybind = "Z",
   HoldToInteract = false,
   Flag = "TeleportToBallKeybind",
   Callback = function(Keybind)
      local char,hrp,hum = getCharacter()
      hrp.Position = ball.Position
   end,
})

--BALL
local ball_tab = window:CreateTab("Ball", "circle") -- Title, Image

   --MAGNUS
local magnusball_section = ball_tab:CreateSection("Magnus Ball")
local magnusball_keybind = ball_tab:CreateKeybind({
   Name = "Keybind",
   CurrentKeybind = "F",
   HoldToInteract = true,
   Flag = "MagnusBallKeybind",
      local char,hrp,hum = getCharacter()
      if Keybind == false then
         getgenv()._magnus = false
      else
         getgenv()._magnus = true
         local camera = workspace.CurrentCamera
         camera.CameraSubject = ball
         local bv = Instance.new("BodyVelocity")
         bv.Parent = ball
         bv.Name = "BallMagnusVelocity"
         bv.MaxForce = Vector3.one * math.huge
         bv.P = 1250
         repeat
            local camera = workspace.CurrentCamera
            local pos = camera.CFrame.LookVector
            bv.Velocity = (pos * (getgenv()._magnus_speed / 10))
            task.wait()
         until getgenv()._magnus == false
         bv:Destroy()
         camera.CameraSubject = hum
         local pos = camera.CFrame.LookVector
         ball.AssemblyLinearVelocity = (pos * (getgenv()._magnus_speed / 10))
      end
   end,
})
local magnusball_slider = ball_tab:CreateSlider({
   Name = "Speed",
   Range = {0, 1000},
   Increment = 5,
   Suffix = "studs/s",
   CurrentValue = _magnus_speed,
   Flag = "MagnusBallSlider",
   Callback = function(Value)
      getgenv()._magnus_speed = Value
   end,
})
local magnusball_divider = ball_tab:CreateDivider()

   --AUTOSCORE
local autoscore_section = ball_tab:CreateSection("Auto Score")
local autoscore_keybind = ball_tab:CreateKeybind({
   Name = "Keybind",
   CurrentKeybind = "G",
   HoldToInteract = false,
   Flag = "AutoScoreKeybind",
   Callback = function(Keybind)
      --[[
      if team == "Home" then
         ball.Position = workspace.Goals.Away.Position
      elseif team == "Away" then
         ball.Position = workspace.Goals.Home.Position
      end
      ==]]-- Above code is reverse for some reason, could be jank from BLR
      ball.Position = workspace.Goals[team].Position -- fuck blr bro ts make no sense
   end,
})

local hitbox_section = ball_tab:CreateSection("Hitbox")
local hitbox_label = player_tab:CreateLabel("CURRENTLY BROKEN (ISN'T REPLICATED TO SERVER)", "file-warning",Color3.fromRGB(255,0,0)) -- Title, Icon, Color, IgnoreTheme
local hitbox_toggle = ball_tab:CreateToggle({
   Name = "Hitbox Extender Enabled",
   CurrentValue = false,
   Flag = "HitboxToggle",
   Callback = function(Value)
      local hitbox = ball.Hitbox
      if Value == true then
         getgenv()._hitbox = true
         hitbox.Size = Vector3.one * getgenv()._hitbox_size
      elseif Value == false then
         hitbox.Size = Vector3.one * 4.93666
      end
   end,
})
local hitbox_slider = ball_tab:CreateSlider({
   Name = "Speed",
   Range = {0, 75},
   Increment = 0.5,
   Suffix = "Studs",
   CurrentValue = _magnus_speed,
   Flag = "HitboxSlider",
   Callback = function(Value)
      local hitbox = ball.Hitbox
      getgenv()._hitbox_size = Value
      hitbox.Size = Vector3.one * getgenv()._hitbox_size
   end,
})
local hitbox_button = ball_tab:CreateButton({
   Name = "Reset Size",
   Callback = function()
      getgenv()._hitbox_size = 4.93666
      hitbox.Size = Vector3.one * getgenv()._hitbox_size
   end,
})

-- VISUAL

local visual_tab = window:CreateTab("Visual", "eye") -- Title, Image
local visual_hitbox_section = visual_tab:CreateSection("Hitbox Visuals")
local visual_hitbox_toggle = visual_tab:CreateToggle({
   Name = "Hitbox Visuals Enabled",
   CurrentValue = false,
   Flag = "VisualHitboxToggle",
   Callback = function(Value)
   local hitbox = ball.Hitbox
      if Value == true then
         hitbox.Transparency = 0
         hitbox.Material = Enum.Material.ForceField
         hitbox.Color = getgenv()._visual_hitbox_color
      elseif Value == false then
         hitbox.Transparency = 1
         hitbox.Material = Enum.Material.Plastic
         hitbox.Color = Color3.fromRGB(163,162,165)
      end
   end,
})
local visual_hitbox_colorpicker = visual_tab:CreateColorPicker({
    Name = "Hitbox Color",
    Color = Color3.fromRGB(255,0,0),
    Flag = "VisualsHitboxColorPicker",
    Callback = function(Value)
        getgenv()._visual_hitbox_color = Value
        hitbox.Color = getgenv()._visual_hitbox_color
    end
})


-- RAYFIELD --

ball.AncestryChanged:Connect(function()
   if ball.Parent == workspace then ballowner = nil else
   ballowner = ball.Parent end
end)

ball.ChildAdded:Connect(function(child)
   if child:IsA("BasePart") and child.Name == "Header" then
      headering = true
      ball.AncestryChanged:Once(function()
         headering = false
       end)
   end
end)

rayfield:LoadConfiguration()
