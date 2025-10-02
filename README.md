# Pokémon Crystal Research Toolkit

A standalone application to run alongside your emulator and your copy of *Pokémon Crystal* that will show **real-time statistics as you play**.

It is compatible with the **English version of Pokémon Crystal** (*presumably should work with 1.0 and 1.1 versions*).

It also works with **a few romhacks** that do not change the original data structures too much.

Here is a **video preview** of the tool working: [YouTube video showcase](https://youtu.be/HL9EYusqOms)

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/293f043b-91d4-4bd3-8750-26617f5d8442" />

## Features

- Real-time map.

- Real-time trainer card with key data.
  
  - Money
  
  - Casino Coins
  
  - Trainer ID
  
  - Secret ID
  
  - Player Name
  
  - Current Map Name
  
  - Current BGM
  
  - Repel Steps
  
  - Badges
  
  - Time of Day
  
  - Playtime
  
  - Gender

- Player Pokémon Team.

- Opponent's team.
  
  - Enemy Trainer Type
  
  - Enemy Pokémon Team

- Daycare Manager
  
  - Egg readyness
  
  - Egg generation step counter
  
  - Breeding compatibility
  
  - Egg species
  
  - Egg shinyness (before hatching egg)
  
  - Egg stats (before hatching egg)

- Player's active Pokémon stats window.
  
  - Exp
  
  - EVs
  
  - IVs
  
  - Attacks
  
  - Friendship
  
  - Status
  
  - Level
  
  - Species
  
  - Stats
  
  - Hidden Power (Type / Power)
  
  - Held Item
  
  - Shinyness

- Enemy's active Pokémon or wild encounters stats.
  
  - Held Item
  
  - Catch Rate
  
  - Growth Rate
  
  - Encounter Type
  
  - Exp
  
  - EVs
  
  - IVs
  
  - Attacks
  
  - Friendship
  
  - Status
  
  - Level
  
  - Species
  
  - Stats
  
  - Base Stats
  
  - Hidden Power (Type / Power)
  
  - Base Exp
  
  - Shinyness

- Pokédex completion progress overlay.
  
  - Unseen
  
  - Seen
  
  - Captured
  
  - Progression Ratio

- Active Pokémon's moveset (Per Level)

## Getting Started

1. Download one of the compatible emulators.

2. Run your Pokémon Crystal rom in it.

3. Run Pokemon Crystal SRT.exe
   
   1. If you download from source you will need to download AutoHotkey v1, and compile "_Pokemon Crystal SRT.ahk_".
   
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



## More use cases

I have made a few tools using this as a base (just ask for new repo uploads)

- Discord shiny notifier

- Automated shiny hunting bot (multiple emulator instances)

- OBS Real-Time 3D Pokémon overlay (gif + websockets)

- Pokémon Home Cloud (personal on-premise pokémon cloud storage system)

- Multiplayer PoC
