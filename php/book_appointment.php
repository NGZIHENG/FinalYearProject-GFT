<?php
	if (!isset($_POST)) {
    	$response = array('status' => 'failed', 'data' => null);
    	sendJsonResponse($response);
    	die();
	}

	include_once("dbconnect.php");
	$userid= $_POST['userid'];
	$selectedDay = $_POST['selectedDay'];
	$selectedSessionType = $_POST['selectedSessionType'];
	$selectedLocation = $_POST['selectedLocation'];

	$sqlappointment = "INSERT INTO `tbl_appointment`(`user_id`, `selected_day`, `selected_session`, `selected_location`) VALUES ('$userid','$selectedDay','$selectedSessionType','$selectedLocation')";

	try {
		if ($conn->query($sqlappointment) === TRUE) {
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