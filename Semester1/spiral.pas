program Matrix;
var
    matr: array[,] of integer;
    cols, rows: integer;
    elements: array of integer;
    
    procedure getDimension;
    begin
      writeln('Введите количество столбцов и строк');
      readln(cols, rows);
      setLength(matr, cols, rows);
      setLength(elements, cols * rows);
    end;
    
    procedure fillRandom;
    var
        element: integer;
        element_i: integer;
    begin
        randomize;
        for var i := 0 to cols - 1 do begin
            for var j := 0 to rows - 1 do begin
                element := Random(10);
                matr[i, j] := element;
                elements[element_i] := element;
                element_i += 1;
            end;
        end;
    end;
    
    procedure printMatrix;
    begin
        for var i:= 0 to cols - 1 do begin
            for var j := 0 to rows - 1 do begin
                write(matr[i, j]:3);
            end;
            writeln;
        end;
        writeln;
    end;
    
    procedure goSpiral(action: integer);
    var 
        steps: integer = 1;
        i: integer = 0;
        j: integer = 0;
        iBeg: integer = 0; iFin: integer = rows - 1; jBeg: integer = 0; jFin: integer = cols - 1;
    begin
        while (steps < rows * cols  + 1) do
            begin
                if (action = 1) then
                  write(matr[i, j]:3)
                else 
                    matr[i, j] := elements[steps - 1];
                if ((i = iBeg) and (j < jFin)) then
                    j += 1
                else if ((j = jFin) and (i < iFin)) then
                    i += 1
                else if ((i = iFin) and (jBeg < j)) then
                    j -= 1
                else if ((j = jBeg) and (iBeg + 1 < i)) then
                    i -= 1;
                if ((i - 1 = iBeg) and (j = Jbeg) and (j <> cols - jFin + 1)) then
                    begin
                    iBeg += 1;
                    jBeg += 1;
                    iFin -= 1;
                    jFin -= 1;
                    end;
                steps += 1;
            end;
        writeln;
    end;
    
    procedure sortElements;
    begin
        sort(elements);
    end;
begin
    getDimension; //  Получаем количество строк и столбцов
    fillRandom; // Заполняем случайными числами от 0 до 9
    printMatrix; // Выводим матрицу
    goSpiral(1); // Выводим матрицу по спирали
    sortElements; // Сортируем массив всех элементов
    goSpiral(2); // Сортируем матрицу по спирали
    printMatrix; // Выводим результат сортировки
end.
