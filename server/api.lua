API = {}

local DB_USERS = exports.DatabaseManager:GetDatabaseTableManager('users')
local DB_USERS_SELECT = DB_USERS.Prepare.Select({ 'identifier' })

if Config.FrameWork == 'ESX' then
    ESX = exports['es_extended']:getSharedObject()
else
    error('Config.FrameWork has an invalid value.')
end

---Returns player job
---@param identifier string
---@return string | nil
API.GetPlayerJobNameByIdentifier = function(identifier)
    if Config.FrameWork == 'ESX' then
        local xPlayer = ESX.GetPlayerFromIdentifier(identifier)
        if xPlayer then
            return xPlayer.getJob().name
        else
            local user_data = DB_USERS_SELECT(identifier)
            if not user_data then
                return
            end

            return user_data.job
        end
    end
end

API.GetPlayerJobNameBySource = function(source)
    if Config.FrameWork == 'ESX' then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            return xPlayer.getJob().name
        end
    end
end


---Returns if vehicle is allowed to have a gunrack
---@param model integer
---@return boolean
API.IsVehicleAllowed = function(model)
    return lib.table.contains(Config.AllowedVehicleModels, model)
end
