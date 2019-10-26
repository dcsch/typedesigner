#  FontScript

_Experimental_

An Objective-C framework implementing the [FontParts API](http://fontparts.readthedocs.io/), allowing
code written in Objective-C, Swift, and Python to construct and manipulate fonts. 

## Language/OS Support
- Python, Swift, and Objective-C on macOS
- Swift and Objective-C on iOS. 

_Note_: The macOS version requires a Python 3 installation, along with Python.framework, as configured by the installer
at [python.org](https://www.python.org/downloads/mac-osx/). The installed framework, as of version 3.7.4, appears to be missing the `Versions/Current` link that allows Xcode to correctly include the header files and libraries. This can be remedied by creating the link manually. In the `/Library/Frameworks/Python.framework/Versions` directory, execute `sudo ln -s 3.7 Current` and all should be well.
