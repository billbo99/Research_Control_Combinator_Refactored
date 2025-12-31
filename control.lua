local function starts_with(str, start)
    return str:sub(1, #start) == start
end

local function log_debug(message)
    if settings.global["research-control-combinator-debug"].value then
        game.print("[DEBUG] " .. message)
    end
end

local function read_force_technologies(force)
    local signals = {}
    for signal in pairs(prototypes.virtual_signal) do
        if starts_with(signal, "infinite-research-") then
            local research_name = signal:gsub("^infinite%-research%-", "")
            if force.technologies[research_name] then
                signals[signal] = force.technologies[research_name]
                log_debug("Force " .. force.name .. " has researched " .. research_name)
            end
        end
    end
    return signals
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

local function process_tracker_combinator(unit_number, combinator_data)
    local entity = combinator_data.entity
    if not entity or not entity.valid then
        storage.combinators[unit_number] = nil
    elseif combinator_data.entity.name == "Research_Tracker_Combinator" then
        local force = entity.force
        local research_map = read_force_technologies(force)
        local slot = 0
        local section = entity.get_control_behavior().get_section(1)
        for signal_name, technology in pairs(research_map) do
            slot = slot + 1
            local slot_filter = {value={type="virtual", name=signal_name, quality='normal'}, min=(technology.level-1)}
            section.set_slot(slot, slot_filter)
        end
    end
end

local function process_control_combinator(unit_number, combinator_data)
    if combinator_data.name ~= "Research_Control_Combinator" then
        return
    end
    local entity = combinator_data.entity
    local force = entity.force
    local research_map = read_force_technologies(force)

    if not entity or not entity.valid then
        storage.combinators[unit_number] = nil
    else
        local signals = get_signals_from_combinator(entity)
        if #signals > 0 then
            for _, signal in ipairs(signals) do
                if signal.signal and signal.signal.type == "virtual" then
                    local research_name = research_map[signal.signal.name].name
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

local function process_combinators()
    if not storage.combinators then
        log_debug("storage.combinators is nil. Skipping processing.")
        return
    end

    for unit_number, combinator_data in pairs(storage.combinators) do
        if not combinator_data or not combinator_data.position or not combinator_data.surface then
            storage.combinators[unit_number] = nil
        else
            process_control_combinator(unit_number, combinator_data)
            process_tracker_combinator(unit_number, combinator_data)
        end
    end
end

-- Handle combinator placement
local function on_built(event)
    local entity = event.created_entity or event.entity
    if not entity or (entity.name ~= "Research_Control_Combinator" and entity.name ~= "Research_Tracker_Combinator") then return end

    storage.combinators = storage.combinators or {}
    storage.combinators[entity.unit_number] = {
        position = entity.position,
        surface = entity.surface.name,
        name = entity.name,
        entity = entity
    }
    entity.operable = false
    log_debug("Added combinator with unit number: " .. entity.unit_number)
end

-- Handle combinator removal
local function on_destroy(event)
    local entity = event.entity
    if not entity or (entity.name ~= "Research_Control_Combinator" and entity.name ~= "Research_Tracker_Combinator") then return end

    if storage.combinators then
        storage.combinators[entity.unit_number] = nil
        log_debug("Removed combinator with unit number: " .. entity.unit_number)
    end
end

-- Initialize storage
local function on_init()
    storage.combinators = storage.combinators or {}
    log_debug("Initialized mod storage.")
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
    script.on_nth_tick(settings.startup["research-control-combinator-polling-tick"].value, process_combinators)
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