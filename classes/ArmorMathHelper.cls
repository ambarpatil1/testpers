public with sharing class ArmorMathHelper {

    public static Integer square(Integer value) {
        return value * value;
    }

    public static Integer cube(Integer value) {
        return value * value * value;
    }

    public static Decimal average(List<Integer> nums) {
        Integer total = 0;

        for(Integer n : nums){
            total += n;
        }

        if(nums.isEmpty()){
            return 0;
        }

        return Decimal.valueOf(total) / nums.size();
    }

    public static Boolean isEven(Integer value){
        return Math.mod(value,2) == 0;
    }
}