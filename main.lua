local UIComponents = {}

function UIComponents.createUI(player, ColorPalette, displayName, customAvatars)
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "EnhancedFlyUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 700, 0, 530)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.BackgroundColor3 = ColorPalette.Secondary
    MainFrame.BackgroundTransparency = 0
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui

    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)
    Instance.new("UIStroke", MainFrame).Color = ColorPalette.Border

    -- Header Section
    local header = Instance.new("Frame", MainFrame)
    header.Size = UDim2.new(1, 0, 0, 70)
    header.BackgroundTransparency = 1

    local userContainer = Instance.new("Frame", header)
    userContainer.Size = UDim2.new(0.4, 0, 1, 0)
    userContainer.BackgroundTransparency = 1

    local avatarFrame = Instance.new("Frame", userContainer)
    avatarFrame.Size = UDim2.new(0, 50, 0, 50)
    avatarFrame.Position = UDim2.new(0, 10, 0.5, -25)
    avatarFrame.BackgroundTransparency = 1

    local avatarImage = Instance.new("ImageLabel")
    avatarImage.Size = UDim2.new(1, 0, 1, 0)
    avatarImage.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    avatarImage.BorderSizePixel = 0
    avatarImage.ScaleType = Enum.ScaleType.Crop
    avatarImage.Parent = avatarFrame
    Instance.new("UICorner", avatarImage).CornerRadius = UDim.new(1, 0)

    local function loadPlayerAvatar()
        local username = player.Name:lower()
        if customAvatars[username] then
            avatarImage.Image = customAvatars[username].decalId
        else
            local success, result = pcall(function()
                return Players:GetUserThumbnailAsync(
                    player.UserId,
                    Enum.ThumbnailType.HeadShot,
                    Enum.ThumbnailSize.Size420x420
                )
            end)
            avatarImage.Image = success and result or "rbxassetid://0"
        end
    end

    local usernameLabel = Instance.new("TextLabel", userContainer)
    usernameLabel.Size = UDim2.new(0, 200, 0, 40)
    usernameLabel.Position = UDim2.new(0, 70, 0.5, -20)
    usernameLabel.BackgroundTransparency = 1
    usernameLabel.Text = displayName
    usernameLabel.TextColor3 = ColorPalette.Text
    usernameLabel.Font = Enum.Font.GothamBold
    usernameLabel.TextSize = 20
    usernameLabel.TextXAlignment = Enum.TextXAlignment.Left

    local Title = Instance.new("TextLabel", header)
    Title.Size = UDim2.new(0.4, 0, 1, 0)
    Title.Position = UDim2.new(0.3, 0, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "^_-"
    Title.TextColor3 = ColorPalette.Accent
    Title.TextSize = 24
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Center

    -- Tab System
    local tabContainer = Instance.new("Frame", MainFrame)
    tabContainer.Size = UDim2.new(1, -30, 0, 40)
    tabContainer.Position = UDim2.new(0, 15, 0, 70)
    tabContainer.BackgroundTransparency = 1

    local function createTabButton(name)
        local btn = Instance.new("TextButton")
        btn.Name = name
        btn.Size = UDim2.new(0.2, 0, 0.8, 0)
        btn.BackgroundColor3 = ColorPalette.Primary
        btn.Text = name
        btn.TextColor3 = ColorPalette.Text
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 14
        btn.AutoButtonColor = false

        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        local stroke = Instance.new("UIStroke")
        stroke.Thickness = 1
        stroke.Color = ColorPalette.Border
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Parent = btn

        btn.MouseEnter:Connect(function()
            btn.TextColor3 = ColorPalette.Accent
        end)

        btn.MouseLeave:Connect(function()
            btn.TextColor3 = ColorPalette.Text
        end)

        return btn
    end

    local mainTab = createTabButton("Main")
    mainTab.Position = UDim2.new(0, 0, 0.1, 0)
    mainTab.Parent = tabContainer

    local settingsTab = createTabButton("Settings")
    settingsTab.Position = UDim2.new(0.33, 0, 0.1, 0)
    settingsTab.Parent = tabContainer

    local annoyingTab = createTabButton("Annoying")
    annoyingTab.Position = UDim2.new(0.66, 0, 0.1, 0)
    annoyingTab.Parent = tabContainer

    -- Content Frames
    local contentFrame = Instance.new("Frame", MainFrame)
    contentFrame.Size = UDim2.new(1, -40, 1, -130)
    contentFrame.Position = UDim2.new(0, 20, 0, 120)
    contentFrame.BackgroundTransparency = 1

    local mainContent = Instance.new("Frame", contentFrame)
    mainContent.Size = UDim2.new(1, 0, 1, 0)
    mainContent.Visible = true
    mainContent.BackgroundTransparency = 1

    local settingsContent = Instance.new("Frame", contentFrame)
    settingsContent.Size = UDim2.new(1, 0, 1, 0)
    settingsContent.Visible = false
    settingsContent.BackgroundTransparency = 1

    local annoyingContent = Instance.new("Frame", contentFrame)
    annoyingContent.Size = UDim2.new(1, 0, 1, 0)
    annoyingContent.Visible = false
    annoyingContent.BackgroundTransparency = 1

    -- Button Creation Function
    local function createButton(buttonName, buttonText, layoutOrder, parent)
        local btn = Instance.new("TextButton")
        btn.Name = buttonName
        btn.Size = UDim2.new(1, 0, 0, 40)
        btn.LayoutOrder = layoutOrder
        btn.BackgroundColor3 = ColorPalette.Primary
        btn.BackgroundTransparency = 0.07
        btn.Text = buttonText
        btn.TextColor3 = ColorPalette.Text
        btn.Font = Enum.Font.GothamMedium
        btn.TextSize = 16
        btn.AutoButtonColor = false
        btn.Parent = parent

        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        local stroke = Instance.new("UIStroke")
        stroke.Thickness = 1
        stroke.Color = ColorPalette.Border
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Parent = btn

        local hover = Instance.new("Frame", btn)
        hover.Size = UDim2.new(1, 0, 1, 0)
        hover.BackgroundColor3 = ColorPalette.Text
        hover.BackgroundTransparency = 0.9
        hover.Visible = false

        btn.MouseEnter:Connect(function()
            hover.Visible = true
            btn.TextColor3 = ColorPalette.Accent
        end)

        btn.MouseLeave:Connect(function()
            hover.Visible = false
            btn.TextColor3 = ColorPalette.Text
        end)

        return btn
    end

    -- Main Tab Content
    local buttonLayout = Instance.new("UIListLayout", mainContent)
    buttonLayout.Padding = UDim.new(0, 10)
    buttonLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local ToggleButton = createButton("ToggleButton", "TOGGLE FLIGHT", 1, mainContent)
    local SpeedButton = createButton("SpeedButton", "ADJUST SPEED", 2, mainContent)
    local LockButton = createButton("LockButton", "LOCK TO HEAD", 3, mainContent)
    local FollowButton = createButton("FollowButton", "FOLLOW PLAYER", 4,  mainContent)
    local StopFollowButton = createButton("StopFollowButton", "STOP FOLLOWING", 5, mainContent)
    local RedeemButton = createButton("RedeemButton", "REDEEM CASH CODES", 6, mainContent)
    StopFollowButton.Visible = false

    local FollowerInputBox = Instance.new("TextBox", mainContent)
    FollowerInputBox.Size = UDim2.new(1, 0, 0, 40)
    FollowerInputBox.Position = UDim2.new(0, 0, 0, 90)
    FollowerInputBox.BackgroundColor3 = ColorPalette.Primary
    FollowerInputBox.TextColor3 = ColorPalette.Text
    FollowerInputBox.Text = "Enter username or display name"
    FollowerInputBox.Font = Enum.Font.Gotham
    FollowerInputBox.TextSize = 14
    Instance.new("UICorner", FollowerInputBox).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Color = ColorPalette.Border
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = FollowerInputBox

    -- Settings Tab Content
    local settingsLayout = Instance.new("UIListLayout", settingsContent)
    settingsLayout.Padding = UDim.new(0, 10)

    local KeybindButton = createButton("KeybindButton", "FLIGHT KEY: B", 30, settingsContent)
    local LockKeybindButton = createButton("LockKeybindButton", "LOCK KEY: T", 60, settingsContent)
    local AntiStompToggle = createButton("AntiStompToggle", "ANTI-STOMP: ON", 10, settingsContent)

    -- Annoying Tab Content
    local annoyingLayout = Instance.new("UIListLayout", annoyingContent)
    annoyingLayout.Padding = UDim.new(0, 10)
    annoyingLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local TargetInput = Instance.new("TextBox", annoyingContent)
    TargetInput.Size = UDim2.new(1, 0, 0, 40)
    TargetInput.BackgroundColor3 = ColorPalette.Primary
    TargetInput.TextColor3 = ColorPalette.Text
    TargetInput.Text = "Enter target username"
    TargetInput.Font = Enum.Font.Gotham
    TargetInput.TextSize = 14
    TargetInput.LayoutOrder = 1
    Instance.new("UICorner", TargetInput).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", TargetInput)
    stroke.Thickness = 1
    stroke.Color = ColorPalette.Border

    local StartAnnoyingBtn = createButton("StartAnnoying", "START ANNOYING MODE", 2, annoyingContent)
    local StopAnnoyingBtn = createButton("StopAnnoying", "STOP ANNOYING MODE (M)", 3, annoyingContent)

    -- Status Bar
    local statusContainer = Instance.new("Frame", MainFrame)
    statusContainer.Size = UDim2.new(1, -40, 0, 80)
    statusContainer.Position = UDim2.new(0, 20, 1, -90)
    statusContainer.BackgroundTransparency = 1

    local statusLabels = {
        Speed = Instance.new("TextLabel", statusContainer),
        Target = Instance.new("TextLabel", statusContainer),
        Following = Instance.new("TextLabel", statusContainer),
        Annoying = Instance.new("TextLabel", statusContainer)
    }

    for i, name in ipairs({"Speed", "Target", "Following", "Annoying"}) do
        statusLabels[name].Size = UDim2.new(0.5, 0, 0, 20)
        statusLabels[name].Position = UDim2.new(0, 0, 0, (i-1)*20)
        statusLabels[name].BackgroundTransparency = 1
        statusLabels[name].Text = name..": None"
        statusLabels[name].TextColor3 = ColorPalette.Text
        statusLabels[name].Font = Enum.Font.Gotham
        statusLabels[name].TextSize = 14
        statusLabels[name].TextXAlignment = Enum.TextXAlignment.Left
    end

    -- Toast Notification System
    local function createToast(message, duration)
        local toastGui = Instance.new("ScreenGui")
        toastGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        toastGui.Parent = player:WaitForChild("PlayerGui")

        local toastFrame = Instance.new("Frame")
        toastFrame.Size = UDim2.new(0.4, 0, 0, 60)
        toastFrame.Position = UDim2.new(0.5, 0, -0.1, 0)
        toastFrame.AnchorPoint = Vector2.new(0.5, 0)
        toastFrame.BackgroundColor3 = ColorPalette.Secondary
        toastFrame.BackgroundTransparency = 1
        toastFrame.Parent = toastGui

        Instance.new("UICorner", toastFrame).CornerRadius = UDim.new(0, 500)

        local uiStroke = Instance.new("UIStroke")
        uiStroke.Thickness = 1
        uiStroke.Color = ColorPalette.Border
        uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        uiStroke.Transparency = 1
        uiStroke.Parent = toastFrame

        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, -20, 1, -20)
        textLabel.Position = UDim2.new(0, 10, 0, 10)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = message
        textLabel.TextColor3 = ColorPalette.Text
        textLabel.Font = Enum.Font.GothamBold
        textLabel.TextSize = 18
        textLabel.RichText = true
        textLabel.TextTransparency = 1
        textLabel.TextStrokeTransparency = 1
        textLabel.Parent = toastFrame

        local slideDown = TweenService:Create(toastFrame, TweenInfo.new(0.6, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {
            Position = UDim2.new(0.5, 0, 0.02, 0),
            BackgroundTransparency = 0.1
        })

        local fadeInText = TweenService:Create(textLabel, TweenInfo.new(0.6), {
            TextTransparency = 0,
            TextStrokeTransparency = 0
        })

        local fadeInStroke = TweenService:Create(uiStroke, TweenInfo.new(0.6), {
            Transparency = 0
        })

        local slideUp = TweenService:Create(toastFrame, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {
            Position = UDim2.new(0.5, 0, -0.1, 0),
            BackgroundTransparency = 1
        })

        local fadeOutText = TweenService:Create(textLabel, TweenInfo.new(0.5), {
            TextTransparency = 1,
            TextStrokeTransparency = 1
        })

        local fadeOutStroke = TweenService:Create(uiStroke, TweenInfo.new(0.5), {
            Transparency = 1
        })

        slideDown:Play()
        fadeInText:Play()
        fadeInStroke:Play()

        task.delay(duration, function()
            slideUp:Play()
            fadeOutText:Play()
            fadeOutStroke:Play()
            slideUp.Completed:Wait()
            toastGui:Destroy()
        end)
    end

    -- Tab Navigation
    local function showTab(tabName)
        mainContent.Visible = tabName == "Main"
        settingsContent.Visible = tabName == "Settings"
        annoyingContent.Visible = tabName == "Annoying"

        mainTab.BackgroundColor3 = tabName == "Main" and ColorPalette.Accent or ColorPalette.Primary
        settingsTab.BackgroundColor3 = tabName == "Settings" and ColorPalette.Accent or ColorPalette.Primary
        annoyingTab.BackgroundColor3 = tabName == "Annoying" and ColorPalette.Accent or ColorPalette.Primary
    end

    -- UI Toggle Function
    local function toggleUI()
        MainFrame.Visible = not MainFrame.Visible
        createToast(MainFrame.Visible and "<b>UI Visible</b>" or "<b>UI Hidden</b>", 1)
    end

    -- Initialize
    loadPlayerAvatar()
    showTab("Main")
    createToast("welcome, <b><font color='#"..ColorPalette.Accent:ToHex().."'>"..displayName.."</font></b>", 3)

    -- Animated Title
    local titleVariants = {"^_-", "-_^", "^_^", "-_^", "-_-"}
    local currentIndex = 1
    task.spawn(function()
        while task.wait(1) do
            Title.Text = titleVariants[currentIndex]
            currentIndex = currentIndex % #titleVariants + 1
        end
    end)

    return {
        ScreenGui = ScreenGui,
        ToggleButton = ToggleButton,
        SpeedButton = SpeedButton,
        LockButton = LockButton,
        FollowButton = FollowButton,
        StopFollowButton = StopFollowButton,
        RedeemButton = RedeemButton,
        FollowerInputBox = FollowerInputBox,
        KeybindButton = KeybindButton,
        LockKeybindButton = LockKeybindButton,
        AntiStompToggle = AntiStompToggle,
        TargetInput = TargetInput,
        StartAnnoyingBtn = StartAnnoyingBtn,
        StopAnnoyingBtn = StopAnnoyingBtn,
        statusLabels = statusLabels,
        showTab = showTab,
        toggleUI = toggleUI,
        createToast = createToast,
        mainTab = mainTab,
        settingsTab = settingsTab,
        annoyingTab = annoyingTab
    }
end

return UIComponents