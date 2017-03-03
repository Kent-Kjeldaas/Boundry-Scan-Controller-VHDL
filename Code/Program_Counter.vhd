library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
 
entity Program_Counter is
    port(
        clk, reset: in std_logic;
        in_signal : in std_logic_vector (7 downto 0);
        Dir : in std_logic; --direction. 1 up and 0 down
        Q : out std_logic_vector (7 downto 0)
        );
end Program_Counter;
   
architecture Behavioral of Program_Counter is
    signal Pre_Q: std_logic_vector(7 downto 0);
    signal temp :std_logic_vector(7 downto 0);
    
begin
    process(clk,reset,Dir, in_signal)
    begin
        if (reset='1') then
            Pre_Q <= "00000000"; -- Settes til null
         else  
            if(in_signal ="00000000") then
                temp <= "00000000";
            end if; 
            if (Dir = '1') then
                if(temp < in_signal) then
                    Pre_Q <= Pre_Q + 1;
                    temp <= temp + 1;
               end if;
               
               -- end loop;
               
            elsif (Dir = '0') then
               if(temp < in_signal) then
                    Pre_Q <= Pre_Q - 1;
                    temp <= temp + 1;
               end if;

            end if;
        end if;  
    end process;  
    Q <= Pre_Q;
    end Behavioral;