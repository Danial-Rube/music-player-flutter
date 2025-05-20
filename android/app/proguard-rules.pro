# خطوط مورد نیاز برای just_audio
-keep class com.google.android.exoplayer2.** { *; }

# خطوط مورد نیاز برای on_audio_query
-keep class * implements android.os.Parcelable {
  public static final android.os.Parcelable$Creator *;
}