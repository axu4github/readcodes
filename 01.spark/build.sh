#!/bin/sh

sub=$1

function run_build() {
    ./build/mvn -DskipTests -pl :$1 clean install
}

if [ -n "${SPARK_HOME}" ]; then
    echo "SPARK_HOME: ${SPARK_HOME}"
    cd ${SPARK_HOME}
    export MAVEN_OPTS="-Xmx2g -XX:ReservedCodeCacheSize=512m"
    if [ "${sub}" = "core" ]; then
        artifactId="spark-core_2.11"
    elif [ "${sub}" = "repl" ]; then
        artifactId="spark-repl_2.11"
    else
        echo "NOT SET SUB."
        exit
    fi

    run_build ${artifactId}

    CMD="cp ${SPARK_HOME}/${sub}/target/${artifactId}-2.3.0.jar ${SPARK_HOME}/assembly/target/scala-2.11/jars/"
    echo "${CMD}"
    ${CMD}

    cd -
else
    echo "NOT SET SPARK_HOME."
fi

