library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types_pkg.all;

entity io_controller is
    port (
        clk       : in  std_logic;
        we        : in  std_logic;
        data_in   : in  Word;           -- 32 bits to write
        data_out  : out Word;           -- 32 bits read
        ports_out : out unsigned(IOPorts-1 downto 0);  -- Output to GPIO
        ports_in  : in  unsigned(IOPorts-1 downto 0)   -- Input from GPIO
    );
end entity;

architecture rtl of io_controller is
    
    -- Internal registers
    signal tx_buffer    : Word := (others => '0');
    signal rx_buffer    : Word := (others => '0');
    signal bit_counter  : integer range 0 to 31 := 0;
    
    -- Control signals (mapped to GPIO)
    signal tx_data      : unsigned(7 downto 0) := (others => '0');  -- 8-bit parallel data
    signal rx_data      : unsigned(7 downto 0);                      -- 8-bit parallel data
    signal tx_valid     : std_logic := '0';                          -- TX data valid signal
    signal rx_ready     : std_logic;                                 -- RX ready signal
    
    -- State machine for transmission/reception
    type state_type is (IDLE, TX_SEND, RX_RECEIVE, DONE);
    signal state : state_type := IDLE;
    
    signal tx_count : integer range 0 to 4 := 0;  -- Counts 4 transfers of 8 bits
    signal rx_count : integer range 0 to 4 := 0;

begin

    -- ================================================================
    -- GPIO MAPPING
    -- ================================================================
    -- GPIO Pin 0-7: Bidirectional data (8 parallel bits)
    -- GPIO Pin 8:   TX_VALID (output - indicates valid output data)
    -- GPIO Pin 9:   RX_READY (input - indicates ready input data)
    -- ================================================================
    
    -- Output assignments
    ports_out(7 downto 0) <= tx_data;
    ports_out(8) <= tx_valid;
    ports_out(9) <= '0';  -- Not used for output
    
    -- Input assignments
    rx_data <= ports_in(7 downto 0);
    rx_ready <= ports_in(9);

    process(clk)
    begin
        if rising_edge(clk) then
            
            case state is

                when IDLE =>
                    tx_valid <= '0';
                    
                    -- Write request
                    if we = '1' then
                        tx_buffer <= data_in;
                        tx_count <= 0;
                        state <= TX_SEND;
                    
                    -- Read request (RX_READY active)
                    elsif rx_ready = '1' then
                        rx_count <= 0;
                        state <= RX_RECEIVE;
                    end if;
                
                when TX_SEND =>
                    
                    -- Select which byte to transmit (0-3)
                    case tx_count is
                        when 0 => tx_data <= tx_buffer(7 downto 0);    -- Byte 0 (LSB)
                        when 1 => tx_data <= tx_buffer(15 downto 8);   -- Byte 1
                        when 2 => tx_data <= tx_buffer(23 downto 16);  -- Byte 2
                        when 3 => tx_data <= tx_buffer(31 downto 24);  -- Byte 3 (MSB)
                        when others => tx_data <= (others => '0');
                    end case;
                    
                    tx_valid <= '1';  -- Signal valid data
                    
                    -- Wait for receiver to acknowledge (RX_READY goes low)
                    if rx_ready = '0' then
                        if tx_count < 3 then
                            tx_count <= tx_count + 1;
                        else
                            state <= DONE;
                        end if;
                    end if;
                
                when RX_RECEIVE =>
                    
                    -- Wait for RX_READY to be high (data ready)
                    if rx_ready = '1' then
                        
                        -- Store received byte in correct position
                        case rx_count is
                            when 0 => rx_buffer(7 downto 0)   <= rx_data;
                            when 1 => rx_buffer(15 downto 8)  <= rx_data;
                            when 2 => rx_buffer(23 downto 16) <= rx_data;
                            when 3 => rx_buffer(31 downto 24) <= rx_data;
                            when others => null;
                        end case;
                        
                        if rx_count < 3 then
                            rx_count <= rx_count + 1;
                        else
                            data_out <= rx_buffer;
                            state <= DONE;
                        end if;
                    end if;
                
                when DONE =>
                    tx_valid <= '0';
                    state <= IDLE;
                
            end case;
            
        end if;
    end process;

end architecture;