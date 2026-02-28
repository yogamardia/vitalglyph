package com.example.vitalglyph

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.graphics.BitmapFactory
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin

/**
 * AppWidgetProvider for the VitalGlyph home screen widget.
 *
 * Displays a Medical ID QR code, profile name, and blood type.
 * Data is populated by [WidgetService] in Flutter via the home_widget plugin.
 * Tapping the widget launches the app.
 */
class VitalglyphWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
    ) {
        for (appWidgetId in appWidgetIds) {
            updateWidget(context, appWidgetManager, appWidgetId)
        }
    }

    companion object {
        fun updateWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int,
        ) {
            // home_widget stores data in FlutterSharedPreferences with "flutter." prefix.
            val widgetData = HomeWidgetPlugin.getData(context)
            val views = RemoteViews(context.packageName, R.layout.vitalglyph_widget)

            val name = widgetData.getString("flutter.profile_name", null)
            val bloodType = widgetData.getString("flutter.blood_type", null)
            val qrImagePath = widgetData.getString("flutter.qr_widget", null)

            views.setTextViewText(R.id.widget_name, name ?: "Medical ID")

            val bloodText = if (!bloodType.isNullOrEmpty()) "Blood: $bloodType" else ""
            views.setTextViewText(R.id.widget_blood_type, bloodText)

            if (!qrImagePath.isNullOrEmpty()) {
                val bitmap = BitmapFactory.decodeFile(qrImagePath)
                if (bitmap != null) {
                    views.setImageViewBitmap(R.id.widget_qr, bitmap)
                }
            }

            // Tapping the widget opens the app.
            val launchIntent = Intent(context, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            }
            val pendingIntent = PendingIntent.getActivity(
                context,
                0,
                launchIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
            )
            views.setOnClickPendingIntent(R.id.widget_root, pendingIntent)

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
