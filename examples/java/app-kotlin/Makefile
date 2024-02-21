all: HelloWorld.jar

HelloWorld.jar: hello.kt main.kt
	@kotlinc -include-runtime -d $@ $^

run: HelloWorld.jar
	@java -jar $<

clean:
	@rm -f HelloWorld.jar