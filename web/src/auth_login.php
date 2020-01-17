<?php

$servername = "172.18.0.2";
$username = "test";
$password = "test";
$dbname = "clouddb";
$mysqli = new mysqli($servername, $username, $password, $dbname);

// Check connection
if($mysqli === false){
  die("ERROR: Could not connect. " . $mysqli->connect_error);
}

// Escape user inputs for security
$subUser = $mysqli->real_escape_string($_REQUEST['username']);
$subPass = $mysqli->real_escape_string($_REQUEST['password']);

date_default_timezone_set("America/Chicago");
$time = date("Y/m/d h:i:s a");

// Attempt insert query execution
$sql = "INSERT INTO users (username, password, time) VALUES('$subUser', '$subPass', '$time')";
if($mysqli->query($sql) === true){
  //echo "Records inserted successfully.";
  echo file_get_contents("index.html");

} else{
  echo "ERROR: Could not execute $sql. " . $mysqli->error;
}

// Close connection
$mysqli->close();
?>

