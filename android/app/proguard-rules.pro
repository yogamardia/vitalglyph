# Flutter-specific rules
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep home_widget classes
-keep class es.antonborri.home_widget.** { *; }

# Keep encrypt/crypto classes
-keep class org.bouncycastle.** { *; }
-dontwarn org.bouncycastle.**
