<?php
	error_reporting(0);
	if (!isset($_GET['userid'])) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
	}
	$userid = $_GET['userid'];
	include_once("dbconnect.php");
	$sqlloadwithdrawal = "SELECT * FROM tbl_withdraw WHERE user_id = '$userid'";
	$result = $conn->query($sqlloadwithdrawal);
	if ($result->num_rows > 0) {
		$withdrawalarray["withdrawal"] = array();
		while ($row = $result->fetch_assoc()) {
			$withdrawallist = array();
			$withdrawallist['withdrawal_id'] = $row['withdrawal_id'];
			$withdrawallist['user_id'] = $row['user_id'];
			$withdrawallist['amount'] = $row['amount'];
			$withdrawallist['bankNum'] = $row['bankNum'];
			$withdrawallist['bankName'] = $row['bankName'];
			array_push($withdrawalarray["withdrawal"],$withdrawallist);
		}
		$response = array('status' => 'success', 'data' => $withdrawalarray);
    sendJsonResponse($response);
		}else{
		$response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
	}
	
	function sendJsonResponse($sentArray)
	{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
	}
?>