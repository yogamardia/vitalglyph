import Flutter
import UIKit

class SceneDelegate: FlutterSceneDelegate {
    private static let channelName = "com.yogamardia.vitalglyph/file_open"
    private var pendingFileURL: URL?
    private var channel: FlutterMethodChannel?

    override func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        super.scene(scene, willConnectTo: session, options: connectionOptions)

        // Check if the app was launched by opening a .medid file.
        if let url = connectionOptions.urlContexts.first?.url,
           url.pathExtension.caseInsensitiveCompare("medid") == .orderedSame {
            pendingFileURL = copyToTemp(url)
        }

        // Set up MethodChannel once FlutterViewController is available.
        if let controller = flutterViewController(for: scene) {
            channel = FlutterMethodChannel(
                name: SceneDelegate.channelName,
                binaryMessenger: controller.engine!.binaryMessenger
            )
            channel?.setMethodCallHandler { [weak self] call, result in
                if call.method == "getInitialFile" {
                    let path = self?.pendingFileURL?.path
                    self?.pendingFileURL = nil
                    result(path)
                } else {
                    result(FlutterMethodNotImplemented)
                }
            }
        }
    }

    override func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        super.scene(scene, openURLContexts: URLContexts)

        guard let url = URLContexts.first?.url,
              url.pathExtension.caseInsensitiveCompare("medid") == .orderedSame else { return }

        if let tempURL = copyToTemp(url) {
            channel?.invokeMethod("onFileOpen", arguments: tempURL.path)
        }
    }

    // MARK: - Helpers

    private func flutterViewController(for scene: UIScene) -> FlutterViewController? {
        guard let windowScene = scene as? UIWindowScene else { return nil }
        return windowScene.windows.first?.rootViewController as? FlutterViewController
    }

    private func copyToTemp(_ url: URL) -> URL? {
        let tempDir = FileManager.default.temporaryDirectory
        let destURL = tempDir.appendingPathComponent(url.lastPathComponent)
        try? FileManager.default.removeItem(at: destURL)
        do {
            let accessed = url.startAccessingSecurityScopedResource()
            defer { if accessed { url.stopAccessingSecurityScopedResource() } }
            try FileManager.default.copyItem(at: url, to: destURL)
            return destURL
        } catch {
            return nil
        }
    }
}
