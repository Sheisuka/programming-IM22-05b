program ochko;

var 
    currentPlayer: integer; 
    player: integer = 0;
    bankPlayer: integer = 0;
    cards: array[1..36] of integer = (11, 11, 11, 11, 5, 5, 5, 5, 4, 4, 4, 4,
                                3, 3, 3, 3, 10, 10, 10, 10, 9, 9, 9, 9,
                                8, 8, 8, 8, 7, 7, 7, 7, 6, 6, 6, 6);
    
    
    function getRandomCard(): integer;
    var
        index, randomCard: integer;
    begin
        index := random(36);
        while (cards[index] = 0) do begin
            index := random(36);
        end;
        randomCard := cards[index];
        cards[index] := 0;
        Exit(randomCard);
    end;
    
    
    procedure getRandomPlayer();
    begin
        if (random(2) = 1) then
            currentPlayer := 1
        else 
            currentPlayer := 2;
        writeln('Первым карту получает игрок под номером ', currentPlayer);
    end;
    
begin
    randomize;
    writeln(getRandomCard);
    getRandomPlayer;
end.