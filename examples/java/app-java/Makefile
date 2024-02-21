all: HelloWorld.jar

HelloWorld.jar: HelloWorld.java Main.java
	@javac HelloWorld.java Main.java
	@jar cfe $@ Main Main.class HelloWorld.class

run: HelloWorld.jar
	@java -jar $<

clean:
	@rm -f HelloWorld.jar *.class