program myQueue;
type
    pBlock = ^Block;
    Block = Record
        data: integer;
        nxt: pBlock;
    end; 
var
    head, tail: pBlock;
    n, flag: integer;
    
    procedure createQueue(n: integer; var head, tail: pBlock);
    var
        currentBlock: Block;
        pCurrentBlock, pPrev: pBlock;
    begin
        new(pCurrentBlock);
        write('Введите данные блока(число) №0 ---> ');
        readln(pCurrentBlock^.data);
        pCurrentBlock^.nxt := nil;
        writeln(pCurrentBlock);
        head := pCurrentBlock;
        tail := pCurrentBlock;
        pPrev := pCurrentBlock;
        for var i := 1 to n - 1 do 
        begin
            new(pCurrentBlock);
            write('Введите данные блока(число) №', i, ' ---> ');
            readln(pCurrentBlock^.data);
            pCurrentBlock^.nxt := nil;
            writeln(pCurrentBlock);
            pPrev^.nxt := pCurrentBlock;
            tail := pCurrentBlock;
            pPrev := pCurrentBlock;
        end;
        writeln;
    end;
    
    procedure viewQueue(head: pBlock);
    begin
        if (head <> nil) then
        begin
            writeln(head^.data, ' ', head);
            viewQueue(head^.nxt);
        end; 
    end;
    
    procedure addBlock(tail: pBlock);
    var
        pBlockNew: pBlock;
        data: integer;
    begin
        new(pBlockNew);
        writeln('Введите данные для нового блока');
        readln(pBlockNew^.data);
        pBlockNew^.nxt := nil;
        tail^.nxt := pBlockNew;
        tail := pBlockNew;
    end;
    
    procedure deleteFirst(var head: pBlock);
    var
        newHead: pBlock;
    begin
        newHead := head^.nxt;
        dispose(head);
        head := newHead;
    end;
        
begin
    write('Введите количество элементов очереди ---> ');
    readln(n);
    writeln;
    if (n <> 0) then
    begin
        new(head);
        new(tail);
        createQueue(n, head, tail);
        while (flag <> -1) do
        begin
            writeln('-1 - Закончить');
            writeln('0 - Добавить новый элемент');
            writeln('1 - Посмотреть очередь с начала до конца');
            writeln('2 - Удалить первый элемент');
            writeln;
            write('Введите номер команды ---> ');
            readln(flag);
            writeln;
            case flag of 
                -1: 
                    Exit;
                0: 
                    addBlock(tail);
                1: 
                    begin
                        viewQueue(head);
                        writeln;
                    end;
                2:
                    deleteFirst(head);
            end;
        end;
    end
    else
        writeln('Очередь пустая');
end.