# Pipeliner v0.6
> Ever wondered why we create test automation pipelines but we don't bother to automatically test those pipelines?

Pipeliner is a Bash & Docker based CI/CD extension to make pipelines maintainable. More than that, it's a [philosophy](#philosophy) to validate everything continuously using Test Driven Development.

## Portable & Easy to debug
- Everything runs in Docker & Bash
- Runs locally and in the Cloud
- Supports various CI/CD platforms
  - [Azure DevOps](https://azure.microsoft.com/en-us/products/devops/pipelines/), [Bitbucket Pipelines](https://bitbucket.org/product/features/pipelines), [GitHub Actions](https://github.com/features/actions), [GitLab Pipelines](https://docs.gitlab.com/ee/ci/pipelines/) and probably more
- Separation of concerns
- Automated testing
- [Get started](#get-started) in 2 seconds

## Alternatives
Pipeliner is not here to replace CI/CD platforms like GitHub Actions. Instead it's an extension to help you increase the reliability of your pipelines and to more easily develop, test & run them locally.

If you're looking for a full CI/CD pipeline platform replacement, have a look at [Dagger](https://dagger.io).

## Prerequisites
You'll need a Unix type of environment with following tools:
- Bash
- Docker
- Wget & Unzip (only for initial installation)

## License
This project is licensed under the terms of the [MIT license](LICENSE.md).

# Get started
To install Pipeliner in your current project directory, run:

```bash
wget -q -O - "https://github.com/MatthijsSchuurman/pipeliner/releases/latest/download/install" | bash
```
This will create 2 directories: `.pipeliner/` and `examples/` and now you're ready to go. If you know what you're doing already then delete the examples.
Next step is to setup your first script

## My first scripts
#### ./pipeline.sh
```bash
#!/bin/bash
source $(dirname ${BASH_SOURCE[0]})/.pipeliner/init #Load everything

App_Build #Build the app
```

#### ./app.sh
```bash
#!/bin/bash

source $(Files_Path_Pipeliner)/core/docker.sh

App_Build() {
  Docker_Build .pipeliner/core/Dockerfile core:runner #Build the pipeline runner container
  if [ $? != 0 ]; then exit 1; fi
  Docker_Run core:runner "touch somebuildfile.bin" #Run build command in the runner
}
```

#### ./app.test.sh
```bash
#!/bin/bash

source $(Files_Path_Root)/app.sh

IntegrationTest_App_Build() {
  #Given

  #When
  App_Build
  local exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_File_Exists $(Files_Path_Root)/somebuildfile.bin

  #Clean
  rm $(Files_Path_Root)/somebuildfile.bin
}
```
Now this is a lot more code compared to just running `touch somebuildfile.bin`. However **building a pipeline is not a quick fix** but a fundamental piece of the [SDLC](https://en.wikipedia.org/wiki/Systems_development_life_cycle) infrastructure. It needs to be 100% reliable otherwise your team will grind to a halt. Hence the [philosophy](#philosophy) to build pipelines that are maintainable.

For more examples please check the [examples/](../examples/) directory.


# Philosophy
The key to success is [TDD](https://en.wikipedia.org/wiki/Test-driven_development). Like with any software project (and CI/CD pipelines are exactly that) writing 1 big `main()` loop is not a very maintainable way of creating code. There are many schools of thought on how to structure code but no matter how you slice it, the simpler you can test your code the more reliable it becomes.

So this chapter gives you some guidance on how to get to easily testable code.

First of all, use the `.pipeliner/test` script to continuously run tests on your code. Just hit save on `some.sh` file and it will run all tests defined in `test/some.sh`.
```bash
.pipeliner/test --watch
```

## Test types
What do you test when and how?

Within Pipeliner there are 3 types of test: *Unit*, *Integration* and *End-to-end* tests. What is important to realise is that depending on what your trying to prove a different type of test should be used. Now for writing them there is no technical difference, but what you validate is.

### Unit testing
The goal is to validate the **technical building blocks**.

Technical building blocks are simple input/output operations with few or no dependencies and no business logic. This makes unit tests easy to write, quick to run and can validate a lot of variety. This should account for about 80% of your total tests.

```bash
UnitTest_trim() {
  #Given
  local string="  a b c  "

  #When
  local result=$(trim "$string")

  #Then
  Assert_Equal "$result" "a b c"
}
```

### Integration testing
The goal is to validate the **functional building blocks**.

Functional building blocks is where you business logic sits, i.e. *what you're trying to do*. This glues together the technical building blocks to create business outcome.

For example you may have some technical building blocks like `Compression` and `Files`. You can use those to create Zip file with some *relevant data* in it. The technical building blocks should be completely agnostic to what files end up in the Zip, yet the functional building block holds the logic to determine what is *relevant*.

Note that [mocking](#mocking) is your friend here, even more so than with [unit testing](#unit-testing). You don't want to have to rely on external or complex dependencies as that makes testing your functional building blocks hard. And besides, that is what [E2E testing](#e2e-testing) is for.

```bash
IntegrationTest_Examples_DotNet_Pipelines_Stage_Test() {
  #Given
  source $(Files_Path_Pipeliner)/init

  #When
  DotNet_Pipelines_Stage_Test examples/dotnet/app1

  #Then
  Assert_File_Exists $(Files_Path_Root)/examples/dotnet/app1/test-report.xml
  Assert_File_Exists $(Files_Path_Root)/examples/dotnet/app1/lint-report.json

  #Clean
  rm $(Files_Path_Root)/examples/dotnet/app1/test-report.xml
  rm $(Files_Path_Root)/examples/dotnet/app1/lint-report.json
}
```

### E2E testing
The goal is to validate the **full flow**.

The full flow typically consistent of a number of functional building blocks orchestrated together. This will be the full logic that is needed to achieve whatever the end goal is.

Testing here is purely focused on validating the end result and not the intermediate steps & logic. As this should have been validated with [integration](#integration-testing) & [unit](#unit-testing) testing.

Don't mock on this level as what you're trying to prove is that everything works. Consequently keep your tests simple as they are going to be slow and running a lot of logic.

In the context of pipelines this is generally a shellscript that you test rather than a function.

```bash
E2ETest_Test_Include() {
  #Given
  local actual=
  local exitCode=

  #When
  actual=$($(Files_Path_Pipeliner)/test --type dontrunanytests --include colors)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Contains "$actual" "Pipeliner core utils colors"
  Assert_Match "$actual" "Color Red: .+SKIP"
}
```

## Mocking
Mocking is a very powerful tool for automation testing. Simply put: you can swap out complex dependencies with static results to make your test simpler, quicker and more reliable.

```bash
UnitTest_Log_Debug_Azure() {
  #Given
  Environment_Platform() { #mock
    echo "azure"
  }

  #When
  local actual=$(Log_Debug "debug message")

  #Then
  Assert_Contains "$actual" "##[debug]" "debug message"
}
```
The `Environment_Platform` is a complex dependency as it relies on things out of control of the test. `Log_Debug` uses `Environment_Platform` and behaves differently depending on the platform type.

To test all variants you would normally have to run this on all platforms (e.g. local, azure, github, etc). By mocking the value can easily work around that problem.

Another way mocking can help to reduce complexity in the tests is by making values more static as shown in this example.
```bash
IntegrationTest_Pipeliner_Test_Run() {
  #Given
  local exitCode=

  Version_Pipeliner_Full() { #mock
    echo "1.2.345-test"
  }

  #When
  Pipeliner_Test_Run
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0

  Assert_Match "$(Variables_Get testReport)" "$(Files_Path_Root)/test_report-1.2.345-test.txt"
  Assert_File_Exists $(Files_Path_Root)/test_report-1.2.345-test.txt

  #Clean
  rm $(Files_Path_Root)/test_report-1.2.345-test.txt
}
```
By mocking `Version_Pipeliner_Full` you can assume the filename of the test report and even validate logic based on it. Rather than having to go and figure out the name (or adding workarounds in the code to somehow get the filename out).

# Tools

## Files & Directory
[.pipeliner](../.pipeliner/)/        *Main pipeliner directory*
- [core](../.pipeliner/core/)/       *Core libraries*
- [dotnet](../.pipeliner/dotnet/)/   *.NET libraries*
- [haskell](../.pipeliner/haskell/)/ *Haskell & Cabal libraries*
- [jvm](../.pipeliner/jvm/)/         *JVM (Java & Kotlin) / Gradle libraries*
- [node](../.pipeliner/node/)/       *Node & NPM libraries*
- [php](../.pipeliner/php/)/         *PHP & Composer libraries*

[.pipeliner](../.pipeliner/)/        *Main scripts*
- [docker](../.pipeliner/docker)     *Quickly [run something in docker](#docker)*
- [init](../.pipeliner/init)         *Initialise pipeliner in your pipeline*
- [install](../.pipeliner/install)   *Install/Upgrade pipeliner in current directory*
- [test](../.pipeliner/test)         *Run [tests](#philosophy)*

[examples](../examples/)/            *Various pipeline examples*


## Docker
Pipeliner relies heavily on Docker it's probably useful to easily run various things in Docker:
```bash
.pipeliner/docker --image node "npm install"
```
Or login to the container itself:
```bash
.pipeliner/docker --image dotnet
```