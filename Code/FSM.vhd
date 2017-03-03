library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;
use ieee.numeric_std.all;
 
entity FSM is
    Port (
        --Inputs
        clk, reset : in STD_LOGIC;
        mtdi : in STD_LOGIC;
        si0 : in STD_LOGIC;
        si1 : in STD_LOGIC;
        Current : in std_logic_vector(7 downto 0);
        db : in STD_LOGIC_VECTOR(7 downto 0);
               
        --Outputs
        mtck : out STD_LOGIC;
        mtms : out STD_LOGIC;
        in_signal_PC : out STD_LOGIC_VECTOR (7 downto 0);
        DIR_PC : out std_logic;
        DaE : out STD_LOGIC;
        Shift : out std_logic;
        Load : out std_logic;
        SendY : out std_logic;
        SendZ  : out std_logic;
        From_FSM : out std_logic_vector(2 downto 0)
        );
end FSM;
 
architecture Behavioral of FSM is
type state_type is (init_0, init_1, init_2, TMS0_0, TMS0_1, TMS1_0, TMS1_1, RST_0, RST_1, RST_2, RST_3, RST_4, RST_5, RST_6, RST_7, RST_8, RST_9, NTCK_0, NTCK_1,
NTCK_2, NTCK_3, SHF_0, SHF_1, SHF_2, SHF_3, SHF_4, SHF_5, SHF_CP_0, SHF_CP_1, SHF_CP_2, SHF_CP_3, SHF_CP_4, SHF_CP_5, SHF_CP_6, SHF_CP_7, SHF_CP_8, SHF_CP_9, SHF_CP_10, SHF_CP_11, SSO00, SSO01, SSO10, SSO11, WSI00, WSI01, WSI10, WSI11, HALT);
signal state_reg, state_next: state_type;
signal n_val, y_val, z_val : std_logic_vector(7 downto 0);
signal n_temp, n_int : integer range 0 to 100;
signal counted : std_logic;
signal integervalue : integer range 0 to 100;


 
begin
   -- state reg
   process (CLK, reset)
    begin
       if (reset = '1') then
          state_reg <= init_0;
       end if;
       if(CLK'event and CLK = '1') then
       state_reg <= state_next;
 
    end if;
   end process;
 
  -- next state
 process(state_reg, state_next, si1, counted)
   begin
  -- initialize
       state_next <= state_reg;
 
       case state_reg is
 
         when init_0 => -- INIT
                in_signal_PC <= "00000001";
                DIR_PC <= '1'; -- "Count up"
                shift <= '0';
                mtck <= '0';
                mtms <= '0';
                state_next <= init_1;
 
            when init_1 =>
                in_signal_PC <= "00000000";
                DaE <= '1';
                state_next <= init_2;
 
            when init_2 =>
                DaE <= '0'; -- Decoding and Execution
                if(current="10100000") then -- Check for opcodes
                    state_next <= tms0_0;
                elsif (current="10100001") then
                    state_next <= tms1_0;
                elsif (current="10100010") then
                    state_next <= rst_0;
                elsif (current="10100011") then
                    state_next <= ntck_0;
                elsif (current="10100100") then
                    state_next <= shf_0;
                elsif (current="10100101") then
                    state_next <= shf_cp_0;
                elsif (current="10100110") then
                    state_next <= sso00;
                elsif (current="10100111") then
                    state_next <= sso01;
                elsif (current="10101000") then
                    state_next <= sso10;
                elsif (current="10101001") then
                    state_next <= sso11;
                elsif (current="10101010") then
                    state_next <= wsi00;
                elsif (current="10101011") then
                    state_next <= wsi01;  
                elsif (current="10101100") then
                    state_next <= wsi10;  
                elsif (current="10101101") then
                    state_next <= wsi11;
                elsif (current="10101111") then
                    state_next <= halt;    
                end if;
 
        when TMS0_0 => -- TMS0
           mtck <= '0';
           mtms <= '0';
           state_next <= TMS0_1;
 
        when TMS0_1 =>
           mtck <= '1';
           mtms <= '0';
           state_next <= init_0;
 
        when TMS1_0 => -- TMS1
              mtck <= '0';
              mtms <= '1';
              state_next <= TMS1_1;
 
        when TMS1_1 =>
              mtck <= '1';
              mtms <= '1';
              state_next <= init_0;
 
        when RST_0 => -- RESET 
               mtck <= '0';
               mtms <= '1';    
               state_next <= RST_1;
        when RST_1 =>
                mtck <= '1';
                mtms <= '1';
               state_next <= RST_2;
        when RST_2 =>
                mtck <= '0';
                mtms <= '1';  
                state_next <= RST_3;              
        when RST_3 =>
                mtck <= '1';
                mtms <= '1';
                state_next <= RST_4;
        when RST_4 =>
                mtck <= '0';
                mtms <= '1';
                state_next <= RST_5;
        when RST_5 =>
                mtck <= '1';
                mtms <= '1';
                state_next <= RST_6;
        when RST_6 =>
                mtck <= '0';
                mtms <= '1';
                state_next <= RST_7;
        when RST_7 =>
                mtck <= '1';
                mtms <= '1';  
                state_next <= RST_8;
        when RST_8 =>
                mtck <= '0';
                mtms <= '1';
                state_next <= RST_9;
        when RST_9 =>
                mtck <= '1';
                mtms <= '1';                    
                state_next <= init_0;
 
        when NTCK_0 => -- NTCK
               in_signal_PC <= "00000001";
               DIR_PC <= '1';
               state_next <= NTCK_1;
        when NTCK_1 =>
               n_val <= db;
               n_temp <= 0;
               if  (n_temp < n_val) then
                   state_next <= NTCK_2;  
               else
                   state_next <= init_0;  
               end if;
        when NTCK_2 =>
               in_signal_PC <= "00000000";        
               MTMS <= '0';
               MTCK <= '0';
               counted <= '0';
               state_next <= NTCK_3;                      
        when NTCK_3 =>
               MTCK <= '1';
               MTMS <= '0';
               if (n_temp < n_val) then
                   if(counted = '0') then
                       n_temp <= n_temp +1;
                       counted <= '1';
                   end if;
                   state_next <= NTCK_2;
               else
                   state_next <= init_0;
               end if;
                  
         when SHF_0 => -- Shift
                 in_signal_PC <= "00000001"; -- INC ROM
                 DIR_PC <= '1';
                 state_next <= SHF_1;              
          when SHF_1 =>
                  n_val <= db; -- N loaded
                  in_signal_PC <= "00000000";
                  n_temp <= 0;
                  state_next <= SHF_2;
          when SHF_2 =>
                  in_signal_PC <= "00000001"; -- INC ROM
                  DIR_PC <= '1';
                  state_next <= SHF_3;
          when SHF_3 =>
                  in_signal_PC <= "00000000";
                  load <= '1'; -- X loaded 
                  state_next <= SHF_4;
          when SHF_4 =>
                  load <= '0';
                  shift <= '0';
                  counted <='0';
                  mtck <= '0';
                  If (n_temp < n_val) then 
                    if(n_temp + 1 = n_val) then
                        mtms <= '1';
                    end if;
                      state_next <= SHF_5;
                  else
                      state_next <= init_0;
                  end if;
                  
          when SHF_5 =>
                   if(counted = '0') then
                      n_temp <= n_temp +1;
                      counted <= '1';
                   end if;
                   shift <= '1'; -- Shift bit
                   mtck <= '1';
                   if (n_temp mod 8 = 0) then --Do we need to load next 8 bits?
                      if(n_temp < n_val) then
                       state_next <= SHF_2;
                      else 
                        state_next <= init_0;
                      end if;
                   else
                       state_next <= SHF_4; -- Check if we're finished
                   end if;
                   
  ------------------- Shift Compare ---------------------------------
        when SHF_CP_0 => -- Shift Compare (N, X, Y, Z)
               in_signal_PC <= "00000001"; -- INC ROM N
               DIR_PC <= '1';
               state_next <= SHF_CP_1;              
        when SHF_CP_1 =>
                in_signal_PC <= "00000000";
                n_val <= db; -- N loaded
                n_int <= to_integer(signed(db)); -- cast db to n_int
                n_temp <= 0;
                state_next <= SHF_CP_2;
        when SHF_CP_2 =>
                in_signal_PC <= "00000001"; -- INC ROM X
                DIR_PC <= '1';
                state_next <= SHF_CP_3;
        when SHF_CP_3 => -- IN X address
                in_signal_PC <= "00000000";
                load <= '1'; -- X loaded
            if (n_int mod 8 = 0) then
                integervalue <= n_int/8;
            else
                integervalue <= (n_int/8)+1;
            end if;
                state_next <= SHF_CP_4;
        when SHF_CP_4 =>
                load <= '0';
                in_signal_pc <= std_logic_vector(to_signed(integervalue,8)); -- INC ROM Y
                DIR_PC <= '1';
                state_next <= SHF_CP_5;
        when SHF_CP_5 =>
                in_signal_PC <= "00000000";
                y_val <= db; -- Y loaded
                state_next <= SHF_CP_6;
        when SHF_CP_6 =>
                in_signal_pc <= std_logic_vector(to_signed(integervalue,8)); -- INC ROM Z
                DIR_PC <= '1';
                state_next <= SHF_CP_7;
        when SHF_CP_7 =>
                in_signal_PC <= "00000000";
                z_val <= db; -- Z loaded
                state_next <= SHF_CP_8;
        when SHF_CP_8 =>
                mtck <= '0';
                shift <= '0';
                counted <='0';
                If (n_temp < n_val) then -- Are we NOT finished?
                    if(n_temp + 1 = n_val) then
                        mtms <= '1';
                    end if;
                    state_next <= SHF_CP_9;
                else
                    state_next <= init_0;
                end if;
 
        when SHF_CP_9 =>
            if(counted = '0') then
                n_temp <= n_temp +1;
                counted <= '1';
            end if;
                state_next <= SHF_CP_10;
        when SHF_CP_10 =>  
            -- *SHIFTS AND COMPARES X,Y,Z if 8 bit shifted, go back to the right address*
            mtck <= '1';
            shift <= '1';
            SendY <= y_val(n_temp mod 8);
            SendZ <= z_val(n_temp mod 8);
            -- go back to the right X address
            if (n_temp mod 8 = 0) then -- load X,Y,Z
                If (n_temp < n_val) then -- Are we NOT finished?
                    in_signal_pc <= std_logic_vector(to_signed(2*integervalue-1,8));
                    dir_pc <= '0';
                    state_next <= SHF_CP_11;
                else
                    state_next <= init_0;
                end if;
            else
                state_next <= SHF_CP_8;
            end if;
           
        when SHF_CP_11 =>
            in_signal_PC <= "00000000";
            shift <= '0';
            dir_pc <= '1';
            mtck <= '0';
            state_next <= SHF_CP_3;
--------------------------------------------------------------------   
                   
        when SSO00 => -- SYNC
            From_FSM <= "010"; -- sets it low
            state_next <= init_0;
        when SSO01 =>
            From_FSM <= "001"; --sets it high
            state_next <= init_0;
        when SSO10 =>
            From_FSM <= "101";
            state_next <= init_0;
        when SSO11 =>
            From_FSM <= "110";
            state_next <= init_0;
           
        when WSI00 =>   -- Wait for SYNC
            if(si0 = '0') then
                state_next <= init_0;
            else
                state_next <= WSI00;
            end if;
           
        when WSI01 =>
            if(si0 = '1') then
                state_next <= init_0;
            else
                state_next <= WSI01;
            end if;
           
        when WSI10 =>
            if(si1 = '0') then
                state_next <= init_0;
            else
                state_next <= WSI10;
            end if;
           
        when WSI11 =>
            if(si1 = '1') then
                state_next <= init_0;
            end if;
 
        when HALT => -- END PROGRAM
           if(reset = '0') then
                state_next <= halt; -- loops HALT-state until reset is pressed.
           else
                state_next <= init_0;
            end if;                
        end case;    
  end process;
 
end Behavioral;