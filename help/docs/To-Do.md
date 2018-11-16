ENVIRONMENT VARIABLE SCRIPT -

Subroutine for the software inventory process has been created. Next step is to design a filter or another function to filter out all but the required software needed for the script to function as intended. Possibly this subroutine should be another function that can be called to cleanup the output of the Get-Software function once the data has been output to a variable.

The variable created needs to contain data in the format -
      1) Pick highest version of the JRE/JDK installed on the local machine, if multiple are installed. If only one version is installed, pick that one;
      2) "<drive_letter>:\(Path to JRE/JDK on disk)";

Once that data is stored in the variable, that variable needs then to be piped to a command - SETX - which sets the local machine environment variables and set the $jhome version as the ENV variable JRE_HOME or, if JDK is installed, JDK_HOME (or both as the need arises).

If Java is not found on the machine (it should be installed on approximately 95% of machines already), ask the user if they wish to download the installer manually (if selected open browser window to the JRE download page on Oracle) or automatically download and install the installer package. Once that is done, perform the same steps as above to set the environment variables.


TOMCAT CONFIGURATION SCRIPT -

Design a filter that takes the output from the function 'Get-Software' and checks for the the presence of the Apache Tomcat Platform on the local machine. If the software is not present on the local machine (indicating a new install of IL and/or Rapport), download the software package from Apache and unpack it to a location specified by the user. Once unpacked perform the same steps as if the software was already installed.

Once Tomcat is downloaded, it needs to be unpacked and copied to a location specified by the user. Once that is specified, then configuration can be completed as outlined in the IL10 Installation Guide for the App Server.


GET_SOFTWARE FUNCTION LIBRARY -

The function has been designed and works. Next step to take the output of the function and apply filters to it so that all unnecessary software is ignored and only the software required for the installation of IL10 is installed and configured properly. This can either be done in the same library or a new library can be created and called as necessary. For now, a separate library will be created for ease of testing, which once validated it works, the library will be merged into an existing library.


- [x] DOWNLOAD_REQUIREMENTS LIBRARY -

This function will have two separate parts that are able to be called independently of each other. The first function - Get-Tomcat detects the architecture of the OS and then downloads the appropriate version of Tomcat. Before downloading, it prompts the user for the location where the installer will be saved to. Once the input is detected, it validates whether or not the directory structure exists; if it doesn't exist, it creates it. The second half of this function will extract and configure the program. The second part of the library will download and configure the Java platform. It will detect the architecture of the OS and then download the appropriate version of Java. Before downloading, it will ask the user for the location where the installer will be saved to. Once the input is received by the program, it detects whether or not the directory structure exists; if it doesn't, it creates it.
