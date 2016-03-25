import json, os
let basics = {"TKPW": "g",
              "SWKPW*": "z",
              "A": "a",
              "PH": "m",
              "O": "o",
              "P": "p",
              "KW": "q",
              "R": "r",
              "U": "u",
              "SR": "v",
              "KP": "x",
              "TK": "d",
              "S": "s",
              "SKWR": "y",
              "-R": "h",
              "-B": "j",
              "-G": "k",
              "-S": "l",
              "PW": "b",
              "W": "w",
              "TP": "f",
              "T": "t",
              "TPH": "n"}
var commandList = newJObject()

for key, value in basics:
    let 
        leftSide = value[0]
        rightSide = value[1]

    let command = newJString("{^" & rightSide & "^}")
    commandList.add(leftSide, command)

writeFile("output.json", commandList.pretty)

