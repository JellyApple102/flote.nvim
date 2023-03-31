# flote.nvim

Easy, minimal, per-project and global markdown notes, in under 70 LOC.

![screenshot](https://user-images.githubusercontent.com/48893929/229207438-80b1d354-defa-45dd-a8dd-2c06e86911f4.png)

## Installation

Install using your preferred package manager.

Example with [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
    'JellyApple102/flote.nvim'
}
```

Then call `setup`:

```lua
require('flote').setup{}
```

and you're all done!

## Usage

The note files are createed and stored in
`vim.fn.stdpath('cache') .. '/flote'`.
If this directory does not exist, `setup` creates it.

`flote` provides one user command: `:Flote [opts]`

`:Flote` opens the project notes.
Project notes are named by the top two parent directories of `vim.fn.getcwd()`.

For example, if you open Neovim in `~/projects/your-awesome-project`,
the generated note file is called `projects_your-awesome-project.md`.

`:Flote global` opens the global note file `flote-global.md`.

`:Flote manage` opens the `flote` directory in `netrw` for easy note management.

## Notes

Currently the buffers created and opend in the float window are 
given the `bufhidden` value of `wipe`, meaning they are completely erased 
when no longer visible. This includes discarding unsaved changes without warning.

## Extras

Theme used in screenshot is [kanagawa.nvim](https://github.com/rebelot/kanagawa.nvim)

Check out my other plugin [easyread.nvim](https://github.com/JellyApple102/easyread.nvim)!
