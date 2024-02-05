class HelloWorld {
  constructor() {
    this.message = 'Hello, World!';
  }

  sayHello() {
    console.log(this.message);
  }
}

// Create an instance of the HelloWorld class
const hello = new HelloWorld();

// Call the sayHello method
hello.sayHello();

exports.HelloWorld = HelloWorld;