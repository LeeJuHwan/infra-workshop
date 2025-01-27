package com.brainbackdoor;

import org.junit.jupiter.api.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.concurrent.Executors;
import java.util.concurrent.ThreadPoolExecutor;

import static org.assertj.core.api.Assertions.assertThat;

public class ThreadPoolsTest {
    private static final Logger log = LoggerFactory.getLogger(ThreadPoolsTest.class);

    @Test
    void newFixedThreadPoolTest() {
        // NOTE: 2개의 고정 쓰레드를 생성
        final var executor = (ThreadPoolExecutor) Executors.newFixedThreadPool(2);
        // NOTE: 고정 쓰레드에서 2개를 할당하고 나머지 1개는 큐에 저장
        executor.submit(log("fixed thread pools"));
        executor.submit(log("fixed thread pools"));
        executor.submit(log("fixed thread pools"));

        final int expectedPoolSize = 2;
        final int expectedQueueSize = 1;
        // NOTE: 결론적으로 고정 쓰레드를 생성한만큼 할당하고 남은 만큼은 큐에 담아둔다.
        assertThat(expectedPoolSize).isEqualTo(executor.getPoolSize());
        assertThat(expectedQueueSize).isEqualTo(executor.getQueue().size());
    }

    @Test
    void newCachedThreadPoolTest() {
        // NOTE: 캐시 쓰레드 풀을 생성
        final var executor = (ThreadPoolExecutor) Executors.newCachedThreadPool();

        // NOTE: 캐시 쓰레드는 이미 사용중인 쓰레드가 있다면 새롭게 생성, 사용하지 않는다면(60초 동안) 리소스 제거
        executor.submit(log("cached thread pools"));
        executor.submit(log("cached thread pools"));
        executor.submit(log("cached thread pools"));

        final int expectedPoolSize = 3;
        final int expectedQueueSize = 0; //TODO: 알맞은 값으로 변경해보세요.

        // NOTE: 결론적으로 3개의 쓰레드가 새롭게 생성되서 할당되고 큐에 담기지 않음
        assertThat(expectedPoolSize).isEqualTo(executor.getPoolSize());
        assertThat(expectedQueueSize).isEqualTo(executor.getQueue().size());
    }

    private Runnable log(final String message) {
        return () -> {
            try {
                Thread.sleep(1000);
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }
            log.info(message);
        };
    }
}
