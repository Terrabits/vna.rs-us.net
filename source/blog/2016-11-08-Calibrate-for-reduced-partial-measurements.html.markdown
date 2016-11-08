---
title:  "Calibrate for Reduced Partial Measurements"
date:   2016-11-08 10:00
tags:   ZNBT, Speed
lead_text: >
  For many-port devices with distinct inputs and outputs, performing a series of one path two port calibrations will reduce the number of partial measurements taken. For many-port devices this can significantly lower measurement time.
---

I'll break the explanation into these parts: 
- Enabling multiple calibrations 
- Performing multiple one path, two port calibrations 
- Verifying the time savings 
- Saving data 
- Simplifying calibration steps 


## Enable Multiple Calibrations 
The first thing you need to do is activate the "multiple calibrations" feature. This allows you to perform and use multiple calibrations that will become active on a trace-by-trace basis depending on the measurement. This concept should become clear as we set up the calibration. 

To activate this, go to: 
`Setup (hard key) -> System (tab) -> System Config... (button)`

A system configuration window should pop up. On that window, enable the following option: 
`calibration (tab) -> Multiple Cal in Calibration Wizard (checkbox)`

The end result should be: 

![Figure 1](/blog/2016/11/08/Calibrate-for-reduced-partial-measurements/figure1.gif)

Now when you calibrate you are presented with an extra dialog that lets you define multiple calibrations to perform as a group. We will use this to perform (for your use-case) 8 one-path two-port (or more accurately 16 port) calibrations corresponding to each partial sweep that you are interested in. 

## Performing Multiple One Path, Two Port Calibrations 
To begin, start your automatic calibration as normal: 
`Cal (hard key) -> Start Cal (tab) -> Start... (Cal Unit) (button)`

You should now be presented with this unfamiliar dialog: 

![Figure 2](/blog/2016/11/08/Calibrate-for-reduced-partial-measurements/figure2.gif)

This screen allows you to add multiple, independent calibrations to your calibration routine. Click the +Add... button to add the first of 8 one-path two-port calibrations. 
The settings should be as follows: 

![Figure 3](/blog/2016/11/08/Calibrate-for-reduced-partial-measurements/figure3.gif)

The important parts are: 
    Ports            - I have selected all 16 ports 
    Calibration Type - "One Path Two Ports" 
    Source           - Port 1 

The source (in this case Port 1) corresponds to the partial sweep that you are calibrating. So, the settings above will calibrate the partial sweep that covers S11...S1601. 

Repeat this step once for each source port that you are interested in (I believe ports 1-8 for your device, since there are 8 inputs and 8 outputs). The resulting calibration list should look like this:

![Figure 4](/blog/2016/11/08/Calibrate-for-reduced-partial-measurements/figure4.gif)

Click next. You should arrive at a screen that allows you to set the cal unit ports used for each calibration. With an 8 port cal unit attached, I get this:

![Figure 5](/blog/2016/11/08/Calibrate-for-reduced-partial-measurements/figure5.gif)

Unfortunately at this point there is some bad news: Doing 8 one path two port calibrations generates a lot of calibration steps - in my example this generates 24 calibration steps (8 calibrations x 3 steps each with an 8 port cal unit => 24 total steps). I have some thoughts on this that I'll come back to later. For now, I performed the calibration and would like to verify that it gives us the results that we want. 

## Verifying the Measurement Time Savings 
To verify that measuring with this calibration saves time over a full calibration, I wrote a python script that does the following measurements and records the time that the sweeps take. 

    1 Partial Sweep:  Traces S11..S1601 
    2 Partial Sweeps: Traces above, plus S12..S1602 
    3 Partial Sweeps: Traces above, plus S13..S1603 
    ... 
    8 Partial Sweeps: Traces above, plus S18... S1608 

As a sanity check, I started with a preset and uncalibrated VNA state with:  
`9 KHz - 201 points`  
In this state, the VNA will only perform the partial calibrations necessary to update the traces. Sure enough, I have a measurement time progression that confirms this: 

**Sweep time vs number of partial sweeps 
- Uncalibrated**
| Partial Sweeps | Time (ms) |
|----------------|-----------|
|              1 | 17        |
|              2 | 35        |
|              3 | 52        |
|              4 | 70        |
|              5 | 87        |
|              6 | 105       |
|              7 | 123       |
|              8 | 140       |
|              9 | 158       |
|             10 | 175       |
|             11 | 193       |
|             12 | 211       |
|             13 | 228       |
|             14 | 246       |
|             15 | 263       |
|             16 | 281       |

Also, as a sanity check, I ran the python script with a full 16-port calibration. The results are as you have experienced; the firmware will measure all S-Parameters / Partial Sweeps regardless of what data you are interested in. 

**Sweep time vs number of partial sweeps 
- Full UOSM Calibration**
| Partial Sweeps | Time (ms) |
|----------------|-----------|
|              1 | 281       |
|              2 | 281       |
|              3 | 281       |
|              4 | 281       |
|              5 | 281       |
|              6 | 281       |
|              7 | 281       |
|              8 | 281       |
|              9 | 281       |
|             10 | 281       |
|             11 | 281       |
|             12 | 281       |
|             13 | 281       |
|             14 | 281       |
|             15 | 281       |
|             16 | 281       |

And now, the same set of measurements with our 8 separate One Path, Two Port calibrations: 

**Sweep time vs number of partial sweeps 
- 8 One Port, Two Path Calibrations**
| Partial Sweeps | Time (ms) |
|----------------|-----------|
|              1 | 17        |
|              2 | 35        |
|              3 | 52        |
|              4 | 70        |
|              5 | 87        |
|              6 | 105       |
|              7 | 123       |
|              8 | 140       |
|              9 | 158       |
|             10 | 175       |
|             11 | 193       |
|             12 | 211       |
|             13 | 228       |
|             14 | 246       |
|             15 | 263       |
|             16 | 281       |

As you can see, this matches the uncalibrated behavior and what you are looking for. 

## Saving Data 
Unfortunately there is one more point of bad news: with this calibration and sweep approach, the firmware will no longer let you simply save your data to touchstone files (S16P). This is because some of the terms in the full S-Parameter matrix go unmeasured. You can still access the full, complex data by saving each trace to a CSV file. If you still need a touchstone format file, you can create one in post-processing (keeping in mind that some of the terms have invalid data).  

## Simplifying the Calibration Steps 
It seems to me that one path, two port calibration should generate a subset of the corrections generated in a full TOSM or UOSM calibration. If this is true that the corrections generated are the same but a subset of UOSM, I wonder if we can instead perfom the full UOSM calibration, but then programmatically separate the corrections into 8 one port, two path calibrations. 

For my example above (16 ports, 8 port cal unit) a full UOSM calibration (what the calibration is by default) involves only three steps. Also, these three steps generate corrections for all sources and all S-parameter terms. Maybe we can programmatically extract what we need from that? 

To be continued...