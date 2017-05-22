library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.all;

entity kalkulator is
port (
	clk_i : in std_logic;
	rst_i:in std_logic;
	gotowe : in std_logic:='0';
	bps2_data_i: in std_logic_vector (7 downto 0) ;
	led7_seg_o_tmp0 : out std_logic_vector(7 downto 0);
	led7_seg_o_tmp1 : out std_logic_vector(7 downto 0);
	led7_seg_o_tmp2 : out std_logic_vector(7 downto 0);
	led7_seg_o_tmp3 : out std_logic_vector(7 downto 0);
	led_o: out std_logic_vector(7 downto 0)
);
end kalkulator;
architecture Behavioral of kalkulator is

type states is (A, B, C, D, E, F, G, H, I, J);

signal b0_0: std_logic_vector (7 downto 0) := x"70";
signal b0_1: std_logic_vector (7 downto 0) := x"70";
signal b0_2: std_logic_vector (7 downto 0) := x"70";
signal b0_3: std_logic_vector (7 downto 0) := x"70";

signal b1_0: std_logic_vector (7 downto 0) := x"70";
signal b1_1: std_logic_vector (7 downto 0) := x"70";
signal b1_2: std_logic_vector (7 downto 0) := x"70";
signal b1_3: std_logic_vector (7 downto 0) := x"70"; 


signal b0_0_next: std_logic_vector (7 downto 0) := x"70";
signal b0_1_next: std_logic_vector (7 downto 0) := x"70";
signal b0_2_next: std_logic_vector (7 downto 0) := x"70";
signal b0_3_next: std_logic_vector (7 downto 0) := x"70";

signal b1_0_next: std_logic_vector (7 downto 0) := x"70";
signal b1_1_next: std_logic_vector (7 downto 0) := x"70";
signal b1_2_next: std_logic_vector (7 downto 0) := x"70";
signal b1_3_next: std_logic_vector (7 downto 0) := x"70"; 


signal state: states:=A;
signal state_next: states;

signal znak: std_logic_vector (7 downto 0) ; 

signal bgotowe : std_logic;

shared variable result0_0 : integer:= 0;
shared variable result0_1 : integer:= 0;
shared variable result0_2 : integer:= 0;
shared variable result0_3 : integer:= 0;
shared variable result0 : integer:= 0;


shared variable result1_0 : integer:= 0;
shared variable result1_1 : integer:= 0;
shared variable result1_2 : integer:= 0;
shared variable result1_3 : integer:= 0;
shared variable result1 : integer:= 0;


shared variable final_result : integer:= 0;
signal final_result0 : integer:= 0;
signal final_result1 : integer:= 0;
signal final_result2 : integer:= 0;
signal final_result3 : integer:= 0;

signal overflow: bit:= '0';


function convert2number (signal ps2_number : std_logic_vector (7 downto 0))
return integer is
variable result_number : integer:= 0;
begin

	case ps2_number is
		 when "01000101" => result_number := 0; 
		 when "00010110" => result_number := 1; 
		 when "00011110" => result_number := 2; 
		 when "00100110" => result_number := 3; 
		 when "00100101" => result_number := 4; 
		 when "00101110" => result_number := 5; 
		 when "00110110" => result_number := 6; 
		 when "00111101" => result_number := 7;     		
		 when "00111110" => result_number := 8; 
		 when "01000110" => result_number := 9;
		 when others => result_number := 0;
	 end case;

return (result_number);
end function convert2number;


function convert2ps2_data (signal number : integer)
return std_logic_vector is
variable result_data : std_logic_vector (7 downto 0);

begin

	case number is
		 when 0 => result_data := "01000101"; 
		 when 1 => result_data := "00010110"; 
		 when 2 => result_data := "00011110"; 
		 when 3 => result_data := "00100110"; 
		 when 4 => result_data := "00100101"; 
		 when 5 => result_data := "00101110"; 
		 when 6 => result_data := "00110110"; 
		 when 7 => result_data := "00111101";     		
		 when 8 => result_data := "00111110"; 
		 when 9 => result_data := "01000110";
		 when others => result_data := "01000101";
	 end case;

return (result_data);
end function convert2ps2_data;



begin
COMBhehehnie: process (clk_i, state,gotowe,bgotowe, bps2_data_i, b0_0, b0_1,  b0_2,  b0_3,  b1_0,  b1_1,  b1_2,  b1_3, b0_0_next, b0_1_next,  b0_2_next,  b0_3_next,  b1_0_next,  b1_1_next,  b1_2_next,  b1_3_next)
	begin
	if rst_i = '1' then
		state<= A;
	elsif (rising_edge(clk_i)) then 
	bgotowe<=gotowe;
	--state_next <= state ; 
--	b1_0_next <= b1_0;
--	b1_1_next <= b1_1;
--	b1_2_next <= b1_2;
--	b1_3_next <= b1_3;
--	
--	b0_0_next <= b0_0;
--	b0_1_next <= b0_1;
--	b0_2_next <= b0_2;
--	b0_3_next <= b0_3;
		if (bgotowe='0' and gotowe='1') then
			if (bps2_data_i=x"76" or bps2_data_i=x"7B" or bps2_data_i=x"79" or bps2_data_i=x"55") then -- ESC - + =

				if (bps2_data_i=x"76") then
					led_o<="10101010";
					state_next <= A;
				end if;
				if (bps2_data_i=x"55") then
					-- konwertuj
					led_o<="11110000";
					
					result0_0:=1;--convert2number(b0_0);
					result0_1:=2;--convert2number(b0_1);
					result0_2:=3;--convert2number(b0_2);
					result0_3:=4;--convert2number(b0_3);
					
					-- result0 := result0_3*1000 + result0_2*100 + result0_1*10 + result0_0;
					
					result1_0:=6;--convert2number(b1_0);
					result1_1:=7;--convert2number(b1_1);
					result1_2:=8;--convert2number(b1_2);
					result1_3:=9;--convert2number(b1_3);
					
					-- result1 := result1_3*1000 + result1_2*100 + result1_1*10 + result1_0;
	
					
					-- end konwertuj

					-- licz
					
					if (znak=x"79") then
					led_o<="11111010";
						-- final_result := result0 - result1;
						final_result0<=result0_0+result1_0;
						if (final_result0>10) then
							final_result1 <= 1;
							final_result0 <= final_result0 - 10;
						end if;
				
						final_result1<=final_result1+result0_1+result1_1;
						if (final_result1>10) then
							final_result2 <= 1;
							final_result1 <= final_result1 - 10;
						end if;
						
						final_result2<=final_result2+result0_2+result1_2;
						if (final_result2>10) then
							final_result3 <= 1;
							final_result2 <= final_result2 - 10;
						end if;
						
						final_result3<=final_result3+result0_3+result1_3;
						if (final_result3>10) then
							overflow <= '1';
							final_result3 <= final_result3 - 10;
						end if;
						
						if (overflow = '1') then 
							final_result0<=0;
							final_result1<=0;
							final_result2<=0;
							final_result3<=0;
						end if;
						
					elsif (znak=x"7B") then
						final_result := result0 + result1;
					end if;
									
					-- end licz
					-- konwertuj w druga strone
					
--					led7_seg_o_tmp0<=convert2ps2_data(final_result0);
--					led7_seg_o_tmp1<=convert2ps2_data(final_result1);
--					led7_seg_o_tmp2<=convert2ps2_data(final_result2);
--					led7_seg_o_tmp3<=convert2ps2_data(final_result3);
					
					b0_0_next<=convert2ps2_data(final_result0);
					b0_1_next<=convert2ps2_data(final_result1);
					b0_2_next<=convert2ps2_data(final_result2);
					b0_3_next<=convert2ps2_data(final_result3);
					
					b1_0_next<=convert2ps2_data(final_result0);
					b1_1_next<=convert2ps2_data(final_result1);
					b1_2_next<=convert2ps2_data(final_result2);
					b1_3_next<=convert2ps2_data(final_result3);
					
					
					
					-- end kowertuj w druga strone 
					
					state_next <= A;
				end if;
				if (bps2_data_i=x"7B" or bps2_data_i=x"79") then -- - / +
					znak <= bps2_data_i;
					state_next<=F;
				end if;

				else
					if (bps2_data_i="01110000" or bps2_data_i=x"69" or bps2_data_i=x"72" or bps2_data_i=x"7A" or bps2_data_i=x"6B" or bps2_data_i=x"73" or bps2_data_i=x"74" or bps2_data_i=x"6C" or bps2_data_i=x"75" or bps2_data_i=x"7D") then
						case state is 
							when A =>	
								led_o<="11111110";							
								b0_1_next <= x"70";
								b0_2_next <= x"70";
								b0_3_next <= x"70";
								b1_1_next<=x"70";
								b1_2_next<=x"70";
								b1_3_next<=x"70";
								b0_0_next<=bps2_data_i;
								state_next <= B;

							when B =>
								led_o<="11111101";
							
								b0_1_next <= b0_0;
								b0_0_next <=bps2_data_i;
								
								b0_2_next <= x"70";
								b0_3_next <= x"70";
								b1_1_next<=x"70";
								b1_2_next<=x"70";
								b1_3_next<=x"70";
								state_next <= C;
							
							when C =>
								led_o<="11111100";
								
								b0_0_next<=bps2_data_i;
								b0_1_next <= b0_0;
								b0_2_next <= b0_1;
								
								b0_3_next <= x"70";
								b1_1_next<=x"70";
								b1_2_next<=x"70";
								b1_3_next<=x"70";
								state_next <= D;
								
							when D =>
							led_o<="11111011";
								b0_0_next <= bps2_data_i;
								b0_1_next <= b0_0;
								b0_2_next <= b0_1;
								b0_3_next <= b0_2;
								
								b1_1_next<=x"70";
								b1_2_next<=x"70";
								b1_3_next<=x"70";
								state_next <= E;
							when E => 
								led_o<="11111010";
								state_next <= E;
							when F =>
							led_o<="11111000";
		
								b1_0_next<=bps2_data_i;
								
								b0_1_next <= b0_0;
								b0_2_next <= b0_1;
								b0_3_next <= b0_2;
								b1_1_next<=x"70";
								b1_2_next<=x"70";
								b1_3_next<=x"70";
								state_next <= G;
							when G =>
							led_o<="11110111";
							
								b1_0_next<=bps2_data_i;
								b1_1_next<=b1_0;
								
								
								b0_1_next <= b0_0;
								b0_2_next <= b0_1;
								b0_3_next <= b0_2;
								b1_2_next<=x"70";
								b1_3_next<=x"70";
								state_next <= H;

							when H =>
							led_o<="11110110";
							
								b1_0_next<=bps2_data_i;
								b1_1_next<=b1_0;
								b1_2_next<=b1_1;
								
								b0_1_next <= b0_0;
								b0_2_next <= b0_1;
								b0_3_next <= b0_2;
								b1_3_next<=x"70";
								state_next <= I;

							when I =>
								led_o<="11110101";
							
								b1_0_next<=bps2_data_i;
								b1_1_next<=b1_0;
								b1_2_next<=b1_1;
								b1_3_next<=b1_2;
								b0_1_next <= b0_0;
								b0_2_next <= b0_1;
								b0_3_next <= b0_2;

								state_next <= J;

							when J => 
								led_o<="11110100";
								state_next <= J;
								
						end case;
				else
					state_next <= A;
				end if;
				
			end if;
		end if;
		state <= state_next;
				
				b0_0 <= b0_0_next;
				b0_1 <= b0_1_next;
				b0_2 <= b0_2_next;
				b0_3 <= b0_3_next;
				
				b1_0 <=b1_0_next;
				b1_1 <=b1_1_next;
				b1_2 <=b1_2_next;
				b1_3 <=b1_3_next;
				
				
			
						
				if (state=A or state=B or state=C or state=D or state=E or state=F) then
		 	led7_seg_o_tmp0 <= b0_0;		
				led7_seg_o_tmp1 <= b0_1;
				led7_seg_o_tmp2 <= b0_2;
				led7_seg_o_tmp3 <= b0_3;
				elsif ( state=G or state=H or state=I or state = J) then
					led7_seg_o_tmp0 <= b1_0;
					led7_seg_o_tmp1 <= b1_1;
					led7_seg_o_tmp2 <= b1_2;
					led7_seg_o_tmp3 <= b1_3; 
				end if;
	end if;
end process;
 end Behavioral;


