#!/bin/sh
#
#
set -ex
bin="$(cd -P -- "$(dirname -- "$0")" && pwd -P)"

IONCUBE_VERSION=$(curl http://www.ioncube.com/feeds/product_info/versions.php?item=loader-versions 2>/dev/null | sed -e 's/.*linux_x86_64[^"]*"[^"]*"//' -e 's/".*//')

# set a default build -> 0 for when it doesn't exist
CIRCLE_BUILD_NUM=${CIRCLE_BUILD_NUM:-0}

# epoch to use for -revision
epoch=$(date +%s)

shortname="ioncube"
name="$shortname-$IONCUBE_VERSION"

version=1
iteration="$(date +%Y%m%d%H%M)"
arch='noarch'
os='linux'
url="https://github.com/pantheon-systems/${shortname}"
vendor='Ioncube'
description='Ioncube: Loader for using Ioncube-encoded PHP files.'
install_prefix="/opt/pantheon/$shortname/$IONCUBE_VERSION"

download_dir="$bin/../tmp"
build_dir="$bin/../build"
target_dir="$bin/../pkgs"

rm -rf $download_dir
mkdir -p $download_dir
curl -o $download_dir/ioncube.tgz https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz
(
  cd "$download_dir"
  tar xzvf "ioncube.tgz"
)

rm -rf $build_dir
mkdir -p $build_dir

# The subset of loaders from the .tgz that we wish to package in our RPM
ioncube_loaders="ioncube_loader_lin_7.1.so ioncube_loader_lin_7.0.so ioncube_loader_lin_5.6.so"

(
  cd "$download_dir/ioncube"
  cp $ioncube_loaders "$build_dir"
)

mkdir -p "$target_dir"

fpm -s dir -t rpm  \
    --package "$target_dir/${name}-${version}-${iteration}.${arch}.rpm" \
    --name "${name}" \
    --version "${version}" \
    --iteration "${iteration}" \
    --epoch "${epoch}" \
    --rpm-os "${os}" \
    --architecture "${arch}" \
    --url "${url}" \
    --vendor "${vendor}" \
    --description "${description}" \
    --prefix "$install_prefix" \
    -C build \
    $ioncube_loaders
