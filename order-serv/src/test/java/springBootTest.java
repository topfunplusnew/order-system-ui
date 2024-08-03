import org.dzu.common.utils.DateUtils;
import org.junit.Test;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class springBootTest {
    @Test
    public void testPasswordEncoder() {
        BCryptPasswordEncoder encoder =new BCryptPasswordEncoder();
        String rawPassword = "123456";
        String encodedPassword = encoder.encode(rawPassword);
        System.out.println("Encoded password: " + encodedPassword);

        // Optional: Assert that the password matches
        boolean matches = encoder.matches(rawPassword, encodedPassword);
        System.out.println("Password matches: " + matches);
    }


    //测试Date和字符串的互相转换
    @Test
    public void testDate() throws ParseException {
        //获取当前时间
        System.out.println(DateUtils.getNowDate());
        Date nowDate = DateUtils.getNowDate();
        //Date转字符串
        String dateStr = DateUtils.parseDateToStr(DateUtils.YYYY_MM_DD, nowDate);
        System.out.println(dateStr);

        Date date = new Date(nowDate.toString());
        System.out.println(date);


        // 创建一个距离今天六天前的date
        Date date1 = new Date();
        date1.setTime(date1.getTime() - 6 * 24 * 60 * 60 * 1000);
        System.out.println(date1);
    }
}
