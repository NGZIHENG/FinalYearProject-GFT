<?php
	error_reporting(0);
	if (!isset($_GET)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
	}
	$pickerid = $_GET['pickerid'];
	include_once("dbconnect.php");
	$sqlloadacceptedappointment = "SELECT * FROM tbl_appointment WHERE picker_id = '$pickerid' AND appointment_status = 'Accepted'";
	$result = $conn->query($sqlloadacceptedappointment);
	if ($result->num_rows > 0) {
		$acceptedappointmentarray["acceptedappointment"] = array();
		while ($row = $result->fetch_assoc()) {
			$acceptedappointmentlist = array();
			$acceptedappointmentlist['appointment_id'] = $row['appointment_id'];
			$acceptedappointmentlist['user_id'] = $row['user_id'];
			$acceptedappointmentlist['selected_day'] = $row['selected_day'];
			$acceptedappointmentlist['selected_session'] = $row['selected_session'];
			$acceptedappointmentlist['selected_location'] = $row['selected_location'];
			array_push($acceptedappointmentarray["acceptedappointment"],$acceptedappointmentlist);
		}
		$response = array('status' => 'success', 'data' => $acceptedappointmentarray);
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