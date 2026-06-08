library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity memory is
    port (
        address  : in  STD_LOGIC_VECTOR(7 downto 0);
        data_in  : in  STD_LOGIC_VECTOR(7 downto 0);
        write    : in  STD_LOGIC;
        clock    : in  STD_LOGIC;
        data_out : out STD_LOGIC_VECTOR(7 downto 0)
    );
end memory;

architecture Structural of memory is

    signal rom_data_out : STD_LOGIC_VECTOR(7 downto 0);
    signal ram_data_out : STD_LOGIC_VECTOR(7 downto 0);
    signal ram_address  : STD_LOGIC_VECTOR(6 downto 0);

    component rom_128x8_sync
        port (
            address  : in  STD_LOGIC_VECTOR(6 downto 0);
            clock    : in  STD_LOGIC;
            data_out : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;

    component rw_96x8_sync
        port (
            address  : in  STD_LOGIC_VECTOR(6 downto 0);
            data_in  : in  STD_LOGIC_VECTOR(7 downto 0);
            write    : in  STD_LOGIC;
            clock    : in  STD_LOGIC;
            data_out : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;

begin

    -- Process: traduce address para la RAM y controla la salida con IF
    MEM_CTRL : process(address, rom_data_out, ram_data_out)
    begin
        if unsigned(address) < to_unsigned(128, 8) then
            -- Zona ROM: 0 a 127
            ram_address <= (others => '0');  -- RAM inactiva, address en cero
            data_out    <= rom_data_out;

        elsif unsigned(address) <= to_unsigned(255, 8) then
            -- Zona RAM: 128 a 223  →  offset interno 0 a 95
            ram_address <= STD_LOGIC_VECTOR(unsigned(address(6 downto 0)));
            data_out    <= ram_data_out;

        else
            -- Fuera de rango: nadie responde
            ram_address <= (others => '0');
            data_out    <= (others => '0');
        end if;
    end process;

    -- Port map ROM
    ROM_INST : rom_128x8_sync
        port map (
            address  => address(6 downto 0),
            clock    => clock,
            data_out => rom_data_out
        );

    -- Port map RAM
    RAM_INST : rw_96x8_sync
        port map (
            address  => ram_address,
            data_in  => data_in,
            write    => write,
            clock    => clock,
            data_out => ram_data_out
        );

end Structural;