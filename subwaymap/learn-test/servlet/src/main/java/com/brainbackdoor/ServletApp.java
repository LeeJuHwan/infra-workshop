package com.brainbackdoor;

public class ServletApp {
    public static void main(String[] args) throws Exception {
        final var tomcatStarter = new TomcatStarter();
        tomcatStarter.start();
        tomcatStarter.await();
    }
}
