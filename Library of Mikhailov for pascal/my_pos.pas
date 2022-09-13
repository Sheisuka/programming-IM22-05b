program CreatingMyPos;
    function myLength(string_: string): integer;
        var 
            i: integer = 1;
            symbol: string;
        begin
            while (True) do
            begin
                symbol := string_[i];
                if (symbol <> char(0)) then begin
                    i += 1;
                    end
                else begin
                    myLength := i - 1;
                    Exit;
                    end
            end;
        end;

    
    function myCopy(string_: string; from_, to_: integer): string;
        var 
            Result: string;
            i: integer;
        begin
            for i := from_ to to_ do begin
                Result += string_[i];
            end;
            myCopy := Result;
        end;


    function myPos(string_, substring: string; p: integer): integer;
        begin
            if (myLength(string_) < myLength(substring)) then begin
                myPos := 0;
            end
            else if (string_ = substring) then begin
                myPos := p;
                Exit;
                end
            else begin
                myPos := myPos(myCopy(string_, 2, myLength(string_)), substring, p + 1);
                end
        end;
begin
    writeln(myPos('222111', '111', 1));
end.