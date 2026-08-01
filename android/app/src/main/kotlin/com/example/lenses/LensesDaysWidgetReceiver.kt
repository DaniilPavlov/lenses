package com.example.lenses

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.graphics.Color
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider
import java.time.LocalDate
import java.time.temporal.ChronoUnit

/**
 * Home-screen виджет: дни до замены линз (single / dual / empty).
 * Дни: dateEnd − today (0 = день замены; как в Flutter LensesController).
 *
 * Цвета как в приложении: L = blue.b800, R = green.g900 (лайм), both = green.g900;
 * день замены / просрочка = error.error.
 */
class LensesDaysWidgetReceiver : HomeWidgetProvider() {

  override fun onUpdate(
    context: Context,
    appWidgetManager: AppWidgetManager,
    appWidgetIds: IntArray,
    widgetData: SharedPreferences,
  ) {
    appWidgetIds.forEach { widgetId ->
      val mode = widgetData.getString(KEY_MODE, MODE_EMPTY) ?: MODE_EMPTY
      val views = when (mode) {
        MODE_DUAL -> buildDual(context, widgetData)
        MODE_SINGLE -> buildSingle(context, widgetData)
        else -> buildEmpty(context, widgetData)
      }
      val pendingIntent = HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java)
      views.setOnClickPendingIntent(R.id.widget_root, pendingIntent)
      appWidgetManager.updateAppWidget(widgetId, views)
    }
  }

  private fun buildEmpty(context: Context, data: SharedPreferences): RemoteViews {
    return RemoteViews(context.packageName, R.layout.widget_lenses_empty).apply {
      applyBrand(this, data)
      setTextViewText(R.id.widget_empty_hint, data.getString(KEY_EMPTY_HINT, "Надеть") ?: "Надеть")
    }
  }

  private fun buildSingle(context: Context, data: SharedPreferences): RemoteViews {
    val leftEnd = data.getString(KEY_LEFT_END, "").orEmpty()
    val rightEnd = data.getString(KEY_RIGHT_END, "").orEmpty()
    val end = leftEnd.ifEmpty { rightEnd }
    val days = daysLeftUntil(end)
    val accent = data.getString(KEY_ACCENT, ACCENT_BOTH) ?: ACCENT_BOTH
    val accentColor = when (accent) {
      ACCENT_LEFT -> COLOR_BLUE
      ACCENT_RIGHT -> COLOR_LIME
      else -> COLOR_LIME
    }
    val numberColor = daysColor(days, accentColor)
    val sideLabel = when (accent) {
      ACCENT_LEFT -> data.getString(KEY_LABEL_LEFT, "L") ?: "L"
      ACCENT_RIGHT -> data.getString(KEY_LABEL_RIGHT, "R") ?: "R"
      else -> ""
    }
    return RemoteViews(context.packageName, R.layout.widget_lenses_single).apply {
      applyBrand(this, data)
      if (sideLabel.isEmpty()) {
        setViewVisibility(R.id.widget_side_label, android.view.View.GONE)
      } else {
        setViewVisibility(R.id.widget_side_label, android.view.View.VISIBLE)
        setTextViewText(R.id.widget_side_label, sideLabel)
        setTextColor(R.id.widget_side_label, numberColor)
      }
      setTextViewText(R.id.widget_days, formatDays(days))
      setTextColor(R.id.widget_days, numberColor)
      setTextViewText(R.id.widget_caption, captionFor(days, data))
      setTextColor(R.id.widget_caption, captionColor(days))
    }
  }

  private fun buildDual(context: Context, data: SharedPreferences): RemoteViews {
    val leftDays = daysLeftUntil(data.getString(KEY_LEFT_END, "").orEmpty())
    val rightDays = daysLeftUntil(data.getString(KEY_RIGHT_END, "").orEmpty())
    val leftColor = daysColor(leftDays, COLOR_BLUE)
    val rightColor = daysColor(rightDays, COLOR_LIME)
    return RemoteViews(context.packageName, R.layout.widget_lenses_dual).apply {
      applyBrand(this, data)
      setTextViewText(R.id.widget_label_left, data.getString(KEY_LABEL_LEFT, "L") ?: "L")
      setTextViewText(R.id.widget_label_right, data.getString(KEY_LABEL_RIGHT, "R") ?: "R")
      setTextViewText(R.id.widget_days_left, formatDays(leftDays))
      setTextViewText(R.id.widget_days_right, formatDays(rightDays))
      setTextColor(R.id.widget_label_left, leftColor)
      setTextColor(R.id.widget_days_left, leftColor)
      setTextColor(R.id.widget_label_right, rightColor)
      setTextColor(R.id.widget_days_right, rightColor)
      setTextViewText(R.id.widget_caption_left, captionFor(leftDays, data))
      setTextViewText(R.id.widget_caption_right, captionFor(rightDays, data))
      setTextColor(R.id.widget_caption_left, captionColor(leftDays))
      setTextColor(R.id.widget_caption_right, captionColor(rightDays))
    }
  }

  private fun applyBrand(views: RemoteViews, data: SharedPreferences) {
    views.setTextViewText(R.id.widget_brand_title, data.getString(KEY_BRAND_TITLE, "lenses") ?: "lenses")
  }

  private fun captionFor(days: Int, data: SharedPreferences): String {
    return when {
      days > 0 -> data.getString(KEY_TITLE_DAYS, null) ?: "Дней до замены"
      days == 0 -> data.getString(KEY_TITLE_REPLACEMENT_DAY, null) ?: "День замены"
      else -> data.getString(KEY_TITLE_OVERDUE, null) ?: "День замены просрочен"
    }
  }

  private fun formatDays(days: Int): String {
    return if (days < 0) "+${-days}" else days.toString()
  }

  private fun daysColor(days: Int, accent: Int): Int {
    return if (days <= 0) COLOR_ERROR else accent
  }

  private fun captionColor(days: Int): Int {
    return if (days <= 0) COLOR_ERROR else COLOR_CAPTION
  }

  companion object {
    private const val KEY_MODE = "mode"
    private const val KEY_ACCENT = "accent"
    private const val KEY_LEFT_END = "leftEnd"
    private const val KEY_RIGHT_END = "rightEnd"
    private const val KEY_BRAND_TITLE = "brandTitle"
    private const val KEY_TITLE_DAYS = "titleDays"
    private const val KEY_TITLE_REPLACEMENT_DAY = "titleReplacementDay"
    private const val KEY_TITLE_OVERDUE = "titleOverdue"
    private const val KEY_LABEL_LEFT = "labelLeft"
    private const val KEY_LABEL_RIGHT = "labelRight"
    private const val KEY_EMPTY_HINT = "emptyHint"

    private const val MODE_EMPTY = "empty"
    private const val MODE_SINGLE = "single"
    private const val MODE_DUAL = "dual"

    private const val ACCENT_BOTH = "both"
    private const val ACCENT_LEFT = "left"
    private const val ACCENT_RIGHT = "right"

    /** AppColors.pureColors.blue.b800 */
    private val COLOR_BLUE = Color.parseColor("#74C3F7")
    /** AppColors.pureColors.green.g900 — лайм правой линзы / обеих */
    private val COLOR_LIME = Color.parseColor("#9CD05A")
    /** AppColors.pureColors.error.error */
    private val COLOR_ERROR = Color.parseColor("#D10046")
    /** Подпись в обычном состоянии (чёрный ~64%). */
    private val COLOR_CAPTION = Color.parseColor("#A3131413")

    /** end − today (0 = replacement day). */
    fun daysLeftUntil(isoDate: String, today: LocalDate = LocalDate.now()): Int {
      if (isoDate.isBlank()) return 0
      val end = LocalDate.parse(isoDate)
      return ChronoUnit.DAYS.between(today, end).toInt()
    }
  }
}
