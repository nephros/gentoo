## KNOWN ISSUES with this ebuild:

 * If the Panel or the desktop do not appear, or if dtwm freezes it might have to do with locale settings. 
   Note that CDE expects UTF8-based locales to be specified as "xx\_YY.UTF-8", while some Gentoo tools export "xx\_YY.utf8".
   You might want to export LANG=en\_US.UTF-8. 
   If in doubt, export LANG=C and try again.

 * The *dtlogin* display manager is untested by the (ebuild) author. If you use a
   display manager, it should pick up the CDE session either via
   /etc/X11/sessions/CDE or the CDE.desktop file.
   For starting without a display manager, use the startcde script.
   For testing in a running X session, use the startcde\_windowed script.

## Tips & Tricks

### The CDE Wiki and other resources
			
Do look through [The CDE Wiki](https://sourceforge.net/p/cdesktopenv/wiki/Home/), 
[Forum](https://sourceforge.net/p/cdesktopenv/discussion/general/), 
and [Mailing List](https://sourceforge.net/p/cdesktopenv/mailman/cdesktopenv-devel/) for some Tips and Tricks.

Note that references to running RPC in insecure mode, or adding stuff to winetd is outdated and does not apply to 
CDE Versions 2.3.0 and higher.

### Prettier(?) Fonts

In order to get prettier fonts via Xft, add the following to your ~/.Xresources file:  

	    *.renderTable: variable'
	    *.renderTable.variable.fontName: Sans'
	    *.renderTable.variable.fontSize: 8'
	    *.renderTable.variable.fontType: FONT_IS_XFT'


