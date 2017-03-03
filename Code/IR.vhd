library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
entity IR is
    Port ( From_ROM : in STD_LOGIC_VECTOR (7 downto 0);
           From_DecodingAndExcecution : in STD_LOGIC;
           IR_Current : out STD_LOGIC_VECTOR (7 downto 0));
end IR;
 
architecture Behavioral of IR is
begin
 
process(From_DecodingAndExcecution, From_ROM)
begin
   
    if (From_DecodingAndExcecution = '1') then -- if FDE is 1, increment to next instruction
        IR_Current <= From_ROM;
    else
        --nothing
    end if;
end process;
 
end Behavioral;