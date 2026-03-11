-- ==========================================
-- NOXVA UI ENGINE | FINAL PREMIUM BUILD V2
-- ==========================================
local NoxvaLib = {}
NoxvaLib.Flags = {} -- Tempat nyimpen data Config

function NoxvaLib:CreateWindow()
    local CoreGui = game:GetService("CoreGui")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local StatsService = game:GetService("Stats")
    local TweenService = game:GetService("TweenService")
    local HttpService = game:GetService("HttpService")

    if gethui then
        if gethui():FindFirstChild("NoxvaHub_Pure") then gethui().NoxvaHub_Pure:Destroy() end
    else
        if CoreGui:FindFirstChild("NoxvaHub_Pure") then CoreGui.NoxvaHub_Pure:Destroy() end
    end

    local NoxvaUI = Instance.new("ScreenGui")
    NoxvaUI.Name = "NoxvaHub_Pure"
    NoxvaUI.ResetOnSpawn = false 
    if gethui then NoxvaUI.Parent = gethui() else pcall(function() NoxvaUI.Parent = CoreGui end) end

    local NotifContainer = Instance.new("Frame", NoxvaUI)
    NotifContainer.Name = "NotifContainer"
    NotifContainer.Size = UDim2.new(0, 250, 1, -20)
    NotifContainer.Position = UDim2.new(1, -20, 0, 0)
    NotifContainer.AnchorPoint = Vector2.new(1, 0)
    NotifContainer.BackgroundTransparency = 1
    local NotifLayout = Instance.new("UIListLayout", NotifContainer)
    NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
    NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    NotifLayout.Padding = UDim.new(0, 10)

    local OpenLogo = Instance.new("Frame", NoxvaUI)
    OpenLogo.Size = UDim2.new(0, 50, 0, 50)
    OpenLogo.Position = UDim2.new(0.5, -25, 0, 20)
    OpenLogo.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    OpenLogo.BackgroundTransparency = 0.15
    OpenLogo.Visible = false 
    Instance.new("UICorner", OpenLogo).CornerRadius = UDim.new(1, 0)
    
    local LogoStroke = Instance.new("UIStroke", OpenLogo)
    LogoStroke.Color = Color3.fromRGB(0, 120, 255)
    LogoStroke.Thickness = 2
    
    local LogoImage = Instance.new("ImageLabel", OpenLogo)
    LogoImage.Size = UDim2.new(1, 0, 1, 0)
    LogoImage.BackgroundTransparency = 1
    LogoImage.Image = "rbxthumb://type=Asset&id=15648362575&w=150&h=150" 
    Instance.new("UICorner", LogoImage).CornerRadius = UDim.new(1, 0)
    
    local LogoClicker = Instance.new("TextButton", OpenLogo)
    LogoClicker.Size = UDim2.new(1, 0, 1, 0)
    LogoClicker.BackgroundTransparency = 1
    LogoClicker.Text = ""

    local FloatBg = Instance.new("Frame", OpenLogo)
    FloatBg.Position = UDim2.new(0.5, 0, 0, -35)
    FloatBg.AnchorPoint = Vector2.new(0.5, 0)
    FloatBg.Size = UDim2.new(0, 0, 0, 24)
    FloatBg.AutomaticSize = Enum.AutomaticSize.X 
    FloatBg.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    FloatBg.BackgroundTransparency = 0.15
    Instance.new("UICorner", FloatBg).CornerRadius = UDim.new(1, 0)
    
    local FloatStroke = Instance.new("UIStroke", FloatBg)
    FloatStroke.Color = Color3.fromRGB(0, 120, 255)
    FloatStroke.Thickness = 1.5
    local FloatPad = Instance.new("UIPadding", FloatBg)
    FloatPad.PaddingLeft = UDim.new(0, 12); FloatPad.PaddingRight = UDim.new(0, 12)

    local FloatingStats = Instance.new("TextLabel", FloatBg)
    FloatingStats.Size = UDim2.new(0, 0, 1, 0)
    FloatingStats.AutomaticSize = Enum.AutomaticSize.X
    FloatingStats.BackgroundTransparency = 1
    FloatingStats.TextColor3 = Color3.fromRGB(0, 255, 150)
    FloatingStats.Font = Enum.Font.GothamBold
    FloatingStats.TextSize = 11

    local MainFrame = Instance.new("Frame", NoxvaUI)
    MainFrame.Size = UDim2.new(0, 500, 0, 350)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    MainFrame.BackgroundTransparency = 0.15 
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
    local MainStroke = Instance.new("UIStroke", MainFrame)
    MainStroke.Color = Color3.fromRGB(40, 40, 40)
    MainStroke.Thickness = 1

    local TopBar = Instance.new("Frame", MainFrame)
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    TopBar.BackgroundTransparency = 0.15
    Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 8)
    
    local TopBarBlocker = Instance.new("Frame", TopBar)
    TopBarBlocker.Size = UDim2.new(1, 0, 0, 10)
    TopBarBlocker.Position = UDim2.new(0, 0, 1, -10)
    TopBarBlocker.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    TopBarBlocker.BackgroundTransparency = 0.15
    TopBarBlocker.BorderSizePixel = 0

    local TitleLabel = Instance.new("TextLabel", TopBar)
    TitleLabel.Size = UDim2.new(0, 200, 1, 0)
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = "NOXVA HUB | PREMIUM"
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 13
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local TopBarStats = Instance.new("TextLabel", TopBar)
    TopBarStats.Size = UDim2.new(0, 150, 1, 0)
    TopBarStats.Position = UDim2.new(0.5, -75, 0, 0)
    TopBarStats.BackgroundTransparency = 1
    TopBarStats.TextColor3 = Color3.fromRGB(0, 255, 150)
    TopBarStats.Font = Enum.Font.GothamMedium
    TopBarStats.TextSize = 12

    local frames, lastUpdate = 0, tick()
    RunService.RenderStepped:Connect(function()
        frames = frames + 1
        if tick() - lastUpdate >= 1 then
            local currentPing = 0
            pcall(function() currentPing = math.round(StatsService.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
            local statText = "FPS: " .. frames .. " | Ping: " .. currentPing .. "ms"
            TopBarStats.Text = statText; FloatingStats.Text = statText
            frames = 0; lastUpdate = tick()
        end
    end)

    local CloseBtn = Instance.new("TextButton", TopBar)
    CloseBtn.Size = UDim2.new(0, 30, 0, 30); CloseBtn.Position = UDim2.new(1, -35, 0, 5)
    CloseBtn.BackgroundTransparency = 1; CloseBtn.Text = "×"; CloseBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
    CloseBtn.Font = Enum.Font.GothamBold; CloseBtn.TextSize = 20
    CloseBtn.MouseButton1Click:Connect(function() NoxvaUI:Destroy() end)

    local MinBtn = Instance.new("TextButton", TopBar)
    MinBtn.Size = UDim2.new(0, 30, 0, 30); MinBtn.Position = UDim2.new(1, -70, 0, 5)
    MinBtn.BackgroundTransparency = 1; MinBtn.Text = "-"; MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinBtn.Font = Enum.Font.GothamBold; MinBtn.TextSize = 24
    MinBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false; OpenLogo.Visible = true end)
    LogoClicker.MouseButton1Click:Connect(function() MainFrame.Visible = true; OpenLogo.Visible = false end)

    -- [ANIMASI TWEEN BUAT TOMBOL BIAR PREMIUM]
    local function AddRipple(button)
        button.MouseButton1Down:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.15), {TextTransparency = 0.5}):Play()
        end)
        button.MouseButton1Up:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.15), {TextTransparency = 0}):Play()
        end)
        button.MouseLeave:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.15), {TextTransparency = 0}):Play()
        end)
    end

    local function MakeDraggable(UIElement, DragHandle)
        local dragging, dragInput, dragStart, startPos
        DragHandle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true; dragStart = input.Position; startPos = UIElement.Position
                input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
            end
        end)
        DragHandle.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                UIElement.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end
    MakeDraggable(MainFrame, TopBar)
    MakeDraggable(OpenLogo, LogoClicker)

    local Sidebar = Instance.new("Frame", MainFrame)
    Sidebar.Size = UDim2.new(0, 130, 1, -40); Sidebar.Position = UDim2.new(0, 0, 0, 40)
    Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 20); Sidebar.BackgroundTransparency = 0.2
    Sidebar.BorderSizePixel = 0
    local SidebarLayout = Instance.new("UIListLayout", Sidebar)
    SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder; SidebarLayout.Padding = UDim.new(0, 5)

    local ContentArea = Instance.new("Frame", MainFrame)
    ContentArea.Size = UDim2.new(1, -130, 1, -40); ContentArea.Position = UDim2.new(0, 130, 0, 40)
    ContentArea.BackgroundTransparency = 1

    local WindowFunctions = {}
    local FirstTab = true

    function WindowFunctions:Notify(Title, Text, Duration)
        local NotifFrame = Instance.new("Frame", NotifContainer)
        NotifFrame.Size = UDim2.new(1, 0, 0, 60)
        NotifFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25); NotifFrame.BackgroundTransparency = 0.1
        NotifFrame.Position = UDim2.new(1, 300, 0, 0)
        Instance.new("UICorner", NotifFrame).CornerRadius = UDim.new(0, 5)
        local NStroke = Instance.new("UIStroke", NotifFrame)
        NStroke.Color = Color3.fromRGB(0, 120, 255); NStroke.Thickness = 1.5

        local NotifTitle = Instance.new("TextLabel", NotifFrame)
        NotifTitle.Size = UDim2.new(1, -20, 0, 20); NotifTitle.Position = UDim2.new(0, 10, 0, 5)
        NotifTitle.BackgroundTransparency = 1; NotifTitle.Text = Title
        NotifTitle.TextColor3 = Color3.fromRGB(0, 120, 255); NotifTitle.Font = Enum.Font.GothamBold
        NotifTitle.TextSize = 13; NotifTitle.TextXAlignment = Enum.TextXAlignment.Left

        local NotifDesc = Instance.new("TextLabel", NotifFrame)
        NotifDesc.Size = UDim2.new(1, -20, 0, 30); NotifDesc.Position = UDim2.new(0, 10, 0, 25)
        NotifDesc.BackgroundTransparency = 1; NotifDesc.Text = Text
        NotifDesc.TextColor3 = Color3.fromRGB(200, 200, 200); NotifDesc.Font = Enum.Font.GothamSemibold
        NotifDesc.TextSize = 12; NotifDesc.TextXAlignment = Enum.TextXAlignment.Left; NotifDesc.TextWrapped = true

        TweenService:Create(NotifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()
        task.delay(Duration or 3, function()
            local fadeOut = TweenService:Create(NotifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position = UDim2.new(1, 300, 0, 0)})
            fadeOut:Play()
            fadeOut.Completed:Connect(function() NotifFrame:Destroy() end)
        end)
    end

    function WindowFunctions:MakeTab(TabName)
        local TabBtn = Instance.new("TextButton", Sidebar)
        TabBtn.Size = UDim2.new(1, 0, 0, 35); TabBtn.BackgroundTransparency = 1
        TabBtn.Text = TabName; TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabBtn.Font = Enum.Font.GothamBold; TabBtn.TextSize = 13
        TabBtn.BorderSizePixel = 0; TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UIPadding", TabBtn).PaddingLeft = UDim.new(0, 15)

        local TabPage = Instance.new("ScrollingFrame", ContentArea)
        TabPage.Size = UDim2.new(1, -20, 1, -20); TabPage.Position = UDim2.new(0, 10, 0, 10)
        TabPage.BackgroundTransparency = 1; TabPage.ScrollBarThickness = 0 
        TabPage.Visible = FirstTab; TabPage.BorderSizePixel = 0

        if FirstTab then TabBtn.TextColor3 = Color3.fromRGB(0, 120, 255); FirstTab = false end

        local PageLayout = Instance.new("UIListLayout", TabPage)
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder; PageLayout.Padding = UDim.new(0, 6)
        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabPage.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 10)
        end)

        TabBtn.MouseButton1Click:Connect(function()
            for _, child in pairs(ContentArea:GetChildren()) do if child:IsA("ScrollingFrame") then child.Visible = false end end
            for _, child in pairs(Sidebar:GetChildren()) do if child:IsA("TextButton") then child.TextColor3 = Color3.fromRGB(150, 150, 150) end end
            TabPage.Visible = true; TabBtn.TextColor3 = Color3.fromRGB(0, 120, 255)
        end)

        local TabFunctions = {}

        function TabFunctions:AddLabel(TextContent)
            local LblFrame = Instance.new("Frame", TabPage)
            LblFrame.Size = UDim2.new(1, 0, 0, 0); LblFrame.AutomaticSize = Enum.AutomaticSize.Y
            LblFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25); LblFrame.BackgroundTransparency = 0.2
            Instance.new("UICorner", LblFrame).CornerRadius = UDim.new(0, 5)

            local LblText = Instance.new("TextLabel", LblFrame)
            LblText.Size = UDim2.new(1, 0, 0, 0); LblText.AutomaticSize = Enum.AutomaticSize.Y
            LblText.BackgroundTransparency = 1; LblText.Text = TextContent
            LblText.TextColor3 = Color3.fromRGB(220, 220, 220); LblText.Font = Enum.Font.GothamSemibold
            LblText.TextSize = 12; LblText.TextWrapped = true
            LblText.TextXAlignment = Enum.TextXAlignment.Left; LblText.TextYAlignment = Enum.TextYAlignment.Top
            local Pad = Instance.new("UIPadding", LblText)
            Pad.PaddingLeft = UDim.new(0, 15); Pad.PaddingRight = UDim.new(0, 15); Pad.PaddingTop = UDim.new(0, 10); Pad.PaddingBottom = UDim.new(0, 10)
            
            local LabelItem = {}
            function LabelItem:SetText(newText) LblText.Text = newText end
            return LabelItem
        end

        function TabFunctions:AddButton(BtnText, Callback)
            local BtnFrame = Instance.new("Frame", TabPage)
            BtnFrame.Size = UDim2.new(1, 0, 0, 35)
            BtnFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35); BtnFrame.BackgroundTransparency = 0.2
            Instance.new("UICorner", BtnFrame).CornerRadius = UDim.new(0, 5)
            local Btn = Instance.new("TextButton", BtnFrame)
            Btn.Size = UDim2.new(1, 0, 1, 0); Btn.BackgroundTransparency = 1; Btn.Text = BtnText; Btn.TextColor3 = Color3.fromRGB(230, 230, 230)
            Btn.Font = Enum.Font.GothamSemibold; Btn.TextSize = 13; Btn.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UIPadding", Btn).PaddingLeft = UDim.new(0, 15)
            AddRipple(Btn)
            Btn.MouseButton1Click:Connect(function() Callback() end)
        end

        function TabFunctions:AddDoubleButton(Btn1Text, Btn1Callback, Btn2Text, Btn2Callback)
            local Container = Instance.new("Frame", TabPage)
            Container.Size = UDim2.new(1, 0, 0, 35)
            Container.BackgroundTransparency = 1

            local Btn1Frame = Instance.new("Frame", Container)
            Btn1Frame.Size = UDim2.new(0.5, -3, 1, 0)
            Btn1Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            Btn1Frame.BackgroundTransparency = 0.2
            Instance.new("UICorner", Btn1Frame).CornerRadius = UDim.new(0, 5)

            local Btn1 = Instance.new("TextButton", Btn1Frame)
            Btn1.Size = UDim2.new(1, 0, 1, 0)
            Btn1.BackgroundTransparency = 1
            Btn1.Text = Btn1Text
            Btn1.TextColor3 = Color3.fromRGB(230, 230, 230)
            Btn1.Font = Enum.Font.GothamSemibold
            Btn1.TextSize = 13
            AddRipple(Btn1)
            Btn1.MouseButton1Click:Connect(function() Btn1Callback() end)

            local Btn2Frame = Instance.new("Frame", Container)
            Btn2Frame.Size = UDim2.new(0.5, -3, 1, 0)
            Btn2Frame.Position = UDim2.new(0.5, 3, 0, 0)
            Btn2Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            Btn2Frame.BackgroundTransparency = 0.2
            Instance.new("UICorner", Btn2Frame).CornerRadius = UDim.new(0, 5)

            local Btn2 = Instance.new("TextButton", Btn2Frame)
            Btn2.Size = UDim2.new(1, 0, 1, 0)
            Btn2.BackgroundTransparency = 1
            Btn2.Text = Btn2Text
            Btn2.TextColor3 = Color3.fromRGB(230, 230, 230)
            Btn2.Font = Enum.Font.GothamSemibold
            Btn2.TextSize = 13
            AddRipple(Btn2)
            Btn2.MouseButton1Click:Connect(function() Btn2Callback() end)
        end

        function TabFunctions:AddToggle(ToggleText, Default, Callback, Flag)
            local State = Default or false
            if Flag and NoxvaLib.Flags[Flag] ~= nil then State = NoxvaLib.Flags[Flag].Value end
            
            local TglFrame = Instance.new("Frame", TabPage)
            TglFrame.Size = UDim2.new(1, 0, 0, 35); TglFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35); TglFrame.BackgroundTransparency = 0.2
            Instance.new("UICorner", TglFrame).CornerRadius = UDim.new(0, 5)
            local ToggleBtn = Instance.new("TextButton", TglFrame)
            ToggleBtn.Size = UDim2.new(1, 0, 1, 0); ToggleBtn.BackgroundTransparency = 1
            ToggleBtn.Text = ToggleText .. "   |   " .. (State and "ON" or "OFF")
            ToggleBtn.TextColor3 = State and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(230, 230, 230)
            ToggleBtn.Font = Enum.Font.GothamSemibold; ToggleBtn.TextSize = 13; ToggleBtn.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UIPadding", ToggleBtn).PaddingLeft = UDim.new(0, 15)
            AddRipple(ToggleBtn)
            
            if Flag then NoxvaLib.Flags[Flag] = {Value = State, Func = Callback} end
            if State then Callback(State) end
            
            ToggleBtn.MouseButton1Click:Connect(function()
                State = not State; ToggleBtn.Text = ToggleText .. "   |   " .. (State and "ON" or "OFF")
                ToggleBtn.TextColor3 = State and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(230, 230, 230); Callback(State)
                if Flag then NoxvaLib.Flags[Flag].Value = State end
            end)
        end

        -- [NEW FEATURE] SLIDER DI TAB UTAMA
        function TabFunctions:AddSlider(txt, min, max, def, Callback, Flag)
            local val = def or min
            if Flag and NoxvaLib.Flags[Flag] ~= nil then val = NoxvaLib.Flags[Flag].Value end

            local ctn = Instance.new("Frame", TabPage); ctn.Size = UDim2.new(1, 0, 0, 50); ctn.BackgroundColor3 = Color3.fromRGB(35, 35, 35); ctn.BackgroundTransparency = 0.2; Instance.new("UICorner", ctn).CornerRadius = UDim.new(0, 5)
            local lbl = Instance.new("TextLabel", ctn); lbl.Size = UDim2.new(1, -30, 0, 20); lbl.Position = UDim2.new(0, 15, 0, 5); lbl.BackgroundTransparency = 1; lbl.Text = txt .. " : " .. tostring(val); lbl.TextColor3 = Color3.fromRGB(230, 230, 230); lbl.Font = Enum.Font.GothamSemibold; lbl.TextSize = 12; lbl.TextXAlignment = Enum.TextXAlignment.Left
            local bg = Instance.new("TextButton", ctn); bg.Size = UDim2.new(1, -30, 0, 6); bg.Position = UDim2.new(0, 15, 0, 32); bg.BackgroundColor3 = Color3.fromRGB(20, 20, 20); bg.Text = ""; Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)
            local fl = Instance.new("Frame", bg); fl.Size = UDim2.new((val - min)/(max - min), 0, 1, 0); fl.BackgroundColor3 = Color3.fromRGB(0, 120, 255); Instance.new("UICorner", fl).CornerRadius = UDim.new(1, 0)
            
            if Flag then NoxvaLib.Flags[Flag] = {Value = val, Func = Callback} end
            local d = false
            local function upd(i) 
                local p = math.clamp((i.Position.X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1)
                val = math.floor(min + (max - min) * p); fl.Size = UDim2.new(p, 0, 1, 0); lbl.Text = txt .. " : " .. tostring(val)
                if Flag then NoxvaLib.Flags[Flag].Value = val end
                Callback(val) 
            end
            bg.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then d = true; upd(i) end end)
            UserInputService.InputChanged:Connect(function(i) if d and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then upd(i) end end)
            UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then d = false end end)
            Callback(val)
        end

        -- [NEW FEATURE] KEYBIND SYSTEM
        function TabFunctions:AddKeybind(BindText, DefaultKey, Callback)
            local key = DefaultKey or Enum.KeyCode.E
            local BindFrame = Instance.new("Frame", TabPage)
            BindFrame.Size = UDim2.new(1, 0, 0, 35); BindFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35); BindFrame.BackgroundTransparency = 0.2
            Instance.new("UICorner", BindFrame).CornerRadius = UDim.new(0, 5)
            
            local BindLabel = Instance.new("TextLabel", BindFrame)
            BindLabel.Size = UDim2.new(0.5, 0, 1, 0); BindLabel.Position = UDim2.new(0, 15, 0, 0); BindLabel.BackgroundTransparency = 1
            BindLabel.Text = BindText; BindLabel.TextColor3 = Color3.fromRGB(230, 230, 230); BindLabel.Font = Enum.Font.GothamSemibold; BindLabel.TextSize = 13; BindLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            local BindBtn = Instance.new("TextButton", BindFrame)
            BindBtn.Size = UDim2.new(0, 80, 0, 25); BindBtn.Position = UDim2.new(1, -95, 0, 5); BindBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            BindBtn.Text = key.Name; BindBtn.TextColor3 = Color3.fromRGB(0, 120, 255); BindBtn.Font = Enum.Font.GothamBold; BindBtn.TextSize = 12
            Instance.new("UICorner", BindBtn).CornerRadius = UDim.new(0, 5)
            
            local isBinding = false
            BindBtn.MouseButton1Click:Connect(function()
                BindBtn.Text = "..."; isBinding = true
            end)
            
            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if isBinding and input.UserInputType == Enum.UserInputType.Keyboard then
                    key = input.KeyCode; BindBtn.Text = key.Name; isBinding = false
                elseif not gameProcessed and input.KeyCode == key and not isBinding then
                    Callback()
                end
            end)
        end

        function TabFunctions:AddDropdown(DropText, Options, Callback, Flag)
            local selected = Options[1]
            if Flag and NoxvaLib.Flags[Flag] ~= nil then selected = NoxvaLib.Flags[Flag].Value end

            local DropdownFrame = Instance.new("Frame", TabPage)
            DropdownFrame.Size = UDim2.new(1, 0, 0, 35); DropdownFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35); DropdownFrame.BackgroundTransparency = 0.2; DropdownFrame.ClipsDescendants = true
            Instance.new("UICorner", DropdownFrame).CornerRadius = UDim.new(0, 5)
            local DropButton = Instance.new("TextButton", DropdownFrame)
            DropButton.Size = UDim2.new(1, 0, 0, 35); DropButton.BackgroundTransparency = 1; DropButton.Text = DropText .. " :  " .. tostring(selected or ""); DropButton.TextColor3 = Color3.fromRGB(230, 230, 230); DropButton.Font = Enum.Font.GothamSemibold; DropButton.TextSize = 13; DropButton.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UIPadding", DropButton).PaddingLeft = UDim.new(0, 15)
            AddRipple(DropButton)

            local DropContainer = Instance.new("ScrollingFrame", DropdownFrame)
            DropContainer.Size = UDim2.new(1, 0, 1, -35); DropContainer.Position = UDim2.new(0, 0, 0, 35); DropContainer.BackgroundTransparency = 1; DropContainer.ScrollBarThickness = 0
            Instance.new("UIListLayout", DropContainer).SortOrder = Enum.SortOrder.LayoutOrder

            if Flag then NoxvaLib.Flags[Flag] = {Value = selected, Func = Callback} end

            local isOpen = false
            DropButton.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                if isOpen then
                    local h = 35 + (#Options * 30); if h > 150 then h = 150 end
                    DropdownFrame.Size = UDim2.new(1, 0, 0, h); DropContainer.CanvasSize = UDim2.new(0, 0, 0, #Options * 30)
                else DropdownFrame.Size = UDim2.new(1, 0, 0, 35) end
            end)

            for _, option in ipairs(Options) do
                local OptBtn = Instance.new("TextButton", DropContainer)
                OptBtn.Size = UDim2.new(1, 0, 0, 30); OptBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45); OptBtn.BackgroundTransparency = 0.5; OptBtn.Text = tostring(option); OptBtn.TextColor3 = Color3.fromRGB(200, 200, 200); OptBtn.Font = Enum.Font.Gotham; OptBtn.TextSize = 13; OptBtn.BorderSizePixel = 0; OptBtn.TextXAlignment = Enum.TextXAlignment.Left
                Instance.new("UIPadding", OptBtn).PaddingLeft = UDim.new(0, 25)
                AddRipple(OptBtn)
                OptBtn.MouseButton1Click:Connect(function()
                    DropButton.Text = DropText .. " :  " .. tostring(option)
                    isOpen = false; DropdownFrame.Size = UDim2.new(1, 0, 0, 35)
                    if Flag then NoxvaLib.Flags[Flag].Value = option end
                    Callback(option)
                end)
            end
            if selected then Callback(selected) end
        end

        function TabFunctions:AddTextbox(BoxText, Placeholder, Callback, Flag)
            local val = ""
            if Flag and NoxvaLib.Flags[Flag] ~= nil then val = NoxvaLib.Flags[Flag].Value end

            local BoxFrame = Instance.new("Frame", TabPage)
            BoxFrame.Size = UDim2.new(1, 0, 0, 40); BoxFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35); BoxFrame.BackgroundTransparency = 0.2
            Instance.new("UICorner", BoxFrame).CornerRadius = UDim.new(0, 5)
            local BoxLabel = Instance.new("TextLabel", BoxFrame)
            BoxLabel.Size = UDim2.new(0.4, 0, 1, 0); BoxLabel.Position = UDim2.new(0, 15, 0, 0); BoxLabel.BackgroundTransparency = 1; BoxLabel.Text = BoxText; BoxLabel.TextColor3 = Color3.fromRGB(230, 230, 230); BoxLabel.Font = Enum.Font.GothamSemibold; BoxLabel.TextSize = 13; BoxLabel.TextXAlignment = Enum.TextXAlignment.Left
            local TextBox = Instance.new("TextBox", BoxFrame)
            TextBox.Size = UDim2.new(0.55, -20, 0, 28); TextBox.Position = UDim2.new(0.45, 5, 0, 6); TextBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20); TextBox.PlaceholderText = Placeholder; TextBox.Text = val; TextBox.TextColor3 = Color3.fromRGB(255, 255, 255); TextBox.Font = Enum.Font.Gotham; TextBox.TextSize = 12
            Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 5)
            
            if Flag then NoxvaLib.Flags[Flag] = {Value = val, Func = Callback} end
            if val ~= "" then Callback(val) end

            TextBox.FocusLost:Connect(function() 
                if Flag then NoxvaLib.Flags[Flag].Value = TextBox.Text end
                Callback(TextBox.Text) 
            end)
        end

        function TabFunctions:AddFolder(TitleText)
            local FolderFrame = Instance.new("Frame", TabPage)
            FolderFrame.Size = UDim2.new(1, 0, 0, 35); FolderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30); FolderFrame.BackgroundTransparency = 0.2; FolderFrame.ClipsDescendants = true
            Instance.new("UICorner", FolderFrame).CornerRadius = UDim.new(0, 5)

            local FolderBtn = Instance.new("TextButton", FolderFrame)
            FolderBtn.Size = UDim2.new(1, 0, 0, 35); FolderBtn.BackgroundTransparency = 1; FolderBtn.Text = TitleText .. "   ▼"; FolderBtn.TextColor3 = Color3.fromRGB(255, 255, 255); FolderBtn.Font = Enum.Font.GothamBold; FolderBtn.TextSize = 13; FolderBtn.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UIPadding", FolderBtn).PaddingLeft = UDim.new(0, 15)
            AddRipple(FolderBtn)

            local ItemContainer = Instance.new("Frame", FolderFrame)
            ItemContainer.Size = UDim2.new(1, 0, 1, -35); ItemContainer.Position = UDim2.new(0, 0, 0, 35); ItemContainer.BackgroundTransparency = 1
            local ItemLayout = Instance.new("UIListLayout", ItemContainer)
            ItemLayout.SortOrder = Enum.SortOrder.LayoutOrder; ItemLayout.Padding = UDim.new(0, 5)
            local CPad = Instance.new("UIPadding", ItemContainer); CPad.PaddingTop = UDim.new(0, 5); CPad.PaddingBottom = UDim.new(0, 5)

            local isOpen = false
            FolderBtn.MouseButton1Click:Connect(function()
                isOpen = not isOpen; FolderBtn.Text = TitleText .. (isOpen and "   ▲" or "   ▼")
                if isOpen then FolderFrame.Size = UDim2.new(1, 0, 0, 35 + ItemLayout.AbsoluteContentSize.Y + 10) else FolderFrame.Size = UDim2.new(1, 0, 0, 35) end
            end)
            ItemLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                if isOpen then FolderFrame.Size = UDim2.new(1, 0, 0, 35 + ItemLayout.AbsoluteContentSize.Y + 10) end
            end)

            -- FUNGSI DI DALAM FOLDER TETAP AMAN TIDAK ADA YANG DIHAPUS
            local FolderFuncs = {}
            function FolderFuncs:AddLabel(txt)
                local LblFrame = Instance.new("Frame", ItemContainer); LblFrame.Size = UDim2.new(1, -20, 0, 0); LblFrame.AutomaticSize = Enum.AutomaticSize.Y; LblFrame.Position = UDim2.new(0, 10, 0, 0); LblFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40); LblFrame.BackgroundTransparency = 0.8; Instance.new("UICorner", LblFrame).CornerRadius = UDim.new(0, 5)
                local LblText = Instance.new("TextLabel", LblFrame); LblText.Size = UDim2.new(1, 0, 0, 0); LblText.AutomaticSize = Enum.AutomaticSize.Y; LblText.BackgroundTransparency = 1; LblText.Text = txt; LblText.TextColor3 = Color3.fromRGB(200, 200, 200); LblText.Font = Enum.Font.GothamSemibold; LblText.TextSize = 11; LblText.TextWrapped = true; LblText.TextXAlignment = Enum.TextXAlignment.Left
                local LPad = Instance.new("UIPadding", LblText); LPad.PaddingLeft = UDim.new(0, 15); LPad.PaddingRight = UDim.new(0, 15); LPad.PaddingTop = UDim.new(0, 8); LPad.PaddingBottom = UDim.new(0, 8)
                local LItem = {}; function LItem:SetText(t) LblText.Text = t end; return LItem
            end
            function FolderFuncs:AddToggle(txt, def, cb, flag)
                local s = def or false; if flag and NoxvaLib.Flags[flag] ~= nil then s = NoxvaLib.Flags[flag].Value end
                local frm = Instance.new("Frame", ItemContainer); frm.Size = UDim2.new(1, -20, 0, 35); frm.Position = UDim2.new(0, 10, 0, 0); frm.BackgroundColor3 = Color3.fromRGB(40, 40, 40); frm.BackgroundTransparency = 0.5; Instance.new("UICorner", frm).CornerRadius = UDim.new(0, 5)
                local btn = Instance.new("TextButton", frm); btn.Size = UDim2.new(1, 0, 1, 0); btn.BackgroundTransparency = 1; btn.Text = txt .. "   |   " .. (s and "ON" or "OFF"); btn.TextColor3 = s and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(230, 230, 230); btn.Font = Enum.Font.GothamSemibold; btn.TextSize = 13; btn.TextXAlignment = Enum.TextXAlignment.Left; Instance.new("UIPadding", btn).PaddingLeft = UDim.new(0, 15)
                AddRipple(btn)
                if flag then NoxvaLib.Flags[flag] = {Value = s, Func = cb} end
                if s then cb(s) end; btn.MouseButton1Click:Connect(function() s = not s; btn.Text = txt .. "   |   " .. (s and "ON" or "OFF"); btn.TextColor3 = s and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(230, 230, 230); if flag then NoxvaLib.Flags[flag].Value = s end; cb(s) end)
            end
            function FolderFuncs:AddButton(txt, cb)
                local frm = Instance.new("Frame", ItemContainer); frm.Size = UDim2.new(1, -20, 0, 35); frm.Position = UDim2.new(0, 10, 0, 0); frm.BackgroundColor3 = Color3.fromRGB(40, 40, 40); frm.BackgroundTransparency = 0.5; Instance.new("UICorner", frm).CornerRadius = UDim.new(0, 5)
                local btn = Instance.new("TextButton", frm); btn.Size = UDim2.new(1, 0, 1, 0); btn.BackgroundTransparency = 1; btn.Text = txt; btn.TextColor3 = Color3.fromRGB(230, 230, 230); btn.Font = Enum.Font.GothamSemibold; btn.TextSize = 13; btn.TextXAlignment = Enum.TextXAlignment.Left; Instance.new("UIPadding", btn).PaddingLeft = UDim.new(0, 15)
                AddRipple(btn); btn.MouseButton1Click:Connect(function() cb() end)
            end
            function FolderFuncs:AddSlider(txt, min, max, def, cb, flag)
                local val = def or min; if flag and NoxvaLib.Flags[flag] ~= nil then val = NoxvaLib.Flags[flag].Value end
                local ctn = Instance.new("Frame", ItemContainer); ctn.Size = UDim2.new(1, -20, 0, 50); ctn.Position = UDim2.new(0, 10, 0, 0); ctn.BackgroundColor3 = Color3.fromRGB(40, 40, 40); ctn.BackgroundTransparency = 0.5; Instance.new("UICorner", ctn).CornerRadius = UDim.new(0, 5)
                local lbl = Instance.new("TextLabel", ctn); lbl.Size = UDim2.new(1, -30, 0, 20); lbl.Position = UDim2.new(0, 15, 0, 5); lbl.BackgroundTransparency = 1; lbl.Text = txt .. " : " .. tostring(val); lbl.TextColor3 = Color3.fromRGB(230, 230, 230); lbl.Font = Enum.Font.GothamSemibold; lbl.TextSize = 12; lbl.TextXAlignment = Enum.TextXAlignment.Left
                local bg = Instance.new("TextButton", ctn); bg.Size = UDim2.new(1, -30, 0, 6); bg.Position = UDim2.new(0, 15, 0, 32); bg.BackgroundColor3 = Color3.fromRGB(20, 20, 20); bg.Text = ""; Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)
                local fl = Instance.new("Frame", bg); fl.Size = UDim2.new((val - min)/(max - min), 0, 1, 0); fl.BackgroundColor3 = Color3.fromRGB(0, 120, 255); Instance.new("UICorner", fl).CornerRadius = UDim.new(1, 0)
                if flag then NoxvaLib.Flags[flag] = {Value = val, Func = cb} end
                local d = false; local function upd(i) local p = math.clamp((i.Position.X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1); val = math.floor(min + (max - min) * p); fl.Size = UDim2.new(p, 0, 1, 0); lbl.Text = txt .. " : " .. tostring(val); if flag then NoxvaLib.Flags[flag].Value = val end; cb(val) end
                bg.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then d = true; upd(i) end end)
                UserInputService.InputChanged:Connect(function(i) if d and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then upd(i) end end)
                UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then d = false end end)
                cb(val)
            end
            return FolderFuncs
        end

        return TabFunctions
    end

    -- [NEW FEATURE] AUTO CONFIG SYSTEM TAB
    function WindowFunctions:MakeConfigTab()
        local ConfTab = WindowFunctions:MakeTab("⚙️ Settings")
        local ConfFolder = ConfTab:AddFolder("Configuration")
        
        ConfFolder:AddButton("Save Settings", function()
            local dataToSave = {}
            for flagName, data in pairs(NoxvaLib.Flags) do dataToSave[flagName] = data.Value end
            local success, json = pcall(function() return HttpService:JSONEncode(dataToSave) end)
            if success and writefile then
                writefile("NoxvaHub_Config.json", json)
                WindowFunctions:Notify("CONFIG", "Settings Saved Successfully!", 3)
            else
                WindowFunctions:Notify("ERROR", "Executor does not support writefile!", 3)
            end
        end)
        
        ConfFolder:AddButton("Load Settings", function()
            if readfile and isfile and isfile("NoxvaHub_Config.json") then
                local success, json = pcall(function() return readfile("NoxvaHub_Config.json") end)
                if success then
                    local data = HttpService:JSONDecode(json)
                    for flagName, value in pairs(data) do
                        if NoxvaLib.Flags[flagName] then
                            NoxvaLib.Flags[flagName].Value = value
                            -- Update UI and Logic implicitly by recalling the function (Requires executor re-run or dynamic update)
                            -- Note: Realtime UI update for loaded config needs manual re-execution for simplicity in this build
                        end
                    end
                    WindowFunctions:Notify("CONFIG", "Settings Loaded! Please re-execute script to apply.", 4)
                end
            else
                WindowFunctions:Notify("ERROR", "No config file found!", 3)
            end
        end)
    end

    WindowFunctions:Notify("NOXVA HUB", "Premium Engine Loaded! Welcome.", 4)
    return WindowFunctions
end

return NoxvaLib
