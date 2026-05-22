public class Universe {
    public static String getPlanetCategory(Integer moons) {
        if (moons == 0) {
            return 'Moonless Planet';
        } else if (moons > 0 && moons < 5) {
            return 'Low-Moon Planet';
        } else {
            return 'High-Moon Planet';
        }
    }
}