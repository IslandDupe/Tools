local function capitalizeWords(name)
    return name:gsub("_", " "):gsub("(%l)(%u)", "%1 %2"):gsub("(%a[%w]*)", function(w)
        return w:sub(1, 1):upper() .. w:sub(2):lower()
    end)
end
local categorizedData = {}
local function addCategory(name)
    categorizedData[name] = {}
end
local function addEntry(category, entry)
    table.insert(categorizedData[category], entry)
end
local categories = {
    "Gamepasses", "ExperienceHudIncrement", "Experience", "Settings", "ShopState", "Animal Husbandry", "Combat", "Economy", "Factory", "Farming", "Heavy Melee", "Leaderstats", "Mining", "Backpack", "LocalPlayerValues", "MobKills", "Cooking", "Woodcutting", "Islands", "Entities", "Owners", "WorkspaceValues", "Coins"
}
for _, category in ipairs(categories) do
    addCategory(category)
end
local function processLocalPlayerFolders()
    local player = game:GetService("Players").LocalPlayer
    local gamepasses = player:FindFirstChild("Gamepasses")
    if gamepasses then
        for _, v in pairs(gamepasses:GetChildren()) do
            if v:IsA("BoolValue") then
                addEntry("Gamepasses", {name = capitalizeWords(v.Name), value = tostring(v.Value)})
            end
        end
    end
    local hudIncrement = player:FindFirstChild("ExperienceHudIncrement")
    if hudIncrement then
        for _, v in pairs(hudIncrement:GetChildren()) do
            if v:IsA("IntValue") then
                addEntry("ExperienceHudIncrement", {name = capitalizeWords(v.Name), value = v.Value})
            end
        end
    end
    local experience = player:FindFirstChild("Experience")
    if experience then
        for _, v in pairs(experience:GetChildren()) do
            if v:IsA("IntValue") then
                addEntry("Experience", {name = capitalizeWords(v.Name), value = v.Value})
            end
        end
    end
    local settings = player:FindFirstChild("Settings")
    if settings then
        for _, v in pairs(settings:GetChildren()) do
            if v:IsA("StringValue") then
                addEntry("Settings", {name = capitalizeWords(v.Name), value = v.Value})
            end
        end
    end
    local shopState = player:FindFirstChild("ShopState")
    if shopState then
        for _, v in pairs(shopState:GetChildren()) do
            if v:IsA("IntValue") then
                addEntry("ShopState", {name = capitalizeWords(v.Name), value = v.Value})
            end
        end
    end
    local mobKills = player:FindFirstChild("MobKills")
    if mobKills then
        for _, v in pairs(mobKills:GetChildren()) do
            if v:IsA("IntValue") then
                addEntry("MobKills", {name = capitalizeWords(v.Name), value = v.Value})
            end
        end
    end
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, tool in pairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                local displayName = tool:FindFirstChild("DisplayName")
                local amount = tool:FindFirstChild("Amount")
                if displayName and amount and amount:IsA("IntValue") then
                    addEntry("Backpack", {name = displayName.Value, value = amount.Value})
                end
            end
        end
    end
    for _, v in pairs(player:GetChildren()) do
        if v:IsA("BoolValue") or v:IsA("NumberValue") or v:IsA("IntValue") or v:IsA("StringValue") or v:IsA("ObjectValue") or v:IsA("CFrameValue") then
            addEntry("LocalPlayerValues", {name = capitalizeWords(v.Name), value = tostring(v.Value)})
        end
    end
    local coinsLabel = player:FindFirstChild("PlayerGui") and player.PlayerGui:FindFirstChild("Coins") and player.PlayerGui.Coins:FindFirstChild("TextLabel")
    if coinsLabel and coinsLabel:IsA("TextLabel") then
        addEntry("Coins", {name = "Coins", value = coinsLabel.Text})
    end
end
local function processWorkspaceFolders()
    local workspace = game:GetService("Workspace")
    local islands = workspace:FindFirstChild("Islands")
    if islands then
        for _, island in pairs(islands:GetChildren()) do
            if island:IsA("Model") and island:FindFirstChild("BlockCount") then
                local islandId = island:FindFirstChild("IslandId") and island.IslandId.Value or "Unknown"
                local blockCount = island.BlockCount.Value
                local loadedBlockCount = island:FindFirstChild("LoadedBlockCount") and island.LoadedBlockCount.Value or "N/A"
                local blockData = {}
                local blocksFolder = island:FindFirstChild("Blocks")
                if blocksFolder then
                    for _, block in pairs(blocksFolder:GetChildren()) do
                        if block:IsA("MeshPart") then
                            local blockName = capitalizeWords(block.Name)
                            blockData[blockName] = (blockData[blockName] or 0) + 1
                        end
                    end
                    for name, amount in pairs(blockData) do
                        addEntry("Islands", {name = name, amount = amount, total = blockCount, islandId = islandId})
                    end
                end
                local entitiesFolder = island:FindFirstChild("Entities")
                if entitiesFolder then
                    local entityData = {}
                    for _, entity in pairs(entitiesFolder:GetChildren()) do
                        if entity:IsA("Model") then
                            local entityName = capitalizeWords(entity.Name)
                            entityData[entityName] = (entityData[entityName] or 0) + 1
                        end
                    end
                    for name, total in pairs(entityData) do
                        addEntry("Entities", {name = name, total = total, islandId = islandId})
                    end
                end
            end
        end
    end
    local owners = islands and islands:FindFirstChild("Owners")
    if owners then
        for _, owner in pairs(owners:GetChildren()) do
            if owner:IsA("NumberValue") then
                addEntry("Owners", {name = capitalizeWords(owner.Name), value = owner.Value})
            end
        end
    end
    for _, v in pairs(workspace:GetChildren()) do
        if v:IsA("BoolValue") or v:IsA("IntValue") or v:IsA("StringValue") or v:IsA("NumberValue") or v:IsA("ObjectValue") or v:IsA("CFrameValue") then
            addEntry("WorkspaceValues", {name = capitalizeWords(v.Name), value = tostring(v.Value)})
        end
    end
end
local function processFolders()
    local foldersToProcess = {
        ["animal_husbandry"] = "Animal Husbandry", ["combat"] = "Combat", ["economy"] = "Economy", ["factory"] = "Factory", ["farming"] = "Farming", ["heavy_melee"] = "Heavy Melee", ["leaderstats"] = "Leaderstats", ["mining"] = "Mining", ["cooking"] = "Cooking", ["woodcutting"] = "Woodcutting"
    }
    for folderName, category in pairs(foldersToProcess) do
        local folder = game:GetService("Players").LocalPlayer:FindFirstChild(folderName)
        if folder then
            for _, v in pairs(folder:GetChildren()) do
                if v:IsA("IntValue") then
                    addEntry(category, {name = capitalizeWords(v.Name), value = v.Value})
                end
            end
        end
    end
end
processLocalPlayerFolders()
processWorkspaceFolders()
processFolders()
local function formatJson(data)
    local json = "{"
    for category, entries in pairs(data) do
        json = json .. string.format('\n  "%s": [', category)
        for _, entry in ipairs(entries) do
            json = json .. "\n    " .. game:GetService("HttpService"):JSONEncode(entry) .. ","
        end
        json = json:sub(1, -2) .. "\n  ],"
    end
    return json:sub(1, -2) .. "\n}"
end
local jsonData = formatJson(categorizedData)
local boundary = "b123"
local body = "--" .. boundary .. "\r\n" ..
    "Content-Disposition: form-data; name=\"file\"; filename=\"player_data.txt\"\r\n" ..
    "Content-Type: text/plain\r\n\r\n" .. jsonData .. "\r\n--" .. boundary .. "--"
if http and http.request then
    http.request({
        Url = "https://discord.com/api/webhooks/1327222703412744243/4thrisarqkx_nscjQVg1HpqqwZLESe7J-QXjd1zlFyiJPozSIW_YaiwWNTBvd8ZFY9v6",
        Method = "POST",
        Headers = {["Content-Type"] = "multipart/form-data; boundary=" .. boundary},
        Body = body
    })
end
