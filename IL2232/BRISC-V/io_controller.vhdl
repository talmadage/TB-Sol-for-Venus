-- io_controller_stub.vhdl
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types_pkg.all;

entity io_controller is
    port (
        we       : in  std_logic;
        data_in  : in  Word;
        data_out : out Word;
        ports    : inout unsigned(IOPorts-1 downto 0)
    );
end entity;

architecture stub of io_controller is
begin
    data_out <= (others => '0');
end architecture;
