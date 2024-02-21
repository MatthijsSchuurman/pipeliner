import java.lang.String;

public class HelloWorld {
    private String message;

    public HelloWorld() {
        this.message = "Hello World!";
    }

    public int sayHello() {
        System.out.println(this.message);
        return 0;
    }
}