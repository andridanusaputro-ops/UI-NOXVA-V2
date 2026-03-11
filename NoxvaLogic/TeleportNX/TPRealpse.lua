local TPRealpse = {}

function TPRealpse:ToSpot()
    local plr = game.Players.LocalPlayer
    if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        plr.Character.HumanoidRootPart.CFrame = CFrame.new(-112, -2, -1029)
    end
end

return TPRealpse
