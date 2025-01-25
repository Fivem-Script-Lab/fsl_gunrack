local DB_VEHICLES = exports.DatabaseManager:GetDatabaseTableManager('owned_vehicles')
local DB_VEHICLES_SELECT = DB_VEHICLES.Prepare.Select({ 'plate' })

lib.callback.register('fsl:registerStash', function(source, data)
    local job = data.job
    local id = data.id

    if not Config.AllowedJob[job] then
        return false
    end


    local slots = Config.AllowedJob[job].slots
    local weight = Config.AllowedJob[job].weight

    local stash = {
        id = id,
        label = ("%s - Gunrack"):format(id),
        slots = slots,
        weight = weight,
        owner = false,

    }

    exports.ox_inventory:RegisterStash(stash.id, stash.label, stash.slots, stash.weight, stash.owner)

    return true
end)


lib.callback.register('fsl:getGunRackID', function(source)
    local source = source

    local player_ped = GetPlayerPed(source)
    local vehicle = GetVehiclePedIsIn(player_ped, false)

    if not vehicle then
        return
    end

    local vehicle_model = GetEntityModel(vehicle)

    local is_vehicle_allowed = API.IsVehicleAllowed(vehicle_model)

    if not is_vehicle_allowed then
        return
    end

    local vehicle_plate = GetVehicleNumberPlateText(vehicle)

    if not vehicle_plate then
        return
    end

    local vehicle_data = DB_VEHICLES_SELECT.execute(vehicle_plate)

    if not vehicle_data then
        return
    end

    local vehicle_owner_licence = vehicle_data.owner

    local vehicle_owner_job = API.GetPlayerJobNameByIdentifier(vehicle_owner_licence)

    if not vehicle_owner_job then
        return
    end

    if not vehicle_owner_job == API.GetPlayerJobNameBySource(source) then
        return
    end

    local stash_id = ('[%s-%s]'):format(vehicle_plate:gsub('%s+', ''), vehicle_owner_licence:sub(-5))

    return stash_id
end)
