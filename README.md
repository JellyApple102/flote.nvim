# flote.nvim

Easy, minimal, per-project and global markdown notes.

![screenshot](https://user-images.githubusercontent.com/48893929/229207438-80b1d354-defa-45dd-a8dd-2c06e86911f4.png)

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
    window_border = 'solid'
}
```

| Option | Default | Description |
| ------ | ------- | ----------- |
| q_to_quit | `true` | Remaps `q` in normal mode to `<cmd>wq<CR>`. |
| window_style | `minimal` | See the `config` section of `:h nvim_open_win()`. Currently either `minimal` or empty string `''`. |
| window_border | `solid` | See the `config` section of `:h nvim_open_win()`. Popular options: `single`, `double`, `solid`. |

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
