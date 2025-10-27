library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package types_pkg is
	constant MemSize : integer := 17; -- MemSize is 2**MemSize
	constant WordSize : integer := 2; -- WordSize is 2**WordSize
	constant MemLen : integer := 2**(MemSize-WordSize);
	constant AddressWidth : integer := 32;
	constant IOPorts : integer := 10;
	constant CacheBlockSize : integer := 4;
	
	subtype OneBit is unsigned(0 downto 0);
	subtype Byte is unsigned(7 downto 0);
	subtype Word is unsigned(8*2**WordSize-1 downto 0);
	subtype MemoryAddress is unsigned(AddressWidth-1 downto 0);
end package types_pkg;
