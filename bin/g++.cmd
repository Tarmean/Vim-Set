@echo off
REM See gcc.cmd. Used for grammars whose external scanner is C++.
zig c++ %* --target=x86_64-windows-gnu
