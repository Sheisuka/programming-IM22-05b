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
    TreeRoot, newNode, fictNode: RBNodeP;
    flag, value: integer;
    
    function IsFict(node: RBNodeP): boolean;
    begin
        Result := ((node^.r = nil) and (node^.l = nil))
    end;
    
    function GetBH(root: RBNodeP; count: integer): integer;
    begin
        if (root^.color = BLACK) then   
            count += 1;
        if (root^.parent <> nil) then
            Result := GetBH(root^.parent, count)
        else
            Result := count;
    end;

    function getMax(root: RBNodeP): RBNodeP;
    begin
        if IsFict(root^.r) then
            Result := root
        else
            Result := getMax(root^.r);
    end;

    procedure viewTree(root: RBNodeP; indent: integer);
    begin
        if (root^.r <> nil) then
            viewTree(root^.r, indent + 4);
        if not IsFict(root) then
        begin
            textcolor(root^.color);
            write(root^.val:indent);
            writeln('(', getBh(root, 0), ')');
        end;
        if (root^.l <> nil) then
            viewTree(root^.l, indent + 4);
    end;

    function GetUncle(root: RBNodeP): RBNodeP;
    begin
        if (root^.val > root^.parent^.parent^.val) then
            Result := root^.parent^.parent^.l
        else
            Result := root^.parent^.parent^.r;
    end;

    procedure _LeftRotateInsert(root: RBNodeP);
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

    procedure _RightRotateInsert(root: RBNodeP);
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

    procedure FixAfterInsert(var root: RBNodeP);
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
                            _RightRotateInsert(root^.parent^.parent);
                        end
                        else
                        begin
                            _LeftRotateInsert(root^.parent); // Переворотом сводим к случаю выше
                            FixAfterInsert(root); // Проверить
                        end
                    else // Левое поддерево
                        if (root^.val < root^.parent^.val) then // Новый узел - левый сын родителя
                        begin
                            root^.parent^.color := BLACK;
                            root^.parent^.parent^.color := RED;
                            _LeftRotateInsert(root^.parent^.parent);
                        end
                        else
                        begin
                            _RightRotateInsert(root^.parent); // Переворотом сводим к случаю выше
                            FixAfterInsert(root); // Проверить
                        end;
                end;
            end;
        end;
        if (root^.parent <> nil) then
            FixAfterInsert(root^.parent);
    end;

    procedure InitNode(var root, fict: RBNodeP; value: integer);
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

    function Search(root: RBNodeP; val: integer): RBNodeP;
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

    function InsertNode(var root, node, parent: RBNodeP): RBNodeP;
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
    
    


    function CreateRBTree(): RBNodeP;
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

    procedure ReduceBH(node: RBNodeP); forward;

    procedure CheckAfterDelete(node: RBNodeP);
    var
        parent: RBNodeP;
    begin
        parent := node^.parent;
        if (parent <> nil) then
        begin
            if (node^.val < parent^.val) then
                ReduceBH(parent^.r)
            else
                ReduceBH(parent^.l);
            if (parent^.parent) <> nil then
                if (parent^.val > parent^.parent^.val) then
                    CheckAfterDelete(parent^.parent^.l) 
                else
                    CheckAfterDelete(parent^.parent^.r);    
        end;
    end;

    procedure ReduceBH(node: RBNodeP);
    var
        son, parent: RBNodeP;
    begin
        parent := node^.parent;
        if (parent^.val < node^.val) then // Рассматриваем правое поддерево node
        begin
            if (parent^.color = RED) then // Случай 2.1| Родитель красный
            begin
                if ((node^.l^.color = RED) or (node^.r^.color = RED)) then // Случай 2.1.1| Есть хотя бы один красный сын у узла
                begin
                    if (node^.l^.color = RED) then
                    begin
                        parent^.color := BLACK;
                        _LeftRotateInsert(node);
                        _RightRotateInsert(parent);
                    end
                    else
                    begin
                        parent^.color := BLACK;
                        _RightRotateInsert(parent);
                    end;
                end
                else //Случай 2.1.2| Нет красного сына
                begin
                    parent^.color := BLACK;
                    node^.color := RED;
                end;
            end
            else // Случай 2.2| Родитель черный
            begin
                if (node^.color = RED) then // Случай 2.2.1| Узел красный
                begin
                    if not IsFict(node^.r) then
                        son := node^.r
                    else
                        son := node^.l;
                    if ((son^.l^.color = RED) or (son^.r^.color = RED)) then // Случай 2.2.1.1| Есть ли красный внук у узла
                    begin
                        son^.r^.color := BLACK;
                        son^.l^.color := RED;
                        if (son^.val < node^.val) then
                            _LeftRotateInsert(node);
                        _RightRotateInsert(parent);
                    end
                    else // Случай 2.2.1.2| Нет красного сына у младшего брата
                    begin
                        if not IsFict(node^.r) then
                            node^.r^.color := RED;
                        if not IsFict(node^.l) then
                            node^.l^.color := RED;
                        node^.color := BLACK;
                        _RightRotateInsert(parent);
                    end;
                end
                else // Случай 2.2.2| Узел черный
                begin
                    if ((node^.l^.color = RED) or (node^.r^.color = RED)) then //Случай 2.2.2.1| Есть хотя бы один красный сын у узла
                    begin
                        if (node^.l^.color = RED) then
                        begin
                            node^.l^.color := BLACK;
                            _LeftRotateInsert(node);
                        end
                        else
                            node^.r^.color := BLACK;
                        _RightRotateInsert(parent);
                    end
                    else // Случай 2.2.2.2| Нет красных детей у узла
                    begin
                        node^.color := RED;
                        CheckAfterDelete(node^.parent);
                    end;
                end;
            end;
        end
        else // Рассмотрим левое поддерево node
        begin
            if (parent^.color = RED) then // Случай 2.1| Родитель красный
            begin
                if ((node^.l^.color = RED) or (node^.r^.color = RED)) then // Случай 2.1.1| Есть хотя бы один красный сын у узла
                begin
                    parent^.color := BLACK;
                    if (node^.r^.color = RED) then
                    begin
                        parent^.color := BLACK;
                        _RightRotateInsert(node);
                        _LeftRotateInsert(parent);
                    end
                    else
                    begin
                        parent^.color := BLACK;
                        _LeftRotateInsert(parent);
                    end;
                end
                else //Случай 2.1.2| Нет красного сына
                begin
                    parent^.color := BLACK;
                    node^.color := RED;
                end;
            end
            else // Случай 2.2| Родитель черный
            begin
                if (node^.color = RED) then // Случай 2.2.1| Узел красный
                begin
                    if not IsFict(node^.r) then
                        son := node^.r
                    else
                        son := node^.l;
                    if ((son^.l^.color = RED) or (son^.r^.color = RED)) then // Случай 2.2.1.1| Есть ли красный внук у узла
                    begin
                        son^.r^.color := BLACK;
                        son^.l^.color := RED;
                        if (son^.val > node^.val) then
                            _RightRotateInsert(node);
                        _LeftRotateInsert(parent);
                    end
                    else // Случай 2.2.1.2| Нет красного сына у младшего брата
                    begin
                        if not IsFict(node^.r) then
                            node^.r^.color := RED;
                        if not IsFict(node^.l) then
                            node^.l^.color := RED;
                        node^.color := BLACK;
                        _LeftRotateInsert(parent);
                    end;
                end
                else // Случай 2.2.2| Узел черный
                begin
                    if ((node^.l^.color = RED) or (node^.r^.color = RED)) then //Случай 2.2.2.1| Есть хотя бы один красный сын у узла
                    begin
                        if (node^.l^.color = RED) then
                        begin
                            node^.l^.color := BLACK;
                        end
                        else
                        begin
                            node^.r^.color := BLACK;
                            _RightRotateInsert(node);
                        end;
                        _LeftRotateInsert(parent);
                    end
                    else // Случай 2.2.2.2| Нет красных детей у узла
                    begin
                        node^.color := RED;
                        CheckAfterDelete(node^.parent);
                    end;
                end;
            end;
        end;
     end;
    
    procedure DeleteNode(root, fictNode: RBNodeP; val: integer);
    var
        node, child, parent, brother, lilbro, subMax: RBNodeP;
    begin
        node := Search(root, val);
        if (node <> nil) then
        begin
            parent := node^.parent;
            if (IsFict(node^.r) and IsFict(node^.l) and (node^.color = RED)) then // Случай 1| Дети фиктивные, x - красный
            begin
                if (parent <> nil) then
                    if (node^.val > parent^.val) then
                        parent^.r := fictNode
                    else
                        parent^.l := fictNode;
                dispose(node);
            end
            else if (IsFict(node^.r) and IsFict(node^.l) and (node^.color = BLACK)) then // Случай 2|  Дети фиктивные, x - черный
            begin
                // В поддереве с корнем в родителе нарушилась BH либо правого, либо левого поддерева
                if (node^.val > parent^.val) then
                begin
                    parent^.r := FictNode;
                    dispose(node);
                    ReduceBH(parent^.l) 
                end
                else
                begin
                    parent^.l := FictNode;
                    dispose(node);
                    ReduceBH(parent^.r);
                end;
            end
            else if (not IsFict(node^.r) and IsFict(node^.l)) or 
                    (IsFict(node^.r) and not IsFict(node^.l)) then // Случай 3| 1 дитё фиктивное другое - поддерево. Поддерево - обязательно красная вершина
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
            else if not ((IsFict(node^.r)) and (IsFict(node^.l))) then // Случай 4| Оба ребенка не фиктивные
            begin
                subMax := getMax(node^.l);
                node^.val := subMax^.val;
                DeleteNode(node^.l, fictNode, node^.val);
            end;
        end;
    end;

begin
    TreeRoot := CreateRBTree();
    fictNode := GetFictNode();
    writeln('1 - добавить элемент, 2 - удалить элемент, 3 - вывести дерево, -1 - закончить');
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
                end;
            2:
                begin
                    writeln('Введите значение удаляемого узла');
                    readln(value);
                    DeleteNode(TreeRoot, FictNode, value);
                end;
            3:
                begin
                    writeln('------------------');
                    viewTree(TreeRoot, 0);
                    writeln('------------------');
                    writeln;
                end;
        end;
    end;
end.