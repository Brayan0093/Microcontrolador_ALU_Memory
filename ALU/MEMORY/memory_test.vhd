library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity memory_test is
end memory_test;

architecture Behavioral of memory_test is

    -- Señales para conectar al DUT (Device Under Test)
    signal address  : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal data_in  : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal write    : STD_LOGIC := '0';
    signal clock    : STD_LOGIC := '0';
    signal data_out : STD_LOGIC_VECTOR(7 downto 0);

    -- Componente DUT
    component memory
        port (
            address  : in  STD_LOGIC_VECTOR(7 downto 0);
            data_in  : in  STD_LOGIC_VECTOR(7 downto 0);
            write    : in  STD_LOGIC;
            clock    : in  STD_LOGIC;
            data_out : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;

    -- Periodo del clock
    constant CLK_PERIOD : time := 10 ns;

begin

    -- Instancia del DUT
    DUT : memory
        port map (
            address  => address,
            data_in  => data_in,
            write    => write,
            clock    => clock,
            data_out => data_out
        );

    -- Generador de clock
    CLK_GEN : process
    begin
        clock <= '0';
        wait for CLK_PERIOD / 2;
        clock <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    -- Proceso de estimulos
    STIM : process
    begin

        -- =========================================
        -- TEST 1: Lectura en zona ROM (0 a 127)
        -- =========================================
        write   <= '0';
        data_in <= (others => '0');

        -- Leer posicion 0 de la ROM
        address <= std_logic_vector(to_unsigned(0, 8));
        wait for CLK_PERIOD * 2;

        -- Leer posicion 5 de la ROM
        address <= std_logic_vector(to_unsigned(5, 8));
        wait for CLK_PERIOD * 2;
        
        -- Leer posicion 10 de la ROM
        address <= std_logic_vector(to_unsigned(10, 8));
        wait for CLK_PERIOD * 2;
        
        -- Leer posicion 127 (ultimo de la ROM)
        address <= std_logic_vector(to_unsigned(127, 8));
        wait for CLK_PERIOD * 2;


        -- =========================================
        -- TEST 2: Escritura en zona RAM (128 a 223)
        -- =========================================

        -- Escribir 0xAB en posicion 128 
        address <= std_logic_vector(to_unsigned(128, 8));
        data_in <= x"CC";
        write   <= '1';
        wait for CLK_PERIOD * 2;
        write   <= '0';

        -- Escribir 0xCD en posicion 150 
        address <= std_logic_vector(to_unsigned(150, 8));
        data_in <= x"CD";
        write   <= '1';
        wait for CLK_PERIOD * 2;
        write   <= '0';

        -- Escribir 0xFF en posicion 223 (ultimo de la RAM, offset = 95)
        address <= std_logic_vector(to_unsigned(223, 8));
        data_in <= x"FF";
        write   <= '1';
        wait for CLK_PERIOD * 2;
        write   <= '0';
        
        address <= std_logic_vector(to_unsigned(255, 8));
        data_in <= x"99";
        write   <= '1';
        wait for CLK_PERIOD * 2;
        write   <= '0';

        -- =========================================
        -- TEST 3: Lectura en zona RAM
        -- =========================================

        -- Leer posicion 128 
        address <= std_logic_vector(to_unsigned(128, 8));
        wait for CLK_PERIOD * 2;

        -- Leer posicion 150 
        address <= std_logic_vector(to_unsigned(150, 8));
        wait for CLK_PERIOD * 2;

        -- Leer posicion 223 
        address <= std_logic_vector(to_unsigned(223, 8));
        wait for CLK_PERIOD * 2;

        -- Intentar leer posicion 224 
        address <= std_logic_vector(to_unsigned(224, 8));
        write   <= '0';
        wait for CLK_PERIOD * 2;

        -- Intentar leer posicion 255 
        address <= std_logic_vector(to_unsigned(255, 8));
        wait for CLK_PERIOD * 2;

        -- =========================================
        -- test 4 Verificar que ROM no se modifica
        -- =========================================

        -- Intentar escribir en zona ROM (no debe tener efecto)
        address <= std_logic_vector(to_unsigned(10, 8));
        data_in <= x"FF";
        write   <= '1';
        wait for CLK_PERIOD * 2;
        write   <= '0';

        -- Leer de nuevo la misma posicion ? debe seguir igual que antes
        address <= std_logic_vector(to_unsigned(10, 8));
        wait for CLK_PERIOD * 2;

        -- Fin de simulacion
        wait;

    end process;

end Behavioral;
