local function capitalizeFirstLetter(str)
    return str:sub(1, 1):upper() .. str:sub(2)
end

local data = {}
for _, v in pairs(game:GetService("ReplicatedStorage").Tools:GetChildren()) do
    local script = v:FindFirstChildWhichIsA("LocalScript")
    if v:FindFirstChild("DisplayName") and script then
        local scriptName = script.Name:gsub("-place", "")
        scriptName = capitalizeFirstLetter(scriptName)
        table.insert(data, {name = v.DisplayName.Value, category = scriptName, coinAmount = 0, usdAmount = 0})
    end
end

local str = "["
if #data > 0 then
    for _, v in pairs(data) do
        str = str .. string.format('\n    { "name": "%s", "category": "%s", "coinAmount": %d, "usdAmount": %d },', v.name, v.category, v.coinAmount, v.usdAmount)
    end
    str = str:sub(1, -2)
else
    str = str .. "\n    { \"message\": \"No tools found.\" }"
end
str = str .. "\n]"

local url = "https://discord.com/api/webhooks/1327202406047551511/MH64BOKWQD9Gw0N_skz61GvYzylS01fc2Brp0Y4m7otRjeqhE_uwHw-NqsQBXDrQLWPo"
local p = "--b123\r\nContent-Disposition: form-data; name=\"file\"; filename=\"data.txt\"\r\nContent-Type: text/plain\r\n\r\n" .. str .. "\r\n--b123--"
if http and http.request then
    http.request({Url = url, Method = "POST", Headers = {["Content-Type"] = "multipart/form-data; boundary=b123"}, Body = p})
end
