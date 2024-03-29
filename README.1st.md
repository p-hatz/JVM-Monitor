# JVM Monitor

Looks for Boomi JVMs and:
1. Retrieves CPU and Memory stats.
2. Pushes to a DB (see [https://github.com/p-hatz/JVM-Monitor/blob/main/osMetricJVM-DDL.sql](url))

It uses the Java Process Status binary (`jps`) that you can find in your JDK and needs to be run on a Node/Pod that is running the Boomi runtime. 

You can then use a viz. tool to hopefully extract some useful info :) See samples below.

### Grafana
![Screenshot from 2024-03-12 13-58-58](https://github.com/p-hatz/JVM-Monitor/assets/141098596/b9bfa342-6d46-4219-ab8f-16b4c880d35e)


### Metabase
![Screenshot from 2024-03-12 16-52-53](https://github.com/p-hatz/JVM-Monitor/assets/141098596/4a594e6b-c740-4400-8369-5a5c1c45217a)

![Screenshot from 2024-03-12 14-21-36](https://github.com/p-hatz/JVM-Monitor/assets/141098596/f2900f45-62b4-4369-bb7b-eca4e070bb89)
