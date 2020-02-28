package require java
java::import -package java.util HashMap Map
java::import -package java.util ArrayList List
java::import -package org.ekstep.graph.dac.model Node

set graph_id "domain"
set object_type "Content"
set search [java::new HashMap]
$search put "objectType" $object_type
$search put "nodeType" "DATA_NODE"
$search put "status" "Retired"

set search_criteria [create_search_criteria $search]
set search_response [searchNodes $graph_id $search_criteria]
set check_error [check_response_error $search_response]
if {$check_error} {
	return $search_response;
} else {
	set item_list [java::new ArrayList]
	set graph_nodes [get_resp_value $search_response "node_list"]
	java::for {Node graph_node} $graph_nodes {
		set itemId [java::prop $graph_node "identifier"]
		$item_list add $itemId
		deleteDataNode $graph_id $itemId
	}
	return $item_list
}