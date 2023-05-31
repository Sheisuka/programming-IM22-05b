program bigNumber26;
    type
        bigNP = ^bigN;
        bigN = record
            val: integer;
            r: bigNP;
            l: bigNP;
        end; 
    var
        ln, rn, ln_k, rn_k : bigNP;
        k: integer;
    
    function my_power(x, y: integer): integer;
    begin
        if (y = 0) then
            Result := 1
        else
            Result := x * my_power(x, y - 1);
    end;
    
    procedure _view_big_n_r(head: bigNP);
    begin
        if (head^.l <> nil) then
            _view_big_n_r(head^.l);
        write(head^.val);
    end;
    
    procedure _view_big_n_l(head: bigNP);
    begin
        write(head^.val);
        if (head^.r <> nil) then
          _view_big_n_l(head^.r);
    end;
    
     procedure view_big_n(head: bigNP);
    begin
        if ((head^.r = nil) and (head^.l <> nil)) then
            _view_big_n_r(head)
        else 
            _view_big_n_l(head);
        writeln;
    end;
        
    procedure strip_bn(var ln: bigNP);
    begin
        while (ln^.val = 0) and (ln^.r <> nil) and (ln^.l = nil) do
        begin
            ln := ln^.r;
            ln^.l^.r := nil;
            ln^.l := nil;
        end;
    end;

    procedure get_big_n(var lh, rh: bigNP);
    var
        num: integer;
        lhead, rhead, dummy, prev: bigNP;
    begin
        new(dummy);
        prev := dummy;
        writeln('Вводите число поциферно справа налево, -1 если захотите закончить');
        while (num <> -1) do
        begin
            write('---> ');
            read(num);
            if ((num >= 0) and (num <= 9)) then
            begin
                new(lhead);
                prev^.l := lhead;
                lhead^.r := prev;
                lhead^.val := num;
                prev := lhead;
            end;
        end;
        dummy^.l^.r := nil;
        lh := lhead;
        rh := dummy^.l;     
    end;
    
    procedure add_bn_int(var rn: bigNP; k: integer);
    var
       carry: integer;
       new_ln: bigNP;
    begin
        carry := (rn^.val + k) div 10;
        rn^.val := (rn^.val + k) mod 10;
        if (carry <> 0) then
            if (rn^.l <> nil) then
                add_bn_int(rn^.l, carry)
            else
            begin
                new(new_ln);
                new_ln^.val := carry;
                rn^.l := new_ln;
                new_ln^.r := rn;
            end;
    end;
    
    procedure subs_bn_int(n: bigNP; k: integer);
    var
       carry: integer;
       new_ln: bigNP;
    begin
        if (k > n^.val) then
        begin
            carry := round((k - n^.val + 5) / 10);
            n^.val := carry * 10 + n^.val - k;
            subs_bn_int(n^.l, carry);
        end
        else if (k <= n^.val) then
            n^.val := n^.val - k;
    end;
    
    procedure add_bn_bn(n, k: bigNP; var resl, resr: bigNP);
    var
        carry: integer;
        dummy, prev: bigNP;
    begin
        new(dummy);
        prev := dummy;
        while ((n <> nil) and (k <> nil)) do
        begin
            new(resl);
            resl^.val := carry + n^.val + k^.val;
            carry := resl^.val div 10;
            resl^.val := resl^.val mod 10;
            resl^.r := prev;
            prev^.l := resl;
            prev := resl;
            n := n^.l;
            k := k^.l;
        end;
        while (n <> nil) do
        begin
            new(resl);
            resl^.val := n^.val + carry;
            carry := resl^.val div 10;
            resl^.val := resl^.val mod 10;
            resl^.r := prev;
            prev^.l := resl;
            prev := resl;
            n := n^.l;
        end;
        while (k <> nil) do
        begin
            new(resl);
            resl^.val := k^.val + carry;
            carry := resl^.val div 10;
            resl^.val := resl^.val mod 10;
            resl^.r := prev;
            prev^.l := resl;
            prev := resl;
            k := k^.l;
        end;
        dummy^.l^.r := nil;
        resr := dummy^.l;
    end;
    
    procedure mult_bn_int(n: bigNP; var resr, resl: bigNP; k: integer);
    var
        carry: integer;
        dummy, prev, cur: bigNP;
    begin
        new(dummy);
        prev := dummy;
        while (n <> nil) do
        begin
            new(cur);
            cur^.val := carry + n^.val * k;
            carry := cur^.val div 10;
            cur^.val := cur^.val mod 10;
            cur^.r := prev;
            prev^.l := cur;
            prev := cur;
            n := n^.l;    
        end;
        while (carry <> 0) do
        begin
            new(cur);
            cur^.val := carry;
            carry := cur^.val div 10;
            cur^.val := cur^.val mod 10;
            cur^.r := prev;
            prev^.l := cur;
            prev := cur;
        end;
        resl := cur;
        resr := dummy^.l;
        resr^.r := nil;
    end;
    
    procedure mult_bn_bn(n, k: bigNP; var resl, resr: bigNP);
    var
        cur_factor := 1;
        res_m_r, res_m_l, res_a_r, res_a_l, cur_a_r, cur_a_l: bigNP;
    begin
        while (k <> nil) do
        begin
            mult_bn_int(n, res_m_r, res_m_l, k^.val * cur_factor);
            view_big_n(res_m_l);
            add_bn_bn(res_m_r, cur_a_r, cur_a_l, cur_a_r);
            view_big_n(cur_a_l);
            cur_factor *= 10;
            k := k^.l;
        end;
        resl := cur_a_l;
        resr := cur_a_r;
    end;
    
    function bn_to_int(bn: bigNP): integer;
    var
        res: integer;
        factor := 1;
    begin
        while (bn <> nil) do
        begin
            res += bn^.val * factor;
            factor *= 10;
            bn := bn^.l;
        end;
        Result := res;
    end;
    
    procedure bn_to_k(nl, nr: bigNP; k: integer; var resl, resr: bigNP);
    var
        remainder: integer; 
        new_nl, new_nr, nikr: bigNP;
    begin
        view_big_n(nr);
        new(new_nr);
        while not ((nr^.val < k) and (nr^.l = nil)) do
        begin
            subs_bn_int(nr, k);
            strip_bn(nl);
            add_bn_int(new_nr, 1);
        end;
        remainder := bn_to_int(nr);
        resr^.val := remainder;
        new(nikr);
        resr^.l := nikr;
        nikr^.r := resr;
        new_nl := new_nr;
        while (new_nl^.l <> nil) do
            new_nl := new_nl^.l;
        if not ((new_nr^.val < k) and (new_nr^.l = nil)) then
            bn_to_k(new_nl, new_nr, k, resl, nikr)
        else
            nikr^.val := new_nr^.val;
        resl := nikr;
    end;
    
    procedure concat_bn_int(var bn_r: bigNP; int: integer);
    var
        len := -1;
        int_: integer;
        cur: bigNP;
    begin
        int_ := int;
        while (int_ > 0) do
        begin
            len += 1;
            int_ := int_ - my_power(10, len);
        end;
        while (int <> 0) do
        begin
            new(cur);
            cur^.val := int div (my_power(10, len));
            int -= my_power(10, len);
            cur^.l := bn_r;
            bn_r^.r := cur;
            bn_r := bn_r^.r;
        end;
    end;

begin
    writeln('Введите число n');
    get_big_n(ln, rn);
    writeln('Ваше число: ');
    view_big_n(ln);
    writeln('Введите число k');
    readln(k);
    new(ln_k);
    new(rn_k);
    bn_to_k(ln, rn, sqr((2 * k + 1)), ln_k, rn_k);
    view_big_n(rn_k);
    concat_bn_int(rn_k, (k * (k + 1)) div 2);
    view_big_n(rn_k);
end.