---
title:  "Averaging with Sweep Count"
date:   2017-06-20 12:17
tags:   Averaging
lead_text: >
  When averaging, make sure you perform enough sweeps to fill the averaging buffer
---

An important thing to recognize when setting up and automating averaging on the VNA is that there are two related but independent VNA settings that you will typically need to set:

- Sweep Count
- Averaging Factor

The averaging factor is straightforward enough: if you set an averaging factor of 10, for example, the VNA will take the average of the last 10 sweeps and give you that result.

Where you may run into trouble is making sure that enough sweeps have been performed to correctly perform the averaging. Even if you've set an averaging factor of 10, if in reality you've only performed 1 sweep the VNA will give you the "average" of the sweeps you have performed *so far*. For one sweep this average is itself, and thus not very helpful.

If your result does not seem to be an average at all, you most likely need to perform more sweeps. This is where `sweep count` comes into play

Sweep Count
-----------

It is possible to set the VNA to perform a certain number of sweeps when triggered. By default, it only performs one. If you are averaging, however, it is helpful to increase this value to match the averaging factor to ensure that the VNA is always calculating the full average.

### Manually

On a ZVA this value can be found from:

`Sweep (hard key) -> More 1/2 (soft key) -> Define Restart... (soft key) -> Number of Sweeps for [All Channels / Active Channel]`

On a ZNB this value is found from:

`Sweep (hard key) -> Sweep Control (tab)`

To set the sweep count, select the `Single` sweep radio button and enter the number of sweeps in the `Sweeps` field.

### Programmatically

By SCPI command, this can be set with:

`SENSe<Ch>:SWEep:COUNt <value>`

Here is an example SCPI command script that performs an averaged sweep in a single channel (Ch1) and queries the complex trace data (Trc1).

~~~python
# Sweep channel 1 only
'INIT:SCOP SING'

# Set 10 sweeps per "INIT",
# Average all 10 sweeps
'SENS1:SWE:COUNT 10'
'SENS1:AVER:COUN 10'
'SENS1:AVER ON'

# Manual sweep mode
'INIT1:CONT OFF'

# Start sweep
'INIT1'

# Wait for sweeps to finish
# Note: Set appropriate VISA timeout
'*OPC?'

# Query averaged, complex,
# unformatted Trc1 data
"CALC1:PAR:SEL 'Trc1'"
'CALC1:DATA? SDAT'
~~~
