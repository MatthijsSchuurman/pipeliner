package com.example

import org.junit.Test
import org.junit.Assert.assertEquals

class HelloWorldTest {

    @Test
    fun testSayHello() {
        val helloWorld = HelloWorld()
        assertEquals(0, helloWorld.sayHello())
    }
}