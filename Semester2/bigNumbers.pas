program bigNumbers;
type
    ptr = ^Element;
    Element = record
        val: integer;
        l: ptr;
        r: ptr;
    end;

var
    hl1, hr1, hl2, hr2, resL, resR: ptr; 
    l1, l2: integer;

    procedure createDeck(var headl, headr: ptr; var len: integer);
    var
        number: integer;
        cur, rhead, lhead: ptr;
    begin
        write('Введите число ---> ');
        readln(number);
        new(rhead);
        cur := rhead;
        while (number > 0) do
        begin
            new(lhead);
            lhead^.r := cur;
            cur^.val := number mod 10;
            number := number div 10;
            cur^.l := lhead;
            cur := lhead;
            len += 1;
        end;
        cur^.r^.l := nil;
        headl := cur^.r;
        headr := rhead;
    end;

    procedure viewFRTL(headl: ptr);
    begin
        while (headl <> nil) do
        begin
            write(headl^.val);
            headl := headl^.l;
        end;
        writeln;
    end;
    
    procedure viewFLTR(headr: ptr);
    begin
        while (headr <> nil) do
        begin
            write(headr^.val);
            headr := headr^.r;
        end;
        writeln;
    end;
    
    {procedure addNumbers(first, second, resL, resR: ptr);
    var
        
    begin
      
    end;}

begin
    createDeck(hl1, hr1, l1);
    writeln('Длина данного числа составляет ', l1);
    viewFLTR(hl1);
    viewFRTL(hr1);
    createDeck(hl2, hr2, l2);
    writeln('Длина данного числа составляет ', l2);
    viewFLTR(hl2);
    viewFRTL(hr2);
    //addNumbers(hr1, hr2, resL, resR);
end.