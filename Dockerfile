FROM teenak/centos-cdh-hadoop-client
MAINTAINER Taishun Nakatani <teenak77@gmail.com>

RUN mkdir -p /opt/apache
RUN curl -s http://ftp.yz.yamagata-u.ac.jp/pub/network/apache/spark/spark-1.6.2/spark-1.6.2-bin-hadoop2.6.tgz  | tar -xz -C /opt/apache
RUN cd /opt/apache && ln -s spark-1.6.2-bin-hadoop2.6 spark

ENV HADOOP_CONF_DIR /etc/hadoop/conf
ENV YARN_CONF_DIR /etc/hadoop/conf
ENV SPARK_HOME /opt/apache/spark
RUN echo "HADOOP_CONF_DIR=/etc/hadoop/conf" >> /etc/environment
RUN echo "YARN_CONF_DIR=/etc/hadoop/conf" >> /etc/environment
RUN echo "SPARK_HOME=/opt/apache/spark" >> /etc/environment

ADD conf/core-site.xml /etc/hadoop/conf/core-site.xml
ADD conf/hdfs-site.xml /etc/hadoop/conf/hdfs-site.xml
ADD conf/yarn-site.xml /etc/hadoop/conf/yarn-site.xml

# setting spark defaults
RUN echo spark.yarn.jar hdfs:///spark/spark-assembly-1.6.2-hadoop2.6.0.jar > $SPARK_HOME/conf/spark-defaults.conf
RUN cp $SPARK_HOME/conf/metrics.properties.template $SPARK_HOME/conf/metrics.properties

ENTRYPOINT ["/bin/bash"]

