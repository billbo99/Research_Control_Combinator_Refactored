-- Debug flag: set to true to enable debug logging
local debug = false
local research_map = {}

local function starts_with(str, start)
    return str:sub(1, #start) == start
end

local function log_debug(message)
    if settings.global["research-control-combinator-debug"].value then
        game.print("[DEBUG] " .. message)
    end
end

-- Function to map signal names to research technologies
local function map_signal_to_research(signal_name)
    local last_signal_index = 1
    local signals = {}
    for signal in pairs(prototypes.virtual_signal) do
        if starts_with(signal, "infinite-research-") then
            table.insert(signals, signal)
        end
    end

    for _, p in pairs(game.forces.player.technologies) do
        if last_signal_index > #signals then
            break
        end

        if not p.researched then
            research_map["infinite-research-" .. p.name] = p.name
            last_signal_index = last_signal_index + 1
        end
    end
    return research_map[signal_name]
end

-- Validate and extract signals from a combinator
local function get_signals_from_combinator(combinator)
    if not combinator.valid then
        return {}
    end

    local red_network = combinator.get_circuit_network(defines.wire_connector_id.combinator_input_red)
    local green_network = combinator.get_circuit_network(defines.wire_connector_id.combinator_input_green)

    local signals = {}
    if red_network and red_network.signals then
        for _, signal in ipairs(red_network.signals) do
            table.insert(signals, signal)
        end
    end
    if green_network and green_network.signals then
        for _, signal in ipairs(green_network.signals) do
            table.insert(signals, signal)
        end
    end

    return signals
end

-- Process all registered combinators
local function process_combinators()
    if not storage.combinators then
        log_debug("storage.combinators is nil. Skipping processing.")
        return
    end

    for unit_number, combinator_data in pairs(storage.combinators) do
        if not combinator_data or not combinator_data.position or not combinator_data.surface then
            storage.combinators[unit_number] = nil
        else
            local surface = game.surfaces[combinator_data.surface]
            local entity = surface and surface.find_entity("Research_Control_Combinator", combinator_data.position)
            if not entity or not entity.valid then
                storage.combinators[unit_number] = nil
            else
                local signals = get_signals_from_combinator(entity)
                if #signals > 0 then
                    for _, signal in ipairs(signals) do
                        if signal.signal and signal.signal.type == "virtual" then
                            local research_name = map_signal_to_research(signal.signal.name)
                            if research_name then
                                local force = game.forces.player
                                if force.current_research and force.current_research.name == research_name then
                                    log_debug("Research already set: " .. research_name)
                                else
                                    force.research_queue = {}
                                    local success = force.add_research(research_name)
                                    if success then
                                        log_debug("Set research to: " .. research_name)
                                    else
                                        log_debug("Failed to set research: " .. research_name)
                                    end
                                end
                            else
                                log_debug("No research mapped for signal: " .. signal.signal.name)
                            end
                        end
                    end
                end
            end
        end
    end
end

-- Handle combinator placement
local function on_built(event)
    local entity = event.created_entity or event.entity
    if not entity or entity.name ~= "Research_Control_Combinator" then return end

    storage.combinators = storage.combinators or {}
    storage.combinators[entity.unit_number] = {
        position = entity.position,
        surface = entity.surface.name,
    }
    entity.operable = false
    log_debug("Added combinator with unit number: " .. entity.unit_number)
end

-- Handle combinator removal
local function on_destroy(event)
    local entity = event.entity
    if not entity or entity.name ~= "Research_Control_Combinator" then return end

    if storage.combinators then
        storage.combinators[entity.unit_number] = nil
        log_debug("Removed combinator with unit number: " .. entity.unit_number)
    end
end

-- Initialize storage
local function on_init()
    storage.combinators = storage.combinators or {}
    log_debug("Initialized mod storage.")

    commands.add_command("research_signals", [["Show infinite technologies and
    their linked signals for Research Control Combinator"]], function(command)
        map_signal_to_research("")

        local s = ""
        for k, v in pairs(research_map) do
            s = s .. k .. " => " .. v .. ", "
        end
        game.print(string.sub(s, 1, -3))
    end)
end

-- Reload storage on game load
local function on_load()
    -- Ensure event handlers are registered again on load
    script.on_event(defines.events.on_built_entity, on_built)
    script.on_event(defines.events.on_robot_built_entity, on_built)
    script.on_event(defines.events.script_raised_built, on_built)
    script.on_event(defines.events.script_raised_revive, on_built)
    script.on_event(defines.events.on_entity_died, on_destroy)
    script.on_event(defines.events.on_pre_player_mined_item, on_destroy)
    script.on_event(defines.events.on_robot_pre_mined, on_destroy)
    script.on_event(defines.events.script_raised_destroy, on_destroy)
    script.on_event(defines.events.on_research_finished, process_combinators)
    script.on_nth_tick(60, process_combinators)

    commands.add_command("research_signals", [["Show infinite technologies and
    their linked signals for Research Control Combinator"]], function(command)
        map_signal_to_research("")

        local s = ""
        for k, v in pairs(research_map) do
            s = s .. k .. " => " .. v .. ", "
        end
        game.print(string.sub(s, 1, -3))
    end)
end


-- Register events
script.on_event(defines.events.on_built_entity, on_built)
script.on_event(defines.events.on_robot_built_entity, on_built)
script.on_event(defines.events.script_raised_built, on_built)
script.on_event(defines.events.script_raised_revive, on_built)
script.on_event(defines.events.on_entity_died, on_destroy)
script.on_event(defines.events.on_pre_player_mined_item, on_destroy)
script.on_event(defines.events.on_robot_pre_mined, on_destroy)
script.on_event(defines.events.script_raised_destroy, on_destroy)
script.on_event(defines.events.on_research_finished, process_combinators)
script.on_nth_tick(settings.startup["research-control-combinator-polling-tick"].value, process_combinators)

script.on_init(on_init)
script.on_load(on_load)