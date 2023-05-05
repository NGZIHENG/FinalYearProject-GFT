<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

if (isset($_POST['newphone'])) {
    $phone = $_POST['newphone'];
    $pickerid = $_POST['pickerid'];
    $sqlupdatepicker = "UPDATE tbl_pickers SET picker_phone ='$phone' WHERE picker_id = '$pickerid'";
    databaseUpdate($sqlupdatepicker);
    die();
}

if (isset($_POST['oldpass'])) {
    $oldpass = sha1($_POST['oldpass']);
    $newpass = sha1($_POST['newpass']);
    $pickerid = $_POST['pickerid'];
    include_once("dbconnect.php");
    $sqlloginpicker = "SELECT * FROM tbl_pickers WHERE picker_id = '$pickerid' AND picker_password = '$oldpass'";
    $result = $conn->query($sqlloginpicker);
    if ($result->num_rows > 0) {
    	$sqlupdatepicker = "UPDATE tbl_pickers SET user_password ='$newpass' WHERE picker_id = '$pickerid'";
            if ($conn->query($sqlupdatepicker) === TRUE) {
                $response = array('status' => 'success', 'data' => null);
                sendJsonResponse($response);
            } else {
                $response = array('status' => 'failed', 'data' => null);
                sendJsonResponse($response);
            }
    }else{
        $response = array('status' => 'failed', 'data' => null);
        sendJsonResponse($response);
    }
}

if (isset($_POST['newname'])) {
    $name = $_POST['newname'];
    $pickerid = $_POST['pickerid'];
    $sqlupdatepicker = "UPDATE tbl_pickers SET picker_name ='$name' WHERE picker_id = '$pickerid'";
    databaseUpdate($sqlupdatepicker);
    die();
}


function databaseUpdate($sql){
    include_once("dbconnect.php");
    if ($conn->query($sql) === TRUE) {
        $response = array('status' => 'success', 'data' => null);
        sendJsonResponse($response);
    } else {
        $response = array('status' => 'failed', 'data' => null);
        sendJsonResponse($response);
    }
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>