import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

plugins {
    kotlin("jvm") version "1.9.22"
    application
}

group = "org.example"
version = "1.0-SNAPSHOT"

repositories {
    mavenCentral()
}

dependencies {
    implementation(kotlin("stdlib"))

    testImplementation("junit:junit:4.13.2")
}

kotlin {
    jvmToolchain(21)
}

sourceSets {
    main {
        kotlin {
            srcDirs("src/main/kotlin", "./src/")
        }
    }
    test {
        kotlin {
            srcDirs("src/test/kotlin", "./test/")
        }
    }
}

application {
    mainClass.set("MainKt")
}