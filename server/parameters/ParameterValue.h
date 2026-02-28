#ifndef PARAMETERVALUE_H
#define PARAMETERVALUE_H
// ParameterValue.h
#pragma once
#include <variant>
#include <string>
#include <cstdint>

using ParameterValue = std::variant<
    uint8_t,
    int,
    double,
    bool,
    std::string
    >;

#endif // PARAMETERVALUE_H
