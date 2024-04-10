# Easy Menu System

An easy to impliment menu system that supports a variety of different options:

    Usage: bash core-menu.sh (-h | --help) (-l | --legacy type) (-c | --config config_location)
      {-l|--legacy} type    -- launch for legacy menu control (possible values: yad, gtkdialog, kdialog, zenity, Xdialog, dialog, none. default: auto select)
      {-h|--help}                     -- print this help message and exit
      {-c|--config} config_location   -- set custom config location (default: ./options/options.json)

This menu system uses [easybashgui](https://sites.google.com/site/easybashgui/) for it's functionality, so it will automatically detect and use: yad, gtkdialog, kdialog, zenity, Xdialog, (c)dialog, whiptail or bash builtins to display the options. That means this system should work on any server or SSH session, terminal session, or GUI session. 

The first version of this menu system was included in [Android-Generic Project](https://github.com/android-generic/vendor_ag), but has been heavily modified for generic functionality.  

## Examples:

Some of the examples will be for various uses:

 - System Startup Menu: [Autostart Script Example](https://github.com/electrikjesus/easy-menu-system/tree/master/configs/startup-script#autostart-script-example)
