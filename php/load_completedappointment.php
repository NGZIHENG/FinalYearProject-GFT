<?php
	error_reporting(0);
	if (!isset($_GET)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
	}
	$pickerid = $_GET['pickerid'];
	include_once("dbconnect.php");
	$sqlloadcompletedappointment = "SELECT * FROM tbl_appointment WHERE picker_id = '$pickerid' AND appointment_status = 'Completed'";
	$result = $conn->query($sqlloadcompletedappointment);
	if ($result->num_rows > 0) {
		$completedappointmentarray["completedappointment"] = array();
		while ($row = $result->fetch_assoc()) {
			$completedappointmentlist = array();
			$completedappointmentlist['appointment_id'] = $row['appointment_id'];
			$completedappointmentlist['user_id'] = $row['user_id'];
			$completedappointmentlist['selected_day'] = $row['selected_day'];
			$completedappointmentlist['selected_session'] = $row['selected_session'];
			$completedappointmentlist['selected_location'] = $row['selected_location'];
			array_push($completedappointmentarray["completedappointment"],$completedappointmentlist);
		}
		$response = array('status' => 'success', 'data' => $completedappointmentarray);
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