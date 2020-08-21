-------------------------------------------
-- This is the receiver part of the UART --
-- receives the data bit by bit with the --
---- use of a delay in order to achieve ----
------------- 9600 baud rate ---------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity UART_RX is
  generic (
    delay : integer := 5208
    );
  port (
    clk       	 : in  std_logic;
    I_rx        	 : in  std_logic;
    O_rxDataValid    : out std_logic;
    O_rxData    	 : out std_logic_vector(7 downto 0)
    );
end UART_RX;


architecture receiver of UART_RX is

  type stateType is (idle, start_Bit, receive_Data, stop_Bit, cleanup);
  signal nextState : stateType := idle;
  
  signal clk_Count 		: integer range 0 to delay-1;
  signal bit_Index 		: integer range 0 to 7;  -- 8 Bits Total
  signal r_rxData   	: std_logic_vector(7 downto 0);
  signal r_rxDone     	: std_logic;
  
begin

  receiverProc : process (clk)
  begin
    if rising_edge(clk) then
        
      case nextState is

        when idle =>
          r_rxDone    <= '0';
          clk_Count <= 0;
          bit_Index <= 0;

          if I_rx = '0' then -- start bit detection
            nextState <= start_Bit;
          else
            nextState <= idle;
          end if;

        when start_Bit =>
          if clk_Count = (delay-1)/2 then -- check middle of start bit to make sure it is not an error
            if I_rx = '0' then
              clk_Count <= 0;
              nextState   <= receive_Data;
            else
              nextState   <= idle;
            end if;
          else
            clk_Count <= clk_Count + 1;
            nextState   <= start_Bit;
          end if;

        when receive_Data =>
          if clk_Count < delay-1 then -- wait delay-1 clock cycles before receiving a bit to achieve 9600baud
            clk_Count <= clk_Count + 1;
            nextState   <= receive_Data;
          else
            clk_Count            <= 0;
            r_rxData(bit_Index) <= I_rx;
            
            if bit_Index < 7 then -- if not all bits have been received, receive
              bit_Index <= bit_Index + 1;
              nextState   <= receive_Data;
            else
              bit_Index <= 0;
              nextState   <= stop_Bit;
            end if;
          end if;

        when stop_Bit => -- receive the stop bit = 1
          if clk_Count < delay-1 then -- delay-1 clock cycles the stop bit
            clk_Count <= clk_Count + 1;
            nextState   <= stop_Bit;
          else
            r_rxDone     <= '1';
            clk_Count <= 0;
            nextState   <= cleanup;
          end if;
     
        when cleanup => -- cleanup before reset
          nextState <= idle;
          r_rxDone   <= '0';
     
        when others =>
          nextState <= idle;

      end case;
    end if;
  end process receiverProc;

  O_rxDataValid <= r_rxDone;
  O_rxData <= r_rxData;
   
end receiver;
