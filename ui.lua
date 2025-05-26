local UILibrary = {}
UILibrary.__index = UILibrary

-- Library setup
function UILibrary.new()
    local self = setmetatable({}, UILibrary)
    self._elements = {}
    return self
end

-- Base window creation
function UILibrary:CreateWindow(name, size, position)
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    
    -- Create main screen GUI
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = name.."UI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = playerGui
    
    -- Main frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    mainFrame.BorderSizePixel = 0
    mainFrame.Position = position or UDim2.new(0.5, -150, 0.5, -150)
    mainFrame.Size = size or UDim2.new(0, 300, 0, 400)
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui
    
    -- Make frame responsive to screen size
    local function updateFramePosition()
        local viewportSize = workspace.CurrentCamera.ViewportSize
        mainFrame.Position = position or UDim2.new(
            0.5, -mainFrame.AbsoluteSize.X/2,
            0.5, -mainFrame.AbsoluteSize.Y/2
        )
    end
    
    updateFramePosition()
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateFramePosition)
    
    -- Top bar (draggable)
    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    topBar.BorderSizePixel = 0
    topBar.Size = UDim2.new(1, 0, 0, 30)
    topBar.Parent = mainFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Text = name
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 14
    titleLabel.Font = Enum.Font.Gotham
    titleLabel.BackgroundTransparency = 1
    titleLabel.Size = UDim2.new(1, 0, 1, 0)
    titleLabel.Parent = topBar
    
    -- Dragging functionality
    local dragging
    local dragInput
    local dragStart
    local startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X,
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end
    
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    topBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
    
    -- Tab system
    local tabButtonsFrame = Instance.new("Frame")
    tabButtonsFrame.Name = "TabButtons"
    tabButtonsFrame.BackgroundTransparency = 1
    tabButtonsFrame.Size = UDim2.new(1, 0, 0, 30)
    tabButtonsFrame.Position = UDim2.new(0, 0, 0, 30)
    tabButtonsFrame.Parent = mainFrame
    
    local tabContentFrame = Instance.new("Frame")
    tabContentFrame.Name = "TabContent"
    tabContentFrame.BackgroundTransparency = 1
    tabContentFrame.Size = UDim2.new(1, -20, 1, -80)
    tabContentFrame.Position = UDim2.new(0, 10, 0, 70)
    tabContentFrame.Parent = mainFrame
    
    -- Corner rounding for modern look
    local uICorner = Instance.new("UICorner")
    uICorner.CornerRadius = UDim.new(0, 6)
    uICorner.Parent = mainFrame
    
    -- Store window data
    local window = {
        ScreenGui = screenGui,
        MainFrame = mainFrame,
        TabButtons = tabButtonsFrame,
        TabContent = tabContentFrame,
        Tabs = {},
        CurrentTab = nil
    }
    
    table.insert(self._elements, window)
    
    -- Add rounded corners to all children
    self:AddRoundedCorners(mainFrame)
    
    return window
end

-- Tab creation
function UILibrary:CreateTab(window, name, color)
    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Name = name
    tabContent.BackgroundTransparency = 1
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.Position = UDim2.new(0, 0, 0, 0)
    tabContent.Visible = false
    tabContent.ScrollBarThickness = 5
    tabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabContent.Parent = window.TabContent
    
    local tabButton = Instance.new("TextButton")
    tabButton.Name = name
    tabButton.Text = name
    tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabButton.TextSize = 14
    tabButton.Font = Enum.Font.Gotham
    tabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    tabButton.BorderSizePixel = 0
    tabButton.Size = UDim2.new(1/#window.Tabs, -4, 1, -4)
    tabButton.Position = UDim2.new((#window.Tabs)/#window.Tabs, 2, 0, 2)
    tabButton.Parent = window.TabButtons
    
    -- Tab switch function
    tabButton.MouseButton1Click:Connect(function()
        if window.CurrentTab then
            window.CurrentTab.Visible = false
            for _, btn in ipairs(window.TabButtons:GetChildren()) do
                if btn:IsA("TextButton") then
                    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                end
            end
        end
        
        window.CurrentTab = tabContent
        tabContent.Visible = true
        tabButton.BackgroundColor3 = color or Color3.fromRGB(52, 152, 219)
    end)
    
    -- Select first tab by default
    if #window.Tabs == 0 then
        tabButton.BackgroundColor3 = color or Color3.fromRGB(52, 152, 219)
        tabContent.Visible = true
        window.CurrentTab = tabContent
    end
    
    local tab = {
        Name = name,
        Content = tabContent,
        Button = tabButton,
        Elements = {},
        NextElementPosition = 10
    }
    
    table.insert(window.Tabs, tab)
    
    -- Add padding at the top
    local padding = Instance.new("Frame")
    padding.Size = UDim2.new(1, 0, 0, 10)
    padding.BackgroundTransparency = 1
    padding.Parent = tabContent
    
    return tab
end

-- UI Elements
function UILibrary:AddLabel(tab, text, options)
    options = options or {}
    
    local label = Instance.new("TextLabel")
    label.Text = text
    label.TextColor3 = options.TextColor or Color3.fromRGB(255, 255, 255)
    label.TextSize = options.TextSize or 14
    label.Font = options.Font or Enum.Font.Gotham
    label.BackgroundTransparency = 1
    label.TextXAlignment = options.TextXAlignment or Enum.TextXAlignment.Left
    label.Size = UDim2.new(1, 0, 0, options.Height or 20)
    label.Position = UDim2.new(0, 0, 0, tab.NextElementPosition)
    label.Parent = tab.Content
    
    tab.NextElementPosition = tab.NextElementPosition + (options.Height or 20) + 10
    
    table.insert(tab.Elements, label)
    
    return label
end

function UILibrary:AddButton(tab, text, callback, options)
    options = options or {}
    
    local button = Instance.new("TextButton")
    button.Text = text
    button.TextColor3 = options.TextColor or Color3.fromRGB(255, 255, 255)
    button.TextSize = options.TextSize or 14
    button.Font = options.Font or Enum.Font.GothamBold
    button.BackgroundColor3 = options.BackgroundColor or Color3.fromRGB(52, 152, 219)
    button.BorderSizePixel = 0
    button.Size = UDim2.new(1, 0, 0, options.Height or 35)
    button.Position = UDim2.new(0, 0, 0, tab.NextElementPosition)
    button.Parent = tab.Content
    
    button.MouseButton1Click:Connect(callback)
    
    -- Hover effects
    local originalColor = button.BackgroundColor3
    local hoverColor = options.HoverColor or Color3.fromRGB(
        math.min(originalColor.R * 255 + 20, 255)/255,
        math.min(originalColor.G * 255 + 20, 255)/255,
        math.min(originalColor.B * 255 + 20, 255)/255
    )
    
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = hoverColor
    end)
    
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = originalColor
    end)
    
    tab.NextElementPosition = tab.NextElementPosition + (options.Height or 35) + 10
    
    table.insert(tab.Elements, button)
    
    return button
end

function UILibrary:AddTextBox(tab, placeholder, options)
    options = options or {}
    
    local textBox = Instance.new("TextBox")
    textBox.PlaceholderText = placeholder
    textBox.Text = options.DefaultText or ""
    textBox.TextColor3 = options.TextColor or Color3.fromRGB(255, 255, 255)
    textBox.TextSize = options.TextSize or 14
    textBox.Font = options.Font or Enum.Font.Gotham
    textBox.BackgroundColor3 = options.BackgroundColor or Color3.fromRGB(70, 70, 70)
    textBox.BorderSizePixel = 0
    textBox.Size = UDim2.new(1, 0, 0, options.Height or 30)
    textBox.Position = UDim2.new(0, 0, 0, tab.NextElementPosition)
    textBox.Parent = tab.Content
    
    tab.NextElementPosition = tab.NextElementPosition + (options.Height or 30) + 10
    
    table.insert(tab.Elements, textBox)
    
    return textBox
end

function UILibrary:AddToggle(tab, text, defaultState, callback, options)
    options = options or {}
    
    local toggleFrame = Instance.new("Frame")
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Size = UDim2.new(1, 0, 0, options.Height or 20)
    toggleFrame.Position = UDim2.new(0, 0, 0, tab.NextElementPosition)
    toggleFrame.Parent = tab.Content
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 40, 0, 20)
    toggleButton.Position = UDim2.new(1, -40, 0.5, -10)
    toggleButton.BackgroundColor3 = options.BackgroundColor or Color3.fromRGB(70, 70, 70)
    toggleButton.BorderSizePixel = 0
    toggleButton.Text = ""
    toggleButton.Parent = toggleFrame
    
    local toggleState = defaultState or false
    local toggleIndicator = Instance.new("Frame")
    toggleIndicator.Size = UDim2.new(0, 18, 0, 18)
    toggleIndicator.Position = UDim2.new(0, 1, 0.5, -9)
    toggleIndicator.BackgroundColor3 = toggleState and (options.ActiveColor or Color3.fromRGB(46, 204, 113)) or (options.InactiveColor or Color3.fromRGB(150, 150, 150))
    toggleIndicator.BorderSizePixel = 0
    toggleIndicator.Parent = toggleButton
    
    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Text = text
    toggleLabel.TextColor3 = options.TextColor or Color3.fromRGB(255, 255, 255)
    toggleLabel.TextSize = options.TextSize or 14
    toggleLabel.Font = options.Font or Enum.Font.Gotham
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.Size = UDim2.new(1, -50, 1, 0)
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    toggleLabel.Parent = toggleFrame
    
    toggleButton.MouseButton1Click:Connect(function()
        toggleState = not toggleState
        if toggleState then
            toggleIndicator.Position = UDim2.new(1, -19, 0.5, -9)
            toggleIndicator.BackgroundColor3 = options.ActiveColor or Color3.fromRGB(46, 204, 113)
        else
            toggleIndicator.Position = UDim2.new(0, 1, 0.5, -9)
            toggleIndicator.BackgroundColor3 = options.InactiveColor or Color3.fromRGB(150, 150, 150)
        end
        
        if callback then callback(toggleState) end
    end)
    
    tab.NextElementPosition = tab.NextElementPosition + (options.Height or 20) + 10
    
    table.insert(tab.Elements, toggleFrame)
    
    return {
        Frame = toggleFrame,
        Button = toggleButton,
        SetState = function(self, state)
            toggleState = state
            if toggleState then
                toggleIndicator.Position = UDim2.new(1, -19, 0.5, -9)
                toggleIndicator.BackgroundColor3 = options.ActiveColor or Color3.fromRGB(46, 204, 113)
            else
                toggleIndicator.Position = UDim2.new(0, 1, 0.5, -9)
                toggleIndicator.BackgroundColor3 = options.InactiveColor or Color3.fromRGB(150, 150, 150)
            end
        end,
        GetState = function(self)
            return toggleState
        end
    }
end

function UILibrary:AddDropdown(tab, text, optionsList, callback, options)
    options = options or {}
    
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.BackgroundTransparency = 1
    dropdownFrame.Size = UDim2.new(1, 0, 0, options.Height or 30)
    dropdownFrame.Position = UDim2.new(0, 0, 0, tab.NextElementPosition)
    dropdownFrame.Parent = tab.Content
    
    local dropdownButton = Instance.new("TextButton")
    dropdownButton.Size = UDim2.new(1, 0, 0, options.Height or 30)
    dropdownButton.BackgroundColor3 = options.BackgroundColor or Color3.fromRGB(70, 70, 70)
    dropdownButton.BorderSizePixel = 0
    dropdownButton.Text = text.." ▼"
    dropdownButton.TextColor3 = options.TextColor or Color3.fromRGB(255, 255, 255)
    dropdownButton.TextSize = options.TextSize or 14
    dropdownButton.Font = options.Font or Enum.Font.Gotham
    dropdownButton.TextXAlignment = Enum.TextXAlignment.Left
    dropdownButton.Parent = dropdownFrame
    
    local dropdownOptions = Instance.new("ScrollingFrame")
    dropdownOptions.Name = "Options"
    dropdownOptions.BackgroundColor3 = options.OptionsBackgroundColor or Color3.fromRGB(50, 50, 50)
    dropdownOptions.BorderSizePixel = 0
    dropdownOptions.Size = UDim2.new(1, 0, 0, options.OptionsHeight or 120)
    dropdownOptions.Position = UDim2.new(0, 0, 0, options.Height and options.Height + 2 or 32)
    dropdownOptions.Visible = false
    dropdownOptions.ClipsDescendants = true
    dropdownOptions.ScrollBarThickness = 5
    dropdownOptions.AutomaticCanvasSize = Enum.AutomaticSize.Y
    dropdownOptions.CanvasSize = UDim2.new(0, 0, 0, 0)
    dropdownOptions.Parent = dropdownFrame
    
    local selectedOptions = {}
    local optionHeight = options.OptionHeight or 30
    
    -- Function to update dropdown button text
    local function updateDropdownText()
        if #selectedOptions == 0 then
            dropdownButton.Text = text.." ▼"
        elseif #selectedOptions == #optionsList then
            dropdownButton.Text = "All "..text.." Selected ▼"
        else
            dropdownButton.Text = #selectedOptions.." "..text.." Selected ▼"
        end
    end
    
    -- Function to create a checkbox
    local function createCheckbox(parent, isChecked)
        local checkbox = Instance.new("Frame")
        checkbox.Name = "Checkbox"
        checkbox.Size = UDim2.new(0, 20, 0, 20)
        checkbox.Position = UDim2.new(1, -30, 0.5, -10)
        checkbox.BackgroundColor3 = options.CheckboxColor or Color3.fromRGB(70, 70, 70)
        checkbox.BorderSizePixel = 0
        
        local uICorner = Instance.new("UICorner")
        uICorner.CornerRadius = UDim.new(0, 4)
        uICorner.Parent = checkbox
        
        local checkmark = Instance.new("ImageLabel")
        checkmark.Name = "Checkmark"
        checkmark.Image = "rbxassetid://3926305904"
        checkmark.ImageRectOffset = Vector2.new(564, 284)
        checkmark.ImageRectSize = Vector2.new(36, 36)
        checkmark.Size = UDim2.new(0.8, 0, 0.8, 0)
        checkmark.Position = UDim2.new(0.1, 0, 0.1, 0)
        checkmark.BackgroundTransparency = 1
        checkmark.Visible = isChecked
        checkmark.Parent = checkbox
        
        return checkbox
    end
    
    -- Create all options
    for i, option in ipairs(optionsList) do
        local optionButton = Instance.new("TextButton")
        optionButton.Name = option
        optionButton.Text = ""
        optionButton.BackgroundColor3 = options.OptionBackgroundColor or Color3.fromRGB(60, 60, 60)
        optionButton.BackgroundTransparency = 0
        optionButton.Size = UDim2.new(1, -10, 0, optionHeight-4)
        optionButton.Position = UDim2.new(0, 5, 0, (i-1)*optionHeight + 2)
        optionButton.Parent = dropdownOptions
        
        -- Option label
        local label = Instance.new("TextLabel")
        label.Text = "  "..option
        label.TextColor3 = options.OptionTextColor or Color3.fromRGB(255, 255, 255)
        label.TextSize = options.OptionTextSize or 14
        label.Font = options.OptionFont or Enum.Font.Gotham
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, -40, 1, 0)
        label.Position = UDim2.new(0, 0, 0, 0)
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = optionButton
        
        -- Create checkbox (initially unchecked)
        local checkbox = createCheckbox(optionButton, false)
        
        -- Click handler for the option
        optionButton.MouseButton1Click:Connect(function()
            local isSelected = not checkbox.Checkmark.Visible
            checkbox.Checkmark.Visible = isSelected
            
            if isSelected then
                table.insert(selectedOptions, option)
                optionButton.BackgroundColor3 = options.OptionSelectedColor or Color3.fromRGB(80, 80, 80)
            else
                table.remove(selectedOptions, table.find(selectedOptions, option))
                optionButton.BackgroundColor3 = options.OptionBackgroundColor or Color3.fromRGB(60, 60, 60)
            end
            
            updateDropdownText()
            if callback then callback(selectedOptions) end
        end)
        
        -- Hover effects
        optionButton.MouseEnter:Connect(function()
            if not checkbox.Checkmark.Visible then
                optionButton.BackgroundColor3 = options.OptionHoverColor or Color3.fromRGB(70, 70, 70)
            end
        end)
        
        optionButton.MouseLeave:Connect(function()
            if not checkbox.Checkmark.Visible then
                optionButton.BackgroundColor3 = options.OptionBackgroundColor or Color3.fromRGB(60, 60, 60)
            end
        end)
    end
    
    -- Update canvas size for scrolling
    dropdownOptions.CanvasSize = UDim2.new(0, 0, 0, #optionsList * optionHeight)
    
    -- Dropdown toggle functionality
    local isDropdownOpen = false
    dropdownButton.MouseButton1Click:Connect(function()
        isDropdownOpen = not isDropdownOpen
        dropdownOptions.Visible = isDropdownOpen
        
        if isDropdownOpen then
            dropdownButton.Text = string.gsub(dropdownButton.Text, "▼", "▲")
        else
            dropdownButton.Text = string.gsub(dropdownButton.Text, "▲", "▼")
        end
    end)
    
    -- Close dropdown when clicking outside
    local function closeDropdown()
        if isDropdownOpen then
            isDropdownOpen = false
            dropdownOptions.Visible = false
            dropdownButton.Text = string.gsub(dropdownButton.Text, "▲", "▼")
        end
    end
    
    game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
        if not processed and input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mousePos = input.Position
            local absolutePos = dropdownFrame.AbsolutePosition
            local absoluteSize = dropdownFrame.AbsoluteSize
            
            if isDropdownOpen and 
               (mousePos.X < absolutePos.X or 
                mousePos.X > absolutePos.X + absoluteSize.X or
                mousePos.Y < absolutePos.Y or
                mousePos.Y > absolutePos.Y + absoluteSize.Y + dropdownOptions.AbsoluteSize.Y) then
                closeDropdown()
            end
        end
    end)
    
    -- Add corner rounding
    self:AddRoundedCorners(dropdownButton)
    self:AddRoundedCorners(dropdownOptions)
    
    tab.NextElementPosition = tab.NextElementPosition + (options.Height or 30) + (options.OptionsHeight or 120) + 10
    
    table.insert(tab.Elements, dropdownFrame)
    
    return {
        Frame = dropdownFrame,
        GetSelected = function()
            return selectedOptions
        end,
        SetSelected = function(self, selections)
            selectedOptions = {}
            
            -- Update all checkboxes
            for _, optionButton in ipairs(dropdownOptions:GetChildren()) do
                if optionButton:IsA("TextButton") then
                    local checkbox = optionButton:FindFirstChild("Checkbox")
                    if checkbox then
                        local isSelected = table.find(selections, optionButton.Name) ~= nil
                        checkbox.Checkmark.Visible = isSelected
                        
                        if isSelected then
                            table.insert(selectedOptions, optionButton.Name)
                            optionButton.BackgroundColor3 = options.OptionSelectedColor or Color3.fromRGB(80, 80, 80)
                        else
                            optionButton.BackgroundColor3 = options.OptionBackgroundColor or Color3.fromRGB(60, 60, 60)
                        end
                    end
                end
            end
            
            updateDropdownText()
        end
    }
end

-- Utility function to add rounded corners
function UILibrary:AddRoundedCorners(parent)
    for _, child in ipairs(parent:GetDescendants()) do
        if (child:IsA("Frame") or child:IsA("TextButton") or child:IsA("TextBox")) and not child:FindFirstChild("UICorner") then
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 4)
            corner.Parent = child
        end
    end
end

-- Cleanup function
function UILibrary:Destroy()
    for _, element in ipairs(self._elements) do
        if element.ScreenGui then
            element.ScreenGui:Destroy()
        end
    end
    self._elements = {}
end

return UILibrary
