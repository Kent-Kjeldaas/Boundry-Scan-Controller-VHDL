-- v3 (goes with bsctr_v3)

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY top_level_tb_v3 IS
END top_level_tb_v3;
 
ARCHITECTURE behavior OF top_level_tb_v3 IS 
 
    -- Component Declarations for the Units Under Test (UUT)
    COMPONENT Top_Level
    PORT(
         clk, reset: in std_logic;
         si0, si1: in std_logic;
         so0, so1: out std_logic;
         mtdi: in std_logic;
         mtms, mtck, mtdo: out std_logic;
         edo: out std_logic         
        );
    END COMPONENT;

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal si0, si1 : std_logic := '0';
   signal mtdi: std_logic := '1';

 	--Outputs
   signal so0, so1 : std_logic;
   signal mtms, mtck, mtdo: std_logic;
   signal edo : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: top_level PORT MAP (
          clk => clk,
          reset => reset,
          si0 => si0,
          si1 => si1,
          so0 => so0,
          so1 => so1,
          mtms => mtms,
          mtck => mtck,
          mtdo => mtdo,
          mtdi => mtdi,
          edo => edo
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
        reset <= '1';
        mtdi <= '1';
        wait for clk_period*2;
		reset <= '0';	
		wait for clk_period*88;
		-- sequence for SHFCP
		wait for clk_period*5;
		-- 1st set of expected values: 5EH ("01011110")
		mtdi <= '0';
		wait for clk_period*3;
		mtdi <= '1';
        wait for clk_period*3;
		mtdi <= '0';
        wait for clk_period*3;
		mtdi <= '1';
        wait for clk_period*3;
		mtdi <= '1';
        wait for clk_period*3;
		mtdi <= '1';
        wait for clk_period*3;
		mtdi <= '1';
        wait for clk_period*3;
		mtdi <= '0';
        wait for clk_period*7;
        -- 2nd set of expected values: 97H ("10010111")
		mtdi <= '1';
        wait for clk_period*3;
        mtdi <= '0';
        wait for clk_period*3;
        mtdi <= '0';
        wait for clk_period*3;
        mtdi <= '1';
        wait for clk_period*3;
        mtdi <= '0';
        wait for clk_period*3;
        mtdi <= '1'; 
        wait for clk_period*3;
        mtdi <= '0'; -- setting mtdi to '0' here will cause an error
        wait for clk_period*3;
        mtdi <= '1'; -- this bit doesn't matter (it's SHFCP for 15 bits)
        wait for clk_period*3;
		wait for clk_period*20;
		si1 <= '1';
		wait for clk_period;
		si1 <= '0'; 
		wait for clk_period*50;

   end process;

END;
