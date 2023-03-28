library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

----------------------------------------------------------
-- Entity declaration for traffic light controller
----------------------------------------------------------

entity tlc is
  port (
    clk   : in    std_logic;
    rst   : in    std_logic;
    south : out   std_logic_vector(2 downto 0);
    west  : out   std_logic_vector(2 downto 0)
  );
end entity tlc;

----------------------------------------------------------
-- Architecture declaration for traffic light controller
----------------------------------------------------------

architecture behavioral of tlc is

  -- Define the FSM states
  type t_state is (
    WEST_STOP,
    WEST_GO,
    WEST_WAIT,
    SOUTH_STOP,
    SOUTH_GO,
    SOUTH_WAIT
  );

  -- Define the signal that uses different states
  signal sig_state : t_state;

  -- Internal clock enable
  signal sig_en : std_logic;

  -- Local delay counter
  signal sig_cnt : unsigned(4 downto 0);

  -- Specific values for local counter
  constant c_DELAY_4SEC : unsigned(4 downto 0) := b"1_0000";
  constant c_DELAY_2SEC : unsigned(4 downto 0) := b"0_1000";
  constant c_DELAY_1SEC : unsigned(4 downto 0) := b"0_0100";
  constant c_ZERO       : unsigned(4 downto 0) := b"0_0000";

  -- Output traffic lights' values
  constant c_RED    : std_logic_vector(2 downto 0) := b"100";
  constant c_YELLOW : std_logic_vector(2 downto 0) := b"110";
  constant c_GREEN  : std_logic_vector(2 downto 0) := b"010";

begin

  --------------------------------------------------------
  -- Instance (copy) of clock_enable entity generates
  -- an enable pulse every 250 ms (4 Hz)
  --------------------------------------------------------
  clk_en0 : entity work.clock_enable
    generic map (
      -- FOR SIMULATION, KEEP THIS VALUE TO 1
      -- FOR IMPLEMENTATION, CALCULATE VALUE: 250 ms / (1/100 MHz)
      -- 1   @ 10 ns
      -- ??? @ 250 ms
      g_MAX => 1
    )
    port map (
      clk => clk,
      rst => rst,
      ce  => sig_en
    );

  --------------------------------------------------------
  -- p_traffic_fsm:
  -- A sequential process with synchronous reset and
  -- clock_enable entirely controls the s_state signal by
  -- CASE statement.
  --------------------------------------------------------
  p_traffic_fsm : process (clk) is
  begin

    if (rising_edge(clk)) then
      if (rst = '1') then                    -- Synchronous reset
        sig_state <= WEST_STOP;              -- Init state
        sig_cnt   <= c_ZERO;                 -- Clear delay counter
      elsif (sig_en = '1') then
        case sig_state is

          when WEST_STOP =>
            if (sig_cnt < c_DELAY_2SEC) then
              sig_cnt <= sig_cnt + 1;
            else
              sig_state <= WEST_GO;
              sig_cnt <= c_ZERO;
            end if;

          when WEST_GO =>
            if (sig_cnt < c_DELAY_4SEC) then
              sig_cnt <= sig_cnt + 1;
            else
              sig_state <= WEST_WAIT;
              sig_cnt <= c_ZERO;
            end if;

          when WEST_WAIT =>
            if (sig_cnt < c_DELAY_1SEC) then
              sig_cnt <= sig_cnt + 1;
            else
              sig_state <= SOUTH_STOP;
              sig_cnt <= c_ZERO;
            end if;

          when SOUTH_STOP =>
            if (sig_cnt < c_DELAY_2SEC) then
              sig_cnt <= sig_cnt + 1;
            else
              sig_state <= SOUTH_GO;
              sig_cnt <= c_ZERO;
            end if;

          when SOUTH_GO =>
            if (sig_cnt < c_DELAY_4SEC) then
              sig_cnt <= sig_cnt + 1;
            else
              sig_state <= SOUTH_WAIT;
              sig_cnt <= c_ZERO;
            end if;

          when SOUTH_WAIT =>
            if (sig_cnt < c_DELAY_1SEC) then
              sig_cnt <= sig_cnt + 1;
            else
              sig_state <= WEST_STOP;
              sig_cnt <= c_ZERO;
            end if;

          when others =>
            sig_state <= WEST_STOP;
            sig_cnt   <= c_ZERO;

        end case;

      end if; -- Synchronous reset
    end if; -- Rising edge
  end process p_traffic_fsm;

  --------------------------------------------------------
  -- p_output_fsm:
  -- A combinatorial process is sensitive to state
  -- changes and sets the output signals accordingly.
  -- This is an example of a Moore state machine and
  -- therefore the output is set based on the active
  -- state only.
  --------------------------------------------------------
  p_output_fsm : process (sig_state) is
  begin

    case sig_state is
      when WEST_STOP =>
        south <= c_RED;
        west  <= c_RED;

      when WEST_GO =>
        south <= c_RED;
        west <= c_GREEN;

      when WEST_WAIT =>
        south <= c_RED;
        west <= c_YELLOW;

      when SOUTH_STOP =>
        south <= c_RED;
        west  <= c_RED;

      when SOUTH_GO =>
        south <= c_GREEN;
        west <= c_RED;

      when SOUTH_WAIT =>
        south <= c_YELLOW;
        west <= c_RED;
        
      when others =>
        south <= c_RED;
        west  <= c_RED;
    end case;

  end process p_output_fsm;

end architecture behavioral;
