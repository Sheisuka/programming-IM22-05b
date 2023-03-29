program bigNumbers;
type
    ptr = ^Element;
    Element = record
        val: integer;
        l: ptr;
        r: ptr;
    end;

var
    hl1, hr1, hl2, hr2: ptr; 

    procedure createDeck(var headl, headr: ptr);
    var
        number: integer;
        cur, dummy: ptr;
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
            number := number div 10
            cur^.l := lhead;
            cur := lhead;
        end;
        cur^.l^.r := nil;
        headl := cur^.l;
        headr := rhead;
    end;

    procedure viewFLTR(headl: ptr);
    begin
        while (headl <> nil) do
        begin
            write(headl^.val);
            headl := headl^.r;
        end;
    end;

begin
    createDeck(hl1, hr1);
    viewFLTR(hl1);
    
end;