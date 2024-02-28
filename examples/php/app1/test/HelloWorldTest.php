<?php

use PHPUnit\Framework\TestCase;

final class HelloWorldTest extends TestCase
{
    public function testSayHello()
    {
        $helloWorld = new HelloWorld();

        // Capture the output of the sayHello method
        ob_start();
        $ret=$helloWorld->sayHello();
        $output = ob_get_clean();

        $this->assertEquals('Hello World!', $output);
        $this->assertEquals(0, $ret);
    }
}