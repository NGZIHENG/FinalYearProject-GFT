<?php
	error_reporting(0);
	if (!isset($_GET)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
	}
	include_once("dbconnect.php");
	$sqlloadallappointment = "SELECT * FROM tbl_appointment WHERE appointment_status = 'Pending'";
	$result = $conn->query($sqlloadallappointment);
	if ($result->num_rows > 0) {
		$allappointmentarray["allappointment"] = array();
		while ($row = $result->fetch_assoc()) {
			$allappointmentlist = array();
			$allappointmentlist['appointment_id'] = $row['appointment_id'];
			$allappointmentlist['user_id'] = $row['user_id'];
			$allappointmentlist['selected_day'] = $row['selected_day'];
			$allappointmentlist['selected_session'] = $row['selected_session'];
			$allappointmentlist['selected_location'] = $row['selected_location'];
			array_push($allappointmentarray["allappointment"],$allappointmentlist);
		}
		$response = array('status' => 'success', 'data' => $allappointmentarray);
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