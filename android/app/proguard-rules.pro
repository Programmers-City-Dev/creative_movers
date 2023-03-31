#=== Flutter Wrapper ===#
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-dontwarn io.flutter.embedding.**

-keep class com.github.chinloyal.pusher_client.** { *; }
# Add this global rule
-keepattributes Signature

-dontshrink

-dontwarn com.google.android.gms.**
-keep class com.google.android.gms.**{ *; }
-keep interface com.google.android.gms.** { *; }
-keepattributes EnclosingMethod
-keepattributes InnerClasses

# WebRTC

-keep class org.webrtc.** { *; }
-dontwarn org.chromium.build.BuildHooksAndroid

# Rule to avoid build errors related to SVGs.
-keep public class com.horcrux.svg.** {*;}