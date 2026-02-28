import WidgetKit
import SwiftUI

// MARK: - Data Model

struct WidgetEntry: TimelineEntry {
    let date: Date
    let profileName: String
    let bloodType: String
    let qrImage: Image?
}

// MARK: - Timeline Provider

struct VitalglyphWidgetProvider: TimelineProvider {

    /// The app group ID must match the value set in Flutter via
    /// `HomeWidget.setAppGroupId('group.com.example.vitalglyph')`.
    private let appGroupId = "group.com.example.vitalglyph"

    func placeholder(in context: Context) -> WidgetEntry {
        WidgetEntry(
            date: Date(),
            profileName: "Jane Doe",
            bloodType: "O+",
            qrImage: nil
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (WidgetEntry) -> Void) {
        completion(buildEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<WidgetEntry>) -> Void) {
        let entry = buildEntry()
        // Refresh policy: never auto-refresh — the Flutter app calls
        // HomeWidget.updateWidget() explicitly when profile data changes.
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }

    // MARK: Private

    private func buildEntry() -> WidgetEntry {
        let defaults = UserDefaults(suiteName: appGroupId)

        let name = defaults?.string(forKey: "profile_name") ?? "Medical ID"
        let bloodType = defaults?.string(forKey: "blood_type") ?? ""

        var qrImage: Image? = nil
        if let imagePath = defaults?.string(forKey: "qr_widget"),
           let uiImage = UIImage(contentsOfFile: imagePath) {
            qrImage = Image(uiImage: uiImage)
        }

        return WidgetEntry(
            date: Date(),
            profileName: name,
            bloodType: bloodType,
            qrImage: qrImage
        )
    }
}

// MARK: - Widget View

struct VitalglyphWidgetEntryView: View {
    var entry: WidgetEntry

    var body: some View {
        ZStack {
            Color.white

            VStack(spacing: 4) {
                // Profile name header
                Text(entry.profileName)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.black)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .frame(maxWidth: .infinity)

                // QR code — the entire point of the widget
                Group {
                    if let qrImage = entry.qrImage {
                        qrImage
                            .resizable()
                            .interpolation(.none)
                            .aspectRatio(1, contentMode: .fit)
                    } else {
                        // Placeholder when no profile is set up
                        VStack(spacing: 4) {
                            Image(systemName: "qrcode")
                                .font(.system(size: 36))
                                .foregroundColor(.secondary)
                            Text("Open VitalGlyph\nto set up")
                                .font(.system(size: 9))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                .frame(maxWidth: .infinity)
                .layoutPriority(1)

                // Blood type footer
                if !entry.bloodType.isEmpty {
                    Text("Blood: \(entry.bloodType)")
                        .font(.system(size: 10))
                        .foregroundColor(Color(red: 0.22, green: 0.25, blue: 0.30))
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(8)
        }
    }
}

// MARK: - Widget Configuration

struct VitalglyphWidget: Widget {
    let kind: String = "VitalglyphWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: VitalglyphWidgetProvider()) { entry in
            VitalglyphWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Medical ID")
        .description("Shows your Medical ID QR code for first responders.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

// MARK: - Preview

struct VitalglyphWidget_Previews: PreviewProvider {
    static var previews: some View {
        VitalglyphWidgetEntryView(
            entry: WidgetEntry(
                date: Date(),
                profileName: "Jane Doe",
                bloodType: "O+",
                qrImage: nil
            )
        )
        .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
