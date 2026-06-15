# typeAxisConfig

## Description

Defines a configuration structure that contains the parameterization for the implemented MC instruction inside of [AxisControl](../blocks/LAxisCtrl_AxisControl.md).

## Structure

| Field | Type | Description |
| ----- | ---- | ----------- |
| generalSettings | [typeGeneralSettings](./LAxisCtrl_typeGeneralSettings.md) | Configuration of general settings |
| power | [typePower](./LAxisCtrl_typePower.md) | Configuration of MC_POWER function |
| jog | [typeJog](./LAxisCtrl_typeJog.md) | Configuration of JOG function |
| moveVelocity | [typeMoveVelocity](./LAxisCtrl_typeMoveVelocity.md) | Configuration of MC_MOVEVELOCITY function |
| stop | [typeStop](./LAxisCtrl_typeStop.md) | Configuration of MC_HALT function |
| fastStop | [typeFastStop](./LAxisCtrl_typeFastStop.md) | Configuration of MC_HALT function (alternative dynamics) |
| torqueLimiting | [typeTorqueLimiting](./LAxisCtrl_typeTorqueLimiting.md) | Configuration of MC_TORQUELIMITING function |
| homing | [typeHoming](./LAxisCtrl_typeHoming.md) | Configuration of HOMING function |
| posRelative | [typePosRelative](./LAxisCtrl_typePosRelative.md) | Configuration of MC_MOVERELATIVE function |
| posAbsolute | [typePosAbsolute](./LAxisCtrl_typePosAbsolute.md) | Configuration of MC_MOVEABSOLUTE function |
| posSuperimposed | [typePosSuperimposed](./LAxisCtrl_typePosSuperimposed.md) | Configuration of MC_MOVESUPERIMPOSED function |
| haltSuperimposed | [typeHaltSuperimposed](./LAxisCtrl_typeHaltSuperimposed.md) | Configuration of MC_HALTSUPERIMPOSED function |
| gearInRelative | [typeGearInRelative](./LAxisCtrl_typeGearInRelative.md) | Configuration of MC_GEARIN function |
| gearInAbsolute | [typeGearInAbsolute](./LAxisCtrl_typeGearInAbsolute.md) | Configuration of MC_GEARIN_POS function |
| gearInVelocity | [typeGearInVelocity](./LAxisCtrl_typeGearInVelocity.md) | Configuration of MC_GEARINVELOCITY function |
| camIn | [typeCamIn](./LAxisCtrl_typeCamIn.md) | Configuration of MC_CAMIN function |
| gearOutCamOut | [typeGearOutCamOut](./LAxisCtrl_typeGearOutCamOut.md) | Configuration of MC_GEAROUT / MC_CAMOUT function |
| phasing | [typePhasing](./LAxisCtrl_typePhasing.md) | Configuration of MC_PHASING function |
| offset | [typeOffset](./LAxisCtrl_typeOffset.md) | Configuration of MC_OFFSET function |

## Usage

This type is used in as an input of the function block [AxisControl](../blocks/LAxisCtrl_AxisControl.md#input-parameters).
