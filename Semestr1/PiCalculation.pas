program PiProgram;

// Объявленине переменных
var 
    answer: char;
    method: integer;
    pi: real;


    function Buffon(): real;
    var 
        l, yMid, dist1, pi, h, Xmid, m, dist2: real;
        x0: real := 0;
        y0: real := 0;
        count, degrees, hitCount, method: integer;
    begin
        writeln('Введите l - длину иголки и h - расстояние между полосками; l < h; 2 * l > h ');
        read(l, h);
        writeln('Введите длину стороны ');
        read(m);
    
        repeat
            writeln('Введите количество бросков иголки');
            readln(count);
            hitCount := 0;
            for var i := 1 to count do
                begin
                    xMid := Random(m);
                    yMid := Random(m);
                    degrees := Random(91);
                    dist1 := Min(abs(yMid - h * trunc(yMid / h)), abs(yMid - h * round(yMid / h)));
                    //writeln(dist1, ' ', yMid);
                    if (dist1 < abs((l / 2) * cos(2 * 3.14159 * degrees / 360))) then
                        hitCount += 1;
                end;
            pi := (2 * l * count) / (hitCount * h);
            writeln('Пи = ', pi);
            writeln('Хотите повторить с другим количеством бросков? Y/N');
            read(answer);
        until (answer = 'N');
        Buffon := pi;
    end;
    
    function Leibniz(): real;
    var
        denominator: integer := 1;
        numerator: integer := 4;
        pi: real;
        count: integer;
        sign: integer := 1;
    begin
      writeln('Введите необходимую точность');
      read(count);
      for var i := 1 to count do
      begin
        pi += numerator / denominator * sign;
        denominator += 2;
        sign := sign * (-1);
      end;
      Leibniz := pi;
    end;
    
    function Wallis(): real;
    var
        pi: real := 1;
        denominator: integer := 1;
        numerator: integer := 2;
        count: integer;
    begin
      writeln('Введите необходимую точность');
      read(count);
      for var i := 1 to count do
      begin
        //writeln(numerator, ' / ', denominator, ' ', numerator, ' / ', denominator + 2);
          pi := pi * (numerator / denominator);
          pi := pi * (numerator / (denominator + 2));
          numerator += 2;
          denominator += 2;
      end;
        Wallis := pi * 2;
    end;
    
begin
    randomize;
    writeln('Выберите метод');
    read(method);
    case method of
        1: 
            begin
                writeln(Buffon());
            end;
        2:  
            begin
                writeln(Leibniz());
            end;
        3:
            begin
                writeln(Wallis());
            end;
        end;
end.