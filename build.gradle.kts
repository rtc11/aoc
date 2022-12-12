plugins {
    kotlin("jvm") version "1.7.21"
}

subprojects {
    repositories {
        mavenCentral()
    }

    apply(plugin = "org.jetbrains.kotlin.jvm")

    tasks {
        withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile> {
            kotlinOptions.jvmTarget = "18"
        }
    }

    kotlin.sourceSets["main"].kotlin.srcDirs("code")
    sourceSets["main"].resources.srcDir("input")
}
