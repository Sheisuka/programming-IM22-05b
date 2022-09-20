program Buffon;

// Объявленине переменных
var 
    l, x1, y1, x2, y2, x3, y3, yMid, dist, pi: real;
    x0: real = 0;
    y0: real = 0;
    answer: char;
    count, xMid, degrees, h, hitCount, i, m, method: integer;


// Метод Бюффона
    function Buffon(): real;
    begin
        x1 := x0;
        y1 := m;
        x2 := m;
        y2 := m;
        x3 := m;
        y3 := y0;
    
        repeat
            writeln('Введите количество бросков иголки');
            read(count);
            hitCount := 0;
            for i := 1 to count do
                begin
                    xMid := Random(m + 1);
                    yMid := Random(m + 1);
                    degrees := Random(180);
                    dist := (yMid / h) - trunc(yMid / h);
                    if (dist < (l / 2) * cos(2 * 3.14 * degrees / 360)) then
                        hitCount += 1;
                end;
            pi := (2 * l * count) / (hitCount * h);
            writeln('Пи = ', pi);
            writeln('Хотите повторить с другим количеством бросков? Y/N');
            read(answer);
        until (answer = 'N');
        Exit(pi);
    end;
begin
    randomize;
    writeln('Введите l - длину иголки и h - расстояние между полосками; l < h ');
    read(l, h);
    writeln('Введите длину стороны ');
    read(m);
    writeln('Выберите метод');
    read(method);
    case method of
        1: 
            begin
                writeln(Buffon());
            end;
        2:  
            begin
                writeln('2');
            end;
        else
            writeln('3');
        end;
end.