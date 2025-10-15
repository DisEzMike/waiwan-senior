# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}

# Uncomment this to preserve the line number information for
# debugging stack traces.
#-keepattributes SourceFile,LineNumberTable

# If you keep the line number information, uncomment this to
# hide the original source file name.
#-renamesourcefileattribute SourceFile

# Keep OkHttp classes for ucrop
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }
-dontwarn okhttp3.**

# Keep ucrop classes
-keep class com.yalantis.ucrop.** { *; }
-dontwarn com.yalantis.ucrop.**

# Keep Retrofit classes if used
-keep class retrofit2.** { *; }
-dontwarn retrofit2.**

# Keep Gson classes if used
-keep class com.google.gson.** { *; }
-dontwarn com.google.gson.**

# Keep Google Play Core API classes
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**

# Keep Flutter classes
-keep class io.flutter.** { *; }
-dontwarn io.flutter.**

# Keep all classes that are referenced by reflection
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# Keep model classes
-keep class * extends java.lang.Object {
    <fields>;
}

# Keep all enums
-keepclassmembers enum * { *; }

# Keep native method names
-keepclasseswithmembernames class * {
    native <methods>;
}