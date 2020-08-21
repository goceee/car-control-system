---- This is a debouncer module ---------
---- it debounces the input signal ------
---- for a specific amount of time ------

---- In this case it is set to keep -----
---- the signal at its transitioned -----
-- value for at least 250 microseconds --

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity debounceP is
  port (
    clk    : in  std_logic;
    i_PulseD : in  std_logic;
    o_PulseD : out std_logic
    );
end entity debounceP;
 
architecture debouncer of debounceP is
 
  constant debounceTime : integer := 12500; -- Set for 12,500 clock ticks of 50 MHz clock (250 microseconds)
 
  signal counter : integer range 0 to debounceTime := debounceTime;
  signal sigState : std_logic := '0';
 
begin
 
  p_Debounce : process (clk) is
  begin
    if rising_edge(clk) then
 
      if (i_PulseD /= sigState and counter = debounceTime) then -- stop counter, should be stable
        sigState <= i_PulseD;
        counter <= 0;
		
      elsif counter < debounceTime then -- increase counter until debounceTime is reached.
        counter <= counter + 1;
 
      end if;
    end if;
  end process p_Debounce;
 
  o_PulseD <= sigState; -- assign debounced signal to output
 
end architecture debouncer;