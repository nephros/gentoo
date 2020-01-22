#!/usr/bin/env bash

d2dt=/usr/dt/bin/tools/desktop2dt/desktop2dt

lst="$1"
if [[ "x$lst" = "x" ]]; then
	lst="/usr/share/applications/*.desktop"
fi
tmp=$(mktemp -d) || exit 10
pushd ${tmp} > /dev/null || exit 11
out=${tmp}/out
mkdir -p ${out}

if [[ ! -e ${d2dt} ]]; then
	echo "conversion tool not found at ${d2dt}."
	echo "Please make sure is gets installed from <<CDE SOURCE>>/contrib"
	exit 127
fi

echo "Will create confuguration for the following (enter to list)"
read dummy
echo $lst
echo "Continue (Ctrl-C to abort)?"
read dummy

mkdir -p ${out}/.dt/appmanager/Desktop_Apps
for s in $lst; do
	echo "Converting ${s##*/}..."
	sh ${d2dt} "${s}" || echo "Conversion failed for ${s}"
	e=$(basename  ${s##*/} .desktop)
	touch ${out}/.dt/appmanager/Desktop_Apps/${e}
	chmod +x ${out}/.dt/appmanager/Desktop_Apps/${e}
done

mkdir -p ${out}/.dt/types/
mkdir -p ${out}/.dt/icons/
mv *.dt ${out}/.dt/types/
mv *.pm ${out}/.dt/icons/

popd

echo "stuff has been placed in ${out}/.dt for you to review."
echo "if ok, move the stuff to your ~/.dt and refresh the CDE desktop"
