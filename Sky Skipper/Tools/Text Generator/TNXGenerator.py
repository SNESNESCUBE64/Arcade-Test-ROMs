import tkinter as tk
from tkinter import *
from tkinter import ttk
import pyperclip

root = Tk()
root.geometry("250x250")
root.title(" Text Converter ")

def Take_input():
    INPUT = inputtxt.get()

    newString = "DB "
    inputString = ''
    inputString = str(INPUT)
    charArray = list(inputString)

    newString = newString + '$' + str(hex(len(charArray))[2:].zfill(2)) + ', '
    newString = newString + '$' + str(hex(color_dropdown.current())[2:].zfill(2)) + ', '
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
            result = "$FF, "
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
        case "g":
            result = "$10, "
        case "h":
            result = "$11, "
        case "i":
            result = "$12, "
        case "j":
            result = "$13, "
        case "k":
            result = "$14, "
        case "l":
            result = "$15, "
        case "m":
            result = "$16, "
        case "n":
            result = "$17, "
        case "o":
            result = "$18, "
        case "p":
            result = "$19, "
        case "q":
            result = "$1A, "
        case "r":
            result = "$1B, "
        case "s":
            result = "$1C, "
        case "t":
            result = "$1D, "
        case "u":
            result = "$1E, "
        case "v":
            result = "$1F, "
        case "w":
            result = "$20, "
        case "x":
            result = "$21, "
        case "y":
            result = "$22, "
        case "z":
            result = "$23, "
        case ".":
            result = "$26, "
        case "-":
            result = "$58, "
        case _:
            result = "$FF, "

    return result
    
l = Label(text = "Enter Text ")
color_label = Label(text = "Select a Color")
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

color_list = ["Yellow", "Red", "Pink", "Dark Gray", "Dark Blue", "Pink (Duplicate)", "Cyan", "Light Gray", "Salmon", "Yellow/Green", "Mint", "Yellow (Duplicate)", "White", "Blue", "Red", "Green", "Brown"]
color_dropdown = ttk.Combobox(root, values=color_list)
color_dropdown.set(color_list[0])

l.pack()
inputtxt.pack(pady=5)
color_label.pack()
color_dropdown.pack(pady=5)
Display.pack(pady=5)
Output.pack(pady=5)

mainloop()