---
layout:         post
navigation_tab: blog
title:         "Parallel Measurements with the ZNBT"
date:          "2015-11-04 15:35"
categories:    "ZNBT Multiport"
---

# Summary
Because a ZNBT can have up to 24 true VNA ports, it can do something that a VNA and a switch matrix cannot: measure multiple devices in parallel. The ZNBT interface makes this easy to do for identical DUTs. But what if you want to measure DUTs with a varying number of ports, or you want to set up these measurements in your own software?

# Example Scenario

For this example we will assume the following:

* A ZNBT with at least 8 ports
* A channel, `channel 1`, configured for measurement
* A device `DUT1` with 3 ports
* A device `DUT2` with 4 ports
* Logical port indexes are the same as the physical port

## Common Gotchas
Before I begin, I'd like to clarify a few things:

**Parallel measurements must share the same measurement settings**  
Internally the ZNBT has a limited number of sources being used by all the physical ports (and DUTs). As such, it is not possible to measure devices in parallel with arbitrarily independent measurement settings. In this example, both DUTs are measured in `channel 1`, and as such share `channel 1`'s measurement settings.

**Port assignments supersede channel settings**  
Another thing to keep in mind is that the port assignments for parallel measurement supersede any port assignments in the channel. So, if you have already created logical port assignments (for example, with balanced ports) they may get overwritten by these SCPI commands.

## SCPI Command Menu

All of the SCPI commands for parallel measurements can be found in the `SOURce:GROup` command menu. Here is a screenshot of the documentation from the ZNBT help menu.

Note the location in help: *Command Reference > SCPI Command Reference > SOURce Commands > SOURce:GROup*

![SCPI Command Menu](/images/posts/2015-11-04-Parallel-measurements-with-the-znbt/scpi_command_menu.png)

## SCPI Commands

In the terminology of the SCPI Command Menu, each DUT will have it's own Port `Group`. The most straightforward command for defining each group is:

![Set Port Group](/images/posts/2015-11-04-Parallel-measurements-with-the-znbt/set_port_group.png)

Now we will create these port groups. I will assign `DUT1` to ports 1-3, and `DUT2` to ports 4-7.

{% highlight ruby %}
"SOURce1:GROup1:PPORTs 1,2,3"
"SOURce1:GROup2:PORTs 4,5,6,7"
{% endhighlight %}

Optionally, you can also give these groups names

{% highlight ruby %}
"SOURce1:GROup1:NAME 'DUT1'"
"SOURce1:GROup2:NAME 'DUT2'"
{% endhighlight %}

You can now use the normal SCPI commands to perform a sweep and query/save data.
