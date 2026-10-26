library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_tx is
    generic (
        CLKS_PER_BIT : integer := 434 -- 50 МГц / 115200 бод = 434 такти на біт
    );
    port (
        clk       : in  std_logic;                    
        rst       : in  std_logic;                    
        tx_start  : in  std_logic;                    
        tx_din    : in  std_logic_vector(7 downto 0); 
        tx_active : out std_logic;                    
        tx_dout   : out std_logic;                    
        tx_done   : out std_logic                     
    );
end entity uart_tx;

architecture rtl of uart_tx is
    
    type state_type is (IDLE, START_BIT, DATA_BITS, STOP_BIT);
    signal state   : state_type := IDLE;

    
    signal clk_cnt : integer range 0 to CLKS_PER_BIT - 1 := 0;
    signal bit_idx : integer range 0 to 7 := 0;
    signal tx_reg  : std_logic_vector(7 downto 0) := (others => '0');
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                state     <= IDLE;
                clk_cnt   <= 0;
                bit_idx   <= 0;
                tx_reg    <= (others => '0');
                tx_dout   <= '1'; 
                tx_active <= '0';
                tx_done   <= '0';
            else
                tx_done <= '0';

                case state is
 
                    when IDLE =>
                        tx_dout   <= '1';
                        tx_active <= '0';
                        clk_cnt   <= 0;
                        bit_idx   <= 0;
                        if tx_start = '1' then
                            tx_reg    <= tx_din;
                            tx_active <= '1';
                            state     <= START_BIT;
                        end if;

                 
                    when START_BIT =>
                        tx_dout <= '0';
                        if clk_cnt < CLKS_PER_BIT - 1 then
                            clk_cnt <= clk_cnt + 1;
                        else
                            clk_cnt <= 0;
                            state   <= DATA_BITS;
                        end if;

                    
                    when DATA_BITS =>
                        tx_dout <= tx_reg(bit_idx);
                        if clk_cnt < CLKS_PER_BIT - 1 then
                            clk_cnt <= clk_cnt + 1;
                        else
                            clk_cnt <= 0;
                            if bit_idx < 7 then
                                bit_idx <= bit_idx + 1;
                            else
                                bit_idx <= 0;
                                state   <= STOP_BIT;
                            end if;
                        end if;

                    
                    when STOP_BIT =>
                        tx_dout <= '1';
                        if clk_cnt < CLKS_PER_BIT - 1 then
                            clk_cnt <= clk_cnt + 1;
                        else
                            clk_cnt   <= 0;
                            tx_done   <= '1';
                            tx_active <= '0';
                            state     <= IDLE;
                        end if;
                end case;
            end if;
        end if;
    end process;

end architecture rtl;