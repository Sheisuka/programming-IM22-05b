program Translit;
    var
        goStr: string;
    const values: array[1..2] of array[1..33] of string = (
                                    ('a', 'b', 'v', 'g', 'd', 'e', 'e', 'zh', 'z', 'i', 'y',
                                    'k', 'l', 'm', 'n', 'o', 'p', 'r', 's', 't', 'u', 'f',
                                    'kh', 'ts', 'ch', 'sh', 'shch', 'y', '', 'ie', 'e', 'iu', 'ia'),
                                    
                                    ('а', 'б', 'в', 'г', 'д', 'е', 'ё', 'ж', 'з', 'и', 'й',
                                    'к', 'л', 'м', 'н', 'о', 'п', 'р', 'с', 'т', 'у', 'ф',
                                    'х', 'ц', 'ч', 'ш', 'щ', 'ы', 'ь', 'ъ', 'э', 'ю', 'я'));
        
        function multiplyString(str: string; number: integer): string;
        var 
          res: string := '';
        begin
          loop number do
          begin
            res += str;
          end;
          multiplyString := res;
          Exit;
        end;
                                    
            
        function findElement(const neededValue: string; index: integer): integer;
          var i: integer;
          begin
            for i := 1 to 33 do
            begin
              if (values[index, i] = neededValue) then
                begin
                findElement := i;
                Exit;
                end;
            end;
          end;
         
         function getString(whoIndex: integer): string;
          var answer: string;
          begin
            if (whoIndex = 1) then
              writeln('Введите строку, которую нужно перевести, кириллицей')
            else 
              writeln('Vvedite stroku, kotoruyu nuzhno perevesti, latinitsey');
            readln(answer);
            getString := answer;
            Exit;
          end;
          
        function getDirection(): integer;
          var answer: string;
          begin
            writeln('Введите направление перевода, кл - кириллица -> латиница, лк - латиница -> кириллица');
            writeln('Vvedite napravlenie perevoda, kl - kirillitsa -> latinitsa, lk - latinitsa -> kirillitsa');
            readln(answer);
            if (pos('кл', answer) > 0 or pos('kl', answer)) then
              getDirection := 1
            else
              getDirection := 2;
          end;
        
        function makeTranslation(const str: string; whoIndex: integer): string;
          var 
          i: integer;
          res, subString, str_: string;
        begin
          str_ := str;
          case whoIndex of
            1:
              begin
                  for i := 1 to length(str_) do
                      begin
                          res += values[whoIndex, findElement(str_[i], whoIndex + 1)];
                      end;
                  makeTranslation := res;
                  Exit;
              end;
            2:
              begin
                i := 1;
                while (i - 1< length(str)) do
                  begin
                    for var k: integer := 3 downto 0 do
                      begin
                        if (i + k <= length(str)) then begin
                          subString := str[i: i + k + 1];
                          if (findElement(subString, 1) > 0) then
                            begin
                              res += values[2, findElement(subString, 1)];
                              i += k;
                              break;
                              end;
                          end;
                      end;
                      i += 1;
                  end;
                  makeTranslation := res;
                  Exit;
              end;
          end;
        end;
        
                                    
        
begin
  repeat
  var dirToConvert: integer := getDirection;
  var stringToConvert: string := getString(dirToConvert);
  writeln(makeTranslation(stringToConvert, dirToConvert));
  writeln('Хотите повторить? y/n');
  writeln('Hotite povtorit? y/n');
  readln(goStr);
  until (goStr = 'n');
end.