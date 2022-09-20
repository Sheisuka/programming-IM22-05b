program Translit;
{$CODEPAGE CP866}
    const values: array[1..2] of array[1..33] of string = (
                                    ('a', 'b', 'v', 'g', 'd', 'e', 'e', 'zh', 'z', 'i', 'y',
                                    'k', 'l', 'm', 'n', 'o', 'p', 'r', 's', 't', 'u', 'f',
                                    'kh', 'ts', 'ch', 'sh', 'shch', 'y', '', 'ie', 'e', 'iu', 'ia'),
                                    
                                    ('а', 'б', 'в', 'г', 'д', 'е', 'ё', 'ж', 'з', 'и', 'й',
                                    'к', 'л', 'м', 'н', 'о', 'п', 'р', 'с', 'т', 'у', 'ф',
                                    'х', 'ц', 'ч', 'ш', 'щ', 'ы', 'ь', 'ъ', 'э', 'ю', 'я'));
                                    
            
        function findElement(const neededValue: string; index: integer): integer;
            var 
                k: integer = 1;
            begin
                for k := 1 to 33 do begin
                    if (values[index, k] = neededValue) then
                        Exit(k);
                end;
            end;
            
        function makeTransliteration(const who: integer; string_: string): string;
            var 
                transliteration: string;
                i: integer = 1;
            const stopWord = 'END';
            begin
                for i := 1 to length(string_) do begin
                    writeln(string_[i], '    ', findElement(string_[i], who));
                    transliteration += values[(who + 1), findElement(string_[i], who)];
                end;
                Exit(transliteration);
            end;
        
                                    
        
begin
    writeln(values[1, 7]);
    writeln(makeTransliteration(1, 'hui'));
end.