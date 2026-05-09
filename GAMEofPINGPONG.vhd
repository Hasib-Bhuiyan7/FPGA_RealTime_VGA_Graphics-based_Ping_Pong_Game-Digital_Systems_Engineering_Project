----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:08:46 11/16/2025 
-- Design Name: 
-- Module Name:    GAMEofPINGPONG - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity GAMEofPINGPONG is
    Port (
        Switches : in STD_LOGIC_VECTOR(3 downto 0);
        DAC_Clk  : out STD_LOGIC;
        Clk      : in STD_LOGIC;
        Rout     : out STD_LOGIC_VECTOR(7 downto 0);
        Gout     : out STD_LOGIC_VECTOR(7 downto 0);
        Bout     : out STD_LOGIC_VECTOR(7 downto 0);
        Vsync    : out STD_LOGIC;
        Hsync    : out STD_LOGIC
    );
end GAMEofPINGPONG;

architecture Behavioral of GAMEofPINGPONG is

    signal horizontalPositionCounter, verticalPositionCounter : integer := 0;
    signal x, y : integer := 0; -- Simplified x and y coordinates

    constant HD  : integer := 640;
    constant HFP : integer := 16;
    constant HSP : integer := 96;
	 constant HBP : integer := 48;

    constant VD  : integer := 480;
    constant VFP : integer := 10;
    constant VSP : integer := 2;
    constant VBP : integer := 33;

	 signal Clk25MHz  : STD_LOGIC := '0';
	 signal counter    : integer := 0;
    signal videoOn   : STD_LOGIC:= '0';
	 
    signal ourVsync : STD_LOGIC;
    signal ourHsync : STD_LOGIC;
	 
    signal R : STD_LOGIC_VECTOR(7 downto 0);
	 signal G : STD_LOGIC_VECTOR(7 downto 0);
	 signal B : STD_LOGIC_VECTOR(7 downto 0);
	 
    signal control0 : std_logic_vector(35 downto 0);
    signal ila_data : std_logic_vector(127 downto 0);
    signal trig0 : std_logic_vector(7 downto 0);

    signal ball_x_direction, ball_y_direction : integer := 1;
    signal ball_x, ball_y : integer := 0;
    signal player1_y, player2_y : integer := 240;
    
    signal pause_counter : integer := 0;
    constant pause_delay : integer := 22;

    signal input_delay_counter : integer := 0;
    constant input_delay : integer := 300000;

    signal ball_delay_counter : integer := 0;
    constant ball_delay : integer := 250000;

component icon
  PORT (
    CONTROL0 : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0));

end component;

component ila
  PORT (
    CONTROL : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0);
    CLK : IN STD_LOGIC;
    DATA : IN STD_LOGIC_VECTOR(127 DOWNTO 0);
    TRIG0 : IN STD_LOGIC_VECTOR(7 DOWNTO 0));

end component;

begin

system_icon : icon
  port map (
    CONTROL0 => CONTROL0);
	 
system_ila : ila
  port map (
    CONTROL => CONTROL0,
    CLK => CLK,
    DATA => ila_data,
    TRIG0 => trig0);

process (Clk)
begin
    if rising_edge(Clk) then
	     counter <= counter + 1;
        if counter mod 2 = 0 then
            Clk25MHz <= not Clk25MHz;
            counter <= 0;
        end if;
    end if;
end process;

process (Clk25MHz)
begin
    if rising_edge(Clk25MHz) then
        if horizontalPositionCounter < (HD + HFP  + HSP + HBP - 1) then
				horizontalPositionCounter <= horizontalPositionCounter + 1;
		  else
            horizontalPositionCounter <= 0;
            if verticalPositionCounter < (VD + VFP + VSP + VBP - 1) then
					verticalPositionCounter <= verticalPositionCounter + 1;
            else
					verticalPositionCounter <= 0;
            end if;
        end if;
    end if;
end process;

process (Clk25MHz)
begin
    if rising_edge(Clk25MHz) then
        if horizontalPositionCounter < (HD + HFP) or horizontalPositionCounter > (HD + HFP + HSP) then
            ourHsync <= '1';
        else
            ourHsync <= '0';
        end if;
    end if;
end process;

process (Clk25MHz)
begin
    if rising_edge(Clk25MHz) then
        if verticalPositionCounter < (VD + VFP) or verticalPositionCounter > (VD + VFP + VSP) then
            ourVsync <= '1';
        else
            ourVsync <= '0';
        end if;
    end if;
end process;

process (Clk25MHz)
begin
    if rising_edge(Clk25MHz) then
        if horizontalPositionCounter < HD and verticalPositionCounter < VD then
            videoOn <= '1';
        else
            videoOn <= '0';
        end if;
    end if;
end process;

process (Clk25MHz)
begin
    if rising_edge(Clk25MHz) then
        if videoOn = '1' then
				if (y < 10 or y > 470) then
					R <= "00000000";
					G <= "11111111";
					B <= "00000000";

				 elsif (((y > 10 AND y < 20) AND (x > 20 AND x < 620)) OR  --upper horizontal strip
						 ((y < 470 AND y > 460) AND (x > 20 AND x < 620)) OR --bottom horizontal strip
						 (((y > 19 AND y < 160) OR (y > 320 AND y < 470)) AND (x > 20 AND x < 30)) OR 
						 --left vertical strips(upper then lower)
						 (((y > 19 AND y < 160) OR (y > 320 AND y < 470)) AND (x > 610 AND x < 620))) then 
						 ----right vertical strips
					  
					  R <= "11111111";
					  G <= "11111111";
					  B <= "11111111";
					  
				 elsif (((y > (ball_y - 8)) AND (y < (ball_y + 8)) AND (x > (ball_x - 8)) AND (x < (ball_x + 8)))) then
					  if (pause_counter > 0) then
							R <= "11111111";
							G <= "00000000";
							B <= "00000000";
					  else
							R <= "11111111";
							G <= "11111111";
							B <= "00000000";
					  end if;
					  
				 elsif ((x > 319 AND x < 321) AND (y > 19 AND y < 461)) then
					  
					  R <= "00000000";
					  G <= "00000000";
					  B <= "00000000";

				 elsif ((y > (player1_y - 40) AND y < (player1_y + 40)) AND
						 (x > 30 AND x < 40)) then
					  R <= "11111111";
					  G <= "00000000";
					  B <= "00000000";

				 elsif ((y > (player2_y - 40) AND y < (player2_y + 40)) AND
						 (x > 600 AND x < 610)) then
					  R <= "00000000";
					  G <= "00000000";
					  B <= "11111111";
						 
				 else
					  R <= "00000000";
					  G <= "11111111";
					  B <= "00000000";
			end if;
        else
            R <= "11111111";
            G <= "11111111";
            B <= "11111111";
        end if;
    end if;
end process;

process (Clk25MHz)
begin
    if rising_edge(Clk25MHz) then
        ball_delay_counter <= ball_delay_counter + 1;
        if (ball_delay_counter > ball_delay) then
            ball_delay_counter <= 0;

            ball_x <= ball_x + ball_x_direction;
            ball_y <= ball_y + ball_y_direction;

            if (((ball_x + ball_x_direction - 8) < 12) AND ((ball_y + ball_y_direction - 8) > 160) AND
                ((ball_y + ball_y_direction + 8) < 320)) then
                
                pause_counter <= pause_counter + 1;
                ball_x_direction <= 0;
                ball_y_direction <= 0;

                if (pause_counter = pause_delay) then
                    pause_counter <= 0;
                    ball_x <= 320;
                    ball_y <= 240;
                    ball_x_direction <= 1;
                    ball_y_direction <= 1;
                end if;
            end if;

            if (((ball_x + ball_x_direction + 8) >= 628) AND ((ball_y + ball_y_direction - 8) > 160) AND
                ((ball_y + ball_y_direction + 8) < 320)) then
                
                pause_counter <= pause_counter + 1;
                ball_x_direction <= 0;
                ball_y_direction <= 0;

                if (pause_counter = pause_delay) then
                    pause_counter <= 0;
                    ball_x <= 320;
                    ball_y <= 240;
                    ball_x_direction <= -1;
                    ball_y_direction <= 1;
                end if;
            end if;
            
            if (ball_y >= (player1_y - 40)) AND (ball_y <= (player1_y + 40)) AND (ball_x >= 38 AND ball_x <= 48) then
						ball_x_direction <= 1;
            end if;

            if (ball_y >= (player2_y - 40)) AND (ball_y <= (player2_y + 40)) AND (ball_x <= 608 AND ball_x >= 592) then
                        ball_x_direction <= -1;
            end if;

            if (ball_y <= 160 OR ball_y >= 320) then
                if ((ball_x + ball_x_direction + 8) > 612) then
                    ball_x_direction <= -1;
                elsif ((ball_x + ball_x_direction - 8) < 28) then
                    ball_x_direction <= 1;
                end if;
            end if;
            
            if ((ball_y + ball_y_direction + 8 ) > 460) then
                ball_y_direction <= -1;
            elsif ((ball_y + ball_y_direction - 8) < 20) then
                ball_y_direction <= 1;
            end if;
        end if;
    end if;
end process;

process (Clk25MHz)
begin
    if rising_edge(Clk25MHz) then
        input_delay_counter <= input_delay_counter + 1;
        if (input_delay_counter > input_delay) then
            input_delay_counter <= 0;

            if (Switches(0) = '1') then
                if (Switches(1) = '0') then 
                    player1_y <= player1_y + 2;
                else
                    player1_y <= player1_y - 2;
                end if;
            end if;

            if (Switches(2) = '1') then
                if (Switches(3) = '0') then 
                    player2_y <= player2_y + 2;
                else
                    player2_y <= player2_y - 2;
                end if;
            end if;

            if(player1_y > 420) then player1_y <= 420; end if;
            if(player1_y < 60) then player1_y <= 60; end if;
            if(player2_y > 420) then player2_y <= 420; end if;
            if(player2_y < 60) then player2_y <= 60; end if;
        end if;
    end if;
end process;

DAC_Clk <= Clk25MHz;

Vsync <= ourVsync;
Hsync <= ourHsync;

Rout <= R;
Gout <= G;
Bout <= B;

x <= horizontalPositionCounter;
y <= verticalPositionCounter;


ila_data(0) <= Clk25MHz;
ila_data(1) <= ourVsync;
ila_data(2) <= ourHsync;
ila_data(3) <= videoOn;

ila_data(11 downto 4) <= R;
ila_data(19 downto 12) <= G;
ila_data(27 downto 20) <= B;

ila_data(35 downto 28) <= std_logic_vector(to_unsigned(horizontalPositionCounter, 10));
ila_data(43 downto 36) <= std_logic_vector(to_unsigned(verticalPositionCounter, 10));


end Behavioral;

