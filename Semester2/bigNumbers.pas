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
        write('Справа налево ');
        while (headl <> nil) do
        begin
            write(headl^.val);
            headl := headl^.l;
        end;
        writeln;
    end;
    
    procedure viewFLTR(headr: ptr);
    begin
        write('Слева направо - ');
        while (headr <> nil) do
        begin
            write(headr^.val);
            headr := headr^.r;
        end;
        writeln;
    end;
    
    procedure addNumbers(var first, second, resL, resR: ptr; l1, l2: integer);
    var
        diff, carry, mainL, subL: integer;
        mainN, subN, newCur: ptr;
    begin
        if (l1 >= l2) then
        begin
            mainN := first;
            mainL := l1;
            subL := l2;
            subN := second;
        end
        else
        begin
            mainN := second;
            mainL := l2;
            subL := l1;
            subN := first;
        end;
        
        new(resR);
        newCur := resR;
        while ((mainN <> nil) and (subN <> nil)) do
        begin
            new(resL);
            resL^.r := newCur;
            newCur^.val := (carry + mainN^.val + subN^.val) mod 10;
            carry := (carry + mainN^.val + subN^.val) div 10;
            newCur^.l := resL;
            newCur := resL;
            mainN := mainN^.l;
            subN := subN^.l;
        end;
        while (mainN <> nil) do
        begin
            new(resL);
            resL^.r := newCur;
            newCur^.val := (carry + mainN^.val) mod 10;
            carry := (carry + mainN^.val) div 10;
            newCur^.l := resL;
            newCur := resL;
            mainN := mainN^.l;
        end;
        if (carry <> 0) then
            resL^.val := carry
        else if (resL^.val = 0) then
        begin
            resL^.r^.l := nil;
            resL := resL^.r;
        end;
    end;

begin
    createDeck(hl1, hr1, l1);
    writeln('Длина данного числа составляет ', l1);
    viewFLTR(hl1);
    viewFRTL(hr1);
    createDeck(hl2, hr2, l2);
    writeln('Длина данного числа составляет ', l2);
    viewFLTR(hl2);
    viewFRTL(hr2);
    addNumbers(hr1, hr2, resL, resR, l1, l2);
    viewFLTR(resL);
    viewFRTL(resR);
end.