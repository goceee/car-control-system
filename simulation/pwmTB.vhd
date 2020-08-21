LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY tbP IS
END tbP;
ARCHITECTURE behavior OF tbP IS 
   --Inputs
   signal pwm_DC : std_logic := '0';
   signal clk : std_logic := '0';
   signal duty_cycle : integer range 0 to 200000;
   -- Clock period definitions
   constant clk_period : time := 20 ns;
BEGIN
    -- Instantiate the Unit Under Test (UUT)
   uut: entity work.pwm
		 port map(
		 clk => clk,
		 pwm_out => pwm_DC,
		 duty_cycle => duty_cycle
		 );
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
	duty_cycle <= 50000;
	wait for 30 ms;
	duty_cycle <= 125000;
	wait for 50 ms;
	duty_cycle <= 200000;
		 wait;
   end process;
END;
