library ieee;
use ieee.std_logic_1164.all;

entity uart_top is
    generic (
        CLKS_PER_BIT : integer := 434
    );
    port (
        clk       : in  std_logic;
        rst       : in  std_logic;
        tx_start  : in  std_logic;
        tx_din    : in  std_logic_vector(7 downto 0);
        tx_active : out std_logic;
        tx_dout   : out std_logic;
        tx_done   : out std_logic;
        rx_din    : in  std_logic;
        rx_valid  : out std_logic;
        rx_dout   : out std_logic_vector(7 downto 0)
    );
end entity uart_top;

architecture structural of uart_top is
begin
    u_tx : entity work.uart_tx
        generic map (
            CLKS_PER_BIT => CLKS_PER_BIT
        )
        port map (
            clk       => clk,
            rst       => rst,
            tx_start  => tx_start,
            tx_din    => tx_din,
            tx_active => tx_active,
            tx_dout   => tx_dout,
            tx_done   => tx_done
        );

    u_rx : entity work.uart_rx
        generic map (
            CLKS_PER_BIT => CLKS_PER_BIT
        )
        port map (
            clk      => clk,
            rst      => rst,
            rx_din   => rx_din,
            rx_valid => rx_valid,
            rx_dout  => rx_dout
        );
end architecture structural;