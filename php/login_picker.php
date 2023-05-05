<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}
include_once("dbconnect.php");
$email = $_POST['email'];
$password = sha1($_POST['password']);
$sqlloginpicker = "SELECT * FROM tbl_pickers WHERE picker_email = '$email' AND picker_password = '$password'";
$result = $conn->query($sqlloginpicker);

if ($result->num_rows > 0) {
	while ($row = $result->fetch_assoc()) {
		$pickerlist = array();
		$pickerlist['id'] = $row['picker_id'];
		$pickerlist['name'] = $row['picker_name'];
    		$pickerlist['email'] = $row['picker_email'];
    		$pickerlist['phone'] = $row['picker_phone'];
    		$pickerlist['address'] = $row['picker_address'];
    		$pickerlist['regdate'] = $row['picker_datereg'];
			$pickerlist['balance'] = $row['picker_balance'];
    $response = array('status' => 'success', 'data' => $pickerlist);
    sendJsonResponse($response);
	}
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