program RBTrees;
uses CRT;
type
    RBNodeP = ^RBNode;
    RBNode = record
        val: integer;
        l: RBNodeP;
        r: RBNodeP;
        parent: RBNodeP;
        color: integer;
    end;

const 
    RED = 4;
    BLACK = 15;
var
    TreeRoot, newNode, fictNode, SearchRes: RBNodeP;
    flag, value: integer;
    
    function IsFict(node: RBNodeP): boolean; // Проверка узла на нефиктивность
    begin
        Result := ((node^.r = nil) and (node^.l = nil))
    end;
    
    function Search(root: RBNodeP; val: integer): RBNodeP; // Поиск по значению в дереве
    begin
        if ((root^.r = nil) and (root^.l = nil)) then
            Result := nil
        else 
            if (val > root^.val) then
                Result := Search(root^.r, val)
            else if (val < root^.val) then
                Result := Search(root^.l, val)
            else
                Result := root;
    end;
    
    function GetBH(root: RBNodeP; count: integer): integer; // Вычисление на какой черной глубине находится узел
    begin
        if (root^.color = BLACK) then   
            count += 1;
        if (root^.parent <> nil) then
            Result := GetBH(root^.parent, count)
        else
            Result := count;
    end;

    function getMax(root: RBNodeP): RBNodeP; // Поиск максимального элемента в дереве
    begin
        if IsFict(root^.r) then
            Result := root
        else
            Result := getMax(root^.r);
    end;

    procedure viewTree(root: RBNodeP; indent: integer); // Вывод дерева на боку
    begin
        if (root^.r <> nil) then
            viewTree(root^.r, indent + 4);
        if not IsFict(root) then
        begin
            textcolor(root^.color);
            write(root^.val:indent);
            writeln('(',getbh(root, 0),')');
        end;
        if (root^.l <> nil) then
            viewTree(root^.l, indent + 4);
    end;

    function GetUncle(root: RBNodeP): RBNodeP; // Получение дяди узла
    begin
        if (root <> nil) then
            if (root^.parent <> nil) then 
                if (root^.parent^.parent <> nil) then
                if (root^.val > root^.parent^.parent^.val) then
                    Result := root^.parent^.parent^.l
                else
                    Result := root^.parent^.parent^.r;
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

    procedure FixAfterInsert(var root: RBNodeP); // Восстановление свойств дерева после вставки элемента
    var
        uncle, parent: RBNodeP;
    begin
        if ((root^.color = RED) and (root^.parent = nil)) then // Мы в красном корне | красим корень в черный
            root^.color := BLACK
        else if ((root^.color = RED) and (root^.parent^.color = RED)) then
        begin
            if (root^.parent^.parent = nil) then // Конфликт с корнем | перекрашиваем корень в черный
                root^.parent^.color := BLACK
            else
            begin
                uncle := GetUncle(root);
                if (uncle^.color = RED) then // Дядя красный | красим дядю и родителя в черный, деда - в красный
                begin
                    uncle^.color := BLACK;
                    root^.parent^.color := BLACK;
                    root^.parent^.parent^.color := RED;
                end
                else // Дядя черный
                begin
                    if (root^.val > root^.parent^.parent^.val) then // Правое поддерево
                        if (root^.val > root^.parent^.val) then // Новый узел - правый сын родителя
                        begin
                            root^.parent^.color := BLACK;
                            root^.parent^.parent^.color := RED;
                            RightRotate(root^.parent^.parent);
                        end
                        else
                        begin
                            LeftRotate(root^.parent); // Переворотом сводим к случаю выше
                            FixAfterInsert(root);
                        end
                    else // Левое поддерево
                        if (root^.val < root^.parent^.val) then // Новый узел - левый сын родителя
                        begin
                            root^.parent^.color := BLACK;
                            root^.parent^.parent^.color := RED;
                            LeftRotate(root^.parent^.parent);
                        end
                        else
                        begin
                            RightRotate(root^.parent); // Переворотом сводим к случаю выше
                            FixAfterInsert(root);
                        end;
                end;
            end;
        end;
        if (root^.parent <> nil) then
            FixAfterInsert(root^.parent);
    end;

    procedure InitNode(var root, fict: RBNodeP; value: integer); // Заполнение узла
    begin
        new(root);
        root^.r := fict;
        root^.l := fict;
        root^.val := value;
        root^.color := RED;
    end;

    function GetFictNode(): RBNodeP;
    var
        FictNode: RBNodeP;
    begin
        new(FictNode);
        FictNode^.r := nil;
        FictNode^.l := nil;
        Result := FictNode;
    end;

    function InsertNode(var root, node, parent: RBNodeP): RBNodeP; // Вставка узла
    begin
        if (root = nil) then
            root := node
        else if ((root^.r = nil) and (root^.l = nil)) then
        begin
            if (root <> parent) then
                node^.parent := parent;
            Result := node;
        end 
        else
        begin
            if (root^.val > node^.val) then
                root^.l := InsertNode(root^.l, node, root)
            else if (root^.val < node^.val) then
                root^.r := InsertNode(root^.r, node, root);
            Result := root
        end;
    end;
    
    


    function CreateRBTree(): RBNodeP; // Создание дерева
    var
        RBTree, NewNode: RBNodeP;
        fictNode := GetFictNode();
        value: integer;
    begin
        writeln('Создадим дерево случайно');
        while (value <> -1) do
        begin
            write('---> ');
            readln(value);
            if (value = -1) then break;
            InitNode(NewNode, FictNode, Random(0, 100));
            InsertNode(RBTree, NewNode, RBTree);
            FixAfterInsert(NewNode);
            viewTree(RBTree, 0);
        end;
        Result := RBTree;
    end;

    procedure ReduceBH(parent, node: RBNodeP);
    var
        nodeSon, nodeSonL, nodeSonr: RBNodeP;
    begin
        // Рассмотрим левое поддерево parent
        if (node^.val < parent^.val) then
        begin
            if (parent^.color = RED) then // Случай 2.1 | parent красный
            begin
                if (node^.l^.color = RED) or (node^.r^.color = RED) then // Случай 2.1.1 | node имеет красного сына
                begin
                    if (node^.l^.color = RED) then // Левый сын красный
                    begin
                        node^.l^.color := BLACK; // Проверить
                        node^.color := RED;
                        parent^.color := BLACK;
                        LeftRotate(parent);
                    end
                    else if (node^.r^.color = RED) then // Правый сын красный
                    begin
                        parent^.color := BLACK;
                        RightRotate(node);
                        LeftRotate(parent);
                    end;
                        
                end
                else if not ((node^.l^.color = RED) or (node^.r^.color = RED)) then // Случай 2.1.2 | node не имеет красных детей
                begin
                    parent^.color := BLACK;
                    node^.color := RED;
                end;
            end
            else if (parent^.color = BLACK) and (node^.color = RED) then // Случай 2.2.1 | parent черный, node красный
            begin
                nodeSonR := node^.r; // Правый и левый обязательно черные
                nodeSonL := node^.l;
                if ((nodeSonR^.r^.color = RED) or (nodeSonR^.l^.color = RED)) or ((nodeSonL^.r^.color = RED) or (nodeSonL^.l^.color = RED)) then // Случай 2.2.1.1 | у сына node есть красный ребенок
                begin
                    if (nodeSonR^.r^.color = RED) or (nodeSonR^.l^.color = RED) then // У правого сына
                    begin
                        if (nodeSonR^.r^.color = RED) then
                            nodeSonR^.r^.color := BLACK
                        else
                            nodeSonR^.l^.color := BLACK;
                        RightRotate(node);
                        LeftRotate(parent);
                    end
                    else if (nodeSonL^.r^.color = RED) or (nodeSonL^.l^.color = RED) then // У левого сына
                    begin
                        if (nodeSonL^.r^.color = RED) then
                            nodeSonL^.r^.color := BLACK
                        else
                            nodeSonL^.l^.color := BLACK;
                        LeftRotate(parent);
                    end;
                end
                else if not ((nodeSonR^.r^.color = RED) or (nodeSonR^.l^.color = RED)) then // Случай 2.2.1.2 | у сына node нет красных детей
                begin
                    nodeSonR^.color := RED;
                    LeftRotate(parent);
                end;
            end
            else  if (parent^.color = BLACK) and (node^.color = BLACK) then // Случай 2.2.2 | parent и node черные
            begin
                if ((node^.r^.color = RED) or (node^.l^.color = RED)) then // Случай 2.2.2.1 | у node есть красные дети
                begin
                    if (node^.r^.color = RED) then // Правый сын красный
                    begin
                        node^.r^.color := BLACK;
                        RightRotate(node);
                        LeftRotate(parent);
                    end
                    else if (node^.l^.color = RED) then // Левый сын красный
                    begin
                        node^.l^.color := BLACK;
                        LeftRotate(parent);
                    end;
                end
                else if not ((node^.r^.color = RED) or (node^.l^.color = RED)) then // Случай 2.2.2.2 | у node нет красных детей
                node^.color := RED;
                if (parent^.parent <> nil) then
                begin
                    if (parent^.val > parent^.parent^.val) then
                        ReduceBH(parent^.parent, parent^.parent^.l)
                    else
                        ReduceBH(parent^.parent, parent^.parent^.r);
                end;
            end;
        end
        // -------------------------------------------------------------------------- //
        // Рассмотрим правое поддерево parent
        else if (node^.val >= parent^.val) then
        begin
            if (parent^.color = RED) then // Случай 2.1 | parent красный
            begin
                if (node^.l^.color = RED) or (node^.r^.color = RED) then // Случай 2.1.1 | node имеет красного сына
                begin
                    if (node^.l^.color = RED) then // Левый сын красный
                    begin
                        parent^.color := BLACK;
                        LeftRotate(node);
                        RightRotate(parent);
                    end
                    else if (node^.r^.color = RED) then // Правый сын красный
                    begin
                        node^.r^.color := BLACK;
                        node^.color := RED;
                        parent^.color := BLACK;
                        RightRotate(parent);
                    end;
                        
                end
                else if not ((node^.l^.color = RED) or (node^.r^.color = RED)) then // Случай 2.1.2 | node не имеет красных детей
                begin
                    parent^.color := BLACK;
                    node^.color := RED;
                end;
            end
            else if (parent^.color = BLACK) and (node^.color = RED) then // Случай 2.2.1 | parent черный, node красный
            begin
                nodeSonR := node^.r; // Правый и левый обязательно черные
                nodeSonL := node^.l;
                if ((nodeSonR^.r^.color = RED) or (nodeSonR^.l^.color = RED)) or ((nodeSonL^.r^.color = RED) or (nodeSonL^.l^.color = RED)) then // Случай 2.2.1.1 | у сына node есть красный ребенок
                begin
                    if (nodeSonR^.r^.color = RED) or (nodeSonR^.l^.color = RED) then // У правого сына
                    begin
                        if (nodeSonR^.r^.color = RED) then
                            nodeSonR^.r^.color := BLACK
                        else
                            nodeSonR^.l^.color := BLACK;
                        RightRotate(parent);
                    end
                    else if (nodeSonL^.r^.color = RED) or (nodeSonL^.l^.color = RED) then // У левого сына
                    begin
                        if (nodeSonL^.r^.color = RED) then
                            nodeSonL^.r^.color := BLACK
                        else
                            nodeSonL^.l^.color := BLACK;
                        LeftRotate(node);
                        RightRotate(parent);
                    end;
                end
                else if not ((nodeSonR^.r^.color = RED) or (nodeSonR^.l^.color = RED)) or ((nodeSonL^.r^.color = RED) or (nodeSonL^.l^.color = RED)) then // Случай 2.2.1.2 | у сына node нет красных детей
                begin
                    nodeSonR^.color := RED;
                    RightRotate(parent);
                end;
            end
            else  if (parent^.color = BLACK) and (node^.color = BLACK) then // Случай 2.2.2 | parent и node черные
            begin
                if ((node^.r^.color = RED) or (node^.l^.color = RED)) then // Случай 2.2.2.1 | у node есть красные дети
                begin
                    if (node^.r^.color = RED) then // Правый сын красный
                    begin
                        node^.r^.color := BLACK;
                        RightRotate(parent);
                    end
                    else if (node^.l^.color = RED) then // Левый сын красный
                    begin
                        node^.l^.color := BLACK;
                        LeftRotate(node);
                        RightRotate(parent);
                    end;
                end
                else if not ((node^.r^.color = RED) or (node^.l^.color = RED)) then // Случай 2.2.2.2 | у node нет красных детей
                begin
                    node^.color := RED;
                    if (parent^.parent <> nil) then
                    begin
                        if (parent^.val > parent^.parent^.val) then
                            ReduceBH(parent^.parent, parent^.parent^.l)
                        else
                            ReduceBH(parent^.parent, parent^.parent^.r);
                    end;
                end;
            end;
        end;
        if (parent^.parent = nil) and (parent^.color = RED) then
            parent^.color := BLACK;
    end;
    
    procedure DeleteNode(var root, fictNode: RBNodeP; val: integer); // Удаление узла по значению
    var
        node, child, parent, brother, lilbro, subMax: RBNodeP;
    begin
        node := Search(root, val);
        if (node <> nil) then
        begin
            parent := node^.parent;
            if (parent = nil) and IsFict(node^.r) and IsFict(node^.l) then
            begin
                dispose(root);
                writeln('Удалено всё дерево');
            end
            else if (IsFict(node^.r) and IsFict(node^.l) and (node^.color = RED)) then // Случай 1 | Дети фиктивные, x - красный
            begin
                if (parent <> nil) then
                    if (node^.val > parent^.val) then
                        parent^.r := fictNode
                    else
                        parent^.l := fictNode;
                dispose(node);
            end
            else if (IsFict(node^.r) and IsFict(node^.l) and (node^.color = BLACK)) then // Случай 2 |  Дети фиктивные, x - черный
            begin
                // В поддереве с корнем в родителе нарушилась BH либо правого, либо левого поддерева
                if (node^.val > parent^.val) then
                begin
                    parent^.r := FictNode;
                    dispose(node);
                    ReduceBH(parent, parent^.l);
                end
                else
                begin
                    parent^.l := FictNode;
                    dispose(node);
                    ReduceBH(parent, parent^.r);
                end;
            end
            else if (not IsFict(node^.r) and IsFict(node^.l)) or 
                    (IsFict(node^.r) and not IsFict(node^.l)) then // Случай 3 | 1 дитё фиктивное другое - поддерево. Поддерево - обязательно красная вершина
            begin
                if (IsFict(node^.r)) then
                    child := node^.l
                else
                    child := node^.r;
                child^.color := BLACK;
                child^.parent := parent;
                if (node^.val > node^.parent^.val) then
                    parent^.r := child
                else
                    parent^.l := child;
                dispose(node);
            end
            else if not ((IsFict(node^.r)) and (IsFict(node^.l))) then // Случай 4 | Оба ребенка не фиктивные
            begin
                subMax := getMax(node^.l);
                node^.val := subMax^.val;
                DeleteNode(node^.l, fictNode, subMax^.val);
            end;
        end;
    end;

begin
    TreeRoot := CreateRBTree();
    fictNode := GetFictNode();
    writeln('1 - добавить элемент, 2 - удалить элемент, 3 - вывести дерево, 4 - найти элемент, -1 - закончить');
    while (flag <> -1) do
    begin
        readln(flag);
        case flag of
            -1: 
                break;
            1:
                begin
                    writeln('Введите значение добавляемого узла');
                    readln(value);
                    InitNode(NewNode, FictNode, value);
                    InsertNode(TreeRoot, NewNode, TreeRoot);
                    FixAfterInsert(NewNode);
                    writeln;
                end;
            2:
                begin
                    writeln('Введите значение удаляемого узла');
                    readln(value);
                    DeleteNode(TreeRoot, FictNode, value);
                    writeln;
                end;
            3:
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
                    if searchRes = nil then
                        writeln('Такого элемента в дереве нет')
                    else
                        writeln('Элемент находится по адресу ', searchRes);
                    writeln;
                end;
        end;
    end;
end.