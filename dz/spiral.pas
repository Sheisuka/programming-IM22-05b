program Matrix;
var
    matr: array[1..4] of array[1..4] of integer;
    
    procedure fillRandom;
    var i, j: integer;
    begin
        randomize;
        for i := 1 to 4 do begin
            for j := 1 to 4 do begin
                matr[i, j] := Random(10);
            end;
        end;
    end;
    
    procedure printMatrix;
    var i, j: integer;
    begin
        for i:= 1 to 4 do begin
            for j := 1 to 4 do begin
                write(matr[i, j]:2);
            end;
            writeln;
        end;
        writeln;
    end;
    
    procedure printBySpiral;
    var 
        steps: integer = 1;
        i: integer = 1;
        j: integer = 1;
        iBeg: integer = 1; iFin: integer = 4; jBeg: integer = 1; jFin: integer = 4;
    begin
        while (steps < 4 * 4 + 1) do
            begin
                write(matr[i, j]:2);
                if ((i = ibeg) and (j < jFin)) then
                    j += 1
                else if ((j = jFin) and (i < iFin)) then
                    i += 1
                else if ((i = iFin) and (1 < j)) then
                    j -= 1
                else if ((j = jBeg) and (1 < i)) then
                    i -= 1;
                if ((i = iBeg + 1) and (j = Jbeg) and (j <> 4 - jFin)) then
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
    
    procedure sortBySpiral;
    begin
        
    end;
begin
    fillRandom;
    printMatrix;
    printBySpiral;
end.
