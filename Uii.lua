-- Whisper UI Library
local WhisperUI = {}

-- Theme settings
WhisperUI.Theme = {
    TextColor = Color3.fromRGB(240, 240, 240),
    Background = Color3.fromRGB(25, 25, 25),
    Topbar = Color3.fromRGB(30, 30, 30),
    TabBackground = Color3.fromRGB(35, 35, 35),
    TabBackgroundSelected = Color3.fromRGB(70, 113, 255),
    ElementBackground = Color3.fromRGB(34, 34, 34),
    ToggleEnabled = Color3.fromRGB(70, 113, 255),
    ToggleDisabled = Color3.fromRGB(68, 68, 68),
    InputBackground = Color3.fromRGB(27, 27, 27),
    DropdownBackground = Color3.fromRGB(31, 31, 31),
    DropdownOption = Color3.fromRGB(40, 40, 40),
    NotificationBackground = Color3.fromRGB(34, 34, 34)
}

-- Create main window
function WhisperUI:CreateWindow(options)
    local Window = {}
    Window.Name = options.Name or "Whisper UI"
    Window.Tabs = {}
    Window.CurrentTab = nil
    Window.Notifications = {}
    
    -- Create the main ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "WhisperUI"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = game:GetService("CoreGui")
    
    -- Main frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainWindow"
    MainFrame.BackgroundColor3 = WhisperUI.Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.345, 0, 0.144, 0)
    MainFrame.Size = UDim2.new(0, 373, 0, 408)
    MainFrame.Parent = ScreenGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 3)
    UICorner.Parent = MainFrame
    
    -- Top bar
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.BackgroundColor3 = WhisperUI.Theme.Topbar
    TopBar.BorderSizePixel = 0
    TopBar.Size = UDim2.new(1, 0, 0, 41)
    TopBar.Parent = MainFrame
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0.311, 0, 0, 0)
    TitleLabel.Size = UDim2.new(0, 100, 0, 41)
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.Text = options.Name or "Whisper UI"
    TitleLabel.TextColor3 = WhisperUI.Theme.TextColor
    TitleLabel.TextSize = 22
    TitleLabel.Parent = TopBar
    
    local BetaLabel = Instance.new("TextLabel")
    BetaLabel.Name = "BetaLabel"
    BetaLabel.BackgroundTransparency = 1
    BetaLabel.Position = UDim2.new(0.598, 0, 0, 0)
    BetaLabel.Size = UDim2.new(0, 33, 0, 41)
    BetaLabel.Font = Enum.Font.SourceSans
    BetaLabel.Text = "Beta"
    BetaLabel.TextColor3 = Color3.fromRGB(156, 156, 156)
    BetaLabel.TextSize = 22
    BetaLabel.Parent = TopBar
    
    -- Content frame
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "Content"
    ContentFrame.BackgroundColor3 = WhisperUI.Theme.Background
    ContentFrame.BorderSizePixel = 0
    ContentFrame.Position = UDim2.new(0, 0, 0.101, 0)
    ContentFrame.Size = UDim2.new(1, 0, 0.899, 0)
    ContentFrame.Parent = MainFrame
    
    -- Tab container
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = "TabContainer"
    TabContainer.BackgroundColor3 = WhisperUI.Theme.Background
    TabContainer.BorderSizePixel = 0
    TabContainer.Position = UDim2.new(0.027, 0, 1.022, 0)
    TabContainer.Size = UDim2.new(0.949, 0, 0, 45)
    TabContainer.CanvasSize = UDim2.new(3, 0, 2, 0)
    TabContainer.ScrollBarThickness = 2
    TabContainer.Parent = MainFrame
    
    local UICornerTabs = Instance.new("UICorner")
    UICornerTabs.Parent = TabContainer
    
    local UIListLayoutTabs = Instance.new("UIListLayout")
    UIListLayoutTabs.FillDirection = Enum.FillDirection.Horizontal
    UIListLayoutTabs.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayoutTabs.Padding = UDim.new(0, 10)
    UIListLayoutTabs.Parent = TabContainer
    
    local UIPaddingTabs = Instance.new("UIPadding")
    UIPaddingTabs.PaddingLeft = UDim.new(0, 10)
    UIPaddingTabs.PaddingTop = UDim.new(0, 6)
    UIPaddingTabs.Parent = TabContainer
    
    -- Content scrolling frame
    local ContentScroller = Instance.new("ScrollingFrame")
    ContentScroller.Name = "ContentScroller"
    ContentScroller.BackgroundTransparency = 1
    ContentScroller.BorderSizePixel = 0
    ContentScroller.Position = UDim2.new(0, 0, 0.113, 0)
    ContentScroller.Size = UDim2.new(1, 0, 0.887, 0)
    ContentScroller.CanvasSize = Vector2.new(0, 1000)
    ContentScroller.ScrollBarThickness = 4
    ContentScroller.Parent = ContentFrame
    
    local UIListLayoutContent = Instance.new("UIListLayout")
    UIListLayoutContent.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayoutContent.Padding = UDim.new(0, 12)
    UIListLayoutContent.Parent = ContentScroller
    
    local UIPaddingContent = Instance.new("UIPadding")
    UIPaddingContent.PaddingLeft = UDim.new(0, 18)
    UIPaddingContent.PaddingTop = UDim.new(0, 12)
    UIPaddingContent.Parent = ContentScroller
    
    -- Notification frame
    local NotificationFrame = Instance.new("Frame")
    NotificationFrame.Name = "Notifications"
    NotificationFrame.BackgroundTransparency = 1
    NotificationFrame.Size = UDim2.new(1, 0, 1, 0)
    NotificationFrame.Position = UDim2.new(0, 0, 0, 0)
    NotificationFrame.ZIndex = 100
    NotificationFrame.Parent = ScreenGui
    
    -- Window methods
    function Window:CreateTab(name, icon)
        local Tab = {}
        Tab.Name = name
        Tab.Elements = {}
        
        -- Create tab button
        local TabButton = Instance.new("ImageButton")
        TabButton.Name = name
        TabButton.BackgroundColor3 = WhisperUI.Theme.TabBackground
        TabButton.Size = UDim2.new(0, 67, 0, 32)
        TabButton.Parent = TabContainer
        
        local UICornerTab = Instance.new("UICorner")
        UICornerTab.Parent = TabButton
        
        local TabLabel = Instance.new("TextLabel")
        TabLabel.Name = "Label"
        TabLabel.BackgroundTransparency = 1
        TabLabel.Size = UDim2.new(1, 0, 1, 0)
        TabLabel.Font = Enum.Font.SourceSans
        TabLabel.Text = name
        TabLabel.TextColor3 = WhisperUI.Theme.TextColor
        TabLabel.TextSize = 18
        TabLabel.Parent = TabButton
        
        -- Create tab content (hidden by default)
        Tab.Content = Instance.new("Frame")
        Tab.Content.Name = name
        Tab.Content.BackgroundTransparency = 1
        Tab.Content.Size = UDim2.new(1, 0, 1, 0)
        Tab.Content.Visible = false
        Tab.Content.Parent = ContentScroller
        
        local UIListLayoutTab = Instance.new("UIListLayout")
        UIListLayoutTab.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayoutTab.Padding = UDim.new(0, 12)
        UIListLayoutTab.Parent = Tab.Content
        
        local UIPaddingTab = Instance.new("UIPadding")
        UIPaddingTab.PaddingLeft = UDim.new(0, 18)
        UIPaddingTab.PaddingTop = UDim.new(0, 12)
        UIPaddingTab.Parent = Tab.Content
        
        -- Select tab function
        function Tab:Select()
            if Window.CurrentTab then
                Window.CurrentTab.Content.Visible = false
                Window.CurrentTab.Button.BackgroundColor3 = WhisperUI.Theme.TabBackground
                Window.CurrentTab.Label.TextColor3 = WhisperUI.Theme.TextColor
            end
            
            Window.CurrentTab = Tab
            Tab.Content.Visible = true
            TabButton.BackgroundColor3 = WhisperUI.Theme.TabBackgroundSelected
            TabLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
            
            -- Scroll to top
            ContentScroller.CanvasPosition = Vector2.new(0, 0)
        end
        
        -- Click handler
        TabButton.MouseButton1Click:Connect(function()
            Tab:Select()
        end)
        
        Tab.Button = TabButton
        Tab.Label = TabLabel
        
        -- Select first tab if none selected
        if not Window.CurrentTab then
            Tab:Select()
        end
        
        -- Tab methods
        function Tab:CreateLabel(options)
            local Label = {}
            Label.Text = options.Text or ""
            
            local LabelFrame = Instance.new("Frame")
            LabelFrame.Name = "Label"
            LabelFrame.BackgroundColor3 = WhisperUI.Theme.ElementBackground
            LabelFrame.Size = UDim2.new(0, 333, 0, 28)
            LabelFrame.Parent = Tab.Content
            
            local UICornerLabel = Instance.new("UICorner")
            UICornerLabel.CornerRadius = UDim.new(0, 5)
            UICornerLabel.Parent = LabelFrame
            
            local LabelText = Instance.new("TextLabel")
            LabelText.Name = "Text"
            LabelText.BackgroundTransparency = 1
            LabelText.Position = UDim2.new(0.036, 0, 0, 0)
            LabelText.Size = UDim2.new(0, 307, 0, 28)
            LabelText.Font = Enum.Font.SourceSans
            LabelText.Text = options.Text or ""
            LabelText.TextColor3 = WhisperUI.Theme.TextColor
            LabelText.TextSize = 15
            LabelText.TextXAlignment = Enum.TextXAlignment.Left
            LabelText.Parent = LabelFrame
            
            function Label:Set(newText)
                LabelText.Text = newText
            end
            
            return Label
        end
        
        function Tab:CreateToggle(options)
            local Toggle = {}
            Toggle.Value = options.CurrentValue or false
            Toggle.Name = options.Name or "Toggle"
            
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Name = "Toggle"
            ToggleFrame.BackgroundColor3 = WhisperUI.Theme.ElementBackground
            ToggleFrame.Size = UDim2.new(0, 333, 0, 44)
            ToggleFrame.Parent = Tab.Content
            
            local UICornerToggle = Instance.new("UICorner")
            UICornerToggle.CornerRadius = UDim.new(0, 5)
            UICornerToggle.Parent = ToggleFrame
            
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Name = "Label"
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Position = UDim2.new(0.036, 0, 0, 0)
            ToggleLabel.Size = UDim2.new(0, 226, 0, 44)
            ToggleLabel.Font = Enum.Font.SourceSans
            ToggleLabel.Text = options.Name or "Toggle"
            ToggleLabel.TextColor3 = WhisperUI.Theme.TextColor
            ToggleLabel.TextSize = 15
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.Parent = ToggleFrame
            
            local ToggleButton = Instance.new("ImageButton")
            ToggleButton.Name = "ToggleButton"
            ToggleButton.BackgroundColor3 = Toggle.Value and WhisperUI.Theme.ToggleEnabled or WhisperUI.Theme.ToggleDisabled
            ToggleButton.Position = UDim2.new(0.796, 0, 0.216, 0)
            ToggleButton.Size = UDim2.new(0, 54, 0, 24)
            ToggleButton.Parent = ToggleFrame
            
            local UICornerButton = Instance.new("UICorner")
            UICornerButton.CornerRadius = UDim.new(1, 0)
            UICornerButton.Parent = ToggleButton
            
            local ToggleKnob = Instance.new("ImageButton")
            ToggleKnob.Name = "Knob"
            ToggleKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ToggleKnob.BorderSizePixel = 0
            ToggleKnob.Position = Toggle.Value and UDim2.new(0.6, 0, 0.125, 0) or UDim2.new(0.06, 0, 0.125, 0)
            ToggleKnob.Size = UDim2.new(0, 18, 0, 18)
            ToggleKnob.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
            ToggleKnob.Parent = ToggleButton
            
            local UICornerKnob = Instance.new("UICorner")
            UICornerKnob.CornerRadius = UDim.new(1, 0)
            UICornerKnob.Parent = ToggleKnob
            
            -- Toggle function
            local function updateToggle()
                Toggle.Value = not Toggle.Value
                ToggleButton.BackgroundColor3 = Toggle.Value and WhisperUI.Theme.ToggleEnabled or WhisperUI.Theme.ToggleDisabled
                
                local newPosition = Toggle.Value and UDim2.new(0.6, 0, 0.125, 0) or UDim2.new(0.06, 0, 0.125, 0)
                ToggleKnob:TweenPosition(newPosition, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
                
                if options.Callback then
                    options.Callback(Toggle.Value)
                end
            end
            
            ToggleButton.MouseButton1Click:Connect(updateToggle)
            
            function Toggle:Set(newValue)
                if Toggle.Value ~= newValue then
                    updateToggle()
                end
            end
            
            return Toggle
        end
        
        function Tab:CreateInput(options)
            local Input = {}
            Input.Name = options.Name or "Input"
            Input.Value = options.PlaceholderText or ""
            
            local InputFrame = Instance.new("Frame")
            InputFrame.Name = "Input"
            InputFrame.BackgroundColor3 = WhisperUI.Theme.ElementBackground
            InputFrame.Size = UDim2.new(0, 333, 0, 39)
            InputFrame.Parent = Tab.Content
            
            local UICornerInput = Instance.new("UICorner")
            UICornerInput.CornerRadius = UDim.new(0, 5)
            UICornerInput.Parent = InputFrame
            
            local InputLabel = Instance.new("TextLabel")
            InputLabel.Name = "Label"
            InputLabel.BackgroundTransparency = 1
            InputLabel.Position = UDim2.new(0.036, 0, 0, 0)
            InputLabel.Size = UDim2.new(0, 253, 0, 39)
            InputLabel.Font = Enum.Font.SourceSans
            InputLabel.Text = options.Name or "Input"
            InputLabel.TextColor3 = WhisperUI.Theme.TextColor
            InputLabel.TextSize = 15
            InputLabel.TextXAlignment = Enum.TextXAlignment.Left
            InputLabel.Parent = InputFrame
            
            local InputBox = Instance.new("TextBox")
            InputBox.Name = "Box"
            InputBox.BackgroundColor3 = WhisperUI.Theme.InputBackground
            InputBox.BorderSizePixel = 0
            InputBox.Position = UDim2.new(0.796, 0, 0.179, 0)
            InputBox.Size = UDim2.new(0, 54, 0, 24)
            InputBox.Font = Enum.Font.SourceSans
            InputBox.PlaceholderText = options.PlaceholderText or ""
            InputBox.Text = ""
            InputBox.TextColor3 = WhisperUI.Theme.TextColor
            InputBox.TextSize = 16
            InputBox.Parent = InputFrame
            
            local UICornerBox = Instance.new("UICorner")
            UICornerBox.CornerRadius = UDim.new(0, 6)
            UICornerBox.Parent = InputBox
            
            InputBox.FocusLost:Connect(function()
                Input.Value = InputBox.Text
                if options.Callback then
                    options.Callback(InputBox.Text)
                end
            end)
            
            function Input:Set(newText)
                InputBox.Text = newText
                Input.Value = newText
            end
            
            return Input
        end
        
        function Tab:CreateButton(options)
            local Button = {}
            Button.Name = options.Name or "Button"
            
            local ButtonFrame = Instance.new("Frame")
            ButtonFrame.Name = "Button"
            ButtonFrame.BackgroundColor3 = WhisperUI.Theme.ElementBackground
            ButtonFrame.Size = UDim2.new(0, 333, 0, 34)
            ButtonFrame.Parent = Tab.Content
            
            local UICornerButton = Instance.new("UICorner")
            UICornerButton.CornerRadius = UDim.new(0, 5)
            UICornerButton.Parent = ButtonFrame
            
            local ButtonLabel = Instance.new("TextLabel")
            ButtonLabel.Name = "Label"
            ButtonLabel.BackgroundTransparency = 1
            ButtonLabel.Position = UDim2.new(0.036, 0, 0, 0)
            ButtonLabel.Size = UDim2.new(0, 226, 0, 34)
            ButtonLabel.Font = Enum.Font.SourceSans
            ButtonLabel.Text = options.Name or "Button"
            ButtonLabel.TextColor3 = WhisperUI.Theme.TextColor
            ButtonLabel.TextSize = 15
            ButtonLabel.TextXAlignment = Enum.TextXAlignment.Left
            ButtonLabel.Parent = ButtonFrame
            
            local ButtonText = Instance.new("TextLabel")
            ButtonText.Name = "ButtonText"
            ButtonText.BackgroundTransparency = 1
            ButtonText.Position = UDim2.new(0.796, 0, 0.147, 0)
            ButtonText.Size = UDim2.new(0, 54, 0, 24)
            ButtonText.Font = Enum.Font.SourceSans
            ButtonText.Text = "Button"
            ButtonText.TextColor3 = Color3.fromRGB(111, 111, 111)
            ButtonText.TextSize = 15
            ButtonText.Parent = ButtonFrame
            
            ButtonFrame.MouseEnter:Connect(function()
                ButtonFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            end)
            
            ButtonFrame.MouseLeave:Connect(function()
                ButtonFrame.BackgroundColor3 = WhisperUI.Theme.ElementBackground
            end)
            
            ButtonFrame.MouseButton1Click:Connect(function()
                if options.Callback then
                    options.Callback()
                end
            end)
            
            return Button
        end
        
        function Tab:CreateDropdown(options)
            local Dropdown = {}
            Dropdown.Name = options.Name or "Dropdown"
            Dropdown.Options = options.Options or {}
            Dropdown.CurrentOption = options.CurrentOption or {}
            Dropdown.Multiple = options.MultipleOptions or false
            Dropdown.Open = false
            
            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Name = "Dropdown"
            DropdownFrame.BackgroundColor3 = WhisperUI.Theme.ElementBackground
            DropdownFrame.Size = UDim2.new(0, 333, 0, 180)
            DropdownFrame.Parent = Tab.Content
            
            local UICornerDropdown = Instance.new("UICorner")
            UICornerDropdown.CornerRadius = UDim.new(0, 5)
            UICornerDropdown.Parent = DropdownFrame
            
            local DropdownLabel = Instance.new("TextLabel")
            DropdownLabel.Name = "Label"
            DropdownLabel.BackgroundTransparency = 1
            DropdownLabel.Position = UDim2.new(0.036, 0, 0, 0)
            DropdownLabel.Size = UDim2.new(0, 157, 0, 34)
            DropdownLabel.Font = Enum.Font.SourceSans
            DropdownLabel.Text = options.Name or "Dropdown"
            DropdownLabel.TextColor3 = WhisperUI.Theme.TextColor
            DropdownLabel.TextSize = 15
            DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
            DropdownLabel.Parent = DropdownFrame
            
            local SelectedLabel = Instance.new("TextLabel")
            SelectedLabel.Name = "Selected"
            SelectedLabel.BackgroundTransparency = 1
            SelectedLabel.Position = UDim2.new(0.571, 0, 0, 0)
            SelectedLabel.Size = UDim2.new(0, 89, 0, 34)
            SelectedLabel.Font = Enum.Font.SourceSans
            SelectedLabel.Text = Dropdown.Multiple and "Multiple" or Dropdown.CurrentOption[1] or "None"
            SelectedLabel.TextColor3 = WhisperUI.Theme.TextColor
            SelectedLabel.TextSize = 15
            SelectedLabel.TextXAlignment = Enum.TextXAlignment.Left
            SelectedLabel.Parent = DropdownFrame
            
            local ArrowLabel = Instance.new("TextLabel")
            ArrowLabel.Name = "Arrow"
            ArrowLabel.BackgroundTransparency = 1
            ArrowLabel.Position = UDim2.new(1.209, 0, 0.118, 0)
            ArrowLabel.Size = UDim2.new(0, 18, 0, 30)
            ArrowLabel.Font = Enum.Font.SourceSans
            ArrowLabel.Text = "^"
            ArrowLabel.TextColor3 = WhisperUI.Theme.TextColor
            ArrowLabel.TextSize = 38
            ArrowLabel.TextXAlignment = Enum.TextXAlignment.Left
            ArrowLabel.Parent = SelectedLabel
            
            -- Dropdown content
            local DropdownContent = Instance.new("ScrollingFrame")
            DropdownContent.Name = "Content"
            DropdownContent.BackgroundColor3 = WhisperUI.Theme.DropdownBackground
            DropdownContent.BorderSizePixel = 0
            DropdownContent.Position = UDim2.new(0.048, 0, 0.194, 0)
            DropdownContent.Size = UDim2.new(0, 303, 0, 138)
            DropdownContent.CanvasSize = UDim2.new(0, 0, 0, 0)
            DropdownContent.ScrollBarThickness = 2
            DropdownContent.Visible = false
            DropdownContent.Parent = DropdownFrame
            
            local UICornerContent = Instance.new("UICorner")
            UICornerContent.Parent = DropdownContent
            
            local UIListLayoutContent = Instance.new("UIListLayout")
            UIListLayoutContent.SortOrder = Enum.SortOrder.LayoutOrder
            UIListLayoutContent.Padding = UDim.new(0, 10)
            UIListLayoutContent.Parent = DropdownContent
            
            local UIPaddingContent = Instance.new("UIPadding")
            UIPaddingContent.PaddingLeft = UDim.new(0, 11)
            UIPaddingContent.PaddingTop = UDim.new(0, 15)
            UIPaddingContent.Parent = DropdownContent
            
            -- Create options
            local function createOption(optionText)
                local OptionButton = Instance.new("Frame")
                OptionButton.Name = "Option"
                OptionButton.BackgroundColor3 = WhisperUI.Theme.DropdownOption
                OptionButton.Size = UDim2.new(0, 281, 0, 52)
                OptionButton.Parent = DropdownContent
                
                local UICornerOption = Instance.new("UICorner")
                UICornerOption.Parent = OptionButton
                
                local OptionLabel = Instance.new("TextLabel")
                OptionLabel.Name = "Label"
                OptionLabel.BackgroundTransparency = 1
                OptionLabel.Size = UDim2.new(1, 0, 1, 0)
                OptionLabel.Font = Enum.Font.SourceSans
                OptionLabel.Text = optionText
                OptionLabel.TextColor3 = WhisperUI.Theme.TextColor
                OptionLabel.TextSize = 27
                OptionLabel.Parent = OptionButton
                
                OptionButton.MouseEnter:Connect(function()
                    OptionButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                end)
                
                OptionButton.MouseLeave:Connect(function()
                    OptionButton.BackgroundColor3 = WhisperUI.Theme.DropdownOption
                end)
                
                OptionButton.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        if Dropdown.Multiple then
                            -- Toggle selection for multiple options
                            local index = table.find(Dropdown.CurrentOption, optionText)
                            if index then
                                table.remove(Dropdown.CurrentOption, index)
                            else
                                table.insert(Dropdown.CurrentOption, optionText)
                            end
                        else
                            -- Single selection
                            Dropdown.CurrentOption = {optionText}
                            DropdownContent.Visible = false
                            Dropdown.Open = false
                            ArrowLabel.Text = "^"
                            
                            -- Resize dropdown frame
                            DropdownFrame.Size = UDim2.new(0, 333, 0, 34)
                        end
                        
                        -- Update selected label
                        if Dropdown.Multiple then
                            SelectedLabel.Text = #Dropdown.CurrentOption > 0 and table.concat(Dropdown.CurrentOption, ", ") or "None"
                        else
                            SelectedLabel.Text = Dropdown.CurrentOption[1] or "None"
                        end
                        
                        if options.Callback then
                            options.Callback(Dropdown.CurrentOption)
                        end
                    end
                end)
            end
            
            -- Populate options
            for _, option in ipairs(Dropdown.Options) do
                createOption(option)
            end
            
            -- Update canvas size
            DropdownContent.CanvasSize = UDim2.new(0, 0, 0, UIListLayoutContent.AbsoluteContentSize.Y)
            
            -- Toggle dropdown
            local function toggleDropdown()
                Dropdown.Open = not Dropdown.Open
                DropdownContent.Visible = Dropdown.Open
                ArrowLabel.Text = Dropdown.Open and "v" or "^"
                
                if Dropdown.Open then
                    DropdownFrame.Size = UDim2.new(0, 333, 0, 180)
                else
                    DropdownFrame.Size = UDim2.new(0, 333, 0, 34)
                end
            end
            
            -- Click handlers
            DropdownFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    toggleDropdown()
                end
            end)
            
            -- Close when clicking outside
            game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
                if not processed and input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if Dropdown.Open then
                        local mousePos = game:GetService("UserInputService"):GetMouseLocation()
                        local absPos = DropdownFrame.AbsolutePosition
                        local absSize = DropdownFrame.AbsoluteSize
                        
                        if not (mousePos.X >= absPos.X and mousePos.X <= absPos.X + absSize.X and
                               mousePos.Y >= absPos.Y and mousePos.Y <= absPos.Y + absSize.Y) then
                            toggleDropdown()
                        end
                    end
                end
            end)
            
            -- Methods
            function Dropdown:SetOptions(newOptions)
                Dropdown.Options = newOptions
                DropdownContent:ClearAllChildren()
                
                for _, option in ipairs(newOptions) do
                    createOption(option)
                end
                
                DropdownContent.CanvasSize = UDim2.new(0, 0, 0, UIListLayoutContent.AbsoluteContentSize.Y)
            end
            
            function Dropdown:Set(newOption)
                if Dropdown.Multiple then
                    Dropdown.CurrentOption = newOption
                    SelectedLabel.Text = #newOption > 0 and table.concat(newOption, ", ") or "None"
                else
                    Dropdown.CurrentOption = {newOption}
                    SelectedLabel.Text = newOption or "None"
                end
                
                if options.Callback then
                    options.Callback(Dropdown.CurrentOption)
                end
            end
            
            -- Initially close dropdown
            DropdownFrame.Size = UDim2.new(0, 333, 0, 34)
            
            return Dropdown
        end
        
        function Tab:CreateParagraph(options)
            local Paragraph = {}
            Paragraph.Title = options.Title or ""
            Paragraph.Content = options.Content or ""
            
            local ParagraphFrame = Instance.new("Frame")
            ParagraphFrame.Name = "Paragraph"
            ParagraphFrame.BackgroundColor3 = WhisperUI.Theme.ElementBackground
            ParagraphFrame.Size = UDim2.new(0, 333, 0, 100) -- Default height
            ParagraphFrame.Parent = Tab.Content
            
            local UICornerParagraph = Instance.new("UICorner")
            UICornerParagraph.CornerRadius = UDim.new(0, 5)
            UICornerParagraph.Parent = ParagraphFrame
            
            local TitleLabel = Instance.new("TextLabel")
            TitleLabel.Name = "Title"
            TitleLabel.BackgroundTransparency = 1
            TitleLabel.Position = UDim2.new(0.036, 0, 0, 0)
            TitleLabel.Size = UDim2.new(0.9, 0, 0, 30)
            TitleLabel.Font = Enum.Font.SourceSansBold
            TitleLabel.Text = options.Title or ""
            TitleLabel.TextColor3 = WhisperUI.Theme.TextColor
            TitleLabel.TextSize = 18
            TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
            TitleLabel.Parent = ParagraphFrame
            
            local ContentLabel = Instance.new("TextLabel")
            ContentLabel.Name = "Content"
            ContentLabel.BackgroundTransparency = 1
            ContentLabel.Position = UDim2.new(0.036, 0, 0.3, 0)
            ContentLabel.Size = UDim2.new(0.9, 0, 0.7, 0)
            ContentLabel.Font = Enum.Font.SourceSans
            ContentLabel.Text = options.Content or ""
            ContentLabel.TextColor3 = WhisperUI.Theme.TextColor
            ContentLabel.TextSize = 15
            ContentLabel.TextXAlignment = Enum.TextXAlignment.Left
            ContentLabel.TextYAlignment = Enum.TextYAlignment.Top
            ContentLabel.TextWrapped = true
            ContentLabel.Parent = ParagraphFrame
            
            function Paragraph:Set(newContent)
                if newContent.Title then
                    TitleLabel.Text = newContent.Title
                end
                if newContent.Content then
                    ContentLabel.Text = newContent.Content
                    
                    -- Auto-size the frame based on content
                    local textHeight = ContentLabel.TextBounds.Y
                    local newHeight = math.max(100, textHeight + 50) -- Minimum height of 100
                    ParagraphFrame.Size = UDim2.new(0, 333, 0, newHeight)
                end
            end
            
            return Paragraph
        end
        
        table.insert(Window.Tabs, Tab)
        return Tab
    end
    
    function Window:Notify(options)
        local Notification = {}
        Notification.Title = options.Title or "Notification"
        Notification.Content = options.Content or ""
        Notification.Duration = options.Duration or 5
        Notification.Image = options.Image or "info"
        
        local NotificationFrame = Instance.new("Frame")
        NotificationFrame.Name = "Notification"
        NotificationFrame.BackgroundColor3 = WhisperUI.Theme.NotificationBackground
        NotificationFrame.BorderSizePixel = 0
        NotificationFrame.Size = UDim2.new(0, 300, 0, 80)
        NotificationFrame.Position = UDim2.new(1, -320, 1, -100 - (#self.Notifications * 90))
        NotificationFrame.Parent = self.Notifications
        
        local UICornerNotification = Instance.new("UICorner")
        UICornerNotification.CornerRadius = UDim.new(0, 8)
        UICornerNotification.Parent = NotificationFrame
        
        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Name = "Title"
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.Position = UDim2.new(0.15, 0, 0.1, 0)
        TitleLabel.Size = UDim2.new(0.8, 0, 0.3, 0)
        TitleLabel.Font = Enum.Font.SourceSansBold
        TitleLabel.Text = Notification.Title
        TitleLabel.TextColor3 = WhisperUI.Theme.TextColor
        TitleLabel.TextSize = 18
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        TitleLabel.Parent = NotificationFrame
        
        local ContentLabel = Instance.new("TextLabel")
        ContentLabel.Name = "Content"
        ContentLabel.BackgroundTransparency = 1
        ContentLabel.Position = UDim2.new(0.15, 0, 0.4, 0)
        ContentLabel.Size = UDim2.new(0.8, 0, 0.5, 0)
        ContentLabel.Font = Enum.Font.SourceSans
        ContentLabel.Text = Notification.Content
        ContentLabel.TextColor3 = WhisperUI.Theme.TextColor
        ContentLabel.TextSize = 14
        ContentLabel.TextXAlignment = Enum.TextXAlignment.Left
        ContentLabel.TextYAlignment = Enum.TextYAlignment.Top
        ContentLabel.TextWrapped = true
        ContentLabel.Parent = NotificationFrame
        
        local Icon = Instance.new("ImageLabel")
        Icon.Name = "Icon"
        Icon.BackgroundTransparency = 1
        Icon.Position = UDim2.new(0.05, 0, 0.25, 0)
        Icon.Size = UDim2.new(0, 30, 0, 30)
        Icon.Image = "rbxassetid://" -- Placeholder, you'd need actual image IDs
        Icon.Parent = NotificationFrame
        
        -- Animation
        NotificationFrame:TweenPosition(
            UDim2.new(1, -320, 1, -100 - (#self.Notifications * 90)),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Quad,
            0.3,
            true
        )
        
        -- Auto-remove after duration
        task.delay(Notification.Duration, function()
            NotificationFrame:TweenPosition(
                UDim2.new(1, 0, NotificationFrame.Position.Y.Scale, NotificationFrame.Position.Y.Offset),
                Enum.EasingDirection.In,
                Enum.EasingStyle.Quad,
                0.3,
                true,
                function()
                    NotificationFrame:Destroy()
                    table.remove(self.Notifications, table.find(self.Notifications, Notification))
                    
                    -- Update positions of remaining notifications
                    for i, notif in ipairs(self.Notifications) do
                        notif.Frame:TweenPosition(
                            UDim2.new(1, -320, 1, -100 - ((i - 1) * 90)),
                            Enum.EasingDirection.Out,
                            Enum.EasingStyle.Quad,
                            0.3,
                            true
                        )
                    end
                end
            )
        end)
        
        Notification.Frame = NotificationFrame
        table.insert(self.Notifications, Notification)
    end
    
    function Window:Destroy()
        ScreenGui:Destroy()
    end
    
    return Window
end

return WhisperUI
