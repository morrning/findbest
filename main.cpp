#include <QGuiApplication>
#include <QQuickStyle> // Class to enabling styling
#include <QFontDatabase>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <backend.h>


int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    QQuickStyle::setStyle("Material"); // Enable Material Design
    QFontDatabase::addApplicationFont(":/icons/iconFonts.ttf");
    QQmlApplicationEngine engine;

    //-----------LOAD BACKENDS----------------

    qmlRegisterType<Backend>("io.qt.Backend", 1, 0, "Backend");

    //-----------SET PROPERTIES----------------
    //SHOW OFFLINE STORAGE PATH LOCATION FOR OFFLINE DATA
    auto offlineStoragePath = QUrl::fromLocalFile(engine.offlineStoragePath());
    engine.rootContext()->setContextProperty("offlineStoragePath", offlineStoragePath);

    //---------- add admob service-------------

    //-----------------------------------------
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    if (engine.rootObjects().isEmpty())
        return -1;
    app.setLayoutDirection(Qt::RightToLeft);
    return app.exec();
}
