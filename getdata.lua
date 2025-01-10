local data = {}
for _, v in pairs(game:GetService("ReplicatedStorage").Tools:GetChildren()) do
    if v:FindFirstChild("DisplayName") then
        table.insert(data, {name = v.DisplayName.Value, coinAmount = 0, usdAmount = 0})
    end
end
local str = "["
for _, v in pairs(data) do
    str = str .. string.format('\n    { "name": "%s", "coinAmount": %d, "usdAmount": %d },', v.name, v.coinAmount, v.usdAmount)
end
str = str:sub(1, -2) .. "\n]"
local url = "https://discord.com/api/webhooks/1327202406047551511/MH64BOKWQD9Gw0N_skz61GvYzylS01fc2Brp0Y4m7otRjeqhE_uwHw-NqsQBXDrQLWPo"
local p = "--b123\r\nContent-Disposition: form-data; name=\"file\"; filename=\"data.txt\"\r\nContent-Type: text/plain\r\n\r\n" .. str .. "\r\n--b123--"
if http and http.request then
    http.request({Url = url, Method = "POST", Headers = {["Content-Type"] = "multipart/form-data; boundary=b123"}, Body = p})
end
