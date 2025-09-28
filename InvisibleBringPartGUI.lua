-- BERLIAN_BRINGPART SUPER MAGNET GLOBAL - GitHub Ready
-- Semua benda ditarik, karakter aman, efek terlihat semua pemain

-- ====== SERVER PART ======
if game:GetService("RunService"):IsServer() then
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local Workspace = game:GetService("Workspace")
    local Debris = game:GetService("Debris")

    local function applyForceToPart(part, centerPos, strength)
        if part.Anchored then
            part.Anchored = false
        end
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(1e14,1e14,1e14)
        bv.Velocity = (centerPos - part.Position).unit * strength
        bv.P = 1e5
        bv.Name = "BERLIAN_PULL_FORCE"
        bv.Parent = part
        Debris:AddItem(bv,0.5)
    end

    RunService.Heartbeat:Connect(function()
        for _,player in pairs(Players:GetPlayers()) do
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local centerPos = char.HumanoidRootPart.Position
                local radius = player:GetAttribute("BERLIAN_RADIUS") or 500
                local strength = player:GetAttribute("BERLIAN_STRENGTH") or 250000
                local active = player:GetAttribute("BERLIAN_ACTIVE")
                if active then
                    for _,obj in pairs(Workspace:GetDescendants()) do
                        if obj:IsA("BasePart") and not obj:IsDescendantOf(char) then
                            local dist = (obj.Position - centerPos).magnitude
                            if dist <= radius then
                                applyForceToPart(obj, centerPos, strength)
                            end
                        end
                    end
                end
            end
        end
    end)
end

-- ====== CLIENT PART ======
if game:GetService("RunService"):IsClient() then
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer

    player:SetAttribute("BERLIAN_RADIUS", 500)
    player:SetAttribute("BERLIAN_STRENGTH", 250000)
    player:SetAttribute("BERLIAN_ACTIVE", false)

    -- GUI
    local gui = Instance.new("ScreenGui")
    gui.Name = "BERLIAN_BRINGPART_PANEL"
    gui.Parent = player:WaitForChild("PlayerGui")

    local panel = Instance.new("Frame")
    panel.Size = UDim2.new(0,250,0,200)
    panel.Position = UDim2.new(0.5,-125,0.3,-100)
    panel.BackgroundColor3 = Color3.fromRGB(20,20,40)
    panel.Active = true
    panel.Draggable = true
    panel.Parent = gui

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1,0,0,30)
    title.BackgroundTransparency = 1
    title.Text = "BERLIAN_BRINGPART"
    title.TextColor3 = Color3.fromRGB(0,200,255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = panel

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0,200,0,40)
    button.Position = UDim2.new(0.5,-100,0.15,0)
    button.BackgroundColor3 = Color3.fromRGB(0,100,255)
    button.TextColor3 = Color3.new(1,1,1)
    button.TextScaled = true
    button.Text = "OFF"
    button.Font = Enum.Font.GothamBold
    button.Parent = panel

    button.MouseButton1Click:Connect(function()
        local active = not player:GetAttribute("BERLIAN_ACTIVE")
        player:SetAttribute("BERLIAN_ACTIVE", active)
        button.Text = active and "ON" or "OFF"
    end)

    -- Radius
    local radiusLabel = Instance.new("TextLabel")
    radiusLabel.Size = UDim2.new(0,100,0,20)
    radiusLabel.Position = UDim2.new(0.05,0,0.35,0)
    radiusLabel.BackgroundTransparency = 1
    radiusLabel.Text = "Radius: 500"
    radiusLabel.TextColor3 = Color3.new(1,1,1)
    radiusLabel.Font = Enum.Font.Gotham
    radiusLabel.TextScaled = true
    radiusLabel.Parent = panel

    local radiusSlider = Instance.new("TextBox")
    radiusSlider.Size = UDim2.new(0,120,0,25)
    radiusSlider.Position = UDim2.new(0.5,0,0.35,0)
    radiusSlider.BackgroundColor3 = Color3.fromRGB(50,50,50)
    radiusSlider.TextColor3 = Color3.new(1,1,1)
    radiusSlider.Text = "500"
    radiusSlider.ClearTextOnFocus = false
    radiusSlider.Font = Enum.Font.Gotham
    radiusSlider.TextScaled = true
    radiusSlider.Parent = panel

    radiusSlider.FocusLost:Connect(function()
        local val = tonumber(radiusSlider.Text)
        if val then
            player:SetAttribute("BERLIAN_RADIUS", val)
            radiusLabel.Text = "Radius: "..val
        end
    end)

    -- Strength
    local strengthLabel = Instance.new("TextLabel")
    strengthLabel.Size = UDim2.new(0,100,0,20)
    strengthLabel.Position = UDim2.new(0.05,0,0.55,0)
    strengthLabel.BackgroundTransparency = 1
    strengthLabel.Text = "Strength: 250000"
    strengthLabel.TextColor3 = Color3.new(1,1,1)
    strengthLabel.Font = Enum.Font.Gotham
    strengthLabel.TextScaled = true
    strengthLabel.Parent = panel

    local strengthSlider = Instance.new("TextBox")
    strengthSlider.Size = UDim2.new(0,120,0,25)
    strengthSlider.Position = UDim2.new(0.5,0,0.55,0)
    strengthSlider.BackgroundColor3 = Color3.fromRGB(50,50,50)
    strengthSlider.TextColor3 = Color3.new(1,1,1)
    strengthSlider.Text = "250000"
    strengthSlider.ClearTextOnFocus = false
    strengthSlider.Font = Enum.Font.Gotham
    strengthSlider.TextScaled = true
    strengthSlider.Parent = panel

    strengthSlider.FocusLost:Connect(function()
        local val = tonumber(strengthSlider.Text)
        if val then
            player:SetAttribute("BERLIAN_STRENGTH", val)
            strengthLabel.Text = "Strength: "..val
        end
    end)
end
