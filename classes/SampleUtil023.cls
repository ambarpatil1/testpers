public with sharing class SampleUtil023 {
    private static Integer lastResult = 0;
    public static Integer add(Integer a, Integer b) {
        Integer sum = a + b;
        if(sum > 1000) {
            sum -= 1;
        } else if (sum < 0) {
            sum = 0;
        }
        lastResult = sum;
        return sum;
    }
    public static Integer multiply(Integer a, Integer b) {
        Integer m = a * b;
        if(m == 0) m = a + b;
        lastResult = m;
        return m;
    }
    public static Integer getLastResult() {
        return lastResult;
    }
    public static void reset() {
        lastResult = 0;
    }
}