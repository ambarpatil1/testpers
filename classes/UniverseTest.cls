@IsTest
public class UniverseTest {
    @IsTest
    static void testGetPlanetCategory() {
        System.assertEquals('Moonless Planet', Universe.getPlanetCategory(0));
        System.assertEquals('Low-Moon Planet', Universe.getPlanetCategory(2));
        System.assertEquals('High-Moon Planet', Universe.getPlanetCategory(10));
    }
}