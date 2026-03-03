import com.android.build.gradle.AppExtension

val android = project.extensions.getByType(AppExtension::class.java)

android.apply {
    flavorDimensions("flavor-type")

    productFlavors {
        create("dev") {
            dimension = "flavor-type"
            applicationId = "com.dev.flavorsdemo"
            resValue(type = "string", name = "app_name", value = "Development Flavor")
            resValue(type = "string", name = "google_maps_api_key", value = "AIza-DEV-KEY-HERE")
        }
        create("staging") {
            dimension = "flavor-type"
            applicationId = "com.staging.flavorsdemo"
            resValue(type = "string", name = "app_name", value = "Staging App")
            resValue(type = "string", name = "google_maps_api_key", value = "AIza-STAGING-KEY-HERE")
        }
        create("prod") {
            dimension = "flavor-type"
            applicationId = "com.production.flavorsdemo"
            resValue(type = "string", name = "app_name", value = "Production App")
            resValue(type = "string", name = "google_maps_api_key", value = "AIza-PROD-KEY-HERE")
        }
    }
}