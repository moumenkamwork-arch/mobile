allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    if (project.name != "app") {
        project.ext.set("flutterCompileSdkVersion", 36)
        project.ext.set("flutterMinSdkVersion", 21)
        project.ext.set("flutterTargetSdkVersion", 34)
        project.ext.set("flutter", mapOf(
            "compileSdkVersion" to 36,
            "minSdkVersion" to 21,
            "targetSdkVersion" to 34
        ))
    }
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
