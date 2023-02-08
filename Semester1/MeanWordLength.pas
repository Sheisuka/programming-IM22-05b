program meanWorldLen;
var
    file_: TextFile;
    s: string;
    totalWords, totalLen: integer;

type 
    lenArray= array of integer;
    
    
    function getWordsLength(s: string): lenArray;
    var
        tempWordI: integer := 0;
        tempWordLen: integer := 0;
        spaceCount: integer := 0;
        wordsLenArray: array of integer;
    begin
        for var i := 1 to Length(s) do
        begin
            if (s[i] = ' ') then
                spaceCount += 1;
        end;
        
        setLength(wordsLenArray, spaceCount + 1);
        
        writeln(s);
        
        for var i := 1 to Length(s) do
        begin
            if (s[i] <> ' ') then
                tempWordLen += 1
            else
                begin
                    wordsLenArray[tempWordI] := tempWordLen;
                    tempWordLen := 0;
                    tempWordI += 1;
                end;
            wordsLenArray[tempWordi] := tempWordLen;
        end;
        
        Result := wordsLenArray;
    end;
    
    function sumWords(mas: lenArray): integer;
    var count: integer;
    begin
      for var i := 0 to High(mas) do
        count += mas[i];
      Result := count;
    end;
    
begin
    AssignFile(file_, 'c:/randomtext.txt');
    Reset(file_);
    while not Eof(file_) do
    begin
      readln(file_, s);
      var mas: lenArray := getWordsLength(s);
      totalWords += sumWords(mas);
      totalLen += length(mas);
    end;
    writeln(#10 + 'Mean word length = ' + totalWords / totalLen);
end.