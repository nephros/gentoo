## KNOWN ISSUES with this ebuild:

 * most things in /etc/appconfig/types/foo/.dt do not work correctly for some reason. This includes the Front Panel, most Actions, icons etc.  
   As a workaround, copy whatever you need into ~/.dt/types.

 * The SubPanel commands in the Front Panel do not work and cause the Panel to not appear.  
   As a workaround, copy /etc/dt/appconfig/types/C/dtwm.fp ~/.dt/types, and remove all SubPanels and things which use them as containers.

 * The above might have to do with locale settings. Note that CDE expects UTF8-based locales to be specified as "xx\_YY.UTF-8", while some Gentoo tools export "xx\_YY.utf8".
   You might want to export LANG=en\_US.UTF-8, or as a failsafe, LANG=C in e.g. ~/.dtprofile.


## Tips & Tricks

### The CDE Wiki and other resources
			
Do look through [The CDE Wiki](https://sourceforge.net/p/cdesktopenv/wiki/Home/), [Forum](https://sourceforge.net/p/cdesktopenv/discussion/general/), and [Mailing List](https://sourceforge.net/p/cdesktopenv/mailman/cdesktopenv-devel/) for some Tips and Tricks.

### Prettier(?) Fonts

In order to get prettier fonts via Xft, add the following to your ~/.Xresources file:  

	    *.renderTable: variable'
	    *.renderTable.variable.fontName: Sans'
	    *.renderTable.variable.fontSize: 8'
	    *.renderTable.variable.fontType: FONT_IS_XFT'


