<?php
    session_start();
    include ('../config/dbconnect.php');
    
    // make sure admin is authenticated
    if ($_SESSION['logged_in'] != true)
        header("Location: ../index.php");
        
    // make sure user is admin
    $checkIfMaster = mysql_query("SELECT permissions FROM users WHERE user_id='".$_SESSION['user_id']."'");
    $results = mysql_fetch_array($checkIfMaster);
    if ($results['permissions'] != 'Master' && $results['permissions'] != 'Admin')
    {
        header("Location: home.php");
    }
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
        <a href="home.php"><input type="button" class="form_btn" style="height: 30px; width: 100px; margin-left: 10px; background-color: #3498db;" value="Menu" /></a>
        <a href="../processes/logout.php"><input type="button" class="form_btn" style="height: 30px; width: 100px; margin-left: 10px; background-color: #e74c3c;" value="Log Out" /></a>
    </div>
    <div id="form">
        <center>
            <span style="display: block; margin-top: 20px; font-size: 18pt; margin-bottom: 30px;">Manage Voters</span>
            <a href="manage_pending_voters.php"><input type="button" value="Pending Voters" class="form_btn" style="display: block; margin-bottom: 10px; width: 200px; background-color: #3498db;" /></a>
            <a href="manage_all_voters.php"><input type="button" value="Approved Voters" class="form_btn" style="display: block; margin-bottom: 10px; width: 200px; background-color: #3498db;" /></a>
        </center>
    </div>
</body>
</html>
