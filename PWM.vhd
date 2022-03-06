--
--Module         : PWM
--File name      : PWM.vhd
--Description    : PWM generator
--System         : VHDL' 93
--Author         : czerw0nk
--Version        : 1.0v 22/07/2021
--
LIBRARY IEEE, STD; 
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all; 
ENTITY PWM IS
	PORT 
		(
		clk,rst_n 	            : IN  std_logic;
		pwm_out                 : OUT std_logic;
		data_read		        : OUT std_logic_vector(7 downto 0);
		data_out                : IN  std_logic_vector(7 downto 0);
		address                 : IN  std_logic_vector(7 downto 0);  
		nr_w                    : IN  std_logic
		);
END ENTITY PWM;

ARCHITECTURE rtl OF PWM IS	

	constant c_REG_PERIOD_ADR   : std_logic_vector(7 downto 0) := x"40"; 
	constant c_REG_DUTY_ADR     : std_logic_vector(7 downto 0) := x"41"; 
	constant c_REG_RUN_ADR      : std_logic_vector(7 downto 0) := x"42";
	constant c_REG_STATUS_ADR   : std_logic_vector(7 downto 0) := x"43";
	
	signal   REG_PERIOD         : std_logic_vector(7 downto 0)  := (others => '0');
	signal   REG_DUTY           : std_logic_vector(7 downto 0)  := (others => '0');
	signal   REG_RUN            : std_logic_vector(7 downto 0)  := (others => '0');
	signal   REG_STATUS         : std_logic_vector(7 downto 0)  := (others => '0');
    signal   cnt                : unsigned(7 downto 0); 

BEGIN
  data_read <= 
			 REG_PERIOD          when address = c_REG_PERIOD_ADR    and nr_w = '0' else 
             REG_DUTY            when address = c_REG_DUTY_ADR      and nr_w = '0' else 
             REG_RUN             when address = c_REG_RUN_ADR       and nr_w = '0' else 
             REG_STATUS          when address = c_REG_STATUS_ADR    and nr_w = '0' else 
         		       												(others => '0');
																	 															 
  r_period: process(clk, rst_n)
	begin
    if rst_n = '0' then 
      REG_PERIOD <= (others => '0'); 
    elsif rising_edge(clk) then 
	  if address = c_REG_PERIOD_ADR and nr_w = '1' then 
        REG_PERIOD <= data_out; 
	  end if; 	
    end if; 
  end process r_period; 
  
  r_duty: process(clk, rst_n)
	begin
    if rst_n = '0' then 
      REG_DUTY <= (others => '0'); 
    elsif rising_edge(clk) then 
	  if address = c_REG_DUTY_ADR and nr_w = '1' then 
        REG_DUTY <= data_out; 
	  end if; 	
    end if; 
  end process r_duty; 
  
  r_run: process(clk, rst_n)
    begin
    if rst_n = '0' then 
      REG_RUN <= (others => '0');  
    elsif rising_edge(clk) then 
	  if address = c_REG_RUN_ADR and nr_w = '1' then 
        REG_RUN <= data_out; 
	  end if; 	
    end if; 
  end process r_run; 
  
  CNT_R : process (clk,rst_n) is 
	begin
	if rst_n = '0' then 
		cnt <= (others => '0');  
	elsif rising_edge(clk) then
		cnt <= cnt + 1;
	elsif cnt >= unsigned(REG_PERIOD) then
		cnt <= (others => '0');
	end if;
  end process CNT_R;
  
  r_status: process(clk, rst_n)
	begin
    if rst_n = '0' then 
      REG_STATUS <= (others => '0');  
    elsif rising_edge(clk) then 
	    -- READ ONLY !!
		if    REG_RUN    = "00000001"  then	REG_STATUS <= "00000001"; --end if;-- 1   RUN MODE 1
		elsif REG_RUN    = "00000010"  then	REG_STATUS <= "00000010"; --end if;-- 2   RUN MODE 2
		elsif REG_RUN    = "00000000"  then	REG_STATUS <= "00000100"; --end if;-- 4   RUN    NOT SET	
	  --elsif REG_DUTY   = "00000000"  then	REG_STATUS <= "00001000"; --end if;-- 8   DUTY   NOT SET
	  --elsif REG_PERIOD = "00000000"  then	REG_STATUS <= "00010000"; --end if;-- 16  PERIOD NOT SET
	  --elsif REG_DUTY   = REG_PERIOD  then	REG_STATUS <= "00100000"; --end if;-- 32  DUTY   EQ. PERIOD
	  --elsif REG_DUTY   < REG_PERIOD  then	REG_STATUS <= "01000000"; --end if;-- 64  PERIOD GREATER THAN DUTY
	  --elsif REG_DUTY   > REG_PERIOD  then	REG_STATUS <= "10000000"; --end if;-- 128 DUTY   GREATER THAN PERIOD
		else  REG_STATUS <= (others => '0');
		end if;
    end if; 
  end process r_status; 

  pwm_out <=    '1'  when REG_RUN = "00000001" and cnt < unsigned(REG_DUTY) else
				'0'  when REG_RUN = "00000000" or  cnt > unsigned(REG_DUTY) else 
				'0'  when rst_n = '0' 										else
				'0';

	

END ARCHITECTURE rtl;

