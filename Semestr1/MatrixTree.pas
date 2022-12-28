<<<<<<< HEAD
﻿program MatrixTree;
=======
program MatrixTree;
>>>>>>> 023564e2770bdf11b12184f9cba45dfda9f09714
    var
    matrix_new: array[1..50, 1..50] of string;
    k, i, dimension:integer;
    matrix_element, spaces, quaters: string;
    
    
    // Процедура для задания размерности матрицы
    procedure initialize_dimension;
        begin
            writeln('Введите четное число > 5 - размерность матрицы');
            readln(dimension);
            writeln('Размерность матрицы - ', dimension)
        end;
    
    
    // Процедура для получения четвертей
    // 1 четверть - верхняя, 2 - левая, 3 - нижняя, 4 - правая
    procedure choose_quaters;
        begin
            writeln('Введите четверти для вывода');
            writeln('1 четверть - верхняя, 2 - левая, 3 - нижняя, 4 - правая, 1234 - все');
            readln(quaters);
        end;
    
    // Процедура для заполнения всей матрицы
    procedure fill_matrix;
        begin
        randomize;
            // Проверяем запрошены ли четверти с нулями. Если нет - вместо нулей
            // Добавляем в массив пустые строки
<<<<<<< HEAD
            for var k := 1 to dimension do
                begin
                    for var i := 1 to dimension do
=======
            for k := 1 to dimension do
                begin
                    for i := 1 to dimension do
>>>>>>> 023564e2770bdf11b12184f9cba45dfda9f09714
                        begin
                            matrix_element := '   ';
                            if (i <= (dimension / 2) - 1) and (pos('2', quaters) > 0)
                                then matrix_element := '  0';
                            if (i > (dimension / 2) + 1) and (pos('4', quaters) > 0)
                                then matrix_element := '  0';
                            matrix_new[k][i] := matrix_element;
                        end;
                end;
            // Проверяем запрошены ли четверти с положительными числами. Если нет - вместо них
            // Добавляем в массив пустые строки
<<<<<<< HEAD
            for var k := 1 to round(dimension / 2) do
                begin
                    for var i := 0 + k to dimension + 1 - k do
=======
            for k := 1 to round(dimension / 2) do
                begin
                    for i := 0 + k to dimension + 1 - k do
>>>>>>> 023564e2770bdf11b12184f9cba45dfda9f09714
                        begin
                            if pos('1', quaters) > 0 then
                                Str((random(9) + 1), matrix_element)
                            else
                                matrix_element := ' ';
                            spaces := '  ';
                                
                            matrix_new[k][i] := spaces + matrix_element;
                        end;
                end;
            // Проверяем запрошены ли четверти с отрицателными числами. Если нет - вместо них
            // Добавляем в массив пустые строки
<<<<<<< HEAD
            for var k := round(dimension / 2) + 1 to dimension do
                begin
                    for var i := dimension - k + 1 to k do
=======
            for k := round(dimension / 2) + 1 to dimension do
                begin
                    for i := dimension - k + 1 to k do
>>>>>>> 023564e2770bdf11b12184f9cba45dfda9f09714
                        begin
                        if pos('3', quaters) > 0 then
                                Str(-(random(9) + 1), matrix_element)
                            else
                                matrix_element := '  ';
                                spaces := ' ';
                            matrix_new[k][i] := spaces + matrix_element;
                        end;
                end;
        end;
    
    
    // Процедура для вывода всей матрицы
    procedure print_matrix;
        begin
<<<<<<< HEAD
            for var k := 1 to dimension do
                begin
                    for var i := 1 to dimension do
=======
            for k := 1 to dimension do
                begin
                    for i := 1 to dimension do
>>>>>>> 023564e2770bdf11b12184f9cba45dfda9f09714
                        begin
                            write(matrix_new[k, i]);
                        end;
                    writeln;
                end;
        end;
    
begin
    initialize_dimension;
    choose_quaters;
    fill_matrix;
    print_matrix;

end.
