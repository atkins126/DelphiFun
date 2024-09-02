# DelphiFun

A collection of some functions I wrote for other applications or out of boredom.

# Detect when a new drive letter gets attached to the Windows file system

Windows broadcasts new devices to all applications that have a main window handle using the WM_DEVICECHANGE message.
Unfortunately the necessary constants or structures are not included in Delphi 11 Community Edition.

This introduces the missing DBTTypes.pas unit and a sample app that notifies the user when a new drive appears or disappears.

# Read desktop shortcut and extract it's configured icon

Drop a desktop shortcut on this demo window and it will read the shortcut file, determine and retrieve the
appropriate icon.
