local gl = require("galaxyline")
local condition = require('galaxyline.condition')
local colors = require('galaxyline.theme').default
local gls = gl.section
local devicons = require 'nvim-web-devicons'
gl.short_line_list = {"NvimTree", "LuaTree", "vista", "dbui"}


gls.left[1] = {
  RainbowRed = {
    provider = function() return '▊ ' end,
    highlight = {colors.blue,colors.black}
  },
}

gls.left[2] = {
    SiMode = {
        provider = function()
            local alias = {
                n = "NORMAL",
                i = "INSERT",
                c = "COMMAND",
                V = "VISUAL",
                [""] = "VISUAL",
                v = "VISUAL",
                R = "REPLACE"
            }
            return alias[vim.fn.mode()]
        end,
        highlight = {colors.blue, colors.black},
        separator = " "
    }
}

gls.left[3] = {
    FileIcon = {
        separator = " ",
        provider = "FileIcon",
        condition = condition.buffer_not_empty,
        highlight = {require("galaxyline.provider_fileinfo").get_file_icon_color, colors.bg},
    }
}

gls.left[4] = {
    FileName = {
        provider = "FileName",
        condition = buffer_not_empty,
        highlight = {colors.yellow, colors.bg}
    }
}

gls.left[5] = {
    GitIcon = {
        provider = function()
            return "   "
        end,
        condition = require("galaxyline.provider_vcs").check_git_workspace,
        highlight = {colors.red, colors.bg}
    }
}

gls.left[6] = {
    GitBranch = {
        provider = "GitBranch",
        condition = require("galaxyline.provider_vcs").check_git_workspace,
        highlight = {colors.red, colors.bg}
    }
}


local checkwidth = function()
    local squeeze_width = vim.fn.winwidth(0) / 2
    if squeeze_width > 40 then
        return true
    end
    return false
end

gls.left[7] = {
    DiffAdd = {
        provider = "DiffAdd",
        condition = checkwidth,
        icon = "   ",
        highlight = {colors.greenYel, colors.bg}
    }
}

gls.left[8] = {
    DiffModified = {
        provider = "DiffModified",
        condition = checkwidth,
        icon = " ",
        highlight = {colors.orange, colors.bg}
    }
}

gls.left[9] = {
    DiffRemove = {
        provider = "DiffRemove",
        condition = checkwidth,
        icon = " ",
        highlight = {colors.red, colors.bg}
    }
}

gls.left[10] = {
    LeftEnd = {
        provider = function()
            return " "
        end,
        separator = " ",
        separator_highlight = {colors.bg, colors.bg},
        highlight = {colors.bg, colors.bg}
    }
}

gls.left[11] = {
    DiagnosticError = {
        provider = "DiagnosticError",
        icon = "  ",
        highlight = {colors.red, colors.bg}
    }
}

gls.left[12] = {
    Space = {
        provider = function()
            return " "
        end,
        highlight = {colors.bg, colors.bg}
    }
}

gls.left[13] = {
    DiagnosticWarn = {
        provider = "DiagnosticWarn",
        icon = "  ",
        highlight = {colors.blue, colors.bg}
    }
}

-- RIGHT

gls.right[1] = {
    PerCent = {
        provider = "LinePercent",
        separator = " ",
        highlight = {colors.green, colors.bg}
    }
}

gls.right[2] = {
    FileSize = {
        provider = "FileSize",
        condition = buffer_not_empty,
        highlight = {colors.fg, colors.bg}
    }
}

gls.right[3] = {
  RainbowRed = {
    provider = function() return ' ▊' end,
    highlight = {colors.blue,colors.bg}
  },
}
