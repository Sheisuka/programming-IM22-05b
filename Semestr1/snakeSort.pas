program sortSmth;
var
    matrix: array of array of  integer;
    
    procedure getDimensionAndFill;
      var cols, rows: integer;
    begin
      rows := Random(4, 16);
      writeln('Количество строк - ', rows);
      setLength(matrix, rows);
      for var i := 0 to High(matrix) do
      begin
          cols := Random(4, 16);
          writeln('В строке ', i + 1, ' ', cols, ' элементов');
          setLength(matrix[i], cols);
          for var j := 0 to High(matrix[i]) do
              matrix[i, j] := Random(0, 9);
      end;
    end;
    
    procedure printMatrix;
    begin
        writeln;
        for var i:= 0 to High(matrix) do begin
            for var j := 0 to High(matrix[i]) do begin
                write(matrix[i, j]:2);
            end;
            writeln;
        end;
        writeln;
    end;
    
    procedure reverseRow;
    var 
        temp: integer;
        direction: integer := 1;
    begin
        for var i := 0 to High(matrix) do
        begin
            for var j := 0 to trunc(High(matrix[i]) / 2) do
            begin
                if (direction = -1) then
                begin
                    temp := matrix[i, j];
                    matrix[i, j] := matrix[i, High(matrix[i]) - j];
                    matrix[i, High(matrix[i]) - j] := temp
                end;
            end;
            direction *= -1;
        end;
    end;
begin
    getDimensionAndFill;
    printMatrix;
    reverseRow;
    printMatrix;
end.