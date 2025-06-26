local WhisperChat = {}

-- Default properties
WhisperChat.DefaultProperties = {
    Size = UDim2.new(0, 373, 0, 408),
    Position = UDim2.new(0.345, 0, 0.144, 0),
    MainColor = Color3.fromRGB(29, 29, 29),
    SecondaryColor = Color3.fromRGB(36, 36, 36),
    AccentColor = Color3.fromRGB(70, 113, 255),
    TextColor = Color3.fromRGB(255, 255, 255),
    Title = "Whisper Chat",
    Subtitle = "Beta",
    BalanceText = "Balance: {Credits} - {Default = 0}",
    DefaultResponseRange = 20
}

function WhisperChat:CreateToggle(name, initialState, parent)
    local toggle = {
        Value = initialState or false,
        OnChanged = nil
    }
    
    -- Create off state frame
    local toggleOff = Instance.new("Frame")
    toggleOff.Name = name .. "Toggle Off"
    toggleOff.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
    toggleOff.BorderSizePixel = 0
    toggleOff.Size = UDim2.new(0, 333, 0, 44)
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = toggleOff
    
    local label = Instance.new("TextLabel")
    label.Parent = toggleOff
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0.036, 0, 0, 0)
    label.Size = UDim2.new(0, 226, 0, 44)
    label.Font = Enum.Font.SourceSans
    label.Text = name
    label.TextColor3 = self.TextColor
    label.TextSize = 15
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local toggleButtonOff = Instance.new("ImageButton")
    toggleButtonOff.Parent = toggleOff
    toggleButtonOff.BackgroundColor3 = Color3.fromRGB(68, 68, 68)
    toggleButtonOff.Position = UDim2.new(0.796, 0, 0.216, 0)
    toggleButtonOff.Size = UDim2.new(0, 54, 0, 24)
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(1, 0)
    buttonCorner.Parent = toggleButtonOff
    
    local toggleKnobOff = Instance.new("ImageButton")
    toggleKnobOff.Parent = toggleButtonOff
    toggleKnobOff.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleKnobOff.Position = UDim2.new(0.06, 0, 0.125, 0)
    toggleKnobOff.Size = UDim2.new(0, 18, 0, 18)
    toggleKnobOff.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = toggleKnobOff
    
    -- Create on state frame
    local toggleOn = Instance.new("Frame")
    toggleOn.Name = name .. "Toggle On"
    toggleOn.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
    toggleOn.BorderSizePixel = 0
    toggleOn.Size = UDim2.new(0, 333, 0, 44)
    toggleOn.Visible = false
    
    local cornerOn = Instance.new("UICorner")
    cornerOn.CornerRadius = UDim.new(0, 5)
    cornerOn.Parent = toggleOn
    
    local labelOn = Instance.new("TextLabel")
    labelOn.Parent = toggleOn
    labelOn.BackgroundTransparency = 1
    labelOn.Position = UDim2.new(0.036, 0, 0, 0)
    labelOn.Size = UDim2.new(0, 226, 0, 44)
    labelOn.Font = Enum.Font.SourceSans
    labelOn.Text = name
    labelOn.TextColor3 = self.TextColor
    labelOn.TextSize = 15
    labelOn.TextXAlignment = Enum.TextXAlignment.Left
    
    local toggleButtonOn = Instance.new("ImageButton")
    toggleButtonOn.Parent = toggleOn
    toggleButtonOn.BackgroundColor3 = self.AccentColor
    toggleButtonOn.Position = UDim2.new(0.796, 0, 0.216, 0)
    toggleButtonOn.Size = UDim2.new(0, 54, 0, 24)
    
    local buttonCornerOn = Instance.new("UICorner")
    buttonCornerOn.CornerRadius = UDim.new(1, 0)
    buttonCornerOn.Parent = toggleButtonOn
    
    local toggleKnobOn = Instance.new("ImageButton")
    toggleKnobOn.Parent = toggleButtonOn
    toggleKnobOn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleKnobOn.Position = UDim2.new(0.6, 0, 0.125, 0)
    toggleKnobOn.Size = UDim2.new(0, 18, 0, 18)
    toggleKnobOn.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    
    local knobCornerOn = Instance.new("UICorner")
    knobCornerOn.CornerRadius = UDim.new(1, 0)
    knobCornerOn.Parent = toggleKnobOn
    
    -- Parent frames
    toggleOff.Parent = parent
    toggleOn.Parent = parent
    
    -- Toggle functionality
    local function updateToggle()
        toggleOff.Visible = not toggle.Value
        toggleOn.Visible = toggle.Value
    end
    
    toggleButtonOff.MouseButton1Click:Connect(function()
        toggle.Value = true
        updateToggle()
        if toggle.OnChanged then
            toggle.OnChanged(toggle.Value)
        end
    end)
    
    toggleButtonOn.MouseButton1Click:Connect(function()
        toggle.Value = false
        updateToggle()
        if toggle.OnChanged then
            toggle.OnChanged(toggle.Value)
        end
    end)
    
    updateToggle()
    
    return toggle
end

function WhisperChat:CreateDropdown(name, options, parent)
    local dropdown = {
        Options = options or {},
        Selected = nil,
        OnSelected = nil,
        IsOpen = false
    }
    
    local dropdownFrame = Instance.new("ImageButton")
    dropdownFrame.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
    dropdownFrame.BorderSizePixel = 0
    dropdownFrame.Size = UDim2.new(0, 333, 0, 180)
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = dropdownFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Parent = dropdownFrame
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0.036, 0, 0, 0)
    titleLabel.Size = UDim2.new(0, 157, 0, 34)
    titleLabel.Font = Enum.Font.SourceSans
    titleLabel.Text = name
    titleLabel.TextColor3 = self.TextColor
    titleLabel.TextSize = 15
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local selectedLabel = Instance.new("TextLabel")
    selectedLabel.Parent = dropdownFrame
    selectedLabel.BackgroundTransparency = 1
    selectedLabel.Position = UDim2.new(0.571, 0, 0, 0)
    selectedLabel.Size = UDim2.new(0, 89, 0, 34)
    selectedLabel.Font = Enum.Font.SourceSans
    selectedLabel.Text = "Select an option"
    selectedLabel.TextColor3 = self.TextColor
    selectedLabel.TextSize = 15
    selectedLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local arrowLabel = Instance.new("TextLabel")
    arrowLabel.Parent = selectedLabel
    arrowLabel.BackgroundTransparency = 1
    arrowLabel.Position = UDim2.new(1.209, 0, 0.118, 0)
    arrowLabel.Size = UDim2.new(0, 18, 0, 30)
    arrowLabel.Font = Enum.Font.SourceSans
    arrowLabel.Text = "^"
    arrowLabel.TextColor3 = self.TextColor
    arrowLabel.TextSize = 38
    arrowLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local optionsFrame = Instance.new("ScrollingFrame")
    optionsFrame.Parent = dropdownFrame
    optionsFrame.Active = true
    optionsFrame.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
    optionsFrame.BorderSizePixel = 0
    optionsFrame.Position = UDim2.new(0.048, 0, 0.194, 0)
    optionsFrame.Size = UDim2.new(0, 303, 0, 138)
    optionsFrame.ScrollBarThickness = 2
    optionsFrame.Visible = false
    
    local optionsCorner = Instance.new("UICorner")
    optionsCorner.Parent = optionsFrame
    
    local optionsLayout = Instance.new("UIListLayout")
    optionsLayout.Parent = optionsFrame
    optionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    optionsLayout.Padding = UDim.new(0, 10)
    
    local optionsPadding = Instance.new("UIPadding")
    optionsPadding.Parent = optionsFrame
    optionsPadding.PaddingLeft = UDim.new(0, 11)
    optionsPadding.PaddingTop = UDim.new(0, 15)
    
    -- Create option buttons
    local function createOptionButton(optionName)
        local button = Instance.new("ImageButton")
        button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        button.BorderSizePixel = 0
        button.Size = UDim2.new(0, 281, 0, 52)
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.Parent = button
        
        local buttonLabel = Instance.new("TextLabel")
        buttonLabel.Parent = button
        buttonLabel.BackgroundTransparency = 1
        buttonLabel.Size = UDim2.new(0, 281, 0, 50)
        buttonLabel.Font = Enum.Font.SourceSans
        buttonLabel.Text = optionName
        buttonLabel.TextColor3 = self.TextColor
        buttonLabel.TextSize = 27
        
        button.MouseButton1Click:Connect(function()
            dropdown.Selected = optionName
            selectedLabel.Text = optionName
            dropdown.IsOpen = false
            optionsFrame.Visible = false
            arrowLabel.Text = "^"
            
            if dropdown.OnSelected then
                dropdown.OnSelected(optionName)
            end
        end)
        
        return button
    end
    
    -- Initialize options
    for _, option in ipairs(dropdown.Options) do
        local button = createOptionButton(option)
        button.Parent = optionsFrame
    end
    
    -- Toggle dropdown
    dropdownFrame.MouseButton1Click:Connect(function()
        dropdown.IsOpen = not dropdown.IsOpen
        optionsFrame.Visible = dropdown.IsOpen
        arrowLabel.Text = dropdown.IsOpen and "v" or "^"
    end)
    
    dropdownFrame.Parent = parent
    
    return dropdown
end

function WhisperChat:CreateButton(name, parent)
    local button = Instance.new("ImageButton")
    button.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
    button.BorderSizePixel = 0
    button.Size = UDim2.new(0, 333, 0, 34)
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = button
    
    local label = Instance.new("TextLabel")
    label.Parent = button
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0.036, 0, 0, 0)
    label.Size = UDim2.new(0, 226, 0, 34)
    label.Font = Enum.Font.SourceSans
    label.Text = name
    label.TextColor3 = self.TextColor
    label.TextSize = 15
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    button.Parent = parent
    
    return button
end

function WhisperChat:CreateTextBox(name, defaultValue, parent)
    local textBoxFrame = Instance.new("Frame")
    textBoxFrame.Name = name
    textBoxFrame.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
    textBoxFrame.BorderSizePixel = 0
    textBoxFrame.Size = UDim2.new(0, 333, 0, 39)
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = textBoxFrame
    
    local label = Instance.new("TextLabel")
    label.Parent = textBoxFrame
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0.036, 0, 0, 0)
    label.Size = UDim2.new(0, 253, 0, 39)
    label.Font = Enum.Font.SourceSans
    label.Text = name
    label.TextColor3 = self.TextColor
    label.TextSize = 15
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local textBox = Instance.new("TextBox")
    textBox.Parent = textBoxFrame
    textBox.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
    textBox.BorderSizePixel = 0
    textBox.Position = UDim2.new(0.796, 0, 0.179, 0)
    textBox.Size = UDim2.new(0, 54, 0, 24)
    textBox.Font = Enum.Font.SourceSans
    textBox.PlaceholderText = tostring(defaultValue or "")
    textBox.Text = ""
    textBox.TextColor3 = self.TextColor
    textBox.TextSize = 16
    
    local textBoxCorner = Instance.new("UICorner")
    textBoxCorner.CornerRadius = UDim.new(0, 6)
    textBoxCorner.Parent = textBox
    
    textBoxFrame.Parent = parent
    
    return textBox
end

function WhisperChat:CreateTabBar(tabs, parent)
    local tabBar = {
        Tabs = tabs or {},
        CurrentTab = nil,
        OnTabChanged = nil
    }
    
    local tabBarFrame = Instance.new("Frame")
    tabBarFrame.Name = "Bottom Bar - Tabs"
    tabBarFrame.BackgroundColor3 = self.MainColor
    tabBarFrame.BorderSizePixel = 0
    tabBarFrame.Position = UDim2.new(0.027, 0, 1.022, 0)
    tabBarFrame.Size = UDim2.new(0, 354, 0, 45)
    
    local corner = Instance.new("UICorner")
    corner.Parent = tabBarFrame
    
    local scrollingFrame = Instance.new("ScrollingFrame")
    scrollingFrame.Parent = tabBarFrame
    scrollingFrame.Active = true
    scrollingFrame.BackgroundColor3 = self.MainColor
    scrollingFrame.BorderSizePixel = 0
    scrollingFrame.Size = UDim2.new(0, 354, 0, 45)
    scrollingFrame.CanvasSize = UDim2.new(3, 0, 2, 0)
    scrollingFrame.ScrollBarThickness = 2
    
    local scrollCorner = Instance.new("UICorner")
    scrollCorner.Parent = scrollingFrame
    
    local layout = Instance.new("UIListLayout")
    layout.Parent = scrollingFrame
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 10)
    
    local padding = Instance.new("UIPadding")
    padding.Parent = scrollingFrame
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingTop = UDim.new(0, 6)
    
    -- Create tab buttons
    for i, tabName in ipairs(tabBar.Tabs) do
        local button = Instance.new("ImageButton")
        button.BackgroundColor3 = i == 1 and self.AccentColor or Color3.fromRGB(34, 34, 34)
        button.BorderSizePixel = 0
        button.Size = UDim2.new(0, 67, 0, 32)
        button.LayoutOrder = i
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.Parent = button
        
        local buttonLabel = Instance.new("TextLabel")
        buttonLabel.Parent = button
        buttonLabel.BackgroundTransparency = 1
        buttonLabel.Size = UDim2.new(0, 67, 0, 32)
        buttonLabel.Font = Enum.Font.SourceSans
        buttonLabel.Text = tabName
        buttonLabel.TextColor3 = self.TextColor
        buttonLabel.TextSize = 18
        
        button.MouseButton1Click:Connect(function()
            if tabBar.CurrentTab ~= tabName then
                -- Update all buttons to inactive state
                for _, child in ipairs(scrollingFrame:GetChildren()) do
                    if child:IsA("ImageButton") then
                        child.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
                    end
                end
                
                -- Set current button to active
                button.BackgroundColor3 = self.AccentColor
                tabBar.CurrentTab = tabName
                
                if tabBar.OnTabChanged then
                    tabBar.OnTabChanged(tabName)
                end
            end
        end)
        
        button.Parent = scrollingFrame
        
        if i == 1 then
            tabBar.CurrentTab = tabName
        end
    end
    
    tabBarFrame.Parent = parent
    
    return tabBar
end

function WhisperChat:CreateWindow(properties)
    properties = properties or {}
    
    -- Merge default properties with provided ones
    for k, v in pairs(self.DefaultProperties) do
        if properties[k] == nil then
            properties[k] = v
        end
    end
    
    local window = {
        Properties = properties,
        Toggles = {},
        Dropdowns = {},
        Buttons = {},
        TextBoxes = {},
        Tabs = {}
    }
    
    -- Create main screen GUI
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "WhisperChatUI"
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Create main frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Parent = screenGui
    mainFrame.BackgroundColor3 = properties.MainColor
    mainFrame.BorderSizePixel = 0
    mainFrame.Position = properties.Position
    mainFrame.Size = properties.Size
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 3)
    frameCorner.Parent = mainFrame
    
    -- Create secondary frame
    local secondaryFrame = Instance.new("Frame")
    secondaryFrame.Parent = mainFrame
    secondaryFrame.BackgroundColor3 = properties.SecondaryColor
    secondaryFrame.BorderSizePixel = 0
    secondaryFrame.Position = UDim2.new(0, 0, 0.1, 0)
    secondaryFrame.Size = UDim2.new(0, properties.Size.X.Offset, 0, -41)
    
    -- Create title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Parent = mainFrame
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0.311, 0, 0, 0)
    titleLabel.Size = UDim2.new(0, 100, 0, 41)
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.Text = properties.Title
    titleLabel.TextColor3 = properties.TextColor
    titleLabel.TextSize = 22
    
    -- Create subtitle
    local subtitleLabel = Instance.new("TextLabel")
    subtitleLabel.Parent = mainFrame
    subtitleLabel.BackgroundTransparency = 1
    subtitleLabel.Position = UDim2.new(0.598, 0, 0, 0)
    subtitleLabel.Size = UDim2.new(0, 33, 0, 41)
    subtitleLabel.Font = Enum.Font.SourceSans
    subtitleLabel.Text = properties.Subtitle
    subtitleLabel.TextColor3 = Color3.fromRGB(156, 156, 156)
    subtitleLabel.TextSize = 22
    
    -- Create scrolling frame for content
    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Parent = mainFrame
    contentFrame.Active = true
    contentFrame.BackgroundTransparency = 1
    contentFrame.BorderSizePixel = 0
    contentFrame.Position = UDim2.new(0, 0, 0.113, 0)
    contentFrame.Size = UDim2.new(0, properties.Size.X.Offset, 0, properties.Size.Y.Offset * 0.887)
    contentFrame.ScrollBarThickness = 4
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Parent = contentFrame
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 12)
    
    local contentPadding = Instance.new("UIPadding")
    contentPadding.Parent = contentFrame
    contentPadding.PaddingLeft = UDim.new(0, 18)
    contentPadding.PaddingTop = UDim.new(0, 12)
    
    -- Create balance display
    local balanceFrame = Instance.new("Frame")
    balanceFrame.Name = "Balance"
    balanceFrame.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
    balanceFrame.BorderSizePixel = 0
    balanceFrame.Size = UDim2.new(0, 333, 0, 28)
    
    local balanceCorner = Instance.new("UICorner")
    balanceCorner.CornerRadius = UDim.new(0, 5)
    balanceCorner.Parent = balanceFrame
    
    local balanceLabel = Instance.new("TextLabel")
    balanceLabel.Parent = balanceFrame
    balanceLabel.BackgroundTransparency = 1
    balanceLabel.Position = UDim2.new(0.036, 0, 0, 0)
    balanceLabel.Size = UDim2.new(0, 307, 0, 28)
    balanceLabel.Font = Enum.Font.SourceSans
    balanceLabel.Text = properties.BalanceText
    balanceLabel.TextColor3 = properties.TextColor
    balanceLabel.TextSize = 15
    balanceLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    balanceFrame.Parent = contentFrame
    
    -- Create tab bar
    local tabBar = self:CreateTabBar({"Home", "Blacklist", "AI/Personality", "Premium Features", "Chat", "Login", "Support", "Config"}, mainFrame)
    window.TabBar = tabBar
    
    -- Add methods to window
    function window:AddToggle(name, initialState)
        local toggle = self.Lib:CreateToggle(name, initialState, contentFrame)
        self.Toggles[name] = toggle
        return toggle
    end
    
    function window:AddDropdown(name, options)
        local dropdown = self.Lib:CreateDropdown(name, options, contentFrame)
        self.Dropdowns[name] = dropdown
        return dropdown
    end
    
    function window:AddButton(name, callback)
        local button = self.Lib:CreateButton(name, contentFrame)
        self.Buttons[name] = button
        
        if callback then
            button.MouseButton1Click:Connect(callback)
        end
        
        return button
    end
    
    function window:AddTextBox(name, defaultValue)
        local textBox = self.Lib:CreateTextBox(name, defaultValue, contentFrame)
        self.TextBoxes[name] = textBox
        return textBox
    end
    
    function window:SetBalanceText(text)
        balanceLabel.Text = text
    end
    
    function window:Destroy()
        screenGui:Destroy()
    end
    
    -- Store library reference
    window.Lib = self
    
    -- Parent to player GUI
    screenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    
    return window
end

return WhisperChat
