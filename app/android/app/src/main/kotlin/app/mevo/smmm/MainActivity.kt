package app.mevo.smmm

import com.eyedeadevelopment.fluttertts.FlutterTtsPlugin
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    // Eklentiler elle kaydedilir (GeneratedPluginRegistrant yerine). Sesli okuma eklentisi açılışta kaydedilmez:
    // Android'de konuşma motoruna bağlanırken ana iş parçacığını saniyelerce meşgul ediyor ve ilk ekranı
    // geciktiriyordu (emülatör ölçümü, 11.11.2026). Dart tarafı ilk kullanımda "mevo/ses" kanalıyla ister.
    // YENİ EKLENTİ EKLENİRSE buraya da eklenmeli (bkz. build/.../GeneratedPluginRegistrant.java).
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        flutterEngine.plugins.add(io.flutter.plugins.inapppurchase.InAppPurchasePlugin())
        flutterEngine.plugins.add(io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin())
        flutterEngine.plugins.add(io.flutter.plugins.urllauncher.UrlLauncherPlugin())
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "mevo/ses").setMethodCallHandler { cagri, sonuc ->
            if (cagri.method == "baslat") {
                if (!flutterEngine.plugins.has(FlutterTtsPlugin::class.java)) {
                    flutterEngine.plugins.add(FlutterTtsPlugin())
                }
                sonuc.success(true)
            } else {
                sonuc.notImplemented()
            }
        }
    }
}
