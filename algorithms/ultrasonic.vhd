------ This is the ultrasonic range finding module ----
------- it measures the time of flight from the -------
---------- ultrasonic to the object and back ----------

-- Setup ----------------------------------------------
-- distance is sensed 20 times per second.
-- 38ms is the maximum echo pulse width when there are no obstructions.
-- 50Mhz Clock
-- trigger width 20(us)

  -- Aproximate values for range with 50Mhz Clock
  -- 20000 ===  60mm =  6cm
  -- 40000 === 120mm = 12cm
  -- 80000 === 240mm = 24cm
 -- 160000 === 480mm = 48cm
 -- 320000 === 960mm = 96cm

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.all;

entity ultrasonic is
port 
(
	clk	  : in std_logic;
	trig  : out std_logic;
  echo  : in  std_logic;
  dist  : out std_logic_vector(23 downto 0)
);

end entity;

architecture distance_measure of ultrasonic is
signal dist_f : integer range 0 to 2500000;
begin
process (clk)
	variable count1, dist_r : integer range 0 to 2500000;
	begin
		if (rising_edge(clk)) then
			count1 := count1 + 1;
			trig <= '0';
			if (count1 < 1000) then -- delay between triggers
			trig <= '1';
			dist_r := 0;
			elsif (echo = '1') then
			dist_r := dist_r + 1;
			elsif (count1 > 1000 and echo = '0') then
			dist_f <= dist_r;
			end if;
			if (count1 = 2500000) then    -- maximum sensing period.
			dist <= std_logic_vector(TO_UNSIGNED(dist_f, dist'length));
			count1 := 0;
				if dist_r >= 1900000 then  -- maximum echo time 38ms, if sensing is above that set distance to max
				dist <= (dist'range => '1');
				end if;
			end if;
		end if;
	end process;

end distance_measure;