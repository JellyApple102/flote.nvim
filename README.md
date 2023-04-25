# flote.nvim

Easy, minimal, per-project and global markdown notes.

![screenshot](https://user-images.githubusercontent.com/48893929/229207438-80b1d354-defa-45dd-a8dd-2c06e86911f4.png)

## Requirements

Neovim version >= 0.9.0 required for the window title only.
Older versions can disable it, check the [configuration](#configuration) section.

## Installation

Install using your preferred package manager.

Example with [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
    'JellyApple102/flote.nvim'
}
```

## Configuration

Call `setup`:

```lua
-- defaults
require('flote').setup{
    q_to_quit = true,
    window_style = 'minimal',
    window_border = 'solid',
    window_title = true,
    notes_dir = vim.fn.stdpath('cache') .. '/flote',
    files = {
        global = 'flote-global.md',
        cwd = function ()
           return vim.fn.getcwd()
        end,
        file_name = function (cwd)
            local base_name = vim.fs.basename(cwd)
            local parent_base_name = vim.fs.basename(vim.fs.dirname(cwd))
            return parent_base_name .. '_' .. base_name .. '.md'
        end
    }

}
```

| Option          | Default                               | Description                                                                                        |
| --------------- | ------------------------------------- | -------------------------------------------------------------------------------------------------- |
| q_to_quit       | `true`                                | Remaps `q` in normal mode to `<cmd>wq<CR>` for the note buffer.                                    |
| window_style    | `minimal`                             | See the `config` section of `:h nvim_open_win()`. Currently either `minimal` or empty string `''`. |
| window_border   | `solid`                               | See the `config` section of `:h nvim_open_win()`. Popular options: `single`, `double`, `solid`.    |
| window_title    | `true`                                | Show the note file name in the title of the flote window. Requires Neovim >= 0.9.0                 |
| notes_dir       | `vim.fn.stdpath('cache') .. '/flote'` | Directory where the notes will be stored.                                                          |
| files.global    | `flote-global.md`                     | Name of the global file.                                                                           |
| files.cwd       | `vim.fn.getcwd()`                     | Current Working Directory where we'll extract the project name.                                    |
| files.file_name | `Parentfolder_childfolder.md`         | Name of the project note file based on the parent folders.                                         |

## Usage

The note files are created and stored in
`vim.fn.stdpath('cache') .. '/flote'`.
If this directory does not exist, `setup` creates it.

---

`flote` provides one user command: `:Flote [opts]`

`:Flote` opens the project notes.
Project notes are named by the top two parent directories of `vim.fn.getcwd()`.

For example, if you open Neovim in `~/projects/your-awesome-project`,
the generated note file is called `projects_your-awesome-project.md`.

`:Flote global` opens the global note file `flote-global.md`.

`:Flote manage` opens the `flote` directory in `netrw` for easy note management.

## Notes

Currently the buffers created and opened in the float window are
given the `bufhidden` value of `wipe`, meaning they are completely erased
when no longer visible. This includes discarding unsaved changes without warning.

This plugin will not work in Windows environments without a `touch` command.
Files are created by calling by calling `os.execute()` with the `touch` command.

## Coming Soon

- Prettier popup window. Things like note filename, press 'q' to quit, title, etc.
- Slightly more robust window management. 'q' to quit works already, but as it stands
  you can open multiple note windows.

## Tips

- Using the parent `.git` folder as the cwd:

```lua
require("flote").setup {
    files = {
      cwd = function()
        local bufPath = vim.api.nvim_buf_get_name(0)
        local cwd = require("lspconfig").util.root_pattern ".git"(bufPath)

        return cwd
      end,
    },
}
```

## Extras

I wrote this for personal use because I wanted per-project notes without
having to learn or use a larger project like [nvim-orgmode](https://github.com/nvim-orgmode/orgmode)
or [vimwiki](https://github.com/vimwiki/vimwiki). These plugins are great and have many more features,
but I wanted something smaller.
As such there is no configuration, all the defaults are my preference.
I think most people would use the defaults anyway.

---

Theme used in screenshot is [kanagawa.nvim](https://github.com/rebelot/kanagawa.nvim)

Check out my other plugin [easyread.nvim](https://github.com/JellyApple102/easyread.nvim)
