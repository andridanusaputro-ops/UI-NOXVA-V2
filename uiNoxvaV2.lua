-- ==========================================
-- NOXVA UI ENGINE | PURE CORE LIBRARY V2.8
-- DEVELOPED BY DANZY 
-- ==========================================
local NoxvaLib = {}
NoxvaLib.Flags = {} 
NoxvaLib.AccentColor = Color3.fromRGB(0, 120, 255)

function NoxvaLib:CreateWindow(CustomName, CustomColor)
    local HubTitle = CustomName or "NOXVA PREMIUM"
    NoxvaLib.AccentColor = CustomColor or NoxvaLib.AccentColor

    local CoreGui = game:GetService("CoreGui")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local StatsService = game:GetService("Stats")
    local TweenService = game:GetService("TweenService")
    local HttpService = game:GetService("HttpService")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    local NoxvaUI = Instance.new("ScreenGui")
    NoxvaUI.Name = "NoxvaHub_Pure"
    NoxvaUI.ResetOnSpawn = false 

    local successHui, hui = pcall(function() return gethui() end)
    local targetParent
    if successHui and hui then
        targetParent = hui
    elseif pcall(function() return CoreGui.Name end) then
        targetParent = CoreGui
    elseif LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui") then
        targetParent = LocalPlayer.PlayerGui
    end

    if targetParent then
        local oldUI = targetParent:FindFirstChild("NoxvaHub_Pure")
        if oldUI then oldUI:Destroy() end
        NoxvaUI.Parent = targetParent
    else
        return nil
    end

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

    -- ==========================================
    -- FPS & PING TRACKER
    -- ==========================================
    local FloatingStats = Instance.new("TextLabel", NoxvaUI)
    FloatingStats.Name = "FPS_Ping_Tracker"
    FloatingStats.Size = UDim2.new(0, 200, 0, 20)
    FloatingStats.Position = UDim2.new(0, 15, 0, 15) 
    FloatingStats.BackgroundTransparency = 1
    FloatingStats.TextColor3 = Color3.fromRGB(255, 255, 255) 
    FloatingStats.Font = Enum.Font.GothamBold
    FloatingStats.TextSize = 12
    FloatingStats.TextXAlignment = Enum.TextXAlignment.Left
    FloatingStats.TextStrokeTransparency = 0.5 

    -- ==========================================
    -- LOGO KOTAK MELENGKUNG SAAT DI-CLOSE
    -- ==========================================
    local OpenLogo = Instance.new("Frame", NoxvaUI)
    OpenLogo.Size = UDim2.new(0, 50, 0, 50) 
    OpenLogo.Position = UDim2.new(0.5, -25, 0, 20)
    OpenLogo.BackgroundColor3 = Color3.fromRGB(15, 15, 15) 
    OpenLogo.BackgroundTransparency = 0.15
    OpenLogo.Visible = false 
    Instance.new("UICorner", OpenLogo).CornerRadius = UDim.new(0, 8) 

    local LogoImage = Instance.new("ImageLabel", OpenLogo)
    LogoImage.Size = UDim2.new(1, 0, 1, 0)
    LogoImage.BackgroundTransparency = 1
    LogoImage.Image = "rbxassetid://125602638236059" 
    LogoImage.ScaleType = Enum.ScaleType.Fit 
    Instance.new("UICorner", LogoImage).CornerRadius = UDim.new(0, 8)

    local LogoClicker = Instance.new("TextButton", OpenLogo)
    LogoClicker.Size = UDim2.new(1, 0, 1, 0)
    LogoClicker.BackgroundTransparency = 1
    LogoClicker.Text = ""

    -- ==========================================
    -- MAIN FRAME
    -- ==========================================
    local MainFrame = Instance.new("Frame", NoxvaUI)
    MainFrame.Size = UDim2.new(0, 480, 0, 310) 
    MainFrame.Position = UDim2.new(0.5, -240, 0.5, -155) 
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
    TitleLabel.Text = HubTitle
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 13
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local TopBarStats = Instance.new("TextLabel", TopBar)
    TopBarStats.Size = UDim2.new(0, 150, 1, 0)
    TopBarStats.Position = UDim2.new(0.5, -75, 0, 0)
    TopBarStats.BackgroundTransparency = 1
    TopBarStats.TextColor3 = NoxvaLib.AccentColor
    TopBarStats.Font = Enum.Font.GothamMedium
    TopBarStats.TextSize = 12

    local frames, lastUpdate = 0, tick()
    local renderConnection
    renderConnection = RunService.RenderStepped:Connect(function()
        if not NoxvaUI or not NoxvaUI.Parent then
            if renderConnection then renderConnection:Disconnect() end
            return
        end
        frames = frames + 1
        if tick() - lastUpdate >= 1 then
            local currentPing = 0
            pcall(function() currentPing = math.round(StatsService.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
            local statText = "FPS: " .. frames .. " | Ping: " .. currentPing .. "ms"
            TopBarStats.Text = statText
            FloatingStats.Text = statText 
            frames = 0; lastUpdate = tick()
        end
    end)

    local function AddRipple(button)
        button.MouseButton1Down:Connect(function() TweenService:Create(button, TweenInfo.new(0.15), {TextTransparency = 0.5}):Play() end)
        button.MouseButton1Up:Connect(function() TweenService:Create(button, TweenInfo.new(0.15), {TextTransparency = 0}):Play() end)
        button.MouseLeave:Connect(function() TweenService:Create(button, TweenInfo.new(0.15), {TextTransparency = 0}):Play() end)
    end

    local CloseBtn = Instance.new("TextButton", TopBar)
    CloseBtn.Size = UDim2.new(0, 30, 0, 30); CloseBtn.Position = UDim2.new(1, -35, 0, 5)
    CloseBtn.BackgroundTransparency = 1; CloseBtn.Text = "×"; CloseBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
    CloseBtn.Font = Enum.Font.GothamBold; CloseBtn.TextSize = 20

    -- ==========================================
    -- ⚠️ SYSTEM EXIT CONFIRMATION DIALOG ⚠️
    -- ==========================================
    local ConfirmOverlay = Instance.new("Frame", NoxvaUI)
    ConfirmOverlay.Size = UDim2.new(1, 0, 1, 0)
    ConfirmOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    ConfirmOverlay.BackgroundTransparency = 1
    ConfirmOverlay.Visible = false
    ConfirmOverlay.BorderSizePixel = 0

    local ConfirmFrame = Instance.new("Frame", ConfirmOverlay)
    ConfirmFrame.Size = UDim2.new(0, 320, 0, 150)
    ConfirmFrame.Position = UDim2.new(0.5, -160, 0.5, -75)
    ConfirmFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    ConfirmFrame.BackgroundTransparency = 0.05
    Instance.new("UICorner", ConfirmFrame).CornerRadius = UDim.new(0, 8)
    local CStroke = Instance.new("UIStroke", ConfirmFrame)
    CStroke.Color = Color3.fromRGB(255, 60, 60)
    CStroke.Thickness = 1.5

    local CTitle = Instance.new("TextLabel", ConfirmFrame)
    CTitle.Size = UDim2.new(1, 0, 0, 30)
    CTitle.Position = UDim2.new(0, 0, 0, 15)
    CTitle.BackgroundTransparency = 1
    CTitle.Text = "⚠️ WARNING ⚠️"
    CTitle.TextColor3 = Color3.fromRGB(255, 60, 60)
    CTitle.Font = Enum.Font.GothamBold
    CTitle.TextSize = 16

    local CDesc = Instance.new("TextLabel", ConfirmFrame)
    CDesc.Size = UDim2.new(1, -40, 0, 40)
    CDesc.Position = UDim2.new(0, 20, 0, 45)
    CDesc.BackgroundTransparency = 1
    CDesc.Text = "Apakah kamu yakin ingin menutup UI selamanya?\n(Logic yang berjalan akan tetap aktif)"
    CDesc.TextColor3 = Color3.fromRGB(200, 200, 200)
    CDesc.Font = Enum.Font.GothamSemibold
    CDesc.TextSize = 11
    CDesc.TextWrapped = true
    CDesc.TextXAlignment = Enum.TextXAlignment.Center

    local BtnAccept = Instance.new("TextButton", ConfirmFrame)
    BtnAccept.Size = UDim2.new(0.5, -30, 0, 35)
    BtnAccept.Position = UDim2.new(0, 20, 0, 100)
    BtnAccept.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    BtnAccept.Text = "Accept (Destroy)"
    BtnAccept.TextColor3 = Color3.fromRGB(255, 255, 255)
    BtnAccept.Font = Enum.Font.GothamBold
    BtnAccept.TextSize = 12
    Instance.new("UICorner", BtnAccept).CornerRadius = UDim.new(0, 6)
    AddRipple(BtnAccept)

    local BtnCancel = Instance.new("TextButton", ConfirmFrame)
    BtnCancel.Size = UDim2.new(0.5, -30, 0, 35)
    BtnCancel.Position = UDim2.new(0.5, 10, 0, 100)
    BtnCancel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    BtnCancel.Text = "Cancel"
    BtnCancel.TextColor3 = Color3.fromRGB(220, 220, 220)
    BtnCancel.Font = Enum.Font.GothamBold
    BtnCancel.TextSize = 12
    Instance.new("UICorner", BtnCancel).CornerRadius = UDim.new(0, 6)
    AddRipple(BtnCancel)

    -- Logic Tombol Close (X) memanggil Dialog Peringatan
    CloseBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
        ConfirmOverlay.Visible = true
        TweenService:Create(ConfirmOverlay, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play()
    end)

    -- Logic Accept (Membunuh UI sepenuhnya)
    BtnAccept.MouseButton1Click:Connect(function()
        NoxvaUI:Destroy()
    end)

    -- Logic Cancel (Membatalkan dan mengembalikan UI)
    BtnCancel.MouseButton1Click:Connect(function()
        local hideTween = TweenService:Create(ConfirmOverlay, TweenInfo.new(0.2), {BackgroundTransparency = 1})
        hideTween:Play()
        hideTween.Completed:Connect(function()
            ConfirmOverlay.Visible = false
            MainFrame.Visible = true
        end)
    end)
    -- ==========================================
    -- END OF CONFIRMATION DIALOG
    -- ==========================================

    local MinBtn = Instance.new("TextButton", TopBar)
    MinBtn.Size = UDim2.new(0, 30, 0, 30); MinBtn.Position = UDim2.new(1, -70, 0, 5)
    MinBtn.BackgroundTransparency = 1; MinBtn.Text = "-"; MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinBtn.Font = Enum.Font.GothamBold; MinBtn.TextSize = 24
    MinBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false; OpenLogo.Visible = true end)
    LogoClicker.MouseButton1Click:Connect(function() MainFrame.Visible = true; OpenLogo.Visible = false end)

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
    MakeDraggable(MainFrame, TopBar); MakeDraggable(OpenLogo, LogoClicker)

    -- ==========================================
    -- SIDEBAR & CONTENT AREA
    -- ==========================================
    local Sidebar = Instance.new("Frame", MainFrame)
    Sidebar.Size = UDim2.new(0, 115, 1, -40); Sidebar.Position = UDim2.new(0, 0, 0, 40) 
    Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 20); Sidebar.BackgroundTransparency = 0.2
    Sidebar.BorderSizePixel = 0
    local SidebarLayout = Instance.new("UIListLayout", Sidebar)
    SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder; SidebarLayout.Padding = UDim.new(0, 5)

    local ContentArea = Instance.new("Frame", MainFrame)
    ContentArea.Size = UDim2.new(1, -115, 1, -40); ContentArea.Position = UDim2.new(0, 115, 0, 40) 
    ContentArea.BackgroundTransparency = 1

    local WindowFunctions = {}
    local FirstTab = true

    function WindowFunctions:EnableAntiAFK()
        if getgenv().NoxvaAntiAFKLoaded then return end
        getgenv().NoxvaAntiAFKLoaded = true
        if LocalPlayer then
            LocalPlayer.Idled:Connect(function()
                local VirtualUser = game:GetService("VirtualUser")
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
            self:Notify("SYSTEM", "Anti-AFK Aktif! Lu aman dari kick.", 3)
        end
    end

    function WindowFunctions:Notify(Title, Text, Duration)
        local NotifFrame = Instance.new("Frame", NotifContainer)
        NotifFrame.Size = UDim2.new(1, 0, 0, 60)
        NotifFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25); NotifFrame.BackgroundTransparency = 0.1
        NotifFrame.Position = UDim2.new(1, 300, 0, 0)
        Instance.new("UICorner", NotifFrame).CornerRadius = UDim.new(0, 5)
        local NStroke = Instance.new("UIStroke", NotifFrame)
        NStroke.Color = NoxvaLib.AccentColor; NStroke.Thickness = 1.5

        local NotifTitle = Instance.new("TextLabel", NotifFrame)
        NotifTitle.Size = UDim2.new(1, -20, 0, 20); NotifTitle.Position = UDim2.new(0, 10, 0, 5)
        NotifTitle.BackgroundTransparency = 1; NotifTitle.Text = Title
        NotifTitle.TextColor3 = NoxvaLib.AccentColor; NotifTitle.Font = Enum.Font.GothamBold
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

    function WindowFunctions:SendWebhook(WebhookURL, EmbedData)
        local requestFunc = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
        if not requestFunc then
            warn("NoxvaHub: Executor lu gak support HTTP Request buat Webhook anj!")
            return
        end
        local payload = { ["embeds"] = {EmbedData} }
        local success, err = pcall(function()
            requestFunc({
                Url = WebhookURL,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode(payload)
            })
        end)
        if not success then warn("NoxvaHub Webhook Error: " .. tostring(err)) end
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

        if FirstTab then TabBtn.TextColor3 = NoxvaLib.AccentColor; FirstTab = false end

        local PageLayout = Instance.new("UIListLayout", TabPage)
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder; PageLayout.Padding = UDim.new(0, 6)
        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabPage.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 10)
        end)

        TabBtn.MouseButton1Click:Connect(function()
            for _, child in pairs(ContentArea:GetChildren()) do if child:IsA("ScrollingFrame") then child.Visible = false end end
            for _, child in pairs(Sidebar:GetChildren()) do if child:IsA("TextButton") then child.TextColor3 = Color3.fromRGB(150, 150, 150) end end
            TabPage.Visible = true; TabBtn.TextColor3 = NoxvaLib.AccentColor
        end)

        local TabFunctions = {}
        local SearchableElements = {}

        function TabFunctions:AddSearchBar()
            local SearchFrame = Instance.new("Frame", TabPage)
            SearchFrame.Size = UDim2.new(1, 0, 0, 35)
            SearchFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25); SearchFrame.BackgroundTransparency = 0.2
            Instance.new("UICorner", SearchFrame).CornerRadius = UDim.new(0, 5)
            local SearchStroke = Instance.new("UIStroke", SearchFrame)
            SearchStroke.Color = NoxvaLib.AccentColor; SearchStroke.Thickness = 1; SearchStroke.Transparency = 0.5
            local SearchBox = Instance.new("TextBox", SearchFrame)
            SearchBox.Size = UDim2.new(1, -30, 1, 0); SearchBox.Position = UDim2.new(0, 15, 0, 0)
            SearchBox.BackgroundTransparency = 1; SearchBox.PlaceholderText = "🔍 Cari fitur di sini..."
            SearchBox.Text = ""; SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            SearchBox.Font = Enum.Font.Gotham; SearchBox.TextSize = 12; SearchBox.TextXAlignment = Enum.TextXAlignment.Left

            SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
                local searchText = SearchBox.Text:lower()
                for _, element in ipairs(SearchableElements) do
                    if searchText == "" or string.find(element.Name, searchText) then
                        element.Frame.Visible = true
                    else
                        element.Frame.Visible = false
                    end
                end
            end)
        end

        function TabFunctions:AddLabel(TextContent)
            local LblFrame = Instance.new("Frame", TabPage)
            LblFrame.Size = UDim2.new(1, 0, 0, 0); LblFrame.AutomaticSize = Enum.AutomaticSize.Y
            LblFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25); LblFrame.BackgroundTransparency = 0.2
            Instance.new("UICorner", LblFrame).CornerRadius = UDim.new(0, 5)
            local LblText = Instance.new("TextLabel", LblFrame)
            LblText.Size = UDim2.new(1, 0, 0, 0); LblText.AutomaticSize = Enum.AutomaticSize.Y
            LblText.BackgroundTransparency = 1; LblText.Text = TextContent
            LblText.TextColor3 = Color3.fromRGB(220, 220, 220); LblText.Font = Enum.Font.GothamSemibold
            LblText.TextSize = 12; LblText.TextWrapped = true; LblText.TextXAlignment = Enum.TextXAlignment.Left; LblText.TextYAlignment = Enum.TextYAlignment.Top
            local Pad = Instance.new("UIPadding", LblText)
            Pad.PaddingLeft = UDim.new(0, 15); Pad.PaddingRight = UDim.new(0, 15); Pad.PaddingTop = UDim.new(0, 10); Pad.PaddingBottom = UDim.new(0, 10)
            
            table.insert(SearchableElements, {Frame = LblFrame, Name = TextContent:lower()})
            local LabelItem = {}
            function LabelItem:SetText(newText) LblText.Text = newText; SearchableElements[#SearchableElements].Name = newText:lower() end
            return LabelItem
        end

        function TabFunctions:AddParagraph(TitleText, DescText)
            local ParaFrame = Instance.new("Frame", TabPage)
            ParaFrame.Size = UDim2.new(1, 0, 0, 0)
            ParaFrame.AutomaticSize = Enum.AutomaticSize.Y 
            ParaFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25) 
            ParaFrame.BackgroundTransparency = 0.2
            Instance.new("UICorner", ParaFrame).CornerRadius = UDim.new(0, 5)

            local UIList = Instance.new("UIListLayout", ParaFrame)
            UIList.SortOrder = Enum.SortOrder.LayoutOrder
            UIList.Padding = UDim.new(0, 5)

            local Pad = Instance.new("UIPadding", ParaFrame)
            Pad.PaddingTop = UDim.new(0, 10); Pad.PaddingBottom = UDim.new(0, 10)
            Pad.PaddingLeft = UDim.new(0, 15); Pad.PaddingRight = UDim.new(0, 15)

            local TitleLbl = Instance.new("TextLabel", ParaFrame)
            TitleLbl.Size = UDim2.new(1, 0, 0, 15)
            TitleLbl.BackgroundTransparency = 1
            TitleLbl.Text = TitleText
            TitleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
            TitleLbl.Font = Enum.Font.GothamBold
            TitleLbl.TextSize = 12
            TitleLbl.TextXAlignment = Enum.TextXAlignment.Left

            local DescLbl = Instance.new("TextLabel", ParaFrame)
            DescLbl.Size = UDim2.new(1, 0, 0, 0)
            DescLbl.AutomaticSize = Enum.AutomaticSize.Y 
            DescLbl.BackgroundTransparency = 1
            DescLbl.Text = DescText
            DescLbl.TextColor3 = Color3.fromRGB(180, 180, 180)
            DescLbl.Font = Enum.Font.GothamSemibold
            DescLbl.TextSize = 11
            DescLbl.TextWrapped = true 
            DescLbl.TextXAlignment = Enum.TextXAlignment.Left

            table.insert(SearchableElements, {Frame = ParaFrame, Name = TitleText:lower()})

            local ParaFunc = {}
            function ParaFunc:Set(NewTitle, NewDesc)
                TitleLbl.Text = NewTitle
                DescLbl.Text = NewDesc
            end
            return ParaFunc
        end

        function TabFunctions:AddSection(TextContent)
            local SecFrame = Instance.new("Frame", TabPage)
            SecFrame.Size = UDim2.new(1, 0, 0, 25)
            SecFrame.BackgroundTransparency = 1
            
            local SecText = Instance.new("TextLabel", SecFrame)
            SecText.Size = UDim2.new(1, 0, 1, 0)
            SecText.BackgroundTransparency = 1
            SecText.Text = "- " .. TextContent .. " -"
            SecText.TextColor3 = NoxvaLib.AccentColor
            SecText.Font = Enum.Font.GothamBold
            SecText.TextSize = 12
            
            table.insert(SearchableElements, {Frame = SecFrame, Name = TextContent:lower()})
        end

        function TabFunctions:AddConsole(ConsoleHeight)
            local h = ConsoleHeight or 150
            local ConFrame = Instance.new("Frame", TabPage)
            ConFrame.Size = UDim2.new(1, 0, 0, h)
            ConFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20); ConFrame.BackgroundTransparency = 0.2
            Instance.new("UICorner", ConFrame).CornerRadius = UDim.new(0, 5)
            local ConStroke = Instance.new("UIStroke", ConFrame)
            ConStroke.Color = NoxvaLib.AccentColor; ConStroke.Thickness = 1; ConStroke.Transparency = 0.5

            local TopCon = Instance.new("Frame", ConFrame)
            TopCon.Size = UDim2.new(1, 0, 0, 25); TopCon.BackgroundColor3 = Color3.fromRGB(30, 30, 30); TopCon.BorderSizePixel = 0
            Instance.new("UICorner", TopCon).CornerRadius = UDim.new(0, 5)
            local FixBlocker = Instance.new("Frame", TopCon); FixBlocker.Size = UDim2.new(1, 0, 0, 5); FixBlocker.Position = UDim2.new(0, 0, 1, -5); FixBlocker.BackgroundColor3 = Color3.fromRGB(30, 30, 30); FixBlocker.BorderSizePixel = 0
            
            local ConTitle = Instance.new("TextLabel", TopCon)
            ConTitle.Size = UDim2.new(0.5, 0, 1, 0); ConTitle.Position = UDim2.new(0, 10, 0, 0); ConTitle.BackgroundTransparency = 1
            ConTitle.Text = "Terminal Log"; ConTitle.TextColor3 = Color3.fromRGB(200, 200, 200); ConTitle.Font = Enum.Font.GothamBold; ConTitle.TextSize = 11; ConTitle.TextXAlignment = Enum.TextXAlignment.Left

            local CopyBtn = Instance.new("TextButton", TopCon)
            CopyBtn.Size = UDim2.new(0, 60, 0, 18); CopyBtn.Position = UDim2.new(1, -65, 0, 3.5); CopyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            CopyBtn.Text = "Copy All"; CopyBtn.TextColor3 = NoxvaLib.AccentColor; CopyBtn.Font = Enum.Font.GothamBold; CopyBtn.TextSize = 10
            Instance.new("UICorner", CopyBtn).CornerRadius = UDim.new(0, 4)

            local ScrollCon = Instance.new("ScrollingFrame", ConFrame)
            ScrollCon.Size = UDim2.new(1, -10, 1, -30); ScrollCon.Position = UDim2.new(0, 5, 0, 25)
            ScrollCon.BackgroundTransparency = 1; ScrollCon.ScrollBarThickness = 2; ScrollCon.ScrollBarImageColor3 = NoxvaLib.AccentColor
            local SLayout = Instance.new("UIListLayout", ScrollCon)
            SLayout.SortOrder = Enum.SortOrder.LayoutOrder; SLayout.Padding = UDim.new(0, 2)
            
            SLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                ScrollCon.CanvasSize = UDim2.new(0, 0, 0, SLayout.AbsoluteContentSize.Y + 5)
                ScrollCon.CanvasPosition = Vector2.new(0, SLayout.AbsoluteContentSize.Y)
            end)

            local AllLogs = ""
            CopyBtn.MouseButton1Click:Connect(function()
                if setclipboard then
                    setclipboard(AllLogs)
                    WindowFunctions:Notify("CONSOLE", "Semua log berhasil disalin ke Clipboard!", 3)
                else
                    WindowFunctions:Notify("ERROR", "Executor lu gak support setclipboard!", 3)
                end
            end)

            table.insert(SearchableElements, {Frame = ConFrame, Name = "console terminal log"})

            local ConsoleFuncs = {}
            function ConsoleFuncs:Log(msg)
                local newLog = Instance.new("TextLabel", ScrollCon)
                newLog.Size = UDim2.new(1, -5, 0, 0); newLog.AutomaticSize = Enum.AutomaticSize.Y
                newLog.BackgroundTransparency = 1; newLog.Text = "> " .. tostring(msg)
                newLog.TextColor3 = Color3.fromRGB(220, 220, 220); newLog.Font = Enum.Font.Code; newLog.TextSize = 11
                newLog.TextWrapped = true; newLog.TextXAlignment = Enum.TextXAlignment.Left
                AllLogs = AllLogs .. tostring(msg) .. "\n"
            end
            function ConsoleFuncs:Clear()
                for _, v in pairs(ScrollCon:GetChildren()) do if v:IsA("TextLabel") then v:Destroy() end end
                AllLogs = ""
            end
            return ConsoleFuncs
        end

        function TabFunctions:AddButton(BtnText, Callback)
            local BtnFrame = Instance.new("Frame", TabPage)
            BtnFrame.Size = UDim2.new(1, 0, 0, 35); BtnFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35); BtnFrame.BackgroundTransparency = 0.2
            Instance.new("UICorner", BtnFrame).CornerRadius = UDim.new(0, 5)
            local Btn = Instance.new("TextButton", BtnFrame)
            Btn.Size = UDim2.new(1, 0, 1, 0); Btn.BackgroundTransparency = 1; Btn.Text = BtnText; Btn.TextColor3 = Color3.fromRGB(230, 230, 230)
            Btn.Font = Enum.Font.GothamSemibold; Btn.TextSize = 13; Btn.TextXAlignment = Enum.TextXAlignment.Left
            Btn.TextTruncate = Enum.TextTruncate.AtEnd 
            Instance.new("UIPadding", Btn).PaddingLeft = UDim.new(0, 15)
            AddRipple(Btn); Btn.MouseButton1Click:Connect(function() Callback() end)
            table.insert(SearchableElements, {Frame = BtnFrame, Name = BtnText:lower()})
        end

        function TabFunctions:AddDoubleButton(Btn1Text, Btn1Callback, Btn2Text, Btn2Callback)
            local Container = Instance.new("Frame", TabPage)
            Container.Size = UDim2.new(1, 0, 0, 35); Container.BackgroundTransparency = 1
            local Btn1Frame = Instance.new("Frame", Container)
            Btn1Frame.Size = UDim2.new(0.5, -3, 1, 0); Btn1Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35); Btn1Frame.BackgroundTransparency = 0.2
            Instance.new("UICorner", Btn1Frame).CornerRadius = UDim.new(0, 5)
            local Btn1 = Instance.new("TextButton", Btn1Frame)
            Btn1.Size = UDim2.new(1, 0, 1, 0); Btn1.BackgroundTransparency = 1; Btn1.Text = Btn1Text; Btn1.TextColor3 = Color3.fromRGB(230, 230, 230); Btn1.Font = Enum.Font.GothamSemibold; Btn1.TextSize = 13
            Btn1.TextTruncate = Enum.TextTruncate.AtEnd
            AddRipple(Btn1); Btn1.MouseButton1Click:Connect(function() Btn1Callback() end)

            local Btn2Frame = Instance.new("Frame", Container)
            Btn2Frame.Size = UDim2.new(0.5, -3, 1, 0); Btn2Frame.Position = UDim2.new(0.5, 3, 0, 0); Btn2Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35); Btn2Frame.BackgroundTransparency = 0.2
            Instance.new("UICorner", Btn2Frame).CornerRadius = UDim.new(0, 5)
            local Btn2 = Instance.new("TextButton", Btn2Frame)
            Btn2.Size = UDim2.new(1, 0, 1, 0); Btn2.BackgroundTransparency = 1; Btn2.Text = Btn2Text; Btn2.TextColor3 = Color3.fromRGB(230, 230, 230); Btn2.Font = Enum.Font.GothamSemibold; Btn2.TextSize = 13
            Btn2.TextTruncate = Enum.TextTruncate.AtEnd
            AddRipple(Btn2); Btn2.MouseButton1Click:Connect(function() Btn2Callback() end)
            
            table.insert(SearchableElements, {Frame = Container, Name = Btn1Text:lower() .. " " .. Btn2Text:lower()})
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
            ToggleBtn.TextColor3 = State and NoxvaLib.AccentColor or Color3.fromRGB(230, 230, 230)
            ToggleBtn.Font = Enum.Font.GothamSemibold; ToggleBtn.TextSize = 13; ToggleBtn.TextXAlignment = Enum.TextXAlignment.Left
            ToggleBtn.TextTruncate = Enum.TextTruncate.AtEnd 
            Instance.new("UIPadding", ToggleBtn).PaddingLeft = UDim.new(0, 15)
            AddRipple(ToggleBtn)
            
            local function UpdateVisual(newState)
                State = newState
                ToggleBtn.Text = ToggleText .. "   |   " .. (State and "ON" or "OFF")
                ToggleBtn.TextColor3 = State and NoxvaLib.AccentColor or Color3.fromRGB(230, 230, 230)
                if Flag then NoxvaLib.Flags[Flag].Value = State end
                Callback(State)
            end

            if Flag then NoxvaLib.Flags[Flag] = {Value = State, Func = Callback, Set = UpdateVisual} end
            if State then Callback(State) end
            
            ToggleBtn.MouseButton1Click:Connect(function() UpdateVisual(not State) end)
            table.insert(SearchableElements, {Frame = TglFrame, Name = ToggleText:lower()})
        end

        function TabFunctions:AddHybridToggle(ToggleText, DefaultState, DefaultKey, Callback, Flag)
            local State = DefaultState or false
            local key = DefaultKey or Enum.KeyCode.E
            if Flag and NoxvaLib.Flags[Flag] ~= nil then 
                if type(NoxvaLib.Flags[Flag].Value) == "table" then
                    State = NoxvaLib.Flags[Flag].Value.State
                    key = NoxvaLib.Flags[Flag].Value.Key
                else
                    State = NoxvaLib.Flags[Flag].Value
                end
            end
            
            local TglFrame = Instance.new("Frame", TabPage)
            TglFrame.Size = UDim2.new(1, 0, 0, 35); TglFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35); TglFrame.BackgroundTransparency = 0.2
            Instance.new("UICorner", TglFrame).CornerRadius = UDim.new(0, 5)
            
            local ToggleBtn = Instance.new("TextButton", TglFrame)
            ToggleBtn.Size = UDim2.new(1, -60, 1, 0); ToggleBtn.BackgroundTransparency = 1
            ToggleBtn.Text = ToggleText .. "   |   " .. (State and "ON" or "OFF")
            ToggleBtn.TextColor3 = State and NoxvaLib.AccentColor or Color3.fromRGB(230, 230, 230)
            ToggleBtn.Font = Enum.Font.GothamSemibold; ToggleBtn.TextSize = 13; ToggleBtn.TextXAlignment = Enum.TextXAlignment.Left
            ToggleBtn.TextTruncate = Enum.TextTruncate.AtEnd 
            Instance.new("UIPadding", ToggleBtn).PaddingLeft = UDim.new(0, 15)
            AddRipple(ToggleBtn)

            local BindBtn = Instance.new("TextButton", TglFrame)
            BindBtn.Size = UDim2.new(0, 50, 0, 25); BindBtn.Position = UDim2.new(1, -60, 0, 5); BindBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            BindBtn.Text = key.Name; BindBtn.TextColor3 = NoxvaLib.AccentColor; BindBtn.Font = Enum.Font.GothamBold; BindBtn.TextSize = 12
            Instance.new("UICorner", BindBtn).CornerRadius = UDim.new(0, 5)
            
            local function UpdateVisual(vObj)
                State = vObj.State; key = vObj.Key
                ToggleBtn.Text = ToggleText .. "   |   " .. (State and "ON" or "OFF")
                ToggleBtn.TextColor3 = State and NoxvaLib.AccentColor or Color3.fromRGB(230, 230, 230)
                BindBtn.Text = key.Name
                if Flag then NoxvaLib.Flags[Flag].Value = {State = State, Key = key} end
                Callback(State)
            end

            if Flag then NoxvaLib.Flags[Flag] = {Value = {State = State, Key = key}, Func = Callback, Set = UpdateVisual} end
            if State then Callback(State) end

            ToggleBtn.MouseButton1Click:Connect(function() UpdateVisual({State = not State, Key = key}) end)

            local isBinding = false
            BindBtn.MouseButton1Click:Connect(function()
                BindBtn.Text = "..."; isBinding = true
            end)
            
            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if isBinding and input.UserInputType == Enum.UserInputType.Keyboard then
                    isBinding = false; UpdateVisual({State = State, Key = input.KeyCode})
                elseif not gameProcessed and input.KeyCode == key and not isBinding then
                    UpdateVisual({State = not State, Key = key})
                end
            end)
            
            table.insert(SearchableElements, {Frame = TglFrame, Name = ToggleText:lower()})
        end

        function TabFunctions:AddSlider(txt, min, max, def, Callback, Flag)
            local val = def or min
            if Flag and NoxvaLib.Flags[Flag] ~= nil then val = NoxvaLib.Flags[Flag].Value end

            local ctn = Instance.new("Frame", TabPage); ctn.Size = UDim2.new(1, 0, 0, 50); ctn.BackgroundColor3 = Color3.fromRGB(35, 35, 35); ctn.BackgroundTransparency = 0.2; Instance.new("UICorner", ctn).CornerRadius = UDim.new(0, 5)
            local lbl = Instance.new("TextLabel", ctn); lbl.Size = UDim2.new(1, -30, 0, 20); lbl.Position = UDim2.new(0, 15, 0, 5); lbl.BackgroundTransparency = 1; lbl.Text = txt .. " : " .. tostring(val); lbl.TextColor3 = Color3.fromRGB(230, 230, 230); lbl.Font = Enum.Font.GothamSemibold; lbl.TextSize = 12; lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextTruncate = Enum.TextTruncate.AtEnd 
            local bg = Instance.new("TextButton", ctn); bg.Size = UDim2.new(1, -30, 0, 6); bg.Position = UDim2.new(0, 15, 0, 32); bg.BackgroundColor3 = Color3.fromRGB(20, 20, 20); bg.Text = ""; Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)
            local fl = Instance.new("Frame", bg); fl.Size = UDim2.new((val - min)/(max - min), 0, 1, 0); fl.BackgroundColor3 = NoxvaLib.AccentColor; Instance.new("UICorner", fl).CornerRadius = UDim.new(1, 0)
            
            local function UpdateVisual(newVal)
                val = math.clamp(math.floor(newVal), min, max)
                local p = (val - min) / (max - min)
                fl.Size = UDim2.new(p, 0, 1, 0)
                lbl.Text = txt .. " : " .. tostring(val)
                if Flag then NoxvaLib.Flags[Flag].Value = val end
                Callback(val)
            end

            if Flag then NoxvaLib.Flags[Flag] = {Value = val, Func = Callback, Set = UpdateVisual} end
            
            local d = false
            bg.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then d = true; UpdateVisual(min + (max - min) * math.clamp((i.Position.X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1)) end end)
            UserInputService.InputChanged:Connect(function(i) if d and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then UpdateVisual(min + (max - min) * math.clamp((i.Position.X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1)) end end)
            UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then d = false end end)
            Callback(val)
            table.insert(SearchableElements, {Frame = ctn, Name = txt:lower()})
        end

        function TabFunctions:AddKeybind(BindText, DefaultKey, Callback)
            local key = DefaultKey or Enum.KeyCode.E
            local BindFrame = Instance.new("Frame", TabPage)
            BindFrame.Size = UDim2.new(1, 0, 0, 35); BindFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35); BindFrame.BackgroundTransparency = 0.2
            Instance.new("UICorner", BindFrame).CornerRadius = UDim.new(0, 5)
            
            local BindLabel = Instance.new("TextLabel", BindFrame)
            BindLabel.Size = UDim2.new(0.5, 0, 1, 0); BindLabel.Position = UDim2.new(0, 15, 0, 0); BindLabel.BackgroundTransparency = 1
            BindLabel.Text = BindText; BindLabel.TextColor3 = Color3.fromRGB(230, 230, 230); BindLabel.Font = Enum.Font.GothamSemibold; BindLabel.TextSize = 13; BindLabel.TextXAlignment = Enum.TextXAlignment.Left
            BindLabel.TextTruncate = Enum.TextTruncate.AtEnd
            
            local BindBtn = Instance.new("TextButton", BindFrame)
            BindBtn.Size = UDim2.new(0, 80, 0, 25); BindBtn.Position = UDim2.new(1, -95, 0, 5); BindBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            BindBtn.Text = key.Name; BindBtn.TextColor3 = NoxvaLib.AccentColor; BindBtn.Font = Enum.Font.GothamBold; BindBtn.TextSize = 12
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
            table.insert(SearchableElements, {Frame = BindFrame, Name = BindText:lower()})
        end

        function TabFunctions:AddDropdown(DropText, Options, Callback, Flag)
            local selected = Options[1]
            if Flag and NoxvaLib.Flags[Flag] ~= nil then selected = NoxvaLib.Flags[Flag].Value end

            local DropdownFrame = Instance.new("Frame", TabPage)
            DropdownFrame.Size = UDim2.new(1, 0, 0, 35); DropdownFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35); DropdownFrame.BackgroundTransparency = 0.2; DropdownFrame.ClipsDescendants = true
            Instance.new("UICorner", DropdownFrame).CornerRadius = UDim.new(0, 5)
            local DropButton = Instance.new("TextButton", DropdownFrame)
            DropButton.Size = UDim2.new(1, 0, 0, 35); DropButton.BackgroundTransparency = 1; DropButton.Text = DropText .. " :  " .. tostring(selected or ""); DropButton.TextColor3 = Color3.fromRGB(230, 230, 230); DropButton.Font = Enum.Font.GothamSemibold; DropButton.TextSize = 13; DropButton.TextXAlignment = Enum.TextXAlignment.Left
            DropButton.TextTruncate = Enum.TextTruncate.AtEnd 
            Instance.new("UIPadding", DropButton).PaddingLeft = UDim.new(0, 15)
            AddRipple(DropButton)

            local DropContainer = Instance.new("ScrollingFrame", DropdownFrame)
            DropContainer.Size = UDim2.new(1, 0, 1, -35); DropContainer.Position = UDim2.new(0, 0, 0, 35); DropContainer.BackgroundTransparency = 1; DropContainer.ScrollBarThickness = 0
            Instance.new("UIListLayout", DropContainer).SortOrder = Enum.SortOrder.LayoutOrder

            local isOpen = false
            
            local function UpdateVisual(newVal)
                selected = newVal
                DropButton.Text = DropText .. " :  " .. tostring(selected)
                isOpen = false; DropdownFrame.Size = UDim2.new(1, 0, 0, 35)
                if Flag then NoxvaLib.Flags[Flag].Value = selected end
                Callback(selected)
            end

            if Flag then NoxvaLib.Flags[Flag] = {Value = selected, Func = Callback, Set = UpdateVisual} end

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
                OptBtn.TextTruncate = Enum.TextTruncate.AtEnd 
                Instance.new("UIPadding", OptBtn).PaddingLeft = UDim.new(0, 25)
                AddRipple(OptBtn)
                OptBtn.MouseButton1Click:Connect(function() UpdateVisual(option) end)
            end
            if selected then Callback(selected) end
            table.insert(SearchableElements, {Frame = DropdownFrame, Name = DropText:lower()})
        end

        function TabFunctions:AddPlayerDropdown(DropText, DefaultSelected, Callback, Flag)
            local selected = DefaultSelected or "None"
            if Flag and NoxvaLib.Flags[Flag] ~= nil then selected = NoxvaLib.Flags[Flag].Value end

            local DropdownFrame = Instance.new("Frame", TabPage)
            DropdownFrame.Size = UDim2.new(1, 0, 0, 35); DropdownFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35); DropdownFrame.BackgroundTransparency = 0.2; DropdownFrame.ClipsDescendants = true
            Instance.new("UICorner", DropdownFrame).CornerRadius = UDim.new(0, 5)
            
            local DropButton = Instance.new("TextButton", DropdownFrame)
            DropButton.Size = UDim2.new(1, 0, 0, 35); DropButton.BackgroundTransparency = 1; DropButton.Text = DropText .. " :  " .. tostring(selected or ""); DropButton.TextColor3 = Color3.fromRGB(230, 230, 230); DropButton.Font = Enum.Font.GothamSemibold; DropButton.TextSize = 13; DropButton.TextXAlignment = Enum.TextXAlignment.Left
            DropButton.TextTruncate = Enum.TextTruncate.AtEnd 
            Instance.new("UIPadding", DropButton).PaddingLeft = UDim.new(0, 15)
            AddRipple(DropButton)

            local DropContainer = Instance.new("ScrollingFrame", DropdownFrame)
            DropContainer.Size = UDim2.new(1, 0, 1, -35); DropContainer.Position = UDim2.new(0, 0, 0, 35); DropContainer.BackgroundTransparency = 1; DropContainer.ScrollBarThickness = 0
            local Layout = Instance.new("UIListLayout", DropContainer)
            Layout.SortOrder = Enum.SortOrder.LayoutOrder

            local isOpen = false
            local function UpdateVisual(newVal)
                selected = newVal
                DropButton.Text = DropText .. " :  " .. tostring(selected)
                isOpen = false; DropdownFrame.Size = UDim2.new(1, 0, 0, 35)
                if Flag then NoxvaLib.Flags[Flag].Value = selected end
                Callback(selected)
            end

            if Flag then NoxvaLib.Flags[Flag] = {Value = selected, Func = Callback, Set = UpdateVisual} end

            DropButton.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                if isOpen then
                    for _, child in pairs(DropContainer:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
                    local playerList = game:GetService("Players"):GetPlayers()
                    for _, player in ipairs(playerList) do
                        local OptBtn = Instance.new("TextButton", DropContainer)
                        OptBtn.Size = UDim2.new(1, 0, 0, 30); OptBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45); OptBtn.BackgroundTransparency = 0.5; OptBtn.Text = player.Name; OptBtn.TextColor3 = Color3.fromRGB(200, 200, 200); OptBtn.Font = Enum.Font.Gotham; OptBtn.TextSize = 13; OptBtn.BorderSizePixel = 0; OptBtn.TextXAlignment = Enum.TextXAlignment.Left
                        OptBtn.TextTruncate = Enum.TextTruncate.AtEnd 
                        Instance.new("UIPadding", OptBtn).PaddingLeft = UDim.new(0, 25)
                        AddRipple(OptBtn)
                        OptBtn.MouseButton1Click:Connect(function() UpdateVisual(player.Name) end)
                    end
                    local targetHeight = 35 + (#playerList * 30)
                    DropdownFrame.Size = UDim2.new(1, 0, 0, math.clamp(targetHeight, 35, 150))
                    DropContainer.CanvasSize = UDim2.new(0, 0, 0, #playerList * 30)
                else 
                    DropdownFrame.Size = UDim2.new(1, 0, 0, 35) 
                end
            end)
            
            if selected ~= "None" then Callback(selected) end
            table.insert(SearchableElements, {Frame = DropdownFrame, Name = DropText:lower()})
        end

        function TabFunctions:AddMultiDropdown(DropText, Options, DefaultSelected, Callback, Flag)
            local selectedTable = DefaultSelected or {}
            if Flag and NoxvaLib.Flags[Flag] ~= nil then selectedTable = NoxvaLib.Flags[Flag].Value end

            local DropdownFrame = Instance.new("Frame", TabPage)
            DropdownFrame.Size = UDim2.new(1, 0, 0, 35); DropdownFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35); DropdownFrame.BackgroundTransparency = 0.2; DropdownFrame.ClipsDescendants = true
            Instance.new("UICorner", DropdownFrame).CornerRadius = UDim.new(0, 5)
            
            local function GetSelectedString()
                if #selectedTable == 0 then return "None" end
                local str = ""
                for i, v in ipairs(selectedTable) do str = str .. tostring(v) .. (i < #selectedTable and ", " or "") end
                if string.len(str) > 25 then str = string.sub(str, 1, 22) .. "..." end
                return str
            end

            local DropButton = Instance.new("TextButton", DropdownFrame)
            DropButton.Size = UDim2.new(1, 0, 0, 35); DropButton.BackgroundTransparency = 1; DropButton.Text = DropText .. " :  " .. GetSelectedString(); DropButton.TextColor3 = Color3.fromRGB(230, 230, 230); DropButton.Font = Enum.Font.GothamSemibold; DropButton.TextSize = 13; DropButton.TextXAlignment = Enum.TextXAlignment.Left
            DropButton.TextTruncate = Enum.TextTruncate.AtEnd 
            Instance.new("UIPadding", DropButton).PaddingLeft = UDim.new(0, 15)
            AddRipple(DropButton)

            local DropContainer = Instance.new("ScrollingFrame", DropdownFrame)
            DropContainer.Size = UDim2.new(1, 0, 1, -35); DropContainer.Position = UDim2.new(0, 0, 0, 35); DropContainer.BackgroundTransparency = 1; DropContainer.ScrollBarThickness = 0
            Instance.new("UIListLayout", DropContainer).SortOrder = Enum.SortOrder.LayoutOrder

            local function UpdateVisual(newTable)
                selectedTable = newTable or {}
                DropButton.Text = DropText .. " :  " .. GetSelectedString()
                
                for _, btn in pairs(DropContainer:GetChildren()) do
                    if btn:IsA("TextButton") then
                        if table.find(selectedTable, btn.Text) then
                            btn.TextColor3 = NoxvaLib.AccentColor
                        else
                            btn.TextColor3 = Color3.fromRGB(200, 200, 200)
                        end
                    end
                end
                
                if Flag then NoxvaLib.Flags[Flag].Value = selectedTable end
                Callback(selectedTable)
            end

            if Flag then NoxvaLib.Flags[Flag] = {Value = selectedTable, Func = Callback, Set = UpdateVisual} end

            local isOpen = false
            DropButton.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                if isOpen then
                    local h = 35 + (#Options * 30); if h > 150 then h = 150 end
                    DropdownFrame.Size = UDim2.new(1, 0, 0, h); DropContainer.CanvasSize = UDim2.new(0, 0, 0, #Options * 30)
                else DropdownFrame.Size = UDim2.new(1, 0, 0, 35) end
            end)

            for _, option in ipairs(Options) do
                local isOptSelected = table.find(selectedTable, option) ~= nil
                local OptBtn = Instance.new("TextButton", DropContainer)
                OptBtn.Size = UDim2.new(1, 0, 0, 30); OptBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45); OptBtn.BackgroundTransparency = 0.5; OptBtn.Text = tostring(option)
                OptBtn.TextColor3 = isOptSelected and NoxvaLib.AccentColor or Color3.fromRGB(200, 200, 200)
                OptBtn.Font = Enum.Font.Gotham; OptBtn.TextSize = 13; OptBtn.BorderSizePixel = 0; OptBtn.TextXAlignment = Enum.TextXAlignment.Left
                OptBtn.TextTruncate = Enum.TextTruncate.AtEnd 
                Instance.new("UIPadding", OptBtn).PaddingLeft = UDim.new(0, 25)
                AddRipple(OptBtn)
                
                OptBtn.MouseButton1Click:Connect(function()
                    local index = table.find(selectedTable, option)
                    if index then 
                        table.remove(selectedTable, index)
                    else 
                        table.insert(selectedTable, option)
                    end
                    UpdateVisual(selectedTable)
                end)
            end
            if #selectedTable > 0 then Callback(selectedTable) end
            table.insert(SearchableElements, {Frame = DropdownFrame, Name = DropText:lower()})
        end

        function TabFunctions:AddTextbox(BoxText, Placeholder, Callback, Flag)
            local val = ""
            if Flag and NoxvaLib.Flags[Flag] ~= nil then val = NoxvaLib.Flags[Flag].Value end

            local BoxFrame = Instance.new("Frame", TabPage)
            BoxFrame.Size = UDim2.new(1, 0, 0, 40); BoxFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35); BoxFrame.BackgroundTransparency = 0.2
            Instance.new("UICorner", BoxFrame).CornerRadius = UDim.new(0, 5)
            local BoxLabel = Instance.new("TextLabel", BoxFrame)
            BoxLabel.Size = UDim2.new(0.4, 0, 1, 0); BoxLabel.Position = UDim2.new(0, 15, 0, 0); BoxLabel.BackgroundTransparency = 1; BoxLabel.Text = BoxText; BoxLabel.TextColor3 = Color3.fromRGB(230, 230, 230); BoxLabel.Font = Enum.Font.GothamSemibold; BoxLabel.TextSize = 13; BoxLabel.TextXAlignment = Enum.TextXAlignment.Left
            BoxLabel.TextTruncate = Enum.TextTruncate.AtEnd 
            local TextBox = Instance.new("TextBox", BoxFrame)
            TextBox.Size = UDim2.new(0.55, -20, 0, 28); TextBox.Position = UDim2.new(0.45, 5, 0, 6); TextBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20); TextBox.PlaceholderText = Placeholder; TextBox.Text = val; TextBox.TextColor3 = Color3.fromRGB(255, 255, 255); TextBox.Font = Enum.Font.Gotham; TextBox.TextSize = 12
            Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 5)
            
            local function UpdateVisual(newVal)
                val = newVal
                TextBox.Text = val
                if Flag then NoxvaLib.Flags[Flag].Value = val end
                Callback(val)
            end

            if Flag then NoxvaLib.Flags[Flag] = {Value = val, Func = Callback, Set = UpdateVisual} end
            if val ~= "" then Callback(val) end

            TextBox.FocusLost:Connect(function() UpdateVisual(TextBox.Text) end)
            table.insert(SearchableElements, {Frame = BoxFrame, Name = BoxText:lower()})
        end

        function TabFunctions:AddColorPicker(TextContent, DefaultColor, Callback, Flag)
            local color = DefaultColor or Color3.fromRGB(255, 255, 255)
            if Flag and NoxvaLib.Flags[Flag] ~= nil then 
                local saved = NoxvaLib.Flags[Flag].Value
                if type(saved) == "table" and saved.IsColor then
                    color = Color3.new(saved.R, saved.G, saved.B)
                end
            end

            local PickerFrame = Instance.new("Frame", TabPage)
            PickerFrame.Size = UDim2.new(1, 0, 0, 35)
            PickerFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            PickerFrame.BackgroundTransparency = 0.2
            PickerFrame.ClipsDescendants = true
            Instance.new("UICorner", PickerFrame).CornerRadius = UDim.new(0, 5)

            local ToggleBtn = Instance.new("TextButton", PickerFrame)
            ToggleBtn.Size = UDim2.new(1, 0, 0, 35); ToggleBtn.BackgroundTransparency = 1; ToggleBtn.Text = TextContent
            ToggleBtn.TextColor3 = Color3.fromRGB(230, 230, 230); ToggleBtn.Font = Enum.Font.GothamSemibold; ToggleBtn.TextSize = 13; ToggleBtn.TextXAlignment = Enum.TextXAlignment.Left
            ToggleBtn.TextTruncate = Enum.TextTruncate.AtEnd 
            Instance.new("UIPadding", ToggleBtn).PaddingLeft = UDim.new(0, 15)
            
            local ColorPreview = Instance.new("Frame", ToggleBtn)
            ColorPreview.Size = UDim2.new(0, 30, 0, 15); ColorPreview.Position = UDim2.new(1, -55, 0.5, -7.5)
            ColorPreview.BackgroundColor3 = color
            Instance.new("UICorner", ColorPreview).CornerRadius = UDim.new(0, 4)

            local ExpandArea = Instance.new("Frame", PickerFrame)
            ExpandArea.Size = UDim2.new(1, 0, 1, -35); ExpandArea.Position = UDim2.new(0, 0, 0, 35); ExpandArea.BackgroundTransparency = 1

            local isOpen = false
            ToggleBtn.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                PickerFrame.Size = isOpen and UDim2.new(1, 0, 0, 115) or UDim2.new(1, 0, 0, 35)
            end)

            local bgR, fillR, bgG, fillG, bgB, fillB

            local function UpdateVisual(newColor)
                color = newColor; ColorPreview.BackgroundColor3 = color
                if fillR then fillR.Size = UDim2.new(color.R, 0, 1, 0) end
                if fillG then fillG.Size = UDim2.new(color.G, 0, 1, 0) end
                if fillB then fillB.Size = UDim2.new(color.B, 0, 1, 0) end
                if Flag then NoxvaLib.Flags[Flag].Value = color end
                Callback(color)
            end

            if Flag then NoxvaLib.Flags[Flag] = {Value = color, Func = Callback, Set = UpdateVisual} end

            local function CreateRGB(yPos, cName, initVal)
                local lbl = Instance.new("TextLabel", ExpandArea)
                lbl.Size = UDim2.new(0, 15, 0, 15); lbl.Position = UDim2.new(0, 15, 0, yPos - 3)
                lbl.BackgroundTransparency = 1; lbl.Text = cName; lbl.TextColor3 = Color3.fromRGB(200, 200, 200); lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 11

                local bg = Instance.new("TextButton", ExpandArea)
                bg.Size = UDim2.new(1, -60, 0, 8); bg.Position = UDim2.new(0, 35, 0, yPos)
                bg.BackgroundColor3 = Color3.fromRGB(20, 20, 20); bg.Text = ""
                Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)

                local cFill = cName == "R" and Color3.fromRGB(255,50,50) or (cName == "G" and Color3.fromRGB(50,255,50)) or Color3.fromRGB(50,150,255)
                local fill = Instance.new("Frame", bg)
                fill.Size = UDim2.new(initVal, 0, 1, 0); fill.BackgroundColor3 = cFill
                Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
                return bg, fill
            end

            bgR, fillR = CreateRGB(10, "R", color.R)
            bgG, fillG = CreateRGB(35, "G", color.G)
            bgB, fillB = CreateRGB(60, "B", color.B)

            local function HookColor(bg, fill)
                local d = false
                local function upd(i)
                    local p = math.clamp((i.Position.X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1)
                    fill.Size = UDim2.new(p, 0, 1, 0) 
                    UpdateVisual(Color3.new(fillR.Size.X.Scale, fillG.Size.X.Scale, fillB.Size.X.Scale))
                end
                bg.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then d = true; upd(i) end end)
                UserInputService.InputChanged:Connect(function(i) if d and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then upd(i) end end)
                UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then d = false end end)
            end
            HookColor(bgR, fillR); HookColor(bgG, fillG); HookColor(bgB, fillB)
            
            Callback(color)
            table.insert(SearchableElements, {Frame = PickerFrame, Name = TextContent:lower()})
        end

        function TabFunctions:AddFolder(TitleText)
            local FolderFrame = Instance.new("Frame", TabPage)
            FolderFrame.Size = UDim2.new(1, 0, 0, 35); FolderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30); FolderFrame.BackgroundTransparency = 0.2; FolderFrame.ClipsDescendants = true
            Instance.new("UICorner", FolderFrame).CornerRadius = UDim.new(0, 5)

            local FolderBtn = Instance.new("TextButton", FolderFrame)
            FolderBtn.Size = UDim2.new(1, 0, 0, 35); FolderBtn.BackgroundTransparency = 1; FolderBtn.Text = TitleText .. "   ▼"; FolderBtn.TextColor3 = Color3.fromRGB(255, 255, 255); FolderBtn.Font = Enum.Font.GothamBold; FolderBtn.TextSize = 13; FolderBtn.TextXAlignment = Enum.TextXAlignment.Left
            FolderBtn.TextTruncate = Enum.TextTruncate.AtEnd 
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
            
            table.insert(SearchableElements, {Frame = FolderFrame, Name = TitleText:lower()})

            local FolderFuncs = {}
            
            function FolderFuncs:AddParagraph(TitleTxt, DescTxt)
                local ParaFrame = Instance.new("Frame", ItemContainer); ParaFrame.Size = UDim2.new(1, -20, 0, 0); ParaFrame.AutomaticSize = Enum.AutomaticSize.Y; ParaFrame.Position = UDim2.new(0, 10, 0, 0); ParaFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40); ParaFrame.BackgroundTransparency = 0.5; Instance.new("UICorner", ParaFrame).CornerRadius = UDim.new(0, 5)
                local LblUIList = Instance.new("UIListLayout", ParaFrame); LblUIList.SortOrder = Enum.SortOrder.LayoutOrder; LblUIList.Padding = UDim.new(0, 5)
                local LblPad = Instance.new("UIPadding", ParaFrame); LblPad.PaddingTop = UDim.new(0, 10); LblPad.PaddingBottom = UDim.new(0, 10); LblPad.PaddingLeft = UDim.new(0, 15); LblPad.PaddingRight = UDim.new(0, 15)
                local TitLbl = Instance.new("TextLabel", ParaFrame); TitLbl.Size = UDim2.new(1, 0, 0, 15); TitLbl.BackgroundTransparency = 1; TitLbl.Text = TitleTxt; TitLbl.TextColor3 = Color3.fromRGB(255, 255, 255); TitLbl.Font = Enum.Font.GothamBold; TitLbl.TextSize = 12; TitLbl.TextXAlignment = Enum.TextXAlignment.Left
                local DesLbl = Instance.new("TextLabel", ParaFrame); DesLbl.Size = UDim2.new(1, 0, 0, 0); DesLbl.AutomaticSize = Enum.AutomaticSize.Y; DesLbl.BackgroundTransparency = 1; DesLbl.Text = DescTxt; DesLbl.TextColor3 = Color3.fromRGB(180, 180, 180); DesLbl.Font = Enum.Font.GothamSemibold; DesLbl.TextSize = 11; DesLbl.TextWrapped = true; DesLbl.TextXAlignment = Enum.TextXAlignment.Left
                local PFunc = {}; function PFunc:Set(t, d) TitLbl.Text = t; DesLbl.Text = d end; return PFunc
            end

            function FolderFuncs:AddLabel(txt)
                local LblFrame = Instance.new("Frame", ItemContainer); LblFrame.Size = UDim2.new(1, -20, 0, 0); LblFrame.AutomaticSize = Enum.AutomaticSize.Y; LblFrame.Position = UDim2.new(0, 10, 0, 0); LblFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40); LblFrame.BackgroundTransparency = 0.8; Instance.new("UICorner", LblFrame).CornerRadius = UDim.new(0, 5)
                local LblText = Instance.new("TextLabel", LblFrame); LblText.Size = UDim2.new(1, 0, 0, 0); LblText.AutomaticSize = Enum.AutomaticSize.Y; LblText.BackgroundTransparency = 1; LblText.Text = txt; LblText.TextColor3 = Color3.fromRGB(200, 200, 200); LblText.Font = Enum.Font.GothamSemibold; LblText.TextSize = 11; LblText.TextWrapped = true; LblText.TextXAlignment = Enum.TextXAlignment.Left
                local LPad = Instance.new("UIPadding", LblText); LPad.PaddingLeft = UDim.new(0, 15); LPad.PaddingRight = UDim.new(0, 15); LPad.PaddingTop = UDim.new(0, 8); LPad.PaddingBottom = UDim.new(0, 8)
                local LItem = {}; function LItem:SetText(t) LblText.Text = t end; return LItem
            end
            
            function FolderFuncs:AddToggle(txt, def, cb, flag)
                local s = def or false; if flag and NoxvaLib.Flags[flag] ~= nil then s = NoxvaLib.Flags[flag].Value end
                local frm = Instance.new("Frame", ItemContainer); frm.Size = UDim2.new(1, -20, 0, 35); frm.Position = UDim2.new(0, 10, 0, 0); frm.BackgroundColor3 = Color3.fromRGB(40, 40, 40); frm.BackgroundTransparency = 0.5; Instance.new("UICorner", frm).CornerRadius = UDim.new(0, 5)
                local btn = Instance.new("TextButton", frm); btn.Size = UDim2.new(1, 0, 1, 0); btn.BackgroundTransparency = 1; btn.Text = txt .. "   |   " .. (s and "ON" or "OFF"); btn.TextColor3 = s and NoxvaLib.AccentColor or Color3.fromRGB(230, 230, 230); btn.Font = Enum.Font.GothamSemibold; btn.TextSize = 13; btn.TextXAlignment = Enum.TextXAlignment.Left; btn.TextTruncate = Enum.TextTruncate.AtEnd; Instance.new("UIPadding", btn).PaddingLeft = UDim.new(0, 15); AddRipple(btn)
                
                local function UpdateVisual(newState)
                    s = newState; btn.Text = txt .. "   |   " .. (s and "ON" or "OFF"); btn.TextColor3 = s and NoxvaLib.AccentColor or Color3.fromRGB(230, 230, 230); if flag then NoxvaLib.Flags[flag].Value = s end; cb(s)
                end
                
                if flag then NoxvaLib.Flags[flag] = {Value = s, Func = cb, Set = UpdateVisual} end
                if s then cb(s) end
                btn.MouseButton1Click:Connect(function() UpdateVisual(not s) end)
            end
            
            function FolderFuncs:AddButton(txt, cb)
                local frm = Instance.new("Frame", ItemContainer); frm.Size = UDim2.new(1, -20, 0, 35); frm.Position = UDim2.new(0, 10, 0, 0); frm.BackgroundColor3 = Color3.fromRGB(40, 40, 40); frm.BackgroundTransparency = 0.5; Instance.new("UICorner", frm).CornerRadius = UDim.new(0, 5)
                local btn = Instance.new("TextButton", frm); btn.Size = UDim2.new(1, 0, 1, 0); btn.BackgroundTransparency = 1; btn.Text = txt; btn.TextColor3 = Color3.fromRGB(230, 230, 230); btn.Font = Enum.Font.GothamSemibold; btn.TextSize = 13; btn.TextXAlignment = Enum.TextXAlignment.Left; btn.TextTruncate = Enum.TextTruncate.AtEnd; Instance.new("UIPadding", btn).PaddingLeft = UDim.new(0, 15); AddRipple(btn); btn.MouseButton1Click:Connect(function() cb() end)
            end
            
            function FolderFuncs:AddSlider(txt, min, max, def, cb, flag)
                local val = def or min; if flag and NoxvaLib.Flags[flag] ~= nil then val = NoxvaLib.Flags[flag].Value end
                local ctn = Instance.new("Frame", ItemContainer); ctn.Size = UDim2.new(1, -20, 0, 50); ctn.Position = UDim2.new(0, 10, 0, 0); ctn.BackgroundColor3 = Color3.fromRGB(40, 40, 40); ctn.BackgroundTransparency = 0.5; Instance.new("UICorner", ctn).CornerRadius = UDim.new(0, 5)
                local lbl = Instance.new("TextLabel", ctn); lbl.Size = UDim2.new(1, -30, 0, 20); lbl.Position = UDim2.new(0, 15, 0, 5); lbl.BackgroundTransparency = 1; lbl.Text = txt .. " : " .. tostring(val); lbl.TextColor3 = Color3.fromRGB(230, 230, 230); lbl.Font = Enum.Font.GothamSemibold; lbl.TextSize = 12; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.TextTruncate = Enum.TextTruncate.AtEnd
                local bg = Instance.new("TextButton", ctn); bg.Size = UDim2.new(1, -30, 0, 6); bg.Position = UDim2.new(0, 15, 0, 32); bg.BackgroundColor3 = Color3.fromRGB(20, 20, 20); bg.Text = ""; Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)
                local fl = Instance.new("Frame", bg); fl.Size = UDim2.new((val - min)/(max - min), 0, 1, 0); fl.BackgroundColor3 = NoxvaLib.AccentColor; Instance.new("UICorner", fl).CornerRadius = UDim.new(1, 0)
                
                local function UpdateVisual(newVal)
                    val = math.clamp(math.floor(newVal), min, max); local p = (val - min) / (max - min); fl.Size = UDim2.new(p, 0, 1, 0); lbl.Text = txt .. " : " .. tostring(val); if flag then NoxvaLib.Flags[flag].Value = val end; cb(val)
                end
                
                if flag then NoxvaLib.Flags[flag] = {Value = val, Func = cb, Set = UpdateVisual} end
                local d = false
                bg.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then d = true; UpdateVisual(min + (max - min) * math.clamp((i.Position.X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1)) end end)
                UserInputService.InputChanged:Connect(function(i) if d and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then UpdateVisual(min + (max - min) * math.clamp((i.Position.X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1)) end end)
                UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then d = false end end)
                cb(val)
            end
            return FolderFuncs
        end

        return TabFunctions
    end

    -- ==========================================
    -- NEW CONFIG TAB: MULTI-SAVE & GAME ISOLATION
    -- ==========================================
    function WindowFunctions:MakeConfigTab()
        local ConfTab = WindowFunctions:MakeTab("⚙️ Settings")
        local GameFolder = "NoxvaHub/Configs/" .. tostring(game.PlaceId)
        
        if makefolder then
            pcall(function()
                makefolder("NoxvaHub")
                makefolder("NoxvaHub/Configs")
                makefolder(GameFolder)
            end)
        end

        ConfTab:AddSection("THEME CUSTOMIZATION")
        ConfTab:AddColorPicker("UI Theme Color", NoxvaLib.AccentColor, function(newColor)
            local oldColor = NoxvaLib.AccentColor
            NoxvaLib.AccentColor = newColor
            for _, element in pairs(NoxvaUI:GetDescendants()) do
                pcall(function()
                    if element:IsA("UIStroke") and element.Color == oldColor then
                        element.Color = newColor
                    elseif (element:IsA("TextLabel") or element:IsA("TextButton")) and element.TextColor3 == oldColor then
                        element.TextColor3 = newColor
                    elseif element:IsA("ScrollingFrame") and element.ScrollBarImageColor3 == oldColor then
                        element.ScrollBarImageColor3 = newColor
                    elseif element:IsA("Frame") and element.BackgroundColor3 == oldColor then
                        element.BackgroundColor3 = newColor
                    end
                end)
            end
        end, "HubThemeColor")

        ConfTab:AddSection("MULTI-CONFIG MANAGER")
        
        local SelectedConfig = "Default"
        ConfTab:AddTextbox("Config Name", "Ketik nama config...", function(t)
            if t ~= "" then
                SelectedConfig = t
            end
        end)

        ConfTab:AddButton("💾 Save Current Config", function()
            local dataToSave = {}
            for flagName, data in pairs(NoxvaLib.Flags) do 
                if typeof(data.Value) == "Color3" then
                    dataToSave[flagName] = {R = data.Value.R, G = data.Value.G, B = data.Value.B, IsColor = true}
                elseif type(data.Value) == "table" and data.Value.Key ~= nil then
                    dataToSave[flagName] = {State = data.Value.State, Key = data.Value.Key.Name} 
                else
                    dataToSave[flagName] = data.Value 
                end
            end
            local success, json = pcall(function() return HttpService:JSONEncode(dataToSave) end)
            if success and writefile then
                local path = GameFolder .. "/" .. SelectedConfig .. ".json"
                writefile(path, json)
                WindowFunctions:Notify("CONFIG", "Tersimpan: '"..SelectedConfig.."' (Game ID: "..tostring(game.PlaceId)..")", 3)
            else
                WindowFunctions:Notify("ERROR", "Executor lu gak support writefile!", 3)
            end
        end)

        ConfTab:AddLabel("Select Config to Load:")
        
        local function GetConfigs()
            local list = {}
            if listfiles then
                local success, files = pcall(function() return listfiles(GameFolder) end)
                if success and files then
                    for _, file in pairs(files) do
                        if file:sub(-5) == ".json" then
                            local name = file:match("([^/]+)%.json$") or file:match("([^\\]+)%.json$")
                            if name then table.insert(list, name) end
                        end
                    end
                end
            end
            if #list == 0 then table.insert(list, "Belum Ada Config") end
            return list
        end

        local ConfigDrop = ConfTab:AddDropdown("Stored Configs", GetConfigs(), function(v)
            SelectedConfig = v
        end)

        ConfTab:AddDoubleButton("Load Selected", function()
            local path = GameFolder .. "/" .. SelectedConfig .. ".json"
            if readfile and isfile and isfile(path) then
                local success, json = pcall(function() return readfile(path) end)
                if success then
                    local data = HttpService:JSONDecode(json)
                    for flagName, value in pairs(data) do
                        if NoxvaLib.Flags[flagName] and NoxvaLib.Flags[flagName].Set then
                            if type(value) == "table" and value.IsColor then
                                NoxvaLib.Flags[flagName].Set(Color3.new(value.R, value.G, value.B))
                            elseif type(value) == "table" and value.State ~= nil and value.Key ~= nil then
                                local loadedKey = Enum.KeyCode[value.Key] or Enum.KeyCode.E
                                NoxvaLib.Flags[flagName].Set({State = value.State, Key = loadedKey})
                            else
                                NoxvaLib.Flags[flagName].Set(value)
                            end
                        end
                    end
                    WindowFunctions:Notify("CONFIG", "Loaded: "..SelectedConfig, 3)
                end
            else
                WindowFunctions:Notify("ERROR", "File not found!", 3)
            end
        end, "Refresh List", function()
            WindowFunctions:Notify("INFO", "Re-execute script untuk memuat ulang daftar config.", 3)
        end)
    end

    return WindowFunctions
end

return NoxvaLib
