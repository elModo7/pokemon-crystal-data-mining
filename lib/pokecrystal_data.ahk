; Items
FileRead, tmp, data/pkmn_items.txt
items := getArrayOfData(tmp)

; Pokemon
FileRead, tmp, data/pkmn_pkmns.txt
pkmns := getArrayOfData(tmp)
pkmnsRev := getArrayOfData(tmp, 1)

; Types
FileRead, tmp, data/pkmn_types.txt
types := getArrayOfData(tmp)

; Moves
FileRead, tmp, data/pkmn_moves.txt
moves := getArrayOfData(tmp)

; Times
FileRead, tmp, data/pkmn_times.txt
times := getArrayOfData(tmp)

; Trainers
FileRead, tmp, data/pkmn_trainers.txt
trainers := getArrayOfData(tmp)

; Musics
FileRead, tmp, data/pkmn_musics.txt
musics := getArrayOfData(tmp)

; Maps
FileRead, tmp, data/pkmn_maps.txt
maps := getArrayOfData(tmp)

; DaysOfWeek
FileRead, tmp, data/pkmn_days_of_week.txt
daysOfWeek := getArrayOfData(tmp)

; Pokedex
FileRead, tmp, data/pokedex_crystal_ids.json
pokedex := JSON.Load(tmp)

; Moves Extended
FileRead, tmp, data/pkmn_moves.json
movesExtended := JSON.Load(tmp)

; Chars Case Sensitive
StringCaseSense, On
FileRead, tmp, data/pkmn_charmap.txt
;~ chars := getArrayOfData(tmp) ; This was not case sensitive, default AHK Maps don't allow for Case Sensitive Keys
chars := getArrayOfDataCaseSensitive(tmp)
charsRev := getArrayOfDataCaseSensitive(tmp, 1)
StringCaseSense, Off

getArrayOfData(tmp, reversed := 0){
    tmpArr := Array()
    Loop, parse, tmp, `n, `r
    {
        StringSplit, arr, A_LoopField, `;
		if(!reversed)
			tmpArr[arr1] := arr2
		else
			tmpArr[arr2] := arr1
    }
    return tmpArr
}

getArrayOfDataCaseSensitive(tmp, reversed := 0){
	tmpArr :=	ComObjCreate("Scripting.Dictionary")
	Loop, parse, tmp, `n, `r
    {
        StringSplit, arr, A_LoopField, `;
		if(!reversed)
			tmpArr.item(arr1) := arr2
		else
			tmpArr.item(arr2) := arr1
    }
    return tmpArr
}