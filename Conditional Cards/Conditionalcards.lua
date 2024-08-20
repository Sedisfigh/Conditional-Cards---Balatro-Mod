--- STEAMODDED HEADER
--- MOD_NAME: Conditional Cards
--- MOD_ID: Conditionalcard
--- PREFIX: con
--- MOD_AUTHOR: [Oiiman (Knockback)]
--- MOD_DESCRIPTION: Conditional Cards needs Cryptid for the exotic jokers.
--- BADGE_COLOUR: 8c4212
--- DEPENDENCIES: [Cryptid]
--- VERSION: 0.1

----------------------------------------------
------------MOD CODE -------------------------
local mod_path = ''..SMODS.current_mod.path
-- Load Options
local read_config = SMODS.load_file("config.lua")
if read_config then
    Conditionalcard_config = read_config()
end

local files = NFS.getDirectoryItems(mod_path.."Items")
for _, file in ipairs(files) do
    print("Loading file "..file)
    local f, err = SMODS.load_file("Items/"..file)
    if err then print("Error loading file: "..err) else
      local curr_obj = f()
      if Conditionalcard_config[curr_obj.name] == nil then Conditionalcard_config[curr_obj.name] = true end
      if Conditionalcard_config[curr_obj.name] then
          if curr_obj.init then curr_obj:init() end
          if not curr_obj.items then
            print("Warning: "..file.." has no items")
          else
            for _, item in ipairs(curr_obj.items) do
                item.discovered = true
                if SMODS[item.object_type] then
                    SMODS[item.object_type](item)
                    -- JokerDisplay mod support
                    if JokerDisplay and item.joker_display_definition then
                        JokerDisplay.Definitions[item.key] = item.joker_display_definition
                    end
                else
                    print("Error loading item "..item.key.." of unknown type "..item.object_type)
                end
            end
         end
      end
    end
end

SMODS.Atlas({
    key = "modicon",
    path = "con_icon.png",
    px = 32,
    py = 32
}):register()

----------------------------------------
------------MOD CODE END----------------------
