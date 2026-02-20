library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.dct_package.ALL;

entity dct_transform is
  Port (
    clk     : in  std_logic;
    reset   : in  std_logic;
    start   : in  std_logic;
    data_in : in  cos_matrix;
    done    : out std_logic;
    dct_out : out cos_matrix
   );
end dct_transform;

architecture rtl of dct_transform is

    signal busy       : std_logic := '0';

    signal i, j, x, y : integer range 0 to 7 := 0;
    signal i_reg, j_reg : integer range 0 to 7 := 0;

    constant CI0 : integer := 11585;
    constant CI1 : integer := 23170;

    signal acc        : integer := 0;
    signal acc1       : integer := 0;
    signal acc2       : integer := 0;

    signal stage      : integer range 0 to 3 := 0;

    function norm(idx : integer) return integer is
    begin
        if idx = 0 then
            return CI0;
        else
            return CI1;
        end if;
    end function;

begin

process(clk, reset)
    variable acc_final : integer;
begin
    if reset = '1' then

        busy   <= '0';
        done   <= '0';

        i <= 0; j <= 0;
        x <= 0; y <= 0;

        acc <= 0;
        acc1 <= 0;
        acc2 <= 0;

        stage <= 0;

    elsif rising_edge(clk) then

        done <= '0';  -- default

        if start = '1' and busy = '0' then

            busy  <= '1';
            i <= 0; j <= 0;
            x <= 0; y <= 0;
            acc <= 0;
            stage <= 0;

        elsif busy = '1' then

            case stage is

                ------------------------------------------------------------------
                -- STAGE 0: Accumulation
                ------------------------------------------------------------------
                when 0 =>

                    acc <= acc +
                          (to_integer(data_in(x,y)) *
                           to_integer(COS_X(i,x)) *
                           to_integer(COS_Y(j,y))) / 32768;

                    if y < 7 then
                        y <= y + 1;

                    elsif x < 7 then
                        x <= x + 1;
                        y <= 0;

                    else
                        i_reg <= i;
                        j_reg <= j;
                        stage <= 1;
                    end if;

                ------------------------------------------------------------------
                -- STAGE 1: Multiply norm(i)
                ------------------------------------------------------------------
                when 1 =>
                    acc1  <= acc * norm(i_reg);
                    stage <= 2;

                ------------------------------------------------------------------
                -- STAGE 2: Multiply norm(j)
                ------------------------------------------------------------------
                when 2 =>
                    acc2  <= acc1 * norm(j_reg);
                    stage <= 3;

                ------------------------------------------------------------------
                -- STAGE 3: Store result + update indices
                ------------------------------------------------------------------
                when 3 =>

                    acc_final := 32768 * 32768;

                    dct_out(i_reg, j_reg) <=
                        to_signed(acc2 / acc_final, 16);

                    acc <= 0;
                    x <= 0;
                    y <= 0;

                    if j < 7 then
                        j <= j + 1;
                        stage <= 0;

                    elsif i < 7 then
                        i <= i + 1;
                        j <= 0;
                        stage <= 0;

                    else
                        busy <= '0';
                        done <= '1';
                        stage <= 0;
                    end if;

                when others =>
                    stage <= 0;

            end case;

        end if;
    end if;
end process;

end rtl;