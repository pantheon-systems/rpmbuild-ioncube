# RPM for ioncube

[![Deprecated](https://img.shields.io/badge/Pantheon-Deprecated-yellow?logo=pantheon&color=FFDC28)](https://pantheon.io/docs/oss-support-levels#deprecated)

This repository builds an RPM for the Ioncube loaders.

## RPM name

The RPM filename built by this repository is:
```
ioncube-10.0.3-201607271418.noarch.rpm
{name }-{vers}-{iteration }.{arch}.rpm
```
The iteration number is the Circle build number for officiel builds, and a timestamp (YYYYMMDDhhmm) for locally-produced builds.

## Install Location

This rpm installs:

/opt/pantheon/ioncube/VERSION/ioncube_loader_lin_%{php_major}.%{php_minor}.so

The following PHP major / PHP minor versions are included:

- 7.1
- 7.0
- 5.6

## Releasing to Package Cloud

CircleCI has automatic deployment of RPMs to Package Cloud configured.

When tests pass for a PR:  publish to pantheon/internal-staging/fedora/#.

When tests pass on master: publish to pantheon/internal/fedora/#.

In the example, # is the fedora build number (19, 20, 22). Note that ioncube is only installed on app servers, and there are no app servers on anything prior to f22; therefore, at the moment, we are only building for f22.

Note that Ioncube does not provide download links for old versions of the loader; only the most recent version is available. They provide a REST API that we use to determine what the current available version is.  Building a new RPM with this script will therefore always package the latest version of Ioncube.

## Provisioning Ioncube on Pantheon

Pantheon will only install Ioncube RPMs specifically mentioned in the cookbooks. This is controlled by [pantheon-cookbooks/endpoint](https://github.com/pantheon-cookbooks/endpoint), and must be updated to roll out new versions of Ioncube.
