library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity test_alu is
end entity test_alu;

architecture ARCH_TB of test_alu is

    component ALU
        port(
            A     : in  std_logic_vector(7 downto 0);
            B     : in  std_logic_vector(7 downto 0);
            Sel   : in  std_logic;
            Y     : out std_logic_vector(7 downto 0);
            Carry : out std_logic;
            Ovf   : out std_logic;
            Neg   : out std_logic;  -- Pos eliminado
            Zero  : out std_logic
        );
    end component;

    signal A_tb     : std_logic_vector(7 downto 0) := (others => '0');
    signal B_tb     : std_logic_vector(7 downto 0) := (others => '0');
    signal Sel_tb   : std_logic := '0';
    signal Y_tb     : std_logic_vector(7 downto 0);
    signal Carry_tb : std_logic;
    signal Ovf_tb   : std_logic;
    signal Neg_tb   : std_logic;    -- Pos_tb eliminado
    signal Zero_tb  : std_logic;

begin

    UUT: ALU
        port map(
            A     => A_tb,
            B     => B_tb,
            Sel   => Sel_tb,
            Y     => Y_tb,
            Carry => Carry_tb,
            Ovf   => Ovf_tb,
            Neg   => Neg_tb,        -- Pos eliminado
            Zero  => Zero_tb
        );

    process
    begin
        -- Estabilizaci�n inicial
        A_tb   <= x"00";
        B_tb   <= x"00";
        Sel_tb <= '0';
        wait for 10 ns;

        -- CASO 1: Suma 20 + 5 = 25
        -- Y=0x19, Carry=0, Ovf=0, Neg=0, Zero=0
        A_tb   <= x"14";
        B_tb   <= x"05";
        Sel_tb <= '0';
        wait for 20 ns;

        -- CASO 2: Resta 10 + 15 = 25
        -- Y=0x0F, Carry=0, Ovf=0, Neg=0, Zero=0
        A_tb   <= x"0A";
        B_tb   <= x"0F";
        Sel_tb <= '0';
        wait for 20 ns;

        -- CASO 3: Resta cero 10 - 2 = 8
        -- Y=0x00, Carry=0, Ovf=0, Neg=0, Zero=1
        A_tb   <= x"0A";
        B_tb   <= x"02";
        Sel_tb <= '1';
        wait for 20 ns;

        -- CASO 4: Suma con carry 200 + 100 = 300
        -- Y=0x2C, Carry=1, Ovf=1, Neg=0, Zero=0
        A_tb   <= x"C8";
        B_tb   <= x"64";
        Sel_tb <= '0';
        wait for 20 ns;

        -- CASO 5: Underflow 0 - 1
        -- Y=0xFF, Carry=0, Ovf=1, Neg=0, Zero=0
        A_tb   <= x"00";
        B_tb   <= x"01";
        Sel_tb <= '1';
        wait for 20 ns;

        wait;
    end process;

end architecture ARCH_TB;