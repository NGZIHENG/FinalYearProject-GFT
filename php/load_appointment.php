<?php
	error_reporting(0);
	if (!isset($_GET['userid'])) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
	}
	$userid = $_GET['userid'];
	include_once("dbconnect.php");
	$sqlloadappointment = "SELECT * FROM tbl_appointment WHERE user_id = '$userid' AND appointment_status = 'Pending'";
	$result = $conn->query($sqlloadappointment);
	if ($result->num_rows > 0) {
		$appointmentarray["appointment"] = array();
		while ($row = $result->fetch_assoc()) {
			$appointmentlist = array();
			$appointmentlist['appointment_id'] = $row['appointment_id'];
			$appointmentlist['user_id'] = $row['user_id'];
			$appointmentlist['selected_day'] = $row['selected_day'];
			$appointmentlist['selected_session'] = $row['selected_session'];
			$appointmentlist['selected_location'] = $row['selected_location'];
			array_push($appointmentarray["appointment"],$appointmentlist);
		}
		$response = array('status' => 'success', 'data' => $appointmentarray);
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