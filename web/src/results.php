<?php
function getDBData(){

	$servername = "172.18.0.2";
	$username = "test";
	$password = "test";
	$dbname = "clouddb";

	session_start();
	$_SESSION['servername'] = $servername; // Lets other files use ip variable (see vars.php)


	// Create connection
	$conn = new mysqli($servername, $username, $password, $dbname, 3306);
	// Check connection
	if ($conn->connect_error) {
		die("Connection failed: " . $conn->connect_error);
	}

	$sql = "SELECT * FROM users ORDER BY ID DESC";
	$result = $conn->query($sql);

	echo "<h3>Login Info:</h2>";

	if ($result->num_rows > 0) {
		echo "<table class=\"table\"><tr><th>Email</th><th>Password</th><th>Date</th></tr>";
		// output data of each row
		while($row = $result->fetch_assoc()) {
			echo "<tr><td>".$row["username"]."</td><td>".$row["password"]."</td><td>".$row["time"]."</td></tr>";
		}
		echo "</table>";
	} else {
		echo "No available data";
	}
	$conn->close();
}
getDBData();

?>
