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
            projects.switch_to_project(project_items[idx].name, project_items[idx].path)
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
    {
      "<leader>pd",
      function()
        local projects = require("dayem.utils.projects")
        local project_items = projects.get_dynamic_project_items()

        if #project_items == 0 then
          vim.notify("No dynamic projects to delete", vim.log.levels.WARN)
          return
        end

        local items = vim.tbl_map(function(project)
          return project.text
        end, project_items)

        require("snacks").picker.select(items, {
          prompt = "Delete Project",
        }, function(selected, idx)
          if idx and project_items[idx] then
            local project_name = project_items[idx].name
            local response = vim.fn.confirm(
              "Delete project '" .. project_name .. "'?",
              "&Yes\n&No",
              2
            )
            if response == 1 then
              projects.delete_project(project_name)
            end
          end
        end)
      end,
      desc = "Delete Project",
    },
  },
}
