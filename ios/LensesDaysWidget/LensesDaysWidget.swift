import SwiftUI
import WidgetKit

private let widgetGroupId = "group.com.example.lenses"

private enum WidgetMode: String {
  case empty
  case single
  case dual
}

private enum WidgetAccent: String {
  case both
  case left
  case right
}

/// AppColors.pureColors.blue.b800
private let colorBlue = Color(red: 0.455, green: 0.765, blue: 0.969) // #74C3F7
/// AppColors.pureColors.green.g900 — лайм правой линзы
private let colorLime = Color(red: 0.612, green: 0.816, blue: 0.353) // #9CD05A
/// AppColors.pureColors.error.error
private let colorError = Color(red: 0.820, green: 0.000, blue: 0.275) // #D10046
private let colorCaption = Color(red: 0.075, green: 0.078, blue: 0.075).opacity(0.64)

private func daysDisplayColor(_ days: Int, accent: Color) -> Color {
  days <= 0 ? colorError : accent
}

private func captionDisplayColor(_ days: Int) -> Color {
  days <= 0 ? colorError : colorCaption
}

/// Дни до замены: dateEnd − today (0 = день замены; как в Flutter LensesController).
private func daysLeftUntil(_ isoDate: String, now: Date = Date()) -> Int {
  guard !isoDate.isEmpty else { return 0 }
  let formatter = DateFormatter()
  formatter.calendar = Calendar(identifier: .gregorian)
  formatter.locale = Locale(identifier: "en_US_POSIX")
  formatter.timeZone = TimeZone.current
  formatter.dateFormat = "yyyy-MM-dd"
  guard let end = formatter.date(from: isoDate) else { return 0 }
  let calendar = Calendar.current
  let startOfToday = calendar.startOfDay(for: now)
  let startOfEnd = calendar.startOfDay(for: end)
  return calendar.dateComponents([.day], from: startOfToday, to: startOfEnd).day ?? 0
}

private func formatDays(_ days: Int) -> String {
  days < 0 ? "+\(-days)" : "\(days)"
}

private struct WidgetStrings {
  let brandTitle: String
  let titleDays: String
  let titleReplacementDay: String
  let titleOverdue: String
  let labelLeft: String
  let labelRight: String
  let emptyHint: String

  static func load(from defaults: UserDefaults?) -> WidgetStrings {
    WidgetStrings(
      brandTitle: defaults?.string(forKey: "brandTitle") ?? "lenses",
      titleDays: defaults?.string(forKey: "titleDays") ?? "Дней до замены",
      titleReplacementDay: defaults?.string(forKey: "titleReplacementDay") ?? "День замены",
      titleOverdue: defaults?.string(forKey: "titleOverdue") ?? "День замены просрочен",
      labelLeft: defaults?.string(forKey: "labelLeft") ?? "L",
      labelRight: defaults?.string(forKey: "labelRight") ?? "R",
      emptyHint: defaults?.string(forKey: "emptyHint") ?? "Надеть"
    )
  }

  func caption(for days: Int) -> String {
    if days > 0 { return titleDays }
    if days == 0 { return titleReplacementDay }
    return titleOverdue
  }
}

private struct LensesDaysEntry: TimelineEntry {
  let date: Date
  let mode: WidgetMode
  let accent: WidgetAccent
  let leftDays: Int
  let rightDays: Int
  let primaryDays: Int
  let strings: WidgetStrings
}

private struct Provider: TimelineProvider {
  func placeholder(in context: Context) -> LensesDaysEntry {
    LensesDaysEntry(
      date: Date(),
      mode: .single,
      accent: .both,
      leftDays: 12,
      rightDays: 12,
      primaryDays: 12,
      strings: .load(from: nil)
    )
  }

  func getSnapshot(in context: Context, completion: @escaping (LensesDaysEntry) -> Void) {
    completion(makeEntry(date: Date()))
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<LensesDaysEntry>) -> Void) {
    let now = Date()
    let entry = makeEntry(date: now)
    let calendar = Calendar.current
    let tomorrow = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: now)!)
    completion(Timeline(entries: [entry], policy: .after(tomorrow)))
  }

  private func makeEntry(date: Date) -> LensesDaysEntry {
    let defaults = UserDefaults(suiteName: widgetGroupId)
    let mode = WidgetMode(rawValue: defaults?.string(forKey: "mode") ?? "empty") ?? .empty
    let accent = WidgetAccent(rawValue: defaults?.string(forKey: "accent") ?? "both") ?? .both
    let leftEnd = defaults?.string(forKey: "leftEnd") ?? ""
    let rightEnd = defaults?.string(forKey: "rightEnd") ?? ""
    let leftDays = daysLeftUntil(leftEnd, now: date)
    let rightDays = daysLeftUntil(rightEnd, now: date)
    let strings = WidgetStrings.load(from: defaults)
    return LensesDaysEntry(
      date: date,
      mode: mode,
      accent: accent,
      leftDays: leftDays,
      rightDays: rightDays,
      primaryDays: leftEnd.isEmpty ? rightDays : leftDays,
      strings: strings
    )
  }
}

private struct LensesDaysWidgetEntryView: View {
  var entry: LensesDaysEntry

  private var numberColor: Color {
    let accent: Color
    switch entry.accent {
    case .left:
      accent = colorBlue
    case .right, .both:
      accent = colorLime
    }
    return daysDisplayColor(entry.primaryDays, accent: accent)
  }

  var body: some View {
    ZStack(alignment: .topLeading) {
      Group {
        switch entry.mode {
        case .empty:
          Text(entry.strings.emptyHint)
            .font(.headline)
            .foregroundColor(Color(red: 0.075, green: 0.078, blue: 0.075))
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        case .single:
          singleView(days: entry.primaryDays)
        case .dual:
          HStack(spacing: 8) {
            sideColumn(
              label: entry.strings.labelLeft,
              days: entry.leftDays,
              color: colorBlue
            )
            sideColumn(
              label: entry.strings.labelRight,
              days: entry.rightDays,
              color: colorLime
            )
          }
          .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
      }
      brandHeader
    }
    .padding(10)
    .modifier(WidgetBackgroundModifier())
  }

  private var brandHeader: some View {
    HStack(spacing: 6) {
      Image("WidgetLogo")
        .resizable()
        .scaledToFit()
        .frame(width: 18, height: 18)
        .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
      Text(entry.strings.brandTitle)
        .font(.caption.weight(.semibold))
        .foregroundColor(Color(red: 0.075, green: 0.078, blue: 0.075))
    }
  }

  private var sideLabel: String? {
    switch entry.accent {
    case .left: return entry.strings.labelLeft
    case .right: return entry.strings.labelRight
    case .both: return nil
    }
  }

  @ViewBuilder
  private func singleView(days: Int) -> some View {
    let color = numberColor
    VStack(spacing: 4) {
      if let sideLabel {
        Text(sideLabel)
          .font(.caption.weight(.bold))
          .foregroundColor(color)
      }
      Text(formatDays(days))
        .font(.system(size: 44, weight: .bold, design: .rounded))
        .foregroundColor(color)
        .minimumScaleFactor(0.5)
        .lineLimit(1)
      Text(entry.strings.caption(for: days))
        .font(.caption2)
        .foregroundColor(captionDisplayColor(days))
        .multilineTextAlignment(.center)
        .minimumScaleFactor(0.8)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }

  @ViewBuilder
  private func sideColumn(label: String, days: Int, color: Color) -> some View {
    let display = daysDisplayColor(days, accent: color)
    VStack(spacing: 2) {
      Text(label)
        .font(.caption.weight(.bold))
        .foregroundColor(display)
      Text(formatDays(days))
        .font(.system(size: 32, weight: .bold, design: .rounded))
        .foregroundColor(display)
        .minimumScaleFactor(0.5)
        .lineLimit(1)
      Text(entry.strings.caption(for: days))
        .font(.system(size: 9))
        .foregroundColor(captionDisplayColor(days))
        .multilineTextAlignment(.center)
        .minimumScaleFactor(0.7)
        .lineLimit(2)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

@main
struct LensesDaysWidget: Widget {
  let kind: String = "LensesDaysWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: Provider()) { entry in
      LensesDaysWidgetEntryView(entry: entry)
    }
    .configurationDisplayName("Дней до замены")
    .description("Показывает, сколько дней осталось до замены контактных линз")
    .supportedFamilies([.systemSmall, .systemMedium])
  }
}

private struct WidgetBackgroundModifier: ViewModifier {
  private let background = Color(red: 0.961, green: 0.949, blue: 0.953) // #F5F2F3

  @ViewBuilder
  func body(content: Content) -> some View {
    if #available(iOSApplicationExtension 17.0, *) {
      content.containerBackground(for: .widget) { background }
    } else {
      content.background(background)
    }
  }
}
