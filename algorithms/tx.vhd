--------------------------------------------
--This is the transmitter part of the UART--
-- transmits the data bit by bit with the --
---- use of a delay in order to achieve ----
------------- 9600 baud rate ---------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UART_TX is
  generic (
    delay : integer := 5208
    );
  port (
    clk       		: in  std_logic;
    I_txDataValid   : in  std_logic;
    I_txData    	: in  std_logic_vector(7 downto 0);
    O_txActive  	: out std_logic;
    O_tx 			: out std_logic;
    O_txDone   		: out std_logic
    );
end UART_TX;


architecture transmitter of UART_TX is

  type stateType is (idle, start_Bit, transmit_Data, stop_Bit, cleanup);
  signal nextState : stateType := idle;

  signal clk_Count : integer range 0 to delay-1 := 0;
  signal bit_Index : integer range 0 to 7 := 0;  -- 8 Bits Total
  signal r_txData   : std_logic_vector(7 downto 0) := (others => '0');
  signal r_txDone   : std_logic := '0';
  
begin

  
  transmitterProc : process (clk)
  begin
    if rising_edge(clk) then
        
      case nextState is

        when idle =>
          O_txActive <= '0';
          O_tx <= '1';         
          r_txDone   <= '0';
          clk_Count <= 0;
          bit_Index <= 0;

          if I_txDataValid = '1' then -- if the data is valid start transmitting
            r_txData <= I_txData;
            nextState <= start_Bit;
          else
            nextState <= idle;
          end if;

        when start_Bit => -- send out the start bit = 0
          O_txActive <= '1';
          O_tx <= '0';

          if clk_Count < delay-1 then -- delay-1 clock cycles the start bit to achieve 9600baud
            clk_Count <= clk_Count + 1;
            nextState   <= start_Bit;
          else
            clk_Count <= 0;
            nextState   <= transmit_Data;
          end if;
         
        when transmit_Data =>
          O_tx <= r_txData(bit_Index);
          
          if clk_Count < delay-1 then	-- send out a bit and wait delay-1 clock cycles before sending the next one 
            clk_Count <= clk_Count + 1;
            nextState   <= transmit_Data;
          else
            clk_Count <= 0;
            
            if bit_Index < 7 then -- if not all bits have been sent, transmit
              bit_Index <= bit_Index + 1;
              nextState   <= transmit_Data;
            else				
              bit_Index <= 0;
              nextState   <= stop_Bit;
            end if;
          end if;

        when stop_Bit => -- send out the stop bit = 1
          O_tx <= '1';
          if clk_Count < delay-1 then -- delay-1 clock cycles the stop bit
            clk_Count <= clk_Count + 1;
            nextState   <= stop_Bit;
          else
            r_txDone   <= '1';
            clk_Count <= 0;
            nextState   <= cleanup;
          end if;

                  
        
        when cleanup => -- cleanup to restart
          O_txActive <= '0';
          r_txDone   <= '1';
          nextState   <= idle;
          
            
        when others =>
          nextState <= idle;

      end case;
    end if;
  end process transmitterProc;

  O_txDone <= r_txDone;
  
end transmitter;
