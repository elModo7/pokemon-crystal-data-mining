# Pokémon Crystal Research Toolkit

A standalone application to run alongside your emulator and your copy of *Pokémon Crystal* that will show **real-time statistics as you play**.

It is compatible with the **English version of Pokémon Crystal** (*presumably should work with 1.0 and 1.1 versions*).

It also works with **a few romhacks** that do not change the original data structures too much.

Here is a **video preview** of the tool working: [YouTube video showcase](https://youtu.be/HL9EYusqOms)

## Features

- Real-time map.
  
- Real-time trainer card with key data.
  
- Small overlay showing the current player's team.
  
- Small overlay showing the opponent's team.
  
- Daycare Egg viewer, steps & compatibility.
  
- Player's active Pokémon stats window.
  
- Enemy's active Pokémon or wild encounters stats.
  
- Pokédex completion progress overlay.
  
- Active Pokémon's moveset.
  

## Getting Started

1. Download one of the compatible emulators.
  
2. Run your Pokémon Crystal rom in it.
  
3. Run Pokemon Crystal SRT.exe
  
  1. If you download from source you will need to download AutoHotkey v1, and compile it.
    
  2. Do **NOT rename** the files, it needs to be "*Pokemon Crystal SRT.exe*".
    

## Emulator Support

- mGBA 0.13
  
- BGB (64-Bit only)
  
- GSE
  
- Gambatte-Speedrun
  
- VisualBoyAdvance-Link
  
- VisualBoyAdvance-H
  
- VisualBoyAdvance-rr
  

## How it works?

This toolkit consists of two main concepts.

- Frontend GUIs (each tool has its own window, data is fetched periodically)
  
- EmuHook-Core (traces emulator memory and communicates with UI)
  
  - A preset of addresses are queried twice every second.

> [!IMPORTANT]  
> This tool reads from memory, it won't open any network connection, but it may be flagged by some heuristic tools due to its nature.
