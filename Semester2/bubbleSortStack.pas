program myStack;
type
    pBlock = ^Block;
    Block = Record
        data: integer;
        adr: pBlock;
    end;
var
    head: pBlock;
    
    function createStack: pBlock;
    var
        head, pCurBlock: pBlock;
        blockCount: integer;
    begin
        write('Введите сколько блоков будет в стеке ---> ');
        readln(blockCount);
        for var i := 1 to blockCount do
        begin
            new(pCurBlock);
            write('Введите данные блока №', i, ' ---> ');
            readln(pCurBlock^.data);
            pCurBlock^.adr := head;
            head := pCurBlock;    
        end;
        Result := head;
    end;
    
    function lengthStack(head: pBlock; cur: integer): integer;
    begin
        if (head <> nil) then
            Result := lengthStack(head^.adr, cur + 1)
        else
            Result := cur;
    end;
    
    procedure viewStack(head: pBlock);
    begin
        if (head <> nil) then
        begin
            writeln('Блок со значением ', head^.data, ' имеет адрес ', head);
            viewStack(head^.adr);
        end;     
    end;
    
    procedure bubbleSortStack(var head: pBlock);
    var
        stackLength: integer := lengthStack(head, 0);
        pF, pS, pT, pPrev: pBlock;
        temp: Block;
    begin
        for var i := 0 to stackLength - 2 do 
        begin
            pPrev := nil;
            pF := head;
            pS := pF^.adr;
            pT := pS^.adr;
            
            if (pF^.data > pS^.data) then
                head := pS;
            
            for var j := 0 to stackLength - 2 do
            begin
                if (pF^.data > pS^.data) then
                begin
                    if (pPrev <> nil) then
                        pPrev^.adr := pS;
                    pS^.adr := pF;
                    pF^.adr := pT;
                end;
                pPrev := pS;
                pS := pT;
                if (pT <> nil) then
                    pT := pT^.adr;
                writeln;
                viewStack(head);
                writeln;
            end;
        end;
    end;
    
begin
    head := createStack;
    viewStack(head);
    writeln(lengthStack(head, 0));
    writeln;
    bubbleSortStack(head);
    viewStack(head);
end.