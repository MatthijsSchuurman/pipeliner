const assert = require('assert');
const HelloWorld = require('./index').HelloWorld;

describe ('HelloWorld', () => {
  it ('should say hello', () => {
    const hello = new HelloWorld();
    assert.equal(hello.message, 'Hello, World!');
  });
})