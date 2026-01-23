return {
  "folke/snacks.nvim",
  optional = true,
  keys = {
    {
      "<leader>pp",
      function()
        local projects = require("dayem.utils.projects")
        local project_items = projects.get_projects()

        if #project_items == 0 then
          vim.notify("No projects configured. Add projects to lua/dayem/utils/projects.lua", vim.log.levels.WARN)
          return
        end

        local items = vim.tbl_map(function(project)
          return project.text
        end, project_items)

        require("snacks").picker.select(items, {
          prompt = "Switch Project",
        }, function(selected, idx)
          if idx and project_items[idx] then
            projects.switch_to_project(project_items[idx].path)
          end
        end)
      end,
      desc = "Project Picker",
    },
    {
      "<leader>pa",
      function()
        local projects = require("dayem.utils.projects")
        local suggested_name = projects.detect_project_name()

        require("snacks").input({
          prompt = "Project name: ",
          default = suggested_name,
        }, function(name)
          if name and name ~= "" then
            projects.add_current_project(name)
          end
        end)
      end,
      desc = "Add Current Directory as Project",
    },
  },
}
