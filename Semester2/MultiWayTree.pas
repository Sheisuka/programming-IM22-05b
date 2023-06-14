{
    Музыкальный каталог, но дополнительно, размещаться могут не только папки, но и файлы  с некоторым 
        расширением, например, с расширением  .mp3 (расширение указывать обязательно
        иначе это будет считаться папкой). При этом наследование от такого 
        файла (в отличие от папки) невозможно. + дополнительно, от себя, добавил вес файла в байтах, подсчет веса каталога в удобночитаемом формате
        также имеется "сортировка" - в каталоге всегда сначала идут подкаталоги, файлы - в самом конце}

program Catalog;

type
  PElem = ^TElem;

  TElem = record
      name: string; // Имя элемента
      nextbr: PElem; // Ссылка на брата
      upchild: PElem; // Ссылка на ребенка
      ext: string; // Расширение элемента
      wBytes: integer; // Вес элемента в байтах
  end;
  
    function myPower(x, y: integer): integer; // Степень для integer
    var
        res: integer;
    begin
        for var i := 1 to y do
            res += x;
        Result := res;
    end;
  
    function IsFile(Tree: PElem): boolean; // Проверка является ли элемент файлом
    begin
      if (Tree = nil) then
          Result := False
      else
          Result := (Tree^.ext <> '');
    end;
    
    function _getWeight(tree: PElem): integer;
    begin
        if tree <> nil then
        begin
            if isFile(tree) then
                Result := tree^.wBytes
            else
            begin
                Result += _getWeight(tree^.upchild);
                Result += _getWeight(tree^.nextbr);
            end;
        end;
    end;
    
    function getWeight(tree: PElem): string;
    var
        weight, carry, power: integer;
        counter := 1;
        ans, wS: string;
        weights: array[1..4] of string = ('Б', 'Кб', 'Мб', 'Гб');
    begin
        weight := _getWeight(tree^.upchild) + tree^.wBytes;
        while (weight > 0) do
        begin
            carry := weight mod myPower(1024, counter);
            str(carry, wS);
            ans :=  wS + weights[counter] + ' ' + ans;
            weight := weight div MyPower(1024, counter);
            counter += 1;
        end;
        if ans <> '' then
            Result := ans
        else
            Result := 'нулевой';
    end;
    
    procedure _ViewTree (Tree: PElem; indent: integer);
    begin
     if (Tree <> nil) then
     begin
       if IsFile(tree) then
           writeln (' ':indent, tree^.name, '.', tree^.ext, ' Объем ', getWeight(tree))
       else
           writeln (' ':indent, tree^.name, ' Объем ', getWeight(tree));
       _ViewTree (tree^.upchild, indent + 5);
       _ViewTree (tree^.nextbr, indent);
     end;
    end;
    
    procedure ViewTree (Tree: PElem);
    begin
     if (Tree <> nil) then
        _viewTree(Tree, 3)
     else
        writeln('Дерево уже пусто');
    end;
    
    //Нахождение адреса папки, от которой наследование при добавлении  
    procedure FindElem(Tree: PElem; name: string; var ResultItem: PElem);
    begin
    ResultItem := nil;
    if Tree <> nil then
      if (Tree^.name = name) or ((Tree^.name + '.' + Tree^.ext) = name) then // Если совпадает с расширением либо каталогом
          ResultItem := Tree
        else
          begin
            //иначе поиск в братьях
            FindElem(Tree^.nextbr, name, ResultItem);
            if (ResultItem = nil) and not IsFile(Tree^.upchild) then // если просмотрели всех братьев, то ищем в детях, если ребенок не файл
                FindElem(Tree^.upchild, name, ResultItem);
          end;
    end;
  
    procedure CreateCat(var Tree: PElem; name: string); // Создание каталога
    begin
        new(Tree);
        Tree^.name := name;
        Tree^.nextbr := nil;
        Tree^.upchild := nil;
        Tree^.wBytes := 0;
        Tree^.ext := '';
    end;
  
    procedure CreateFile(var Tree: PElem; name, ext: string; weight: integer); // Создание файла
    begin
      new(Tree);
      Tree^.name := name;
      Tree^.ext := ext;
      Tree^.wBytes := weight;
      Tree^.nextbr := nil;
      Tree^.upchild := nil;
    end;
  
    procedure CreateElem(var Tree: PElem; elem: string); // Проверяем файл или каталог, если файл, то корректность формата имени
    var
      fileName: array of string;
      weight: integer;
      ext, name, wStr: string;
    begin
      if (pos('.', elem) > 0) then
      begin
          fileName := elem.Split('.');
          if (pos('(', fileName[1]) > 1) and (pos(')', fileName[1]) > 4) then // Проверка на то, что расширение не пусто, вес не пуст и скобки веса в правильном порядке
          begin
              name := fileName[0];
              ext := fileName[1][1:pos('(', fileName[1])];
              wStr := fileName[1][pos('(', fileName[1]) + 1:pos(')', fileName[1])];
              integer.TryParse(wStr, weight);
              CreateFile(Tree, name, ext, weight);
          end
          else
              writeln('Формат имени файла неверный - ничего не добавлено. Возможно вы забыли расширение или вес');
      end
      else
          CreateCat(Tree, elem);
    end;
    
    procedure _AddElem(var Tree: PElem; cat, name: string);
    var 
      P, newItem, upchild: PElem;
    begin
    if (Tree <> nil) then
    begin
      FindElem(Tree, cat, P);
      if (P <> nil) and not IsFile(P) then
          if (P^.upchild = nil) then
              CreateElem(P^.upchild, name)
            else
              begin
                upchild := P^.upchild;
                if IsFile(upchild) then
                begin
                    CreateElem(newItem, name);
                    newItem^.nextbr := upchild;
                    P^.upchild := newItem;
                end
                else
                begin
                    while (upchild^.nextbr <> nil) and not IsFile(upchild^.nextbr) do
                        upchild := upchild^.nextbr;
                    CreateElem(upchild^.nextbr, name);
                end;
              end;
      end
      else
          CreateElem(Tree, name);
    end;
  
    procedure AddElem(var Tree: PElem);
    var 
        cat, name, inpS: string;
        inp: array of string;
    begin
        if (Tree <> nil) then
        begin
            writeln('Введите через пробел каталог, куда добавить, и название элемента');
            write('---> ');
            readln(inpS);
            inp := inpS.Split();
            cat := inp[0];
            name := inp[1];
            if Tree <> nil then
            begin
                if (cat = '') or (name = '') then 
                    writeln('Неверный формат ввода - каталог, имя элемента не должны быть пустыми')
                else
                    _AddElem(Tree, cat, name);
            end;
        end
        else
        begin
            writeln('Введите название нового корневого каталога');
            readln(name);
            _AddElem(Tree, cat, name);
        end;
    end;
    
    procedure _DeleteTree(var tree : PElem); 
      begin
         if Tree <> nil 
           then
             begin
               _DeleteTree(tree^.upchild);
               _DeleteTree(tree^.nextbr);
               dispose(tree);
               tree := nil;
             end;
      end;
      
      procedure DeleteTree(var tree: PElem);
      begin
            if (tree = nil) then
                writeln('Дерево уже пусто')
            else
            begin
                _DeleteTree(tree);
                writeln('Дерево удалено');
            end;
      end;


    procedure Main;
    var
        Tree: PElem;
        Action: integer;
    begin
        CreateCat(Tree, 'ROOT'); // Предварительно создадим каталоги ROOT, C и D для удобства
        _AddElem(Tree, 'ROOT', 'C:');
        _AddElem(Tree, 'ROOT', 'D:');
        writeln('Пример ввода при добавлении:');
        writeln(Char(9), '"Catalog1 Catalog2" - "Catalog2" добавить в "Catalog1", "Calatog file.exe(10)" - добавить файл с весом 10 Б в каталог "Catalog". Примечание - расширение файла и вес не могут быть пустыми');
        writeln(Char(9), 'Введите 1, чтобы добавить элемент, 2 - удалить дерево, 3 - вывести дерево, -1 - закончить');
        while True do
        begin
            readln(Action);
            case Action of 
                -1: break;
                1: AddElem(Tree);
                2: DeleteTree(Tree);
                3: ViewTree(Tree);
            end;
        end;
    end;
    
begin
    Main;
end.
