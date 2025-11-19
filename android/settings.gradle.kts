pluginManagement {
    val flutterSdkPath =
        run {
            val properties = java.util.Properties()
            file("local.properties").inputStream().use { properties.load(it) }
            val flutterSdkPath = properties.getProperty("flutter.sdk")
            require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
            flutterSdkPath
        }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        // ensure plugin artifacts can be resolved
        gradlePluginPortal()
        google()
        mavenCentral()
    }
}

// Ensure project dependencies are resolved from common repositories
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
        // fallback to plugin portal if needed
        maven { url = uri("https://plugins.gradle.org/m2/") }
    }
}

rootProject.name = "gratify"
include(":app")