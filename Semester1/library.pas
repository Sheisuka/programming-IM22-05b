program CreatingMyLibrary;

    // Обозначение переменных для тестов
    var 
        a: array[1..10] of integer = (1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
    type 
        someArray = array[1..10] of integer;
    
    
    // Считает длину произвольной
    function myLength(const stringMyLength: string): integer;
        var 
            i: integer = 1;
        begin
            while (True) do
            begin
                if (stringMyLength[i] <> char(0)) then begin
                    i += 1;
                    end
                else begin
                    Exit(i - 1);
                    end
            end;
        end;
        
    // Считает длину массива не содержащего нуль
    function myIntArrayLength(const arr: someArray): integer;
    var 
        i: integer = 1;
    begin
        while (True) do
            begin
                if (arr[i] <> 0) then begin
                    i += 1;
                    end
                else begin
                    Exit(i - 1);
                    end
            end;
        end;

    // Возвращает копию строки с i-того по j-тый индекс
    function myCopy(string_: string; from_, to_: integer): string;
        var 
            Result: string = '';
            i: integer;
        begin
            for i := from_ to to_ do begin
                Result += string_[i];
            end;
            myCopy := Result;
        end;

    
    // Возращает индекс первого вхождения подстроки в строку
    function myPos(const string_: string; const substring: string): integer;
        var
            i: integer;
        begin
            for i := 1 to myLength(string_) - myLength(substring) + 1 do begin
                writeln(myCopy(string_, i, i + myLength(substring) - 1));
                if (myCopy(string_, i, i + myLength(substring) - 1) = substring) then
                    Exit(i);
            end;
            Exit(0)
        end;

   { procedure myShuffle(arr: someArray);
    var
        len: integer;
    begin
        len := myIntArrayLength(arr);
        writeln(len);
    end;}

begin
    writeln(myLength('111'));
    writeln(myIntArrayLength(a));
end.