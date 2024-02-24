const assert = require("assert");
const HelloWorld = require("../src/helloworld").HelloWorld;

describe ("HelloWorld", () => {
  it ("should say hello", () => {
    const hello = new HelloWorld();
    assert.equal(hello.message, "Hello World!");
  });
})