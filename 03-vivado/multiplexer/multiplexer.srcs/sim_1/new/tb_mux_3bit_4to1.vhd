library ieee;
use ieee.std_logic_1164.all;

entity tb_mux_3bit_4to1 is 
end entity tb_mux_3bit_4to1;

architecture testbench of tb_mux_3bit_4to1 is
    signal sel  :   std_logic_vector(2 - 1 downto 0);
    signal a    :   std_logic_vector(3 - 1 downto 0);
    signal b    :   std_logic_vector(3 - 1 downto 0);
    signal c    :   std_logic_vector(3 - 1 downto 0);
    signal d    :   std_logic_vector(3 - 1 downto 0);
    signal y    :   std_logic_vector(3 - 1 downto 0);
    
begin

	uut_gates : entity work.mux_3bit_4to1
        port map(
            a_i      => a,
            b_i      => b,
            c_i      => c,
            d_i      => d,
            y_o      => y,
            sel_i    => sel

        );

	p_stimulus : process
        begin

        a   <= "000";
        b   <= "001";
        c   <= "010";
        d   <= "011";
        sel <= "00";
        wait for 50 ns;
        sel <= "01";
        wait for 50 ns;
        sel <= "10";
        wait for 50 ns;
        sel <= "11";
        wait for 50 ns;
        report "Stimulus process finished" severity note;
        wait;
	end process p_stimulus;

end architecture testbench;