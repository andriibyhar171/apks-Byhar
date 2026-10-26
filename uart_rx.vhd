library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity uart_rx is
    generic (
        CLKS_PER_BIT : integer := 434 -- 50 МГц / 115200 бод = 434 такти на біт
    );
    port (
        clk      : in  std_logic;                    
        rst      : in  std_logic;                    
        rx_din   : in  std_logic;                    
        rx_valid : out std_logic;                    
        rx_dout  : out std_logic_vector(7 downto 0)  
    );
end entity uart_rx;

architecture rtl of uart_rx is
    
    type state_type is (IDLE, START_BIT, DATA_BITS, STOP_BIT);
    signal state   : state_type := IDLE;

    
    signal rx_sync1 : std_logic := '1';
    signal rx_sync2 : std_logic := '1';

    
    signal clk_cnt : integer range 0 to CLKS_PER_BIT - 1 := 0;
    signal bit_idx : integer range 0 to 7 := 0;
    signal rx_reg  : std_logic_vector(7 downto 0) := (others => '0');
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                state    <= IDLE;
                rx_sync1 <= '1';
                rx_sync2 <= '1';
                clk_cnt  <= 0;
                bit_idx  <= 0;
                rx_reg   <= (others => '0');
                rx_dout  <= (others => '0');
                rx_valid <= '0';
            else
                
                rx_sync1 <= rx_din;
                rx_sync2 <= rx_sync1;
                rx_valid <= '0';

                case state is
                    
                    when IDLE =>
                        clk_cnt <= 0;
                        bit_idx <= 0;
                        if rx_sync2 = '0' then
                            state <= START_BIT;
                        end if;

                   
                    when START_BIT =>
                        if clk_cnt = (CLKS_PER_BIT - 1) / 2 then
                            if rx_sync2 = '0' then
                                clk_cnt <= 0; 
                                state   <= DATA_BITS;
                            else
                                state   <= IDLE; 
                            end if;
                        else
                            clk_cnt <= clk_cnt + 1;
                        end if;

                    
                    when DATA_BITS =>
                        if clk_cnt < CLKS_PER_BIT - 1 then
                            clk_cnt <= clk_cnt + 1;
                        else
                            clk_cnt         <= 0;
                            rx_reg(bit_idx) <= rx_sync2;
                            if bit_idx < 7 then
                                bit_idx <= bit_idx + 1;
                            else
                                bit_idx <= 0;
                                state   <= STOP_BIT;
                            end if;
                        end if;

                    
                    when STOP_BIT =>
                        if clk_cnt < CLKS_PER_BIT - 1 then
                            clk_cnt <= clk_cnt + 1;
                        else
                            clk_cnt  <= 0;
                            rx_dout  <= rx_reg;
                            rx_valid <= '1';
                            state    <= IDLE;
                        end if;
                end case;
            end if;
        end if;
    end process;

end architecture rtl;