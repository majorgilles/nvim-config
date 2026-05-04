# Neovim config

LazyVim-based config. Plugin specs live in `lua/plugins/`.

## Debugging Rust with breakpoints

DAP is wired up via `nvim-dap` + `nvim-dap-ui` + `codelldb` (installed by Mason).
Rust integration uses `rustaceanvim`, which auto-detects cargo targets so you
don't have to hand-write binary paths.

Relevant plugin files:
- `lua/plugins/dap.lua` — core DAP setup, codelldb adapter, generic Rust launch config, keymaps
- `lua/plugins/rust.lua` — rustaceanvim + dap-virtual-text

### Prerequisites

- A Rust project with a debug build (`cargo build` — release builds strip symbols)
- `codelldb` installed:
  - **macOS / Linux**: `:MasonInstall codelldb`
  - **Windows**: Mason's installer fails without Git Bash / `uname` on PATH, so
    install manually:
    ```powershell
    $dest = "$env:LOCALAPPDATA\codelldb"
    $vsix = "$env:TEMP\codelldb.vsix"
    Invoke-WebRequest -Uri "https://github.com/vadimcn/codelldb/releases/latest/download/codelldb-win32-x64.vsix" -OutFile $vsix -UseBasicParsing
    Expand-Archive -Path $vsix -DestinationPath $dest -Force
    ```
    The config in `dap.lua` and `rust.lua` looks up the binary at
    `%LOCALAPPDATA%\codelldb\extension\adapter\codelldb.exe` on Windows and at
    Mason's path elsewhere — no per-machine config edits needed.

### Workflow A — rustaceanvim (recommended)

Best for Rust because it discovers cargo targets automatically.

1. Open a `.rs` file from the project root.
2. Set a breakpoint with `<leader>db` on a line.
3. `<leader>dR` → pick the bin/test/example you want → it builds and launches
   with the debugger attached.
4. Execution stops at the breakpoint; `dap-ui` opens with variables, stack,
   scopes, and breakpoints panels.
5. Step with `<F10>` / `<F11>` / `<F12>`; continue with `<F5>`.

### Workflow B — plain DAP

Works for any cargo project; the launch config in `dap.lua` auto-suggests
`target/debug/<crate-name>.exe` based on the current directory.

1. `<F5>` (or `<leader>dc`) → pick "Launch (cargo build)" → confirm the path.
2. Debugger attaches and stops at any set breakpoint.

### Keymaps

| Key | Action |
| --- | --- |
| `<leader>db` | Toggle breakpoint |
| `<leader>dB` | Conditional breakpoint |
| `<leader>dc` / `<F5>` | Continue / start |
| `<leader>do` / `<F10>` | Step over |
| `<leader>di` / `<F11>` | Step into |
| `<leader>dO` / `<F12>` | Step out |
| `<leader>dr` | Restart |
| `<leader>dx` | Terminate |
| `<leader>du` | Toggle debug UI |
| `<leader>de` | Eval expression (normal/visual) |
| `<leader>dR` | Rust: pick debuggable (rustaceanvim) |
| `<leader>cR` | Rust: pick runnable (rustaceanvim) |

You can also click the gutter to toggle a breakpoint (handled by the snacks
statuscolumn override in `dap.lua`).

### Notes

- The first launch in a session runs `cargo build` first — symbols are
  required, and `target/debug/` must exist.
- Breakpoints set before the session starts are remembered.
- `<leader>de` over a variable evaluates it; works in visual mode too.
- `nvim-dap-virtual-text` shows live variable values inline next to code while
  stopped at a breakpoint.

### Other languages

- **Python**: `dap.lua` auto-detects `.venv/bin/python` in the project root and
  configures `dap-python` against it.
- **Adding more**: drop a new adapter + `dap.configurations.<filetype>` entry
  into `dap.lua`, or create a dedicated plugin file under `lua/plugins/`.
