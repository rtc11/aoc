import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

plugins {
    kotlin("jvm")
}

dependencies {
    implementation("org.jetbrains.kotlin:kotlin-stdlib:1.6.0")
    implementation("com.diogonunes:JColor:5.2.0")
}

tasks {
    withType<KotlinCompile> {
        kotlinOptions.jvmTarget = "16"
    }
}

kotlin.sourceSets["main"].kotlin.srcDirs("code")
sourceSets["main"].resources.srcDir("input")
