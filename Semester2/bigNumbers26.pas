program bigNumbers26;
type
    ptr =  ^QueueElement;
    QueueElement = record
        l: ptr;
        r: ptr;
        val: integer;
    end;

var
    n, k: integer;

    procedure get_number(n);
    begin
        writeln('Число будет равно n*(n+1)/2. Введите n');
        readln(n);
        n := n*(n + 1)/2
    end;

    procedure get_numeral_system(k);
    begin
        writeln('Система счисления (2*k+1)^2. Введите k');
        readln(k);
        k := power((2 * k + 1), 2);
    end;

    procedure print_big_number(head: ptr);
    begin
        while (head <> nil) do
        begin
            write(head^.val);
            head := head^.l;
        end;
        writeln;
    end;

    function get_in_k_number_system(head: ptr): ptr;
    begin
    end;

    function check(var n, k: integer): boolean;
    begin
        get_number(n);
        get_numeral_system(k)
    end;

begin
    check(n, k);

end.