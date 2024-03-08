using System;

namespace Hello;

public class HelloWorld
{
    private string message;

    public HelloWorld()
    {
        this.message = "Hello, World!";
    }

    public int sayHello()
    {
        Console.WriteLine(this.message);
        return 0;
    }
}