-- ============================================================
-- NOXVA UI ENGINE | PURE CORE LIBRARY V3.0
-- DEVELOPED BY DANZY | REBUILT & UPGRADED
-- NEW: ProgressBar, Image, InputSwitch, ConfirmDialog API,
--      AddTable, Console Levels, Full Folder support,
--      Live Config Refresh, Auto-Save, Tab Badges,
--      FPS/Ping toggle, cleaner modern aesthetic
-- ============================================================
local NoxvaLib = {}
NoxvaLib.Flags = {}
NoxvaLib.AccentColor = Color3.fromRGB(99, 102, 241) -- indigo-500

-- ============================================================
-- THEME CONSTANTS
-- ============================================================
local T = {
    BG        = Color3.fromRGB(10, 10, 12),
    SURFACE   = Color3.fromRGB(16, 16, 20),
    SURFACE2  = Color3.fromRGB(22, 22, 28),
    SURFACE3  = Color3.fromRGB(30, 30, 38),
    BORDER    = Color3.fromRGB(40, 40, 52),
    TEXT      = Color3.fromRGB(240, 240, 245),
    SUBTEXT   = Color3.fromRGB(140, 140, 160),
    MUTED     = Color3.fromRGB(80, 80, 100),
    SUCCESS   = Color3.fromRGB(52, 211, 153),
    WARNING   = Color3.fromRGB(251, 191, 36),
    DANGER    = Color3.fromRGB(248, 113, 113),
    INFO      = Color3.fromRGB(96, 165, 250),
}

function NoxvaLib:CreateWindow(CustomName, CustomColor)
    local HubTitle = CustomName or "NOXVA"
    NoxvaLib.AccentColor = CustomColor or NoxvaLib.AccentColor

    local CoreGui        = game:GetService("CoreGui")
    local RunService     = game:GetService("RunService")
    local UIS            = game:GetService("UserInputService")
    local TweenService   = game:GetService("TweenService")
    local HttpService    = game:GetService("HttpService")
    local Players        = game:GetService("Players")
    local StatsService   = game:GetService("Stats")
    local LocalPlayer    = Players.LocalPlayer

    -- ── helpers ─────────────────────────────────────────────
    local function Tween(obj, t, props, style, dir)
        style = style or Enum.EasingStyle.Quart
        dir   = dir   or Enum.EasingDirection.Out
        TweenService:Create(obj, TweenInfo.new(t, style, dir), props):Play()
    end

    local function Corner(parent, radius)
        local c = Instance.new("UICorner", parent)
        c.CornerRadius = UDim.new(0, radius or 6)
        return c
    end

    local function Stroke(parent, color, thickness, trans)
        local s = Instance.new("UIStroke", parent)
        s.Color       = color or T.BORDER
        s.Thickness   = thickness or 1
        s.Transparency = trans or 0
        return s
    end

    local function Pad(parent, l, r, t, b)
        local p = Instance.new("UIPadding", parent)
        p.PaddingLeft   = UDim.new(0, l or 0)
        p.PaddingRight  = UDim.new(0, r or 0)
        p.PaddingTop    = UDim.new(0, t or 0)
        p.PaddingBottom = UDim.new(0, b or 0)
        return p
    end

    local function List(parent, padding, align, ha)
        local l = Instance.new("UIListLayout", parent)
        l.SortOrder           = Enum.SortOrder.LayoutOrder
        l.Padding             = UDim.new(0, padding or 0)
        l.VerticalAlignment   = align or Enum.VerticalAlignment.Top
        l.HorizontalAlignment = ha    or Enum.HorizontalAlignment.Left
        return l
    end

    local function Label(parent, props)
        local l = Instance.new("TextLabel", parent)
        l.BackgroundTransparency = 1
        l.Font     = props.Font     or Enum.Font.GothamSemibold
        l.TextSize = props.TextSize or 12
        l.TextColor3 = props.Color  or T.TEXT
        l.Text       = props.Text   or ""
        l.Size       = props.Size   or UDim2.new(1,0,0,20)
        l.Position   = props.Position or UDim2.new(0,0,0,0)
        l.TextXAlignment = props.XAlign or Enum.TextXAlignment.Left
        l.TextYAlignment = props.YAlign or Enum.TextYAlignment.Center
        l.TextWrapped = props.Wrap or false
        l.TextTruncate = Enum.TextTruncate.AtEnd
        return l
    end

    local function Ripple(btn)
        btn.MouseButton1Down:Connect(function() Tween(btn, 0.1, {TextTransparency=0.4}) end)
        btn.MouseButton1Up:Connect(function()   Tween(btn, 0.15,{TextTransparency=0})   end)
        btn.MouseLeave:Connect(function()       Tween(btn, 0.15,{TextTransparency=0})   end)
    end

    local function MakeDraggable(frame, handle)
        local drag, dragInput, dragStart, startPos
        handle.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1
            or i.UserInputType == Enum.UserInputType.Touch then
                drag = true; dragStart = i.Position; startPos = frame.Position
                i.Changed:Connect(function()
                    if i.UserInputState == Enum.UserInputState.End then drag = false end
                end)
            end
        end)
        handle.InputChanged:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseMovement
            or i.UserInputType == Enum.UserInputType.Touch then dragInput = i end
        end)
        UIS.InputChanged:Connect(function(i)
            if i == dragInput and drag then
                local d = i.Position - dragStart
                frame.Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + d.X,
                    startPos.Y.Scale, startPos.Y.Offset + d.Y
                )
            end
        end)
    end

    -- ── root gui ────────────────────────────────────────────
    local NoxvaUI = Instance.new("ScreenGui")
    NoxvaUI.Name = "NoxvaHub_V3"
    NoxvaUI.ResetOnSpawn = false
    NoxvaUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local ok, hui = pcall(function() return gethui() end)
    local target = (ok and hui) and hui
        or (pcall(function() return CoreGui.Name end) and CoreGui)
        or (LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui"))
    if not target then return nil end
    local old = target:FindFirstChild("NoxvaHub_V3")
    if old then old:Destroy() end
    NoxvaUI.Parent = target

    -- ── notification container ───────────────────────────────
    local NotifContainer = Instance.new("Frame", NoxvaUI)
    NotifContainer.Name = "Notifs"
    NotifContainer.Size = UDim2.new(0, 260, 1, -20)
    NotifContainer.Position = UDim2.new(1, -270, 0, 10)
    NotifContainer.BackgroundTransparency = 1
    local NL = List(NotifContainer, 8)
    NL.VerticalAlignment = Enum.VerticalAlignment.Bottom

    -- ── floating stats (top-left, toggleable) ────────────────
    local StatsLabel = Instance.new("TextLabel", NoxvaUI)
    StatsLabel.Name = "StatsLabel"
    StatsLabel.Size = UDim2.new(0, 180, 0, 18)
    StatsLabel.Position = UDim2.new(0, 10, 0, 10)
    StatsLabel.BackgroundTransparency = 1
    StatsLabel.TextColor3 = T.SUBTEXT
    StatsLabel.Font = Enum.Font.GothamBold
    StatsLabel.TextSize = 11
    StatsLabel.TextXAlignment = Enum.TextXAlignment.Left
    StatsLabel.TextStrokeTransparency = 0.4
    StatsLabel.Visible = true

    local fpsFrames, fpsLast = 0, tick()
    RunService.RenderStepped:Connect(function()
        if not NoxvaUI.Parent then return end
        fpsFrames += 1
        if tick() - fpsLast >= 1 then
            local ping = 0
            pcall(function() ping = math.round(StatsService.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
            local txt = "FPS " .. fpsFrames .. "  ·  PING " .. ping .. "ms"
            StatsLabel.Text = txt
            fpsFrames = 0; fpsLast = tick()
        end
    end)

    -- ── minimized logo ───────────────────────────────────────
    local MiniLogo = Instance.new("Frame", NoxvaUI)
    MiniLogo.Size = UDim2.new(0, 44, 0, 44)
    MiniLogo.Position = UDim2.new(0.5, -22, 0, 16)
    MiniLogo.BackgroundColor3 = T.SURFACE2
    MiniLogo.BackgroundTransparency = 0
    MiniLogo.Visible = false
    Corner(MiniLogo, 10)
    Stroke(MiniLogo, NoxvaLib.AccentColor, 1.5)

    local MiniImg = Instance.new("ImageLabel", MiniLogo)
    MiniImg.Size = UDim2.new(0.7,0,0.7,0)
    MiniImg.Position = UDim2.new(0.15,0,0.15,0)
    MiniImg.BackgroundTransparency = 1
    MiniImg.Image = "rbxassetid://125602638236059"
    MiniImg.ScaleType = Enum.ScaleType.Fit

    local MiniBtn = Instance.new("TextButton", MiniLogo)
    MiniBtn.Size = UDim2.new(1,0,1,0)
    MiniBtn.BackgroundTransparency = 1
    MiniBtn.Text = ""
    MakeDraggable(MiniLogo, MiniBtn)

    -- ── main frame ───────────────────────────────────────────
    local Main = Instance.new("Frame", NoxvaUI)
    Main.Size = UDim2.new(0, 500, 0, 330)
    Main.Position = UDim2.new(0.5,-250,0.5,-165)
    Main.BackgroundColor3 = T.BG
    Main.BackgroundTransparency = 0
    Corner(Main, 10)
    Stroke(Main, T.BORDER, 1)

    -- subtle inner gradient
    local BgGrad = Instance.new("UIGradient", Main)
    BgGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(14,14,18)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(8,8,10)),
    })
    BgGrad.Rotation = 135

    -- ── topbar ───────────────────────────────────────────────
    local TopBar = Instance.new("Frame", Main)
    TopBar.Size = UDim2.new(1,0,0,42)
    TopBar.BackgroundColor3 = T.SURFACE
    TopBar.BackgroundTransparency = 0
    Corner(TopBar, 10)
    Stroke(TopBar, T.BORDER, 1)
    -- block bottom corners
    local TBBlock = Instance.new("Frame", TopBar)
    TBBlock.Size = UDim2.new(1,0,0,10)
    TBBlock.Position = UDim2.new(0,0,1,-10)
    TBBlock.BackgroundColor3 = T.SURFACE
    TBBlock.BorderSizePixel = 0

    -- accent line under topbar
    local AccentLine = Instance.new("Frame", TopBar)
    AccentLine.Size = UDim2.new(1,0,0,1)
    AccentLine.Position = UDim2.new(0,0,1,-1)
    AccentLine.BackgroundColor3 = NoxvaLib.AccentColor
    AccentLine.BackgroundTransparency = 0.6
    AccentLine.BorderSizePixel = 0

    -- dot decorations
    local function TopDot(xOff, col)
        local d = Instance.new("Frame", TopBar)
        d.Size = UDim2.new(0,7,0,7)
        d.Position = UDim2.new(0, xOff, 0.5, -3)
        d.BackgroundColor3 = col
        d.BorderSizePixel = 0
        Corner(d, 4)
    end
    TopDot(12, T.DANGER)
    TopDot(24, T.WARNING)
    TopDot(36, T.SUCCESS)

    local TitleLbl = Label(TopBar, {
        Text = HubTitle,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        Color = T.TEXT,
        Size = UDim2.new(0, 160, 1, 0),
        Position = UDim2.new(0, 52, 0, 0),
    })

    local TopStatLbl = Label(TopBar, {
        Text = "",
        Font = Enum.Font.GothamMedium,
        TextSize = 11,
        Color = T.MUTED,
        Size = UDim2.new(0, 160, 1, 0),
        Position = UDim2.new(0.5,-80,0,0),
        XAlign = Enum.TextXAlignment.Center,
    })

    -- connect stats to topbar too
    RunService.RenderStepped:Connect(function()
        TopStatLbl.Text = StatsLabel.Text
    end)

    -- control buttons (top-right)
    local function CtrlBtn(xOff, txt, color)
        local b = Instance.new("TextButton", TopBar)
        b.Size = UDim2.new(0,28,0,28)
        b.Position = UDim2.new(1,xOff,0.5,-14)
        b.BackgroundColor3 = T.SURFACE3
        b.Text = txt
        b.TextColor3 = color or T.SUBTEXT
        b.Font = Enum.Font.GothamBold
        b.TextSize = 14
        b.BorderSizePixel = 0
        Corner(b, 6)
        b.MouseEnter:Connect(function() Tween(b, 0.12, {BackgroundColor3 = T.BORDER}) end)
        b.MouseLeave:Connect(function() Tween(b, 0.12, {BackgroundColor3 = T.SURFACE3}) end)
        return b
    end
    local CloseBtn = CtrlBtn(-10, "×", T.DANGER)
    local MinBtn   = CtrlBtn(-44, "−", T.SUBTEXT)
    local StatsBtn = CtrlBtn(-78, "◉", T.INFO)  -- toggle floating stats

    StatsBtn.MouseButton1Click:Connect(function()
        StatsLabel.Visible = not StatsLabel.Visible
    end)

    MakeDraggable(Main, TopBar)
    MakeDraggable(MiniLogo, MiniBtn)

    MinBtn.MouseButton1Click:Connect(function()
        Tween(Main, 0.2, {Size = UDim2.new(0,500,0,0)})
        task.delay(0.2, function() Main.Visible = false; MiniLogo.Visible = true end)
    end)
    MiniBtn.MouseButton1Click:Connect(function()
        Main.Visible = true; MiniLogo.Visible = false
        Main.Size = UDim2.new(0,500,0,0)
        Tween(Main, 0.25, {Size = UDim2.new(0,500,0,330)})
    end)

    -- ── close confirmation ───────────────────────────────────
    local ConfirmOverlay = Instance.new("Frame", NoxvaUI)
    ConfirmOverlay.Size = UDim2.new(1,0,1,0)
    ConfirmOverlay.BackgroundColor3 = Color3.new(0,0,0)
    ConfirmOverlay.BackgroundTransparency = 1
    ConfirmOverlay.Visible = false

    local ConfirmBox = Instance.new("Frame", ConfirmOverlay)
    ConfirmBox.Size = UDim2.new(0, 300, 0, 140)
    ConfirmBox.Position = UDim2.new(0.5,-150,0.5,-70)
    ConfirmBox.BackgroundColor3 = T.SURFACE
    Corner(ConfirmBox, 10)
    Stroke(ConfirmBox, T.DANGER, 1.5)

    Label(ConfirmBox, {
        Text = "Close UI?",
        Font = Enum.Font.GothamBold,
        TextSize = 15,
        Color = T.TEXT,
        Size = UDim2.new(1,0,0,24),
        Position = UDim2.new(0,0,0,16),
        XAlign = Enum.TextXAlignment.Center,
    })
    Label(ConfirmBox, {
        Text = "UI akan dihapus. Logic tetap aktif.",
        TextSize = 11,
        Color = T.SUBTEXT,
        Size = UDim2.new(1,-40,0,18),
        Position = UDim2.new(0,20,0,44),
        XAlign = Enum.TextXAlignment.Center,
        Wrap = true,
    })

    local function ConfirmActionBtn(xOff, txt, bg)
        local b = Instance.new("TextButton", ConfirmBox)
        b.Size = UDim2.new(0,115,0,32)
        b.Position = UDim2.new(0,xOff,0,96)
        b.BackgroundColor3 = bg
        b.Text = txt
        b.TextColor3 = T.TEXT
        b.Font = Enum.Font.GothamBold
        b.TextSize = 12
        b.BorderSizePixel = 0
        Corner(b, 7)
        return b
    end
    local BtnAccept = ConfirmActionBtn(20,  "Ya, Tutup",  T.DANGER)
    local BtnCancel = ConfirmActionBtn(165, "Batal",      T.SURFACE3)

    CloseBtn.MouseButton1Click:Connect(function()
        Main.Visible = false
        ConfirmOverlay.Visible = true
        Tween(ConfirmOverlay, 0.2, {BackgroundTransparency=0.55})
    end)
    BtnAccept.MouseButton1Click:Connect(function() NoxvaUI:Destroy() end)
    BtnCancel.MouseButton1Click:Connect(function()
        Tween(ConfirmOverlay, 0.15, {BackgroundTransparency=1})
        task.delay(0.15, function() ConfirmOverlay.Visible = false; Main.Visible = true end)
    end)

    -- ── sidebar ──────────────────────────────────────────────
    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size = UDim2.new(0, 120, 1, -42)
    Sidebar.Position = UDim2.new(0, 0, 0, 42)
    Sidebar.BackgroundColor3 = T.SURFACE
    Sidebar.BorderSizePixel = 0

    -- right border on sidebar
    local SBorder = Instance.new("Frame", Sidebar)
    SBorder.Size = UDim2.new(0,1,1,0)
    SBorder.Position = UDim2.new(1,-1,0,0)
    SBorder.BackgroundColor3 = T.BORDER
    SBorder.BorderSizePixel = 0

    local SideList = List(Sidebar, 2)
    Pad(Sidebar, 6, 6, 8, 8)

    -- ── content area ─────────────────────────────────────────
    local ContentArea = Instance.new("Frame", Main)
    ContentArea.Size = UDim2.new(1,-120,1,-42)
    ContentArea.Position = UDim2.new(0,120,0,42)
    ContentArea.BackgroundTransparency = 1

    -- ── window api ───────────────────────────────────────────
    local WindowFunctions = {}
    local FirstTab = true

    -- ── notify ───────────────────────────────────────────────
    local NOTIF_COLORS = {
        SUCCESS = T.SUCCESS, ERROR = T.DANGER,
        WARNING = T.WARNING, INFO  = T.INFO,
        SYSTEM  = NoxvaLib.AccentColor, CONFIG = NoxvaLib.AccentColor,
        CONSOLE = T.SUBTEXT,
    }

    function WindowFunctions:Notify(Title, Text, Duration, Level)
        local accent = NOTIF_COLORS[Level or Title:upper()] or NoxvaLib.AccentColor
        local NF = Instance.new("Frame", NotifContainer)
        NF.Size = UDim2.new(1,0,0,62)
        NF.BackgroundColor3 = T.SURFACE
        NF.Position = UDim2.new(1,300,0,0)
        NF.BorderSizePixel = 0
        Corner(NF, 8)
        Stroke(NF, accent, 1.5)

        -- left accent bar
        local Bar = Instance.new("Frame", NF)
        Bar.Size = UDim2.new(0,3,1,-16)
        Bar.Position = UDim2.new(0,0,0,8)
        Bar.BackgroundColor3 = accent
        Bar.BorderSizePixel = 0
        Corner(Bar, 2)

        Label(NF, {
            Text = Title:upper(),
            Font = Enum.Font.GothamBold, TextSize = 11,
            Color = accent,
            Size = UDim2.new(1,-20,0,16),
            Position = UDim2.new(0,14,0,8),
        })
        Label(NF, {
            Text = Text,
            TextSize = 11,
            Color = T.SUBTEXT,
            Size = UDim2.new(1,-20,0,28),
            Position = UDim2.new(0,14,0,26),
            Wrap = true,
            YAlign = Enum.TextYAlignment.Top,
        })

        Tween(NF, 0.4, {Position = UDim2.new(0,0,0,0)})
        task.delay(Duration or 3, function()
            Tween(NF, 0.35, {Position = UDim2.new(1,300,0,0)})
            task.delay(0.4, function() NF:Destroy() end)
        end)
    end

    -- ── webhook ──────────────────────────────────────────────
    function WindowFunctions:SendWebhook(URL, EmbedData)
        local req = (syn and syn.request) or (http and http.request)
            or http_request or (fluxus and fluxus.request) or request
        if not req then warn("NoxvaHub: HTTP not supported") return end
        pcall(function()
            req({
                Url = URL, Method = "POST",
                Headers = {["Content-Type"]="application/json"},
                Body = HttpService:JSONEncode({embeds={EmbedData}}),
            })
        end)
    end

    -- ── anti-afk ─────────────────────────────────────────────
    function WindowFunctions:EnableAntiAFK()
        if getgenv().NoxvaAntiAFKLoaded then return end
        getgenv().NoxvaAntiAFKLoaded = true
        if LocalPlayer then
            LocalPlayer.Idled:Connect(function()
                local VU = game:GetService("VirtualUser")
                VU:CaptureController(); VU:ClickButton2(Vector2.new())
            end)
            self:Notify("SYSTEM","Anti-AFK aktif!",3)
        end
    end

    -- ── GLOBAL CONFIRM DIALOG API ─────────────────────────────
    -- Usage: WindowFunctions:ShowConfirm("Title","Desc", function(ok) end)
    function WindowFunctions:ShowConfirm(Title, Desc, Callback)
        local Overlay = Instance.new("Frame", NoxvaUI)
        Overlay.Size = UDim2.new(1,0,1,0)
        Overlay.BackgroundColor3 = Color3.new(0,0,0)
        Overlay.BackgroundTransparency = 0.55
        Overlay.ZIndex = 10

        local Box = Instance.new("Frame", Overlay)
        Box.Size = UDim2.new(0,300,0,145)
        Box.Position = UDim2.new(0.5,-150,0.5,-72)
        Box.BackgroundColor3 = T.SURFACE
        Box.ZIndex = 11
        Corner(Box,10)
        Stroke(Box, NoxvaLib.AccentColor, 1.5)

        Label(Box,{Text=Title,Font=Enum.Font.GothamBold,TextSize=15,Color=T.TEXT,Size=UDim2.new(1,0,0,24),Position=UDim2.new(0,0,0,16),XAlign=Enum.TextXAlignment.Center})
        Label(Box,{Text=Desc,TextSize=11,Color=T.SUBTEXT,Size=UDim2.new(1,-40,0,28),Position=UDim2.new(0,20,0,44),XAlign=Enum.TextXAlignment.Center,Wrap=true,YAlign=Enum.TextYAlignment.Top})

        local Yes = Instance.new("TextButton",Box)
        Yes.Size=UDim2.new(0,115,0,32);Yes.Position=UDim2.new(0,20,0,100)
        Yes.BackgroundColor3=NoxvaLib.AccentColor;Yes.Text="Confirm";Yes.TextColor3=T.TEXT
        Yes.Font=Enum.Font.GothamBold;Yes.TextSize=12;Yes.BorderSizePixel=0;Yes.ZIndex=12
        Corner(Yes,7)

        local No = Instance.new("TextButton",Box)
        No.Size=UDim2.new(0,115,0,32);No.Position=UDim2.new(0,165,0,100)
        No.BackgroundColor3=T.SURFACE3;No.Text="Cancel";No.TextColor3=T.SUBTEXT
        No.Font=Enum.Font.GothamBold;No.TextSize=12;No.BorderSizePixel=0;No.ZIndex=12
        Corner(No,7)

        Yes.MouseButton1Click:Connect(function() Overlay:Destroy(); if Callback then Callback(true) end end)
        No.MouseButton1Click:Connect(function()  Overlay:Destroy(); if Callback then Callback(false) end end)
    end

    -- ── TAB MAKER ────────────────────────────────────────────
    function WindowFunctions:MakeTab(TabName, TabIcon)
        -- sidebar button
        local TabBtn = Instance.new("TextButton", Sidebar)
        TabBtn.Size = UDim2.new(1,0,0,34)
        TabBtn.BackgroundColor3 = FirstTab and T.SURFACE3 or Color3.new(0,0,0)
        TabBtn.BackgroundTransparency = FirstTab and 0 or 1
        TabBtn.Text = (TabIcon and TabIcon.." " or "") .. TabName
        TabBtn.TextColor3 = FirstTab and T.TEXT or T.SUBTEXT
        TabBtn.Font = Enum.Font.GothamSemibold
        TabBtn.TextSize = 12
        TabBtn.BorderSizePixel = 0
        TabBtn.TextTruncate = Enum.TextTruncate.AtEnd
        Corner(TabBtn, 6)
        Pad(TabBtn, 10, 8, 0, 0)

        -- tab badge
        local Badge = Instance.new("TextLabel", TabBtn)
        Badge.Size = UDim2.new(0,16,0,16)
        Badge.Position = UDim2.new(1,-20,0.5,-8)
        Badge.BackgroundColor3 = NoxvaLib.AccentColor
        Badge.TextColor3 = T.TEXT
        Badge.Font = Enum.Font.GothamBold
        Badge.TextSize = 9
        Badge.Text = ""
        Badge.Visible = false
        Badge.ZIndex = 5
        Corner(Badge, 8)

        -- hover
        TabBtn.MouseEnter:Connect(function()
            if TabBtn.BackgroundTransparency == 1 then
                Tween(TabBtn, 0.12, {BackgroundTransparency=0.6, BackgroundColor3=T.SURFACE3})
            end
        end)
        TabBtn.MouseLeave:Connect(function()
            if TabBtn.BackgroundTransparency ~= 0 then
                Tween(TabBtn, 0.12, {BackgroundTransparency=1})
            end
        end)

        -- content page
        local TabPage = Instance.new("ScrollingFrame", ContentArea)
        TabPage.Size = UDim2.new(1,-12,1,-12)
        TabPage.Position = UDim2.new(0,6,0,6)
        TabPage.BackgroundTransparency = 1
        TabPage.ScrollBarThickness = 2
        TabPage.ScrollBarImageColor3 = T.BORDER
        TabPage.BorderSizePixel = 0
        TabPage.Visible = FirstTab

        local PageList = List(TabPage, 5)
        PageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabPage.CanvasSize = UDim2.new(0,0,0,PageList.AbsoluteContentSize.Y+8)
        end)

        if FirstTab then FirstTab = false end

        TabBtn.MouseButton1Click:Connect(function()
            for _, c in pairs(ContentArea:GetChildren()) do
                if c:IsA("ScrollingFrame") then c.Visible = false end
            end
            for _, c in pairs(Sidebar:GetChildren()) do
                if c:IsA("TextButton") then
                    c.TextColor3 = T.SUBTEXT
                    Tween(c, 0.12, {BackgroundTransparency=1})
                end
            end
            TabPage.Visible = true
            TabBtn.TextColor3 = T.TEXT
            Tween(TabBtn, 0.12, {BackgroundTransparency=0, BackgroundColor3=T.SURFACE3})
        end)

        -- ── shared element builder state ─────────────────────
        local SearchableElements = {}
        local TF = {} -- TabFunctions

        -- ── helper: item frame ───────────────────────────────
        local function ItemFrame(h, bg, autoh)
            local f = Instance.new("Frame", TabPage)
            f.Size = autoh and UDim2.new(1,0,0,0) or UDim2.new(1,0,0,h or 34)
            if autoh then f.AutomaticSize = Enum.AutomaticSize.Y end
            f.BackgroundColor3 = bg or T.SURFACE2
            f.BackgroundTransparency = 0
            f.BorderSizePixel = 0
            Corner(f, 6)
            Stroke(f, T.BORDER, 1, 0.4)
            return f
        end

        -- ── SEARCH BAR ───────────────────────────────────────
        function TF:AddSearchBar()
            local SF = ItemFrame(34)
            SF.BackgroundColor3 = T.SURFACE3
            local SBox = Instance.new("TextBox", SF)
            SBox.Size = UDim2.new(1,-32,1,-8)
            SBox.Position = UDim2.new(0,32,0,4)
            SBox.BackgroundTransparency = 1
            SBox.PlaceholderText = "Search..."
            SBox.PlaceholderColor3 = T.MUTED
            SBox.Text = ""
            SBox.TextColor3 = T.TEXT
            SBox.Font = Enum.Font.Gotham
            SBox.TextSize = 12
            SBox.TextXAlignment = Enum.TextXAlignment.Left
            SBox.ClearTextOnFocus = false

            local Icon = Label(SF,{Text="🔍",TextSize=13,Color=T.MUTED,Size=UDim2.new(0,24,1,0),Position=UDim2.new(0,6,0,0),XAlign=Enum.TextXAlignment.Center})
            SBox:GetPropertyChangedSignal("Text"):Connect(function()
                local q = SBox.Text:lower()
                for _, el in ipairs(SearchableElements) do
                    el.Frame.Visible = q=="" or el.Name:find(q,1,true)~=nil
                end
            end)
        end

        -- ── SECTION ──────────────────────────────────────────
        function TF:AddSection(txt)
            local SF = Instance.new("Frame", TabPage)
            SF.Size = UDim2.new(1,0,0,22)
            SF.BackgroundTransparency = 1

            local Line = Instance.new("Frame", SF)
            Line.Size = UDim2.new(0.3,0,0,1)
            Line.Position = UDim2.new(0,0,0.5,0)
            Line.BackgroundColor3 = T.BORDER
            Line.BorderSizePixel = 0

            local Line2 = Instance.new("Frame", SF)
            Line2.Size = UDim2.new(0.3,0,0,1)
            Line2.Position = UDim2.new(0.7,0,0.5,0)
            Line2.BackgroundColor3 = T.BORDER
            Line2.BorderSizePixel = 0

            Label(SF,{Text=txt:upper(),Font=Enum.Font.GothamBold,TextSize=9,Color=T.MUTED,
                Size=UDim2.new(0.4,0,1,0),Position=UDim2.new(0.3,0,0,0),
                XAlign=Enum.TextXAlignment.Center})

            table.insert(SearchableElements,{Frame=SF,Name=txt:lower()})
        end

        -- ── LABEL ────────────────────────────────────────────
        function TF:AddLabel(txt)
            local F = ItemFrame(nil, T.SURFACE2, true)
            local L = Label(F,{Text=txt,TextSize=12,Color=T.SUBTEXT,Size=UDim2.new(1,0,0,0),Wrap=true,YAlign=Enum.TextYAlignment.Top})
            L.AutomaticSize = Enum.AutomaticSize.Y
            Pad(L,12,12,8,8)
            table.insert(SearchableElements,{Frame=F,Name=txt:lower()})
            local LI={}
            function LI:SetText(t) L.Text=t; SearchableElements[#SearchableElements].Name=t:lower() end
            return LI
        end

        -- ── PARAGRAPH ────────────────────────────────────────
        function TF:AddParagraph(TitleTxt, DescTxt)
            local F = ItemFrame(nil, T.SURFACE2, true)
            local Inner = Instance.new("Frame",F)
            Inner.Size=UDim2.new(1,0,0,0); Inner.AutomaticSize=Enum.AutomaticSize.Y
            Inner.BackgroundTransparency=1
            List(Inner,4)
            Pad(Inner,12,12,10,10)

            local TL = Label(Inner,{Text=TitleTxt,Font=Enum.Font.GothamBold,TextSize=12,Color=T.TEXT,Size=UDim2.new(1,0,0,14)})
            local DL = Label(Inner,{Text=DescTxt,TextSize=11,Color=T.SUBTEXT,Size=UDim2.new(1,0,0,0),Wrap=true,YAlign=Enum.TextYAlignment.Top})
            DL.AutomaticSize=Enum.AutomaticSize.Y

            table.insert(SearchableElements,{Frame=F,Name=TitleTxt:lower()})
            local PF={}
            function PF:Set(t,d) TL.Text=t; DL.Text=d end
            return PF
        end

        -- ── IMAGE ─────────────────────────────────────────────
        function TF:AddImage(AssetId, ImageHeight, Caption)
            local h = ImageHeight or 80
            local F = ItemFrame(h + (Caption and 24 or 0))
            local Img = Instance.new("ImageLabel",F)
            Img.Size=UDim2.new(1,-4,0,h); Img.Position=UDim2.new(0,2,0,2)
            Img.BackgroundTransparency=1; Img.Image="rbxassetid://"..tostring(AssetId)
            Img.ScaleType=Enum.ScaleType.Fit
            if Caption then
                Label(F,{Text=Caption,TextSize=10,Color=T.MUTED,
                    Size=UDim2.new(1,0,0,20),Position=UDim2.new(0,0,0,h+2),
                    XAlign=Enum.TextXAlignment.Center})
            end
            table.insert(SearchableElements,{Frame=F,Name=(Caption or "image"):lower()})
        end

        -- ── PROGRESS BAR ─────────────────────────────────────
        function TF:AddProgressBar(txt, initVal, maxVal, color)
            local val = math.clamp(initVal or 0, 0, maxVal or 100)
            local max_ = maxVal or 100
            local col  = color or NoxvaLib.AccentColor

            local F = ItemFrame(46)
            local TitleRow = Instance.new("Frame",F)
            TitleRow.Size=UDim2.new(1,-16,0,18);TitleRow.Position=UDim2.new(0,8,0,6)
            TitleRow.BackgroundTransparency=1

            local TL = Label(TitleRow,{Text=txt,Font=Enum.Font.GothamSemibold,TextSize=11,Color=T.TEXT,Size=UDim2.new(0.7,0,1,0)})
            local VL = Label(TitleRow,{Text=tostring(val).." / "..tostring(max_),TextSize=10,Color=T.MUTED,
                Size=UDim2.new(0.3,0,1,0),XAlign=Enum.TextXAlignment.Right})

            local TrackBG = Instance.new("Frame",F)
            TrackBG.Size=UDim2.new(1,-16,0,5)
            TrackBG.Position=UDim2.new(0,8,0,30)
            TrackBG.BackgroundColor3=T.SURFACE3
            TrackBG.BorderSizePixel=0
            Corner(TrackBG,3)

            local Fill = Instance.new("Frame",TrackBG)
            Fill.Size=UDim2.new(val/max_,0,1,0)
            Fill.BackgroundColor3=col
            Fill.BorderSizePixel=0
            Corner(Fill,3)

            -- glow on fill
            local FG = Instance.new("UIGradient",Fill)
            FG.Color=ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.new(1,1,1)),
                ColorSequenceKeypoint.new(1, col),
            })
            FG.Transparency=NumberSequence.new({
                NumberSequenceKeypoint.new(0,0.3),
                NumberSequenceKeypoint.new(1,0),
            })

            table.insert(SearchableElements,{Frame=F,Name=txt:lower()})

            local PBI={}
            function PBI:Set(newVal)
                val=math.clamp(newVal,0,max_)
                Tween(Fill,0.3,{Size=UDim2.new(val/max_,0,1,0)})
                VL.Text=tostring(val).." / "..tostring(max_)
            end
            function PBI:SetMax(newMax) max_=newMax; self:Set(val) end
            return PBI
        end

        -- ── TABLE ────────────────────────────────────────────
        function TF:AddTable(Headers, Rows)
            local cols = #Headers
            local rowH = 26
            local totalH = rowH * (#Rows + 1) + 8

            local F = ItemFrame(totalH)
            F.ClipsDescendants = true

            -- header row
            local HRow = Instance.new("Frame",F)
            HRow.Size=UDim2.new(1,-8,0,rowH); HRow.Position=UDim2.new(0,4,0,4)
            HRow.BackgroundColor3=T.SURFACE3; HRow.BorderSizePixel=0
            Corner(HRow,5)

            for i,h in ipairs(Headers) do
                Label(HRow,{Text=h,Font=Enum.Font.GothamBold,TextSize=10,Color=NoxvaLib.AccentColor,
                    Size=UDim2.new(1/cols,0,1,0),
                    Position=UDim2.new((i-1)/cols,0,0,0),
                    XAlign=Enum.TextXAlignment.Center})
            end

            -- data rows
            for ri, row in ipairs(Rows) do
                local RRow = Instance.new("Frame",F)
                RRow.Size=UDim2.new(1,-8,0,rowH)
                RRow.Position=UDim2.new(0,4,0,4+rowH*ri)
                RRow.BackgroundColor3 = ri%2==0 and T.SURFACE2 or T.BG
                RRow.BackgroundTransparency = ri%2==0 and 0 or 0.3
                RRow.BorderSizePixel=0
                Corner(RRow,4)

                for ci, cell in ipairs(row) do
                    Label(RRow,{Text=tostring(cell),TextSize=10,Color=T.TEXT,
                        Size=UDim2.new(1/cols,0,1,0),
                        Position=UDim2.new((ci-1)/cols,0,0,0),
                        XAlign=Enum.TextXAlignment.Center})
                end
            end

            table.insert(SearchableElements,{Frame=F,Name=table.concat(Headers," "):lower()})
        end

        -- ── BUTTON ───────────────────────────────────────────
        function TF:AddButton(txt, cb, BtnColor)
            local F = ItemFrame(34)
            F.BackgroundColor3 = BtnColor and Color3.fromRGB(
                math.round(BtnColor.R*255*0.15),
                math.round(BtnColor.G*255*0.15),
                math.round(BtnColor.B*255*0.15)
            ) or T.SURFACE2

            local B = Instance.new("TextButton",F)
            B.Size=UDim2.new(1,0,1,0); B.BackgroundTransparency=1
            B.Text=txt; B.TextColor3=BtnColor or T.TEXT
            B.Font=Enum.Font.GothamSemibold; B.TextSize=12
            B.TextXAlignment=Enum.TextXAlignment.Left
            B.TextTruncate=Enum.TextTruncate.AtEnd
            Pad(B,12,12,0,0)
            Ripple(B)

            -- right arrow indicator
            Label(F,{Text="›",TextSize=16,Color=T.MUTED,
                Size=UDim2.new(0,20,1,0),
                Position=UDim2.new(1,-24,0,0),
                XAlign=Enum.TextXAlignment.Center})

            B.MouseEnter:Connect(function() Tween(F,0.1,{BackgroundColor3=T.SURFACE3}) end)
            B.MouseLeave:Connect(function() Tween(F,0.1,{BackgroundColor3=BtnColor and Color3.fromRGB(
                math.round(BtnColor.R*255*0.15),math.round(BtnColor.G*255*0.15),math.round(BtnColor.B*255*0.15)
            ) or T.SURFACE2}) end)
            B.MouseButton1Click:Connect(function() cb() end)
            table.insert(SearchableElements,{Frame=F,Name=txt:lower()})
        end

        -- ── DOUBLE BUTTON ────────────────────────────────────
        function TF:AddDoubleButton(t1,cb1,t2,cb2)
            local C = Instance.new("Frame",TabPage)
            C.Size=UDim2.new(1,0,0,34); C.BackgroundTransparency=1

            local function Half(off,txt,cb)
                local F=Instance.new("Frame",C)
                F.Size=UDim2.new(0.5,-3,1,0); F.Position=UDim2.new(0,off,0,0)
                F.BackgroundColor3=T.SURFACE2; F.BorderSizePixel=0
                Corner(F,6); Stroke(F,T.BORDER,1,0.4)
                local B=Instance.new("TextButton",F)
                B.Size=UDim2.new(1,0,1,0); B.BackgroundTransparency=1
                B.Text=txt; B.TextColor3=T.TEXT
                B.Font=Enum.Font.GothamSemibold; B.TextSize=12
                B.TextTruncate=Enum.TextTruncate.AtEnd
                Ripple(B)
                B.MouseEnter:Connect(function() Tween(F,0.1,{BackgroundColor3=T.SURFACE3}) end)
                B.MouseLeave:Connect(function() Tween(F,0.1,{BackgroundColor3=T.SURFACE2}) end)
                B.MouseButton1Click:Connect(function() cb() end)
            end
            Half(0,t1,cb1); Half(UDim2.new(0.5,3,0,0).X.Offset+UDim2.new(0.5,0,0,0).X.Scale > 0 and 3 or 3,t2,cb2)
            -- simple positional fix:
            local F2=C:GetChildren()[2]; if F2 then F2.Position=UDim2.new(0.5,3,0,0) end
            table.insert(SearchableElements,{Frame=C,Name=t1:lower().." "..t2:lower()})
        end

        -- ── TOGGLE ───────────────────────────────────────────
        function TF:AddToggle(txt, def, cb, Flag)
            local state = def or false
            if Flag and NoxvaLib.Flags[Flag] then state = NoxvaLib.Flags[Flag].Value end

            local F = ItemFrame(34)
            local B = Instance.new("TextButton",F)
            B.Size=UDim2.new(1,-60,1,0); B.BackgroundTransparency=1
            B.Text=txt; B.TextColor3=T.TEXT
            B.Font=Enum.Font.GothamSemibold; B.TextSize=12
            B.TextXAlignment=Enum.TextXAlignment.Left
            B.TextTruncate=Enum.TextTruncate.AtEnd
            Pad(B,12,0,0,0)
            Ripple(B)

            -- pill toggle
            local Pill = Instance.new("Frame",F)
            Pill.Size=UDim2.new(0,36,0,18); Pill.Position=UDim2.new(1,-48,0.5,-9)
            Pill.BackgroundColor3 = state and NoxvaLib.AccentColor or T.SURFACE3
            Pill.BorderSizePixel=0
            Corner(Pill,9)

            local Knob = Instance.new("Frame",Pill)
            Knob.Size=UDim2.new(0,12,0,12); Knob.Position=state and UDim2.new(1,-15,0.5,-6) or UDim2.new(0,3,0.5,-6)
            Knob.BackgroundColor3=T.TEXT; Knob.BorderSizePixel=0
            Corner(Knob,6)

            local function UpdateToggle(newState)
                state=newState
                Tween(Pill,0.2,{BackgroundColor3=state and NoxvaLib.AccentColor or T.SURFACE3})
                Tween(Knob,0.2,{Position=state and UDim2.new(1,-15,0.5,-6) or UDim2.new(0,3,0.5,-6)})
                if Flag then NoxvaLib.Flags[Flag].Value=state end
                cb(state)
            end

            if Flag then NoxvaLib.Flags[Flag]={Value=state,Func=cb,Set=UpdateToggle} end
            if state then cb(state) end

            B.MouseButton1Click:Connect(function() UpdateToggle(not state) end)
            Pill.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then UpdateToggle(not state) end end)
            table.insert(SearchableElements,{Frame=F,Name=txt:lower()})
        end

        -- ── HYBRID TOGGLE (with keybind) ──────────────────────
        function TF:AddHybridToggle(txt, defState, defKey, cb, Flag)
            local state = defState or false
            local key   = defKey or Enum.KeyCode.E
            if Flag and NoxvaLib.Flags[Flag] then
                local v = NoxvaLib.Flags[Flag].Value
                if type(v)=="table" then state=v.State; key=v.Key end
            end

            local F = ItemFrame(34)
            local B = Instance.new("TextButton",F)
            B.Size=UDim2.new(1,-100,1,0); B.BackgroundTransparency=1
            B.Text=txt; B.TextColor3=T.TEXT
            B.Font=Enum.Font.GothamSemibold; B.TextSize=12
            B.TextXAlignment=Enum.TextXAlignment.Left
            B.TextTruncate=Enum.TextTruncate.AtEnd
            Pad(B,12,0,0,0)
            Ripple(B)

            local Pill=Instance.new("Frame",F)
            Pill.Size=UDim2.new(0,36,0,18); Pill.Position=UDim2.new(1,-94,0.5,-9)
            Pill.BackgroundColor3=state and NoxvaLib.AccentColor or T.SURFACE3
            Pill.BorderSizePixel=0; Corner(Pill,9)

            local Knob=Instance.new("Frame",Pill)
            Knob.Size=UDim2.new(0,12,0,12)
            Knob.Position=state and UDim2.new(1,-15,0.5,-6) or UDim2.new(0,3,0.5,-6)
            Knob.BackgroundColor3=T.TEXT; Knob.BorderSizePixel=0; Corner(Knob,6)

            local BindBtn=Instance.new("TextButton",F)
            BindBtn.Size=UDim2.new(0,46,0,22); BindBtn.Position=UDim2.new(1,-52,0.5,-11)
            BindBtn.BackgroundColor3=T.SURFACE3; BindBtn.Text=key.Name
            BindBtn.TextColor3=NoxvaLib.AccentColor; BindBtn.Font=Enum.Font.GothamBold; BindBtn.TextSize=10
            BindBtn.BorderSizePixel=0; Corner(BindBtn,5)

            local function Upd(v)
                state=v.State; key=v.Key
                Tween(Pill,0.2,{BackgroundColor3=state and NoxvaLib.AccentColor or T.SURFACE3})
                Tween(Knob,0.2,{Position=state and UDim2.new(1,-15,0.5,-6) or UDim2.new(0,3,0.5,-6)})
                BindBtn.Text=key.Name
                if Flag then NoxvaLib.Flags[Flag].Value={State=state,Key=key} end
                cb(state)
            end
            if Flag then NoxvaLib.Flags[Flag]={Value={State=state,Key=key},Func=cb,Set=Upd} end
            if state then cb(state) end

            B.MouseButton1Click:Connect(function() Upd({State=not state,Key=key}) end)
            Pill.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then Upd({State=not state,Key=key}) end end)

            local binding=false
            BindBtn.MouseButton1Click:Connect(function() BindBtn.Text="···"; binding=true end)
            UIS.InputBegan:Connect(function(i,gp)
                if binding and i.UserInputType==Enum.UserInputType.Keyboard then
                    binding=false; Upd({State=state,Key=i.KeyCode})
                elseif not gp and i.KeyCode==key and not binding then
                    Upd({State=not state,Key=key})
                end
            end)
            table.insert(SearchableElements,{Frame=F,Name=txt:lower()})
        end

        -- ── SLIDER ───────────────────────────────────────────
        function TF:AddSlider(txt, min, max, def, cb, Flag)
            local val = def or min
            if Flag and NoxvaLib.Flags[Flag] then val=NoxvaLib.Flags[Flag].Value end

            local F = ItemFrame(48)
            local TitleRow=Instance.new("Frame",F)
            TitleRow.Size=UDim2.new(1,-16,0,18); TitleRow.Position=UDim2.new(0,8,0,6)
            TitleRow.BackgroundTransparency=1

            local TL=Label(TitleRow,{Text=txt,Font=Enum.Font.GothamSemibold,TextSize=11,Color=T.TEXT,Size=UDim2.new(0.7,0,1,0)})
            local VL=Label(TitleRow,{Text=tostring(val),TextSize=11,Color=NoxvaLib.AccentColor,
                Size=UDim2.new(0.3,0,1,0),XAlign=Enum.TextXAlignment.Right})

            local Track=Instance.new("TextButton",F)
            Track.Size=UDim2.new(1,-16,0,5); Track.Position=UDim2.new(0,8,0,32)
            Track.BackgroundColor3=T.SURFACE3; Track.Text=""; Track.BorderSizePixel=0
            Corner(Track,3)

            local Fill=Instance.new("Frame",Track)
            Fill.Size=UDim2.new((val-min)/(max-min),0,1,0)
            Fill.BackgroundColor3=NoxvaLib.AccentColor
            Fill.BorderSizePixel=0; Corner(Fill,3)

            local FGrad=Instance.new("UIGradient",Fill)
            FGrad.Color=ColorSequence.new({
                ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),
                ColorSequenceKeypoint.new(1,NoxvaLib.AccentColor),
            })
            FGrad.Transparency=NumberSequence.new({
                NumberSequenceKeypoint.new(0,0.4),
                NumberSequenceKeypoint.new(1,0),
            })

            -- thumb dot
            local Thumb=Instance.new("Frame",Track)
            Thumb.Size=UDim2.new(0,11,0,11); Thumb.AnchorPoint=Vector2.new(0.5,0.5)
            Thumb.Position=UDim2.new((val-min)/(max-min),0,0.5,0)
            Thumb.BackgroundColor3=T.TEXT; Thumb.BorderSizePixel=0; Corner(Thumb,6)
            Stroke(Thumb,NoxvaLib.AccentColor,1.5)

            local function Upd(newVal)
                val=math.clamp(math.floor(newVal),min,max)
                local p=(val-min)/(max-min)
                Tween(Fill,0.05,{Size=UDim2.new(p,0,1,0)})
                Tween(Thumb,0.05,{Position=UDim2.new(p,0,0.5,0)})
                VL.Text=tostring(val)
                if Flag then NoxvaLib.Flags[Flag].Value=val end
                cb(val)
            end
            if Flag then NoxvaLib.Flags[Flag]={Value=val,Func=cb,Set=Upd} end
            cb(val)

            local d=false
            Track.InputBegan:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
                    d=true; Upd(min+(max-min)*math.clamp((i.Position.X-Track.AbsolutePosition.X)/Track.AbsoluteSize.X,0,1))
                end
            end)
            UIS.InputChanged:Connect(function(i)
                if d and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
                    Upd(min+(max-min)*math.clamp((i.Position.X-Track.AbsolutePosition.X)/Track.AbsoluteSize.X,0,1))
                end
            end)
            UIS.InputEnded:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then d=false end
            end)
            table.insert(SearchableElements,{Frame=F,Name=txt:lower()})
        end

        -- ── KEYBIND ──────────────────────────────────────────
        function TF:AddKeybind(txt, defKey, cb)
            local key=defKey or Enum.KeyCode.E
            local F=ItemFrame(34)
            Label(F,{Text=txt,Font=Enum.Font.GothamSemibold,TextSize=12,Color=T.TEXT,
                Size=UDim2.new(0.6,0,1,0),Position=UDim2.new(0,12,0,0)})

            local BB=Instance.new("TextButton",F)
            BB.Size=UDim2.new(0,70,0,22); BB.Position=UDim2.new(1,-82,0.5,-11)
            BB.BackgroundColor3=T.SURFACE3; BB.Text=key.Name
            BB.TextColor3=NoxvaLib.AccentColor; BB.Font=Enum.Font.GothamBold; BB.TextSize=10
            BB.BorderSizePixel=0; Corner(BB,5)

            local binding=false
            BB.MouseButton1Click:Connect(function() BB.Text="···"; binding=true end)
            UIS.InputBegan:Connect(function(i,gp)
                if binding and i.UserInputType==Enum.UserInputType.Keyboard then
                    key=i.KeyCode; BB.Text=key.Name; binding=false
                elseif not gp and i.KeyCode==key and not binding then
                    cb()
                end
            end)
            table.insert(SearchableElements,{Frame=F,Name=txt:lower()})
        end

        -- ── TEXTBOX ──────────────────────────────────────────
        function TF:AddTextbox(txt, placeholder, cb, Flag)
            local val=""
            if Flag and NoxvaLib.Flags[Flag] then val=NoxvaLib.Flags[Flag].Value end
            local F=ItemFrame(34)
            Label(F,{Text=txt,Font=Enum.Font.GothamSemibold,TextSize=12,Color=T.TEXT,
                Size=UDim2.new(0.45,0,1,0),Position=UDim2.new(0,12,0,0)})

            local TB=Instance.new("TextBox",F)
            TB.Size=UDim2.new(0.5,-10,0,24); TB.Position=UDim2.new(0.5,0,0.5,-12)
            TB.BackgroundColor3=T.SURFACE3; TB.PlaceholderText=placeholder or ""
            TB.PlaceholderColor3=T.MUTED; TB.Text=val
            TB.TextColor3=T.TEXT; TB.Font=Enum.Font.Gotham; TB.TextSize=11
            TB.ClearTextOnFocus=false; TB.BorderSizePixel=0
            Corner(TB,5); Pad(TB,8,8,0,0)
            Stroke(TB,T.BORDER,1,0.3)

            local function Upd(v)
                val=v; TB.Text=v
                if Flag then NoxvaLib.Flags[Flag].Value=v end
                cb(v)
            end
            if Flag then NoxvaLib.Flags[Flag]={Value=val,Func=cb,Set=Upd} end
            if val~="" then cb(val) end
            TB.FocusLost:Connect(function() Upd(TB.Text) end)

            TB.Focused:Connect(function() Tween(TB,0.15,{BackgroundColor3=T.BORDER}) end)
            TB.FocusLost:Connect(function() Tween(TB,0.15,{BackgroundColor3=T.SURFACE3}) end)
            table.insert(SearchableElements,{Frame=F,Name=txt:lower()})
        end

        -- ── INPUT SWITCH ─────────────────────────────────────
        -- Like AddTextbox but with an action button on the right
        function TF:AddInputSwitch(LabelTxt, Placeholder, BtnTxt, cb)
            local F=ItemFrame(34)
            Label(F,{Text=LabelTxt,Font=Enum.Font.GothamSemibold,TextSize=11,Color=T.TEXT,
                Size=UDim2.new(0.3,0,1,0),Position=UDim2.new(0,10,0,0)})

            local TB=Instance.new("TextBox",F)
            TB.Size=UDim2.new(0.42,0,0,24); TB.Position=UDim2.new(0.3,4,0.5,-12)
            TB.BackgroundColor3=T.SURFACE3; TB.PlaceholderText=Placeholder or ""
            TB.PlaceholderColor3=T.MUTED; TB.Text=""
            TB.TextColor3=T.TEXT; TB.Font=Enum.Font.Gotham; TB.TextSize=11
            TB.ClearTextOnFocus=false; TB.BorderSizePixel=0
            Corner(TB,5); Pad(TB,6,6,0,0)

            local ActBtn=Instance.new("TextButton",F)
            ActBtn.Size=UDim2.new(0,60,0,24); ActBtn.Position=UDim2.new(1,-72,0.5,-12)
            ActBtn.BackgroundColor3=NoxvaLib.AccentColor; ActBtn.Text=BtnTxt or "Go"
            ActBtn.TextColor3=T.TEXT; ActBtn.Font=Enum.Font.GothamBold; ActBtn.TextSize=11
            ActBtn.BorderSizePixel=0; Corner(ActBtn,5)
            Ripple(ActBtn)
            ActBtn.MouseEnter:Connect(function() Tween(ActBtn,0.1,{BackgroundTransparency=0.2}) end)
            ActBtn.MouseLeave:Connect(function() Tween(ActBtn,0.1,{BackgroundTransparency=0}) end)
            ActBtn.MouseButton1Click:Connect(function() cb(TB.Text) end)
            TB.FocusLost:Connect(function(enterPressed) if enterPressed then cb(TB.Text) end end)
            table.insert(SearchableElements,{Frame=F,Name=LabelTxt:lower()})
        end

        -- ── DROPDOWN ─────────────────────────────────────────
        function TF:AddDropdown(txt, opts, cb, Flag)
            local sel=opts[1]
            if Flag and NoxvaLib.Flags[Flag] then sel=NoxvaLib.Flags[Flag].Value end

            local F=ItemFrame(34)
            F.ClipsDescendants=true

            local Header=Instance.new("TextButton",F)
            Header.Size=UDim2.new(1,0,0,34); Header.BackgroundTransparency=1
            Header.Text=txt.."   ·   "..(tostring(sel) or "")
            Header.TextColor3=T.TEXT; Header.Font=Enum.Font.GothamSemibold; Header.TextSize=12
            Header.TextXAlignment=Enum.TextXAlignment.Left; Header.TextTruncate=Enum.TextTruncate.AtEnd
            Pad(Header,12,36,0,0)
            Ripple(Header)

            -- chevron
            local Chev=Label(F,{Text="⌄",TextSize=14,Color=T.MUTED,
                Size=UDim2.new(0,24,0,34),Position=UDim2.new(1,-28,0,0),
                XAlign=Enum.TextXAlignment.Center})

            local DrpScroll=Instance.new("ScrollingFrame",F)
            DrpScroll.Size=UDim2.new(1,0,1,-34); DrpScroll.Position=UDim2.new(0,0,0,34)
            DrpScroll.BackgroundTransparency=1; DrpScroll.ScrollBarThickness=2
            DrpScroll.ScrollBarImageColor3=T.MUTED
            List(DrpScroll,1)

            local isOpen=false
            local function Upd(v)
                sel=v; Header.Text=txt.."   ·   "..tostring(sel)
                isOpen=false; Tween(F,0.2,{Size=UDim2.new(1,0,0,34)})
                Tween(Chev,0.15,{Rotation=0})
                if Flag then NoxvaLib.Flags[Flag].Value=sel end
                cb(sel)
            end
            if Flag then NoxvaLib.Flags[Flag]={Value=sel,Func=cb,Set=Upd} end

            Header.MouseButton1Click:Connect(function()
                isOpen=not isOpen
                if isOpen then
                    local h=34+math.min(#opts,5)*28
                    Tween(F,0.2,{Size=UDim2.new(1,0,0,h)})
                    Tween(Chev,0.15,{Rotation=180})
                    DrpScroll.CanvasSize=UDim2.new(0,0,0,#opts*28)
                else
                    Tween(F,0.2,{Size=UDim2.new(1,0,0,34)})
                    Tween(Chev,0.15,{Rotation=0})
                end
            end)
            for _,opt in ipairs(opts) do
                local OB=Instance.new("TextButton",DrpScroll)
                OB.Size=UDim2.new(1,0,0,28); OB.BackgroundTransparency=1
                OB.Text=tostring(opt); OB.TextColor3=T.SUBTEXT
                OB.Font=Enum.Font.Gotham; OB.TextSize=12
                OB.TextXAlignment=Enum.TextXAlignment.Left; OB.TextTruncate=Enum.TextTruncate.AtEnd
                Pad(OB,20,0,0,0)
                OB.MouseEnter:Connect(function() OB.TextColor3=T.TEXT end)
                OB.MouseLeave:Connect(function() OB.TextColor3=T.SUBTEXT end)
                Ripple(OB)
                OB.MouseButton1Click:Connect(function() Upd(opt) end)
            end
            if sel then cb(sel) end
            table.insert(SearchableElements,{Frame=F,Name=txt:lower()})

            -- return control to update options
            local DI={}
            function DI:SetOptions(newOpts)
                for _,c in pairs(DrpScroll:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
                for _,opt in ipairs(newOpts) do
                    local OB=Instance.new("TextButton",DrpScroll)
                    OB.Size=UDim2.new(1,0,0,28); OB.BackgroundTransparency=1
                    OB.Text=tostring(opt); OB.TextColor3=T.SUBTEXT
                    OB.Font=Enum.Font.Gotham; OB.TextSize=12
                    OB.TextXAlignment=Enum.TextXAlignment.Left; OB.TextTruncate=Enum.TextTruncate.AtEnd
                    Pad(OB,20,0,0,0)
                    OB.MouseEnter:Connect(function() OB.TextColor3=T.TEXT end)
                    OB.MouseLeave:Connect(function() OB.TextColor3=T.SUBTEXT end)
                    Ripple(OB)
                    OB.MouseButton1Click:Connect(function() Upd(opt) end)
                end
                DrpScroll.CanvasSize=UDim2.new(0,0,0,#newOpts*28)
            end
            return DI
        end

        -- ── PLAYER DROPDOWN ───────────────────────────────────
        function TF:AddPlayerDropdown(txt, defSel, cb, Flag)
            local sel=defSel or "None"
            if Flag and NoxvaLib.Flags[Flag] then sel=NoxvaLib.Flags[Flag].Value end

            local F=ItemFrame(34); F.ClipsDescendants=true

            local Header=Instance.new("TextButton",F)
            Header.Size=UDim2.new(1,0,0,34); Header.BackgroundTransparency=1
            Header.Text=txt.."   ·   "..tostring(sel)
            Header.TextColor3=T.TEXT; Header.Font=Enum.Font.GothamSemibold; Header.TextSize=12
            Header.TextXAlignment=Enum.TextXAlignment.Left; Header.TextTruncate=Enum.TextTruncate.AtEnd
            Pad(Header,12,36,0,0)
            Ripple(Header)

            local Chev=Label(F,{Text="⌄",TextSize=14,Color=T.MUTED,
                Size=UDim2.new(0,24,0,34),Position=UDim2.new(1,-28,0,0),
                XAlign=Enum.TextXAlignment.Center})

            local DrpScroll=Instance.new("ScrollingFrame",F)
            DrpScroll.Size=UDim2.new(1,0,1,-34); DrpScroll.Position=UDim2.new(0,0,0,34)
            DrpScroll.BackgroundTransparency=1; DrpScroll.ScrollBarThickness=2
            DrpScroll.ScrollBarImageColor3=T.MUTED
            List(DrpScroll,1)

            local isOpen=false
            local function Upd(v)
                sel=v; Header.Text=txt.."   ·   "..tostring(sel)
                isOpen=false; Tween(F,0.2,{Size=UDim2.new(1,0,0,34)})
                Tween(Chev,0.15,{Rotation=0})
                if Flag then NoxvaLib.Flags[Flag].Value=sel end
                cb(sel)
            end
            if Flag then NoxvaLib.Flags[Flag]={Value=sel,Func=cb,Set=Upd} end

            local function Repopulate()
                for _,c in pairs(DrpScroll:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
                local plist=Players:GetPlayers()
                for _,p in ipairs(plist) do
                    local OB=Instance.new("TextButton",DrpScroll)
                    OB.Size=UDim2.new(1,0,0,28); OB.BackgroundTransparency=1
                    OB.Text=p.Name; OB.TextColor3=T.SUBTEXT
                    OB.Font=Enum.Font.Gotham; OB.TextSize=12
                    OB.TextXAlignment=Enum.TextXAlignment.Left; OB.TextTruncate=Enum.TextTruncate.AtEnd
                    Pad(OB,20,0,0,0)
                    OB.MouseEnter:Connect(function() OB.TextColor3=T.TEXT end)
                    OB.MouseLeave:Connect(function() OB.TextColor3=T.SUBTEXT end)
                    Ripple(OB)
                    OB.MouseButton1Click:Connect(function() Upd(p.Name) end)
                end
                DrpScroll.CanvasSize=UDim2.new(0,0,0,#plist*28)
                return #plist
            end

            Header.MouseButton1Click:Connect(function()
                isOpen=not isOpen
                if isOpen then
                    local n=Repopulate()
                    Tween(F,0.2,{Size=UDim2.new(1,0,0,34+math.min(n,5)*28)})
                    Tween(Chev,0.15,{Rotation=180})
                else
                    Tween(F,0.2,{Size=UDim2.new(1,0,0,34)})
                    Tween(Chev,0.15,{Rotation=0})
                end
            end)
            if sel~="None" then cb(sel) end
            table.insert(SearchableElements,{Frame=F,Name=txt:lower()})
        end

        -- ── MULTI DROPDOWN ───────────────────────────────────
        function TF:AddMultiDropdown(txt, opts, defSel, cb, Flag)
            local sel=defSel or {}
            if Flag and NoxvaLib.Flags[Flag] then sel=NoxvaLib.Flags[Flag].Value end

            local function SelStr()
                if #sel==0 then return "None" end
                local s=table.concat(sel,", ")
                return #s>22 and s:sub(1,19).."..." or s
            end

            local F=ItemFrame(34); F.ClipsDescendants=true

            local Header=Instance.new("TextButton",F)
            Header.Size=UDim2.new(1,0,0,34); Header.BackgroundTransparency=1
            Header.Text=txt.."   ·   "..SelStr()
            Header.TextColor3=T.TEXT; Header.Font=Enum.Font.GothamSemibold; Header.TextSize=12
            Header.TextXAlignment=Enum.TextXAlignment.Left; Header.TextTruncate=Enum.TextTruncate.AtEnd
            Pad(Header,12,36,0,0)

            local Chev=Label(F,{Text="⌄",TextSize=14,Color=T.MUTED,
                Size=UDim2.new(0,24,0,34),Position=UDim2.new(1,-28,0,0),
                XAlign=Enum.TextXAlignment.Center})

            local DrpScroll=Instance.new("ScrollingFrame",F)
            DrpScroll.Size=UDim2.new(1,0,1,-34); DrpScroll.Position=UDim2.new(0,0,0,34)
            DrpScroll.BackgroundTransparency=1; DrpScroll.ScrollBarThickness=2
            DrpScroll.ScrollBarImageColor3=T.MUTED
            List(DrpScroll,1)

            local function Upd(newSel)
                sel=newSel; Header.Text=txt.."   ·   "..SelStr()
                for _,c in pairs(DrpScroll:GetChildren()) do
                    if c:IsA("TextButton") then
                        c.TextColor3=table.find(sel,c.Text) and NoxvaLib.AccentColor or T.SUBTEXT
                    end
                end
                if Flag then NoxvaLib.Flags[Flag].Value=sel end
                cb(sel)
            end
            if Flag then NoxvaLib.Flags[Flag]={Value=sel,Func=cb,Set=Upd} end

            local isOpen=false
            Header.MouseButton1Click:Connect(function()
                isOpen=not isOpen
                if isOpen then
                    Tween(F,0.2,{Size=UDim2.new(1,0,0,34+math.min(#opts,5)*28)})
                    Tween(Chev,0.15,{Rotation=180})
                    DrpScroll.CanvasSize=UDim2.new(0,0,0,#opts*28)
                else
                    Tween(F,0.2,{Size=UDim2.new(1,0,0,34)})
                    Tween(Chev,0.15,{Rotation=0})
                end
            end)
            for _,opt in ipairs(opts) do
                local OB=Instance.new("TextButton",DrpScroll)
                OB.Size=UDim2.new(1,0,0,28); OB.BackgroundTransparency=1
                OB.Text=tostring(opt)
                OB.TextColor3=table.find(sel,opt) and NoxvaLib.AccentColor or T.SUBTEXT
                OB.Font=Enum.Font.Gotham; OB.TextSize=12
                OB.TextXAlignment=Enum.TextXAlignment.Left; OB.TextTruncate=Enum.TextTruncate.AtEnd
                Pad(OB,20,0,0,0)
                OB.MouseEnter:Connect(function() if not table.find(sel,opt) then OB.TextColor3=T.TEXT end end)
                OB.MouseLeave:Connect(function() OB.TextColor3=table.find(sel,opt) and NoxvaLib.AccentColor or T.SUBTEXT end)
                OB.MouseButton1Click:Connect(function()
                    local idx=table.find(sel,opt)
                    if idx then table.remove(sel,idx) else table.insert(sel,opt) end
                    Upd(sel)
                end)
            end
            if #sel>0 then cb(sel) end
            table.insert(SearchableElements,{Frame=F,Name=txt:lower()})
        end

        -- ── COLOR PICKER ─────────────────────────────────────
        function TF:AddColorPicker(txt, defColor, cb, Flag)
            local color=defColor or Color3.fromRGB(255,255,255)
            if Flag and NoxvaLib.Flags[Flag] then
                local v=NoxvaLib.Flags[Flag].Value
                if type(v)=="table" and v.IsColor then color=Color3.new(v.R,v.G,v.B) end
            end

            local F=ItemFrame(34); F.ClipsDescendants=true

            local Header=Instance.new("TextButton",F)
            Header.Size=UDim2.new(1,0,0,34); Header.BackgroundTransparency=1
            Header.Text=txt; Header.TextColor3=T.TEXT
            Header.Font=Enum.Font.GothamSemibold; Header.TextSize=12
            Header.TextXAlignment=Enum.TextXAlignment.Left
            Pad(Header,12,0,0,0)

            local Preview=Instance.new("Frame",F)
            Preview.Size=UDim2.new(0,28,0,16); Preview.Position=UDim2.new(1,-40,0.5,-8)
            Preview.BackgroundColor3=color; Preview.BorderSizePixel=0
            Corner(Preview,4); Stroke(Preview,T.BORDER,1,0.2)

            local Expand=Instance.new("Frame",F)
            Expand.Size=UDim2.new(1,0,1,-34); Expand.Position=UDim2.new(0,0,0,34)
            Expand.BackgroundTransparency=1

            local isOpen=false
            Header.MouseButton1Click:Connect(function()
                isOpen=not isOpen
                Tween(F,0.2,{Size=isOpen and UDim2.new(1,0,0,34+72) or UDim2.new(1,0,0,34)})
            end)

            local fills={}

            local function Upd(c)
                color=c; Preview.BackgroundColor3=c
                for i,d in ipairs({"R","G","B"}) do
                    if fills[d] then
                        fills[d].Size=UDim2.new(({c.R,c.G,c.B})[i],0,1,0)
                    end
                end
                if Flag then NoxvaLib.Flags[Flag].Value=c end
                cb(c)
            end
            if Flag then NoxvaLib.Flags[Flag]={Value=color,Func=cb,Set=Upd} end

            local chColors={R=Color3.fromRGB(255,60,60),G=Color3.fromRGB(60,220,120),B=Color3.fromRGB(60,120,255)}
            for i,ch in ipairs({"R","G","B"}) do
                local y=(i-1)*22+4
                Label(Expand,{Text=ch,Font=Enum.Font.GothamBold,TextSize=10,
                    Color=chColors[ch],Size=UDim2.new(0,14,0,12),
                    Position=UDim2.new(0,10,0,y+1),XAlign=Enum.TextXAlignment.Center})

                local BG=Instance.new("TextButton",Expand)
                BG.Size=UDim2.new(1,-36,0,6); BG.Position=UDim2.new(0,28,0,y+4)
                BG.BackgroundColor3=T.SURFACE3; BG.Text=""; BG.BorderSizePixel=0
                Corner(BG,3)

                local FL=Instance.new("Frame",BG)
                FL.Size=UDim2.new(({color.R,color.G,color.B})[i],0,1,0)
                FL.BackgroundColor3=chColors[ch]; FL.BorderSizePixel=0; Corner(FL,3)
                fills[ch]=FL

                local d=false
                local function upd(inp)
                    local p=math.clamp((inp.Position.X-BG.AbsolutePosition.X)/BG.AbsoluteSize.X,0,1)
                    FL.Size=UDim2.new(p,0,1,0)
                    Upd(Color3.new(fills.R.Size.X.Scale,fills.G.Size.X.Scale,fills.B.Size.X.Scale))
                end
                BG.InputBegan:Connect(function(inp)
                    if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
                        d=true; upd(inp)
                    end
                end)
                UIS.InputChanged:Connect(function(inp)
                    if d and (inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch) then upd(inp) end
                end)
                UIS.InputEnded:Connect(function(inp)
                    if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then d=false end
                end)
            end
            cb(color)
            table.insert(SearchableElements,{Frame=F,Name=txt:lower()})
        end

        -- ── CONSOLE (with log levels) ─────────────────────────
        function TF:AddConsole(h)
            h=h or 150
            local F=ItemFrame(h)

            local TopBar_=Instance.new("Frame",F)
            TopBar_.Size=UDim2.new(1,0,0,24); TopBar_.BackgroundColor3=T.SURFACE3
            TopBar_.BorderSizePixel=0
            Corner(TopBar_,6)
            local TBB=Instance.new("Frame",TopBar_)
            TBB.Size=UDim2.new(1,0,0,8); TBB.Position=UDim2.new(0,0,1,-8)
            TBB.BackgroundColor3=T.SURFACE3; TBB.BorderSizePixel=0

            Label(TopBar_,{Text="CONSOLE",Font=Enum.Font.GothamBold,TextSize=9,Color=T.MUTED,
                Size=UDim2.new(0.5,0,1,0),Position=UDim2.new(0,10,0,0),
                XAlign=Enum.TextXAlignment.Left})

            local CopyBtn=Instance.new("TextButton",TopBar_)
            CopyBtn.Size=UDim2.new(0,50,0,16); CopyBtn.Position=UDim2.new(1,-90,0.5,-8)
            CopyBtn.BackgroundColor3=T.SURFACE2; CopyBtn.Text="Copy"; CopyBtn.TextColor3=T.SUBTEXT
            CopyBtn.Font=Enum.Font.GothamBold; CopyBtn.TextSize=9; CopyBtn.BorderSizePixel=0
            Corner(CopyBtn,4)

            local ClearBtn=Instance.new("TextButton",TopBar_)
            ClearBtn.Size=UDim2.new(0,44,0,16); ClearBtn.Position=UDim2.new(1,-42,0.5,-8)
            ClearBtn.BackgroundColor3=T.SURFACE2; ClearBtn.Text="Clear"; ClearBtn.TextColor3=T.DANGER
            ClearBtn.Font=Enum.Font.GothamBold; ClearBtn.TextSize=9; ClearBtn.BorderSizePixel=0
            Corner(ClearBtn,4)

            local Scroll=Instance.new("ScrollingFrame",F)
            Scroll.Size=UDim2.new(1,-8,1,-30); Scroll.Position=UDim2.new(0,4,0,26)
            Scroll.BackgroundTransparency=1; Scroll.ScrollBarThickness=2
            Scroll.ScrollBarImageColor3=T.BORDER
            List(Scroll,1)

            Scroll:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                local l=List(Scroll); -- get layout
                for _,c in pairs(Scroll:GetChildren()) do
                    if c:IsA("UIListLayout") then
                        Scroll.CanvasSize=UDim2.new(0,0,0,c.AbsoluteContentSize.Y+4)
                        Scroll.CanvasPosition=Vector2.new(0,c.AbsoluteContentSize.Y)
                    end
                end
            end)

            local LEVEL_COLORS={
                INFO   = T.SUBTEXT,
                WARN   = T.WARNING,
                ERROR  = T.DANGER,
                OK     = T.SUCCESS,
                DEBUG  = T.MUTED,
            }
            local allLogs=""

            CopyBtn.MouseButton1Click:Connect(function()
                if setclipboard then setclipboard(allLogs)
                    WindowFunctions:Notify("CONSOLE","Logs copied!",2)
                end
            end)
            ClearBtn.MouseButton1Click:Connect(function()
                for _,c in pairs(Scroll:GetChildren()) do
                    if c:IsA("Frame") then c:Destroy() end
                end
                allLogs=""
            end)

            table.insert(SearchableElements,{Frame=F,Name="console terminal log"})

            local CF={}
            function CF:Log(msg, level)
                level=level or "INFO"
                local col=LEVEL_COLORS[level] or T.SUBTEXT
                local Row=Instance.new("Frame",Scroll)
                Row.Size=UDim2.new(1,0,0,0); Row.AutomaticSize=Enum.AutomaticSize.Y
                Row.BackgroundTransparency=1

                local Prefix=Label(Row,{Text="["..level.."]",Font=Enum.Font.GothamBold,TextSize=9,
                    Color=col,Size=UDim2.new(0,44,0,14),Position=UDim2.new(0,2,0,1)})
                local MsgLbl=Label(Row,{Text=tostring(msg),TextSize=9,Color=T.SUBTEXT,
                    Size=UDim2.new(1,-48,0,0),Position=UDim2.new(0,48,0,1),
                    Wrap=true,YAlign=Enum.TextYAlignment.Top})
                MsgLbl.AutomaticSize=Enum.AutomaticSize.Y

                allLogs=allLogs.."["..level.."] "..tostring(msg).."\n"
                -- auto-scroll
                for _,c in pairs(Scroll:GetChildren()) do
                    if c:IsA("UIListLayout") then
                        Scroll.CanvasPosition=Vector2.new(0,c.AbsoluteContentSize.Y)
                    end
                end
            end
            function CF:Warn(msg)  self:Log(msg,"WARN")  end
            function CF:Error(msg) self:Log(msg,"ERROR") end
            function CF:Ok(msg)    self:Log(msg,"OK")    end
            function CF:Debug(msg) self:Log(msg,"DEBUG") end
            function CF:Clear()
                for _,c in pairs(Scroll:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
                allLogs=""
            end
            return CF
        end

        -- ── FOLDER (now with full component support) ──────────
        function TF:AddFolder(title)
            local F=Instance.new("Frame",TabPage)
            F.Size=UDim2.new(1,0,0,32); F.BackgroundColor3=T.SURFACE2
            F.BackgroundTransparency=0; F.ClipsDescendants=true
            F.BorderSizePixel=0
            Corner(F,6); Stroke(F,T.BORDER,1,0.3)

            local HBtn=Instance.new("TextButton",F)
            HBtn.Size=UDim2.new(1,0,0,32); HBtn.BackgroundTransparency=1
            HBtn.Text=""; HBtn.BorderSizePixel=0

            local FolderIcon=Label(F,{Text="▶",TextSize=9,Color=T.MUTED,
                Size=UDim2.new(0,16,0,32),Position=UDim2.new(0,8,0,0),XAlign=Enum.TextXAlignment.Center})
            Label(F,{Text=title,Font=Enum.Font.GothamBold,TextSize=12,Color=T.TEXT,
                Size=UDim2.new(1,-32,0,32),Position=UDim2.new(0,24,0,0)})

            local Inner=Instance.new("Frame",F)
            Inner.Size=UDim2.new(1,-8,1,-36); Inner.Position=UDim2.new(0,4,0,34)
            Inner.BackgroundTransparency=1
            local IL=List(Inner,4)
            Pad(Inner,0,0,0,4)

            local isOpen=false
            IL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                if isOpen then Tween(F,0.2,{Size=UDim2.new(1,0,0,36+IL.AbsoluteContentSize.Y+8)}) end
            end)

            HBtn.MouseButton1Click:Connect(function()
                isOpen=not isOpen
                if isOpen then
                    Tween(FolderIcon,0.15,{Rotation=90})
                    Tween(F,0.2,{Size=UDim2.new(1,0,0,36+IL.AbsoluteContentSize.Y+8)})
                else
                    Tween(FolderIcon,0.15,{Rotation=0})
                    Tween(F,0.2,{Size=UDim2.new(1,0,0,32)})
                end
            end)
            table.insert(SearchableElements,{Frame=F,Name=title:lower()})

            -- ── folder sub-functions ──────────────────────────
            -- These are thin wrappers that create elements inside Inner
            -- by temporarily swapping TabPage
            local FF={}

            local function WithInner(size, bg)
                local sf=Instance.new("Frame",Inner)
                sf.Size=UDim2.new(1,0,0,size or 32)
                sf.BackgroundColor3=bg or T.SURFACE3
                sf.BorderSizePixel=0
                Corner(sf,5)
                return sf
            end

            function FF:AddLabel(txt)
                local sf=WithInner(nil,T.SURFACE3); sf.AutomaticSize=Enum.AutomaticSize.Y; sf.Size=UDim2.new(1,0,0,0)
                local L=Label(sf,{Text=txt,TextSize=11,Color=T.SUBTEXT,Size=UDim2.new(1,0,0,0),Wrap=true,YAlign=Enum.TextYAlignment.Top})
                L.AutomaticSize=Enum.AutomaticSize.Y; Pad(L,10,10,6,6)
                local LI={}; function LI:SetText(t) L.Text=t end; return LI
            end

            function FF:AddParagraph(t,d)
                local sf=WithInner(nil,T.SURFACE3); sf.AutomaticSize=Enum.AutomaticSize.Y; sf.Size=UDim2.new(1,0,0,0)
                local Inn=Instance.new("Frame",sf); Inn.Size=UDim2.new(1,0,0,0); Inn.AutomaticSize=Enum.AutomaticSize.Y; Inn.BackgroundTransparency=1
                List(Inn,3); Pad(Inn,10,10,6,6)
                local TL=Label(Inn,{Text=t,Font=Enum.Font.GothamBold,TextSize=11,Color=T.TEXT,Size=UDim2.new(1,0,0,14)})
                local DL=Label(Inn,{Text=d,TextSize=10,Color=T.SUBTEXT,Size=UDim2.new(1,0,0,0),Wrap=true,YAlign=Enum.TextYAlignment.Top}); DL.AutomaticSize=Enum.AutomaticSize.Y
                local PF={}; function PF:Set(nt,nd) TL.Text=nt; DL.Text=nd end; return PF
            end

            function FF:AddButton(txt,cb)
                local sf=WithInner(30)
                local B=Instance.new("TextButton",sf); B.Size=UDim2.new(1,0,1,0); B.BackgroundTransparency=1
                B.Text=txt; B.TextColor3=T.TEXT; B.Font=Enum.Font.GothamSemibold; B.TextSize=11
                B.TextXAlignment=Enum.TextXAlignment.Left; B.TextTruncate=Enum.TextTruncate.AtEnd
                Pad(B,10,0,0,0); Ripple(B)
                B.MouseEnter:Connect(function() Tween(sf,0.1,{BackgroundColor3=T.BORDER}) end)
                B.MouseLeave:Connect(function() Tween(sf,0.1,{BackgroundColor3=T.SURFACE3}) end)
                B.MouseButton1Click:Connect(function() cb() end)
            end

            function FF:AddToggle(txt,def,cb,flag)
                local state=def or false
                if flag and NoxvaLib.Flags[flag] then state=NoxvaLib.Flags[flag].Value end
                local sf=WithInner(30)

                local B=Instance.new("TextButton",sf); B.Size=UDim2.new(1,-52,1,0); B.BackgroundTransparency=1
                B.Text=txt; B.TextColor3=T.TEXT; B.Font=Enum.Font.GothamSemibold; B.TextSize=11
                B.TextXAlignment=Enum.TextXAlignment.Left; B.TextTruncate=Enum.TextTruncate.AtEnd
                Pad(B,10,0,0,0); Ripple(B)

                local Pill=Instance.new("Frame",sf); Pill.Size=UDim2.new(0,32,0,16); Pill.Position=UDim2.new(1,-42,0.5,-8)
                Pill.BackgroundColor3=state and NoxvaLib.AccentColor or T.BORDER; Pill.BorderSizePixel=0; Corner(Pill,8)
                local Knob=Instance.new("Frame",Pill); Knob.Size=UDim2.new(0,10,0,10)
                Knob.Position=state and UDim2.new(1,-13,0.5,-5) or UDim2.new(0,3,0.5,-5)
                Knob.BackgroundColor3=T.TEXT; Knob.BorderSizePixel=0; Corner(Knob,5)

                local function Upd(ns)
                    state=ns; Tween(Pill,0.2,{BackgroundColor3=state and NoxvaLib.AccentColor or T.BORDER})
                    Tween(Knob,0.2,{Position=state and UDim2.new(1,-13,0.5,-5) or UDim2.new(0,3,0.5,-5)})
                    if flag then NoxvaLib.Flags[flag].Value=state end; cb(state)
                end
                if flag then NoxvaLib.Flags[flag]={Value=state,Func=cb,Set=Upd} end
                if state then cb(state) end
                B.MouseButton1Click:Connect(function() Upd(not state) end)
                Pill.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then Upd(not state) end end)
            end

            function FF:AddSlider(txt,min,max,def,cb,flag)
                local val=def or min
                if flag and NoxvaLib.Flags[flag] then val=NoxvaLib.Flags[flag].Value end
                local sf=WithInner(44)

                local TL=Label(sf,{Text=txt,Font=Enum.Font.GothamSemibold,TextSize=10,Color=T.TEXT,
                    Size=UDim2.new(0.7,0,0,16),Position=UDim2.new(0,8,0,4)})
                local VL=Label(sf,{Text=tostring(val),TextSize=10,Color=NoxvaLib.AccentColor,
                    Size=UDim2.new(0.3,0,0,16),Position=UDim2.new(0.7,0,0,4),XAlign=Enum.TextXAlignment.Right})

                local Track=Instance.new("TextButton",sf); Track.Size=UDim2.new(1,-16,0,4); Track.Position=UDim2.new(0,8,0,28)
                Track.BackgroundColor3=T.SURFACE2; Track.Text=""; Track.BorderSizePixel=0; Corner(Track,2)
                local Fill=Instance.new("Frame",Track); Fill.Size=UDim2.new((val-min)/(max-min),0,1,0)
                Fill.BackgroundColor3=NoxvaLib.AccentColor; Fill.BorderSizePixel=0; Corner(Fill,2)

                local function Upd(nv)
                    val=math.clamp(math.floor(nv),min,max); local p=(val-min)/(max-min)
                    Tween(Fill,0.05,{Size=UDim2.new(p,0,1,0)}); VL.Text=tostring(val)
                    if flag then NoxvaLib.Flags[flag].Value=val end; cb(val)
                end
                if flag then NoxvaLib.Flags[flag]={Value=val,Func=cb,Set=Upd} end; cb(val)
                local d=false
                Track.InputBegan:Connect(function(i)
                    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
                        d=true; Upd(min+(max-min)*math.clamp((i.Position.X-Track.AbsolutePosition.X)/Track.AbsoluteSize.X,0,1))
                    end
                end)
                UIS.InputChanged:Connect(function(i)
                    if d and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
                        Upd(min+(max-min)*math.clamp((i.Position.X-Track.AbsolutePosition.X)/Track.AbsoluteSize.X,0,1))
                    end
                end)
                UIS.InputEnded:Connect(function(i)
                    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then d=false end
                end)
            end

            function FF:AddDropdown(txt,opts,cb,flag)
                local sel=opts[1]
                if flag and NoxvaLib.Flags[flag] then sel=NoxvaLib.Flags[flag].Value end
                local sf=WithInner(30); sf.ClipsDescendants=true

                local HH=Instance.new("TextButton",sf); HH.Size=UDim2.new(1,0,0,30); HH.BackgroundTransparency=1
                HH.Text=txt.." · "..(tostring(sel) or ""); HH.TextColor3=T.TEXT
                HH.Font=Enum.Font.GothamSemibold; HH.TextSize=11
                HH.TextXAlignment=Enum.TextXAlignment.Left; HH.TextTruncate=Enum.TextTruncate.AtEnd
                Pad(HH,10,0,0,0)

                local DS=Instance.new("ScrollingFrame",sf); DS.Size=UDim2.new(1,0,1,-30); DS.Position=UDim2.new(0,0,0,30)
                DS.BackgroundTransparency=1; DS.ScrollBarThickness=1; List(DS,1)

                local isO=false
                local function Upd(v)
                    sel=v; HH.Text=txt.." · "..tostring(sel); isO=false
                    Tween(sf,0.15,{Size=UDim2.new(1,0,0,30)})
                    if flag then NoxvaLib.Flags[flag].Value=sel end; cb(sel)
                end
                if flag then NoxvaLib.Flags[flag]={Value=sel,Func=cb,Set=Upd} end
                HH.MouseButton1Click:Connect(function()
                    isO=not isO
                    if isO then
                        Tween(sf,0.15,{Size=UDim2.new(1,0,0,30+math.min(#opts,4)*24)})
                        DS.CanvasSize=UDim2.new(0,0,0,#opts*24)
                    else Tween(sf,0.15,{Size=UDim2.new(1,0,0,30)}) end
                end)
                for _,o in ipairs(opts) do
                    local OB=Instance.new("TextButton",DS); OB.Size=UDim2.new(1,0,0,24); OB.BackgroundTransparency=1
                    OB.Text=tostring(o); OB.TextColor3=T.SUBTEXT; OB.Font=Enum.Font.Gotham; OB.TextSize=11
                    OB.TextXAlignment=Enum.TextXAlignment.Left; Pad(OB,18,0,0,0)
                    OB.MouseEnter:Connect(function() OB.TextColor3=T.TEXT end)
                    OB.MouseLeave:Connect(function() OB.TextColor3=T.SUBTEXT end)
                    OB.MouseButton1Click:Connect(function() Upd(o) end)
                end
                if sel then cb(sel) end
            end

            function FF:AddColorPicker(txt,def,cb,flag)
                -- reuse tab-level color picker but parented to Inner
                local old=TabPage; TabPage=Inner
                TF:AddColorPicker(txt,def,cb,flag)
                TabPage=old
                -- move last child of Inner (already done since TabPage=Inner)
            end

            function FF:AddKeybind(txt,defKey,cb)
                local key=defKey or Enum.KeyCode.E
                local sf=WithInner(30)
                Label(sf,{Text=txt,Font=Enum.Font.GothamSemibold,TextSize=11,Color=T.TEXT,
                    Size=UDim2.new(0.6,0,1,0),Position=UDim2.new(0,10,0,0)})
                local BB=Instance.new("TextButton",sf); BB.Size=UDim2.new(0,60,0,20); BB.Position=UDim2.new(1,-70,0.5,-10)
                BB.BackgroundColor3=T.SURFACE2; BB.Text=key.Name; BB.TextColor3=NoxvaLib.AccentColor
                BB.Font=Enum.Font.GothamBold; BB.TextSize=10; BB.BorderSizePixel=0; Corner(BB,4)
                local binding=false
                BB.MouseButton1Click:Connect(function() BB.Text="···"; binding=true end)
                UIS.InputBegan:Connect(function(i,gp)
                    if binding and i.UserInputType==Enum.UserInputType.Keyboard then
                        key=i.KeyCode; BB.Text=key.Name; binding=false
                    elseif not gp and i.KeyCode==key and not binding then cb() end
                end)
            end

            function FF:AddMultiDropdown(txt,opts,defSel,cb,flag)
                local old=TabPage; TabPage=Inner
                TF:AddMultiDropdown(txt,opts,defSel,cb,flag)
                TabPage=old
            end

            function FF:AddInputSwitch(lbl,ph,bTxt,cb)
                local old=TabPage; TabPage=Inner
                TF:AddInputSwitch(lbl,ph,bTxt,cb)
                TabPage=old
            end

            return FF
        end

        -- ── TAB BADGE API ────────────────────────────────────
        local TFApi = {}
        for k,v in pairs(TF) do TFApi[k]=v end
        function TFApi:SetBadge(count)
            if count and count>0 then
                Badge.Text=tostring(count); Badge.Visible=true
            else
                Badge.Visible=false
            end
        end
        function TFApi:ClearBadge() Badge.Visible=false end

        return TFApi
    end

    -- ── CONFIG TAB (UPGRADED: live refresh, auto-save) ────────
    function WindowFunctions:MakeConfigTab()
        local CTab=WindowFunctions:MakeTab("⚙ Settings")
        local GameFolder="NoxvaHub/Configs/"..tostring(game.PlaceId)

        if makefolder then
            pcall(function()
                makefolder("NoxvaHub")
                makefolder("NoxvaHub/Configs")
                makefolder(GameFolder)
            end)
        end

        CTab:AddSection("THEME")
        CTab:AddColorPicker("Accent Color", NoxvaLib.AccentColor, function(c)
            local old=NoxvaLib.AccentColor
            NoxvaLib.AccentColor=c
            for _,el in pairs(NoxvaUI:GetDescendants()) do
                pcall(function()
                    if el:IsA("UIStroke") and el.Color==old then el.Color=c
                    elseif (el:IsA("TextLabel") or el:IsA("TextButton")) and el.TextColor3==old then el.TextColor3=c
                    elseif el:IsA("Frame") and el.BackgroundColor3==old then el.BackgroundColor3=c
                    elseif el:IsA("ScrollingFrame") and el.ScrollBarImageColor3==old then el.ScrollBarImageColor3=c
                    end
                end)
            end
        end, "HubThemeColor")

        CTab:AddToggle("Show FPS / Ping", true, function(v)
            StatsLabel.Visible=v
        end)

        CTab:AddSection("CONFIG MANAGER")

        local SelectedConfig="Default"
        CTab:AddTextbox("Config Name","e.g. Default",function(t)
            if t~="" then SelectedConfig=t end
        end)

        -- live refresh helper
        local function GetConfigs()
            local list={}
            if listfiles then
                local ok2,files=pcall(function() return listfiles(GameFolder) end)
                if ok2 and files then
                    for _,file in pairs(files) do
                        if file:sub(-5)==".json" then
                            local name=file:match("([^/\\]+)%.json$")
                            if name then table.insert(list,name) end
                        end
                    end
                end
            end
            if #list==0 then table.insert(list,"No Configs") end
            return list
        end

        local ConfigDrop=CTab:AddDropdown("Load Config", GetConfigs(), function(v)
            SelectedConfig=v
        end)

        CTab:AddDoubleButton("💾 Save", function()
            local data={}
            for fn,fd in pairs(NoxvaLib.Flags) do
                if typeof(fd.Value)=="Color3" then
                    data[fn]={R=fd.Value.R,G=fd.Value.G,B=fd.Value.B,IsColor=true}
                elseif type(fd.Value)=="table" and fd.Value.Key~=nil then
                    data[fn]={State=fd.Value.State,Key=fd.Value.Key.Name}
                else
                    data[fn]=fd.Value
                end
            end
            local ok2,json=pcall(function() return HttpService:JSONEncode(data) end)
            if ok2 and writefile then
                writefile(GameFolder.."/"..SelectedConfig..".json",json)
                WindowFunctions:Notify("CONFIG","Saved: '"..SelectedConfig.."'",3)
                -- live-refresh dropdown
                ConfigDrop:SetOptions(GetConfigs())
            else
                WindowFunctions:Notify("ERROR","writefile not supported",3)
            end
        end, "🔄 Refresh", function()
            ConfigDrop:SetOptions(GetConfigs())
            WindowFunctions:Notify("CONFIG","Config list refreshed!",2)
        end)

        CTab:AddButton("📂 Load Selected", function()
            local path=GameFolder.."/"..SelectedConfig..".json"
            if readfile and isfile and isfile(path) then
                local ok2,json=pcall(function() return readfile(path) end)
                if ok2 then
                    local data=HttpService:JSONDecode(json)
                    for fn,val in pairs(data) do
                        if NoxvaLib.Flags[fn] and NoxvaLib.Flags[fn].Set then
                            if type(val)=="table" and val.IsColor then
                                NoxvaLib.Flags[fn].Set(Color3.new(val.R,val.G,val.B))
                            elseif type(val)=="table" and val.State~=nil and val.Key~=nil then
                                NoxvaLib.Flags[fn].Set({State=val.State,Key=Enum.KeyCode[val.Key] or Enum.KeyCode.E})
                            else
                                NoxvaLib.Flags[fn].Set(val)
                            end
                        end
                    end
                    WindowFunctions:Notify("CONFIG","Loaded: "..SelectedConfig,3)
                end
            else
                WindowFunctions:Notify("ERROR","File not found!",3)
            end
        end)

        -- auto-save on UI destroy
        NoxvaUI.AncestryChanged:Connect(function()
            if not NoxvaUI.Parent then
                local data={}
                for fn,fd in pairs(NoxvaLib.Flags) do
                    if typeof(fd.Value)=="Color3" then
                        data[fn]={R=fd.Value.R,G=fd.Value.G,B=fd.Value.B,IsColor=true}
                    elseif type(fd.Value)=="table" and fd.Value.Key~=nil then
                        data[fn]={State=fd.Value.State,Key=fd.Value.Key.Name}
                    else
                        data[fn]=fd.Value
                    end
                end
                local ok2,json=pcall(function() return HttpService:JSONEncode(data) end)
                if ok2 and writefile then
                    pcall(function() writefile(GameFolder.."/autosave.json",json) end)
                end
            end
        end)
    end

    return WindowFunctions
end

return NoxvaLib
