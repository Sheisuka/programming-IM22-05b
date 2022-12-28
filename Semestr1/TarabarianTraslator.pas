program Tarabarian;


var
    answer: string := 'continue';
    sentence, language, symb: string;
    vowels: string := 'ёуеыаоэяию';
    symbols: string := '-.,/\:; !@#$%^&*()_+=-?%';
  
  
    function getWord(): string;
        var word: string;
    begin
        writeln('Введите слово');
        readln(word);
        getWord := word;
    end;
    
    
    function transformToTarabarian(word, symb: string): string;
        var answer: string;
    begin
        for var i := 1 to length(word) do
        begin
            if (pos(word[i], vowels) = 0) or (pos(word[i], symbols) <> 0) then
                begin
                    answer += word[i];
                end
            else
                answer += word[i] + symb + word[i];
        end;
        transformToTarabarian := answer;
    end;
    
    
    function transformToRussian(word, symb: string): string;
        var answer: string;
    begin
        answer := word[1:3];
        for var i := 3 to length(word)  do
        begin
            if (pos(word[i], vowels) = 0) then
                begin
                    if (word[i] = symb) then
                        begin
                            if (word[i - 1] <> word[i + 1]) then
                                begin
                                    answer += word[i];
                                    continue;
                                end;
                        end
                    else
                        begin
                            answer += word[i];
                            continue;
                        end;
                end
            else if ((word[i] <> word[i - 2]) or ((word[i + 1] = symb) and (word[i + 2] = word[i]))) then
                answer += word[i];
        end;
        transformToRussian := answer;
    end;
    
    
    function defineType(word: string): string;
    var 
        answer: string;
    begin
        for var i := 1 to length(word) - 2 do
        begin
            if ((pos(word[i], vowels) = 0) or (pos(word[i], symbols) <> 0)) then
                continue;
            if (word[i] = word[i + 2]) then
                begin
                    answer := 'tarabarian' + word[i + 1];
                    defineType := answer;
                    Exit;
                end
            else
                defineType := 'russian';
                Exit;
        end;
    end;
  
begin
    repeat
        sentence := getWord;
        language := defineType(sentence);
        writeln(language);
        if (pos('tarabarian', language) > 0) then
            begin
              symb := language[length(language)];
              writeln(transformToRussian(sentence, symb));
            end
        else
            begin
                writeln('Введите разделяющий символ');
                readln(symb);
                writeln(transformToTarabarian(sentence, symb));
            end;
        writeln('Введите stop если хотите окончить, иначе - нажмите enter');
        readln(answer);
    until (answer = 'stop');
end.