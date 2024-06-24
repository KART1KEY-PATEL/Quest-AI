import UIKit
import Flutter
import AVFoundation

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: "com.example.questias/tts", binaryMessenger: controller.binaryMessenger)

        channel.setMethodCallHandler { [weak self] (call, result) in
            guard call.method == "speak" else {
                result(FlutterMethodNotImplemented)
                return
            }

            if let args = call.arguments as? [String: Any],
               let text = args["text"] as? String {
                self?.speak(text: text)
                result("Success")
            } else {
                result(FlutterError(code: "Error", message: "Text is null", details: nil))
            }
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func speak(text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")

        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
}
