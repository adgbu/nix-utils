# .NET 6/7 on Linux and macOS

These are some instructions to install and manage installations of 
.NET (dotnet) on macOS, Linux, Raspberry Pi, etc.


## Uninstall .NET on macOS

I had old versions of runtime and SDK for .NET on macOS.
I wanted to begin by cleaning up legacy stuff before installing .NET 6.
There is a tool called dotnet-core-uninstall.

### .NET Uninstall Tool
https://docs.microsoft.com/en-us/dotnet/core/additional-tools/uninstall-tool?tabs=macos

### Uninstall Tool: dotnet-core-uninstall
https://github.com/dotnet/cli-lab


## Install (dotnet) .NET 6/7 on Raspberry Pi

Repo with automated helper script.
https://github.com/pjgpetecodes/dotnet6pi
https://github.com/pjgpetecodes/dotnet7pi

Also check out his blog.
https://www.petecodes.co.uk

First review the script, before you run it with sudo.

    $ curl https://raw.githubusercontent.com/pjgpetecodes/dotnet7pi/master/install.sh | less

The oneliner dotnet install!

    $ curl https://raw.githubusercontent.com/pjgpetecodes/dotnet7pi/master/install.sh | sudo bash


## Install (dotnet) .NET 6 on Ubuntu x86/amd64

Official instructions
https://docs.microsoft.com/en-us/dotnet/core/install/linux

Example Ubuntu 18.04 (Note! Different sources for different versions.)
First add the Microsoft package repository and key to your list of repositories and trusted keys.

    $ wget https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
    $ sudo dpkg -i packages-microsoft-prod.deb
    $ rm packages-microsoft-prod.deb

Then we install the .NET SDK.

    $ install -y apt-transport-https
    $ install -y dotnet-sdk-6.0


## dotnet command cheat sheet

Help to remember how to use commands that you don't type very often.

List of possible types of projects to create.

    $ dotnet new --list

Create a new project (CLI).

    $ dotnet new console -n "HelloConsole"

Add an NuGet package to the project as a dependency. 

    $ dotnet add package Azure.Data.Tables

Get the dependencies for an existing project. (You can also just build/run).

    $ dotnet restore

Create a Solution for multi project (preferably in parent directory).

    $ dotnet new sln -n "SolutionName"

Add a project to your Solution.

    $ dotnet sln SolutionName.sln add "HelloConsole/HelloConsole.csproj"


Build a project to a self-contained application, i.e. if dotnet is not installed globally on the target machine.
<RID> is the Runtime Identifier (e.g. linux-arm). Docs: https://docs.microsoft.com/en-us/dotnet/core/deploying/

    $ dotnet publish --configuration Release --runtime <RID> --self-contained true
    $ dotnet publish --configuration Release --runtime <RID> --self-contained true


## More tips and tricks

Blazor webapps by default listen only on localhost interface.
To listen for __any incoming connection__ there are multiple ways to configure this.

    $ dotnet run --urls="http://*:5000"

