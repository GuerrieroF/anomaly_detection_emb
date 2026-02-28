// ParameterLut.h
#pragma once
#include <QVector>
#include "Parameter.h"

class ParameterLut {
public:
    static QVector<Parameter*> defaults(QObject* parent = nullptr);
};
