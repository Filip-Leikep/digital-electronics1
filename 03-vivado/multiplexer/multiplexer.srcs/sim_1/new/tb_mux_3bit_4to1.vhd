----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.02.2023 12:37:25
-- Design Name: 
-- Module Name: tb_mux_3bit_4to1 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_mux_3bit_4to1 is
    
end tb_mux_3bit_4to1;

architecture Behavioral of tb_mux_3bit_4to1 is
    signal sel  :   std_logic_vector(2 - 1 downto 0);
    signal a    :   std_logic_vector(3 - 1 downto 0);
    signal b    :   std_logic_vector(3 - 1 downto 0);
    signal c    :   std_logic_vector(3 - 1 downto 0);
    signal d    :   std_logic_vector(3 - 1 downto 0);
    signal y    :   std_logic_vector(3 - 1 downto 0);
    
begin


end Behavioral;
