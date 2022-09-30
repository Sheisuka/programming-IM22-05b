program SortMatrixByMean;
    var 
        matrix: array[,] of integer;
        cols, rows: integer;
        meanValues: array of real;
    
    procedure setDimension;
        begin
            writeln('Введите количество столбцов и строк матрицы');
            write('Размерность матрицы -  ');
            readln(cols, rows);
            setLength(matrix, cols, rows);
            setLength(meanValues, rows);
        end;
    
    procedure calculateMean;
        var mean: real;
        begin
          for var i := 0 to cols - 1 do
          begin
              mean := 0;
              for var j := 0 to rows - 1 do
              begin
                  mean += matrix[i, j];
              end;
              meanValues[i] := mean / rows;
          end;
        end;
      
    procedure fillMatrix;
    begin
        randomize;
        for var i := 0 to cols - 1 do
        begin
            for var j := 0 to rows - 1 do
            begin
                matrix[i, j] := Random(10);
            end;
        end;
    end;
    
    procedure printMatrix;
    begin
        writeln;
        for var i := 0 to cols - 1 do
        begin
            for var j := 0 to rows - 1 do
            begin
                write(matrix[i, j]:3);
            end;
            writeln;
        end;
    end;
    
    procedure swapRows(i, j: integer);
        var temp: integer;
    begin
        for var k := 0 to rows - 1 do
        begin
            temp := matrix[i, k];
            matrix[i, k] := matrix[j, k];
            matrix[j, k] := temp;
        end;
    end;
    
    procedure SortByMean;
        var tempMean: real;
    begin
        for var i := 0 to rows - 1 do
        begin
            for var j := 0 to rows - 2 do
            begin
                if (meanValues[j + 1] < meanValues[j]) then
                    begin
                        tempMean := meanValues[j + 1];
                        meanValues[j + 1] := meanValues[j];
                        meanValues[j] := tempMean;
                        swapRows(j, j + 1);
                    end;
            end;
        end;
    end;
    
    
begin
  setDimension;
  fillMatrix;
  printMatrix;
  calculateMean;
  writeln;
  writeln('Массив средних значений');
  println(meanValues);
  sortByMean;
  printMatrix;
  
end.