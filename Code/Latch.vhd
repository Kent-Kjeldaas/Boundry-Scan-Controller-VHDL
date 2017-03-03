library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
 
entity Latch is
     Port   ( clk, reset : in std_logic;
            from_FSM : in std_logic_vector (2 downto 0);
            from_edo : in std_logic;
            to_edo, to_sso1, to_sso2 : out std_logic
            );
end Latch;
 
architecture Behavioral of Latch is
signal edo_sig : std_logic;
signal sso1_sig : std_logic;
signal sso2_sig : std_logic;
 
begin
    process(clk, reset, from_FSM)
        begin
            if (reset = '1') then
                edo_sig <= '0';
                sso1_sig <= '0';
                sso2_sig <= '0';
            else        
               if (from_fsm = "001") then
                       sso1_sig <= '1';
               elsif (from_fsm = "010") then
                       sso1_sig <= '0';
               elsif (from_fsm = "011") then
                       sso2_sig <= '1';  
               elsif (from_fsm = "100") then
                       sso2_sig <= '0';  
               
               end if;
               if(from_edo = '1') then
                   edo_sig <= '1';
               end if;         
              end if;
            
        end process;
           
        to_edo <= edo_sig;
        to_sso1 <= sso1_sig;
        to_sso2 <= sso2_sig;
           
end Behavioral;