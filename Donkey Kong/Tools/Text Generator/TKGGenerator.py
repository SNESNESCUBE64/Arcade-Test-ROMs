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
    charArray = list(reversed(charArray))

    for character in charArray:
        convString = Decode(character.lower())
        newString = newString + str(convString)

    newString = newString + "$3F"
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
            result = "$10, "
        case "a":
            result = "$11, "
        case "b":
            result = "$12, "
        case "c":
            result = "$13, "
        case "d":
            result = "$14, "
        case "e":
            result = "$15, "
        case "f":
            result = "$16, "
        case "g":
            result = "$17, "
        case "h":
            result = "$18, "
        case "i":
            result = "$19, "
        case "j":
            result = "$1A, "
        case "k":
            result = "$1B, "
        case "l":
            result = "$1C, "
        case "m":
            result = "$1D, "
        case "n":
            result = "$1E, "
        case "o":
            result = "$1F, "
        case "p":
            result = "$20, "
        case "q":
            result = "$21, "
        case "r":
            result = "$22, "
        case "s":
            result = "$23, "
        case "t":
            result = "$24, "
        case "u":
            result = "$25, "
        case "v":
            result = "$26, "
        case "w":
            result = "$27, "
        case "x":
            result = "$28, "
        case "y":
            result = "$29, "
        case "z":
            result = "$2A, "
        case ".":
            result = "$2B, "
        case "-":
            result = "$2C, "
        case _:
            result = "$FF, "

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