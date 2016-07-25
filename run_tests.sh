cd tests
tests=$(ls -1 *.sh)
tests=($tests)
num_tests=${#tests[@]}
declare -a failed_tests

echo 1..$num_tests

ct=1
for f in ${tests[@]}; do
    bash $f &> /dev/null
    rc=$?
    if [[ $rc -ne 0 ]]; then
        echo not ok $ct - ${f%.*}
        failed_tests=( ${failed_tests[@]} $ct )
    else
        echo ok $ct - ${f%.*}
    fi
    let ct=ct+1
done

num_failed=${#failed_tests[@]}
if [[ $num_failed -gt 0 ]]; then
    let num_okay="$num_tests - $num_failed"
    pcnt_okay=$(bc -l <<< $num_okay/$num_tests*100)
    echo FAILED tests ${failed_tests[@]}
    printf "Failed $num_failed/$num_tests, %.2f%% okay\n" $pcnt_okay
    exit 1
fi
exit 0
cd ..
