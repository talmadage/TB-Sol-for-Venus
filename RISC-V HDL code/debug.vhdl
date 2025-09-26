library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.dtekv_lib.all;

package debug is

  procedure print ( clk : std_logic; v0 : String);
  procedure printf ( v0 : String);
  procedure printc ( ascii : character);
  attribute foreign of printc : procedure is "VHPIDIRECT callback__printc";


  -- Function for loading a byte from memory
  function extern_loadword (byteadr : integer) return Word;
  function extern_loadbyte (byteadr : integer) return integer;
  attribute foreign of extern_loadbyte : function is "VHPIDIRECT callback_loadbyte";

  -- Function for storing a byte to memory
  procedure extern_writebyte (byteadr : integer; data : integer);
  attribute foreign of extern_writebyte : procedure is "VHPIDIRECT callback_writebyte";

 
  -- Tick function
  procedure tick (dummy : integer);
  attribute foreign of tick : procedure is "VHPIDIRECT callback__tick";
  procedure abort (dummy : integer);
  attribute foreign of abort : procedure is "VHPIDIRECT callback__abort";

  
end package debug;

package body debug is
  
  procedure printf ( v0 : String) is
    variable endofline : character;
  begin
    for i in 1 to v0'length loop
      printc(v0(i));
    end loop;
    endofline := lf;
    printc(endofline);
  end printf;

  procedure print (clk : std_logic; v0 : String) is
  begin
    if (clk='1') then
      printf(v0);
    end if;
  end print;
  
  procedure printc ( ascii : character) is
  begin
    assert false severity failure;
  end printc;

  
  procedure extern_writebyte (byteadr : integer; data : integer) is
  begin
    assert false severity failure;
  end extern_writebyte;

  function extern_loadbyte (byteadr : integer) return integer is
  begin
    assert false severity failure;
  end extern_loadbyte;

  function extern_loadword (byteadr : integer) return Word is
  begin
    return to_unsigned(extern_loadbyte(byteadr+3),8) & to_unsigned(extern_loadbyte(byteadr+2),8) & to_unsigned(extern_loadbyte(byteadr+1),8) & to_unsigned(extern_loadbyte(byteadr+0),8);
  end extern_loadword;


  procedure tick ( dummy : integer) is
  begin
    assert false severity failure;
  end tick;

  procedure abort ( dummy : integer) is
  begin
    assert false severity failure;
  end abort;

end package body;
