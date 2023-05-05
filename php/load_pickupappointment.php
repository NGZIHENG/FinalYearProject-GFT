<?php
	error_reporting(0);
	if (!isset($_GET)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
	}
	$pickerid = $_GET['pickerid'];
	include_once("dbconnect.php");
	$sqlloadpickupappointment = "SELECT * FROM tbl_appointment WHERE picker_id = '$pickerid' AND appointment_status = 'Pick Up'";
	$result = $conn->query($sqlloadpickupappointment);
	if ($result->num_rows > 0) {
		$pickupappointmentarray["pickupappointment"] = array();
		while ($row = $result->fetch_assoc()) {
			$pickupappointmentlist = array();
			$pickupappointmentlist['appointment_id'] = $row['appointment_id'];
			$pickupappointmentlist['user_id'] = $row['user_id'];
			$pickupappointmentlist['selected_day'] = $row['selected_day'];
			$pickupappointmentlist['selected_session'] = $row['selected_session'];
			$pickupappointmentlist['selected_location'] = $row['selected_location'];
			array_push($pickupappointmentarray["pickupappointment"],$pickupappointmentlist);
		}
		$response = array('status' => 'success', 'data' => $pickupappointmentarray);
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