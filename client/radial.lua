lib.onCache('vehicle', function(value)
    if not Config.AllowedJob[API.GetPlayerJobName()] then
        return
    end

    if not value then
        lib.removeRadialItem('open_stash')
        return
    end

    local stash_id = lib.callback.await('fsl:getGunRackID')

    if not stash_id then
        return
    end

    lib.addRadialItem({
        {
            id = 'open_stash',
            label = 'Open Gunrack',
            icon = 'gun',
            onSelect = function()
                if exports.ox_inventory:openInventory('stash', { id = stash_id }) == false then
                    lib.callback.await('fsl:registerStash', false, { id = stash_id, job = API.GetPlayerJobName() })
                    exports.ox_inventory:openInventory('stash', { id = stash_id })
                end
            end
        },
    })
end)
