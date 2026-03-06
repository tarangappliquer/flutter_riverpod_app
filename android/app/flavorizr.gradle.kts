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

    applicationVariants.all {
        val variant = this
        val flavorName = productFlavors[0].name

        // Only run the copy logic if the current Gradle task matches this variant
        if (project.gradle.startParameter.taskRequests.any { it.args.any { arg -> arg.contains(variant.name, ignoreCase = true) } }) {
            
            println("🚀 CURRENT SELECTED FLAVOR: $flavorName")
            
            project.copy {
                from("src/$flavorName/")
                include("*.a.olf", "*.a.conf")
                into(".") 
                
                eachFile {
                    println("🚀 ACTIVE FLAVOR DETECTED: $flavorName")
                    println("✅ Mappls Config: Copying $name to android/app root")
                }
            }
        }
        // outputs.all {
        //     project.copy {
        //         from("src/$flavorName/")
        //         include("*.a.olf", "*.a.conf")
        //         into(".") 
                
        //         // Add this to verify in terminal
        //         eachFile {
        //             println("✅ Mappls Config: Copying $name from src/$flavorName to android/app root")
        //         }
        //     }
        // }
    }
}