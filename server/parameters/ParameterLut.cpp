// ParameterLut.cpp
#include "ParameterLut.h"

QVector<Parameter*> ParameterLut::defaults(QObject* parent) {
    return {
        new Parameter("volume", ParameterType::Int, 50, 0, 100, "%", parent),
        new Parameter("brightness", ParameterType::Int, 75, 0, 100, "%", parent),
        new Parameter("username", ParameterType::String, "guest", {}, {}, "", parent)
    };
}
