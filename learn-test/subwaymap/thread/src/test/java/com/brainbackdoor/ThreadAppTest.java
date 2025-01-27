package com.brainbackdoor;

import org.junit.jupiter.api.Test;

import java.net.http.HttpResponse;
import java.util.concurrent.atomic.AtomicInteger;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * 1. ThreadApp 클래스의 애플리케이션을 실행시켜 서버를 띄운다.
 * 2. ThreadAppTest를 실행시킨다.
 * 3. ThreadAppTest가 아닌, ThreadApp의 콘솔에서 SampleController가 생성한 http call count 로그를 확인한다.
 * 4. application.yml에서 설정값을 변경해보면서 어떤 차이점이 있는지 분석해본다.
 */
public class ThreadAppTest {
    private static final AtomicInteger count = new AtomicInteger(0);

    @Test
    void test() throws Exception {
        final var NUMBER_OF_THREAD = 10;
        var threads = new Thread[NUMBER_OF_THREAD]; // Thread 10개 생성

        for (int i = 0; i < NUMBER_OF_THREAD; i++) {
            // NOTE: thread 0 번 부터 순차적으로 /test URL을 호출
            threads[i] = new Thread(() -> incrementIfOk(TestHttpUtils.send("/test")));
        }
        System.out.println("threads = " + threads.length);

        for (final var thread : threads) {
            thread.start();
            Thread.sleep(50);
        }

        for (final var thread : threads) {
            thread.join();
        }

        assertThat(count.intValue()).isEqualTo(2);
    }

    private static void incrementIfOk(final HttpResponse<String> response) {
        if (response.statusCode() == 200) {
            count.incrementAndGet();
        }
    }
}
