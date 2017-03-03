library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity Top_Level is
 PORT(
        clk, reset: in std_logic;
        si0, si1: in std_logic;
        so0, so1: out std_logic;
        mtdi: in std_logic;
        mtms, mtck, mtdo: out std_logic;
        edo: out std_logic         
       );
end Top_Level;

architecture Behavioral of Top_Level is

    component FSM is 
        Port(
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
              in_signal_PC : out STD_LOGIC_vector(7 downto 0);
              DIR_PC : out std_logic;
              from_FSM: out std_logic_vector(2 downto 0);
              Shift : out std_logic;
              Load  : out std_logic;
              SendY : out std_logic;
              SendZ : out std_logic;
              DaE : out STD_LOGIC
        );
    end component;
    
     -------------------------------------
     --------------------------------------
    component IR is
        Port(
             From_ROM : in STD_LOGIC_VECTOR (7 downto 0);
             From_DecodingAndExcecution : in STD_LOGIC;
             IR_Current : out STD_LOGIC_VECTOR (7 downto 0)
        );
    end component;
    -------------------------------------------------------
    ----------------------------------------------------    
    component Latch is -- Latch er feil, må skrives om pga. 10 - 01 - 11 osv. Fordi den tar i mot value fra FSM 1 downto 0, 
        Port(
            clk, reset : in std_logic;
            from_FSM : in std_logic_vector (2 downto 0); -- DEnne må lages i FSM
            From_edo : in std_logic;
            to_edo, to_sso1, to_sso2 : out std_logic
        );
    end component;
    -------------------------------------------------------
    ----------------------------------------------------  
     component Serializer is
        Port(
            from_RAM : in std_logic_vector(7 downto 0);
            sL : in std_logic;
            sS : in std_logic;
            clk, reset : in std_logic;
            to_TDO : out std_logic
       );
     end component;
     -------------------------------------------------------
     --------------------------------------------------------
     component ROM is
        Port(
             ab: in std_logic_vector(7 downto 0);
             db: out std_logic_vector(7 downto 0)
        );
     end component;
     -----------------------------------------------------------
     -------------------------------------------------------------
    component Program_Counter is
        Port(
             clk, reset: in std_logic;
             in_signal : in std_logic_vector (7 downto 0);
             Dir : in std_logic; --direction. 1 up and 0 down
             Q : out std_logic_vector (7 downto 0)
        );
    end component;
---------------------------------------------------------     
---------------------------------------------------------
    component Deserializer is
        Port(
            MTDI : in std_logic;
            LoadZ : in std_logic;
            LoadY: in std_logic;
            EDO : out std_logic
        ); 
    end component;     

signal db : STD_LOGIC_vector(7 downto 0);
signal ab : std_logic_vector(7 downto 0);
signal From_ROM :  STD_LOGIC_VECTOR(7 downto 0);
signal From_DaE :  std_logic;
signal IR_Current : STD_LOGIC_VECTOR(7 downto 0);
signal from_FSM : std_Logic_vector(2 downto 0);
signal from_RAM : std_logic_vector(7 downto 0);  -- To Serializer
signal sL : std_logic;
signal sS : std_logic;
signal in_signal : std_logic_vector(7 downto 0);
signal Dir : std_logic;
signal Q : std_logic_vector(7 downto 0);
signal Z : std_logic;
signal Y : std_logic;
signal EDO_From_Deserializer : std_logic;

begin

Component_FSM :  FSM 
        port map( clk => clk,
                  reset => reset, 
                  mtdi => mtdi,
                  si0 => si0,
                  si1 => si1,
                  Shift => sS,
                  Load => sL,
                  db => db,
                  mtms => mtms,
                  from_FSM => from_FSM,
                  mtck => mtck, 
                  Current => IR_Current,
                  Dir_PC => Dir,
                  in_signal_PC => in_signal,
                  DaE => From_DaE, 
                  SendY => Y,
                  SendZ => Z
                 
                );       
-----------------------------------------------------------

Component_IR : IR
        port map(
            From_ROM => db, -- Dobbeltsjekk denne
            From_DecodingAndExcecution => From_DaE,
            IR_Current => IR_Current
        );
---------------------------------------------------------------

Component_Latch : Latch 
        port map(
            clk => clk, 
            reset => reset,
            from_FSM => from_FSM, -- Sjekk denne på nytt!!!
            to_edo => edo,
            from_edo => EDO_From_Deserializer,
            to_sso1 => so0,
            to_sso2 => so1
            
        );
---------------------------------------------------------------

Component_Serializer : Serializer 
        port map(
            clk => clk,
            reset => reset,
            to_TDO => mtdo,
            from_RAM => db,
            sL => sL,
            sS => sS
        );
        
----------------------------------------------------
Component_ROM : ROM 
        port map( 
            ab => Q,
            db => db
        );
        
   ---------------------------------------------------     

Component_ProgramCounter : Program_Counter
        port map(
            clk => clk,
            reset => reset,
            in_signal => in_signal,
            Dir => Dir,
            Q => Q
        );
----------------------------------------------------------

Component_Deserializer : Deserializer
        port map(
            mtdi => mtdi,
            LoadY => Y,
            LoadZ => Z,
            EDO => EDO_From_Deserializer
        );        

end Behavioral;
