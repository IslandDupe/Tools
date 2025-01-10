local itemData = {}
for _, tool in pairs(game:GetService("ReplicatedStorage").Tools:GetChildren()) do
    local displayName = tool:FindFirstChild("DisplayName")
    if displayName then
        table.insert(itemData, {name = displayName.Value, coinAmount = 0, usdAmount = 0})
    end
end
local formattedString = "["
for _, item in pairs(itemData) do
    formattedString = formattedString .. string.format('\n    { "name": "%s", "coinAmount": %d, "usdAmount": %d },', item.name, item.coinAmount, item.usdAmount)
end
formattedString = formattedString:sub(1, -2) .. "\n]"
setclipboard(formattedString)
print(formattedString ~= "" and "Clipboard set successfully." or "Failed to set clipboard.")
