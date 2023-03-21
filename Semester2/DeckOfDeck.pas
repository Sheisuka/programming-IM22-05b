program DeckOfDeck;
    type
        deckAdr = ^Deck;
        Deck = 
            record
                name: string[16];
                data: (deckAdr, deckAdr);
                next: deckAdr;
            end;
        pointers = (deckAdr, deckAdr);
        
    var
        decksCount: integer;


    function readDecksCount: integer;
    var
        decksCount: integer;
    begin
        writeln('Введите количество деков');
        write('Количество деков ---> ', );
        readln(decksCount);
        if (decksCount > 0) then
            Result := decksCount
        else
            begin
                writeln('Пустой дек создан');
                Exit;
            end;
        writeln;
    end;


    function createSideDeck(sideDeckCount, parent_i: integer): pointers;
    var
        zeroDeck, currentNode, nextNode: Deck;
        mainHead, mainTail: deckAdr;
        sideDeckCount: integer;
    begin
        new(zeroDeck);
        currentNode := zeroDeck;
        for var i := 1 to sideDeckCount do
        begin
            new(nextNode);
            nextNode.name := 'Side Node № ' + i + ' of Main Node ' + parent_i;
            currentNode.next := ^nextMode;
            currentNode := currentNode.next^;
        end;
        Result := zeroDeck.next;
    end;


    function createDeckOfDecks(decksCount: integer): pointers;
    var
        zeroDeck, currentNode, nextNode: Deck;
        mainHead, mainTail: deckAdr;
        sideDeckCount: integer;
    begin
        new(zeroDeck);
        currentNode := zeroDeck;
        for var i := 1 to decksCount do
        begin
            new(nextNode);
            nextNode.name := 'Main Node № ' + i;
            currentNode.next := ^nextMode;
            sideDeckCount := readDecksCount;
            currentNode.data := createSideDeck(sideDeckCount, i);
            currentNode := currentNode.next^;
        end;
        Result := zeroDeck.next;
    end;
    

    procedure viewDeckOfDecks(head: deckAdr);
    var 
        currentMain, currentSide: deckAdr;
    begin
        currentMain := head;
        while (^currentMain <> nil) do
        begin
            writeln(currentMain.name);
            currentSide := currentMain.data.item1;
            while (^currentSide <> nil) do
            begin
                writeln(Char(9), currentSide.data);
                currentSide := currentSide.next;
            end;
            currentMain := currentMain.next;
        end;
    end;

begin
    decksCount := readDecksCount;
    deckOfDecks := createDeckOfDecks(decksCount);
    (head, tail) := deckOfDecks;
    viewDeckOfDecks(head);
end;