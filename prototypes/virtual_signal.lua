local function create_rich_text_icons(inputs)
    local rich_text_icons = { "" }
    for _, input in pairs(inputs) do
        table.insert(rich_text_icons, string.format("[img=item/%s]", input))
    end
    return rich_text_icons
end

local function short_from_name(name)
    name = (name or ""):gsub("%-%d+$", "") -- strip trailing -<number>
    local s = ""
    local parts = {}
    for part in name:gmatch("[^-]+") do
        table.insert(parts, part)
    end
    local c = parts[1]:sub(1,3)
    if c ~= "" then s = s .. c:lower() end
    if s == "" then return name end
    return s
end

function create_item_subgroup(proto)

    local ingredients = {}
    local short_name
    local count = 0
    for _, ingredient in pairs(proto.unit.ingredients or {}) do
        local full_name = ingredient[1] or ingredient.name
        short_name = short_from_name(full_name)
        table.insert(ingredients, short_name)
    end
    table.sort(ingredients)
    local subgroup_name = "infinite-research-" .. table.concat(ingredients, "-")

    if data.raw["item-subgroup"][subgroup_name] then
        return data.raw["item-subgroup"][subgroup_name]
    end

    local subgroup = {
        type = "item-subgroup",
        name = subgroup_name,
        group = "infinite-research",
        order = "z" .. string.format("%02d", #ingredients) .. "-" .. subgroup_name
    }
    data:extend({ subgroup })
    return subgroup
end

function create_infinite_research_signal(name, proto)
    log("Infinite Tech Found : " .. name)
    local subgroup = create_item_subgroup(proto)

    local base_name = name:gsub("%-%d+$", "")

    local ingredients = {}
    for _, ingredient in pairs(proto.unit.ingredients or {}) do
        local full_name = ingredient[1] or ingredient.name
        table.insert(ingredients, full_name)
    end

    local signal = {
        type = "virtual-signal",
        name = "infinite-research-" .. name,
        subgroup = subgroup.name,
        order = proto.order or "z" .. base_name,
        localised_name = { "technology-name." .. base_name},
        localised_description = { "", create_rich_text_icons(ingredients)}
    }
    if proto.icon then
        signal.icon = proto.icon
        signal.icon_size = proto.icon_size or 64
        signal.icon_mipmaps = proto.icon_mipmaps or 0

    elseif proto.icons then
        signal.icons = { proto.icons[1] }
    end

    data:extend({ signal })
end

data:extend({
    {
        type = "item-group",
        name = "infinite-research",
        icon = "__Research_Control_Combinator_Refactored__/graphics/icons/lab.png",
        icon_size = 256,
        order = "z",
        localised_name = { "item-group-name.infinite-research" }
    },
    {
        type = "item-subgroup",
        name = "InfiniteResearch",
        group = "infinite-research",
        order = "zInfiniteResearch"
    }
})

local techs = {}

if data and data.raw and data.raw["technology"] then
    for name, proto in pairs(data.raw["technology"]) do
        if proto.unit and proto.unit.count_formula then
            create_infinite_research_signal(name, proto)
        end
    end
end
