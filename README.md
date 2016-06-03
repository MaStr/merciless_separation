# merciless_separation
Scripts and configuration for art project "Merciless separation"

# Usage 

## 'live'
This branch contains the live configuration and setup files. It is pulled by the live servers and refreshed regulary

## 'lab'
This is used by the lab server for testing.

## Master 
Working tree for the project.

# Tags
For changes on the live server, a tag needs to placed to a particular commit. The tag needs to be formed:

	live-CCYY-MM-dd

Everyday the following procedure happens:

	* git fetch
	* Compare current date vs. available tags. If the tag for the current day is available, the following steps happen:

	* Monit stop vote: openvpn
	* Monit stop vote: squid3 
	* Monit stop vote: perl-proxy

	* git checkout <tag live-CCYY-MM-dd>

	* monit start vote: perl-proxy
	* OK?
	* monit start vote squid3 
	* OK?
	* monit start vote openvpn
	* OK?

	* => Send email information.


