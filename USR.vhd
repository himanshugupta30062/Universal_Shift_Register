-----------------------------------------------------------------------------------------------------------------------------
-- File:	      USR.vhd
-- Engineer:	  Oscar Cairoli
-- Description: A Universal Shift Register
-- OS:		   Linux (Ubuntu) Terminal Command Lines with Digilent Adept and Basys2 FPGA:
--		$ djtgcfg enum						                     // The "enum" command enumerates the devices (-d)
--		$ djtgcfg init -d Basys2                       // The "init" command initializes the device for use
--		$ djtgcfg prog -d Basys2 -i 0 -f USR.bit		   // The "prog" command programs an interface (-i) on 
-- 									                                 // a device (-d) with the .bit file (-f)
----------------------------------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity USR is 
  generic (data_width  : integer := 8);
    
  port (
    A     : out std_logic_vector(data_width - 1 downto 0);
    S     : in  std_logic_vector(1 downto 0);
    I     : in  std_logic;
    reset : in  std_logic;
    clk   : in  std_logic);
end USR;

architecture behavior of USR is
  
  signal A_reg  : std_logic_vector(data_width - 1 downto 0) := (others => '0');
  
  A <= A_reg;
  
  USR_proc : process(clk)
  begin
    if (rising_edge(clk)) then
      if (reset = '1') then
        A_reg <= (others => '0');
      else
        case S is 
          when "00" =>  -- Hold
            A_reg <= '0';
          
          when "01" =>  -- Shift Right
            A_reg(data_width - 1) <= '0';
            A_reg(data_width - 2 downto 0) <= A_reg(data_width - 1 downto 1);
            
          when "10" =>  -- Shift Left
            A_reg(data_width - 1 downto 1) <= A_reg(data_width - 2 downto 0);
            A_reg(0) <= '0';
            
          when "11" =>   -- Serial Load
            A_reg(0) <= I;
            
          when others =>  -- Error Code
            A_reg <= (others => 'X');  
        end case;
      end if;
    end if;
  end process USR_proc;
end behavior;  
    
