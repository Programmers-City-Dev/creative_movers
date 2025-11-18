#=== Flutter Wrapper ===#
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.embedding.**

# Pusher Client
-keep class com.github.chinloyal.pusher_client.** { *; }
# Add this global rule
-keepattributes Signature

# Firebase (Analytics, Messaging, Storage, Firestore, etc.)
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**
-keep interface com.google.firebase.** { *; }

# Play Services
-keep class com.google.android.gms.** { *; }
-keep interface com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

# Attributes to keep
-keepattributes Signature
-keepattributes EnclosingMethod
-keepattributes InnerClasses

# WebRTC

-keep class org.webrtc.** { *; }
-dontwarn org.chromium.build.BuildHooksAndroid

# SVG support
-keep public class com.horcrux.svg.** { *; }

# Prevent removing required classes
-dontshrink



-dontwarn androidx.window.extensions.WindowExtensions
-dontwarn androidx.window.extensions.WindowExtensionsProvider
-dontwarn androidx.window.extensions.area.ExtensionWindowAreaPresentation
-dontwarn androidx.window.extensions.area.ExtensionWindowAreaStatus
-dontwarn androidx.window.extensions.area.WindowAreaComponent
-dontwarn androidx.window.extensions.embedding.ActivityEmbeddingComponent
-dontwarn androidx.window.extensions.embedding.ActivityRule$Builder
-dontwarn androidx.window.extensions.embedding.ActivityRule
-dontwarn androidx.window.extensions.embedding.ActivityStack
-dontwarn androidx.window.extensions.embedding.EmbeddingRule
-dontwarn androidx.window.extensions.embedding.SplitAttributes$Builder
-dontwarn androidx.window.extensions.embedding.SplitAttributes$SplitType$ExpandContainersSplitType
-dontwarn androidx.window.extensions.embedding.SplitAttributes$SplitType$HingeSplitType
-dontwarn androidx.window.extensions.embedding.SplitAttributes$SplitType$RatioSplitType
-dontwarn androidx.window.extensions.embedding.SplitAttributes$SplitType
-dontwarn androidx.window.extensions.embedding.SplitAttributes
-dontwarn androidx.window.extensions.embedding.SplitAttributesCalculatorParams
-dontwarn androidx.window.extensions.embedding.SplitInfo
-dontwarn androidx.window.extensions.embedding.SplitPairRule$Builder
-dontwarn androidx.window.extensions.embedding.SplitPairRule
-dontwarn androidx.window.extensions.embedding.SplitPlaceholderRule$Builder
-dontwarn androidx.window.extensions.embedding.SplitPlaceholderRule
-dontwarn androidx.window.extensions.layout.DisplayFeature
-dontwarn androidx.window.extensions.layout.FoldingFeature
-dontwarn androidx.window.extensions.layout.WindowLayoutComponent
-dontwarn androidx.window.extensions.layout.WindowLayoutInfo
-dontwarn androidx.window.sidecar.SidecarDeviceState
-dontwarn androidx.window.sidecar.SidecarDisplayFeature
-dontwarn androidx.window.sidecar.SidecarInterface$SidecarCallback
-dontwarn androidx.window.sidecar.SidecarInterface
-dontwarn androidx.window.sidecar.SidecarProvider
-dontwarn androidx.window.sidecar.SidecarWindowLayoutInfo
-dontwarn com.google.api.client.http.GenericUrl
-dontwarn com.google.api.client.http.HttpHeaders
-dontwarn com.google.api.client.http.HttpRequest
-dontwarn com.google.api.client.http.HttpRequestFactory
-dontwarn com.google.api.client.http.HttpResponse
-dontwarn com.google.api.client.http.HttpTransport
-dontwarn com.google.api.client.http.javanet.NetHttpTransport$Builder
-dontwarn com.google.api.client.http.javanet.NetHttpTransport
-dontwarn com.squareup.okhttp.CipherSuite
-dontwarn com.squareup.okhttp.ConnectionSpec
-dontwarn com.squareup.okhttp.TlsVersion
-dontwarn org.joda.time.Instant
-dontwarn org.slf4j.impl.StaticLoggerBinder
-dontwarn org.slf4j.impl.StaticMDCBinder
-dontwarn org.slf4j.impl.StaticMarkerBinder
