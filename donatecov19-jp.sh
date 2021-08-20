#!/bin/bash
echo "COVID-19 Donater&Analyzer Installer Started."

# Ask E-Mail Address for sign up
read -p "E-Mail Address> " email

# Create Random ID/Password
id=$(pwgen 60 1)
pw=$(pwgen 10 1)

# Show ID/PW
echo "ID: $id"
echo "PW: $pw"

echo "Installing Folding@home..."

# Ask PC enviroment for installing Folding@home
echo "Which is your PC enviroment?"
echo "1 amd64 Debian/Ubuntu/Mint"
echo "2 amd64 Redhat/CentOS Stream/Fedora"
echo "3 arm64 Debian/Ubuntu/Mint"

# Get OS
read -p  "> " env
case "$env" in
  1) os=debian;;
  2) os=redhat;;
  3) os=debian;;
esac
case "$env" in
  1) arch=amd64;;
  2) arch=amd64;;
  3) arch=arm64;;
esac

# Select package to download
if [ "$os" = debian ]
  then
  if [ "$arch" = amd64 ]
    then
    link="https://download.foldingathome.org/releases/public/release/fahclient/debian-stable-64bit/v7.6/fahclient_7.6.21_amd64.deb"
    out="fah.deb"
  fi
  if [ "$arch" = arm64 ]
    then
    link="https://download.foldingathome.org/releases/public/release/fahclient/debian-stable-arm64/v7.6/fahclient_7.6.21_arm64.deb"
    out="fah.deb"
  fi
fi
if [ "$os" = redhat ]
    then
    link="https://download.foldingathome.org/releases/public/release/fahclient/centos-6.7-64bit/v7.6/fahclient-7.6.21-1.x86_64.rpm"
    out="fah.rpm"
fi

# Start Download
echo "Downloading Installer..."
echo "Link: $link"

# Select wget/aria2c
if wget -h > /dev/null 2>&1
  then
  wget=ok
fi
if aria2c -h > /dev/null 2>&1
  then
  aria2c=ok
fi
if [ $aria2c = ok ]
  then
  echo "using aria2c..."
  dl=aria2c
  else
  if [ $wget = ok ]
    then
    echo "using wget..."
    dl=wget
    else
    echo "ERR: Wget or Aria2c not found."
    exit 1
  fi
fi

# Start Download
if [ $dl = aria2c ]
  then
  $dl -x2 -o $out "$link"
fi
if [ $dl = wget ]
  then
  $dl -O $out "$link"
fi

# End Downloading
echo "Download Done."

# Install
echo "Installing..."

# Installtion proccess for Debian/Ubuntu/Mint
if [ $os = debian ]
  then
  echo "Press Enter if you are asked about name/team id/passkey."
  echo "Press Enter to continue..."
  read
  sudo apt install ./fah.deb
fi

# Installtion proccess for Redhat/CentOS Stream/Fedora
if [ $os = redhat ]
  then
  if yum help > /dev/null 2>&1
    then
    sudo yum install fah.rpm
    else
    if dnf help > /dev/null 2>&1
      then
      sudo dnf install fah.rpm
      else
      if rpm --help > /dev/null 2>&1
        then
        sudo rpm -i fah.rpm
        else
        echo "yum or dnf or rpm not found."
        exit 1
      fi
    fi
  fi
fi

# End Installing
echo "Done."

# Activate Account
wget http://okaits7534.ddns.net:6896/donatecov19/jp/signup.cgi?${id}+${pw}+${email} -O activatelog.log
cat activatelog.log

# Show Information to users
echo "Account acctivated."
echo "I will send e-mail from okaits7534@gmail.com."
echo "After that, please set Folding@home UserName/TeamID(Optional: Passkey)."
echo "If you found bugs, please create pull-requests or mail to okaits7534+DonateCov19-jp@gmail.com."
echo "Note: Developer(okaits#7534) will take 5% commision."

# Remove Folding@home Package
echo "Removing items that are no longer needed."
if [ $os = debian ]
  then
  rm fah.deb
fi
if [ $os = redhat ]
  then
  rm fah.rpm
fi

# End Program
echo "Installtion/SignUp Procces Done."
echo "Good bye!"
exit
