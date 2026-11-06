# typeAxisConfig

## Description

Defines a configuration structure that contains the parameterization for the implemented MC instruction inside of [AxisControl](../blocks/AxisControl.md).

## Structure

| Field | Type | Description |
| ----- | ---- | ----------- |
| generalSettings | [typeGeneralSettings](./typeGeneralSettings.md) | Configuration of general settings |
| power | [typePower](./typePower.md) | Configuration of MC_POWER function |
| jog | [typeJog](./typeJog.md) | Configuration of JOG function |
| moveVelocity | [typeMoveVelocity](./typeMoveVelocity.md) | Configuration of MC_MOVEVELOCITY function |
| stop | [typeStop](./typeStop.md) | Configuration of MC_HALT function |
| fastStop | [typeFastStop](./typeFastStop.md) | Configuration of MC_HALT function (alternative dynamics) |
| torqueLimiting | [typeTorqueLimiting](./typeTorqueLimiting.md) | Configuration of MC_TORQUELIMITING function |
| homing | [typeHoming](./typeHoming.md) | Configuration of HOMING function |
| posRelative | [typePosRelative](./typePosRelative.md) | Configuration of MC_MOVERELATIVE function |
| posAbsolute | [typePosAbsolute](./typePosAbsolute.md) | Configuration of MC_MOVEABSOLUTE function |
| posSuperimposed | [typePosSuperimposed](./typePosSuperimposed.md) | Configuration of MC_MOVESUPERIMPOSED function |
| haltSuperimposed | [typeHaltSuperimposed](./typeHaltSuperimposed.md) | Configuration of MC_HALTSUPERIMPOSED function |
| gearInRelative | [typeGearInRelative](./typeGearInRelative.md) | Configuration of MC_GEARIN function |
| gearInAbsolute | [typeGearInAbsolute](./typeGearInAbsolute.md) | Configuration of MC_GEARIN_POS function |
| gearInVelocity | [typeGearInVelocity](./typeGearInVelocity.md) | Configuration of MC_GEARINVELOCITY function |
| camIn | [typeCamIn](./typeCamIn.md) | Configuration of MC_CAMIN function |
| gearOutCamOut | [typeGearOutCamOut](./typeGearOutCamOut.md) | Configuration of MC_GEAROUT / MC_CAMOUT function |
| phasing | [typePhasing](./typePhasing.md) | Configuration of MC_PHASING function |
| offset | [typeOffset](./typeOffset.md) | Configuration of MC_OFFSET function |

## Usage

This type is used in as an input of the function block [AxisControl](../blocks/AxisControl.md#input-parameters).
