<?php
	if (!isset($_POST['withdraw'])) {
    	$response = array('status' => 'failed', 'data' => null);
    	sendJsonResponse($response);
		die();
	}

	include_once("dbconnect.php");
	$userid= $_POST['userid'];
	$amount = $_POST['amount'];
	$bankNum = $_POST['bankNum'];
	$bankName = $_POST['bankName'];

	$sqlgetbalance = "SELECT user_balance FROM tbl_users WHERE user_id = '$userid'";
	$result = $conn->query($sqlgetbalance);
	if ($result->num_rows > 0) {
		$row = $result->fetch_assoc();
		$currentBalance = $row['user_balance'];
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
	$sqlupdatebalance = "UPDATE tbl_users SET user_balance = '$newBalance' WHERE user_id = '$userid'";

	$sqlwithdrawuser = "INSERT INTO `tbl_withdraw`(`user_id`,`amount`, `bankNum`, `bankName`) VALUES ('$userid','$amount','$bankNum','$bankName')";

	try {
		$conn->begin_transaction();

		if ($conn->query($sqlwithdrawuser) === TRUE && $conn->query($sqlupdatebalance) === TRUE) {
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