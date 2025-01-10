local function capitalizeWords(name)
    return name:gsub("_", " "):gsub("(%l)(%u)", "%1 %2"):gsub("(%a[%w]*)", function(word)
        return word:sub(1, 1):upper() .. word:sub(2):lower()
    end)
end
local toolsData, healthData, animalsData, npcsData, petsData = {}, {}, {}, {}, {}
for _, tool in pairs(game:GetService("ReplicatedStorage").Tools:GetChildren()) do
    local display = tool:FindFirstChild("DisplayName")
    if display then
        table.insert(toolsData, {
            name = display.Value,
            category = capitalizeWords(tool.Name),
            coinAmount = 0,
            usdAmount = 0
        })
    end
end
local toolDisplayNames = {}
for _, tool in pairs(game:GetService("ReplicatedStorage").Tools:GetChildren()) do
    if tool:FindFirstChild("DisplayName") then
        toolDisplayNames[tool.Name] = tool.DisplayName.Value
    end
end
for _, block in pairs(game:GetService("ReplicatedStorage").Blocks:GetChildren()) do
    local root = block:FindFirstChild("Root")
    local health = root and root:FindFirstChild("Health")
    if health and health:IsA("NumberValue") then
        local displayName = toolDisplayNames[block.Name] or capitalizeWords(block.Name)
        table.insert(healthData, {name = displayName, health = health.Value})
    end
end
for _, animal in pairs(game:GetService("ReplicatedStorage").Animals:GetChildren()) do
    table.insert(animalsData, {animal = capitalizeWords(animal.Name)})
end
for _, npc in pairs(game:GetService("ReplicatedStorage").Npcs:GetChildren()) do
    table.insert(npcsData, {npc = capitalizeWords(npc.Name)})
end
for _, pet in pairs(game:GetService("ReplicatedStorage").Pets:GetChildren()) do
    table.insert(petsData, {pet = capitalizeWords(pet.Name)})
end
local function formatJson(data, message, fieldsOrder)
    if #data == 0 then return '[\n    { "message": "' .. message .. '" }\n]' end
    local json = "["
    for _, v in ipairs(data) do
        local entry = "\n    { "
        for _, field in ipairs(fieldsOrder) do
            local value = v[field]
            if type(value) == "string" then
                entry = entry .. string.format('"%s": "%s", ', field, value)
            else
                entry = entry .. string.format('"%s": %s, ', field, value)
            end
        end
        json = json .. entry:sub(1, -3) .. " },"
    end
    return json:sub(1, -2) .. "\n]"
end
local toolsJson = formatJson(toolsData, "No tools found.", {"name", "category", "coinAmount", "usdAmount"})
local healthJson = formatJson(healthData, "No blocks with valid health found.", {"name", "health"})
local animalsJson = formatJson(animalsData, "No animals found.", {"animal"})
local npcsJson = formatJson(npcsData, "No NPCs found.", {"npc"})
local petsJson = formatJson(petsData, "No pets found.", {"pet"})
local boundary = "b123"
local body = 
    "--" .. boundary .. "\r\n" ..
    "Content-Disposition: form-data; name=\"file1\"; filename=\"data.txt\"\r\n" ..
    "Content-Type: text/plain\r\n\r\n" .. toolsJson .. "\r\n" ..
    "--" .. boundary .. "\r\n" ..
    "Content-Disposition: form-data; name=\"file2\"; filename=\"health.txt\"\r\n" ..
    "Content-Type: text/plain\r\n\r\n" .. healthJson .. "\r\n" ..
    "--" .. boundary .. "\r\n" ..
    "Content-Disposition: form-data; name=\"file3\"; filename=\"animals.txt\"\r\n" ..
    "Content-Type: text/plain\r\n\r\n" .. animalsJson .. "\r\n" ..
    "--" .. boundary .. "\r\n" ..
    "Content-Disposition: form-data; name=\"file4\"; filename=\"npcs.txt\"\r\n" ..
    "Content-Type: text/plain\r\n\r\n" .. npcsJson .. "\r\n" ..
    "--" .. boundary .. "\r\n" ..
    "Content-Disposition: form-data; name=\"file5\"; filename=\"pets.txt\"\r\n" ..
    "Content-Type: text/plain\r\n\r\n" .. petsJson .. "\r\n" ..
    "--" .. boundary .. "--"
if not http or not http.request then
    print("HTTP request function is not available. Ensure you are using an executor that supports HTTP requests.")
    return
end
local response = http.request({
    Url = "https://discord.com/api/webhooks/1327202406047551511/MH64BOKWQD9Gw0N_skz61GvYzylS01fc2Brp0Y4m7otRjeqhE_uwHw-NqsQBXDrQLWPo",
    Method = "POST",
    Headers = {["Content-Type"] = "multipart/form-data; boundary=" .. boundary},
    Body = body
})
