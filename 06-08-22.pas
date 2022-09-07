program Hello;
    var
    i, j, dimension: integer;
    matrix_new, zeros, plus, minus: array[1..2,1..2] of integer;
    
    procedure initialize_dimension;
    begin
        writeln('Введите размерность матрицы');
        readln(dimension);
        writeln('Размерность матрицы - ', dimension)
    end;
    
    procedure create_numbers;
    begin
        randomize;
        for var k: integer := 1 to dimension * dimension * 0.5 do begin
            zeros[k] := 0;
        end;
        for var k: integer := 1 to dimension * dimension * 0.25 do begin
            plus[k] := random(1, dimension);
        end;
        for var k: integer := 1 to dimension * dimension * 0.5 do begin
            minus[k] := random(-dimension, -1);
        end;
    end;
    
begin
    initialize_dimension;
    matrix_new[3][3] := 120;
    writeln(matrix_new[3][3]);
end.
