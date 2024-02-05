using Hello;

public class HelloWorldTest
{
    [Fact]
    public void TestSayHello()
    {
        HelloWorld hello = new HelloWorld();
        Assert.Equal(0, hello.sayHello());
    }
}
