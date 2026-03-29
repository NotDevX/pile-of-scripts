--[[
	World Edit Thingamabob - Fused Script
	Tool + GUI + Logic all in one
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

local Tool = Instance.new("Tool")
Tool.Name = "World Edit Thingamabob"
Tool.RequiresHandle = false
Tool.Parent = Player:WaitForChild("Backpack")

local Gui = Instance.new("ScreenGui")
Gui.Name = "WorldEditGUI"
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.DisplayOrder = 101
Gui.ResetOnSpawn = false
Gui.Parent = Tool

local SelectionBox = Instance.new("SelectionBox")
SelectionBox.LineThickness = 0.05
SelectionBox.Color3 = Color3.new(1, 1, 1)
SelectionBox.Parent = Tool

local currentTarget = nil
local hue = 0

local OptionsFrame = Instance.new("Frame")
OptionsFrame.Name = "OptionsFrame"
OptionsFrame.Parent = Gui
OptionsFrame.BackgroundColor3 = Color3.fromRGB(0, 56, 159)
OptionsFrame.Position = UDim2.new(0.747, 0, 0.836, 0)
OptionsFrame.Size = UDim2.new(0.206, 0, 0.056, 0)
OptionsFrame.BorderSizePixel = 0
Instance.new("UICorner", OptionsFrame).CornerRadius = UDim.new(0.2, 0)

local ValueFrame = Instance.new("Frame")
ValueFrame.Name = "ValueFrame"
ValueFrame.Parent = Gui
ValueFrame.BackgroundColor3 = Color3.fromRGB(0, 56, 159)
ValueFrame.Position = UDim2.new(0.747, 0, 0.767, 0)
ValueFrame.Size = UDim2.new(0.206, 0, 0.056, 0)
ValueFrame.BorderSizePixel = 0
ValueFrame.Visible = false
Instance.new("UICorner", ValueFrame).CornerRadius = UDim.new(0.2, 0)

local UIGridLayout = Instance.new("UIGridLayout")
UIGridLayout.Parent = OptionsFrame
UIGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIGridLayout.VerticalAlignment = Enum.VerticalAlignment.Center
UIGridLayout.CellSize = UDim2.new(0.127, 0, 0.769, 0)

local function createButton(name, text)
	local btn = Instance.new("TextButton")
	btn.Name = name
	btn.Text = text
	btn.Font = Enum.Font.Code
	btn.TextScaled = true
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.BackgroundColor3 = Color3.fromRGB(97, 126, 255)
	btn.Size = UDim2.new(0, 100, 0, 30)
	btn.BorderSizePixel = 0
	Instance.new("UICorner", btn)
	btn.Parent = OptionsFrame
	return btn
end

local Delete = createButton("Delete", "×")
local ClonePart = createButton("ClonePart", "C")
local Anchor = createButton("Anchor", "A")
local Goto = createButton("Goto", "G")
local Highlight = createButton("Highlight", "H")
local TransparencyPart = createButton("TransparencyPart", "T")
local ExportValues = createButton("ExportValues", "E")
ExportValues.Visible = false

local SlideBackground = Instance.new("Frame", ValueFrame)
SlideBackground.Name = "SlideBackground"
SlideBackground.BackgroundColor3 = Color3.fromRGB(0, 36, 97)
SlideBackground.Position = UDim2.new(0.025, 0, 0.138, 0)
SlideBackground.Size = UDim2.new(0.949, 0, 0.709, 0)
SlideBackground.BorderSizePixel = 0
Instance.new("UICorner", SlideBackground).CornerRadius = UDim.new(0.2, 0)

local Slider = Instance.new("Frame", SlideBackground)
Slider.Name = "Slider"
Slider.BackgroundColor3 = Color3.fromRGB(0, 81, 222)
Slider.Size = UDim2.new(1, 0, 1, 0)
Slider.BorderSizePixel = 0
Instance.new("UICorner", Slider).CornerRadius = UDim.new(0.2, 0)

local TextButton = Instance.new("TextButton", SlideBackground)
TextButton.BackgroundTransparency = 1
TextButton.Size = UDim2.new(1, 0, 1, 0)
TextButton.Text = ""
TextButton.TextTransparency = 1

local OutputValue = Instance.new("NumberValue", SlideBackground)
OutputValue.Name = "OutputValue"
OutputValue.Value = 0

Tool.Equipped:Connect(function()
	Gui.Parent = CoreGui
end)

Tool.Unequipped:Connect(function()
	Gui.Parent = Tool
	currentTarget = nil
	SelectionBox.Adornee = nil
	ValueFrame.Visible = false
end)

Tool.Activated:Connect(function()
	currentTarget = Mouse.Target
	SelectionBox.Adornee = currentTarget
end)

RunService.RenderStepped:Connect(function()
	hue = (hue + 0.01) % 1
	SelectionBox.Color3 = Color3.fromHSV(hue, 1, 1)
end)

Delete.MouseButton1Click:Connect(function()
	if currentTarget then
		currentTarget:Destroy()
		currentTarget = nil
		SelectionBox.Adornee = nil
	end
end)

ClonePart.MouseButton1Click:Connect(function()
	if currentTarget then
		local c = currentTarget:Clone()
		c.Parent = currentTarget.Parent
		c.CFrame = currentTarget.CFrame + Vector3.new(0, currentTarget.Size.Y + 1, 0)
		currentTarget = c
		SelectionBox.Adornee = c
	end
end)

Anchor.MouseButton1Click:Connect(function()
	if currentTarget then
		currentTarget.Anchored = not currentTarget.Anchored
		if currentTarget.Anchored then
			currentTarget.AssemblyLinearVelocity = Vector3.zero
			currentTarget.AssemblyAngularVelocity = Vector3.zero
		end
	end
end)

Goto.MouseButton1Click:Connect(function()
	if currentTarget then
		local hrp = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
		if hrp then
			hrp.CFrame = currentTarget.CFrame + Vector3.new(0, 5, 0)
		end
	end
end)

Highlight.MouseButton1Click:Connect(function()
	if currentTarget then
		local h = Instance.new("Highlight", Tool)
		h.Adornee = currentTarget
		currentTarget.Destroying:Connect(function()
			h:Destroy()
			currentTarget = nil
			SelectionBox.Adornee = nil
		end)
	end
end)

TransparencyPart.MouseButton1Click:Connect(function()
	if currentTarget then
		ValueFrame.Visible = true
		local con; con = OutputValue.Changed:Connect(function(v)
			if currentTarget then
				currentTarget.Transparency = v
			else
				ValueFrame.Visible = false
				con:Disconnect()
			end
		end)
	end
end)

TextButton.MouseButton1Down:Connect(function()
	local dragging = true
	local function update()
		if dragging then
			local x = math.clamp((Mouse.X - SlideBackground.AbsolutePosition.X) / SlideBackground.AbsoluteSize.X, 0, 1)
			OutputValue.Value = x
			Slider.Size = UDim2.new(x, 0, 1, 0)
		end
	end

	update()
	local conn = Mouse.Move:Connect(update)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
			conn:Disconnect()
		end
	end)
end)
