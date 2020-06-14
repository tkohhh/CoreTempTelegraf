#CoreTemp Windows Telegraf Plugin

This program outputs data collected by CoreTemp (https://www.alcpu.com/CoreTemp/) in a format that can be consumed by Telegraf (https://www.influxdata.com/time-series-platform/telegraf/). The program is written in Delphi, and utilizes a library developed by Michal Kokorceny from http://74.cz/.


##Prerequisites
In order for the program to run as expected, the following is required:
  
*CoreTemp installed and running
  
In order for Telegraf to consume the data output by the program, the following is also required:

*Telegraf installed and running (I used this guide: https://www.influxdata.com/blog/using-telegraf-on-windows/)

*Enable global shared memory on CoreTemp (Options > Settings, Advanced tab)


##Usage
  
You can check the output of the program in a command prompt or PowerShell.  CD to the directory where the program resides, and then enter the command: CoreTempTelegraf

To collect the data in telegraf, add an entry to your Telegraf config like this:
  
[[inputs.exec]]
  commands = ["C:\path\to\program\CoreTempTelegraf"]
  data_format = "influx"

You can place the program in a Windows System Path location, allowing you to run the program from any directory.  This simplifies the "commands" line to:

  commands = ["CoreTempTelegraf"]
  
