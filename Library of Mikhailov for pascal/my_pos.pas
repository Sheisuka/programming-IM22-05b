program CreatingMyPos;
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
begin
end.