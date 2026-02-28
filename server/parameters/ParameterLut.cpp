// ParameterLut.cpp
#include "ParameterLut.h"

QVector<Parameter*> ParameterLut::defaults(QObject* parent) {
    return {
        new Parameter("volume", "int", 50, 0, 100, "%", parent),
        new Parameter("brightness", "int", 75, 0, 100, "%", parent),
        new Parameter("username", "string", "guest", {}, {}, "", parent)
    };
}
