<?php
	if (!isset($_POST['withdrawpicker'])) {
    	$response = array('status' => 'failed', 'data' => null);
    	sendJsonResponse($response);
		die();
	}

	include_once("dbconnect.php");
	$pickerid= $_POST['pickerid'];
	$amount = $_POST['amount'];
	$bankNum = $_POST['bankNum'];
	$bankName = $_POST['bankName'];

	$sqlgetbalance = "SELECT picker_balance FROM tbl_pickers WHERE picker_id = '$pickerid'";
	$result = $conn->query($sqlgetbalance);
	if ($result->num_rows > 0) {
		$row = $result->fetch_assoc();
		$currentBalance = $row['picker_balance'];
	} else {
		$response = array('status' => 'failed', 'data' => null);
		sendJsonResponse($response);
		die();
	}

	// Check if the picker has sufficient balance
	// if ($amount > $currentBalance) {
	// 	$response = array('status' => 'failed', 'data' => null);
	// 	sendJsonResponse($response);
	// 	die();
	// }

	// Deduct the withdrawn amount from the picker's balance
	$newBalance = $currentBalance - $amount;
	$sqlupdatebalance = "UPDATE tbl_pickers SET picker_balance = '$newBalance' WHERE picker_id = '$pickerid'";

	$sqlwithdrawpicker = "INSERT INTO `tbl_withdrawpicker`(`picker_id`,`amount`, `bankNum`, `bankName`) VALUES ('$pickerid','$amount','$bankNum','$bankName')";

	try {
		$conn->begin_transaction();

		if ($conn->query($sqlwithdrawpicker) === TRUE && $conn->query($sqlupdatebalance) === TRUE) {
			$conn->commit();
			$response = array('status' => 'success', 'data' => null);
			sendJsonResponse($response);
		} else {
			$conn->rollback();
			$response = array('status' => 'failed', 'data' => null);
			sendJsonResponse($response);
		}
	}
	catch(Exception $e) {
		$conn->rollback();
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