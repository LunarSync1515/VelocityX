local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Library do 
	Library = {
        Theme =  { },
        espfont = nil,

        MenuKeybind = tostring(Enum.KeyCode.RightControl), 

        Flags = { },

        Tween = {
            Time = 0.25,
            Style = Enum.EasingStyle.Quart,
            Direction = Enum.EasingDirection.Out
        },

        FadeSpeed = 0.2,

        Folders = {
            Directory = "Aether",
            Configs = "Aether/Configs",
            Assets = "Aether/Assets",
			Sounds = "Aether/Sounds",
        },

        -- Ignore below
        Pages = { },
        Sections = { },

        Connections = { },
        Threads = { },

        ThemeMap = { },
        ThemeItems = { },

        OpenFrames = { },

        SetFlags = { },

        UnnamedConnections = 0,
        UnnamedFlags = 0,

        Holder = nil,
        NotifHolder = nil,
        UnusedHolder = nil,
        KeyList = nil,

        Font = nil,
        CopiedColor = nil,
		Fonts = { },
    }

    Library.__index = Library
    Library.Sections.__index = Library.Sections
    Library.Pages.__index = Library.Pages
end


gethui = gethui or function()
    return CoreGui
end

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local FromRGB = Color3.fromRGB
local FromHSV = Color3.fromHSV
local FromHex = Color3.fromHex

local RGBSequence = ColorSequence.new
local RGBSequenceKeypoint = ColorSequenceKeypoint.new
local NumSequence = NumberSequence.new
local NumSequenceKeypoint = NumberSequenceKeypoint.new

local UDim2New = UDim2.new
local UDimNew = UDim.new
local UDim2FromOffset = UDim2.fromOffset
local Vector2New = Vector2.new
local Vector3New = Vector3.new

local MathClamp = math.clamp
local MathFloor = math.floor
local MathAbs = math.abs
local MathSin = math.sin

local TableInsert = table.insert
local TableFind = table.find
local TableRemove = table.remove
local TableConcat = table.concat
local TableClone = table.clone
local TableUnpack = table.unpack

local StringFormat = string.format
local StringFind = string.find
local StringGSub = string.gsub
local StringLower = string.lower
local StringLen = string.len

local InstanceNew = Instance.new

local RectNew = Rect.new

local Keys = {
    ["Unknown"]           = "Unknown",
    ["Backspace"]         = "Back",
    ["Tab"]               = "Tab",
    ["Clear"]             = "Clear",
    ["Return"]            = "Return",
    ["Pause"]             = "Pause",
    ["Escape"]            = "Escape",
    ["Space"]             = "Space",
    ["QuotedDouble"]      = '"',
    ["Hash"]              = "#",
    ["Dollar"]            = "$",
    ["Percent"]           = "%",
    ["Ampersand"]         = "&",
    ["Quote"]             = "'",
    ["LeftParenthesis"]   = "(",
    ["RightParenthesis"]  = " )",
    ["Asterisk"]          = "*",
    ["Plus"]              = "+",
    ["Comma"]             = ",",
    ["Minus"]             = "-",
    ["Period"]            = ".",
    ["Slash"]             = "`",
    ["Three"]             = "3",
    ["Seven"]             = "7",
    ["Eight"]             = "8",
    ["Colon"]             = ":",
    ["Semicolon"]         = ";",
    ["LessThan"]          = "<",
    ["GreaterThan"]       = ">",
    ["Question"]          = "?",
    ["Equals"]            = "=",
    ["At"]                = "@",
    ["LeftBracket"]       = "LeftBracket",
    ["RightBracket"]      = "RightBracked",
    ["BackSlash"]         = "BackSlash",
    ["Caret"]             = "^",
    ["Underscore"]        = "_",
    ["Backquote"]         = "`",
    ["LeftCurly"]         = "{",
    ["Pipe"]              = "|",
    ["RightCurly"]        = "}",
    ["Tilde"]             = "~",
    ["Delete"]            = "Delete",
    ["End"]               = "End",
    ["KeypadZero"]        = "Keypad0",
    ["KeypadOne"]         = "Keypad1",
    ["KeypadTwo"]         = "Keypad2",
    ["KeypadThree"]       = "Keypad3",
    ["KeypadFour"]        = "Keypad4",
    ["KeypadFive"]        = "Keypad5",
    ["KeypadSix"]         = "Keypad6",
    ["KeypadSeven"]       = "Keypad7",
    ["KeypadEight"]       = "Keypad8",
    ["KeypadNine"]        = "Keypad9",
    ["KeypadPeriod"]      = "KeypadP",
    ["KeypadDivide"]      = "KeypadD",
    ["KeypadMultiply"]    = "KeypadM",
    ["KeypadMinus"]       = "KeypadM",
    ["KeypadPlus"]        = "KeypadP",
    ["KeypadEnter"]       = "KeypadE",
    ["KeypadEquals"]      = "KeypadE",
    ["Insert"]            = "Insert",
    ["Home"]              = "Home",
    ["PageUp"]            = "PageUp",
    ["PageDown"]          = "PageDown",
    ["RightShift"]        = "RightShift",
    ["LeftShift"]         = "LeftShift",
    ["RightControl"]      = "RightControl",
    ["LeftControl"]       = "LeftControl",
    ["LeftAlt"]           = "LeftAlt",
    ["RightAlt"]          = "RightAlt"
}

local Themes = {
    ["Preset"] = {
        ["Window Outline"] = FromRGB(60, 65, 75),

        ["Accent"] = FromRGB(140, 180, 255),

        ["Background 1"] = FromRGB(18,18,19),
        ["Background 2"] = FromRGB(10,10,12),

        ["Inline"] = FromRGB(12,12,14),
        ["Element"] = FromRGB(18,18,20),

        ["Border"] = FromRGB(60, 65, 75),

        ["Text"] = FromRGB(220,220,220),
        ["Inactive Text"] = FromRGB(170,170,170)
    }
}

Library.Theme = TableClone(Themes["Preset"])

-- Folders
for Index, Value in Library.Folders do 
    if not isfolder(Value) then
        makefolder(Value)
    end
end

-- Tweening
local Tween = { } do
    Tween.__index = Tween

    Tween.Create = function(self, Item, Info, Goal, IsRawItem)
        Item = IsRawItem and Item or Item.Instance
        Info = Info or TweenInfo.new(Library.Tween.Time, Library.Tween.Style, Library.Tween.Direction)

        local NewTween = {
            Tween = TweenService:Create(Item, Info, Goal),
            Info = Info,
            Goal = Goal,
            Item = Item
        }

        NewTween.Tween:Play()

        setmetatable(NewTween, Tween)

        return NewTween
    end

    Tween.GetProperty = function(self, Item)
        Item = Item or self.Item 

        if Item:IsA("Frame") then
            return { "BackgroundTransparency" }
        elseif Item:IsA("TextLabel") or Item:IsA("TextButton") then
            return { "TextTransparency", "BackgroundTransparency" }
        elseif Item:IsA("ImageLabel") or Item:IsA("ImageButton") then
            return { "BackgroundTransparency", "ImageTransparency" }
        elseif Item:IsA("ScrollingFrame") then
            return { "BackgroundTransparency", "ScrollBarImageTransparency" }
        elseif Item:IsA("TextBox") then
            return { "TextTransparency", "BackgroundTransparency" }
        elseif Item:IsA("UIStroke") then 
            return { "Transparency" }
        end
    end

    Tween.FadeItem = function(self, Item, Property, Visibility, Speed)
        local Item = Item or self.Item 

        local OldTransparency = Item[Property]
        Item[Property] = Visibility and 1 or OldTransparency

        local NewTween = Tween:Create(Item, TweenInfo.new(Speed or Library.Tween.Time, Library.Tween.Style, Library.Tween.Direction), {
            [Property] = Visibility and OldTransparency or 1
        }, true)

        Library:Connect(NewTween.Tween.Completed, function()
            if not Visibility then 
                task.wait()
                Item[Property] = OldTransparency
            end
        end)

        return NewTween
    end

    Tween.Get = function(self)
        if not self.Tween then 
            return
        end

        return self.Tween, self.Info, self.Goal
    end

    Tween.Pause = function(self)
        if not self.Tween then 
            return
        end

        self.Tween:Pause()
    end

    Tween.Play = function(self)
        if not self.Tween then 
            return
        end

        self.Tween:Play()
    end

    Tween.Clean = function(self)
        if not self.Tween then 
            return
        end

        Tween:Pause()
        self = nil
    end
end

-- Instances
Instances = { } do
    Instances.__index = Instances

    Instances.Create = function(self, Class, Properties)
        local NewItem = {
            Instance = InstanceNew(Class),
            Properties = Properties,
            Class = Class
        }

        setmetatable(NewItem, Instances)

        for Property, Value in NewItem.Properties do
            NewItem.Instance[Property] = Value
        end

        return NewItem
    end

    Instances.FadeItem = function(self, Visibility, Speed)
        local Item = self.Instance

        if Visibility == true then 
            Item.Visible = true
        end

        local Descendants = Item:GetDescendants()
        TableInsert(Descendants, Item)

        local NewTween

        for Index, Value in Descendants do 
            local TransparencyProperty = Tween:GetProperty(Value)

            if not TransparencyProperty then 
                continue
            end

            if type(TransparencyProperty) == "table" then 
                for _, Property in TransparencyProperty do 
                    NewTween = Tween:FadeItem(Value, Property, not Visibility, Speed)
                end
            else
                NewTween = Tween:FadeItem(Value, TransparencyProperty, not Visibility, Speed)
            end
        end
    end

    Instances.AddToTheme = function(self, Properties)
        if not self.Instance then 
            return
        end

        Library:AddToTheme(self, Properties)
    end

    Instances.ChangeItemTheme = function(self, Properties)
        if not self.Instance then 
            return
        end

        Library:ChangeItemTheme(self, Properties)
    end

    Instances.Connect = function(self, Event, Callback, Name)
        if not self.Instance then 
            return
        end

        if not self.Instance[Event] then 
            return
        end

        return Library:Connect(self.Instance[Event], Callback, Name)
    end

    Instances.Tween = function(self, Info, Goal)
        if not self.Instance then 
            return
        end

        return Tween:Create(self, Info, Goal)
    end

    Instances.Disconnect = function(self, Name)
        if not self.Instance then 
            return
        end

        return Library:Disconnect(Name)
    end

    Instances.Clean = function(self)
        if not self.Instance then 
            return
        end

        self.Instance:Destroy()
        self = nil
    end

    Instances.MakeDraggable = function(self)
        if not self.Instance then 
            return
        end
    
        local Gui = self.Instance
        local Dragging = false 
        local DragStart
        local StartPosition 
    
        local Set = function(Input)
            local DragDelta = Input.Position - DragStart
            local NewX = StartPosition.X.Offset + DragDelta.X
            local NewY = StartPosition.Y.Offset + DragDelta.Y

            local ScreenSize = Gui.Parent.AbsoluteSize
            local GuiSize = Gui.AbsoluteSize
    
            NewX = MathClamp(NewX, 0, ScreenSize.X - GuiSize.X)
            NewY = MathClamp(NewY, 0, ScreenSize.Y - GuiSize.Y)
    
            self:Tween(TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(0, NewX, 0, NewY)})
        end
    
        local InputChanged
    
        self:Connect("InputBegan", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                Dragging = true
                DragStart = Input.Position
                StartPosition = Gui.Position
    
                if InputChanged then 
                    return
                end
    
                InputChanged = Input.Changed:Connect(function()
                    if Input.UserInputState == Enum.UserInputState.End then
                        Dragging = false
                        InputChanged:Disconnect()
                        InputChanged = nil
                    end
                end)
            end
        end)
    
        Library:Connect(UserInputService.InputChanged, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                if Dragging then
                    Set(Input)
                end
            end
        end)
    
        return Dragging
    end

    Instances.MakeResizeable = function(self, Minimum, Maximum)
        if not self.Instance then 
            return
        end

        local Gui = self.Instance

        local Resizing = false 
        local CurrentSide = nil

        local StartMouse = nil 
        local StartPosition = nil 
        local StartSize = nil
        
        local EdgeThickness = 2

        local MakeEdge = function(Name, Position, Size)
            local Button = Instances:Create("TextButton", {
                Name = "\0",
                Size = Size,
                Position = Position,
                BackgroundColor3 = FromRGB(166, 147, 243),
                BackgroundTransparency = 1,
                Text = "",
                BorderSizePixel = 0,
                AutoButtonColor = false,
                Parent = Gui,
                ZIndex = 99999,
            })  Button:AddToTheme({BackgroundColor3 = "Accent"})

            return Button
        end

        local Edges = {
            {Button = MakeEdge(
                "Left", 
                UDim2New(0, 0, 0, 0), 
                UDim2New(0, EdgeThickness, 1, 0)), 
                Side = "L"
            },

            {Button = MakeEdge(
                "Right", 
                UDim2New(1, -EdgeThickness, 0, 0), 
                UDim2New(0, EdgeThickness, 1, 0)), 
                Side = "R"
            },

            {Button = MakeEdge(
                "Top", UDim2New(0, 0, 0, 0), 
                UDim2New(1, 0, 0, EdgeThickness)), 
                Side = "T"
            },

            {Button = MakeEdge(
                "Bottom", 
                UDim2New(0, 0, 1, -EdgeThickness), 
                UDim2New(1, 0, 0, EdgeThickness)), 
                Side = "B"
            },
        }

        local BeginResizing = function(Side)
            Resizing = true 
            CurrentSide = Side 

            StartMouse = UserInputService:GetMouseLocation()

            -- store offsets, not absolute screen pos
            StartPosition = Vector2New(Gui.Position.X.Offset, Gui.Position.Y.Offset)
            StartSize = Vector2New(Gui.Size.X.Offset, Gui.Size.Y.Offset)
            
            for Index, Value in Edges do 
                Value.Button.Instance.BackgroundTransparency = (Value.Side == Side) and 0 or 1
            end
        end

        local EndResizing = function()
            Resizing = false 
            CurrentSide = nil

            for Index, Value in Edges do 
                Value.Button.Instance.BackgroundTransparency = 1
            end
        end

        for Index, Value in Edges do 
            Value.Button:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    BeginResizing(Value.Side)
                end
            end)
        end

        Library:Connect(UserInputService.InputEnded, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                if Resizing then
                    EndResizing()
                end
            end
        end)

        Library:Connect(RunService.RenderStepped, function()
            if not Resizing or not CurrentSide then 
                return 
            end

            local MouseLocation = UserInputService:GetMouseLocation()
            local dx = MouseLocation.X - StartMouse.X
            local dy = MouseLocation.Y - StartMouse.Y
        
            local x, y = StartPosition.X, StartPosition.Y
            local w, h = StartSize.X, StartSize.Y

            if CurrentSide == "L" then
                x = StartPosition.X + dx
                w = StartSize.X - dx
            elseif CurrentSide == "R" then
                w = StartSize.X + dx
            elseif CurrentSide == "T" then
                y = StartPosition.Y + dy
                h = StartSize.Y - dy
            elseif CurrentSide == "B" then
                h = StartSize.Y + dy
            end
        
            if w < Minimum.X then
                if CurrentSide == "L" then
                    x = x - (Minimum.X - w)
                end
                w = Minimum.X
            end
            if h < Minimum.Y then
                if CurrentSide == "T" then
                    y = y - (Minimum.Y - h)
                end
                h = Minimum.Y
            end
        
            self:Tween(TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2FromOffset(x, y)})
            self:Tween(TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2FromOffset(w, h)})
        end)
    end

    Instances.OnHover = function(self, Function)
        if not self.Instance then 
            return
        end
        
        return Library:Connect(self.Instance.MouseEnter, Function)
    end

    Instances.OnHoverLeave = function(self, Function)
        if not self.Instance then 
            return
        end
        
        return Library:Connect(self.Instance.MouseLeave, Function)
    end
end

-- Custom font
local CustomFont = { } do
    function CustomFont:New(Name, Weight, Style, Data)
        if isfile(Library.Folders.Assets .. "/" .. Name .. ".json") then
            return Font.new(getcustomasset(Library.Folders.Assets .. "/" .. Name .. ".json"))
        end

        if not isfile(Library.Folders.Assets .. "/" .. Name .. ".ttf") then 
            writefile(Library.Folders.Assets .. "/" .. Name .. ".ttf", game:HttpGet(Data.Url))
        end

        local FontData = {
            name = Name,
            faces = { {
                name = "Regular",
                weight = Weight,
                style = Style,
                assetId = getcustomasset(Library.Folders.Assets .. "/" .. Name .. ".ttf")
            } }
        }

        writefile(Library.Folders.Assets .. "/" .. Name .. ".json", HttpService:JSONEncode(FontData))
        return Font.new(getcustomasset(Library.Folders.Assets .. "/" .. Name .. ".json"))
    end

    function CustomFont:Get(Name)
        if isfile(Library.Folders.Assets .. "/" .. Name .. ".json") then
            return Font.new(getcustomasset(Library.Folders.Assets .. "/" .. Name .. ".json"))
        end
    end

    CustomFont:New("Verdana", 400, "Regular", {
        Id = "Verdana",
        Url = "https://github.com/mainstreamed/clones/raw/refs/heads/main/bred/verdana.ttf"
    })

    CustomFont:New("SmallestPixel", 400, "Regular", {Url = "https://github.com/mainstreamed/clones/raw/refs/heads/main/bred/smallest_pixel-7.ttf"})
    CustomFont:New("ProggyClean", 400, "Regular", {Url = "https://github.com/mainstreamed/clones/raw/refs/heads/main/bred/proggy-clean.ttf"})
    CustomFont:New("TahomaXP", 400, "Regular", {Url = "https://github.com/mainstreamed/clones/raw/refs/heads/main/bred/windows-xp-tahoma.ttf"})
    CustomFont:New("MinecraftiaRegular", 400, "Regular", {Url = "https://github.com/mainstreamed/clones/raw/refs/heads/main/bred/minecraftia-regular.ttf"})
    CustomFont:New("Monaco", 400, "Regular", {Url = "https://github.com/mainstreamed/clones/raw/refs/heads/main/bred/Monaco.ttf"})
    CustomFont:New("Verdana", 400, "Regular", {Url = "https://github.com/mainstreamed/clones/raw/refs/heads/main/bred/verdana.ttf"})
    CustomFont:New("TeachersPet", 400, "Regular", {Url = "https://github.com/mainstreamed/clones/raw/refs/heads/main/bred/teachers-pet.ttf"})
--     CustomFont:New("FSTahoma", 400, "Regular", {Url = "https://github.com/sametexe001/beta/raw/refs/heads/main/fs-tahoma-8px.ttf"})

    Library.Fonts["Smallest Pixel"] = CustomFont:Get("SmallestPixel")
    Library.Fonts["Proggy Clean"] = CustomFont:Get("ProggyClean")
    Library.Fonts["Tahoma XP"] = CustomFont:Get("TahomaXP")
    Library.Fonts["Minecraftia"] = CustomFont:Get("MinecraftiaRegular")
    Library.Fonts["Monaco"] = CustomFont:Get("Monaco")
    Library.Fonts["Verdana"] = CustomFont:Get("Verdana")
    Library.Fonts["Teachers Pet"] = CustomFont:Get("TeachersPet")
--     Library.Fonts['FSTahoma'] = CustomFont:Get("FSTahoma")
    Library.Fonts['Gotham SSm'] = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.ExtraBold)

    Library.Font = CustomFont:Get("Verdana")
    Library.espfont = Library.Fonts["Tahoma XP"]
end

Library.Holder = Instances:Create("ScreenGui", {
    Parent = gethui(),
    Name = "\0",
    ZIndexBehavior = Enum.ZIndexBehavior.Global,
    DisplayOrder = 2,
    IgnoreGuiInset = true,
    ResetOnSpawn = false
})

Library.UnusedHolder = Instances:Create("ScreenGui", {
    Parent = gethui(),
    Name = "\0",
    ZIndexBehavior = Enum.ZIndexBehavior.Global,
    Enabled = false,
    ResetOnSpawn = false
})

Library.NotifHolder = Instances:Create("Frame", {
    Parent = Library.Holder.Instance,
    Name = "\0",
    BorderColor3 = FromRGB(0, 0, 0),
    AnchorPoint = Vector2New(1, 0),
    BackgroundTransparency = 1,
    Position = UDim2New(1, 0, 0, 0),
    Size = UDim2New(0, 0, 1, 0),
    BorderSizePixel = 0,
    AutomaticSize = Enum.AutomaticSize.X,
    BackgroundColor3 = FromRGB(255, 255, 255)
})

Instances:Create("UIListLayout", {
    Parent = Library.NotifHolder.Instance,
    Name = "\0",
    SortOrder = Enum.SortOrder.LayoutOrder,
    HorizontalAlignment = Enum.HorizontalAlignment.Right,
    Padding = UDimNew(0, 8)
})

Instances:Create("UIPadding", {
    Parent = Library.NotifHolder.Instance,
    Name = "\0",
    PaddingTop = UDimNew(0, 15),
    PaddingBottom = UDimNew(0, 15),
    PaddingRight = UDimNew(0, 15),
    PaddingLeft = UDimNew(0, 15)
})

Library.Unload = function(self)
    for Index, Value in self.Connections do 
        Value.Connection:Disconnect()
    end

    for Index, Value in self.Threads do 
        coroutine.close(Value)
    end

    if self.Holder then 
        self.Holder:Clean()
    end

    Library = nil 
    getgenv().Library = nil
end

Library.GetImage = function(self, Image)
    local ImageData = self.Images[Image]

    if not ImageData then 
        return
    end

    return getcustomasset(self.Folders.Assets .. "/" .. ImageData[1])
end

Library.Round = function(self, Number, Float)
    local Multiplier = 1 / (Float or 1)
    return MathFloor(Number * Multiplier) / Multiplier
end

Library.Thread = function(self, Function)
    local NewThread = coroutine.create(Function)
    
    coroutine.wrap(function()
        coroutine.resume(NewThread)
    end)()

    TableInsert(self.Threads, NewThread)
    return NewThread
end

Library.SafeCall = function(self, Function, ...)
    local Arguements = { ... }
    local Success, Result = pcall(Function, TableUnpack(Arguements))

    if not Success then
        LocalPlayer:Kick("Aether Callback Error: " .. tostring(Result))
        return false
    end

    return Success
end

Library.Connect = function(self, Event, Callback, Name)
    Name = Name or StringFormat("connection_number_%s_%s", self.UnnamedConnections + 1, HttpService:GenerateGUID(false))

    local NewConnection = {
        Event = Event,
        Callback = Callback,
        Name = Name,
        Connection = nil
    }

    Library:Thread(function()
        NewConnection.Connection = Event:Connect(Callback)
    end)

    TableInsert(self.Connections, NewConnection)
    return NewConnection
end

Library.Disconnect = function(self, Name)
    for _, Connection in self.Connections do 
        if Connection.Name == Name then
            Connection.Connection:Disconnect()
            break
        end
    end
end

Library.EscapePattern = function(self, String)
    local ShouldEscape = false 

    if string.match(String, "[%(%)%.%%%+%-%*%?%[%]%^%$]") then
        ShouldEscape = true
    end

    if ShouldEscape then
        return StringGSub(String, "[%(%)%.%%%+%-%*%?%[%]%^%$]", "%%%1")
    end

    return String
end

Library.NextFlag = function(self)
    local FlagNumber = self.UnnamedFlags + 1
    return StringFormat("flag_number_%s_%s", FlagNumber, HttpService:GenerateGUID(false))
end

Library.AddToTheme = function(self, Item, Properties)
    Item = Item.Instance or Item 

    local ThemeData = {
        Item = Item,
        Properties = Properties,
    }

    for Property, Value in ThemeData.Properties do
        if type(Value) == "string" then
            Item[Property] = self.Theme[Value]
        else
            Item[Property] = Value()
        end
    end

    TableInsert(self.ThemeItems, ThemeData)
    self.ThemeMap[Item] = ThemeData
end

Library.GetConfig = function(self)
    local Config = {}

    local Success, Result = Library:SafeCall(function()

        -- Save normal flags
        for Index, Value in Library.Flags do
            if type(Value) == "table" and Value.Key then
                Config[Index] = {
                    Key = tostring(Value.Key),
                    Mode = Value.Mode,
                    Toggled = Value.Toggled
                }

            elseif type(Value) == "table" and Value.Color then
                Config[Index] = {
                    Color = "#" .. Value.HexValue,
                    Alpha = Value.Alpha
                }

            else
                Config[Index] = Value
            end
        end

        -- Save widget positions
        Config.WidgetPositions = {}

        if Library.KeybindListInstance and Library.KeybindListInstance.GetPosition then
            Config.WidgetPositions.KeybindList = Library.KeybindListInstance:GetPosition()
        end

        if Library.ArmorViewerInstance and Library.ArmorViewerInstance.GetPosition then
            Config.WidgetPositions.ArmorViewer = Library.ArmorViewerInstance:GetPosition()
        end

        if Library.ModeratorListInstance and Library.ModeratorListInstance.GetPosition then
            Config.WidgetPositions.ModeratorList = Library.ModeratorListInstance:GetPosition()
        end

        if Library.PlayerListInstance and Library.PlayerListInstance.GetPosition then
            Config.WidgetPositions.PlayerList = Library.PlayerListInstance:GetPosition()
        end

        if Library.WatermarkInstance and Library.WatermarkInstance.GetPosition then
            Config.WidgetPositions.Watermark = Library.WatermarkInstance:GetPosition()
        end

        if Library.TargetHudInstance and Library.TargetHudInstance.GetPosition then
            Config.WidgetPositions.TargetHud = Library.TargetHudInstance:GetPosition()
        end

    end)

    return HttpService:JSONEncode(Config)
end


Library.LoadConfig = function(self, Config)
    local Decoded = HttpService:JSONDecode(Config)

    local Success, Result = Library:SafeCall(function()

        for Index, Value in Decoded do
            if Index == "WidgetPositions" then
                continue
            end

            local SetFunction = Library.SetFlags[Index]

            if not SetFunction then
                continue
            end

            if type(Value) == "table" and Value.Key then
                SetFunction(Value)

            elseif type(Value) == "table" and Value.Color then
                SetFunction(Value.Color, Value.Alpha)

            else
                SetFunction(Value)
            end
        end

        -- Restore widget positions
        if Decoded.WidgetPositions then

            if Decoded.WidgetPositions.KeybindList
            and Library.KeybindListInstance
            and Library.KeybindListInstance.SetPosition then
                Library.KeybindListInstance:SetPosition(
                    Decoded.WidgetPositions.KeybindList
                )
            end

            if Decoded.WidgetPositions.ArmorViewer
            and Library.ArmorViewerInstance
            and Library.ArmorViewerInstance.SetPosition then
                Library.ArmorViewerInstance:SetPosition(
                    Decoded.WidgetPositions.ArmorViewer
                )
            end

            if Decoded.WidgetPositions.ModeratorList
            and Library.ModeratorListInstance
            and Library.ModeratorListInstance.SetPosition then
                Library.ModeratorListInstance:SetPosition(
                    Decoded.WidgetPositions.ModeratorList
                )
            end

            if Decoded.WidgetPositions.PlayerList
            and Library.PlayerListInstance
            and Library.PlayerListInstance.SetPosition then
                Library.PlayerListInstance:SetPosition(
                    Decoded.WidgetPositions.PlayerList
                )
            end

            if Decoded.WidgetPositions.Watermark
            and Library.WatermarkInstance
            and Library.WatermarkInstance.SetPosition then
                Library.WatermarkInstance:SetPosition(
                    Decoded.WidgetPositions.Watermark
                )
            end

            if Decoded.WidgetPositions.TargetHud
            and Library.TargetHudInstance
            and Library.TargetHudInstance.SetPosition then
                Library.TargetHudInstance:SetPosition(
                    Decoded.WidgetPositions.TargetHud
                )
            end
        end

    end)

    return Success, Result
end


Library.DeleteConfig = function(self, Config)

    if isfile(Library.Folders.Configs .. "/" .. Config) then
        delfile(Library.Folders.Configs .. "/" .. Config)
    end

end

Library.RefreshConfigsList = function(self, Element)

    local List = {}
    local ReturnList = {}

    List = listfiles(Library.Folders.Configs)

    for Index = 1, #List do
        local File = List[Index]

        if File:sub(-5) == ".json" then

            local Position = File:find(".json", 1, true)
            local StartPosition = Position

            local Character = File:sub(Position, Position)

            while Character ~= "/" and Character ~= "\\" and Character ~= "" do
                Position = Position - 1
                Character = File:sub(Position, Position)
            end

            if Character == "/" or Character == "\\" then
                TableInsert(ReturnList, File:sub(Position + 1, StartPosition - 1))
            end
        end
    end

    Element:Refresh(ReturnList)

end

Library.ChangeItemTheme = function(self, Item, Properties)
    Item = Item.Instance or Item

    if not self.ThemeMap[Item] then 
        return
    end

    self.ThemeMap[Item].Properties = Properties
    self.ThemeMap[Item] = self.ThemeMap[Item]
end

Library.ChangeTheme = function(self, Theme, Color)
    self.Theme[Theme] = Color

    for _, Item in self.ThemeItems do
        for Property, Value in Item.Properties do
            if type(Value) == "string" and Value == Theme then
                Item.Item[Property] = Color
            elseif type(Value) == "function" then
                Item.Item[Property] = Value()
            end
        end
    end
end

Library.IsMouseOverFrame = function(self, Frame)
    Frame = Frame.Instance

    local MousePosition = Vector2New(Mouse.X, Mouse.Y)

    return MousePosition.X >= Frame.AbsolutePosition.X and MousePosition.X <= Frame.AbsolutePosition.X + Frame.AbsoluteSize.X 
    and MousePosition.Y >= Frame.AbsolutePosition.Y and MousePosition.Y <= Frame.AbsolutePosition.Y + Frame.AbsoluteSize.Y
end

Library.GetLighterColor = function(self, Color, Increment)
    local Hue, Saturation, Value = Color:ToHSV()
    return FromHSV(Hue, Saturation, Value * Increment)
end

do 
    Library.CreateColorpicker = function(self, Data)
        local Colorpicker = {
            Hue = 0,
            Saturation = 0,
            Value = 0,

            Alpha = 0,

            IsOpen = false,
            IsOpen2 = false,

            Color = FromRGB(0, 0, 0),
            HexValue = "000000",

            Flag = Data.Flag
        }

        local Items = { } do
            Items["ColorpickerButton"] = Instances:Create("TextButton", {
                Parent = Data.Parent.Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                Size = UDim2New(0, 15, 0, 15),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = FromRGB(140, 255, 213)
            })
            
            Instances:Create("UIStroke", {
                Parent = Items["ColorpickerButton"].Instance,
                Name = "\0",
                Color = FromRGB(46, 52, 61),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})
            
            Instances:Create("UIGradient", {
                Parent = Items["ColorpickerButton"].Instance,
                Name = "\0",
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(152, 152, 152))}
            })                

            Items["ColorpickerWindow"] = Instances:Create("Frame", {
                Parent = Library.UnusedHolder.Instance,
                Name = "\0",
                Visible = false,
                Position = UDim2New(0, 1032, 0, 123),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(0, 232, 0, 265),
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(17, 21, 27)
            })
            
            Items["Glow"] = Instances:Create("ImageLabel", {
                Parent = Items["ColorpickerWindow"].Instance,
                Name = "\0",
                ImageColor3 = FromRGB(94, 213, 213),
                ScaleType = Enum.ScaleType.Slice,
                ImageTransparency = 0.699999988079071,
                BorderColor3 = FromRGB(0, 0, 0),
                BackgroundColor3 = FromRGB(255, 255, 255),
                Size = UDim2New(1, 25, 1, 25),
                AnchorPoint = Vector2New(0.5, 0.5),
                Image = "http://www.roblox.com/asset/?id=18245826428",
                BackgroundTransparency = 1,
                Position = UDim2New(0.5, 0, 0.5, 0),
                ZIndex = -1,
                BorderSizePixel = 0,
                SliceCenter = RectNew(Vector2New(21, 21), Vector2New(79, 79))
            })  Items["Glow"]:AddToTheme({ImageColor3 = "Accent"})
            
            Instances:Create("UIGradient", {
                Parent = Items["Glow"].Instance,
                Name = "\0",
                Rotation = 90,
                Transparency = NumSequence{NumSequenceKeypoint(0, 0), NumSequenceKeypoint(1, 1)}
            })
            
            Instances:Create("UIStroke", {
                Parent = Items["ColorpickerWindow"].Instance,
                Name = "\0",
                Color = FromRGB(94, 213, 213),
                LineJoinMode = Enum.LineJoinMode.Miter
            }):AddToTheme({Color = "Accent"})
            
            Items["Alpha"] = Instances:Create("TextButton", {
                Parent = Items["ColorpickerWindow"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                AnchorPoint = Vector2New(0, 1),
                BorderSizePixel = 0,
                Position = UDim2New(0, 8, 1, -35),
                Size = UDim2New(1, -16, 0, 10),
                ZIndex = 2,
                TextSize = 14,
                BackgroundColor3 = FromRGB(140, 255, 213)
            })
            
            Items["Checkers"] = Instances:Create("ImageLabel", {
                Parent = Items["Alpha"].Instance,
                Name = "\0",
                ScaleType = Enum.ScaleType.Tile,
                BorderColor3 = FromRGB(0, 0, 0),
                TileSize = UDim2New(0, 6, 0, 6),
                Image = "http://www.roblox.com/asset/?id=18274452449",
                BackgroundTransparency = 1,
                Size = UDim2New(1, 0, 1, 0),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            
            Instances:Create("UIGradient", {
                Parent = Items["Checkers"].Instance,
                Name = "\0",
                Transparency = NumSequence{NumSequenceKeypoint(0, 1), NumSequenceKeypoint(0.37, 0.5), NumSequenceKeypoint(1, 0)}
            })
            
            Items["AlphaDragger"] = Instances:Create("Frame", {
                Parent = Items["Alpha"].Instance,
                Name = "\0",
                Size = UDim2New(0, 2, 1, 0),
                Position = UDim2New(0, 8, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            
            Instances:Create("UIStroke", {
                Parent = Items["AlphaDragger"].Instance,
                Name = "\0",
                Color = FromRGB(46, 52, 61),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})
            
            Items["Hue"] = Instances:Create("TextButton", {
                Parent = Items["ColorpickerWindow"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                AnchorPoint = Vector2New(1, 0),
                BorderSizePixel = 0,
                Position = UDim2New(1, -7, 0, 8),
                Size = UDim2New(0, 10, 1, -59),
                ZIndex = 2,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            
            Items["HueInline"] = Instances:Create("TextButton", {
                Parent = Items["Hue"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                BorderSizePixel = 0,
                Size = UDim2New(1, 0, 1, 0),
                ZIndex = 2,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            
            Instances:Create("UIGradient", {
                Parent = Items["HueInline"].Instance,
                Name = "\0",
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 0, 0)), RGBSequenceKeypoint(0.17, FromRGB(255, 255, 0)), RGBSequenceKeypoint(0.33, FromRGB(0, 255, 0)), RGBSequenceKeypoint(0.5, FromRGB(0, 255, 255)), RGBSequenceKeypoint(0.67, FromRGB(0, 0, 255)), RGBSequenceKeypoint(0.83, FromRGB(255, 0, 255)), RGBSequenceKeypoint(1, FromRGB(255, 0, 0))}
            })
            
            Instances:Create("UIStroke", {
                Parent = Items["Hue"].Instance,
                Name = "\0",
                Color = FromRGB(46, 52, 61),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})
            
            Items["HueDragger"] = Instances:Create("Frame", {
                Parent = Items["Hue"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                BackgroundTransparency = -0.009999999776482582,
                Position = UDim2New(0, 0, 0, 8),
                Size = UDim2New(1, 0, 0, 2),
                ZIndex = 3,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            
            Instances:Create("UIStroke", {
                Parent = Items["HueDragger"].Instance,
                Name = "\0",
                Color = FromRGB(46, 52, 61),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})
            
            Items["Palette"] = Instances:Create("TextButton", {
                Parent = Items["ColorpickerWindow"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                BorderSizePixel = 0,
                Position = UDim2New(0, 8, 0, 8),
                Size = UDim2New(1, -31, 1, -59),
                ZIndex = 2,
                TextSize = 14,
                BackgroundColor3 = FromRGB(140, 255, 213)
            })
            
            Instances:Create("UIStroke", {
                Parent = Items["Palette"].Instance,
                Name = "\0",
                Color = FromRGB(46, 52, 61),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})
            
            Items["Saturation"] = Instances:Create("Frame", {
                Parent = Items["Palette"].Instance,
                Name = "\0",
                Size = UDim2New(1, 0, 1, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            
            Instances:Create("UIGradient", {
                Parent = Items["Saturation"].Instance,
                Name = "\0",
                Transparency = NumSequence{NumSequenceKeypoint(0, 1), NumSequenceKeypoint(1, 0)}
            })
            
            Items["Value"] = Instances:Create("Frame", {
                Parent = Items["Palette"].Instance,
                Name = "\0",
                Size = UDim2New(1, 0, 1, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(0, 0, 0)
            })
            
            Instances:Create("UIGradient", {
                Parent = Items["Value"].Instance,
                Name = "\0",
                Rotation = 90,
                Transparency = NumSequence{NumSequenceKeypoint(0, 1), NumSequenceKeypoint(1, 0)}
            })
            
            Items["PaletteDragger"] = Instances:Create("Frame", {
                Parent = Items["Palette"].Instance,
                Name = "\0",
                Size = UDim2New(0, 2, 0, 2),
                Position = UDim2New(0, 8, 0, 8),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            
            Instances:Create("UIStroke", {
                Parent = Items["PaletteDragger"].Instance,
                Name = "\0",
                Color = FromRGB(46, 52, 61),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})
            
            Items["HexInput"] = Instances:Create("TextBox", {
                Parent = Items["ColorpickerWindow"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                ClearTextOnFocus = false,
                TextColor3 = FromRGB(255, 255, 255),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AnchorPoint = Vector2New(0, 1),
                Size = UDim2New(1, -16, 0, 20),
                PlaceholderColor3 = FromRGB(255, 255, 255),
                Position = UDim2New(0, 8, 1, -7),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = FromRGB(32, 38, 48)
            })  Items["HexInput"]:AddToTheme({TextColor3 = "Text", BackgroundColor3 = "Element"})
            
            Instances:Create("UIStroke", {
                Parent = Items["HexInput"].Instance,
                Name = "\0",
                Color = FromRGB(46, 52, 61),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})            
            
            Items["ColorpickerWindow2"] = Instances:Create("Frame", {
                Parent = Library.UnusedHolder.Instance,
                Name = "\0",
                Position = UDim2New(0, 0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(0, 50, 0, 20),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(32, 38, 48),
                AutomaticSize = Enum.AutomaticSize.Y
            })  Items["ColorpickerWindow2"]:AddToTheme({BackgroundColor3 = "Element"})

            Instances:Create("UIStroke", {
                Parent = Items["ColorpickerWindow2"].Instance,
                Name = "\0",
                Color = FromRGB(46, 52, 61),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})

            Instances:Create("UIListLayout", {
                Parent = Items["ColorpickerWindow2"].Instance,
                Name = "\0",
                Padding = UDimNew(0, 2),
                SortOrder = Enum.SortOrder.LayoutOrder
            })
        end

        local AddButton = function(Name, Callback)
            local NewButton = Instances:Create("TextButton", {
                Parent = Items["ColorpickerWindow2"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Name,
                AutoButtonColor = false,
                BackgroundTransparency = 1,
                Size = UDim2New(1, 0, 0, 20),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = FromRGB(32, 38, 48)
            })  NewButton:AddToTheme({TextColor3 = "Text"})

            NewButton:Connect("MouseButton1Down", function()
                Callback()
                Colorpicker:SetOpen2(false)
            end)

            return NewButton
        end

        AddButton("Copy", function()
            local Red = MathFloor(Colorpicker.Color.R * 255)
            local Green = MathFloor(Colorpicker.Color.G * 255)
            local Blue = MathFloor(Colorpicker.Color.B * 255)

            setclipboard(Red .. ", " .. Green .. ", " .. Blue)
            Library.CopiedColor = Red .. ", " .. Green .. ", " .. Blue
        end)
        AddButton("Paste", function()
            if Library.CopiedColor then 
                local Red, Green, Blue = Library.CopiedColor:match("(%d+),%s*(%d+),%s*(%d+)")
                Red, Green, Blue = tonumber(Red), tonumber(Green), tonumber(Blue)

                Colorpicker:Set({Red, Green, Blue}, Colorpicker.Alpha)
            end
        end)

        local SlidingPalette = false
        local SlidingHue = false
        local SlidingAlpha = false

        local Debounce = false
        local RenderStepped  

        local RenderStepped2

        function Colorpicker:Get()
            return Colorpicker.Color, Colorpicker.Alpha
        end

        function Colorpicker:SetOpen(Bool)
            if Debounce then 
                return
            end

            Colorpicker.IsOpen = Bool

            Debounce = true 

            if Colorpicker.IsOpen then 
                Items["ColorpickerWindow"].Instance.Visible = true
                Items["ColorpickerWindow"].Instance.Parent = Library.Holder.Instance
                
                RenderStepped = RunService.RenderStepped:Connect(function()
                    Items["ColorpickerWindow"].Instance.Position = UDim2New(0, Items["ColorpickerButton"].Instance.AbsolutePosition.X, 0, Items["ColorpickerButton"].Instance.AbsolutePosition.Y + Items["ColorpickerButton"].Instance.AbsoluteSize.Y + 65)
                end)

                for Index, Value in Library.OpenFrames do 
                    if Value ~= Colorpicker then 
                        Value:SetOpen(false)
                    end
                end

                Library.OpenFrames[Colorpicker] = Colorpicker 
            else
                if Library.OpenFrames[Colorpicker] then 
                    Library.OpenFrames[Colorpicker] = nil
                end

                if RenderStepped then 
                    RenderStepped:Disconnect()
                    RenderStepped = nil
                end
            end

            local Descendants = Items["ColorpickerWindow"].Instance:GetDescendants()
            TableInsert(Descendants, Items["ColorpickerWindow"].Instance)

            local NewTween

            for Index, Value in Descendants do 
                local TransparencyProperty = Tween:GetProperty(Value)

                if not TransparencyProperty then
                    continue 
                end

                if not Value.ClassName:find("UI") then
                    Value.ZIndex = Colorpicker.IsOpen and 104 or 1
                    Items["Glow"].Instance.ZIndex = Colorpicker.IsOpen and 103 or 1
                end

                if type(TransparencyProperty) == "table" then 
                    for _, Property in TransparencyProperty do 
                        NewTween = Tween:FadeItem(Value, Property, Bool, Library.FadeSpeed)
                    end
                else
                    NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Library.FadeSpeed)
                end
            end
            
            NewTween.Tween.Completed:Connect(function()
                Debounce = false 
                Items["ColorpickerWindow"].Instance.Visible = Colorpicker.IsOpen
                task.wait(0.2)
                Items["ColorpickerWindow"].Instance.Parent = not Colorpicker.IsOpen and Library.UnusedHolder.Instance or Library.Holder.Instance
            end)
        end

        function Colorpicker:SetOpen2(Bool)
            Colorpicker.IsOpen2 = Bool
            if Bool then
                Items["ColorpickerWindow2"].Instance.Visible = true 
                Items["ColorpickerWindow2"].Instance.Parent = Library.Holder.Instance

                RenderStepped2 = RunService.RenderStepped:Connect(function()
                    Items["ColorpickerWindow2"].Instance.Position = UDim2New(0, Items["ColorpickerButton"].Instance.AbsolutePosition.X + Items["ColorpickerButton"].Instance.AbsoluteSize.X, 0, Items["ColorpickerButton"].Instance.AbsolutePosition.Y + Items["ColorpickerButton"].Instance.AbsoluteSize.Y + 65)
                end)
            else
                if RenderStepped2 then 
                    RenderStepped2:Disconnect()
                    RenderStepped2 = nil
                end

                Items["ColorpickerWindow2"].Instance.Visible = false
                Items["ColorpickerWindow2"].Instance.Parent = Library.UnusedHolder.Instance
            end
        end

        function Colorpicker:SlidePalette(Input)
            if not Input or not SlidingPalette then
                return
            end

            local ValueX = MathClamp(1 - (Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) / Items["Palette"].Instance.AbsoluteSize.X, 0, 1)
            local ValueY = MathClamp(1 - (Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) / Items["Palette"].Instance.AbsoluteSize.Y, 0, 1)

            Colorpicker.Saturation = ValueX
            Colorpicker.Value = ValueY

            local SlideX = MathClamp((Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) / Items["Palette"].Instance.AbsoluteSize.X, 0, 0.99)
            local SlideY = MathClamp((Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) / Items["Palette"].Instance.AbsoluteSize.Y, 0, 0.99)

            Items["PaletteDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(SlideX, 0, SlideY, 0)})
            Colorpicker:Update()
        end

        function Colorpicker:SlideHue(Input)
            if not Input or not SlidingHue then
                return
            end
            
            local ValueY = MathClamp((Input.Position.Y - Items["Hue"].Instance.AbsolutePosition.Y) / Items["Hue"].Instance.AbsoluteSize.Y, 0, 1)

            Colorpicker.Hue = ValueY

            local SlideY = MathClamp((Input.Position.Y - Items["Hue"].Instance.AbsolutePosition.Y) / Items["Hue"].Instance.AbsoluteSize.Y, 0, 0.99)

            Items["HueDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(0, 0, SlideY, 0)})
            Colorpicker:Update()
        end

        function Colorpicker:SlideAlpha(Input)
            if not Input or not SlidingAlpha then
                return
            end

            local ValueX = MathClamp((Input.Position.X - Items["Alpha"].Instance.AbsolutePosition.X) / Items["Alpha"].Instance.AbsoluteSize.X, 0, 1)

            Colorpicker.Alpha = ValueX

            local SlideX = MathClamp((Input.Position.X - Items["Alpha"].Instance.AbsolutePosition.X) / Items["Alpha"].Instance.AbsoluteSize.X, 0, 0.99)

            Items["AlphaDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(SlideX, 0, 0, 0)})
            Colorpicker:Update(true)
        end

        function Colorpicker:Update(IsFromAlpha)
            local Hue, Saturation, Value = Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value
            Colorpicker.Color = FromHSV(Hue, Saturation, Value)
            Colorpicker.HexValue = Colorpicker.Color:ToHex()

            Library.Flags[Colorpicker.Flag] = {
                Alpha = Colorpicker.Alpha,
                Color = Colorpicker.Color,
                HexValue = Colorpicker.HexValue,
                Transparency = 1 - Colorpicker.Alpha
            }

            Items["ColorpickerButton"]:Tween(nil, {BackgroundColor3 = Colorpicker.Color})
            Items["Palette"]:Tween(nil, {BackgroundColor3 = FromHSV(Hue, 1, 1)})
            Items["HexInput"].Instance.Text = "#"..Colorpicker.HexValue

            if not IsFromAlpha then 
                Items["Alpha"]:Tween(nil, {BackgroundColor3 = Colorpicker.Color})
            end

            if Data.Callback then 
                Library:SafeCall(Data.Callback, Colorpicker.Color, Colorpicker.Alpha)
            end
        end

        function Colorpicker:Set(Color, Alpha)
            if type(Color) == "table" then
                Color = FromRGB(Color[1], Color[2], Color[3])
            elseif type(Color) == "string" then
                Color = FromHex(Color)
            end 

            Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value = Color:ToHSV()
            Colorpicker.Alpha = Alpha or 0  

            local PaletteValueX = MathClamp(1 - Colorpicker.Saturation, 0, 0.99)
            local PaletteValueY = MathClamp(1 - Colorpicker.Value, 0, 0.99)

            local AlphaPositionX = MathClamp(Colorpicker.Alpha, 0, 0.99)
                
            local HuePositionY = MathClamp(Colorpicker.Hue, 0, 0.99)

            Items["PaletteDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(PaletteValueX, 0, PaletteValueY, 0)})
            Items["HueDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(0, 0, HuePositionY, 0)})
            Items["AlphaDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(AlphaPositionX, 0, 0, 0)})
            Colorpicker:Update(false)
        end

        Items["Palette"]:Connect("InputBegan", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                SlidingPalette = true
                Colorpicker:SlidePalette(Input)
            end
        end)
        
        Items["Palette"]:Connect("InputEnded", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                SlidingPalette = false
            end
        end)

        Items["HueInline"]:Connect("InputBegan", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                SlidingHue = true
                Colorpicker:SlideHue(Input)
            end
        end)
        
        Items["HueInline"]:Connect("InputEnded", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                SlidingHue = false
            end
        end)

        Items["Alpha"]:Connect("InputBegan", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                SlidingAlpha = true
                Colorpicker:SlideAlpha(Input)
            end
        end)
        
        Items["Alpha"]:Connect("InputEnded", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                SlidingAlpha = false
            end
        end)
        
        Items["HexInput"]:Connect("FocusLost", function()
            Colorpicker:Set(tostring(Items["HexInput"].Instance.Text), Colorpicker.Alpha)
        end)

        local CompareVectors = function(PointA, PointB)
            return (PointA.X < PointB.X) or (PointA.Y < PointB.Y)
        end

        local IsClipped = function(Object, Column)
            local Parent = Column
            
            local BoundryTop = Parent.AbsolutePosition
            local BoundryBottom = BoundryTop + Parent.AbsoluteSize

            local Top = Object.AbsolutePosition
            local Bottom = Top + Object.AbsoluteSize 

            return CompareVectors(Top, BoundryTop) or CompareVectors(BoundryBottom, Bottom)
        end

        Items["ColorpickerButton"]:Connect("Changed", function(Property)
            if Property == "AbsolutePosition" and Colorpicker.IsOpen then
                Colorpicker.IsOpen = not IsClipped(Items["ColorpickerWindow"].Instance, Data.Section.Items["Section"].Instance.Parent)
                Items["ColorpickerWindow"].Instance.Visible = Colorpicker.IsOpen
            end
        end)

        Library:Connect(UserInputService.InputChanged, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseMovement then
                if SlidingPalette then
                    Colorpicker:SlidePalette(Input)
                elseif SlidingHue then
                    Colorpicker:SlideHue(Input)
                elseif SlidingAlpha then
                    Colorpicker:SlideAlpha(Input)
                end
            end
        end)

        Library:Connect(UserInputService.InputBegan, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                if not Colorpicker.IsOpen then
                    return
                end

                if Library:IsMouseOverFrame(Items["ColorpickerWindow"]) or Library:IsMouseOverFrame(Items["ColorpickerWindow2"]) then
                    return
                end

                Colorpicker:SetOpen(false)
                Colorpicker:SetOpen2(false)
            end
        end)

        Items["ColorpickerButton"]:Connect("MouseButton1Down", function()
            Colorpicker:SetOpen(not Colorpicker.IsOpen)
        end)

        Items["ColorpickerButton"]:Connect("MouseButton2Down", function()
            Colorpicker:SetOpen2(not Colorpicker.IsOpen2)
        end)

        if Data.Default then 
            Colorpicker:Set(Data.Default, Data.Alpha)
        end

        Library.SetFlags[Colorpicker.Flag] = function(Color, Alpha)
            Colorpicker:Set(Color, Alpha)
        end

        return Colorpicker, Items 
    end
    
    Library.CreateKeybind = function(self, Data)
        local Keybind = {
            IsOpen = false,

            Key = "",
            Toggled = false,
            Mode = "",

            Flag = Data.Flag,

            Picking = false,
            Value = ""
        }

        local KeyListItem 
        if Library.KeyList then 
            KeyListItem = Library.KeyList:Add("", "")
        end

        local Items = { } do 
            Items["KeyButton"] = Instances:Create("TextButton", {
                Parent = Data.Parent.Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                TextTransparency = 0.5,
                Text = "Unbound",
                AutoButtonColor = false,
                Size = UDim2New(0, 0, 0, 15),
                BorderSizePixel = 0,
                BorderColor3 = FromRGB(0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 14,
                BackgroundColor3 = FromRGB(32, 38, 48)
            })  Items["KeyButton"]:AddToTheme({TextColor3 = "Text", BackgroundColor3 = "Element"})
            
            Instances:Create("UIPadding", {
                Parent = Items["KeyButton"].Instance,
                Name = "\0",
                PaddingRight = UDimNew(0, 8),
                PaddingLeft = UDimNew(0, 8)
            })
            
            Instances:Create("UIStroke", {
                Parent = Items["KeyButton"].Instance,
                Name = "\0",
                Color = FromRGB(46, 52, 61),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})

            Items["KeybindWindow"] = Instances:Create("Frame", {
                Parent = Library.UnusedHolder.Instance,
                Name = "\0",
                Visible = false,
                Position = UDim2New(0, 114, 0, 35),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 5,
                Size = UDim2New(0, 78, 0, 66),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(32, 38, 48)
            })  Items["KeybindWindow"]:AddToTheme({BackgroundColor3 = "Element"})

            Items["Toggle"] = Instances:Create("TextButton", {
                Parent = Items["KeybindWindow"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                BorderSizePixel = 0,
                Position = UDim2New(0, 2, 0, 2),
                Size = UDim2New(1, -4, 0, 20),
                ZIndex = 5,
                TextSize = 14,
                BackgroundColor3 = FromRGB(32, 38, 48)
            })  Items["Toggle"]:AddToTheme({BackgroundColor3 = "Element"})

            Instances:Create("UIGradient", {
                Parent = Items["Toggle"].Instance,
                Name = "\0",
                Rotation = -90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(200, 200, 200))}
            })

            Items["ToggleStroke"] = Instances:Create("UIStroke", {
                Parent = Items["Toggle"].Instance,
                Name = "\0",
                Color = FromRGB(46, 52, 61),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            })  Items["ToggleStroke"]:AddToTheme({Color = "Border"})

            Items["ToggleLiner"] = Instances:Create("Frame", {
                Parent = Items["Toggle"].Instance,
                Name = "\0",
                Size = UDim2New(0, 1, 1, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 5,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(94, 213, 213)
            })  Items["ToggleLiner"]:AddToTheme({BackgroundColor3 = "Accent"})

            Items["ToggleText"] = Instances:Create("TextLabel", {
                Parent = Items["Toggle"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "Toggle",
                AutomaticSize = Enum.AutomaticSize.X,
                AnchorPoint = Vector2New(0, 0.5),
                Size = UDim2New(0, 0, 0, 15),
                BackgroundTransparency = 1,
                Position = UDim2New(0, 7, 0.5, 0),
                BorderSizePixel = 0,
                ZIndex = 5,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["ToggleText"]:AddToTheme({TextColor3 = "Text"})

            Items["Hold"] = Instances:Create("TextButton", {
                Parent = Items["KeybindWindow"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                Position = UDim2New(0, 2, 0, 22),
                Size = UDim2New(1, -4, 0, 20),
                ZIndex = 5,
                TextSize = 14,
                BackgroundColor3 = FromRGB(32, 38, 48)
            })  Items["Hold"]:AddToTheme({BackgroundColor3 = "Element"})

            Instances:Create("UIGradient", {
                Parent = Items["Hold"].Instance,
                Name = "\0",
                Rotation = -90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(200, 200, 200))}
            })

            Items["HoldStroke"] = Instances:Create("UIStroke", {
                Parent = Items["Hold"].Instance,
                Name = "\0",
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Transparency = 1,
                Color = FromRGB(46, 52, 61),
                LineJoinMode = Enum.LineJoinMode.Miter
            })  Items["HoldStroke"]:AddToTheme({Color = "Border"})

            Items["HoldLiner"] = Instances:Create("Frame", {
                Parent = Items["Hold"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Size = UDim2New(0, 1, 1, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 5,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(94, 213, 213)
            })  Items["HoldLiner"]:AddToTheme({BackgroundColor3 = "Accent"})

            Items["HoldText"] = Instances:Create("TextLabel", {
                Parent = Items["Hold"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                TextTransparency = 0.4000000059604645,
                Text = "Hold",
                AutomaticSize = Enum.AutomaticSize.X,
                Size = UDim2New(0, 0, 0, 15),
                AnchorPoint = Vector2New(0, 0.5),
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                Position = UDim2New(0, 10, 0.5, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 5,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["HoldText"]:AddToTheme({TextColor3 = "Text"})

            Items["AlwaysOn"] = Instances:Create("TextButton", {
                Parent = Items["KeybindWindow"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                Position = UDim2New(0, 2, 0, 44),
                Size = UDim2New(1, -4, 0, 20),
                ZIndex = 5,
                TextSize = 14,
                BackgroundColor3 = FromRGB(32, 38, 48)
            })

            Instances:Create("UIGradient", {
                Parent = Items["AlwaysOn"].Instance,
                Name = "\0",
                Rotation = -90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(200, 200, 200))}
            })

            Items["AlwaysOnStroke"] = Instances:Create("UIStroke", {
                Parent = Items["AlwaysOn"].Instance,
                Name = "\0",
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Transparency = 1,
                Color = FromRGB(46, 52, 61),
                LineJoinMode = Enum.LineJoinMode.Miter
            })  Items["AlwaysOnStroke"]:AddToTheme({Color = "Border"})

            Items["AlwaysOnLiner"] = Instances:Create("Frame", {
                Parent = Items["AlwaysOn"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Size = UDim2New(0, 1, 1, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 5,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(94, 213, 213)
            })  Items["AlwaysOnLiner"]:AddToTheme({BackgroundColor3 = "Accent"})

            Items["AlwaysOnText"] = Instances:Create("TextLabel", {
                Parent = Items["AlwaysOn"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                TextTransparency = 0.4000000059604645,
                Text = "Always On",
                AutomaticSize = Enum.AutomaticSize.X,
                Size = UDim2New(0, 0, 0, 15),
                AnchorPoint = Vector2New(0, 0.5),
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                Position = UDim2New(0, 10, 0.5, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 5,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["AlwaysOnText"]:AddToTheme({TextColor3 = "Text"})

            Items["KeyButton"]:OnHover(function()
                Items["KeyButton"]:Tween(nil, {BackgroundColor3 = Library:GetLighterColor(Library.Theme.Element, 1.35)})
            end)

            Items["KeyButton"]:OnHoverLeave(function()
                Items["KeyButton"]:Tween(nil, {BackgroundColor3 = Library.Theme.Element})
            end)
        end

        local Update = function()
            if KeyListItem then
                KeyListItem:SetText(Data.Name, Keybind.Value)
                KeyListItem:SetStatus(Keybind.Toggled)
            end
        end

        local Modes = {
            ["Toggle"] = {Items["Toggle"], Items["ToggleText"], Items["ToggleStroke"], Items["ToggleLiner"]},
            ["Hold"] = {Items["Hold"], Items["HoldText"], Items["HoldStroke"], Items["HoldLiner"]},
            ["Always On"] = {Items["AlwaysOn"], Items["AlwaysOnText"], Items["AlwaysOnStroke"], Items["AlwaysOnLiner"]}
        }

        function Keybind:Get()
            return Keybind.Mode, Keybind.Key, Keybind.Toggled
        end

        local Debounce = false
        local RenderStepped  

        function Keybind:SetOpen(Bool)
            if Debounce then 
                return
            end

            Keybind.IsOpen = Bool

            Debounce = true 

            if Keybind.IsOpen then 
                Items["KeybindWindow"].Instance.Visible = true
                Items["KeybindWindow"].Instance.Parent = Library.Holder.Instance
                
                RenderStepped = RunService.RenderStepped:Connect(function()
                    Items["KeybindWindow"].Instance.Position = UDim2New(0, Items["KeyButton"].Instance.AbsolutePosition.X, 0, Items["KeyButton"].Instance.AbsolutePosition.Y + Items["KeyButton"].Instance.AbsoluteSize.Y + 65)
                end)

                if not Debounce then 
                    for Index, Value in Library.OpenFrames do 
                        if Value ~= Keybind then 
                            Value:SetOpen(false)
                        end
                    end

                    Library.OpenFrames[Keybind] = Keybind 
                end
            else
                if not Debounce then 
                    if Library.OpenFrames[Keybind] then 
                        Library.OpenFrames[Keybind] = nil
                    end
                end

                if RenderStepped then 
                    RenderStepped:Disconnect()
                    RenderStepped = nil
                end
            end

            local Descendants = Items["KeybindWindow"].Instance:GetDescendants()
            TableInsert(Descendants, Items["KeybindWindow"].Instance)

            local NewTween

            for Index, Value in Descendants do 
                local TransparencyProperty = Tween:GetProperty(Value)

                if not TransparencyProperty then
                    continue 
                end

                if type(TransparencyProperty) == "table" then 
                    for _, Property in TransparencyProperty do 
                        NewTween = Tween:FadeItem(Value, Property, Bool, Library.FadeSpeed)
                    end
                else
                    NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Library.FadeSpeed)
                end
            end
            
            NewTween.Tween.Completed:Connect(function()
                Debounce = false 
                Items["KeybindWindow"].Instance.Visible = Keybind.IsOpen
                task.wait(0.2)
                Items["KeybindWindow"].Instance.Parent = not Keybind.IsOpen and Library.UnusedHolder.Instance or Library.Holder.Instance
            end)
        end

        function Keybind:Set(Key)
            if StringFind(tostring(Key), "Enum") then 
                Keybind.Key = tostring(Key)

                Key = Key.Name == "Backspace" and "None" or Key.Name

                local KeyString = Keys[Keybind.Key] or StringGSub(Key, "Enum.", "") or "None"
                local TextToDisplay = StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "") or "None"

                Keybind.Value = TextToDisplay
                Items["KeyButton"].Instance.Text = TextToDisplay

                Library.Flags[Keybind.Flag] = {
                    Mode = Keybind.Mode,
                    Key = Keybind.Key,
                    Toggled = Keybind.Toggled,
                    active = Keybind.Toggled
                }

                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end

                Update()
            elseif type(Key) == "table" then
                local RealKey = Key.Key == "Backspace" and "None" or Key.Key
                Keybind.Key = tostring(Key.Key)

                if Key.Mode then
                    Keybind.Mode = Key.Mode
                    Keybind:SetMode(Key.Mode)
                else
                    Keybind.Mode = "Toggle"
                    Keybind:SetMode("Toggle")
                end

                local KeyString = Keys[Keybind.Key] or StringGSub(tostring(RealKey), "Enum.", "") or RealKey
                local TextToDisplay = KeyString and StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "") or "None"

                TextToDisplay = StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "")

                Keybind.Value = TextToDisplay
                Items["KeyButton"].Instance.Text = TextToDisplay

                if Key.Toggled then 
                    Keybind:Press(Key.Toggled, true)
                end

                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end

                Update()
            elseif TableFind({"Toggle", "Hold", "Always"}, Key) then
                Keybind.Mode = Key
                Keybind:SetMode(Keybind.Mode)

                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end

                Update()
            elseif type(Key) == "boolean" then  
                Keybind:Press(Key)
            end

            Keybind.Picking = false
        end

        function Keybind:Press(Bool)
            if Keybind.Mode == "Toggle" then 
                Keybind.Toggled = not Keybind.Toggled
            elseif Keybind.Mode == "Hold" then 
                Keybind.Toggled = Bool
            elseif Keybind.Mode == "Always" then 
                Keybind.Toggled = true
            end

            Library.Flags[Keybind.Flag] = {
                Mode = Keybind.Mode,
                Key = Keybind.Key,
                Toggled = Keybind.Toggled,
                active = Keybind.Toggled
            }

            if Data.Callback then 
                Library:SafeCall(Data.Callback, Keybind.Toggled)
            end

            Update()
        end

        function Keybind:SetMode(Mode)
            for Index, Value in Modes do 
                if Index == Mode then
                    Value[1]:Tween(nil, {BackgroundTransparency = 0})
                    Value[4]:Tween(nil, {BackgroundTransparency = 0})
                    Value[2]:Tween(nil, {TextTransparency = 0})
                    Value[3]:Tween(nil, {Transparency = 0})
                else
                    Value[1]:Tween(nil, {BackgroundTransparency = 1})
                    Value[4]:Tween(nil, {BackgroundTransparency = 1})
                    Value[2]:Tween(nil, {TextTransparency = 0.4})
                    Value[3]:Tween(nil, {Transparency = 1})
                end
            end

            Library.Flags[Keybind.Flag] = {
                Mode = Keybind.Mode,
                Key = Keybind.Key,
                Toggled = Keybind.Toggled,
                active = Keybind.Toggled
            }

            if Data.Callback then 
                Library:SafeCall(Data.Callback, Keybind.Toggled)
            end

            Update()
        end

        local CompareVectors = function(PointA, PointB)
            return (PointA.X < PointB.X) or (PointA.Y < PointB.Y)
        end

        local IsClipped = function(Object, Column)
            local Parent = Column
            
            local BoundryTop = Parent.AbsolutePosition
            local BoundryBottom = BoundryTop + Parent.AbsoluteSize

            local Top = Object.AbsolutePosition
            local Bottom = Top + Object.AbsoluteSize 

            return CompareVectors(Top, BoundryTop) or CompareVectors(BoundryBottom, Bottom)
        end

        Items["KeyButton"]:Connect("Changed", function(Property)
            if Property == "AbsolutePosition" and Keybind.IsOpen then
                Keybind.IsOpen = not IsClipped(Items["KeybindWindow"].Instance, Data.Section.Items["Section"].Instance.Parent)
                Items["KeybindWindow"].Instance.Visible = Keybind.IsOpen
            end
        end)

        Items["KeyButton"]:Connect("MouseButton1Click", function()
            Keybind.Picking = true 

            Items["KeyButton"].Instance.Text = "."
            Library:Thread(function()
                local Count = 1

                while true do 
                    if not Keybind.Picking then 
                        break
                    end

                    if Count == 4 then
                        Count = 1
                    end

                    Items["KeyButton"].Instance.Text = Count == 1 and "." or Count == 2 and ".." or Count == 3 and "..."
                    Count += 1
                    task.wait(0.4)
                end
            end)

            local InputBegan
            InputBegan = UserInputService.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.Keyboard then 
                    Keybind:Set(Input.KeyCode)
                else
                    Keybind:Set(Input.UserInputType)
                end

                InputBegan:Disconnect()
                InputBegan = nil
            end)
        end)

        Items["KeyButton"]:Connect("MouseButton2Down", function()
            Keybind:SetOpen(not Keybind.IsOpen)
        end)

        Library:Connect(UserInputService.InputBegan, function(Input)
            if Keybind.Value == "None" then return end

            if tostring(Input.KeyCode) == Keybind.Key then
                if Keybind.Mode == "Toggle" then 
                    Keybind:Press()
                elseif Keybind.Mode == "Hold" then 
                    Keybind:Press(true)
                elseif Keybind.Mode == "Always" then 
                    Keybind:Press(true)
                end
            elseif tostring(Input.UserInputType) == Keybind.Key then
                if Keybind.Mode == "Toggle" then 
                    Keybind:Press()
                elseif Keybind.Mode == "Hold" then 
                    Keybind:Press(true)
                elseif Keybind.Mode == "Always" then 
                    Keybind:Press(true)
                end
            end

            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                if not Keybind.IsOpen then
                    return
                end

                if Library:IsMouseOverFrame(Items["KeybindWindow"]) then
                    return
                end

                Keybind:SetOpen(false)
            end
        end)

        Library:Connect(UserInputService.InputEnded, function(Input)
            if Keybind.Value == "None" then return end

            if tostring(Input.KeyCode) == Keybind.Key then
                if Keybind.Mode == "Hold" then 
                    Keybind:Press(false)
                elseif Keybind.Mode == "Always" then 
                    Keybind:Press(true)
                end
            elseif tostring(Input.UserInputType) == Keybind.Key then
                if Keybind.Mode == "Hold" then 
                    Keybind:Press(false)
                elseif Keybind.Mode == "Always" then 
                    Keybind:Press(true)
                end
            end
        end)

        Items["Toggle"]:Connect("MouseButton1Down", function()
            Keybind.Mode = "Toggle"
            Keybind:SetMode("Toggle")
        end)

        Items["Hold"]:Connect("MouseButton1Down", function()
            Keybind.Mode = "Hold"
            Keybind:SetMode("Hold")
        end)

        Items["AlwaysOn"]:Connect("MouseButton1Down", function()
            Keybind.Mode = "Always"
            Keybind:SetMode("Always On")
        end)

        if Data.Default then
            Keybind:Set({Key = Data.Default, Mode = Data.Mode or "Toggle", Toggled = Data.Toggled})
        end

        Library.SetFlags[Keybind.Flag] = function(Value)
            Keybind:Set(Value)
        end

        return Keybind, Items 
    end

Library.Watermark = function(self, Name)
    local RunService = game:GetService("RunService")

    local Watermark = { }
    local fps = 0
    local frames = 0
    local lastUpdate = tick()

    local Items = { } do 
        Items["Watermark"] = Instances:Create("Frame", {
            Parent = Library.Holder.Instance,
            Name = "\0",
            AnchorPoint = Vector2New(0.5, 0),
            Position = UDim2New(0.5, 0, 0, 25),
            BorderColor3 = FromRGB(0, 0, 0),
            Size = UDim2New(0, 180, 0, 30),
            BorderSizePixel = 2,
            BackgroundColor3 = FromRGB(17, 21, 27),
            ZIndex = 5,
        })  Items["Watermark"]:AddToTheme({BackgroundColor3 = "Background 1"})

        Items["Watermark"]:MakeDraggable()

        Items["UIStroke"] = Instances:Create("UIStroke", {
            Parent = Items["Watermark"].Instance,
            Name = "\0",
            Color = FromRGB(94, 213, 213),
            LineJoinMode = Enum.LineJoinMode.Miter,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        })  Items["UIStroke"]:AddToTheme({Color = "Accent"})

        Instances:Create("UIGradient", {
            Parent = Items["UIStroke"].Instance,
            Name = "\0",
            Rotation = 90,
            Transparency = NumSequence{
                NumSequenceKeypoint(0, 0),
                NumSequenceKeypoint(0.696, 0.2749999761581421),
                NumSequenceKeypoint(0.84, 0.574999988079071),
                NumSequenceKeypoint(1, 1)
            }
        })

        Items["Glow"] = Instances:Create("ImageLabel", {
            Parent = Items["Watermark"].Instance,
            Name = "\0",
            ImageColor3 = FromRGB(94, 213, 213),
            ScaleType = Enum.ScaleType.Slice,
            ImageTransparency = 0.5,
            BorderColor3 = FromRGB(0, 0, 0),
            BackgroundColor3 = FromRGB(255, 255, 255),
            Size = UDim2New(1, 25, 1, 25),
            AnchorPoint = Vector2New(0.5, 0.5),
            Image = "rbxassetid://18245826428",
            BackgroundTransparency = 1,
            Position = UDim2New(0.5, 0, 0.5, 0),
            ZIndex = 4,
            BorderSizePixel = 0,
            SliceCenter = RectNew(Vector2New(21, 21), Vector2New(79, 79))
        })  Items["Glow"]:AddToTheme({ImageColor3 = "Accent"})

        Instances:Create("UIGradient", {
            Parent = Items["Glow"].Instance,
            Name = "\0",
            Rotation = 90,
            Transparency = NumSequence{
                NumSequenceKeypoint(0, 0),
                NumSequenceKeypoint(1, 1)
            }
        })

        Items["Text"] = Instances:Create("TextLabel", {
            Parent = Items["Watermark"].Instance,
            Name = "\0",
            FontFace = Library.Font,
            TextColor3 = FromRGB(255, 255, 255),
            BorderColor3 = FromRGB(0, 0, 0),
            Text = Name,
            AnchorPoint = Vector2New(0.5, 0.5),
            Size = UDim2New(0, 0, 0, 15),
            BackgroundTransparency = 1,
            Position = UDim2New(0.5, 0, 0.5, 0),
            BorderSizePixel = 0,
            ZIndex = 5,
            AutomaticSize = Enum.AutomaticSize.X,
            TextSize = 14,
            BackgroundColor3 = FromRGB(255, 255, 255)
        })  Items["Text"]:AddToTheme({TextColor3 = "Text"})
    end

    function Watermark:SetText(Text)
        Text = tostring(Text)
        Items["Text"].Instance.Text = Text
        Items["Watermark"]:Tween(nil, {
            Size = UDim2New(0, Items["Text"].Instance.TextBounds.X + 20, 0, 30)
        })
    end

    function Watermark:SetVisibility(Bool)
        Items["Watermark"].Instance.Visible = Bool
    end

    function Watermark:GetPosition()
        local Position = Items["Watermark"].Instance.Position
        return {
            XScale = Position.X.Scale,
            XOffset = Position.X.Offset,
            YScale = Position.Y.Scale,
            YOffset = Position.Y.Offset
        }
    end

    function Watermark:SetPosition(Position)
        if not Position then
            return
        end

        Items["Watermark"].Instance.Position = UDim2New(
            Position.XScale or 0,
            Position.XOffset or 0,
            Position.YScale or 0,
            Position.YOffset or 0
        )
    end

    Watermark:SetText(Name)

    Library.WatermarkInstance = Watermark

    RunService.RenderStepped:Connect(function()
        frames += 1

        if tick() - lastUpdate >= 1 then
            fps = frames
            frames = 0
            lastUpdate = tick()

            local now = os.date("*t")
            local dateText = string.format("%02d/%02d/%04d", now.day, now.month, now.year)
            local timeText = string.format("%02d:%02d:%02d", now.hour, now.min, now.sec)

            Watermark:SetText(string.format(
                "Fallen Survival | %s | %s | %d FPS",
                dateText,
                timeText,
                fps
            ))
        end
    end)

    return Watermark
end

Library.KeybindList = function(self)
    local KeybindList = {}

    Library.KeyList = KeybindList
    self.KeyList = KeybindList

    local Items = {}

    Items["KeybindList"] = Instances:Create("Frame", {
        Parent = Library.Holder.Instance,
        Name = "\0",
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 20, 0.5, 0),
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.XY,
        BackgroundColor3 = Color3.fromRGB(10,12,16),
        ClipsDescendants = false
    })

    -- Top blue line
    Items["TopLine"] = Instances:Create("Frame", {
        Parent = Items["KeybindList"].Instance,
        Position = UDim2.new(0,-1,0,-1),
        Size = UDim2.new(1,2,0,2),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(90,190,255),
        ZIndex = 5
    })

    Instances:Create("UIStroke", {
        Parent = Items["KeybindList"].Instance,
        Color = Color3.fromRGB(35,40,48),
        Thickness = 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })

    Items["Inner"] = Instances:Create("Frame", {
        Parent = Items["KeybindList"].Instance,
        BackgroundTransparency = 1,
        Position = UDim2.new(0,0,0,1),
        AutomaticSize = Enum.AutomaticSize.XY,
        BorderSizePixel = 0
    })

    Instances:Create("UIPadding", {
        Parent = Items["Inner"].Instance,
        PaddingTop = UDim.new(0,6),
        PaddingBottom = UDim.new(0,6),
        PaddingLeft = UDim.new(0,10),
        PaddingRight = UDim.new(0,10)
    })

    -- Dragging
    do
        local frame = Items["KeybindList"].Instance
        local UIS = game:GetService("UserInputService")

        local dragging = false
        local dragStart
        local startPos

        local function update(input)
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end

        frame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = frame.Position

                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)

        UIS.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                update(input)
            end
        end)
    end

    Items["Title"] = Instances:Create("TextLabel", {
        Parent = Items["Inner"].Instance,
        FontFace = Library.Font,
        Text = "Keybinds",
        TextColor3 = Color3.fromRGB(235,235,235),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        Size = UDim2.new(0,80,0,14),
        TextSize = 13
    })

    Items["Divider"] = Instances:Create("Frame", {
        Parent = Items["Inner"].Instance,
        Position = UDim2.new(0,0,0,18),
        Size = UDim2.new(1,0,0,1),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(30,34,40)
    })

    Items["Content"] = Instances:Create("Frame", {
        Parent = Items["Inner"].Instance,
        BackgroundTransparency = 1,
        Position = UDim2.new(0,0,0,22),
        AutomaticSize = Enum.AutomaticSize.XY,
        BorderSizePixel = 0
    })

    Instances:Create("UIListLayout", {
        Parent = Items["Content"].Instance,
        Padding = UDim.new(0,2),
        SortOrder = Enum.SortOrder.LayoutOrder
    })

    function KeybindList:SetVisibility(Bool)
        Items["KeybindList"].Instance.Visible = Bool
    end

    function KeybindList:GetPosition()
        local p = Items["KeybindList"].Instance.Position
        return {
            XScale = p.X.Scale,
            XOffset = p.X.Offset,
            YScale = p.Y.Scale,
            YOffset = p.Y.Offset
        }
    end

    function KeybindList:SetPosition(Pos)
        if typeof(Pos) == "UDim2" then
            Items["KeybindList"].Instance.Position = Pos
            return
        end

        Items["KeybindList"].Instance.Position = UDim2.new(
            Pos.XScale or 0,
            Pos.XOffset or 0,
            Pos.YScale or 0,
            Pos.YOffset or 0
        )
    end

    function KeybindList:Add(Name, Key, Mode)
        Mode = Mode or "Toggle"

        local Row = Instances:Create("Frame", {
            Parent = Items["Content"].Instance,
            BackgroundTransparency = 1,
            Size = UDim2.new(0,0,0,16),
            AutomaticSize = Enum.AutomaticSize.X
        })

        local Check = Instances:Create("Frame", {
            Parent = Row.Instance,
            BackgroundColor3 = Color3.fromRGB(55,60,68),
            BorderSizePixel = 0,
            Size = UDim2.new(0,8,0,8),
            Position = UDim2.new(0,0,0,4)
        })

        local CheckStroke = Instances:Create("UIStroke", {
            Parent = Check.Instance,
            Color = Color3.fromRGB(80,85,95),
            Thickness = 1
        })

        local MainText = Instances:Create("TextLabel", {
            Parent = Row.Instance,
            FontFace = Library.Font,
            Text = string.format("[%s] %s", Key, Name),
            TextColor3 = Color3.fromRGB(220,220,220),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            Position = UDim2.new(0,14,0,0),
            Size = UDim2.new(0,0,0,16),
            AutomaticSize = Enum.AutomaticSize.X,
            TextSize = 13
        })

        local Suffix = Instances:Create("TextLabel", {
            Parent = Row.Instance,
            FontFace = Library.Font,
            Text = " ("..Mode..")",
            TextColor3 = Color3.fromRGB(120,120,120),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            Position = UDim2.new(0,14,0,0),
            Size = UDim2.new(0,0,0,16),
            AutomaticSize = Enum.AutomaticSize.X,
            TextSize = 13
        })

        local CurrentMode = Mode

        local function UpdateSuffix()
            Suffix.Instance.Position =
                UDim2.new(0,14 + MainText.Instance.TextBounds.X + 2,0,0)
        end

        UpdateSuffix()

        function Row:SetText(NewName, NewKey, NewMode)
            Name = NewName or Name
            Key = NewKey or Key
            CurrentMode = NewMode or CurrentMode

            MainText.Instance.Text = string.format("[%s] %s", Key, Name)
            Suffix.Instance.Text = " ("..CurrentMode..")"
            UpdateSuffix()
        end

        function Row:SetStatus(Bool)
            if Bool then
                Check.Instance.BackgroundColor3 = Color3.fromRGB(110,200,255)
                CheckStroke.Instance.Color = Color3.fromRGB(150,220,255)

                MainText.Instance.TextColor3 = Color3.fromRGB(140,210,255)
                Suffix.Instance.TextColor3 = Color3.fromRGB(140,210,255)
            else
                Check.Instance.BackgroundColor3 = Color3.fromRGB(55,60,68)
                CheckStroke.Instance.Color = Color3.fromRGB(80,85,95)

                MainText.Instance.TextColor3 = Color3.fromRGB(220,220,220)
                Suffix.Instance.TextColor3 = Color3.fromRGB(120,120,120)
            end
        end

        return Row
    end

    return KeybindList
end
									
Library.ModeratorList = function(self)

    local ModList = {}
    local Moderators = {}

    local Items = {} do
        Items["ModList"] = Instances:Create("Frame", {
            Parent = Library.Holder.Instance,
            Name = "__ModeratorList",
            AnchorPoint = Vector2New(0, 0.5),
            Position = UDim2New(1, -220, 0.5, 0),
            BorderSizePixel = 0,
            Size = UDim2New(0, 200, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = FromRGB(24, 28, 36)
        })
        Items["ModList"]:AddToTheme({BackgroundColor3 = "Background 2"})
        Items["ModList"]:MakeDraggable()

        Items["ModList"].Instance.ClipsDescendants = false

        Items["TopBar"] = Instances:Create("Frame", {
            Parent = Items["ModList"].Instance,
            Position = UDim2New(0, -9, 0, -9),
            Size = UDim2New(1, 18, 0, 3),
            BorderSizePixel = 0,
            BackgroundColor3 = FromRGB(0,170,255)
        })

        Items["TopBar"].Instance.ZIndex = 60

        local sg = Items["ModList"].Instance:FindFirstAncestorOfClass("ScreenGui")
        if sg then
            sg.ZIndexBehavior = Enum.ZIndexBehavior.Global
        end

        Items["ModList"].Instance.ZIndex = 50

        Instances:Create("UIPadding", {
            Parent = Items["ModList"].Instance,
            PaddingTop = UDimNew(0,9),
            PaddingBottom = UDimNew(0,9),
            PaddingRight = UDimNew(0,9),
            PaddingLeft = UDimNew(0,9)
        })

        Items["Title"] = Instances:Create("TextLabel", {
            Parent = Items["ModList"].Instance,
            FontFace = Library.Font,
            TextColor3 = FromRGB(255,255,255),
            Text = "Moderators",
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            Size = UDim2New(0,150,0,15),
            TextSize = 14
        })
        Items["Title"]:AddToTheme({TextColor3 = "Text"})

        Items["Liner2"] = Instances:Create("Frame", {
            Parent = Items["ModList"].Instance,
            Position = UDim2New(0,0,0,21),
            Size = UDim2New(1,0,0,1),
            BorderSizePixel = 0,
            BackgroundColor3 = FromRGB(46,52,61)
        })
        Items["Liner2"]:AddToTheme({BackgroundColor3 = "Border"})

        Items["Content"] = Instances:Create("Frame", {
            Parent = Items["ModList"].Instance,
            BackgroundTransparency = 1,
            Position = UDim2New(0,0,0,28),
            BorderSizePixel = 0,
            Size = UDim2New(1,0,0,0),
            AutomaticSize = Enum.AutomaticSize.Y
        })

        Items["Title"].Instance.ZIndex = 51
        Items["Liner2"].Instance.ZIndex = 51
        Items["Content"].Instance.ZIndex = 51

        Instances:Create("UIListLayout", {
            Parent = Items["Content"].Instance,
            Padding = UDimNew(0,4),
            SortOrder = Enum.SortOrder.LayoutOrder
        })

        Instances:Create("UIStroke", {
            Parent = Items["ModList"].Instance,
            Color = FromRGB(46,52,61),
            LineJoinMode = Enum.LineJoinMode.Miter,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        }):AddToTheme({Color = "Border"})
    end

    function ModList:SetVisibility(Bool)
        Items["ModList"].Instance.Visible = Bool
    end

    function ModList:GetPosition()
        local p = Items["ModList"].Instance.Position
        return {
            XScale = p.X.Scale,
            XOffset = p.X.Offset,
            YScale = p.Y.Scale,
            YOffset = p.Y.Offset
        }
    end

    function ModList:SetPosition(Pos)
        if not Pos then
            return
        end

        Items["ModList"].Instance.Position = UDim2.new(
            Pos.XScale or 0,
            Pos.XOffset or 0,
            Pos.YScale or 0,
            Pos.YOffset or 0
        )
    end

    function ModList:add_mod(UserId, Username, Role)
        if Moderators[UserId] then
            ModList:remove_mod(UserId)
        end

        Role = Role or "Moderator"

        local ModFrame = Instances:Create("Frame", {
            Parent = Items["Content"].Instance,
            BackgroundTransparency = 1,
            Size = UDim2New(1,0,0,15),
            BorderSizePixel = 0
        })

        local Line = Instances:Create("TextLabel", {
            Parent = ModFrame.Instance,
            FontFace = Library.Font,
            RichText = true,
            TextColor3 = FromRGB(255,255,255),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextSize = 14,
            Size = UDim2New(1,0,0,15),
            Text = ""
        })

        ModFrame.Instance.ZIndex = 52
        Line.Instance.ZIndex = 53
        Line.Instance.Visible = true
        Line.Instance.TextTransparency = 0

        Line.Instance.Text = string.format(
            '<font color="#4DA6FF">%s</font>  <font color="#B9B9B9">%s</font>',
            tostring(Username),
            tostring(Role)
        )

        Moderators[UserId] = {
            Frame = ModFrame,
            Username = Username,
            Role = Role,
            Label = Line
        }

        return Moderators[UserId]
    end

    function ModList:remove_mod(UserId)
        local ModData = Moderators[UserId]
        if ModData then
            ModData.Frame:Clean()
            Moderators[UserId] = nil
        end
    end

    function ModList:Get()
        local ModTable = {}
        for UserId, Data in pairs(Moderators) do
            table.insert(ModTable, {
                userid = UserId,
                username = Data.Username,
                role = Data.Role
            })
        end
        return ModTable
    end

    Library.ModeratorListInstance = ModList

    return ModList
end

Library.ArmorViewer = function(self)
    local Viewer = {
        Items = {}
    }

    local Items = {}
    local Layout

    local MinWidth = 180
    local MaxWidth = 9999
    local BarHeight = 120
    local ItemSize = 82
    local Gap = 8
    local PadL, PadR = 8, 8
    local PadT, PadB = 6, 10
    local HeaderH = 32

    local function Clamp(x, a, b)
        if (x < a) then return a end
        if (x > b) then return b end
        return x
    end

    local function CountItems()
        local n = 0
        for _, c in ipairs(Items["RealHolder"].Instance:GetChildren()) do
            if c:IsA("Frame") then
                n += 1
            end
        end
        return n
    end

    local function UpdateBarSize()
        if not Items["ArmorViewer"] then
            return
        end

        local n = CountItems()
        local contentW

        if n <= 0 then
            contentW = PadL + PadR
        else
            contentW = PadL + PadR + (n * ItemSize) + ((n - 1) * Gap)
        end

        local outerW = contentW + 16
        local w = Clamp(outerW, MinWidth, MaxWidth)

        Items["ArmorViewer"].Instance.Size = UDim2New(0, w, 0, BarHeight)
        Items["Holder"].Instance.Size = UDim2New(1, -16, 1, -(HeaderH + 8))
        Items["RealHolder"].Instance.Size = UDim2New(1, 0, 1, 0)
        Items["RealHolder"].Instance.CanvasSize = UDim2New(0, math.max(0, contentW), 0, 0)
    end

    do
        Items["ArmorViewer"] = Instances:Create("Frame", {
            Parent = Library.Holder.Instance,
            Name = "\0",
            Position = UDim2New(0, 0, 0.5, 0),
            BorderColor3 = FromRGB(0, 0, 0),
            Size = UDim2New(0, MinWidth, 0, BarHeight),
            BorderSizePixel = 0,
            ZIndex = 8,
            BackgroundTransparency = 1,
            BackgroundColor3 = FromRGB(24, 28, 36),
            AnchorPoint = Vector2New(0, 0.5)
        })

        Items["ArmorViewer"]:MakeDraggable()

        Items["Title"] = Instances:Create("TextLabel", {
            Parent = Items["ArmorViewer"].Instance,
            Name = "\0",
            FontFace = Library.Font,
            TextColor3 = FromRGB(255, 255, 255),
            BorderColor3 = FromRGB(0, 0, 0),
            Text = "Armor",
            Size = UDim2New(1, -16, 0, 15),
            Position = UDim2New(0, 8, 0, 8),
            BackgroundTransparency = 1,
            TextTransparency = 0,
            Visible = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            BorderSizePixel = 0,
            ZIndex = 8,
            AutomaticSize = Enum.AutomaticSize.None,
            TextSize = 14,
            BackgroundColor3 = FromRGB(255, 255, 255)
        })  Items["Title"]:AddToTheme({TextColor3 = "Text"})

        Items["Holder"] = Instances:Create("Frame", {
            Parent = Items["ArmorViewer"].Instance,
            Name = "\0",
            BackgroundTransparency = 1,
            Position = UDim2New(0, 8, 0, HeaderH),
            BorderColor3 = FromRGB(0, 0, 0),
            Size = UDim2New(1, -16, 1, -(HeaderH + 8)),
            BorderSizePixel = 0,
            ZIndex = 8,
            BackgroundColor3 = FromRGB(255, 255, 255)
        })

        Items["RealHolder"] = Instances:Create("ScrollingFrame", {
            Parent = Items["Holder"].Instance,
            Name = "\0",
            Active = true,
            AutomaticCanvasSize = Enum.AutomaticSize.None,
            BorderSizePixel = 0,
            CanvasSize = UDim2New(0, 0, 0, 0),
            ScrollBarImageColor3 = FromRGB(46, 52, 61),
            MidImage = "rbxassetid://93024691806056",
            BorderColor3 = FromRGB(0, 0, 0),
            ScrollBarThickness = 3,
            Size = UDim2New(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Position = UDim2New(0, 0, 0, 0),
            ZIndex = 8,
            BottomImage = "rbxassetid://93024691806056",
            TopImage = "rbxassetid://93024691806056",
            BackgroundColor3 = FromRGB(255, 255, 255),
            ScrollingDirection = Enum.ScrollingDirection.X
        })  Items["RealHolder"]:AddToTheme({ScrollBarImageColor3 = "Border"})

        Layout = Instances:Create("UIListLayout", {
            Parent = Items["RealHolder"].Instance,
            Name = "\0",
            SortOrder = Enum.SortOrder.LayoutOrder,
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDimNew(0, Gap)
        })

        Instances:Create("UIPadding", {
            Parent = Items["RealHolder"].Instance,
            Name = "\0",
            PaddingTop = UDimNew(0, PadT),
            PaddingBottom = UDimNew(0, PadB),
            PaddingRight = UDimNew(0, PadR),
            PaddingLeft = UDimNew(0, PadL)
        })

        Items["RealHolder"].Instance.ChildAdded:Connect(function()
            UpdateBarSize()
        end)

        Items["RealHolder"].Instance.ChildRemoved:Connect(function()
            UpdateBarSize()
        end)

        UpdateBarSize()
    end

    function Viewer:Add(Name, Icon)
        local NewItemTable = {}

        local NewItem = Instances:Create("Frame", {
            Parent = Items["RealHolder"].Instance,
            Name = "\0",
            BackgroundTransparency = 1,
            BorderColor3 = FromRGB(0, 0, 0),
            ZIndex = 8,
            Size = UDim2New(0, ItemSize, 0, ItemSize),
            BorderSizePixel = 0,
            BackgroundColor3 = FromRGB(255, 255, 255)
        })

        Instances:Create("ImageLabel", {
            Parent = NewItem.Instance,
            Name = "\0",
            BorderColor3 = FromRGB(0, 0, 0),
            AnchorPoint = Vector2New(0.5, 0.5),
            ZIndex = 8,
            Image = Icon,
            BackgroundTransparency = 1,
            Position = UDim2New(0.5, 0, 0.5, 0),
            Size = UDim2New(0, 50, 0, 50),
            BorderSizePixel = 0,
            BackgroundColor3 = FromRGB(255, 255, 255)
        })

        function NewItemTable:Remove()
            NewItem:Clean()
            Viewer.Items[Name] = nil
            UpdateBarSize()
        end

        Viewer.Items[Name] = NewItemTable
        UpdateBarSize()
        return NewItemTable
    end

    function Viewer:ClearAllItems()
        for _, Value in Viewer.Items do
            if not Value or not Value.Remove then
                continue
            end
            Value:Remove()
        end
        UpdateBarSize()
    end

    function Viewer:SetVisibility(Bool)
        Items["ArmorViewer"].Instance.Visible = Bool
    end

    function Viewer:SetTitle(Name)
        if Items["Title"] and Items["Title"].Instance then
            Items["Title"].Instance.Text = tostring(Name or "")
        end
    end

    function Viewer:SetText(Name)
        Viewer:SetTitle(Name)
    end

    function Viewer:GetPosition()
        local p = Items["ArmorViewer"].Instance.Position

        return {
            XScale = p.X.Scale,
            XOffset = p.X.Offset,
            YScale = p.Y.Scale,
            YOffset = p.Y.Offset
        }
    end

    function Viewer:SetPosition(Position)
        if not Position then
            return
        end

        if typeof(Position) == "UDim2" then
            Items["ArmorViewer"].Instance.Position = Position
            return
        end

        Items["ArmorViewer"].Instance.Position = UDim2.new(
            Position.XScale or 0,
            Position.XOffset or 0,
            Position.YScale or 0,
            Position.YOffset or 0
        )
    end

    function Viewer:SetSizeLimits(Min, Max)
        MinWidth = Min or MinWidth
        MaxWidth = Max or MaxWidth
        UpdateBarSize()
    end

    function Viewer:SetBarHeight(H)
        BarHeight = H or BarHeight
        Items["ArmorViewer"].Instance.Size = UDim2New(0, Items["ArmorViewer"].Instance.Size.X.Offset, 0, BarHeight)
        UpdateBarSize()
    end

    return Viewer
end

    Library.Notification = function(self, Name, Duration)
        local Items = { } do
            Items["Notification"] = Instances:Create("Frame", {
                Parent = self.NotifHolder.Instance,
                Name = "\0",
                Size = UDim2New(0, 20, 0, 20),
                BorderColor3 = FromRGB(0, 0, 0),
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.XY,
                BackgroundColor3 = FromRGB(24, 28, 36)
            })  Items["Notification"]:AddToTheme({BackgroundColor3 = "Inline"})
            
            Instances:Create("UIPadding", {
                Parent = Items["Notification"].Instance,
                Name = "\0",
                PaddingTop = UDimNew(0, 7),
                PaddingBottom = UDimNew(0, 7),
                PaddingRight = UDimNew(0, 7),
                PaddingLeft = UDimNew(0, 7)
            })
            
            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Notification"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Name,
                Size = UDim2New(0, 0, 0, 15),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.XY,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Notification"].Instance,
                Name = "\0",
                Color = FromRGB(46, 52, 61),
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})
        end

        local Size = Items["Notification"].Instance.AbsoluteSize

        for Index, Value in Items do 
            if Value.Instance:IsA("Frame") then
                Value.Instance.BackgroundTransparency = 1
            elseif Value.Instance:IsA("TextLabel") then 
                Value.Instance.TextTransparency = 1
            end
        end 

        Items["Notification"].Instance.AutomaticSize = Enum.AutomaticSize.None

        Library:Thread(function()
            for Index, Value in Items do 
                if Value.Instance:IsA("Frame") then
                    Value:Tween(nil, {BackgroundTransparency = 0})
                elseif Value.Instance:IsA("TextLabel") then 
                    Value:Tween(nil, {TextTransparency = 0})
                end
            end

            Items["Notification"]:Tween(nil, {Size = UDim2New(0, Size.X, 0, Size.Y)})

            task.delay(Duration + 0.1, function()
                for Index, Value in Items do 
                    if Value.Instance:IsA("Frame") then
                        Value:Tween(nil, {BackgroundTransparency = 1})
                    elseif Value.Instance:IsA("TextLabel") then 
                        Value:Tween(nil, {TextTransparency = 1})
                    end
                end

                Items["Notification"]:Tween(nil, {Size = UDim2New(0, 0, 0, 0)})
                
                task.wait(0.5)
                Items["Notification"]:Clean()
            end)
        end)
    end

Library.TargetHud = function(self)
    local TargetHud = {}
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")

    local LocalPlayer = Players.LocalPlayer
    local flags = Library.Flags

    local currentTargetPlayer = nil
    local currentTargetCharacter = nil
    local currentHumanoid = nil
    local currentRootPart = nil
    local currentHealthConn = nil
    local currentCharacterAddedConn = nil
    local currentCharacterRemovingConn = nil
    local renderConn = nil

    local thumbnailCache = {}

    local Items = {} do
        Items["TargetHud"] = Instances:Create("Frame", {
            Parent = Library.Holder.Instance,
            Name = "__TargetHud",
            AnchorPoint = Vector2New(0.5, 0.5),
            Position = UDim2New(0.5, 0, 0.75, 0),
            BorderSizePixel = 0,
            Size = UDim2New(0, 340, 0, 130),
            BackgroundColor3 = FromRGB(16, 16, 18),
            Visible = true
        }) Items["TargetHud"]:AddToTheme({BackgroundColor3 = "Background 2"})

        Items["TargetHud"]:MakeDraggable()

        Instances:Create("UICorner", {
            Parent = Items["TargetHud"].Instance,
            CornerRadius = UDim.new(0, 4)
        })

        Instances:Create("UIStroke", {
            Parent = Items["TargetHud"].Instance,
            Color = FromRGB(125, 190, 255),
            Thickness = 1.5,
            Transparency = 0.35,
            LineJoinMode = Enum.LineJoinMode.Miter,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        })

        Instances:Create("UIStroke", {
            Parent = Items["TargetHud"].Instance,
            Color = FromRGB(125, 190, 255),
            Thickness = 3,
            Transparency = 0.82,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        })

        Items["Title"] = Instances:Create("TextLabel", {
            Parent = Items["TargetHud"].Instance,
            BackgroundTransparency = 1,
            Position = UDim2New(0, 8, 0, 2),
            Size = UDim2New(1, -16, 0, 18),
            FontFace = Library.Font,
            Text = "Target Viewer",
            TextSize = 12,
            TextColor3 = FromRGB(220, 235, 255),
            TextXAlignment = Enum.TextXAlignment.Left
        }) Items["Title"]:AddToTheme({TextColor3 = "Text"})

        Items["TopBar"] = Instances:Create("Frame", {
            Parent = Items["TargetHud"].Instance,
            Position = UDim2New(0, 10, 0, 22),
            Size = UDim2New(1, -20, 0, 2),
            BorderSizePixel = 0,
            BackgroundColor3 = FromRGB(125, 190, 255)
        })

        Items["SectionLabel"] = Instances:Create("TextLabel", {
            Parent = Items["TargetHud"].Instance,
            BackgroundTransparency = 1,
            Position = UDim2New(0, 14, 0, 26),
            Size = UDim2New(0, 80, 0, 16),
            FontFace = Library.Font,
            Text = "info",
            TextSize = 12,
            TextColor3 = FromRGB(205, 220, 245),
            TextXAlignment = Enum.TextXAlignment.Left
        }) Items["SectionLabel"]:AddToTheme({TextColor3 = "Text"})

        Items["Avatar"] = Instances:Create("ImageLabel", {
            Parent = Items["TargetHud"].Instance,
            BackgroundTransparency = 0,
            BackgroundColor3 = FromRGB(28, 28, 32),
            Position = UDim2New(0, 14, 0, 42),
            Size = UDim2New(0, 52, 0, 52),
            BorderSizePixel = 0,
            Image = ""
        })

        Instances:Create("UICorner", {
            Parent = Items["Avatar"].Instance,
            CornerRadius = UDim.new(0, 4)
        })

        Instances:Create("UIStroke", {
            Parent = Items["Avatar"].Instance,
            Color = FromRGB(55, 70, 95),
            Thickness = 1,
            Transparency = 0.35
        })

        Items["NameLabel"] = Instances:Create("TextLabel", {
            Parent = Items["TargetHud"].Instance,
            BackgroundTransparency = 1,
            Position = UDim2New(0, 78, 0, 40),
            Size = UDim2New(1, -88, 0, 16),
            FontFace = Library.Font,
            Text = "",
            TextSize = 13,
            TextColor3 = FromRGB(225, 235, 255),
            TextXAlignment = Enum.TextXAlignment.Left
        }) Items["NameLabel"]:AddToTheme({TextColor3 = "Text"})

        Items["DistanceLabel"] = Instances:Create("TextLabel", {
            Parent = Items["TargetHud"].Instance,
            BackgroundTransparency = 1,
            Position = UDim2New(0, 78, 0, 55),
            Size = UDim2New(1, -88, 0, 14),
            FontFace = Library.Font,
            Text = "",
            TextSize = 12,
            TextColor3 = FromRGB(200, 210, 225),
            TextXAlignment = Enum.TextXAlignment.Left
        }) Items["DistanceLabel"]:AddToTheme({TextColor3 = "Text"})

        Items["VisibleLabel"] = Instances:Create("TextLabel", {
            Parent = Items["TargetHud"].Instance,
            BackgroundTransparency = 1,
            Position = UDim2New(0, 78, 0, 68),
            Size = UDim2New(1, -88, 0, 14),
            FontFace = Library.Font,
            Text = "",
            TextSize = 12,
            TextColor3 = FromRGB(200, 210, 225),
            TextXAlignment = Enum.TextXAlignment.Left
        }) Items["VisibleLabel"]:AddToTheme({TextColor3 = "Text"})

        Items["HealthText"] = Instances:Create("TextLabel", {
            Parent = Items["TargetHud"].Instance,
            BackgroundTransparency = 1,
            Position = UDim2New(0, 78, 0, 81),
            Size = UDim2New(1, -88, 0, 14),
            FontFace = Library.Font,
            Text = "Health",
            TextSize = 12,
            TextColor3 = FromRGB(215, 225, 240),
            TextXAlignment = Enum.TextXAlignment.Left
        }) Items["HealthText"]:AddToTheme({TextColor3 = "Text"})

        Items["HealthBarBg"] = Instances:Create("Frame", {
            Parent = Items["TargetHud"].Instance,
            Position = UDim2New(0, 78, 0, 95),
            Size = UDim2New(0, 190, 0, 8),
            BackgroundColor3 = FromRGB(24, 24, 26),
            BorderSizePixel = 0
        }) Items["HealthBarBg"]:AddToTheme({BackgroundColor3 = "Background 1"})

        Instances:Create("UICorner", {
            Parent = Items["HealthBarBg"].Instance,
            CornerRadius = UDim.new(0, 2)
        })

        Instances:Create("UIStroke", {
            Parent = Items["HealthBarBg"].Instance,
            Color = FromRGB(50, 55, 60),
            Thickness = 1,
            Transparency = 0.5
        }):AddToTheme({Color = "Border"})

        Items["HealthBar"] = Instances:Create("Frame", {
            Parent = Items["HealthBarBg"].Instance,
            Size = UDim2New(0, 0, 1, 0),
            BackgroundColor3 = FromRGB(55, 220, 95),
            BorderSizePixel = 0
        })

        Instances:Create("UICorner", {
            Parent = Items["HealthBar"].Instance,
            CornerRadius = UDim.new(0, 2)
        })

        Items["HealthValueLabel"] = Instances:Create("TextLabel", {
            Parent = Items["TargetHud"].Instance,
            BackgroundTransparency = 1,
            Position = UDim2New(0, 272, 0, 89),
            Size = UDim2New(0, 22, 0, 14),
            FontFace = Library.Font,
            Text = "",
            TextSize = 11,
            TextColor3 = FromRGB(210, 225, 240),
            TextXAlignment = Enum.TextXAlignment.Right
        }) Items["HealthValueLabel"]:AddToTheme({TextColor3 = "Text"})
    end

    local function isEnabled()
        if flags and flags.TargetHudEnabled ~= nil then
            return flags.TargetHudEnabled
        end
        return true
    end

    local function disconnectTargetConnections()
        if currentHealthConn then
            currentHealthConn:Disconnect()
            currentHealthConn = nil
        end

        if currentCharacterAddedConn then
            currentCharacterAddedConn:Disconnect()
            currentCharacterAddedConn = nil
        end

        if currentCharacterRemovingConn then
            currentCharacterRemovingConn:Disconnect()
            currentCharacterRemovingConn = nil
        end
    end

    local function clearTargetState()
        currentTargetPlayer = nil
        currentTargetCharacter = nil
        currentHumanoid = nil
        currentRootPart = nil
    end

    local function getCharacterParts(character)
        if not character then
            return nil, nil
        end

        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local rootPart = character:FindFirstChild("HumanoidRootPart")

        if not humanoid or not rootPart then
            return nil, nil
        end

        return humanoid, rootPart
    end

    local function setAvatar(player)
        if not player then
            Items["Avatar"].Instance.Image = ""
            return
        end

        local cached = thumbnailCache[player.UserId]
        if cached then
            Items["Avatar"].Instance.Image = cached
            return
        end

        local ok, image = pcall(function()
            return Players:GetUserThumbnailAsync(
                player.UserId,
                Enum.ThumbnailType.HeadShot,
                Enum.ThumbnailSize.Size100x100
            )
        end)

        if ok and image then
            thumbnailCache[player.UserId] = image
            Items["Avatar"].Instance.Image = image
        else
            Items["Avatar"].Instance.Image = ""
        end
    end

    local function setHealthBarColor(percent)
        if percent > 0.6 then
            Items["HealthBar"].Instance.BackgroundColor3 = FromRGB(55, 220, 95)
        elseif percent > 0.3 then
            Items["HealthBar"].Instance.BackgroundColor3 = FromRGB(255, 200, 90)
        else
            Items["HealthBar"].Instance.BackgroundColor3 = FromRGB(255, 90, 90)
        end
    end

    local function showEmptyState()
        if not isEnabled() then
            Items["TargetHud"].Instance.Visible = false
            return
        end

        Items["TargetHud"].Instance.Visible = true
        Items["Avatar"].Instance.Image = ""
        Items["NameLabel"].Instance.Text = "Player: none"
        Items["DistanceLabel"].Instance.Text = "Distance: N/A"
        Items["VisibleLabel"].Instance.Text = "Visible: false"
        Items["HealthBar"].Instance.Size = UDim2New(0, 0, 1, 0)
        Items["HealthValueLabel"].Instance.Text = "0/0"
    end

    local function hideHUD()
        disconnectTargetConnections()
        clearTargetState()
        showEmptyState()
    end

    local function updateHUD()
        if not isEnabled() then
            Items["TargetHud"].Instance.Visible = false
            return
        end

        if not currentTargetPlayer or not currentTargetCharacter or not currentHumanoid or not currentRootPart then
            showEmptyState()
            return
        end

        if currentHumanoid.Health <= 0 then
            hideHUD()
            return
        end

        Items["TargetHud"].Instance.Visible = true

        local player = currentTargetPlayer
        if player.DisplayName ~= player.Name then
            Items["NameLabel"].Instance.Text = string.format("Player: %s (@%s)", player.DisplayName, player.Name)
        else
            Items["NameLabel"].Instance.Text = string.format("Player: %s", player.Name)
        end

        local health = currentHumanoid.Health
        local maxHealth = math.max(currentHumanoid.MaxHealth, 1)
        local percent = math.clamp(health / maxHealth, 0, 1)

        Items["HealthBar"].Instance.Size = UDim2New(percent, 0, 1, 0)
        Items["HealthValueLabel"].Instance.Text = string.format("%d/%d", math.floor(health), math.floor(maxHealth))
        setHealthBarColor(percent)

        local localCharacter = LocalPlayer.Character
        local localRoot = localCharacter and localCharacter:FindFirstChild("HumanoidRootPart")

        if localRoot then
            local distance = (localRoot.Position - currentRootPart.Position).Magnitude
            Items["DistanceLabel"].Instance.Text = string.format("Distance: %.0f", distance)
        else
            Items["DistanceLabel"].Instance.Text = "Distance: N/A"
        end

        Items["VisibleLabel"].Instance.Text = "Visible: true"
    end

    local function bindHealthConnection(player, character, humanoid)
        if currentHealthConn then
            currentHealthConn:Disconnect()
            currentHealthConn = nil
        end

        if not humanoid then
            return
        end

        currentHealthConn = humanoid.HealthChanged:Connect(function()
            if currentTargetPlayer == player and currentTargetCharacter == character and currentHumanoid == humanoid then
                updateHUD()
            end
        end)
    end

    local function bindTarget(player, character)
        disconnectTargetConnections()

        currentTargetPlayer = player
        currentTargetCharacter = character
        currentHumanoid, currentRootPart = getCharacterParts(character)

        if not currentHumanoid or not currentRootPart then
            showEmptyState()
            return
        end

        setAvatar(player)
        bindHealthConnection(player, character, currentHumanoid)
        updateHUD()

        currentCharacterAddedConn = player.CharacterAdded:Connect(function(newCharacter)
            if currentTargetPlayer ~= player then
                return
            end

            currentTargetCharacter = newCharacter
            currentHumanoid, currentRootPart = getCharacterParts(newCharacter)

            if currentHumanoid and currentRootPart then
                bindHealthConnection(player, newCharacter, currentHumanoid)
                updateHUD()
            else
                showEmptyState()
            end
        end)

        currentCharacterRemovingConn = player.CharacterRemoving:Connect(function(removingCharacter)
            if currentTargetPlayer == player and currentTargetCharacter == removingCharacter then
                hideHUD()
            end
        end)
    end

    local function getTargetPlayerFromTargeting()
        local character = Library.Targeting and Library.Targeting.TargetCharacter
        if not character then
            return nil, nil
        end

        if typeof(character) ~= "Instance" or not character:IsA("Model") then
            return nil, nil
        end

        if character == LocalPlayer.Character then
            return nil, nil
        end

        if character.Name:lower():find("soldier") then
            return nil, nil
        end

        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid or humanoid.Health <= 0 then
            return nil, nil
        end

        local player = Players:GetPlayerFromCharacter(character)
        if not player then
            return nil, nil
        end

        return player, character
    end

    function TargetHud:SetVisibility(Bool)
        Bool = Bool and true or false

        if flags then
            flags.TargetHudEnabled = Bool
        end

        if Bool then
            showEmptyState()
        else
            Items["TargetHud"].Instance.Visible = false
        end
    end

    function TargetHud:GetPosition()
        local p = Items["TargetHud"].Instance.Position
        return {
            XScale = p.X.Scale,
            XOffset = p.X.Offset,
            YScale = p.Y.Scale,
            YOffset = p.Y.Offset
        }
    end

    function TargetHud:SetPosition(Pos)
        if not Pos then
            return
        end

        Items["TargetHud"].Instance.Position = UDim2.new(
            Pos.XScale or 0,
            Pos.XOffset or 0,
            Pos.YScale or 0,
            Pos.YOffset or 0
        )
    end

    function TargetHud:Destroy()
        if renderConn then
            renderConn:Disconnect()
            renderConn = nil
        end

        disconnectTargetConnections()

        if Items["TargetHud"] then
            Items["TargetHud"]:Clean()
        end
    end

    if flags and flags.TargetHudEnabled == nil then
        flags.TargetHudEnabled = true
    end

    if isEnabled() then
        showEmptyState()
    else
        Items["TargetHud"].Instance.Visible = false
    end

    renderConn = RunService.RenderStepped:Connect(function()
        if not isEnabled() then
            Items["TargetHud"].Instance.Visible = false
            return
        end

        local targetPlayer, targetCharacter = getTargetPlayerFromTargeting()

        if not targetPlayer or not targetCharacter then
            hideHUD()
            return
        end

        if targetPlayer ~= currentTargetPlayer or targetCharacter ~= currentTargetCharacter then
            bindTarget(targetPlayer, targetCharacter)
        else
            updateHUD()
        end
    end)

    Library.TargetHudInstance = TargetHud
    return TargetHud
end
									
return Library















