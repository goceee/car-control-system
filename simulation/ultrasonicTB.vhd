LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY tbBu IS
END tbBu;
ARCHITECTURE behavior OF tbBu IS 
   --Inputs
   signal echo : std_logic := '0';
   signal clk : std_logic := '0';
   signal trig : std_logic;
   signal dist : std_logic_vector(23 downto 0);
   -- Clock period definitions
   constant clk_period : time := 20 ns;
BEGIN
    -- Instantiate the Unit Under Test (UUT)
   uut: entity work.ultrasonic
   port map (echo => echo,
			 dist => dist,
			 trig => trig,
			 clk => clk);
   -- Clock process definitions
   clk_process :process
   begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
   end process;
   -- Stimulus process
   stim_proc: process
   begin
		wait for 5 ms;
        wait until trig = '1';
		echo <= '1';
		wait for 30 ms;
		echo <= '0';
		wait until trig = '1';
		echo <= '1';
		wait for 20 ms;
		echo <= '0';
		wait until trig = '1';
		echo <= '1';
		wait for 34 ms;
		echo <= '0';
		wait until trig = '1';
		echo <= '1';
		wait for 25 ms;
		echo <= '0';
		wait;
   end process;
END;