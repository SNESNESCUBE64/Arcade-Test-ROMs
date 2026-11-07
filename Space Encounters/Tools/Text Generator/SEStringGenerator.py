import tkinter as tk
from tkinter import *
import pyperclip

root = Tk()
root.geometry("250x200")
root.title(" Text Converter ")

def Take_input():
    INPUT = inputtxt.get()

    newString = "DB "
    inputString = ''
    inputString = str(INPUT)
    charArray = list(inputString)

    newString = newString + '$' + str(hex(len(charArray))[2:].zfill(2)).upper() + ', '

    for character in charArray:
        convString = Decode(character.lower())
        newString = newString + str(convString)
    
    newString = newString[:-2]

    Output.delete('1.0', END)
    Output.insert(END, newString)
    pyperclip.copy(newString)

def Decode(character):
    result = ",$FF "
    match character:
        case "0":
            result = "$00, "
        case "1":
            result = "$01, "
        case "2":
            result = "$02, "
        case "3":
            result = "$03, "
        case "4":
            result = "$04, "
        case "5":
            result = "$05, "
        case "6":
            result = "$06, "
        case "7":
            result = "$07, "
        case "8":
            result = "$08, "
        case "9":
            result = "$09, "
        case " ":
            result = "$1D, "
        case "a":
            result = "$0A, "
        case "b":
            result = "$0B, "
        case "c":
            result = "$0C, "
        case "d":
            result = "$0D, "
        case "e":
            result = "$0E, "
        case "f":
            result = "$0F, "
        case "h":
            result = "$10, "
        case "i":
            result = "$11, "
        case "l":
            result = "$12, "
        case "n":
            result = "$13, "
        case "o":
            result = "$14, "
        case "p":
            result = "$15, "
        case "r":
            result = "$16, "
        case "s":
            result = "$17, "
        case "t":
            result = "$18, "
        case "u":
            result = "$19, "
        case "v":
            result = "$1A, "
        case "z":
            result = "$1B, "
        case ":":
            result = "$1C, "
        case _:
            result = "$1D, "

    return result
    
l = Label(text = "Enter Text ")
inputtxt = Entry(root,
                width = 34,
                bg = "light yellow")

Output = Text(root, height = 5, 
              width = 25, 
              bg = "light cyan")

Display = Button(root, height = 2,
                 width = 26, 
                 text ="Convert and copy to clip board",
                 command = lambda:Take_input())

l.pack()
inputtxt.pack(pady=5)
Display.pack(pady=5)
Output.pack(pady=5)

mainloop()