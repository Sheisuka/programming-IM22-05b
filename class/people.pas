program maxMeanHeight;
    type peopleDataArray = array of array of string;
    type arrayString = array of string;
    
    function getFile(): TextFile;
    var f: TextFile;
    begin
        AssignFile('c:/familytree.txt', f);
        Result := f;
    end;
    
    function splitString(str: string): arrayString;
    var 
        spacesCount: integer := 0;
        wordsArray : arrayString;
    begin
        for var i := 0 to Length(str) do
        begin
          if (str[i] = ' ') then
            
        end;
            
    end;
    
    function getPeople(file_: TextFile): peopleDataArray;
    var 
      people: peopleDataArray;
      str: string;
    begin
        reset(file_);
        while not Eof(file_) do
        begin
            readln(file_, str);
            
        end
    end;
begin
    
end.
