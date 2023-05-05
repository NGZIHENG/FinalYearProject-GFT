<?php
	if (!isset($_POST['register'])) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
		die();
	}

include_once("dbconnect.php");
$name = $_POST['name'];
$email = $_POST['email'];
$phone = $_POST['phone'];
$password = sha1($_POST['password']);
$otp = rand(10000,99999);
$address = "na";
$balance = "0";

$sqlregpicker = "INSERT INTO `tbl_pickers`(`picker_email`, `picker_name`, `picker_phone`, `picker_address`, `picker_otp`, `picker_password`, `picker_balance`) VALUES ('$email','$name','$phone','$address',$otp,'$password','$balance')";

try {
	if ($conn->query($sqlregpicker) === TRUE) {
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