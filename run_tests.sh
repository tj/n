cd tests
for f in $(ls *.sh); do
    echo Running test... $f
    bash $f
    rc=$?
    if [[ $rc -ne 0 ]]; then
        echo TEST FAILED!
        exit $rc
    fi
done
cd ..
