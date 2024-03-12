#!/bin/bash

pushSample() {
	mysql -u {username} -p"{yourPassword}" -D {yourDBName} < $1
}

osSample() {
	_pidStat="/tmp/$1.stat"
	_pidLck="/tmp/$1.lck"

	if [ ! -f $_pidLck ]
	then
		touch $_pidLck
		_date="$(date +"%F %T.%3N")~$1"
		_sample="$(ps -p $1 -o %cpu,%mem,cmd | tail -1)"
		_sample=$(echo $_sample|sed "s/~ /~/g")
		_sample=$(echo $_sample|awk -F " " '$2=$2"~"')
		_sample=$(echo $_sample|awk -F " " '$3=$3"~"')
		_sample=$(echo $_sample|awk -F " " '$1=$1"~"')
		_sample=$(echo $_sample|sed "s/~ /~/g")

		_typeMain=$(echo $_sample | grep "com.boomi.container.core.Container" | wc -l)
		_typeWorker=$(echo $_sample | grep "com.boomi.execution.forker.ProcessExecutionWorker" | wc -l)
		_typeRunner=$(echo $_sample | grep "com.boomi.execution.forker.ProcessExecutionRunner" | wc -l)
		if [ "$_typeMain" -gt 0 ]
		then
			_sample=$(echo $_sample"~Main")
		elif [ "$_typeWorker" -gt 0 ]
		then
			_sample=$(echo $_sample"~AW")
		elif [ "$_typeRunner" -gt 0 ]
		then
			_sample=$(echo $_sample"~FE")
		fi

		echo "$_date~$_sample" >> $_pidStat

		sed -i "s/^/insert into osMetricJVM (captureDt,pid,cpuUsage,memUsage,binName,binParms,binType) values ('/g" $_pidStat
		sed -i "s/~/','/g" $_pidStat
		sed -i "s/$/');/g" $_pidStat

		pushSample $_pidStat
	else
		_date="$(date +"%F %T.%3N")~$1"
		_sample="$(ps -p $1 -o %cpu,%mem,cmd | tail -1)"
		_sample=$(echo $_sample|sed "s/~ /~/g")
		_sample=$(echo $_sample|awk -F " " '$2=$2"~"')
		_sample=$(echo $_sample|awk -F " " '$3=$3"~"')
		_sample=$(echo $_sample|awk -F " " '$1=$1"~"')
		_sample=$(echo $_sample|sed "s/~ /~/g")

		_typeMain=$(echo $_sample | grep "com.boomi.container.core.Container" | wc -l)
		_typeWorker=$(echo $_sample | grep "com.boomi.execution.forker.ProcessExecutionWorker" | wc -l)
		_typeRunner=$(echo $_sample | grep "com.boomi.execution.forker.ProcessExecutionRunner" | wc -l)
		if [ "$_typeMain" -gt 0 ]
		then
			_sample=$(echo $_sample"~Main")
		elif [ "$_typeWorker" -gt 0 ]
		then
			_sample=$(echo $_sample"~AW")
		elif [ "$_typeRunner" -gt 0 ]
		then
			_sample=$(echo $_sample"~FE")
		fi

		echo "$_date~$_sample" >> $_pidStat

		sed -i "s/^/insert into osMetricJVM (captureDt,pid,cpuUsage,memUsage,binName,binParms,binType) values ('/g" $_pidStat
		sed -i "s/~/','/g" $_pidStat
		sed -i "s/$/');/g" $_pidStat

		pushSample $_pidStat

		/bin/rm -f $_pidLck
	fi

	/bin/rm -f $_pidLck
}

/bin/rm -f /tmp/JVMPids.lst

_pidsFile="/tmp/JVMPids.lst"
while true
do
	jps -l | grep com.boomi.launcher.Launcher$ | awk '{ print $1 }' > $_pidsFile

	if [ ! -s "$_pidsFile" ]
	then
		echo No JVMs running?
	fi

	while read _in
	do
		_idx=$((_idx + 1))
		/bin/rm -f /tmp/$_in.stat
		/bin/rm -f /tmp/$_in.lck

		echo Sampling $_in...
		osSample $_in&

		sleep 3
	done < /tmp/JVMPids.lst
	sleep 3
done
