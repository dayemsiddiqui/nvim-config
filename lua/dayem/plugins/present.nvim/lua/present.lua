local M = {}

M.setup = function()
    -- Nothing
end

--- @class present.Slides
--- @field slides string[]: The slides of the file

--- Takes somes lines and parses them
--- @param lines string[]
--- @return present.Slides
local parse_slides = function(lines)
    local slides = { slides = {} }
    local current_slide = {}

    local separator = "^#"
    for i, line in ipairs(lines) do
        print(line, "find: ", line:find(separator), "|")
    end
    return slides
end


vim.print(parse_slides {
    "# Hello",
    "This is some things lse",
    "# World",
    "This is something else"
})

return M
