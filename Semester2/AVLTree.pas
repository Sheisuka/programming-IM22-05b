program AVLTree;
// Реализация АВЛ дерева. 
// Пояснения:
    // Вывод производится непосредственно в консоли, т.к. используется модуль CRT, необходимый для изменения цвета вывода
    // Цвет вывода меняется для того, чтобы показать область, в которой были совершены повороты - они подсвечиваются зеленым
    // При выводе дерева в скобках у каждой вершины так же указывается разница между высотой левого и правого поддерева с корнем в этой вершине
    
    // Изначально дерево заполяется случайными числами от 0 до 100, при необходимости можно добавить узлы и задавая значения с клавиатуры
uses CRT;
const 
    RED = 10;
    WHITE = 15;
type
    NodeP = ^Node;
    Node = record
        val: integer;
        l: NodeP;
        r: NodeP;
        parent: NodeP;
        diff: integer; // diff > 0 если перевес в правую сторону, diff < 0 - в левую, diff = 0 - перевеса нет
        color: integer;
    end;
    
    procedure initNodeRandom(var node: NodeP); // Заполнение узла случайными числами
    var
        val: integer;
    begin
        new(node);
        val := Random(0, 100);
        node^.color := WHITE;
        writeln('Добавлен узел со значением ', val);
        node^.val := val;
    end;

    procedure initNode(var node: NodeP); // Заполнение узла с клавиатуры
    var
        value: integer;
    begin
        new(node);
        writeln('Введите значение добавляемого узла');
        write('->  ');
        readln(value);
        node^.color := WHITE;
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
    
    procedure paintTree(root: NodeP); // Перекрас всего дерева в белый
    begin
        if (root <> nil) then
            root^.color := WHITE;
        if (root^.r <> nil) then
            paintTree(root^.r);
        if (root^.l) <> nil then
            paintTree(root^.l);
    end;
    
    function countHeight(node: NodeP): integer; // Подсчет высоты поддерева в узле рекурсивно
    begin
        if (node^.r = nil) and (node^.l = nil) then
            Result := 1
        else
            if (node^.r = nil) then
                Result := countHeight(node^.l) + 1
            else if (node^.l = nil) then
                Result := countHeight(node^.r) + 1
            else
                Result := max(countHeight(node^.l) + 1, countHeight(node^.r) + 1);
    end;
    
    function getMax(root: NodeP): NodeP; // Поиск максимального узла
    begin
        if (root^.r <> nil) then
            Result := getMax(root^.r)
        else
            Result := root;
    end;
    
    procedure getHeight(node: NodeP); // Получение разница правого и левого поддерева узла
    var
        lH, rH: integer;
    begin
        node^.diff := 0;
        if node^.l <> nil then
            node^.diff -= countHeight(node^.l);
        if node^.r <> nil then
            node^.diff += countHeight(node^.r);
    end;

    procedure _viewTree(root: NodeP; indent: integer); // Вывод дерева на боку
    begin
        if (root^.r <> nil) then
            _viewTree(root^.r, indent + 4);
        textcolor(root^.color);
        write(root^.val:(indent));
        writeln('(',root^.diff,')');
        if (root^.l <> nil) then
            _viewTree(root^.l, indent + 4);
    end;

    procedure viewTree(root: NodeP); // Вывод дерева на боку
    begin
        textcolor(WHITE);
        writeln('-----------------------------------');
        if (root = nil) then
            writeln('Дерево пусто')
        else
            _viewTree(root, 0);
        paintTree(root);
        textcolor(WHITE);
        writeln('-----------------------------------');
        writeln;
    end;

    procedure LeftRotate(root: NodeP); // Левый поворот
    var
        temp: Node;
        temp2: NodeP;
        l := root^.l;
    begin
        root^.color := RED; // Красим
        l^.color := RED;
        if root^.parent <> nil then
            root^.parent^.color := RED;
        
        temp := l^;
        l^ := root^;
        root^ := temp;
        temp2 := root^.r;
        l^.l := temp2;
        if (l^.l <> nil) then
            l^.l^.parent := l;
        if (l^.r <> nil) then
            l^.r^.parent := l;
        root^.parent := l^.parent;
        l^.parent := root;
        root^.r := l;
        if root^.l <> nil then
            root^.l^.parent := root;
    end;

    procedure RightRotate(root: NodeP); // Правый поворот
    var
        temp: Node;
        temp2: NodeP;
        r := root^.r;
    begin
        root^.color := RED; // Красим
        r^.color := RED;
        if root^.parent <> nil then
            root^.parent^.color := RED;
        
        temp := r^;
        r^ := root^;
        root^ := temp;
        temp2 := root^.l;
        r^.r := temp2;
        if (r^.r <> nil) then
            r^.r^.parent := r;
        if (r^.l <> nil) then
            r^.l^.parent := r;
        root^.parent := r^.parent;
        r^.parent := root;
        root^.l := r;
        if root^.r <> nil then
            root^.r^.parent := root;
    end;

    procedure balanceHeights(parent: NodeP); // Балансировка поворотами и пересчет разниц узлов, затронутых непосредственно при повороте
    var
        node: NodeP;
    begin
        if (parent^.diff = 2) then // Перевес вправо
        begin
            node := parent^.r;
            if (node^.diff = 1) then
            begin
                RightRotate(parent);
                getHeight(parent);
                getHeight(node);
            end
            else if (node^.diff = 0) then
            begin
                RightRotate(parent);
                getHeight(parent);
                getHeight(node);
            end
            else if (node^.diff = -1) then
            begin
                LeftRotate(node);
                RightRotate(parent);
                getHeight(parent);
                getHeight(parent^.l);
                getHeight(parent^.r);
            end;
        end
        else if (parent^.diff = -2) then // Перевес влево
        begin
            node := parent^.l;
            if (node^.diff = 1) then
            begin
                RightRotate(node);
                LeftRotate(parent);
                getHeight(parent);
                getHeight(parent^.l);
                getHeight(parent^.r);
            end
            else if (node^.diff = 0) then
            begin
                LeftRotate(parent);
                getHeight(node);
                getHeight(parent);
            end
            else if (node^.diff = -1) then
            begin
                LeftRotate(parent);
                getHeight(node);
                getHeight(parent);
            end;
        end;
    end;

    procedure FixAfterInsert(parent: NodeP); // Восстановление свойств после добавления элемента
    begin
        if (parent <> nil) then
        begin
            getHeight(parent);
            if (abs(parent^.diff) = 1) and (parent^.parent <> nil) then
                FixAfterInsert(parent^.parent)
            else if abs(parent^.diff) = 2 then
            begin
                balanceHeights(parent);
                FixAfterInsert(parent);
            end;
        end;
    end;
    
    procedure FixAfterDelete(parent: NodeP); // Восстановление свойств после удаления, отличается от восстановления после вставки тем, что идет наверх если разница стала нулевой 
    begin                                                                                                                   // то есть уменьшилась высота
        if (parent <> nil) then
        begin
            getHeight(parent);
            if ((parent^.diff) = 0) and (parent^.parent <> nil) then
                FixAfterDelete(parent^.parent)
            else if abs(parent^.diff) = 2 then
            begin
                balanceHeights(parent);
                FixAfterDelete(parent);
            end;
        end;
    end;

    function createTree: NodeP; // Инициализация дерева
    var
        flag: integer;
        treeRoot, newNode, typedNil: NodeP;
    begin
        writeln('Создадим дерево, добавляя случайные значения, введите -1 чтобы закончить');
        while True do
        begin
            readln(flag);
            if (flag = -1) then break;
            initNodeRandom(newNode);
            insertNode(treeRoot, newNode, typedNil);
            writeln('Дерево до:');
            viewTree(treeRoot);
            FixAfterInsert(newNode^.parent);
            writeln('Дерево после:');
            viewTree(treeRoot);
        end;
        Result := treeRoot;
    end;
    
    procedure DeleteNode(node: NodeP); // Удаление узла и дальнейшее исправление
    var
        subMax, parent: NodeP;
    begin
        parent := node^.parent;
        if not ((node^.r = nil) or (node^.l = nil)) then
        begin
            subMax := getMax(node^.l);
            node^.val := subMax^.val;
            DeleteNode(subMax);
        end
        else
            if (node^.r = nil) then
            begin
                if (parent <> nil) then
                    if node^.val > parent^.val then
                        parent^.r := node^.l
                    else
                        parent^.l := node^.l;
                dispose(node);
                FixAfterDelete(parent);
            end
            else if (node^.l = nil) then
            begin
                if (parent <> nil) then
                    if node^.val > parent^.val then
                        parent^.r := node^.r
                    else
                        parent^.l := node^.r;
                dispose(node);
                FixAfterDelete(parent);
            end;
    end;

    procedure main_; // Главный цикл программы
    var
        treeRoot, newNode, searchRes, typedNil: NodeP;
        flag: integer;
    begin
        treeRoot := createTree;
        writeln('Дерево создано');
        writeln('1 - добавить случайное число, 2 - добавить введенное число, 3 - удалить, 4 - вывести, 5 - найти, -1 - закончить');
    while (flag <> -1) do
    begin
        write('-->  ');
        readln(flag);
        case flag of
            -1: 
                break;
            1:
                begin
                    InitNodeRandom(newNode);
                    InsertNode(treeRoot, newNode, typedNil); // Добавление узла со случайным значением
                    FixAfterInsert(newNode^.parent);
                end;
            2:
                begin
                    InitNode(newNode);
                    InsertNode(treeRoot, newNode, typedNil); // Добавление узла со значением введеным пользователем
                    FixAfterInsert(newNode^.parent);
                end;
            3:
                begin
                    writeln('Введите значение удаляемого узла');
                    readln(flag);
                    searchRes := search(treeRoot, flag); // Удаление узла по его значению
                    if searchRes = nil then
                        writeln('Такого элемента в дереве нет')
                    else
                        DeleteNode(searchRes);
                end;
            4:
                begin
                    viewTree(treeRoot); // Вывод дерева
                end;
            5:
                begin
                    writeln('Введите искомое значение');
                    readln(flag);
                    searchRes := Search(TreeRoot, flag);
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