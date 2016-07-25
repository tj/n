export N_PREFIX=/tmp/n
export PATH=/tmp/n/bin:$PATH
mkdir -p $N_PREFIX

N=../bin/n
NPM=/tmp/n/bin/npm

$N latest

echo Install 0.10.36
$N 0.10.36

echo Install different version of npm
$NPM install -g npm@2.2

echo Use latest
$N latest

echo Use 0.10.36
$N 0.10.36

test $($NPM --version) = "2.2.0"
rc=$?

rm -rf $N_PREFIX
exit $rc
