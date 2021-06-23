import numpy as np


game_list = [['-','-','-'],['-','-','-'],['-','-','-']]
# Игровое поле с начальными значениями ячеек.


def out_game_field():
    """Функция выводит текушее состояние игрового поля."""
    
    print(f"""
    
       0  1  2
    0  {game_list[0][0]}  {game_list[0][1]}  {game_list[0][2]}
    1  {game_list[1][0]}  {game_list[1][1]}  {game_list[1][2]}
    2  {game_list[2][0]}  {game_list[2][1]}  {game_list[2][2]}""")


def input_gamer(game_list):
    """Функция обеспечивает выбор игроком ячейки, в которую ставится крестик.
    После ввода с клавиатуры координат ячейки проводится проверка,не была ли
    ранее эта ячейка занята. Итерации продолжаются до тех пор, пока ход 
    не будет сделан, то есть пока не изменится игровое поле"""
    
    control = game_list    
    while control == game_list:
        row = int(input("Введи номер строки от 0 до 2 - "))
        column = int(input("Введи номер столбца от 0 до 2 - "))
        if control[row][column] == '-':
            control[row][column] = 'X'
            break
        else:
            print("Это поле уже занято, выбери свободное поле.")    
    game_list = control
    
    
def input_comp(game_list):
    """Функция обеспечивает ход компьютера. Выпор поля проводится путем 
    случайного выбора номера строки и номера столбца до тех пор пока не будет 
    найдено первое свободное поле."""
    control = game_list
    while control == game_list:
        row = np.random.randint(0,3)
        column = np.random.randint(0,3)
        if control[row][column] == '-':
            control[row][column] = 'O'
            break
    game_list = control
    
    
def check_win():
    """Функция содержит список всех вариантов выигрышных сочетаний ячеек.
    Если появляется выигрыш, то возврашает - None, т.е. False.
    Если выигрыша нет, возврашает - True."""
    
    win_list = [[game_list[0][0],game_list[0][1],game_list[0][2]],
                [game_list[1][0],game_list[1][1],game_list[1][2]],
                [game_list[2][0],game_list[2][1],game_list[2][2]],
                [game_list[0][0],game_list[1][0],game_list[2][0]],
                [game_list[0][1],game_list[1][1],game_list[2][1]],
                [game_list[0][2],game_list[1][2],game_list[2][2]],
                [game_list[0][0],game_list[1][1],game_list[2][2]],
                [game_list[0][2],game_list[1][1],game_list[2][0]]
               ]
    if ['X','X','X'] in win_list:
        print("Вы выиграли.")
    elif ['O','O','O'] in win_list:
        print("Вы проиграли.")
    else:
        return True
    
    
def game_core():
    """Главная функция игры крестики - нолики. Поочередно предоставляет ход
    то игроку, то компьютеру, путем вызова соответствующих функций"""
    
    print("Вы играете крестиками, ваш ход первый.")
    count = 0
    while check_win():
        out_game_field()
        count += 1
        if count % 2 == 1:
            input_gamer(game_list)
            
        else:
            input_comp(game_list)
    out_game_field()
    
game_core()  # Запуск игры.
          