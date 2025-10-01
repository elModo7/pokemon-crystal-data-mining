; Function to perform a deep copy of an object
DeepCopy(obj) {
    newobj := {}
    for key, value in obj {
        ; If the value is an object, recursively copy it
        if IsObject(value) {
            newobj[key] := DeepCopy(value)
        } else {
            newobj[key] := value
        }
    }
    return newobj
}

/*
; Original object
originalObj := {key1: "value1", key2: {subkey1: "subvalue1"}}

; Perform a deep copy
copiedObj := DeepCopy(originalObj)

; Modify the copied object (optional)
copiedObj.key1 := "new value"

; Test to see if the modification affects the original object
MsgBox % originalObj.key1 ; This should display "value1"
MsgBox % copiedObj.key1   ; This should display "new value"
*/