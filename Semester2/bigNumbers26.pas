program bigNumber26;
    type
        bigNP = bigN^;
        bigN = record
            val: integer;
            r: bigNP;
            l: bigNP;
        end; 
    var
        ln, rn, lnk, rnk: bigNP;
        k: integer;

    procedure get_big_n(var lh, rh: bigNP);
    var
        num: integer;
        lhead, rhead, dummy, prev: bigNP;
    begin
        new(dummy);
        prev := dummy;
        writeln('Вводите число поциферно справа налево, -1 если захотите закончить');
        while (num <> -1) do
        begin
            writeln('---> ');
            read(num);
            if ((num >= 0) and (num <= 9)) then
            begin
                new(lhead);
                prev^.l := lhead;
                lhead^.r := prev;
                lhead^.val := num;
                prev := lhead;
            end;
        end;
        lh := lhead;
        rh := dummy^.l;     
    end;

    procedure view_big_n(lh: bigNP);
    begin
        while (lh <> nil) do
        begin
            write(lh^.val);
            lh := lh^.r;
        end;
    end;

begin
    writeln('Введите число n');
    get_big_n(ln, rn);
    view_big_n(ln);
    writeln('Введите число k');
    readln(k);
end.