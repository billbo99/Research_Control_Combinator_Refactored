data:extend({
    {
        type = "bool-setting",
        name = "research-control-combinator-debug",
        setting_type = "runtime-global",
        default_value = false,
        order = "a"
    },
    {
        type = "bool-setting",
        name = "research-control-combinator-add-to-queue",
        setting_type = "runtime-global",
        default_value = true,
        order = "b"
    },
    {
        type = "int-setting",
        name = "research-control-combinator-polling-tick",
        setting_type = "startup",
        default_value = 300,
        order = "c"
    }
})