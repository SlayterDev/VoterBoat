<?php
    session_start();
    include ('../config/dbconnect.php');
    
    // make sure admin is authenticated
    if ($_SESSION['logged_in'] != true)
        header("Location: ../index.php");
?>

<!doctype html>

<html lang="en">
<head>
    <title>VoterBoat</title>
    <link rel="stylesheet" tyep="text/css" href="../css/main.css" />
    <script src="../javascript/jquery1.js"></script>
    <script src="../javascript/jquery2.js"></script>
    <script src="../javascript/main.js"></script>
</head>
<body>
    <div id="header">
        <center><a href="home.php"><span>VoterBoat</span></a></center>
    </div>
    <div id="form">
        <center>
            <span style="display: block; margin-top: 20px; font-size: 18pt; margin-bottom: 30px;">Manage Voters</span>
            <a href="manage_pending_voters.php"><input type="button" value="Pending Voters" class="form_btn" style="display: block; margin-bottom: 10px; width: 200px; background-color: #3498db;" /></a>
            <a href="manage_all_voters.php"><input type="button" value="All Voters" class="form_btn" style="display: block; margin-bottom: 10px; width: 200px; background-color: #3498db;" /></a>
        </center>
    </div>
</body>
</html>
