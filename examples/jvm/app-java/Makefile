JUNIT_JAR = ../junit-4.x.jar
JUNIT_URL = https://repo1.maven.org/maven2/junit/junit/4.13.2/junit-4.13.2.jar

HAMCREST_JAR = ../hamcrest-core-1.x.jar
HAMCREST_URL = https://repo1.maven.org/maven2/org/hamcrest/hamcrest-core/1.3/hamcrest-core-1.3.jar


#Main targets

all: build test run

clean:
	@rm -Rf *.jar *.class build

build: HelloWorld.jar

test: junit-install hamcrest-install HelloWorldTest.jar
	@java -cp .:$(JUNIT_JAR):$(HAMCREST_JAR):HelloWorld.jar:HelloWorldTest.jar org.junit.runner.JUnitCore HelloWorldTest

run: build
	@java -jar HelloWorld.jar Main


#Build targets

HelloWorld.jar: HelloWorld.java Main.java
	@javac $^
	@jar cfe $@ Main Main.class HelloWorld.class

HelloWorldTest.jar: HelloWorldTest.java
	@javac -cp .:$(JUNIT_JAR):$(HAMCREST_JAR):HelloWorld.jar -d build $^
	@jar cvfe $@ HelloWorldTest -C build .


#Dependency targets

junit-install:
	@if [ ! -f $(JUNIT_JAR) ]; then $(MAKE) junit-download; fi
junit-download:
	@curl -L -o $(JUNIT_JAR) $(JUNIT_URL)

hamcrest-install:
	@if [ ! -f $(HAMCREST_JAR) ]; then $(MAKE) hamcrest-download; fi
hamcrest-download:
	@curl -L -o $(HAMCREST_JAR) $(HAMCREST_URL)