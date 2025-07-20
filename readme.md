sudo sysctl -w vm.max_map_count=262144

h-1 | ERROR: [1] bootstrap checks failed
opensearch-1 | [1]: max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]
opensearch-1 | ERROR: OpenSearch did not exit normally - check the logs at /usr/share/opensearch/logs/opensearch-cluster.log

composer install

