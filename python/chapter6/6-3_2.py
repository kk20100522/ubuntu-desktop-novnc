import tkinter

def click_bin():
    button["text"] = "クリックしました"

root = tkinter.Tk()
root.title("初めてのボタン")
root.geometry("800x600")
button = tkinter.Button(root,text="クリックしてください",font=("Times New Roman",24),command=click_bin)
button.place(x=200,y=100)
root.mainloop()