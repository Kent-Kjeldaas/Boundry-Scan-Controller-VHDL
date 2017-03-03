library ieee;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
   
 
entity Deserializer is
    port (
            MTDI : in std_logic;
            LoadZ : in std_logic;
            LoadY: in std_logic;
            EDO : out std_logic
    );
end Deserializer;
 
architecture Behavioral of Deserializer is
  
begin
process(MTDI, LoadY)
    begin
    if(LoadZ = '1') then
        if(MTDI /= LoadY) then
           EDO <= '1';
        end if;
    else 
        EDO <= '0';
    end if;
        
end process;

end Behavioral;