library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity changing_page is
	port(
		CP_Clock: in std_logic;
		Next_PB, Prev_PB: in std_logic;
		Rst_PB: in std_logic;
		Page_Number: out integer
	);
end changing_page;

architecture arch of changing_page is 
	signal CLK_FREQ: integer := 50000000;
--	signal CLK_FREQ: integer := 10;
	signal max_page: integer := 4;
	signal page_num: integer := 0;
	signal changing_state: std_logic := '0';
	signal timer_count: integer := 0;
	signal next_state, prev_state: std_logic := '0';
begin
	chng_page: process(CP_Clock, Next_PB, Prev_PB, changing_state)
	begin
	
		if Rst_PB = '1' then
			changing_state <= '0';
		end if;
		
		if Next_PB = '0' and changing_state = '0' then
			changing_state <= '1';
			next_state <= '1';
			prev_state <= '0';
		elsif Prev_PB = '0' and changing_state = '0' then
			changing_state <= '1';
			next_state <= '0';
			prev_state <= '1';
		end if;

		if rising_edge(changing_state) then 
			if next_state = '1' then 
				if (page_num < max_page) then
			                page_num <= page_num + 1;
				else
			                page_num <= 0;
				end if;
			elsif prev_state = '1' then
				if (page_num > 0) then
					page_num <= page_num - 1;
				else
					page_num <= max_page;
				end if;
			end if;
		end if;

		if rising_edge(CP_Clock) then
			if changing_state = '1' then
				if timer_count >= CLK_FREQ / 2 then
					changing_state <= '0';
					timer_count <= 0;
				else
					timer_count <= timer_count + 1;
				end if;
			end if;
		else 
			changing_state <= changing_state;
		end if;
	end process chng_page;
	
	Page_Number <= page_num;
end arch;