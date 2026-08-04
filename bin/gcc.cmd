@echo off
REM Shim so the tree-sitter CLI can build parsers with zig instead of MSVC.
REM Named gcc/g++ so cc-rs picks GNU-style flags; the trailing --target
REM overrides the x86_64-pc-windows-msvc triple zig does not understand.
zig cc %* --target=x86_64-windows-gnu
