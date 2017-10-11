#!/bin/bash
# confirm-rpm.sh

expectedName=ioncube-10.0.3
expectedContents="ioncube_loader_lin_7.1.so ioncube_loader_lin_7.0.so ioncube_loader_lin_5.6.so"
pkgDir="pkgs"
if [ ! -d "$pkgDir" ]
then
  echo 'Package directory not found.'
  exit 1
fi

rpmName=$(ls "$pkgDir")

if [ -z "$rpmName" ]
then
  echo 'No build found.'
  exit 1
fi

echo
echo "RPM info:"
echo "-------------------------------"
echo "RPM is $rpmName"
rpm -qpi "$pkgDir/$rpmName"
rpm -qp "$pkgDir/$rpmName" --qf "OS - Architecture: %{os} - %{arch}\n"
echo
echo "RPM contents:"
echo "-------------------------------"
rpm -qpl "$pkgDir/$rpmName"
echo

name=$(rpm -qp --queryformat '%{NAME}\n' "$pkgDir/$rpmName")
if [ "$(echo "$name" | sed -e 's/-[a-z]*$//')" != "$expectedName" ]
then
  echo "Name is not $expectedName"
  exit 1
fi

architecture=$(rpm -qp "$pkgDir/$rpmName" --qf "%{arch}")
if [ "$architecture" != "noarch" ]
then
  echo "Architecture $architecture is not 'noarch'"
  exit 1
fi

os=$(rpm -qp "$pkgDir/$rpmName" --qf "%{os}")
if [ "$os" != "linux" ]
then
  echo "Architecture $os is not 'linux'"
  exit 1
fi


epoch=$(rpm -qp --queryformat '%{EPOCH}\n' "$pkgDir/$rpmName")
if [ -z "$(echo "$epoch" | grep '^[0-9]\{10\}$')" ]
then
  echo "Epoch $epoch does not look like an epoch"
  exit 1
fi

release=$(rpm -qp --queryformat '%{RELEASE}\n' "$pkgDir/$rpmName")
if [ -z "$(echo "$release" | grep '^\([0-9]\{12\}\)$')" ]
then
  echo "Release $release does not match our expected format"
  exit 1
fi


version=$(rpm -qp --queryformat '%{VERSION}\n' "$pkgDir/$rpmName")
if [ -z "$(echo "$version" | grep '^[0-9]\+')" ]
then
  echo "Version $version is not numeric"
  exit 1
fi

contents=$(rpm -qpl "$pkgDir/$rpmName")
for expected in $expectedContents ; do
  if [ "${contents/$expected/}" == "$contents" ]
  then
    echo "RPM contents do not contain expected value '$expected'"
    exit 1
  fi
done

echo 'Basic rpm validation checks all passed.'
exit 0
