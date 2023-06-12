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

    procedure LeftRotate(root: RBNodeP); // Левый поворот
    var
        temp: RBNode;
        temp2: RBNodeP;
        l := root^.l;
    begin
        temp := l^;
        l^ := root^;
        root^ := temp;
        temp2 := root^.r;
        l^.l := temp2;
        l^.l^.parent := l;
        l^.r^.parent := l;
        root^.parent := l^.parent;
        l^.parent := root;
        root^.r := l;
        root^.l^.parent := root;
    end;

    procedure RightRotate(root: RBNodeP); // Правый поворот
    var
        temp: RBNode;
        temp2: RBNodeP;
        r := root^.r;
    begin
        temp := r^;
        r^ := root^;
        root^ := temp;
        temp2 := root^.l;
        r^.r := temp2;
        r^.r^.parent := r;
        r^.l^.parent := r;
        root^.parent := r^.parent;
        r^.parent := root;
        root^.l := r;
        root^.r^.parent := root;
    end;

    procedure balanceHeights(parent: NodeP);
    var
        node: NodeP;
    begin
        if (parent^.diff = 2) then // Перевес вправо
        begin
            node := parent^.r;
            if (node^.diff = 1) then
            begin
                RightRotate(parent);
                getHeight(node); // Проверить на что ссылаемся
                getHeight(parent);
            end
            else if (node^.diff = 0) then
            begin
                RightRotate(parent);
                getHeight(node); // Проверить на что ссылаемся
                getHeight(parent);
            end
            else if (node^.diff = -1) then
            begin
                LeftRotate(node);
                RightRotate(parent);
                getHeight(node); // Проверить ссылки
                getHeight(parent^.l);
                getHeight(parent);
            end;
        end
        else if (parent^.diff = -2) then // Перевес влево
        begin
            node := parent^.l;
            if (node^.diff = 1) then
            begin
                RightRotate(node);
                LeftRotate(parent)
                getHeight(node); // Проверить ссылки
                getHeight(parent^.l);
                getHeight(parent);
            end
            else if (node^.diff = 0) then
            begin
                LeftRotate(parent);
                getHeight(node); // Проверить на что ссылаемся
                getHeight(parent);
            end
            else if (node^.diff = -1) then
            begin
                LeftRotate(parent);
                
            end;
        end;
    end;


    procedure getHeight(node: NodeP);
    begin
        if (node^.r <> nil) then
            node^.diff := abs(node^.r^.diff)
        else node^.diff := 0;
        if (node^.l <> nil) then
            node^.diff := - abs(node^.l^.diff);
    end;

    procedure FixAfterInsert(parent: NodeP);
    begin
        getHeight(parent);
        if ((abs(parent^.diff) = 1) and (parent^.parent <> nil)) then
            FixAfterInsert(parent^.parent)
        else if abs(parent^.diff) = 2 then
        begin
            balanceHeights(parent);
            FixAfterInsert(parent);
        end;
    end;
    

    procedure initNodeRandom(var node: NodeP); // Заполняем узел случайными числами
    begin
        new(node);
        node^.val := Random(0, 100);
    end;

    procedure initNode(var node: NodeP); // Заполняем узел
    var
        value: integer;
    begin
        new(node);
        writeln('Введите значение добавляемого узла');
        write('->  ');
        readln(value);
        node^.val := value;
    end;

    function search(root: NodeP; val: integer): NodeP; // Поиск узла в дереве
    begin
        if (root = nil) then
            Result := nil
        else if (root^.val > val) then
            Result := search(root^.l, val)
        else if (root^.val < val) then
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
                root^.r := insertNode(root^.r, node, root)
            else if (root^.val > node^.val) then
                root^.l := insertNode(root^.l, node, root);
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
            insertNode(treeRoot, newNode, treeRoot);
            FixAfterInsert(newNode^.parent, newNode);
        end;
    end;

    procedure main_; // Главный цикл программы
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
                    InsertNode(treeRoot, newNode);
                    FixAfterInsert(newNode^.parent);
                end;
            2:
                begin
                    InitNode(newNode);
                    InsertNode(treeRoot, newNode);
                    FixAfterInsert(newNode);
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
    main_;
end.