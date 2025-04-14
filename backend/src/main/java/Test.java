import java.time.LocalDate;

public class Test {
    public static void main(String[] args) {
        LocalDate localDate = LocalDate.parse("2025-03-01");
        System.out.println("주차==" + getWeekOfDate(localDate));
    }

    public static int getWeekOfDate(LocalDate date) {
        // date에서 day만 1로 변경
        LocalDate firstDay = date.withDayOfMonth(1);

        // 요일 추출 (일~토 = 0~6로 맞추기)
        int firstDayWeekValue = (firstDay.getDayOfWeek().getValue()) % 7;

        int day = date.getDayOfMonth();

        return (day + firstDayWeekValue -1) / 7 + 1;
    }
}
