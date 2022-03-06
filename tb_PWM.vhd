--
--Module         : PWM_TestBench
--File name      : tb_PWM.vhd
--Description    : Test Bench for PWM
--System         : VHDL' 93
--Author         : czerw0nk
--Version        : 1.0v 22/07/2021
--
LIBRARY IEEE, STD; 
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all; 

ENTITY tb_PWM IS
END tb_PWM; 

ARCHITECTURE tbArchitecture OF tb_PWM IS 

  constant c_PERIOD_OF_TIME : time := 10 ns;
  constant c_REG_PERIOD_ADR   : std_logic_vector(7 downto 0) := x"40"; 
  constant c_REG_DUTY_ADR     : std_logic_vector(7 downto 0) := x"41"; 
  constant c_REG_RUN_ADR      : std_logic_vector(7 downto 0) := x"42";
  constant c_REG_STATUS_ADR   : std_logic_vector(7 downto 0) := x"43";
  
  COMPONENT PWM is
	PORT 
		 (
		 clk,rst_n 	      : IN  std_logic;
		 pwm_out          : OUT std_logic;
		 data_read		  : OUT std_logic_vector(7 downto 0); 
	     data_out         : in  std_logic_vector(7 downto 0);   
		 address          : IN  std_logic_vector(7 downto 0);  
		 nr_w             : IN  std_logic
		 );
  end component PWM; 
  
  signal s_reset_n        : std_logic; 
  signal s_clk            : std_logic;   
  signal s_pwm_out        : std_logic; 
  signal s_data_read      : std_logic_vector(7 downto 0); 
  signal s_data_out       : std_logic_vector(7 downto 0); 
  signal s_address        : std_logic_vector(7 downto 0);
  signal s_nr_w           : std_logic;
BEGIN

  scenario: process 
  begin 

    --  RESET -- 
    s_reset_n   <= '0';	
	s_data_out	<= (others => '0');
	s_address  <= (others => '0'); 
	s_nr_w      <= '0';
	wait for 3.3 * c_PERIOD_OF_TIME; 
    s_reset_n <= '1'; 
	wait for 2* c_PERIOD_OF_TIME; 
	s_address  <= c_REG_PERIOD_ADR;  
	s_data_out <= "00000111";  
	s_nr_w     <= '1'; 
	wait for 1* c_PERIOD_OF_TIME; 
	s_nr_w     <= '0'; 
	wait for 1* c_PERIOD_OF_TIME; 
	s_address  <= c_REG_DUTY_ADR;  
	s_data_out <= "00000010";  
	s_nr_w     <= '1'; 
	wait for 1* c_PERIOD_OF_TIME; 
	s_nr_w     <= '0'; 
	wait for 1* c_PERIOD_OF_TIME; 
	s_address  <= c_REG_RUN_ADR;  
	s_data_out <= "00000001"; 
	s_nr_w     <= '1'; 
	wait for 10* c_PERIOD_OF_TIME; 
	s_nr_w     <= '0';
	s_address  <= c_REG_DUTY_ADR;  
	s_data_out <= "00000011";  
	s_nr_w     <= '1'; 	
	wait for 10* c_PERIOD_OF_TIME; 
    s_nr_w     <= '0';
	wait for 1* c_PERIOD_OF_TIME; 
	s_address  <= c_REG_DUTY_ADR;  
	s_data_out <= "00000100";  
	s_nr_w     <= '1'; 
	wait for 10* c_PERIOD_OF_TIME; 
	s_nr_w     <= '0';
	s_address  <= c_REG_RUN_ADR;  
	s_data_out <= "00000000"; 
	s_nr_w     <= '1'; 
	wait for 10* c_PERIOD_OF_TIME; 

	assert false 
	  report "DONE"
	  severity failure; 
	
  end process scenario; 
    	
  tick: process
  begin   
    s_clk <= '0'; 
	wait for c_PERIOD_OF_TIME/2; 
    s_clk <= '1'; 
	wait for c_PERIOD_OF_TIME/2; 
  end process tick; 	
  
  connections :  PWM port map
  (
	rst_n      => s_reset_n    ,
	clk        => s_clk        ,
	pwm_out    => s_pwm_out    ,
    data_read  => s_data_read  ,
    data_out   => s_data_out   ,
    address    => s_address    ,
    nr_w       => s_nr_w       	
  );                
                    
END ARCHITECTURE tbArchitecture;
