library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types_pkg.all;

entity RAM is
    port (
        clk              : in  std_logic;
        reset            : in  std_logic;

        data_addr        : in  MemoryAddress;
        we               : in  std_logic;
        data_in          : in  Word;
        data_out         : out Word;
        data_imm         : in  Word;
        load_instruction : in  std_logic;
        new_instruction  : in  std_logic
    );
end entity;

architecture rtl of RAM is

    constant ADDR_WIDTH : natural := 10;  -- 1024 words

    signal sel_addr : MemoryAddress;
    signal sel_data : Word;
    signal sel_we   : std_logic;

    signal q_ram : std_logic_vector(31 downto 0);

begin

    ------------------------------------------------------------------------
    -- Combinational input selection
    ------------------------------------------------------------------------
    process(load_instruction, data_imm, we, data_in, data_addr)
    begin
        sel_addr <= data_addr;
        sel_data <= data_in;
        sel_we   <= we;

        if load_instruction = '1' then
            sel_data <= data_imm;
            sel_we   <= '1';
        end if;
    end process;

    ------------------------------------------------------------------------
    -- RAM IP instantiation
    ------------------------------------------------------------------------
    u_ram_inst : entity work.RAM_1PORT
    port map (
        clock   => clk,
        address => std_logic_vector(sel_addr(ADDR_WIDTH-1 downto 0)),
        data    => std_logic_vector(sel_data),
        wren    => sel_we,
        q       => q_ram
    );

    ------------------------------------------------------------------------
    -- Convert RAM output to unsigned Word
    ------------------------------------------------------------------------
    data_out <= unsigned(q_ram);

end architecture;
