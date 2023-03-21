program queueeOfqueuee;
    type
        queueeAdr = ^queuee;
        pointers = 
            record
              head: queueeAdr;
              tail: queueeAdr;
            end;
        queuee = 
            record
                name: string[32];
                data: pointers;
                next: queueeAdr;
            end;
        
    var
        queueesCount: integer;
        queueeOfqueuees, edges: pointers;


    function readqueueesCount: integer;
    var
        queueesCount: integer;
    begin
        writeln('Введите количество деков');
        write('Количество деков ---> ');
        readln(queueesCount);
        if (queueesCount > 0) then
            Result := queueesCount
        else
            begin
                writeln('Пустой дек создан');
                Exit;
            end;
        writeln;
    end;


    function createSidequeuee(sidequeueeCount, parent_i: integer): pointers;
    var
        edges: pointers;
        pZeroqueuee, pNextNode, pCurrentNode: queueeAdr;
    begin
        new(pZeroqueuee);
        pCurrentNode := pZeroqueuee;
        for var i := 1 to sidequeueeCount do
        begin
            new(pNextNode);
            pNextNode^.name := 'Side Node № ' + i + ' of Main Node № ' + parent_i;
            pCurrentNode^.next := pNextNode;
            pCurrentNode := pCurrentNode^.next;
        end;
        edges.head := pZeroqueuee^.next;
        edges.tail := pCurrentNode;
        Result := edges;
    end;


    function createqueueeOfqueuees(queueesCount: integer): pointers;
    var
        pZeroqueuee, pNextNode, pCurrentNode: queueeAdr;
        sidequeueeCount: integer;
        edges: pointers;
    begin
        new(pZeroqueuee);
        pCurrentNode := pZeroqueuee;
        for var i := 1 to queueesCount do
        begin
            new(pNextNode);
            pNextNode^.name := 'Main Node № ' + i;
            sidequeueeCount := readqueueesCount;
            edges := createSidequeuee(sidequeueeCount, i);
            pNextNode^.data.head := edges.head;
            pNextNode^.data.tail := edges.tail;
            pCurrentNode^.next := pNextNode;
            pCurrentNode := pCurrentNode^.next;
        end;
        edges.head := pZeroqueuee^.next;
        edges.tail := pCurrentNode;
        Result := edges;
    end;
    

    procedure viewqueueeOfqueuees(head: queueeAdr);
    var 
        currentMain, currentSide: queueeAdr;
    begin
        currentMain := head;
        while (currentMain <> nil) do
        begin
            writeln(currentMain^.name);
            currentSide := currentMain^.data.head;
            while (currentSide <> nil) do
            begin
                writeln('----- ' , currentSide^.name);
                currentSide := currentSide^.next;
            end;
            currentMain := currentMain^.next;
        end;
        writeln;
    end;
    
    function empty(head: queueeAdr): boolean;
    begin
        Result := (head = nil);
    end;
    
    procedure pop(var head: queueeAdr);
    var
        newHead: queueeAdr;
    begin
        newHead := head^.next;
        dispose(head);
        head := newHead;
    end;  
    
    procedure push(var tail: queueeAdr);
    var
        newTail: queueeAdr;
    begin
        new(newTail);
        newTail^.name := 'Это какой то новый блок';
        tail^.next := newTail;
        tail := newTail;
    end;

begin
    queueesCount := readqueueesCount;
    queueeOfqueuees := createqueueeOfqueuees(queueesCount);
    edges := queueeOfqueuees; 
    viewqueueeOfqueuees(edges.head);
    pop(edges.head);
    viewQueueeOfQueuees(edges.head);
    push(edges.tail);
    viewQueueeOfQueuees(edges.head);
end.