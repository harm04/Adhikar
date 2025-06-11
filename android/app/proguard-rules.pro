# -------- ML Kit Text Recognition --------
-keep class com.google.mlkit.vision.text.** { *; }
-dontwarn com.google.mlkit.vision.text.**

-keep class com.google.mlkit.vision.text.chinese.** { *; }
-keep class com.google.mlkit.vision.text.devanagari.** { *; }
-keep class com.google.mlkit.vision.text.japanese.** { *; }
-keep class com.google.mlkit.vision.text.korean.** { *; }

# -------- Razorpay --------
-keep class com.razorpay.** { *; }
-keep interface com.razorpay.** { *; }
-dontwarn com.razorpay.**

# -------- Proguard Keep Annotations --------
-keepattributes *Annotation*
-keep class proguard.annotation.Keep
-keep class proguard.annotation.KeepClassMembers

# -------- Flutter Plugins --------
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.plugins.**

# -------- AndroidX --------
-keep class androidx.** { *; }
-dontwarn androidx.**
