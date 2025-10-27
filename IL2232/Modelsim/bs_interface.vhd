library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types_pkg.all;

entity bs_interface is
	port (	clk				: in std_logic;
			com_enable		: in std_logic;
			m_active		: in std_logic;
			tx_data			: in unsigned(1 downto 0);
			addr			: in unsigned(1 downto 0);
			s_active		: out std_logic;
			rx_data			: out unsigned(1 downto 0);

			data_addr		: out MemoryAddress;
			we				: out std_logic;
			data4mem		: in Word;					-- Data from memory
			data2mem		: out Word;					-- Data to memory
			data4io			: in Word;					-- Data from IO 
			data2io			: out Word					-- Data to IO 
		 );
end entity;

architecture Behavioral of bs_interface is

    type state_type is (IDLE, WR_TX, WR_WAIT_ACK, WR_WAIT_NACK, RD_TX_ADDR, RD_WAIT_ACK, RD_WAIT_NACK, RD_TX_DATA);
	signal current_state		: state_type := IDLE;
	signal burst				: std_logic := '0';
	signal mode					: unsigned(1 downto 0) := "00";
	signal counter				: integer range 0 to 2**(3+WordSize) := 2**(3+WordSize);
	signal br_counter			: integer range 0 to CacheBlockSize := CacheBlockSize; -- Burst read counter
	signal target_addr			: MemoryAddress := (others => '0');
	signal data_packet			: Word := (others => '0');
	signal parity_check_data	: unsigned(1 downto 0) := (others => '0');
	signal parity_check_addr	: unsigned(1 downto 0) := (others => '0');
	signal we_reg				: std_logic := '0';

begin

    -- State transition process
    process(clk)
    begin
		if rising_edge(clk) then
			case current_state is
				when IDLE =>
					s_active <= '0';
					we_reg <= '0';
					rx_data <= (others => '0');
					if com_enable = '1' and m_active = '1' then 
						target_addr <= (others => '0');
						parity_check_data <= (others => '0');
						parity_check_addr <= (others => '0');
						counter <= 2**(3+WordSize);
						mode <= addr;
						case addr is
							when "00" =>
								current_state <= WR_TX;
							when "01" =>
								current_state <= WR_TX;
							when "10" =>
								current_state <= RD_TX_ADDR;
							when "11" =>
								current_state <= RD_TX_ADDR;
								br_counter <= CacheBlockSize;
							when others =>
								current_state <= IDLE;
						end case;
					end if;

				when WR_TX =>
					if (counter = 0) then
						-- Parity check:
						if parity_check_data /= tx_data then 
							current_state <= WR_WAIT_NACK;
							burst <= '0';
						elsif burst = '0' and parity_check_addr /= addr then
							current_state <= WR_WAIT_NACK;
						else
							s_active <= '1';
							current_state <= WR_WAIT_ACK;
							burst <= '0';
						end if;
					else
						parity_check_data <= parity_check_data xor tx_data;
						parity_check_addr <= parity_check_addr xor addr;
						data_packet(33-counter) <= tx_data(0);
						data_packet(32-counter) <= tx_data(1);
						if burst = '0' then
							target_addr(33-counter) <= addr(0);
							target_addr(32-counter) <= addr(1);
						end if;
						counter <= counter - 2;
					end if;

				when WR_WAIT_ACK =>
					if (mode = "00" or (mode = "01" and burst = '0')) and we_reg = '0' then
						s_active <= '1';
						we_reg <= '1';

					elsif mode = "00" then
						we_reg <= '0';
						current_state <= IDLE;
					elsif mode = "01" and burst = '0' then
						s_active <= '1';
						burst <= '1';
					elsif mode = "01" and burst = '1' then
						s_active <= '0';
						we_reg <= '0';
						if com_enable = '1' and m_active = '1' then
							current_state <= WR_TX;
							target_addr <= target_addr + to_unsigned(2**WordSize, MemoryAddress'length);
							parity_check_data <= (others => '0');
							parity_check_addr <= (others => '0');
							data_packet <= (tx_data & (Word'length - 3 downto 0 => '0'));
							counter <= 2**(3+WordSize) - 2;
						else
							burst <= '0';
							current_state <= IDLE;
						end if;
					end if;

				when WR_WAIT_NACK =>
					s_active <= '0';
					current_state <= IDLE;

				when RD_TX_ADDR =>
					if (counter = 0) then
						-- Parity check:
						if parity_check_addr /= addr then
							current_state <= RD_WAIT_NACK;
						else
							current_state <= RD_WAIT_ACK;
							s_active <= '1';
						end if;
					else
						parity_check_addr <= parity_check_addr xor addr;
						target_addr(33-counter) <= addr(0);
						target_addr(32-counter) <= addr(1);
						counter <= counter - 2;
					end if;

				when RD_WAIT_ACK =>
					current_state <= RD_TX_DATA;
					counter <= 2**(3+WordSize);
					target_addr <= target_addr;
					if target_addr = ('1' & (MemoryAddress'length - 2 downto 0 => '0')) then
						data_packet <= data4io;
					else
						data_packet <= data4mem;
					end if;

				when RD_WAIT_NACK =>
					s_active <= '0';
					current_state <= IDLE;
				
				when RD_TX_DATA =>
					if counter = 0 then
						current_state <= IDLE;
						rx_data <= parity_check_data;
					else
						if counter = 2 and mode = "11" then
							if br_counter /= 1 then
								br_counter <= br_counter - 1;
								counter <= 2**(3+WordSize);
								target_addr <= target_addr + to_unsigned(2**WordSize, MemoryAddress'length);
								if target_addr = ('1' & (MemoryAddress'length - 2 downto 0 => '0')) then
									data_packet <= data4io;
								else
									data_packet <= data4mem;
								end if;
							end if;
						else
							counter <= counter - 2;
						end if;
						parity_check_data <= parity_check_data xor data_packet(counter-1 downto counter-2);
						rx_data(0) <= data_packet(33-counter);
						rx_data(1) <= data_packet(32-counter);
					end if;

			end case;
		end if;
    end process;

	we <= we_reg;
	data_addr <= target_addr;

	data2io <= data_packet when current_state = WR_WAIT_ACK and burst = '0' and target_addr = ('1' & (MemoryAddress'length - 2 downto 0 => '0')) else (others => '0');

	data2mem <= data_packet when current_state = WR_WAIT_ACK and burst = '0' and target_addr /= ('1' & (MemoryAddress'length - 2 downto 0 => '0')) else (others => '0');

end Behavioral;
