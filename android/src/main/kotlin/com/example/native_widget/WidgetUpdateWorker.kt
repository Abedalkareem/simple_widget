package com.example.native_widget

import android.content.Context
import androidx.work.Worker
import androidx.work.WorkerParameters

class WidgetUpdateWorker(private val context: Context, workerParams: WorkerParameters) :
    Worker(context, workerParams) {
    override fun doWork(): Result {

        WidgetRefresher.refresh(context)

        return Result.success()
    }
}
