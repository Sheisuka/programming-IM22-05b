program bigNumber26;
    type
        bigNP = ^bigN;
        bigN = record
            val: integer;
            r: bigNP;
            l: bigNP;
        end; 
    var
        ln, rn, ln_k, rn_k, int_k_l, int_k_r: bigNP;
        ISH_L, ISH_R: bigNP;
        ln_copy, rn_copy, n_n1l, n_n1r, ndiv_l, ndiv_r: bigNP;
        THE_NUML, THE_NUMR, THE_NUML_K, THE_NUMR_K: bigNP;
        k: integer;
        
    procedure copy_big_n(r: bigNP; var new_l, new_r: bigNP);
    var
        prev, dummy: bigNP;
    begin
        new(dummy);
        prev := dummy;
        while (r <> nil) do
        begin
            new(new_l);
            new_l^.val := r^.val;
            new_l^.r := prev;
            prev^.l := new_l;
            prev := new_l;
            r := r^.l;
        end;
        new_r := dummy^.l;
        new_r^.r := nil;
    end;
    
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
            add_bn_bn(res_m_r, cur_a_r, cur_a_l, cur_a_r);
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
    
    procedure int_to_k(int, k: integer; var resl_, resr_: bigNP);
    var
        resl, resr: bigNP;
    begin
        new(resr);
        resl := resr;
        while (int > 0) do
        begin
            resl^.val := int mod k;
            int := int div k;
            new(resl^.l);
            resl^.l^.r := resl;
            resl := resl^.l;
        end;
        if (resl^.val = 0) then
        begin
            resl^.r^.l := nil;
            resl := resl^.r;
        end;
        resl_ := resl;
        resr_ := resr;
    end;
    
    procedure concat_bn_bn(var bn_r: bigNP; int: bigNP);
    var 
        new_r := bn_r;
    begin
        while (int <> nil) do
        begin
            new(new_r);
            new_r^.val := int^.val;
            new_r^.l := bn_r;
            bn_r^.r := new_r;
            bn_r := new_r;
            int := int^.r;
        end;
    end;
    
    procedure div_by_2(n_l, n_r: bigNP; var res_l, res_r: bigNP);
    var
        resl, resr: bigNP;
    begin
        new(resr);
        resl := resr;
        while not ((n_r^.val < 2) and (n_r^.l = nil)) do
        begin
            subs_bn_int(n_r, 2);
            strip_bn(n_l);
            add_bn_int(resr, 1);
        end;
        while (resl^.l <> nil) do
            resl := resl^.l;
        res_l := resl;
        res_r := resr;
    end;
    
    procedure get_the_number(n_l, n_r: bigNP; k: integer; var resl, resr: bigNP);
    var
        mult_new_k_n1l, mult_new_k_n1r, mult_new_k_n2l, mult_new_k_n2r: bigNP;
        mult_bn_bn_l, mult_bn_bn_r, THATL, THATR: bigNP;
        new_k: integer;
    begin
        new_k := 2 * k + 1;
        mult_bn_int(n_r, mult_new_k_n1r, mult_new_k_n1l, new_k);
        mult_bn_int(n_r, mult_new_k_n2r, mult_new_k_n2l, new_k);
        add_bn_int(mult_new_k_n1r, k);
        add_bn_int(mult_new_k_n2r, k + 1);
        mult_bn_bn(mult_new_k_n1r, mult_new_k_n2r, mult_bn_bn_l, mult_bn_bn_r);
        div_by_2(mult_bn_bn_l, mult_bn_bn_r, THATL, THATR);
        resl := THATL;
        resr := THATR;
    end;

begin
    writeln('Введите число n');
    get_big_n(ln, rn);
    writeln('Ваше число: ');
    view_big_n(ln);
    copy_big_n(rn, ish_l, ish_r);
    copy_big_n(rn, ln_copy, rn_copy);
    
    writeln('Введите число k');
    readln(k);
    
    new(ln_k);
    new(rn_k); 
    writeln('n');
    view_big_n(rn);
    add_bn_int(rn, 1);
    writeln('n + 1');
    view_big_n(rn);
    mult_bn_bn(rn, rn_copy, n_n1l, n_n1r);
    writeln('n * (n + 1)');
    view_big_n(n_n1r);
    div_by_2(n_n1l, n_n1r, ndiv_l, ndiv_r);
    writeln('n * (n + 1) / 2');
    view_big_n(ndiv_r);
    bn_to_k(ndiv_l, ndiv_r, sqr((2 * k + 1)), ln_k, rn_k);
    writeln('n * (n + 1) / 2 в СЧ с осн. ', sqr((2 * k + 1)));
    view_big_n(rn_k); 
    int_to_k(((k + 1) * k) div 2, sqr(2 * k + 1), int_k_l, int_k_r);
    
    writeln('То что вышло в ходе склеивания');
    concat_bn_bn(rn_k, int_k_l);
    view_big_n(rn_k);
    
    writeln('То самое число в СЧ 10');
    get_the_number(ish_l, ish_r, k, THE_NUML, THE_NUMR);
    view_big_n(THE_NUMR);
    
    new(THE_NUML_K);
    new(THE_NUMR_K);
    writeln('То самое число в СЧ ', sqr(2 * k + 1));
    bn_to_k(THE_NUML, THE_NUMR, sqr(2 * k + 1), THE_NUML_K, THE_NUMR_K);
    view_big_n(THE_NUMR_K);
end.