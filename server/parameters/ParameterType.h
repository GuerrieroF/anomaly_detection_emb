#pragma once

#include <QString>
#include <QVariant>

enum class ParameterType {
    UInt8,
    Int,
    Double,
    Bool,
    String
};

inline QString parameterTypeToString(ParameterType type) {
    switch (type) {
    case ParameterType::UInt8: return "UInt8";
    case ParameterType::Int: return "Int";
    case ParameterType::Bool: return "Bool";
    case ParameterType::String: return "String";
    case ParameterType::Double: return "Double";
    default: return "unknown";
    }
}

inline ParameterType parameterTypeFromString(const QString& str) {
    if (str == "UInt8") return ParameterType::UInt8;
    if (str == "Int") return ParameterType::Int;
    if (str == "Bool") return ParameterType::Bool;
    if (str == "String") return ParameterType::String;
    if (str == "Double") return ParameterType::Double;
    return ParameterType::String; // fallback
}

inline bool parameterTypeMatches(ParameterType type, const QVariant& value)
{
    switch (type) {
    case ParameterType::UInt8:
        return value.canConvert<quint32>();
    case ParameterType::Int:
        return value.canConvert<int>();
    case ParameterType::Double:
        return value.canConvert<double>();
    case ParameterType::Bool:
        return value.canConvert<bool>();
    case ParameterType::String:
        return value.canConvert<QString>();
    }
    return false;
}
