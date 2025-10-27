LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.NUMERIC_STD.all;
ENTITY memory IS
   GENERIC(Nr_Of_Ports:INTEGER;
           Mem_Size:INTEGER;
	   Address_Size:INTEGER;
           Data_Size:INTEGER);
   PORT(address:IN std_logic_vector(Nr_Of_Ports*Address_Size-1 downto 0);
        data:INOUT std_logic_vector(Nr_Of_Ports*Data_Size-1 downto 0);
        ce:IN std_logic_vector(Nr_Of_Ports-1 downto 0);
        re:IN std_logic_vector(Nr_Of_Ports-1 downto 0);
        wr:IN std_logic_vector(Nr_Of_Ports-1 downto 0));
END memory;
ARCHITECTURE program OF memory IS
   TYPE mem_array IS ARRAY (Mem_Size-1 downto 0) OF std_logic_vector(Data_Size-1 downto 0);
--   SIGNAL int_ce:std_logic;
BEGIN
   -- pragma synthesis_off
--   int_ce <= 'L';
--   int_ce <= ce;
--   PROCESS (address,data,rw,int_ce)
   PROCESS (address,data,re,wr,ce)
      VARIABLE memory_Var:mem_array;
   BEGIN
      FOR i IN Nr_Of_Ports-1 DOWNTO 0 LOOP
         IF (ce(i)='1') THEN
            IF (re(i)='1') THEN
               data((i+1)*Data_Size-1 DOWNTO i*Data_Size) <= memory_var(to_integer(unsigned(address((i+1)*Address_Size-1 DOWNTO i*Address_Size))));
            ELSIF (wr(i)='1') THEN
               memory_Var(to_integer(unsigned(address((i+1)*Address_Size-1 DOWNTO i*Address_Size)))) := data((i+1)*Data_Size-1 DOWNTO i*Data_Size);
            END IF;
         ELSE
            data((i+1)*Data_Size-1 DOWNTO i*Data_Size) <= (others =>'Z');
         END IF;
      END LOOP;
   END PROCESS;
   -- pragma synthesis_on
END program;

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
--library SYNT;
--use SYNT.STD_LOGIC_ARITH.all;
PACKAGE program_package IS
  
  -- All these functions are made to simplify conversions - L(R)V'96
  -- Additional conversion functions (declarations)
  function conv_boolean (a: signed) return boolean;
  function conv_boolean (a: unsigned) return boolean;
  function conv_signed (a: bit; l: integer) return signed;
  function conv_unsigned (a: bit; l: integer) return unsigned;
  function conv_signed (a: boolean; l: integer) return signed;
  function conv_unsigned (a: boolean; l: integer) return unsigned;
  -- Additional operations (declarations)
  function "and" (l,r: signed) return signed;
  function "and" (l,r: unsigned) return unsigned;
  function "nand" (l,r: signed) return signed;
  function "nand" (l,r: unsigned) return unsigned;
  function "or" (l,r: signed) return signed;
  function "or" (l,r: unsigned) return unsigned;
  function "nor" (l,r: signed) return signed;
  function "nor" (l,r: unsigned) return unsigned;
  function "xor" (l,r: signed) return signed;
  function "xor" (l,r: unsigned) return unsigned;
  function "not" (a: signed) return signed;
  function "not" (a: unsigned) return unsigned;
  
  function insert_bit(t:unsigned;b:std_logic;w:unsigned) return unsigned;
  function extract_bit(t:unsigned;w:unsigned) return unsigned;

  function add(l:std_logic_vector;r:std_logic_vector) return std_logic_vector;
  function subtract(l:std_logic_vector;r:std_logic_vector) return std_logic_vector;
  function multiply(l:std_logic_vector;r:std_logic_vector) return std_logic_vector;
  function divide(l:std_logic_vector;r:std_logic_vector) return std_logic_vector;
  function equ(l:std_logic_vector;r:std_logic_vector) return boolean;
  function neq(l:std_logic_vector;r:std_logic_vector) return boolean;
  function gte(l:std_logic_vector;r:std_logic_vector) return boolean;
  function gt (l:std_logic_vector;r:std_logic_vector) return boolean;
  function lte(l:std_logic_vector;r:std_logic_vector) return boolean;
  function lt (l:std_logic_vector;r:std_logic_vector) return boolean;

  function GetElement(a,sel:std_logic_vector;asize,bsize:natural) return std_logic_vector;
  function GetElement(a:std_logic_vector;sel,asize,bsize:natural) return std_logic_vector;
END program_package;

PACKAGE BODY program_package IS
  
  -- All these functions are made to simplify conversions - L(R)V'96
  -- Additional conversion functions (for pakage body)
  function conv_boolean (a: signed) return boolean is
  begin if to_bit(a(a'low))='1' then return TRUE; else return FALSE; end if;
  end conv_boolean;
  function conv_boolean (a: unsigned) return boolean is
  begin if to_bit(a(a'low))='1' then return TRUE; else return FALSE; end if;
  end conv_boolean;
  function conv_signed (a: bit; l: integer) return signed is
  begin return conv_signed(to_stdulogic(a),l);
  end conv_signed;
  function conv_unsigned (a: bit; l: integer) return unsigned is
  begin return conv_unsigned(to_stdulogic(a),l);
  end conv_unsigned;
  function conv_signed (a: boolean; l: integer) return signed is
    variable t: bit;
  begin if a then t:='1'; else t:='0'; end if; return conv_signed(t,l);
  end conv_signed;
  function conv_unsigned (a: boolean; l: integer) return unsigned is
    variable t: bit;
  begin if a then t:='1'; else t:='0'; end if; return conv_unsigned(t,l);
  end conv_unsigned;
  -- Additional operations (declarations)
  function "and" (l,r: signed) return signed is
  begin return signed(std_logic_vector(l) and std_logic_vector(r)); end;
  function "and" (l,r: unsigned) return unsigned is
  begin return unsigned(std_logic_vector(l) and std_logic_vector(r)); end;
  function "nand" (l,r: signed) return signed is
  begin return signed(std_logic_vector(l) nand std_logic_vector(r)); end;
  function "nand" (l,r: unsigned) return unsigned is
  begin return unsigned(std_logic_vector(l) nand std_logic_vector(r)); end;
  function "or" (l,r: signed) return signed is
  begin return signed(std_logic_vector(l) or std_logic_vector(r)); end;
  function "or" (l,r: unsigned) return unsigned is
  begin return unsigned(std_logic_vector(l) or std_logic_vector(r)); end;
  function "nor" (l,r: signed) return signed is
  begin return signed(std_logic_vector(l) nor std_logic_vector(r)); end;
  function "nor" (l,r: unsigned) return unsigned is
  begin return unsigned(std_logic_vector(l) nor std_logic_vector(r)); end;
  function "xor" (l,r: signed) return signed is
  begin return signed(std_logic_vector(l) xor std_logic_vector(r)); end;
  function "xor" (l,r: unsigned) return unsigned is
  begin return unsigned(std_logic_vector(l) xor std_logic_vector(r)); end;
  function "not" (a: signed) return signed is
  begin return signed(not std_logic_vector(a)); end;
  function "not" (a: unsigned) return unsigned is
  begin return unsigned(not std_logic_vector(a)); end;

  function insert_bit(t:unsigned;b:std_logic;w:unsigned) return unsigned is
     variable ret:unsigned(t'range);
     variable where:integer;
  begin
     ret:=t;
     where:=conv_integer(unsigned(w));
     ret(where):=b;
     return ret;
  end;
  function extract_bit(t:unsigned;w:unsigned) return unsigned is
     variable ret:unsigned(0 downto 0);
     variable where:integer;
  begin
     where:=conv_integer(unsigned(w));
     ret(0):=t(where);
     return ret;
  end;

  function add(l:std_logic_vector;r:std_logic_vector) return std_logic_vector is
  begin
     return std_logic_vector'(unsigned(l)+unsigned(r));
  end;

  function subtract(l:std_logic_vector;r:std_logic_vector) return std_logic_vector is
  begin
     return std_logic_vector'(unsigned(l)-unsigned(r));
  end;

  function multiply(l:std_logic_vector;r:std_logic_vector) return std_logic_vector is
  begin
     return std_logic_vector'(unsigned(l)*unsigned(r));
  end;

  function divide(l:std_logic_vector;r:std_logic_vector) return std_logic_vector is
  begin
     -- Cheating...
     return std_logic_vector'(unsigned(l)*unsigned(r));
  end;

  function equ(l:std_logic_vector;r:std_logic_vector) return boolean is
  begin
     return l=r;
  end;

  function neq(l:std_logic_vector;r:std_logic_vector) return boolean is
  begin
     return l/=r;
  end;

  function gte(l:std_logic_vector;r:std_logic_vector) return boolean is
  begin
     return unsigned(l)>=unsigned(r);
  end;

  function gt (l:std_logic_vector;r:std_logic_vector) return boolean is
  begin
     return unsigned(l)>unsigned(r);
  end;

  function lte(l:std_logic_vector;r:std_logic_vector) return boolean is
  begin
     return unsigned(l)<=unsigned(r);
  end;

  function lt (l:std_logic_vector;r:std_logic_vector) return boolean is
  begin
     return unsigned(l)<unsigned(r);
  end;

  function GetElement(a,sel:std_logic_vector;asize,bsize:natural) return std_logic_vector is
     variable ret:std_logic_vector(bsize-1 downto 0);
     variable elem:natural;
  begin
     elem:=conv_integer(unsigned(sel));
     for i in asize-1 downto 0 loop
        if (elem=i) then
	   ret:=a(i*bsize+bsize-1 downto i*bsize+0);
	end if;
     end loop;
     return ret;
   end;

  function GetElement(a:std_logic_vector;sel,asize,bsize:natural) return std_logic_vector is
     variable ret:std_logic_vector(bsize-1 downto 0);
  begin
     for i in asize-1 downto 0 loop
        if (sel=i) then
	   ret:=a(i*bsize+bsize-1 downto i*bsize+0);
	end if;
     end loop;
     return ret;
   end;
END program_package;


