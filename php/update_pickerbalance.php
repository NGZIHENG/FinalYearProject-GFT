<?php
	if (!isset($_POST['pickerbalance'])) {
    	$response = array('status' => 'failed', 'data' => null);
    	sendJsonResponse($response);
		die();
	}

	include_once("dbconnect.php");
	$pickerid= $_POST['pickerid'];

	$sqlupdatepicker = "UPDATE tbl_pickers SET picker_balance = picker_balance + 5 WHERE picker_id = '$pickerid'";

	try {
		if ($conn->query($sqlupdatepicker) === TRUE) {
			$response = array('status' => 'success', 'data' => null);
			sendJsonResponse($response);
		}else{
			$response = array('status' => 'failed', 'data' => null);
			sendJsonResponse($response);
		}
	}
	catch(Exception $e) {
	$response = array('status' => 'failed', 'data' => null);
	sendJsonResponse($response);
	}
	$conn->close();

	function sendJsonResponse($sentArray)
	{
		header('Content-Type: application/json');
		echo json_encode($sentArray);
	}
?>