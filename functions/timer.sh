timer(){
# Timer function.
# Reports REAL time elapsed in hours/minutes/seconds as appropriate
# Code to be timed should be wrapped as follows:
#  1.  START=$SECONDS
#  2.  <execute timed code>
#  3.  FINISH=$SECONDS
#  4.  echo "Elapsed: $(timer)
# Uses the SECONDS environment variable
hrs="$((($FINISH - $START)/3600)) hrs"
min="$(((($FINISH - $START)/60)%60)) min"
sec="$((($FINISH - $START)%60)) sec"

if [[ $(($FINISH - $START)) -gt 3600 ]]; then echo -e >&1 "\033[1m$hrs, $min, $sec\033[0m"
elif [[ $(($FINISH - $START)) -gt 60 ]]; then echo -e >&1 "\033[1m$min, $sec\033[0m"
else echo -e >&1 "\033[1m$sec\033[0m"
fi
}


# e.g.


START=$SECONDS
sleep 3
FINISH=$SECONDS
echo "Elapsed: $(timer)"
