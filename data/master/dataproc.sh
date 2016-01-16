cat ../classes | while read line ;do cat ../data-11-full.json | jq -c "select(.digest ==$line).pattern" >> `echo $line | sed 's/\//_/g'`;
echo `echo $line | sed 's/\//_/g'` >> classes; done

cat classes | while read line; do mv $line "${(l:3::0:)n}-`wc -l $line | awk '{print $1}'`"; ((n = n+1)); done
