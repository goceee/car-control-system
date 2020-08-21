----- This is the period measuring module ----
----- as its name states it measures the -----
------------ period between pulses -----------

------ Period can be calculated in ms --------
-- DAT_O (Period) / 50000 for a 50Mhz clock --

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pulseM is
port (DAT_O : out integer range 0 to 2000000000;
      Pulse_I : in std_logic;   
      clk : in std_logic);
end pulseM;
architecture Behavioral of pulseM is

signal countStayW, countStayB : integer range 0 to 200000000;

signal StartC : std_logic := '0';
signal Curr_Count : integer range 0 to 2000000000;
signal countP : integer range 0 to 5;
signal o_pulse : std_logic;
signal delS : integer range 0 to 5;
signal o_PulseD : std_logic;

begin

RisingEdge: entity work.edge_detector
   port map(
	  clk => clk,		
	  i_pulse => o_PulseD,
	  o_pulse => o_pulse);
	  
DebounceSignal : entity work.debounceP
	port map(
		clk => clk,
		i_PulseD => Pulse_I,
		o_PulseD => o_PulseD);
 
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

process(clk)
begin
    if(rising_edge(clk)) then
        if(StartC = '1') then -- pulse detected, start measuring the pulse using a counter
			Curr_Count <= Curr_Count + 1;
			if(o_pulse = '1') then -- if a second pulse is detected output data and reset counter
				DAT_O <= Curr_Count;
				Curr_Count <= 1;
			end if;
		else 
		    Curr_Count <= 0;
            DAT_O <= 0;
		end if;	
	end if;
end process;

------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

process(clk)
begin
	if (rising_edge(clk)) then
		if (delS  < 3) then -- delay the pulse counting, in order to avoid counting a pulse in the beginning
		delS <= delS + 1;
		elsif (delS = 3) then
		delS <= 3+1;
		else
		
		if(o_pulse = '1') then -- when a pulse is detected start the measurements
			StartC <= '1';
		end if;
		
		if (countStayB = 50000000 or countStayW = 50000000) then -- detect if the car has stopped
			countStayW <= 0;
			countStayB <= 0;
			StartC <= '0';
			countP <= 0;
		elsif (Pulse_I <= '0' and countStayW < 50000000) then -- if the car has stopped and white line is detected
			countStayB <= 0;
			countStayW <= countStayW + 1;
		elsif (Pulse_I <= '1' and countStayB < 50000000) then -- if the car has stopped and black line is detected
			countStayW <= 0;
			countStayB <= countStayB + 1;
		end if;
	end if;    
	end if;
end process;
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

end Behavioral;