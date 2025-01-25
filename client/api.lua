API = {}

if Config.FrameWork == 'ESX' then
    ESX = exports['es_extended']:getSharedObject()
else
    error('Config.FrameWork has an invalid value.')
end

---Returns player job
---@return string | nil
API.GetPlayerJobName = function()
    if Config.FrameWork == 'ESX' then
        return ESX.PlayerData.job.name
    end
end
