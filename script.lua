-- Criando GUI compatível com Xeno
local TweenService = game:GetService("TweenService")
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UIStroke = Instance.new("UIStroke")
local UICorner = Instance.new("UICorner")
local VerifyButton = Instance.new("TextButton")
local GetKeyButton = Instance.new("TextButton")
local SupportButton = Instance.new("TextButton")
local KeyInput = Instance.new("TextBox")
local Notification = Instance.new("TextLabel")
local Player = game:GetService("Players").LocalPlayer
local PlayerGui = Player:FindFirstChild("PlayerGui") or Instance.new("ScreenGui", Player)

-- Key criptografada
local encodedKey = "RGVrMjAyNQ==" -- "Dek2025" codificado em Base64
local function decodeKey(encoded)
    local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    encoded = string.gsub(encoded, "[^"..b.."=]", "")
    return (encoded:gsub(".", function(x)
        if (x == '=') then return '' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r
    end):gsub("%d%d%d?%d?%d?%d?%d?%d?", function(x)
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
        return string.char(c)
    end))
end

-- Configurando GUIhttps://i.imgur.com/HRzLKba.png
ScreenGui.Parent = PlayerGui
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 300, 0, 250)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -125)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BackgroundTransparency = 0.1

UIStroke.Parent = MainFrame
UIStroke.Thickness = 3
UIStroke.Color = Color3.fromRGB(255, 0, 0)

UICorner.Parent = MainFrame
UICorner.CornerRadius = UDim.new(0, 10)

KeyInput.Parent = MainFrame
KeyInput.Size = UDim2.new(0, 250, 0, 30)
KeyInput.Position = UDim2.new(0, 25, 0, 80)
KeyInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.PlaceholderText = "Digite sua key aqui"
KeyInput.Font = Enum.Font.GothamBold
KeyInput.TextSize = 14

Notification.Parent = ScreenGui
Notification.Size = UDim2.new(0, 300, 0, 50)
Notification.Position = UDim2.new(0.5, -150, 0.8, 0)
Notification.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Notification.TextColor3 = Color3.fromRGB(255, 255, 255)
Notification.Text = ""
Notification.Visible = false
Notification.Font = Enum.Font.GothamBold
Notification.TextSize = 16
Notification.BackgroundTransparency = 0.2
UICorner:Clone().Parent = Notification

local function showNotification(text)
    Notification.Text = text
    Notification.Visible = true
    wait(2)
    Notification.Visible = false
end

local function createButton(text, position, callback)
    local button = Instance.new("TextButton")
    button.Parent = MainFrame
    button.Size = UDim2.new(0, 250, 0, 35)
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    button.TextColor3 = Color3.fromRGB(255, 0, 0)
    button.Text = text
    button.Font = Enum.Font.GothamBold
    button.TextSize = 14
    button.AutoButtonColor = false
    
    local corner = UICorner:Clone()
    corner.Parent = button
    
    button.MouseEnter:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(255, 0, 0), TextColor3 = Color3.fromRGB(0, 0, 0)})
        tween:Play()
    end)
    
    button.MouseLeave:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(40, 40, 40), TextColor3 = Color3.fromRGB(255, 0, 0)})
        tween:Play()
    end)
    
    button.MouseButton1Click:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(200, 0, 0)})
        tween:Play()
        wait(0.1)
        local tween2 = TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)})
        tween2:Play()
        callback()
    end)
    return button
end

VerifyButton = createButton("Verificar Key", UDim2.new(0, 25, 0, 120), function()
    local key = KeyInput.Text
    if key == decodeKey(encodedKey) then
        showNotification("Key verificada com sucesso!")
        wait(1)
        MainFrame.Visible = false
        loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true))()
    else
        showNotification("Key inválida! Tente novamente.")
    end
end)

GetKeyButton = createButton("Adquirir Key", UDim2.new(0, 25, 0, 160), function()
    showNotification("Link da key copiado!")
    if setclipboard then
        setclipboard("https://fir3.net/KEY1PASS")
    end
end)

SupportButton = createButton("Suporte", UDim2.new(0, 25, 0, 200), function()
    showNotification("Link de suporte copiado!")
    if setclipboard then
        setclipboard("https://discord.gg/Bkdxtu4e6A")
    end
end)
