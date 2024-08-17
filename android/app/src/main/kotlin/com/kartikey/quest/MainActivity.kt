package com.kartikey.quest

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import android.speech.tts.TextToSpeech
import java.util.*

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.questias/tts"
    private lateinit var tts: TextToSpeech

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        tts = TextToSpeech(this) { status ->
            if (status != TextToSpeech.ERROR) {
                tts.language = Locale.US
            }
        }

        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "speak" -> {
                    val text = call.argument<String>("text")
                    if (text != null) {
                        tts.speak(text, TextToSpeech.QUEUE_FLUSH, null, null)
                        result.success("Success")
                    } else {
                        result.error("Error", "Text is null", null)
                    }
                }
                "stop" -> {
                    tts.stop()
                    result.success("Stopped")
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    override fun onDestroy() {
        tts.stop()
        tts.shutdown()
        super.onDestroy()
    }
}