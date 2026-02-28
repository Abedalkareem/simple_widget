package com.example.simple_widget

import android.content.Context
import android.util.Base64
import org.json.JSONArray
import org.json.JSONObject
import java.security.MessageDigest

object MigrationHelper {

  private const val MIGRATION_PREF = "SimpleWidgetMigration"
  private const val KEY_MIGRATED = "migrated_to_files"

  fun isMigrated(context: Context): Boolean {
    val prefs = context.getSharedPreferences(MIGRATION_PREF, Context.MODE_PRIVATE)
    return prefs.getBoolean(KEY_MIGRATED, false)
  }

  private fun setMigrated(context: Context) {
    val prefs = context.getSharedPreferences(MIGRATION_PREF, Context.MODE_PRIVATE)
    prefs.edit().putBoolean(KEY_MIGRATED, true).apply()
  }

  fun migrateBase64ToFiles(context: Context): Boolean {
    if (isMigrated(context)) {
      return false
    }

    val jsonString = AppSharedPreferences.getTimelinesData(context) ?: run {
      setMigrated(context)
      return false
    }

    try {
      val timelines = JSONArray(jsonString)
      var changed = false
      // Track already-saved hashes to deduplicate shared backgrounds
      val hashToPath = mutableMapOf<String, String>()

      for (i in 0 until timelines.length()) {
        val timeline = timelines.getJSONObject(i)
        val data = timeline.getJSONArray("data")

        for (j in 0 until data.length()) {
          val entry = data.getJSONObject(j)

          val bgValue = entry.optString("background", "")
          if (bgValue.isNotEmpty() && !bgValue.startsWith("widget_images/")) {
            val path = saveBase64AsFile(context, bgValue, hashToPath)
            if (path != null) {
              entry.put("background", path)
              changed = true
            }
          }

          val fgValue = entry.optString("foreground", "")
          if (fgValue.isNotEmpty() && !fgValue.startsWith("widget_images/")) {
            val path = saveBase64AsFile(context, fgValue, hashToPath)
            if (path != null) {
              entry.put("foreground", path)
              changed = true
            }
          }
        }
      }

      if (changed) {
        AppSharedPreferences.save(timelines.toString(), context)
      }

      setMigrated(context)
      return changed
    } catch (e: Exception) {
      e.printStackTrace()
      return false
    }
  }

  private fun saveBase64AsFile(
    context: Context,
    base64String: String,
    hashToPath: MutableMap<String, String>
  ): String? {
    return try {
      val bytes = Base64.decode(base64String, Base64.DEFAULT)
      val hash = md5(bytes)

      // Deduplicate: if we already saved an identical image, reuse its path
      hashToPath[hash]?.let { return it }

      val path = ImageFileManager.saveImage(context, bytes, null)
      hashToPath[hash] = path
      path
    } catch (e: Exception) {
      e.printStackTrace()
      null
    }
  }

  private fun md5(bytes: ByteArray): String {
    val digest = MessageDigest.getInstance("MD5")
    val hashBytes = digest.digest(bytes)
    return hashBytes.joinToString("") { "%02x".format(it) }
  }
}
