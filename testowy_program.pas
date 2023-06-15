program test;
      {test}
      const
            {test}
            PI = 3.14;
            STALA = 100.100;
            MAX_VALUE = 200;
            WARUNEK_TEKST = 'test';
      var
            {test}
            a, b, c, d, e, f, g, h, i, j, k, l, m, n: integer;
            tablica: array [2..10] of integer;
            testowa: real; 
            testowa2: integer;
      function funkcja (n:integer):integer; 
            begin
                  write('write test');
            end
      begin
      {komentarz testowy}
		write('test');
		writeln('test');
		read(a);
		readln(b);
            for wi:=1 to m do
                  begin
                        a:=wi;
                  end
	      if a > 0 and b >= 0 or c = 2 or b < 2 and d <= 10 or not d then
                  begin
                        write('test test');
                  end
            else 
                  begin
                        writeln('test test');
                  end;
            repeat
    		writeln('test');
    		liczba := liczba + 1;
            procedure testowa_procedura;
                  begin
                  writeln('NIE MA WARTOSCI OPTYMALNEJ');
                  halt
                  end;
  		until liczba > 10;
	      function funkcja (n:string):integer; 
		    begin
		          {zmienna2 to zmienna}
		          write(zmienna2);
	            end
	      function funkcjaaaa (n:boolean; s:integer):integer;
		    const
		          a=20;
		    var
		          a, i, j, k:integer;
		    begin
		          write('test');
                      if a = 0 then 
                        begin
                              write('test');
                        end
                        else 
                              begin
                                    writeln('test test');
                              end;
	            end
      end
end.
