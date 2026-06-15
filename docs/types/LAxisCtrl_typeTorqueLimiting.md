# typeTorqueLimiting

## Description

Defines a data structure that is used to parameterize the MC_TorqueLimiting instruction.

## Structure

| Field | Type | Description |
| ----- | ---- | ----------- |
| limit | LREAL | Value of force/torque limiting (in the configured unit of measurement) (Value >= 0.0: The specified value is used; Value < 0.0: Use of the default value configured in the technology object) |
| mode | [TorqueLimitingMode](../enums/LAxisCtrl_TorqueLimitingMode.md) | 0: Force/Torque limiting; 1: Fixed stop detection |

## Usage

This type is used in the axis config structure (contains all the configuration structures and parameters for the MC instructions) [typeAxisConfig](./LAxisCtrl_typeAxisConfig.md).
