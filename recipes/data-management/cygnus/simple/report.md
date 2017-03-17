Create issues:


## Misleading Mysql config
Options set in the config file regarding host user and pass for mysql (and might apply to others) are being ignored because docker image already defines default env variables which override the former.

## Using non-root user won't create the database
If I set a non-root user, he won't be able to create database "default". Changing to root works.
time=2017-03-23T07:20:57.762Z | lvl=ERROR | corr=65aa76ec-3b44-41ab-abd2-51651ac7e9cc | trans=65aa76ec-3b44-41ab-abd2-51651ac7e9cc | srv=default | subsrv=/ | comp=cygnus-ngsi | op=processRollbackedBatches | msg=com.telefonica.iot.cygnus.sinks.NGSISink[394] : Persistence error. Message: SQLException, Access denied for user 'myuser'@'%' to database 'default', Stack trace: [com.telefonica.iot.cygnus.backends.mysql.MySQLBackendImpl.createDatabase(MySQLBackendImpl.java:99), com.telefonica.iot.cygnus.sinks.NGSIMySQLSink.persistAggregation(NGSIMySQLSink.java:546), com.telefonica.iot.cygnus.sinks.NGSIMySQLSink.persistBatch(NGSIMySQLSink.java:200), com.telefonica.iot.cygnus.sinks.NGSISink.processRollbackedBatches(NGSISink.java:387), com.telefonica.iot.cygnus.sinks.NGSISink.process(NGSISink.java:370), org.apache.flume.sink.DefaultSinkProcessor.process(DefaultSinkProcessor.java:68), org.apache.flume.SinkRunner$PollingRunner.run(SinkRunner.java:147), java.lang.Thread.run(Thread.java:745)]

Error When first trying FileChannel...

time=2017-03-23T09:30:16.889Z | lvl=ERROR | corr= | trans= | srv= | subsrv= | comp=cygnus-ngsi | op=run | msg=org.apache.flume.SinkRunner$PollingRunner[160] : Unable to deliver event. Exception follows.
java.lang.ClassCastException: org.apache.flume.channel.file.FlumeEvent cannot be cast to com.telefonica.iot.cygnus.interceptors.NGSIEvent
	at com.telefonica.iot.cygnus.sinks.NGSISink.processNewBatches(NGSISink.java:489)
	at com.telefonica.iot.cygnus.sinks.NGSISink.process(NGSISink.java:368)
	at org.apache.flume.sink.DefaultSinkProcessor.process(DefaultSinkProcessor.java:68)
	at org.apache.flume.SinkRunner$PollingRunner.run(SinkRunner.java:147)
	at java.lang.Thread.run(Thread.java:745)
time=2017-03-23T09:30:21.893Z | lvl=ERROR | corr= | trans= | srv= | subsrv= | comp=cygnus-ngsi | op=run | msg=org.apache.flume.SinkRunner$PollingRunner[160] : Unable to deliver event. Exception follows.
java.lang.IllegalStateException: begin() called when transaction is OPEN!
	at com.google.common.base.Preconditions.checkState(Preconditions.java:145)
	at org.apache.flume.channel.BasicTransactionSemantics.begin(BasicTransactionSemantics.java:131)
	at com.telefonica.iot.cygnus.sinks.NGSISink.processNewBatches(NGSISink.java:476)
	at com.telefonica.iot.cygnus.sinks.NGSISink.process(NGSISink.java:368)
	at org.apache.flume.sink.DefaultSinkProcessor.process(DefaultSinkProcessor.java:68)
	at org.apache.flume.SinkRunner$PollingRunner.run(SinkRunner.java:147)
	at java.lang.Thread.run(Thread.java:745)


- CYGNUS_CONF_URL=https://gist.githubusercontent.com/taliaga/26ebe4b540befa32f24a8f847de4c72b/raw/a0226f4f33fd739b9e8e9ad1b7b2d84c84219a0a/cygnus_agent.conf
