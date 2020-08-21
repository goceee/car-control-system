LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY tbBn IS
END tbBn;
ARCHITECTURE behavior OF tbBn IS 
   --Inputs
   signal pulse_I : std_logic:='1';
   signal clk : std_logic := '0';
   signal speed : integer range 0 to 300;
   -- Clock period definitions
   constant clk_period : time := 20 ns;
BEGIN
    -- Instantiate the Unit Under Test (UUT)
   uut: entity work.speed_calc
   port map (speed => speed,
			 pulse_I => pulse_I,
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
        Pulse_I <= '1';
         wait for 30 ms;
         Pulse_I <= '0';
         wait for 20 ms;
         Pulse_I <= '1';
		 wait for 30 ms; 
		 Pulse_I <= '0';
		 wait for 20 ms;
		 Pulse_I <= '1';
		 wait for 20 ms;
		 Pulse_I <= '0';
		 wait for 35 ms;
		 Pulse_I <= '1';
		 wait for 50 ms; --1
		 Pulse_I <= '0';
		 wait for 50 ms;
		 Pulse_I <= '1';
		 wait for 12 ms;
		 Pulse_I <= '0';
		 wait for 50 ms;
		 Pulse_I <= '1';
		 wait for 10 ms;
		 Pulse_I <= '0';
		 wait for 50 ms; --2
		 Pulse_I <= '1';
		 wait for 50 ms;
		 Pulse_I <= '0';
		 wait for 50 ms;
		 Pulse_I <= '1';
		 wait for 50 ms;
		 Pulse_I <= '0';
		 wait for 50 ms;
		 Pulse_I <= '1';
		 wait for 50 ms;
		 Pulse_I <= '0';
		 wait for 50 ms;
		 Pulse_I <= '1';
		 wait for 3230 ms;
		 Pulse_I <= '0';
		 wait for 50 ms;
		 Pulse_I <= '1';
		 wait for 50 ms;
		 Pulse_I <= '0';
		 wait for 5 ms;
		 Pulse_I <= '1';
		 wait for 50 ms;
		 Pulse_I <= '0';
		 wait for 3000 ms;
		 Pulse_I <= '1';
		 wait for 50 ms;
		 Pulse_I <= '0';
		 wait for 510 ms;
		 Pulse_I <= '1';
		 wait for 50 ms;
		 Pulse_I <= '0';
		 wait for 50 ms;
		 Pulse_I <= '1';
		 wait for 50 ms;
		 Pulse_I <= '0';
		 wait for 50 ms;
		 Pulse_I <= '1';
		 wait for 50 ms;
		 Pulse_I <= '0';
		 wait for 50 ms;
		 Pulse_I <= '1';
		 wait for 50 ms;
		 Pulse_I <= '0';
		 wait for 50 ms;
		 Pulse_I <= '1';
		 wait for 500 ms;
		 Pulse_I <= '0';
		 wait for 500 ms;
		 Pulse_I <= '1';
		 wait for 50 ms;
		 Pulse_I <= '0';
		 wait for 1002 ms;
		 Pulse_I <= '1';
		 wait for 50 ms;
		 Pulse_I <= '0';
		 wait for 50 ms;
		 Pulse_I <= '1';
		 wait for 50 ms;
		 Pulse_I <= '0';
		 wait for 510 ms;
		 Pulse_I <= '1';
		 wait for 520 ms;
		 Pulse_I <= '0';
		 wait for 50 ms;
		 Pulse_I <= '1';
		 wait for 50 ms;
		 Pulse_I <= '0';
		 wait for 50 ms;
		 Pulse_I <= '1';
		 wait for 50 ms;
		 Pulse_I <= '0';
		 wait for 50 ms;
		 Pulse_I <= '1';
		 wait;
   end process;
END;