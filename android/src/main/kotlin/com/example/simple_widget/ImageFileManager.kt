package com.example.simple_widget

import android.content.Context
import java.io.File
import java.util.UUID

object ImageFileManager {

  private const val IMAGE_DIR = "widget_images"

  fun getImageDir(context: Context): File {
    val dir = File(context.filesDir, IMAGE_DIR)
    if (!dir.exists()) {
      dir.mkdirs()
    }
    return dir
  }

  fun saveImage(context: Context, bytes: ByteArray, filename: String?): String {
    val dir = getImageDir(context)
    val name = filename ?: "${UUID.randomUUID()}.png"
    val file = File(dir, name)
    file.writeBytes(bytes)
    return "$IMAGE_DIR/$name"
  }

  fun deleteImages(context: Context, relativePaths: List<String>) {
    for (path in relativePaths) {
      val file = File(context.filesDir, path)
      if (file.exists()) {
        file.delete()
      }
    }
  }

  fun readImage(context: Context, relativePath: String): ByteArray? {
    val file = File(context.filesDir, relativePath)
    if (file.exists()) {
      return file.readBytes()
    }
    return null
  }

  fun getBasePath(context: Context): String {
    return context.filesDir.absolutePath
  }
}
