library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
 
entity UART_TB is
end UART_TB;
 
architecture Behave of UART_TB is
   
  -- Test Bench uses a 50 MHz Clock
  constant c_CLK_PERIOD : time := 20 ns;
  
  -- 9600 baud UART
  -- 50000000 / 9600 = 5208 Clocks Per Bit.
  constant delay : integer := 5208;
 
  constant c_BIT_PERIOD : time := 104160 ns;
   
  signal clk     : std_logic                    := '0';
  signal txDataValid     : std_logic                    := '0';
  signal txData   : std_logic_vector(7 downto 0) := (others => '0');
  signal tx : std_logic;
  signal txDone   : std_logic;
  signal txActive : std_logic;
  signal rxDataValid     : std_logic;
  signal rxData   : std_logic_vector(7 downto 0);
  signal rxS : std_logic := '1';
  signal rx : std_logic;
   
begin
 
  -- Instantiate UART transmitter
  UART_TX_INST : entity work.UART_TX
    generic map (
      delay => delay
      )
    port map (
      clk       => clk,
      I_txDataValid     => txDataValid,
      I_txData   => txData,
      O_txActive => txActive,
      O_tx => tx,
      O_txDone   => txDone
      );
	  
 
  -- Instantiate UART Receiver
  UART_RX_INST : entity work.UART_RX
    generic map (
      delay => delay
      )
    port map (
      clk       => clk,
      I_rx => rx,
      O_rxDataValid => rxDataValid,
      O_rxData   => rxData

      );
 
  rx <= tx when txActive = '1' else '1';
  clk <= not clk after c_CLK_PERIOD/2;
   
  process is
  begin
	wait for 20 ms;
    wait until rising_edge(clk);
    wait until rising_edge(clk);
    txDataValid   <= '1';
    txData <= X"61";
    wait until rising_edge(clk);
    txDataValid   <= '0';
    wait;
     
  end process;
   
end Behave;
