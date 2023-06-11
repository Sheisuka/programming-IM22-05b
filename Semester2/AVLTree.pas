program AVLTree;
type
    NodeP = ^Node;
    Node = record
        val: integer;
        l: NodeP;
        r: NodeP;
        par: NodeP;
        diff: integer; // diff > 0 если перевес в правую сторону, diff < 0 - в левую, diff = 0 - перевеса нет
    end;

    procedure viewTree(root: NodeP; indent: integer); // Вывод дерева на боку
    begin
        if (root^.r <> nil) then
            viewTree(root^.r, indent + 4);
        writeln(root^.val:(indent));
        if (root^.l <> nil) then
            viewTree(root^.l, indent + 4);
    end;

    procedure initNodeRandom(var node: NodeP); // Заполняем узел случайными числами
    begin
        new(node);
        node^.val := Random(0, 100);
    end;

    procedure initNode(var node: NodeP); // Заполняем узел случайными числами
    var
        value: integer;
    begin
        new(node);
        writeln('Введите значение добавляемого узла');
        write('->  ');
        readln(value)
        node^.val := value;
    end;

    function search(root: NodeP; val: integer): NodeP; // Поиск узла в дереве
    begin
        if (root = nil) then
            Result := nil
        else if (root^.val > val) then
            Result := search(root^.l, val)
        else (root^.val < val) then
            Result := search(root^.r, val)
        else if (root^.val = val) then
            Result := root;
    end;

    function deleteNode: NodeP; // Удаление узла

    function insertNode(var root: NodeP; node, parent: NodeP): NodeP; // Вставка узла
    begin
        if (root = nil) and (parent = nil) then
            root := node
        else if (root = nil) then
        begin
            node^.parent := parent;
            Result := node;
        end
        else 
        begin
            if (root^.val < node^.val) then
                root^.r := inserNode(root^.r, node, root)
            else if (root^.val > node^.val) then
                root^.l := inserNode(root^.l, node, root);
            Result := root;
        end;
    end;

    function createTree: NodeP; // Инициализация дерева
    begin
        writeln('Создадим дерево, добавляя случайные значения, введите -1 чтобы закончить');
        while True do
        begin
            readln(flag);
            if (flag = -1) then break;
            initNodeRandom(newNode);
            insertNode(treeRoot, newNode);
            FixAfterInsert(newNode);
        end;
    end;

    procedure main; // Главный цикл программы
    var
        treeRoot, newNode, searchRes: RBNodeP;
        flag: integer;
    begin
        writeln('Создадим дерево');
        treeRoot := createTree;
        writeln('Дерево создано');
        writeln('1 - добавить случайное число, 2 - добавить введенное число, 3 - удалить, 4 - вывести, 5 - найти, -1 - закончить');
    while (flag <> -1) do
    begin
        write('->  ');
        readln(flag);
        case flag of
            -1: 
                break;
            1:
                begin
                    InitNodeRandom(newNode);
                    InsertNode(treeRoot, newNode;);
                    FixAfterInsert(newNode);
                end;
            2:
                begin
                    InitNode(newNode);
                    InsertNode(treeRoot, newNode);
                    FixAfterInsert(newNode);
                    writeln;
                end;
            3:
                begin
                    writeln('Введите значение удаляемого узла');
                    readln(value);
                    searchRes := search(treeRoot, value);
                    DeleteNode(TreeRoot, searchRes);
                    writeln;
                end;
            4:
                begin
                    writeln('------------------');
                    if (TreeRoot = nil) then
                        writeln('Дерево пусто')
                    else
                        viewTree(TreeRoot, 0);
                    writeln('------------------');
                    writeln;
                end;
            4:
                begin
                    writeln('Введите искомое значение');
                    readln(value);
                    searchRes := Search(TreeRoot, value);
                    if (searchRes = nil) then
                        writeln('Такого элемента в дереве нет')
                    else
                        writeln('Элемент находится по адресу ', searchRes);
                    writeln;
                end;
        end;
    end;
    end;
    
begin
    main();
end.