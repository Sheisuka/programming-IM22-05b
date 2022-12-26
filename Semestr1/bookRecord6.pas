program LibraryApp;
type
    BookRecord = record
        author: string;
        year_published: integer;
        title: string;
        genre: string; 
    end;
    Books = array of BookRecord;
    
    procedure addBook(var arr: Books);
    var n: integer;
    begin
        n := Length(arr);
        setLength(arr, n + 1);
        writeln('Введите автора книги');
        readln(arr[n].author);
        writeln('Введите год написания');
        readln(arr[n].year_published);
        writeln('Введите название');
        readln(arr[n].title);
        writeln('Введите жанр произведения');
        readln(arr[n].genre);
    end;
    
    
    procedure printBooks(arr: Books);
    begin
      if (Length(arr) = 0) then
          writeln('В списке ничего нет')
      else
      begin
          writeln('Автор':15, 'Название':15, 'Жанр':10, 'Год': 6);
          for var i := 0 to High(arr) do
          begin
              writeln(arr[i].author:15, ' ', arr[i].title:15, ' ', arr[i].genre:10, arr[i].year_published:6);
          end;
      end;
    end;
    
    
    procedure removeBook(var arr: Books);
    var needed_i: integer := -1; needed_title: string;
    begin
        writeln('Введите название книги, которую нужно удалить');
        readln(needed_title);
        for var i := 0 to High(arr) do
        begin
            if (arr[i].title = needed_title) then 
            begin
                needed_i := i;
                break;
            end;
        end;
        if (needed_i = -1) then 
            writeln('Книги с таким названием нет')
        else
        begin
            for var i := needed_i to High(arr) - 1 do
            begin
                arr[i] := arr[i + 1];
            end;
            setLength(arr, Length(arr) - 1);
        end;
    end;
    

var
    boooks: Books;
    a: integer;
begin
    repeat
        writeln('Введите номер нужной операции');
        writeln('0 - для завершения работы');
        writeln('1 - для добавления книги');
        writeln('2 - для удаления книги');
        writeln('3 - для вывода всех книг на экран');
        readln(a);
        if (a = 1) then addBook(boooks);
        if (a = 2) then removeBook(boooks);
        if (a = 3) then printBooks(boooks);
    until (a = 0);
end.
