package com.example

class HelloWorld {
    private var message: String

    init {
        this.message = "Hello, World!"
    }

    fun sayHello(): Int {
        println(message)
        return 0
    }
}