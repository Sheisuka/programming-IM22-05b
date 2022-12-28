program chessField;
var field: array[1..8, 1..8] of integer := (
                                (0, 0, 0, 0, 0, 0, 0, 0), 
                                (0, 0, 0, 0, 0, 0, 0, 0),
                                (0, 0, 0, 0, 0, 0, 0, 0), 
                                (0, 0, 0, 0, 0, 0, 0, 0),
                                (0, 0, 0, 0, 0, 0, 0, 0), 
                                (0, 0, 0, 0, 0, 0, 0, 0),
                                (0, 0, 0, 0, 0, 0, 0, 0), 
                                (0, 0, 0, 0, 0, 0, 0, 0));
    knight_x, kngiht_y: integer;

    procedure printMatrix;
    begin
      writeln;
      for var i := 1 to High(field) do
      begin
          for var j := 1 to High(field[i]) do
          begin
              write(field[i, j]:2);
          end;
          writeln;
      end;
    end;
    
    
    procedure walk(x, y: integer);
    begin
        field[y, x] := 1;
        writeln(y, ' ', x);
        if (x + 2 <= 8) then
            begin
                if (y - 1 >= 1) then
                    if (field[y - 1, x + 2] = 0) then
                        walk(x + 2, y - 1);
                if (y + 1 <= 8) then
                    if (field[y + 1, x + 2] = 0) then
                        walk(x + 2, y + 1);
            end;
        if (x - 2 >= 1) then
            begin
                if (y - 1 >= 1) then
                    if (field[y - 1, x - 2] = 0) then
                        walk(x - 2, y - 1);
                if (y + 1 <= 8) then
                    if (field[y + 1, x - 2] = 0) then
                        walk(x - 2, y + 1);
            end;
        if (y + 2 <= 8) then
            begin
                if (x - 1 >= 1) then
                  if (field[y + 2, x - 1] = 0) then
                        walk(x - 1, y + 2);
                if (x + 1 <= 8) then
                    if (field[y + 1, x + 1] = 0) then
                        walk(x + 1, y + 2);
            end;
        if (y -  2 >= 1) then
            begin
                if (x - 1 >= 1) then
                    if (field[y - 2, x - 1] = 0) then
                        walk(x - 1, y - 2);
                if (x + 1 <= 8) then
                    if (field[y - 2, x + 1] = 0) then
                        walk(x + 2, y - 1);
            end;     
    end;

begin
    printMatrix;
    writeln('Введите исходные координаты x y');
    readln(knight_x, kngiht_y);
    walk(knight_x, kngiht_y);
    printMatrix;
end.
