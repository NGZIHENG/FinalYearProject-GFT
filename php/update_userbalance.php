<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

if (isset($_POST['userid']) && isset($_POST['newamount'])) {
    $userid = $_POST['userid'];
    $amount = $_POST['newamount'];
    $sql = "UPDATE tbl_users SET user_balance = user_balance + $amount WHERE user_id = '$userid'";
    databaseUpdate($sql);
} else {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
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