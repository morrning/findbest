#include "backend.h"
#include <QtNetwork>

#include "QDebug"
Backend::Backend(QObject *parent) : QObject(parent)
{

}

QString Backend::doSome()
{
    return "0";
}

