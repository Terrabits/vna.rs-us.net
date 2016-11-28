---
title:  "The VISA Stack"
date:   2016-11-16 17:00
tags:   SCPI, Programming
lead_text: >
  A short introduction to the Virtual Instrument Software Architecture (VISA)
---

This question comes up a lot from people that are new to instrument programming:  
What is VISA? What does it do? Why do I need it? Where do I get it?

VISA Software Stack
-------------------

A typical instrument control application using VISA looks like this:

<figure class="center">
	<img class="tall-img" alt="VISA stack" src="/blog/2016/11/16/the-visa-stack/visa-stack.svg" />
	<figcaption>
		VISA instrument control stack
	</figcaption>
</figure>

These layers are:

### Application  
Appropriately enough, this is the application that is being made, written in the programming language of choice.

### Programming Language, Library
A programming language provides a high-level and often-times cross-platform way to accomplish certain tasks, like create a window or write to a file. Most programming languages come with a built-in library (usually referred to as the standard library [stdlib]) to help with these tasks.

So far we have an application in mind, a programming language, a PC with an operating system, and an instrument that's connected to the PC and configured correctly.

Virtual Instrument Software Architecture (VISA) is a software library that helps your application connect to and communicate with the instrument.

Connecting to the Instrument
----------------------------

Some older languages that are still used today, like C\C++, do not provide libraries for things like ethernet control. To connect to another computer via GPIB or ethernet, the choices are to either:

1. Understand how to use the libraries provided by the operating system
2. Find a third party library for a specific programming language and operating system that handles this

Every operating system is different. It is not trivial learning how to perform communication via the Windows socket libraries (winsock), for example. Furthermore, if you have to support more than one operating system, you'd have to learn how to do this for each. You'd also have to maintain a version of your application for each platform.

VISA does this for you. VISA has a defined interface that supports any platform (Windows, Mac or Linux) and with any instrument connection (GPIB, ethernet, wifi and USB). The VISA interface is very simple. Most instrument control applications only need three functions: connect, write command and read data.

Rohde & Schwarz VISA
--------------------

The VISA standard is just that: a standard. It is up to instrument manufacturers to implement it. Below is a link to the Rohde & Schwarz implementation of VISA.

[Rohde & Schwarz VISA](https://www.rohde-schwarz.com/us/applications/r-s-visa-application-note_56280-148812.html)

If you are using a Rohde & Schwarz instrument it is highly recommended, especially for on-instrument installation because of potential conflicts with the firmware. An application note is included to help you get set up with many common programming languages.

Alternatives to VISA
--------------------

The problem that VISA solves no longer exists in many modern programming languages. For example, if you are using Python and an ethernet connection you can take advantage of Python's standard library, which includes a TCP socket class. the Python standard library is cross-platform and simple to use. No additional software (VISA) is necessary.

The communications stack is simpler:

<figure class="center">
	<img class="tall-img" alt="No VISA stack" src="/blog/2016/11/16/the-visa-stack/no-visa-stack.svg" />
	<figcaption>Non-VISA instrument control stack
	</figcaption>
</figure>

Conclusion
----------

Whether or not you use VISA will depend largely on your needs.

If you are using a VISA driver from an instrument manufacturer, that driver will most likely require VISA. You don't have a choice.

Also, if you need GPIB control you are pretty much stuck with VISA. No programming languages that I know of support GPIB control in their standard library. No other third party libraries I know of support direct GPIB control. Working around VISA on your own would take some effort. If you want an easy and cross-platform way to control your instrument via GPIB, VISA is the way to go.

If you are using ethernet and a programming language (such as standard C++) that does not provide a TCP communications library, you may consider VISA. Short of building a library for yourself, you will need a third party library. VISA is easy to use and widely supported in the test and measurement industry.

If you are using ethernet or wifi and have a tcp library you can use, it's up to you. Many engineers stick with VISA anyway for the flexibility it provides (changing your application later to GPIB or USB is trivial). Some engineers consider the added complexity of installing and managing VISA not worth the effort.

<hr />
<small>
	GPIB image by MDragunov<br>
	Own work, Public Domain<br>
	<a href="https://commons.wikimedia.org/w/index.php?curid=11117515">https://commons.wikimedia.org/w/index.php?curid=11117515</a>
</small>
