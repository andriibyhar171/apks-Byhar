library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_tb is
end entity uart_tb;

architecture sim of uart_tb is
    constant CLK_PERIOD   : time    := 20 ns;
    constant CLKS_PER_BIT : integer := 434;

    signal clk         : std_logic := '0';
    signal rst         : std_logic := '1';
    signal tx_start    : std_logic := '0';
    signal tx_din      : std_logic_vector(7 downto 0) := (others => '0');
    signal tx_active   : std_logic;
    signal tx_done     : std_logic;
    signal serial_line : std_logic;
    signal rx_valid    : std_logic;
    signal rx_dout     : std_logic_vector(7 downto 0);
begin

    uut : entity work.uart_top
        generic map (
            CLKS_PER_BIT => CLKS_PER_BIT
        )
        port map (
            clk       => clk,
            rst       => rst,
            tx_start  => tx_start,
            tx_din    => tx_din,
            tx_active => tx_active,
            tx_dout   => serial_line,
            tx_done   => tx_done,
            rx_din    => serial_line, 
            rx_valid  => rx_valid,
            rx_dout   => rx_dout
        );

    clk_process : process
    begin
        clk <= '0';
        wait for CLK_PERIOD / 2;
        clk <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    stim_proc : process
    begin

        rst <= '1';
        wait for CLK_PERIOD * 5;
        rst <= '0';
        wait for CLK_PERIOD * 5;


        tx_din   <= x"A5";
        tx_start <= '1';
        wait for CLK_PERIOD;
        tx_start <= '0';

        wait until rx_valid = '1';
        assert rx_dout = x"A5" report "Error receiving byte 0xA5!" severity error;
        wait for CLK_PERIOD * 20;


        tx_din   <= x"3C";
        tx_start <= '1';
        wait for CLK_PERIOD;
        tx_start <= '0';

        wait until rx_valid = '1';
        assert rx_dout = x"3C" report "Error receiving byte 0x3C!" severity error;

        wait for CLK_PERIOD * 50;
        report "UART simulation finished successfully! Both bytes received correctly." severity note;
        std.env.stop;
    end process;

end architecture sim;