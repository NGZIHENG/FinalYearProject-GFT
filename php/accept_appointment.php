<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

if (isset($_POST['appointmentid']) && isset($_POST['pickerid'])) {
    $appointmentid = $_POST['appointmentid'];
    $pickerid = $_POST['pickerid'];
    $sqlacceptappointment = "UPDATE tbl_appointment SET appointment_status = 'Accepted', picker_id = '$pickerid' WHERE appointment_id = '$appointmentid'";
    databaseUpdate($sqlacceptappointment);
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