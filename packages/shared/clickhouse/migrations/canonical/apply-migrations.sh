#!/bin/bash
for migration in $(ls *.up.sql | sort); do
    echo "Applying: $migration"
    
    # Use perl -0777 (slurp mode) to handle multi-line template variables
    # sed processes line-by-line and cannot match {TEMPLATE:...} that spans multiple lines
    content=$(perl -0777 -pe '
        s/\{CLICKHOUSE_CLUSTER_CLAUSE\}//g;
        s/\{CLICKHOUSE_REPLICATION_PREFIX\}//g;
        s/\{CLICKHOUSE_HISTORICAL_FINAL_NEWLINES:[^}]*\}//g;
        s/\{CLICKHOUSE_UNCLUSTERED_ONLY:([^}]*)\}/$1/g;
        s/\{CLICKHOUSE_CLUSTERED_ONLY:[^}]*\}//g;
    ' "$migration")
    
    echo "$content" | docker exec -i langfuse-clickhouse clickhouse-client \
        --user=clickhouse \
        --password=clickhouse \
        --database=default \
        --multiquery 2>&1 | grep -v "already exists" || true
done
