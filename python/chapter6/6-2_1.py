import tkinter
root = tkinter.Tk()
root.title("初め")
root.geometry("400x200")
label = tkinter.Label(root,text="ラベルの文字列")
font=("System",24)
label.place(x=200,y=100)
root.mainloop()