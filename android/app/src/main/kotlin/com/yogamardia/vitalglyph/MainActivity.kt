package com.yogamardia.vitalglyph

import android.content.Intent
import android.net.Uri
import android.provider.OpenableColumns
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterFragmentActivity() {
    private val CHANNEL = "com.yogamardia.vitalglyph/file_open"
    private var methodChannel: MethodChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        methodChannel!!.setMethodCallHandler { call, result ->
            if (call.method == "getInitialFile") {
                result.success(resolveFileFromIntent(intent))
            } else {
                result.notImplemented()
            }
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        val filePath = resolveFileFromIntent(intent)
        if (filePath != null) {
            methodChannel?.invokeMethod("onFileOpen", filePath)
        }
    }

    private fun resolveFileFromIntent(intent: Intent): String? {
        if (intent.action != Intent.ACTION_VIEW) return null
        val uri = intent.data ?: return null

        val path = when (uri.scheme) {
            "file" -> uri.path
            "content" -> copyContentToTemp(uri)
            else -> null
        } ?: return null

        // Only accept .medid files
        if (!path.endsWith(".medid", ignoreCase = true)) return null
        return path
    }

    private fun copyContentToTemp(uri: Uri): String? {
        return try {
            val inputStream = contentResolver.openInputStream(uri) ?: return null
            val displayName = getDisplayName(uri) ?: "backup.medid"
            val tempFile = File(cacheDir, displayName)
            tempFile.outputStream().use { output ->
                inputStream.use { input -> input.copyTo(output) }
            }
            tempFile.absolutePath
        } catch (e: Exception) {
            null
        }
    }

    private fun getDisplayName(uri: Uri): String? {
        val cursor = contentResolver.query(uri, null, null, null, null)
        cursor?.use {
            if (it.moveToFirst()) {
                val nameIndex = it.getColumnIndex(OpenableColumns.DISPLAY_NAME)
                if (nameIndex >= 0) return it.getString(nameIndex)
            }
        }
        return null
    }
}
