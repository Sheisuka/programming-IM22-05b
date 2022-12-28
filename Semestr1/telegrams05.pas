program telegrams;

var 
    newString, text: string;
    abbreviationsArray1: array[0..4] of string := ('ТЧК', 'ЗПТ', 'ВСКЛ', 'ВПР', 'ДВТЧ');
    abbreviationsArray2: array[0..4] of string := ('.', ',', '!', '?', ':');
type 
    strArray = array of string;
    
    function replaceAbbreviations(str: string): string;
    var
        abrOrigin, abrDest: string;
        position: integer;
    begin
        for var i := 0 to 4 do
        begin
            abrOrigin := abbreviationsArray1[i];
            abrDest := abbreviationsArray2[i];
            position := pos(abrOrigin, str);
            while (position <> 0) do
            begin
                delete(str, position, Length(abrOrigin));
                insert(abrDest, str, position);
                for var j := position - 1 downto 1 do
                begin
                    if (str[j] <> ' ') then
                    begin
                        delete(str, j + 1, position - j - 1);
                        break;
                    end;
                end;
                position := pos(abrOrigin, str);
            end;
        end;
        Result := str;
    end; 
    

begin
    writeln('Введите текст, который нужно изменить');  
    readln(text);
    writeln(replaceAbbreviations(text));
end.