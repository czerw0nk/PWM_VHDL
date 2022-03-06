# Programmable PWM

## Files: 
* PWM.vhd - main module
* tb_PWM.vhd - testbench

## Registers:
* c_REG_PERIOD_ADR := x"40" 
* c_REG_DUTY_ADR   := x"41" 
* c_REG_RUN_ADR    := x"42"
* c_REG_STATUS_ADR := x"43"

## Run modes:
* RUN MODE 1 - ON 
* RUN MODE 2 - OFF
* Other bits for future implementaton

## Simulation

![Simulation](/SimulationPWM.PNG "Simulation")