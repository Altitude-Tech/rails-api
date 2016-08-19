# Sensor Resistance

*Based on [1](https://learn.adafruit.com/thermistor/using-a-thermistor)*

Voltage output:
```
Vo = Rs / (Rs + Rl) * Vcc
```

Where:
    `Vo`: Voltage out.
    `Vcc`: Power supply voltage.
    `Rl`: Load resistance (of the board).
    `Rs`: Sensor resistance.

ADC value:
```
Aval = Vi * Amax / Vcc
```

Where:
    `Aval`: Current ADC value.
    `Vi`: Voltage in (to the ADC).
    `Amax`: Maximum ADC value.
    `Vcc`: Power supply voltage.

Combining `Vout = Vin`:
```
Aval = (Rs / (Rs + Rl)) * Vcc * (Amax / Vcc)
```

Rearranging:
```
Aval = (Rs / (Rs + Rl)) * ((Vcc * Amax) / Vcc)

# cancel out Vcc
Aval = (Rs / (Rs + Rl)) * Amax

# dive both sides my Amax
Aval / Amax = Rs / (Rs + Rl)

# invert both sides
Amax / Aval = (Rs + Rl) / Rs

# split the right hand side
Amax / Aval = (Rs / Rs) + (Rl / Rs)
Amax / Aval = 1 + (Rload / Rs)

# subtract 1 from each side
(Amax / Aval) - 1 = (Rl / Rs)

# multiply both side by Rs
Rs * ((Amax / Aval) - 1) = Rl

# rearrange for Rs
Rs = (Rl / ((Amax / Aval) - 1))
```

For our purposes:
    `Rl`: 10 kOhms.
    `Amax`: 4095 (max value of 12 bit unsigned integer).

