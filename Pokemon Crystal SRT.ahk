; ********************************************************************************
; IMPORTANT: You must compile this script for it to work! (or use releases)
; ********************************************************************************

; OS Version ...: Windows 10 (Previous versions tested working on Win7)
;@Ahk2Exe-SetName Pokemon Crystal SRT
;@Ahk2Exe-SetDescription Pokemon Crystal Speedrun Tool
;@Ahk2Exe-SetVersion 0.3.6
;@Ahk2Exe-SetCopyright Copyright (c) 2025`, elModo7
;@Ahk2Exe-SetOrigFilename Pokemon Crystal SRT.exe
version := "0.3.6"
#NoEnv
#SingleInstance, Force
#Persistent
DetectHiddenWindows, On
ListLines, Off
SetBatchLines, -1
pokedexSpriteHalfSize := 0 ; Editable size of pokedex 0: Normal / 1: Small
backgroundGuiColor := 0x252c3d
#Include <JSON>
#Include <deepCopy>
#Include <talk>
#Include <pokecrystal_data>
#Include <noTrayOrphans>
#Include <aboutScreen>
FileInstall, res\font\Pokemon GB.ttf, %A_Temp%\Pokemon GB.ttf, 0
RutaFuente = %A_Temp%\Pokemon GB.ttf
font1 := New CustomFont(RutaFuente)
FileInstall, res\font\pkmnfl.ttf, %A_Temp%\pkmnfl.ttf, 0
RutaFuente2 = %A_Temp%\pkmnfl.ttf
font2 := New CustomFont(RutaFuente2)
global gameData := []
global gameDataJson := ""
global oldGameData := []
OnExit, exitGracefully
gosub, closeEmuHook
sender := new talk("Background")

; Tray menu
Menu, Tray, NoStandard
Menu, Tray, Tip, elModo7's Pkmn Crystal SRT v%version%
Menu, Tray, Add, About, showAbout
Menu, Tray, Add,
Menu, Tray, Add, Restart, Restart
Menu, Tray, Add, Exit, Exit

; TRAINER CARD
Gui tcard:+LastFound +E0x02000000 +E0x00080000
Gui tcard:Font, s10, Pokemon GB
Gui tcard:Add, Text, x24 y232 w272 h37 +BackgroundTrans vmusic,
Gui tcard:Add, Text, x24 y200 w200 h37 +BackgroundTrans vmapName,
Gui tcard:Font, s12, Pokemon GB
Gui tcard:Add, Text, x112 y28 w120 h23 +0x200 +BackgroundTrans vplayerName,
Gui tcard:Add, Text, x72 y61 w120 h23 +0x200 +BackgroundTrans vtrainerID,
Gui tcard:Add, Text, x130 y85 w120 h23 +0x200 +BackgroundTrans vmoney,
Gui tcard:Add, Text, x24 y152 w143 h23 +0x200 +BackgroundTrans, PLAY TIME
Gui tcard:Add, Text, x192 y152 w80 h23 +0x200 +BackgroundTrans vigt,
Gui tcard:Add, Text, x24 y176 w120 h23 +0x200 +BackgroundTrans, COINS
Gui tcard:Add, Text, x112 y176 w120 h23 +0x200 +BackgroundTrans vcoins,
Gui tcard:Add, Text, x30 y105 w177 h23 +0x200 +BackgroundTrans, REPEL STE.
Gui tcard:Add, Text, x216 y105 w80 h23 +0x200 +BackgroundTrans vrepelSteps,
Gui tcard:Add, Picture, hidden vbadge1 x56 y321 w32 h32 +BackgroundTrans, res\badges\01.png
Gui tcard:Add, Picture, hidden vbadge2 x120 y321 w32 h32 +BackgroundTrans, res\badges\02.png
Gui tcard:Add, Picture, hidden vbadge3 x184 y321 w32 h32 +BackgroundTrans, res\badges\03.png
Gui tcard:Add, Picture, hidden vbadge4 x252 y321 w32 h32 +BackgroundTrans, res\badges\04.png
Gui tcard:Add, Picture, hidden vbadge5 x56 y369 w32 h32 +BackgroundTrans, res\badges\05.png
Gui tcard:Add, Picture, hidden vbadge6 x120 y369 w32 h32 +BackgroundTrans, res\badges\06.png
Gui tcard:Add, Picture, hidden vbadge7 x184 y369 w32 h32 +BackgroundTrans, res\badges\07.png
Gui tcard:Add, Picture, hidden vbadge8 x251 y369 w32 h32 +BackgroundTrans, res\badges\08.png
Gui tcard:Add, Picture, hidden vbadge9 x57 y465 w32 h32 +BackgroundTrans, res\badges\09.png
Gui tcard:Add, Picture, hidden vbadge10 x120 y465 w32 h32 +BackgroundTrans, res\badges\10.png
Gui tcard:Add, Picture, hidden vbadge11 x184 y465 w32 h32 +BackgroundTrans, res\badges\11.png
Gui tcard:Add, Picture, hidden vbadge12 x248 y465 w32 h32 +BackgroundTrans, res\badges\12.png
Gui tcard:Add, Picture, hidden vbadge13 x56 y513 w32 h32 +BackgroundTrans, res\badges\13.png
Gui tcard:Add, Picture, hidden vbadge14 x121 y513 w32 h32 +BackgroundTrans, res\badges\14.png
Gui tcard:Add, Picture, hidden vbadge15 x184 y513 w32 h32 +BackgroundTrans, res\badges\15.png
Gui tcard:Add, Picture, hidden vbadge16 x248 y513 w32 h32 +BackgroundTrans, res\badges\16.png
Gui tcard:Add, Picture, x240 y18 w54 h110 hidden vgirl, res\girl.png
Gui tcard:Add, Picture, x244 y18 w54 h110 hidden vboy, res\boy.png
Gui tcard:Add, Picture, x0 y0 w320 h577, res\trainer_card.png
Gui tcard:Show, x0 y0 w320 h577, Trainer Card

; PLAYER TEAM ICONS
Gui playerTeam:+LastFound +E0x02000000 +E0x00080000
Gui playerTeam:Color, %backgroundGuiColor%
Gui playerTeam:Add, Picture, +BackgroundTrans vplayerPk1 x8 y8 w40 h30, res\pokemon_icon\0.png
Gui playerTeam:Add, Picture, +BackgroundTrans vplayerPk2 x48 y8 w40 h30, res\pokemon_icon\0.png
Gui playerTeam:Add, Picture, +BackgroundTrans vplayerPk3 x88 y8 w40 h30, res\pokemon_icon\0.png
Gui playerTeam:Add, Picture, +BackgroundTrans vplayerPk4 x128 y8 w40 h30, res\pokemon_icon\0.png
Gui playerTeam:Add, Picture, +BackgroundTrans vplayerPk5 x168 y8 w40 h30, res\pokemon_icon\0.png
Gui playerTeam:Add, Picture, +BackgroundTrans vplayerPk6 x208 y8 w40 h30, res\pokemon_icon\0.png
Gui playerTeam:Show, x321 y0 w248 h54, Player Pokemon Team

; ENEMY TEAM ICONS
Gui enemyTeam:+LastFound +E0x02000000 +E0x00080000
Gui enemyTeam:Color, %backgroundGuiColor%
Gui enemyTeam:Add, Picture, +BackgroundTrans venemyTrainer x16 y12 w63 h65, res\trainers\eusine.png
Gui enemyTeam:Add, Picture, +BackgroundTrans venemyPk1 x88 y8 w40 h30, res\pokemon_icon\0.png
Gui enemyTeam:Add, Picture, +BackgroundTrans venemyPk2 x128 y8 w40 h30, res\pokemon_icon\0.png
Gui enemyTeam:Add, Picture, +BackgroundTrans venemyPk3 x168 y8 w40 h30, res\pokemon_icon\0.png
Gui enemyTeam:Add, Picture, +BackgroundTrans venemyPk4 x88 y48 w40 h30, res\pokemon_icon\0.png
Gui enemyTeam:Add, Picture, +BackgroundTrans venemyPk5 x128 y48 w40 h30, res\pokemon_icon\0.png
Gui enemyTeam:Add, Picture, +BackgroundTrans venemyPk6 x168 y48 w40 h30, res\pokemon_icon\0.png
Gui enemyTeam:Show, x321 y80 w215 h88, Enemy Trainer Team

; TOOL WINDOW
Gui pokeTools:New,, Pokemon Crystal Tools
Gui pokeTools:Font, s12 cWhite, Pokemon FireLeaf
Gui pokeTools:Color, %backgroundGuiColor%
Gui pokeTools:Add, CheckBox, +BackgroundTrans vwalkThroughWalls disabled x8 y8 w189 h23, Walk Through Walls
Gui pokeTools:Add, CheckBox, +BackgroundTrans valwaysBike disabled x8 y32 w189 h23, Always On Bike
Gui pokeTools:Add, CheckBox, +BackgroundTrans vnoRandomBattles disabled x8 y56 w189 h23, No Random Battles
Gui pokeTools:Add, CheckBox, +BackgroundTrans vforceShinyEncounter disabled x8 y80 w189 h23, Force Shiny Encounter
Gui pokeTools:Add, CheckBox, +BackgroundTrans vsetBuenaPasswordTrainerID disabled x8 y104 w327 h23, Set Buena's Password to your Trainer ID
Gui pokeTools:Add, CheckBox, +BackgroundTrans vthrowMaxRepel disabled x8 y128 w189 h23, Throw Max Repel
Gui pokeTools:Add, CheckBox, +BackgroundTrans gRestart x184 y40 w152 h23 +Right, Reload Everything
for k, v in pkmnsRev
    txtPokemons .= k "|"
i := 1
while(i <= 100){
    txtLvls .= i "|"
    i++
}

Gui pokeTools:Add, CheckBox, x8 y152 w250 h23 disabled vforcePokemon, Force specific Wild Pokemon
Gui pokeTools:Add, Text, x8 y176 w56 h23 +0x200, Pokemon:
Gui pokeTools:Add, ComboBox, x70 y176 w120 vforcePokeID disabled, %txtPokemons%
Gui pokeTools:Add, Text, x8 y210 w56 h23 +0x200, Level
Gui pokeTools:Add, ComboBox, x70 y210 w120 vforcePokeLvl disabled, %txtLvls%
Gui pokeTools:Font, s12 c0xFF00FF, Pokemon FireLeaf
Gui pokeTools:Add, Text, +BackgroundTrans x8 y270 w329 h23 +0x200 +Center, elModo7's Pokemon Crystal Speedrun Tool
Gui pokeTools:Font, s12 c0x00B000, Pokemon FireLeaf
Gui pokeTools:Add, Text, +BackgroundTrans x200 y8 w138 h23 +0x200 +Right, Version: %version%
Gui pokeTools:Show, x321 y192 w343 h297, Pokemon Crystal Tools

; ACTIVE POKEMON
Gui active:+LastFound +E0x02000000 +E0x00080000
Gui active:Font, s12, Pokemon GB
Gui active:Add, Text, vppNickname x128 y29 w160 h23 +0x200 +BackgroundTrans,
Gui active:Add, Text, vppSpecie x160 y61 w160 h23 +0x200 +BackgroundTrans,
Gui active:Add, Text, vppSpecieID x160 y-3 w51 h23 +BackgroundTrans,
Gui active:Add, Text, vppExp x208 y157 w120 h23 +0x200 +BackgroundTrans,
Gui active:Add, Text, vppLvl x224 y-3 w120 h23 +0x200 +BackgroundTrans,
Gui active:Add, Text, vppHp x16 y157 w120 h23 +0x200 +BackgroundTrans,
Gui active:Add, Text, vppStatus x0 y205 w143 h23 +0x200 +Center +BackgroundTrans,
Gui active:Add, Text, vppItem x128 y288 w192 h23 +0x200 +BackgroundTrans, ---
Gui active:Add, Text, vppMove1 x128 y320 w191 h23 +0x200 +BackgroundTrans,
Gui active:Add, Text, vppMove2 x128 y352 w191 h23 +0x200 +BackgroundTrans,
Gui active:Add, Text, vppMove3 x128 y384 w191 h23 +0x200 +BackgroundTrans,
Gui active:Add, Text, vppMove4 x128 y416 w191 h23 +0x200 +BackgroundTrans,
Gui active:Add, Text, vppPPMove1 x240 y336 w84 h23 +Center +BackgroundTrans,
Gui active:Add, Text, vppPPMove2 x240 y368 w84 h23 +Center +BackgroundTrans,
Gui active:Add, Text, vppPPMove3 x240 y400 w84 h23 +Center +BackgroundTrans,
Gui active:Add, Text, vppPPMove4 x240 y432 w84 h23 +Center +BackgroundTrans,
Gui active:Add, Text, vppOTName x336 y205 w147 h23 +0x200 +Center +BackgroundTrans,
Gui active:Add, Text, vppOTID x352 y157 w120 h23 +0x200 +BackgroundTrans,
Gui active:Add, Text, x320 y223 w171 h23 +0x200 +BackgroundTrans, HP TYPE
Gui active:Add, Text, vppHiddenPowerType x328 y238 w130 h23 +0x200 +BackgroundTrans Right,
Gui active:Add, Text, x320 y253 w171 h23 +0x200 +BackgroundTrans, HP POWER
Gui active:Add, Text, vppHiddenPowerPower x328 y268 w100 h23 +0x200 +BackgroundTrans Right,
Gui active:Add, Text, vppAtk x592 y141 w54 h23 +0x200 +BackgroundTrans,
Gui active:Add, Text, vppDef x592 y173 w54 h23 +0x200 +BackgroundTrans,
Gui active:Add, Text, vppSpa x592 y205 w54 h23 +0x200 +BackgroundTrans,
Gui active:Add, Text, vppSpd x592 y237 w54 h23 +0x200 +BackgroundTrans,
Gui active:Add, Text, vppSpeed x592 y269 w54 h23 +0x200 +BackgroundTrans,
Gui active:Add, Text, x320 y288 w120 h23 +0x200 +BackgroundTrans, EVs
Gui active:Add, Text, x488 y288 w120 h23 +0x200 +BackgroundTrans, IVs
Gui active:Add, Text, x328 y320 w52 h23 +0x200 +BackgroundTrans, ATK
Gui active:Add, Text, x328 y344 w52 h23 +0x200 +BackgroundTrans, DEF
Gui active:Add, Text, x328 y368 w53 h23 +0x200 +BackgroundTrans, SPC
Gui active:Add, Text, x328 y392 w55 h23 +0x200 +BackgroundTrans, SPD
Gui active:Add, Text, x328 y416 w52 h23 +0x200 +BackgroundTrans, HP
Gui active:Add, Text, x496 y320 w52 h23 +0x200 +BackgroundTrans, ATK
Gui active:Add, Text, x496 y344 w52 h23 +0x200 +BackgroundTrans, DEF
Gui active:Add, Text, x496 y368 w65 h23 +0x200 +BackgroundTrans, SPEC
Gui active:Add, Text, x496 y392 w83 h23 +0x200 +BackgroundTrans, SPEED
Gui active:Add, Text, vppEVAtk x392 y320 w83 h23 +0x200 +BackgroundTrans,
Gui active:Add, Text, vppEVDef x392 y344 w83 h23 +0x200 +BackgroundTrans,
Gui active:Add, Text, vppEVSpc x392 y368 w83 h23 +0x200 +BackgroundTrans,
Gui active:Add, Text, vppEVSpd x392 y392 w83 h23 +0x200 +BackgroundTrans,
Gui active:Add, Text, vppEVHP x392 y416 w83 h23 +0x200 +BackgroundTrans,
Gui active:Add, Text, vppIVAtk x600 y320 w36 h23 +0x200 +BackgroundTrans,
Gui active:Add, Text, vppIVDef x600 y344 w36 h23 +0x200 +BackgroundTrans,
Gui active:Add, Text, vppIVSpc x600 y368 w36 h23 +0x200 +BackgroundTrans,
Gui active:Add, Text, vppIVSpd x600 y392 w36 h23 +0x200 +BackgroundTrans,
Gui active:Add, Picture, x430 y64 w16 h16, res\status\shiny.png
Gui active:Add, Text, x152 y189 w171 h23 +0x200 +BackgroundTrans, FRIENDSHIP
Gui active:Add, Picture, x128 y88 w16 h8 vppStatusImg,
Gui active:Add, Text, x8 y224 w120 h23 +0x200 +BackgroundTrans vppPokerus hidden, POKERUS
Gui active:Add, Picture, x168 y88 w40 h16 vppPokerusImg hidden, res\status\Pokerus.png
Gui active:Add, Text, vppFriendship x264 y208 w54 h23 +0x200 +BackgroundTrans, 70
Gui active:Add, Picture, +BackgroundTrans x16 y16 w96 h96 vppImgMain,
Gui active:Add, Picture, +BackgroundTrans x110 y56 w40 h30 vppImgIco,
Gui active:Add, Picture, +BackgroundTrans x328 y8 w48 h48 vppImgPkmn,
Gui active:Add, Picture, +BackgroundTrans x384 y8 w48 h48 vppImgPkmnB,
Gui active:Add, Picture, +BackgroundTrans x328 y64 w48 h48 vppImgPkmnS,
Gui active:Add, Picture, +BackgroundTrans x384 y64 w48 h48 vppImgPkmnBS,
Gui active:Add, Picture, +BackgroundTrans x104 y0 w16 h16 vppShiny hidden, res\status\shiny.png
Gui active:Add, Picture, +BackgroundTrans x0 y0 w640 h451, res\active_pokemon.png
Gui active:Show, x665 y0 w640 h451, Active Pokemon

; ENEMY POKEMON
Gui enemy:+LastFound +E0x02000000 +E0x00080000
Gui enemy:Font, s12, Pokemon GB
Gui enemy:Add, Text, vepNickname x128 y29 w160 h23 +0x200 +BackgroundTrans,
Gui enemy:Add, Text, vepSpecie x160 y61 w160 h23 +0x200 +BackgroundTrans,
Gui enemy:Add, Text, vepSpecieID x160 y-3 w51 h23 +BackgroundTrans,
Gui enemy:Add, Text, vepLvl x224 y-3 w120 h23 +0x200 +BackgroundTrans,
Gui enemy:Add, Text, vepHp x16 y157 w120 h23 +0x200 +BackgroundTrans,
Gui enemy:Add, Text, vepStatus x0 y205 w143 h23 +0x200 +Center +BackgroundTrans,
Gui enemy:Add, Text, vepType x0 y241 w143 h55 +Center +BackgroundTrans,
Gui enemy:Add, Text, vepItem x128 y288 w192 h23 +0x200 +BackgroundTrans, ---
Gui enemy:Add, Text, vepMove1 x128 y320 w191 h23 +0x200 +BackgroundTrans,
Gui enemy:Add, Text, vepMove2 x128 y352 w191 h23 +0x200 +BackgroundTrans,
Gui enemy:Add, Text, vepMove3 x128 y384 w191 h23 +0x200 +BackgroundTrans,
Gui enemy:Add, Text, vepMove4 x128 y416 w191 h23 +0x200 +BackgroundTrans,
Gui enemy:Add, Text, vepPPMove1 x240 y336 w84 h23 +Center +BackgroundTrans,
Gui enemy:Add, Text, vepPPMove2 x240 y368 w84 h23 +Center +BackgroundTrans,
Gui enemy:Add, Text, vepPPMove3 x240 y400 w84 h23 +Center +BackgroundTrans,
Gui enemy:Add, Text, vepPPMove4 x240 y432 w84 h23 +Center +BackgroundTrans,
Gui enemy:Add, Text, vepOTName x336 y205 w147 h23 +0x200 +Center +BackgroundTrans,
Gui enemy:Add, Text, vepOTID x352 y157 w120 h23 +0x200 +BackgroundTrans,
Gui enemy:Add, Text, vepAtk x592 y141 w54 h23 +0x200 +BackgroundTrans,
Gui enemy:Add, Text, vepDef x592 y173 w54 h23 +0x200 +BackgroundTrans,
Gui enemy:Add, Text, vepSpa x592 y205 w54 h23 +0x200 +BackgroundTrans,
Gui enemy:Add, Text, vepSpd x592 y237 w54 h23 +0x200 +BackgroundTrans,
Gui enemy:Add, Text, vepSpeed x592 y269 w54 h23 +0x200 +BackgroundTrans,
Gui enemy:Add, Text, x320 y288 w120 h23 +0x200 +BackgroundTrans, STATS
Gui enemy:Add, Text, x488 y288 w120 h23 +0x200 +BackgroundTrans, IVs
Gui enemy:Add, Text, x328 y310 w52 h23 +0x200 +BackgroundTrans, ATK
Gui enemy:Add, Text, x328 y334 w52 h23 +0x200 +BackgroundTrans, DEF
Gui enemy:Add, Text, x328 y358 w53 h23 +0x200 +BackgroundTrans, SPA
Gui enemy:Add, Text, x328 y382 w53 h23 +0x200 +BackgroundTrans, SPD
Gui enemy:Add, Text, x328 y406 w55 h23 +0x200 +BackgroundTrans, SPE
Gui enemy:Add, Text, x328 y430 w52 h23 +0x200 +BackgroundTrans, HP
Gui enemy:Add, Text, x496 y320 w52 h23 +0x200 +BackgroundTrans, ATK
Gui enemy:Add, Text, x496 y344 w52 h23 +0x200 +BackgroundTrans, DEF
Gui enemy:Add, Text, x496 y368 w65 h23 +0x200 +BackgroundTrans, SPEC
Gui enemy:Add, Text, x496 y392 w83 h23 +0x200 +BackgroundTrans, SPEED
Gui enemy:Add, Text, vepStAtk x392 y310 w83 h23 +0x200 +BackgroundTrans,
Gui enemy:Add, Text, vepStDef x392 y334 w83 h23 +0x200 +BackgroundTrans,
Gui enemy:Add, Text, vepStSpa x392 y358 w83 h23 +0x200 +BackgroundTrans,
Gui enemy:Add, Text, vepStSpd x392 y382 w83 h23 +0x200 +BackgroundTrans,
Gui enemy:Add, Text, vepStSpeed x392 y406 w83 h23 +0x200 +BackgroundTrans,
Gui enemy:Add, Text, vepStHP x392 y430 w83 h23 +0x200 +BackgroundTrans,
Gui enemy:Add, Text, vepIVAtk x600 y320 w36 h23 +0x200 +BackgroundTrans,
Gui enemy:Add, Text, vepIVDef x600 y344 w36 h23 +0x200 +BackgroundTrans,
Gui enemy:Add, Text, vepIVSpc x600 y368 w36 h23 +0x200 +BackgroundTrans,
Gui enemy:Add, Text, vepIVSpd x600 y392 w36 h23 +0x200 +BackgroundTrans,
Gui enemy:Add, Picture, x430 y64 w16 h16, res\status\shiny.png
Gui enemy:Add, Text, x152 y130 w171 h23 +0x200 +BackgroundTrans, FRIENDSHIP
Gui enemy:Add, Text, vepFriendship x264 y145 w54 h23 +0x200 +BackgroundTrans, 70
Gui enemy:Add, Text, x152 y160 w171 h23 +0x200 +BackgroundTrans, CATCH RATE
Gui enemy:Add, Text, vepCatchRate x264 y175 w54 h23 +0x200 +BackgroundTrans,
Gui enemy:Add, Text, x149 y190 w171 h23 +0x200 +BackgroundTrans, GROWTH RATE
Gui enemy:Add, Text, vepGrowthRate x264 y205 w54 h23 +0x200 +BackgroundTrans,
Gui enemy:Add, Text, x149 y220 w171 h23 +0x200 +BackgroundTrans, ENCOUNTER
Gui enemy:Add, Text, vepEncounterType x150 y235 w160 h23 Right +0x200 +BackgroundTrans,
Gui enemy:Add, Text, x149 y250 w171 h23 +0x200 +BackgroundTrans, BASE EXP
Gui enemy:Add, Text, vepExp x264 y265 w54 h23 +0x200 +BackgroundTrans,
Gui enemy:Add, Text, x320 y130 w171 h23 +0x200 +BackgroundTrans, HP TYPE
Gui enemy:Add, Text, vepHiddenPowerType x328 y145 w130 h23 +0x200 +BackgroundTrans Right,
Gui enemy:Add, Text, x320 y160 w171 h23 +0x200 +BackgroundTrans, HP POWER
Gui enemy:Add, Text, vepHiddenPowerPower x328 y175 w100 h23 +0x200 +BackgroundTrans Right,
Gui enemy:Add, Text, x320 y190 w171 h23 +0x200 +BackgroundTrans, HELD ITEMS
Gui enemy:Add, Text, vcanHoldItems x328 y205 w150 h23 +0x200 +BackgroundTrans Right, ---
Gui enemy:Add, Text, x320 y250 w171 h23 +0x200 +BackgroundTrans, ENC TYPE
Gui enemy:Add, Text, vbattleType x328 y265 w150 h23 +0x200 +BackgroundTrans Right,
Gui enemy:Add, Picture, x128 y88 w16 h8 vepStatusImg,
Gui enemy:Add, Text, x8 y224 w120 h23 +0x200 +BackgroundTrans vepPokerus hidden, POKERUS
Gui enemy:Add, Picture, x168 y88 w40 h16 vepPokerusImg hidden, res\status\Pokerus.png
Gui enemy:Add, Picture, +BackgroundTrans x16 y16 w96 h96 vepImgMain,
Gui enemy:Add, Picture, +BackgroundTrans x110 y56 w40 h30 vepImgIco,
Gui enemy:Add, Picture, +BackgroundTrans x328 y8 w48 h48 vepImgPkmn,
Gui enemy:Add, Picture, +BackgroundTrans x384 y8 w48 h48 vepImgPkmnB,
Gui enemy:Add, Picture, +BackgroundTrans x328 y64 w48 h48 vepImgPkmnS,
Gui enemy:Add, Picture, +BackgroundTrans x384 y64 w48 h48 vepImgPkmnBS,
Gui enemy:Add, Picture, +BackgroundTrans x104 y0 w16 h16 vepShiny hidden, res\status\shiny.png
Gui enemy:Add, Text, x430 y5 w220 h23 +0x200 +BackgroundTrans vpokedexSeen, Seen:0
Gui enemy:Add, Text, x430 y25 w220 h23 +0x200 +BackgroundTrans vpokedexCaught, Caught:0
Gui enemy:Add, Text, x430 y45 w220 h23 +0x200 +BackgroundTrans vpercentagePokedexCompleted, Complete:0`%
Gui enemy:Add, Picture, +BackgroundTrans x0 y0 w640 h451, res\enemy_pokemon.png
Gui enemy:Show, x665 y476 w640 h451, Enemy Pokemon

; MAP
Gui map:+LastFound +E0x02000000 +E0x00080000
Gui map:Color, %backgroundGuiColor%
Gui map:Add, Picture, x0 y0 w320 h288 vimgMap,
Gui map:Show, x0 y603 w320 h288, Pokemon Map

; DAYCARE
Gui dayCare:Add, Picture, x0 y0 w320 h288, res\daycare.png
Gui dayCare:Font, s12 c0xFFFFFF, Pokemon GB
Gui dayCare:Add, Text, x12 y32 w237 h23 +0x200 +BackgroundTrans vdayCareMan, 
Gui dayCare:Add, Text, x28 y202 w237 h23 +0x200 +BackgroundTrans vdayCareWoman, 
Gui dayCare:Add, Text, x128 y226 w101 h23 +0x200 +BackgroundTrans vdayCareSteps, 
Gui dayCare:Add, Text, x90 y67 w237 h23 +0x200 +BackgroundTrans vdayCareEggSpecie,
Gui dayCare:Add, Text, x74 y51 w237 h23 +0x200 +BackgroundTrans vdayCareEgg,
Gui dayCare:Font, s12 cYellow, Pokemon GB
Gui dayCare:Add, Text, x150 y185 w237 h23 +0x200 +BackgroundTrans vdayCareShiny hidden, SHINY!!
Gui dayCare:Show, w320 h288 x322 y515, Daycare Viewer

; POKEDEX
Gui pokedex:+LastFound +E0x02000000 +E0x00080000
imageSpacingWidth := 10
imageSpacingHeight := 10
x := imageSpacingWidth
y := imageSpacingHeight
imageWidth := 40 
imageHeight := 30
imageBgWidth := 50
imageBgHeight := 50
imagesPerRow := 13
totalImages := 251
transformpokedexSpriteHalfSize(pokedexSpriteHalfSize) ; Makes them half the size
i := 1
while(i <= totalImages){
    if(Mod(i-1, imagesPerRow) == 0 && i != 1){
        y += imageWidth + imageSpacingHeight
        x := imageSpacingWidth
    }
    progressX := x - (imageBgWidth - imageWidth)/2
    progressY := y - (imageBgHeight - imageHeight)/2
    
    Gui, pokedex:Add, Picture, x%x% y%y% w%imageWidth% h%imageHeight% +BackgroundTrans, % "res/pokemon_icon/" i ".png"
    Gui, pokedex:Add, Progress, hWndhPrg x%progressX% y%progressY% w%imageBgWidth% h%imageBgHeight% -Smooth +C0x008000 vpokedexPkId%i%, 0 ; +C0x008000 -> Captured +C0x004080 -> Seen
    
    x += imageWidth + imageSpacingWidth
    i++
}
Gui, pokedex:Show, x1250 y0,Pokedex Viewer

; ACTIVE POKEMON MOVEPOOL
Gui activeMovepool:+LastFound +E0x02000000 +E0x00080000
Gui activeMovepool:Color, %backgroundGuiColor%
Gui activeMovepool:Font, s12 cWhite, Pokemon GB
Gui activeMovepool:Add, Text, x10 y10 w340 h380 +BackgroundTrans vactivePokemonMovepool,
x := A_ScreenWidth - 360
y := A_ScreenHeight - 450
Gui activeMovepool:Show, h400 w360 x%x% y%y%, Active Movepool

Run, EmuHook_Core.exe
return

Exit:
pokeToolsGuiEscape:
pokeToolsGuiClose:
enemyTeamGuiEscape:
enemyTeamGuiClose:
playerTeamGuiEscape:
playerTeamGuiClose:
activeGuiEscape:
activeGuiClose:
tcardGuiEscape:
tcardGuiClose:
enemyGuiClose:
enemyGuiEscape:
mapGuiEscape:
mapGuiClose:
pokedexGuiClose:
pokedexGuiEscape:
dayCareGuiClose:
dayCareGuiEscape:
activeMovepoolGuiClose:
activeMovepoolGuiEscape:
emuSelectGuiClose:
emuSelectGuiEscape:
    ExitApp
    
Restart:
    Reload

mainLoop:
    ; FILE (NON-MEMORY) POKEDEX DATA
    gameData := JSON.Load(gameDataJson)
    
    if(gameData.activePokemon.specieID != oldGameData.activePokemon.specieID){
        curActivePkmnPokedex := pokedex[gameData.activePokemon.specieID]
        activePokemonMovepoolTxt := ""
        for k_level_up_learnset, moveLevel in curActivePkmnPokedex.level_up_learnset
        {
            StringUpper, moveLevelName, % moveLevel[2]
            activePokemonMovepoolTxt .= moveLevel[1] ((moveLevel[1] > 0 && moveLevel[1] < 10) ? "  - " : " - ") moveLevelName (k_level_up_learnset != a.level_up_learnset.length() ? "`n" : "")
        }
        GuiControl, activeMovepool:, activePokemonMovepool, % activePokemonMovepoolTxt
    }
    if(gameData.enemy.specieID != oldGameData.enemy.specieID){
        curEnemyPkmnPokedex := pokedex[gameData.enemy.specieID]
    }

    ; TRAINER CARD
    if(gameData.playerName != oldGameData.playerName)
        GuiControl, tcard:, playerName, % gameData.playerName
    if(gameData.trainerID != oldGameData.trainerID)
        GuiControl, tcard:, trainerID, % gameData.trainerID
    if(gameData.money != oldGameData.money)
        GuiControl, tcard:, money, % gameData.money
    if(gameData.mapName != oldGameData.mapName)
        GuiControl, tcard:, mapName, % "MAP: " gameData.mapName
    if(gameData.mapId != oldGameData.mapId)
        GuiControl, map:, imgMap, % "./res/map/" gameData.mapId ".png"
    if(gameData.igt_short != oldGameData.igt_short)
        GuiControl, tcard:, igt, % gameData.igt_short
    if(gameData.coins != oldGameData.coins)
        GuiControl, tcard:, coins, % gameData.coins
    if(gameData.repelSteps != oldGameData.repelSteps)
        GuiControl, tcard:, repelSteps, % gameData.repelSteps
    if(gameData.music != oldGameData.music)
        GuiControl, tcard:, music, % gameData.music
    if(oldGameData.gender != gameData.gender){
        if(gameData.gender == "Boy"){
            GuiControl, tcard:hide, girl
            GuiControl, tcard:show, boy
        }else{
            GuiControl, tcard:show, girl
            GuiControl, tcard:hide, boy
        }
    }
    ; MEDALS        
    if(gameData.johtoBadges[1] != oldGameData.johtoBadges[1])	
        if(gameData.johtoBadges[1])		
            GuiControl, tcard:show, badge1
        else
            GuiControl, tcard:hide, badge1
    if(gameData.johtoBadges[2] != oldGameData.johtoBadges[2])	
        if(gameData.johtoBadges[2])		
            GuiControl, tcard:show, badge2
        else
            GuiControl, tcard:hide, badge2
    if(gameData.johtoBadges[3] != oldGameData.johtoBadges[3])	
        if(gameData.johtoBadges[3])		
            GuiControl, tcard:show, badge3
        else
            GuiControl, tcard:hide, badge3
    if(gameData.johtoBadges[4] != oldGameData.johtoBadges[4])	
        if(gameData.johtoBadges[4])		
            GuiControl, tcard:show, badge4
        else
            GuiControl, tcard:hide, badge4
    if(gameData.johtoBadges[5] != oldGameData.johtoBadges[5])	
        if(gameData.johtoBadges[5])		
            GuiControl, tcard:show, badge5
        else
            GuiControl, tcard:hide, badge5
    if(gameData.johtoBadges[6] != oldGameData.johtoBadges[6])	
        if(gameData.johtoBadges[6])		
            GuiControl, tcard:show, badge6
        else
            GuiControl, tcard:hide, badge6
    if(gameData.johtoBadges[7] != oldGameData.johtoBadges[7])	
        if(gameData.johtoBadges[7])		
            GuiControl, tcard:show, badge7
        else
            GuiControl, tcard:hide, badge7
    if(gameData.johtoBadges[8] != oldGameData.johtoBadges[8])	
        if(gameData.johtoBadges[8])		
            GuiControl, tcard:show, badge8
        else
            GuiControl, tcard:hide, badge8
    if(gameData.kantoBadges[1] != oldGameData.kantoBadges[2])	
        if(gameData.kantoBadges[1])		
            GuiControl, tcard:show, badge9
        else
            GuiControl, tcard:hide, badge9
    if(gameData.kantoBadges[2] != oldGameData.kantoBadges[2])	
        if(gameData.kantoBadges[2])		
            GuiControl, tcard:show, badge10
        else
            GuiControl, tcard:hide, badge10
    if(gameData.kantoBadges[3] != oldGameData.kantoBadges[3])	
        if(gameData.kantoBadges[3])		
            GuiControl, tcard:show, badge11
        else
            GuiControl, tcard:hide, badge11
    if(gameData.kantoBadges[4] != oldGameData.kantoBadges[4])	
        if(gameData.kantoBadges[4])		
            GuiControl, tcard:show, badge12
        else
            GuiControl, tcard:hide, badge12
    if(gameData.kantoBadges[5] != oldGameData.kantoBadges[5])	
        if(gameData.kantoBadges[5])		
            GuiControl, tcard:show, badge13
        else
            GuiControl, tcard:hide, badge13
    if(gameData.kantoBadges[6] != oldGameData.kantoBadges[6])	
        if(gameData.kantoBadges[6])		
            GuiControl, tcard:show, badge14
        else
            GuiControl, tcard:hide, badge14
    if(gameData.kantoBadges[7] != oldGameData.kantoBadges[7])	
        if(gameData.kantoBadges[7])		
            GuiControl, tcard:show, badge15
        else
            GuiControl, tcard:hide, badge15
    if(gameData.kantoBadges[8] != oldGameData.kantoBadges[8])	
        if(gameData.kantoBadges[8])		
            GuiControl, tcard:show, badge16
        else
            GuiControl, tcard:hide, badge16

    
    ; PARTY POKEMON
    if(gameData.activePokemon.nickname != oldGameData.activePokemon.nickname)
        GuiControl, active:, ppNickname, % gameData.activePokemon.nickname
    if(gameData.activePokemon.specie != oldGameData.activePokemon.specie)
        GuiControl, active:, ppSpecie, % gameData.activePokemon.specie
    if(gameData.activePokemonID != oldGameData.activePokemonID){
        GuiControl, active:, ppSpecieID, % gameData.activePokemon.specieID
        GuiControl, active:, ppImgMain, % "res\pokemon\" gameData.activePokemon.specieID (gameData.activePokemon.shiny ? "s.png" : ".png")
        GuiControl, active:, ppImgIco, % "res\pokemon_icon\" gameData.activePokemon.specieID (gameData.activePokemon.shiny ? "s.png" : ".png")
        GuiControl, active:, ppImgPkmn, % "res\pokemon\" gameData.activePokemon.specieID ".png"
        GuiControl, active:, ppImgPkmnB, % "res\pokemon_back\" gameData.activePokemon.specieID ".png"
        GuiControl, active:, ppImgPkmnS, % "res\pokemon\" gameData.activePokemon.specieID "s.png"
        GuiControl, active:, ppImgPkmnBS, % "res\pokemon_back\" gameData.activePokemon.specieID "s.png"
    }
    if(gameData.activePokemon.level != oldGameData.activePokemon.level)
        GuiControl, active:, ppLvl, % "Lv." gameData.activePokemon.level
    if(gameData.activePokemon.hp != oldGameData.activePokemon.hp || gameData.activePokemon.maxHP != oldGameData.activePokemon.maxHP)
        GuiControl, active:, ppHP, % gameData.activePokemon.hp "/" gameData.activePokemon.maxHP
    if(gameData.activePokemon.experience != oldGameData.activePokemon.experience)
        GuiControl, active:, ppExp, % gameData.activePokemon.experience
    if(gameData.activePokemon.friendship != oldGameData.activePokemon.friendship)
        GuiControl, active:, ppFriendship, % gameData.activePokemon.friendship
    if(gameData.activePokemon.status != oldGameData.activePokemon.status){
        GuiControl, active:, ppStatus, % gameData.activePokemon.status
        GuiControl, active:, ppStatusImg, % "res\status\" gameData.activePokemon.status ".png"
    }
    if(gameData.activePokemon.item != oldGameData.activePokemon.item)
        GuiControl, active:, ppItem, % gameData.activePokemon.item == "" ? "---" : gameData.activePokemon.item
    if(gameData.activePokemon.move1 != oldGameData.activePokemon.move1)
        GuiControl, active:, ppMove1, % gameData.activePokemon.move1
    if(gameData.activePokemon.move2 != oldGameData.activePokemon.move2)
        GuiControl, active:, ppMove2, % gameData.activePokemon.move2
    if(gameData.activePokemon.move3 != oldGameData.activePokemon.move3)
        GuiControl, active:, ppMove3, % gameData.activePokemon.move3
    if(gameData.activePokemon.move4 != oldGameData.activePokemon.move4)
        GuiControl, active:, ppMove4, % gameData.activePokemon.move4
    if(gameData.activePokemon.move1PP != oldGameData.activePokemon.move1PP)
        GuiControl, active:, ppPPMove1, % "x" gameData.activePokemon.move1PP
    if(gameData.activePokemon.move2PP != oldGameData.activePokemon.move2PP)
        GuiControl, active:, ppPPMove2, % "x" gameData.activePokemon.move2PP
    if(gameData.activePokemon.move3PP != oldGameData.activePokemon.move3PP)
        GuiControl, active:, ppPPMove3, % "x" gameData.activePokemon.move3PP
    if(gameData.activePokemon.move4PP != oldGameData.activePokemon.move4PP)
        GuiControl, active:, ppPPMove4, % "x" gameData.activePokemon.move4PP
    if(gameData.activePokemon.trainerID != oldGameData.activePokemon.trainerID){
        GuiControl, active:, ppOTID, % gameData.activePokemon.trainerID
        if(gameData.trainerID != gameData.activePokemon.trainerID)
            GuiControl, active:, ppOTName, ???
        else
            GuiControl, active:, ppOTName, % gameData.playerName
    }
    if(gameData.activePokemon.attack != oldGameData.activePokemon.attack)
        GuiControl, active:, ppAtk, % gameData.activePokemon.attack
    if(gameData.activePokemon.defense != oldGameData.activePokemon.defense)
		GuiControl, active:, ppDef, % gameData.activePokemon.defense
    if(gameData.activePokemon.specialAttack != oldGameData.activePokemon.specialAttack)
		GuiControl, active:, ppSpa, % gameData.activePokemon.specialAttack
    if(gameData.activePokemon.specialDefense != oldGameData.activePokemon.specialDefense)
		GuiControl, active:, ppSpd, % gameData.activePokemon.specialDefense
    if(gameData.activePokemon.speed != oldGameData.activePokemon.speed)
		GuiControl, active:, ppSpeed, % gameData.activePokemon.speed
    if(gameData.activePokemon.attackEV != oldGameData.activePokemon.attackEV)
		GuiControl, active:, ppEVAtk, % gameData.activePokemon.attackEV
    if(gameData.activePokemon.defenseEV != oldGameData.activePokemon.defenseEV)
		GuiControl, active:, ppEVDef, % gameData.activePokemon.defenseEV
    if(gameData.activePokemon.specialEV != oldGameData.activePokemon.specialEV)
		GuiControl, active:, ppEVSpc, % gameData.activePokemon.specialEV
    if(gameData.activePokemon.speedEV != oldGameData.activePokemon.speedEV)
		GuiControl, active:, ppEVSpd, % gameData.activePokemon.speedEV
    if(gameData.activePokemon.hpEV != oldGameData.activePokemon.hpEV)
		GuiControl, active:, ppEVHP, % gameData.activePokemon.hpEV
    if(gameData.activePokemon.attackIV != oldGameData.activePokemon.attackIV)
		GuiControl, active:, ppIVAtk, % gameData.activePokemon.attackIV
    if(gameData.activePokemon.defenseIV != oldGameData.activePokemon.defenseIV)
		GuiControl, active:, ppIVDef, % gameData.activePokemon.defenseIV
    if(gameData.activePokemon.specialIV != oldGameData.activePokemon.specialIV)
		GuiControl, active:, ppIVSpc, % gameData.activePokemon.specialIV
    if(gameData.activePokemon.speedIV != oldGameData.activePokemon.speedIV)
		GuiControl, active:, ppIVSpd, % gameData.activePokemon.speedIV
    
    if(gameData.activePokemon.hiddenPowerType != oldGameData.activePokemon.hiddenPowerType)
		GuiControl, active:, ppHiddenPowerType, % gameData.activePokemon.hiddenPowerType
    if(gameData.activePokemon.hiddenPowerPower != oldGameData.activePokemon.hiddenPowerPower)
		GuiControl, active:, ppHiddenPowerPower, % gameData.activePokemon.hiddenPowerPower
    
    if(gameData.activePokemon.shiny != oldGameData.activePokemon.shiny)
        if(gameData.activePokemon.shiny)
            GuiControl, active:show, ppShiny
        else
            GuiControl, active:hide, ppShiny
    if(gameData.activePokemon.pokerus != oldGameData.activePokemon.pokerus)
        if(gameData.activePokemon.pokerus){
            GuiControl, active:show, ppPokerus
            GuiControl, active:show, ppPokerusImg
        }
        else{
            GuiControl, active:hide, ppPokerus
            GuiControl, active:hide, ppPokerusImg
        }
        
    ; ENEMY POKEMON
    if(gameData.enemy.nickname != oldGameData.enemy.nickname)
        GuiControl, enemy:, epNickname, % gameData.enemy.nickname
    if(gameData.enemy.specie != oldGameData.enemy.specie)
        GuiControl, enemy:, epSpecie, % gameData.enemy.specie
    if(gameData.enemy.specieID != 0 && (gameData.enemy.specieID != oldGameData.enemy.specieID || gameData.enemy.shiny != oldGameData.enemy.shiny)){
        GuiControl, enemy:, epSpecieID, % gameData.enemy.specieID
        GuiControl, enemy:, epImgMain, % "res\pokemon\" gameData.enemy.specieID (gameData.enemy.shiny ? "s.png" : ".png")
        GuiControl, enemy:, epImgIco, % "res\pokemon_icon\" gameData.enemy.specieID (gameData.enemy.shiny ? "s.png" : ".png")
        GuiControl, enemy:, epImgPkmn, % "res\pokemon\" gameData.enemy.specieID ".png"
        GuiControl, enemy:, epImgPkmnB, % "res\pokemon_back\" gameData.enemy.specieID ".png"
        GuiControl, enemy:, epImgPkmnS, % "res\pokemon\" gameData.enemy.specieID "s.png"
        GuiControl, enemy:, epImgPkmnBS, % "res\pokemon_back\" gameData.enemy.specieID "s.png"
    }
    if(gameData.enemy.level != oldGameData.enemy.level)
        GuiControl, enemy:, epLvl, % "Lv." gameData.enemy.level
    if(gameData.enemy.hp != oldGameData.enemy.hp || gameData.enemy.maxHP != oldGameData.enemy.maxHP)
        GuiControl, enemy:, epHP, % gameData.enemy.hp "/" gameData.enemy.maxHP
    if(gameData.enemy.experience != oldGameData.enemy.experience)
        GuiControl, enemy:, epExp, % gameData.enemy.experience
    if(gameData.enemy.friendship != oldGameData.enemy.friendship)
        GuiControl, enemy:, epFriendship, % gameData.enemy.friendship
    if(gameData.enemy.status != oldGameData.enemy.status){
        if(InStr(gameData.enemy.status, "Asleep")){
            GuiControl, enemy:, epStatus, % "SLEEP: " SubStr(gameData.enemy.status, 9, 1)
            GuiControl, enemy:, epStatusImg, % "res\status\Asleep.png"
        }else{
            GuiControl, enemy:, epStatus, % gameData.enemy.status
            GuiControl, enemy:, epStatusImg, % "res\status\" gameData.enemy.status ".png"
        }
    }
    if(gameData.enemy.item != oldGameData.enemy.item)
        GuiControl, enemy:, epItem, % gameData.enemy.item == "" ? "---" : gameData.enemy.item
    if(gameData.enemy.move1 != oldGameData.enemy.move1)
        GuiControl, enemy:, epMove1, % gameData.enemy.move1
    if(gameData.enemy.move2 != oldGameData.enemy.move2)
        GuiControl, enemy:, epMove2, % gameData.enemy.move2
    if(gameData.enemy.move3 != oldGameData.enemy.move3)
        GuiControl, enemy:, epMove3, % gameData.enemy.move3
    if(gameData.enemy.move4 != oldGameData.enemy.move4)
        GuiControl, enemy:, epMove4, % gameData.enemy.move4
    if(gameData.enemy.move1PP != oldGameData.enemy.move1PP)
        GuiControl, enemy:, epPPMove1, % "x" gameData.enemy.move1PP
    if(gameData.enemy.move2PP != oldGameData.enemy.move2PP)
        GuiControl, enemy:, epPPMove2, % "x" gameData.enemy.move2PP
    if(gameData.enemy.move3PP != oldGameData.enemy.move3PP)
        GuiControl, enemy:, epPPMove3, % "x" gameData.enemy.move3PP
    if(gameData.enemy.move4PP != oldGameData.enemy.move4PP)
        GuiControl, enemy:, epPPMove4, % "x" gameData.enemy.move4PP
    if(gameData.enemy.trainerID != oldGameData.enemy.trainerID){
        GuiControl, enemy:, epOTID, % gameData.enemy.trainerID
        if(gameData.trainerID != gameData.enemy.trainerID)
            GuiControl, enemy:, epOTName, ???
        else
            GuiControl, enemy:, epOTName, % gameData.playerName
    }
    if(gameData.enemy.atk != oldGameData.enemy.atk)
        GuiControl, enemy:, epAtk, % gameData.enemy.atk
    if(gameData.enemy.def != oldGameData.enemy.def)
        GuiControl, enemy:, epDef, % gameData.enemy.def
    if(gameData.enemy.spa != oldGameData.enemy.spa)
        GuiControl, enemy:, epSpa, % gameData.enemy.spa
    if(gameData.enemy.spd != oldGameData.enemy.spd)
        GuiControl, enemy:, epSpd, % gameData.enemy.spd
    if(gameData.enemy.speed != oldGameData.enemy.speed)
        GuiControl, enemy:, epSpeed, % gameData.enemy.speed
    if(gameData.enemy.baseAtk != oldGameData.enemy.baseAtk)
        GuiControl, enemy:, epStAtk, % gameData.enemy.baseAtk
    if(gameData.enemy.baseDef != oldGameData.enemy.baseDef)
        GuiControl, enemy:, epStDef, % gameData.enemy.baseDef
    if(gameData.enemy.baseSpa != oldGameData.enemy.baseSpa)
        GuiControl, enemy:, epStSpa, % gameData.enemy.baseSpa
    if(gameData.enemy.baseSpd != oldGameData.enemy.baseSpd)
        GuiControl, enemy:, epStSpd, % gameData.enemy.baseSpd
    if(gameData.enemy.baseSpeed != oldGameData.enemy.baseSpeed)
        GuiControl, enemy:, epStSpeed, % gameData.enemy.baseSpeed
    if(gameData.enemy.baseHP != oldGameData.enemy.baseHP)
        GuiControl, enemy:, epStHP, % gameData.enemy.baseHP
    
    if(gameData.enemy.canHoldItem1 != oldGameData.enemy.canHoldItem1 || gameData.enemy.canHoldItem2 != oldGameData.enemy.canHoldItem2){
        if(gameData.enemy.canHoldItem1 == gameData.enemy.canHoldItem2)
            GuiControl, enemy:, canHoldItems, ---
        else if(gameData.enemy.canHoldItem1 != gameData.enemy.canHoldItem2)
            if(gameData.enemy.canHoldItem1 != "" && gameData.enemy.canHoldItem2 != "")
                GuiControl, enemy:, canHoldItems, % gameData.enemy.canHoldItem1 "\`n" gameData.enemy.canHoldItem2
            else if(gameData.enemy.canHoldItem1 != "")
                GuiControl, enemy:, canHoldItems, % gameData.enemy.canHoldItem1
            else
                GuiControl, enemy:, canHoldItems, % gameData.enemy.canHoldItem2
    }
    
    if(gameData.enemy.attackIV != oldGameData.enemy.attackIV)
        GuiControl, enemy:, epIVAtk, % gameData.enemy.attackIV
    if(gameData.enemy.defenseIV != oldGameData.enemy.defenseIV)
        GuiControl, enemy:, epIVDef, % gameData.enemy.defenseIV
    if(gameData.enemy.specialIV != oldGameData.enemy.specialIV)
        GuiControl, enemy:, epIVSpc, % gameData.enemy.specialIV
    if(gameData.enemy.speedIV != oldGameData.enemy.speedIV)
        GuiControl, enemy:, epIVSpd, % gameData.enemy.speedIV
    
    if(gameData.enemy.growthRate != oldGameData.enemy.growthRate)
        GuiControl, enemy:, epGrowthRate, % gameData.enemy.growthRate
    if(gameData.enemy.catchRate != oldGameData.enemy.catchRate)
        GuiControl, enemy:, epCatchRate, % gameData.enemy.catchRate
    if(gameData.encounterType != oldGameData.encounterType)
        GuiControl, enemy:, epEncounterType, % gameData.encounterType
    if(gameData.enemy.type1 != oldGameData.enemy.type1 || gameData.enemy.type2 != oldGameData.enemy.type2)
        if(gameData.enemy.type1 != gameData.enemy.type2)
            GuiControl, enemy:, epType, % gameData.enemy.type1 "`n" gameData.enemy.type2
        else
            GuiControl, enemy:, epType, % gameData.enemy.type1
    if(gameData.enemy.baseExp != oldGameData.enemy.baseExp)
        GuiControl, enemy:, epExp, % gameData.enemy.baseExp
    
    if(gameData.enemy.hiddenPowerType != oldGameData.enemy.hiddenPowerType)
        GuiControl, enemy:, epHiddenPowerType, % gameData.enemy.hiddenPowerType
    if(gameData.enemy.hiddenPowerPower != oldGameData.enemy.hiddenPowerPower)
        GuiControl, enemy:, epHiddenPowerPower, % gameData.enemy.hiddenPowerPower
    if(gameData.battleType != oldGameData.battleType)
		GuiControl, enemy:, battleType, % gameData.battleType
    
    if(gameData.enemy.shiny != oldGameData.enemy.shiny)
        if(gameData.enemy.shiny)
            GuiControl, enemy:show, epShiny
        else
            GuiControl, enemy:hide, epShiny
    if(gameData.enemy.pokerus != oldGameData.enemy.pokerus)
        if(gameData.enemy.pokerus){
            GuiControl, enemy:show, epPokerus
            GuiControl, enemy:show, epPokerusImg
        }
        else{
            GuiControl, enemy:hide, epPokerus
            GuiControl, enemy:hide, epPokerusImg
        }
    
    ; PARTY TEAM ICONS
    for k, v in gameData.party
    {
        if(gameData.party[k].specieID != oldGameData.party[k].specieID || gameData.party[k].shiny != oldGameData.party[k].shiny){
            GuiControl, playerTeam:, playerPk%k%, % "res\pokemon_icon\" gameData.party[k].specieID (gameData.party[k].shiny == 1 ? "s.png" : ".png")
        }
    }
    if(gameData.pokemonPartyCount != oldGameData.pokemonPartyCount){
        k++
        while(k >= 0 && k <= 6){
            GuiControl, playerTeam:, playerPk%k%, % "res\pokemon_icon\0.png"
            k++
        }
    }
    
    ; ENEMY TEAM ICONS
    if(gameData.trainer.class != oldGameData.trainer.class){
        GuiControl, enemyTeam:, enemyTrainer, % "res\trainers\" gameData.trainer.class ".png"
    }
    for k, v in gameData.trainer.party
    {
        if(gameData.trainer.party[k].specieID != oldGameData.trainer.party[k].specieID)
            GuiControl, enemyTeam:, enemyPk%k%, % "res\pokemon_icon\" gameData.trainer.party[k].specieID ".png"
    }
    if(gameData.trainer.pokemonCount != oldGameData.trainer.pokemonCount){
        k++
        while(k >= 0 && k <= 6){
            GuiControl, enemyTeam:, enemyPk%k%, % "res\pokemon_icon\0.png"
            k++
        }
    }
    
    ; POKEDEX
    if(gameData.caughtCount != oldGameData.caughtCount || gameData.seenCount != oldGameData.seenCount){
        GuiControl, enemy:, pokedexSeen, % "Seen:" gameData.seenCount
        GuiControl, enemy:, pokedexCaught, % "Caught:" gameData.caughtCount
        GuiControl, enemy:, percentagePokedexCompleted, % "Complete:" Floor((gameData.caughtCount / 251) * 100) "%"
        pokedexCurId := 1
        while(pokedexCurId <= 251){
            if(gameData.caughtPokedex[pokedexCurId]){
                GuiControl, pokedex:+C0x008000, pokedexPkId%pokedexCurId%
                GuiControl, pokedex:, pokedexPkId%pokedexCurId%, 100
            }else if(gameData.seenPokedex[pokedexCurId]){
                GuiControl, pokedex:+C0x004080, pokedexPkId%pokedexCurId%
                GuiControl, pokedex:, pokedexPkId%pokedexCurId%, 100
            }else{
                GuiControl, pokedex:, pokedexPkId%pokedexCurId%, 0
            }
            pokedexCurId++
        }
    }
    
    ; DAYCARE
    if(gameData.dayCare.egg != oldGameData.dayCare.egg){
        GuiControl, dayCare:, dayCareEgg, % gameData.dayCare.egg
    }
    if(gameData.dayCare.man != oldGameData.dayCare.man){
        GuiControl, dayCare:, dayCareMan, % gameData.dayCare.man
    }
    if(gameData.dayCare.woman != oldGameData.dayCare.woman){
        GuiControl, dayCare:, dayCareWoman, % gameData.dayCare.woman
    }
    if(gameData.dayCare.stepsForEggChance != oldGameData.dayCare.stepsForEggChance){
        GuiControl, dayCare:, dayCareSteps, % gameData.dayCare.stepsForEggChance
    }
    if(gameData.dayCare.eggSpecie != oldGameData.dayCare.eggSpecie){
        GuiControl, dayCare:, dayCareEggSpecie, % gameData.dayCare.eggSpecie
    }    
    if(gameData.dayCare.eggShiny != oldGameData.dayCare.eggShiny){
        if(gameData.dayCare.eggShiny)
            GuiControl, dayCare:show, dayCareShiny
        else
            GuiControl, dayCare:hide, dayCareShiny
    }
    
    ;~ oldGameData := JSON.Dump(gameData)
    oldGameData := DeepCopy(gameData)
return

transformpokedexSpriteHalfSize(pokedexSpriteHalfSize){
	global
	if(pokedexSpriteHalfSize){
		imageWidth := imageWidth / 2
		imageHeight := imageHeight / 2
		imageBgWidth := imageBgWidth / 2
		imageBgHeight := imageBgHeight / 2
	}
}

; OTHER
chooseEmulatorMsgBox() {
    DetectHiddenWindows, On
    Process, Exist
    If (WinExist("ahk_class #32770 ahk_pid " . ErrorLevel)) {
        hIcon := LoadPicture("imageres.dll", "w32 Icon311", _)
        SendMessage 0x172, 1, %hIcon%, Static1 ; STM_SETIMAGE
        ControlSetText Button1, BGB
        ControlSetText Button2, mGBA
        ControlSetText Button3, VBA
    }
}

emuSelectVBA:
    gameExe := "ahk_exe VisualBoyAdvance.exe"
return

emuSelectVBAH:
    gameExe := "ahk_exe VisualBoyAdvance_H.exe"
return

emuSelectVBArr:
    gameExe := "ahk_exe VBA-rr-svn480.exe"
return

emuSelectMGBA:
    gameExe := "ahk_exe mGBA.exe"
return

emuSelectBizHawk:
    gameExe := "ahk_exe EmuHawk.exe"
return

emuSelectBGB:
    gameExe := "ahk_exe bgb64.exe"
return

emuSelectGambatteSpeedrun:
    gameExe := "ahk_exe gambatte_speedrun.exe"
    
return

moveWindow:
    PostMessage, 0xA1, 2,,, A 
Return

closeEmuHook:
    RunWait, taskkill /IM EmuHook_Core.exe /F,, Hide
    Process, Exist, EmuHook_Core.exe
	if	pid :=	ErrorLevel
	{
		Loop 
		{
			WinClose, ahk_pid %pid%, , 5
			if	ErrorLevel
				Process, Close, %pid%
			Process, Exist, EmuHook_Core.exe
		}	Until	!pid :=	ErrorLevel
	}
    NoTrayOrphans()
return

exitGracefully:
    gosub, closeEmuHook
ExitApp

showAbout:
	showAboutScreen("Pokemon Crystal SRT v" version, "A collection of data mining and Pokemon research tools for Pokemon Crystal U.")
return

aboutGuiEscape:
aboutGuiClose:
	AboutGuiClose()
return