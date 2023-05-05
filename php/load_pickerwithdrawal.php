<?php
	error_reporting(0);
	if (!isset($_GET['pickerid'])) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
	}
	$pickerid = $_GET['pickerid'];
	include_once("dbconnect.php");
	$sqlloadpickerwithdrawal = "SELECT * FROM tbl_withdrawpicker WHERE picker_id = '$pickerid'";
	$result = $conn->query($sqlloadpickerwithdrawal);
	if ($result->num_rows > 0) {
		$withdrawalpickerarray["withdrawpicker"] = array();
		while ($row = $result->fetch_assoc()) {
			$withdrawalpickerlist = array();
			$withdrawalpickerlist['withdrawpicker_id'] = $row['withdrawpicker_id'];
			$withdrawalpickerlist['picker_id'] = $row['picker_id'];
			$withdrawalpickerlist['amount'] = $row['amount'];
			$withdrawalpickerlist['bankNum'] = $row['bankNum'];
			$withdrawalpickerlist['bankName'] = $row['bankName'];
			array_push($withdrawalpickerarray["withdrawpicker"],$withdrawalpickerlist);
		}
		$response = array('status' => 'success', 'data' => $withdrawalpickerarray);
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