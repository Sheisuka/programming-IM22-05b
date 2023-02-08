Unit linal;


Interface
    type 
        matrix = array of array of real;
        arr = array of real;
    var C: matrix;

Function AddMatrixes(A, B: matrix): matrix;
Function SubsMatrixes(A, B: matrix): matrix;
Function MultMatrixes(A, B: matrix): matrix;
Function MultArrays(arr1, arr2: arr): arr;
{Function DivMatrixes(A, B: matrix): matrix;
Function DetMatrix(A: matrix): integer;}


Implementation
    
    Function __CheckLengthEquality__(A, B: matrix): boolean; Forward;
    Function __MakeErrorMatrix__: matrix; Forward;
    Function __GetMatrixMultElement__(row, col: integer; A, B: matrix): real; Forward;
    
    Function __AddMatrixes__(A, B: matrix; sign: integer ): matrix;
    begin
        if (__CheckLengthEquality__(A, B) = False) then 
            Result := __MakeErrorMatrix__
        else
            begin
                setLength(C, length(A));
                for var i := 0 to High(A) do
                begin
                    setLength(C[i], length(A[i]));
                    for var j := 0 to High(A[i]) do
                    begin
                        C[i, j] := A[i, j] + sign * B[i, j];          
                    end;
                end;
                Result := C;
            end;
    end;
    
    Function __MakeErrorMatrix__: matrix;
    var matr: matrix;
    begin
        setLength(matr, 1);
        setLength(matr[0], 1);
        matr[0, 0] := 0;
        Result := matr;
    end;
    
    
    Function __CheckLengthEquality__(A, B: matrix): boolean;
    var answer: boolean := True;
    begin
        if (length(A) <> length(B)) then answer := False;
        if (answer) then 
        begin
            for var i := 0 to High(A) do
            if (length(A[i]) <> length(B[i])) then 
            begin
                answer := False;
                break;
            end;
        end;
        Result := answer;
    end;
    
    
    Function AddMatrixes(A, B: matrix): matrix;
    begin
        C := __AddMatrixes__(A, B, 1);
        Result := C;
    end;
    
    Function SubsMatrixes(A, B: matrix): matrix;
    begin
        C := __AddMatrixes__(A, B, -1);
        Result := C;
    end;
    
    
    Function __GetMatrixMultElement__(row, col: integer; A, B: matrix): real;
    var element: real;
    begin
        for var i := 0 to High(A) do
        begin
            element += A[row, i] * B[i, col];
        end;
        Result := element;
    end;
    
    Function MultMatrixes(A, B: matrix): matrix;
    begin
        setLength(C, length(A));
        for var i := 0 to High(A) do
        begin
            setLength(C[i], length(B[i]));
            for var j := 0 to High(B[0]) do
            begin
                C[i, j] := __GetMatrixMultElement__(i, j, A, B);
            end;
        end;
        Result := C;
    end;
    
    Function MultArrays(arr1, arr2: arr): arr;
    var arr3: arr;
    begin
        for var i := 0 to High(arr1) do
            arr3[i] := arr1[i] * arr2[i];
        Result := arr3;
    end;    
End.
