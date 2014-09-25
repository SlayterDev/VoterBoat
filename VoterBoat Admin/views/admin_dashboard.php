<?php
    session_start();
    include ('../config/dbconnect.php');
    
    // make sure admin is authenticated
    if ($_SESSION['logged_in'] != true)
        header("Location: ../index.php");
    
    $checkIfMaster = mysql_query("SELECT * FROM users WHERE user_id='".$_SESSION['user_id']."'");
    $results = mysql_fetch_array($checkIfMaster);
    if ($results['permissions'] == 'Master')
        $isMaster = true;
    else
        $isMaster = false;
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
            <span style="display: block; margin-top: 20px; font-size: 18pt; margin-bottom: 30px;">Admin Dashboard</span>
            <?php
                if ($isMaster)
                    echo '<a href="add_admin.php"><input type="button" value="Add Admin" class="form_btn" style="display: block; margin-bottom: 10px; width: 200px;" /></a>';
            ?>
            <a href="create_election.php"><input type="button" value="Create Election" class="form_btn" style="display: block; margin-bottom: 10px; width: 200px;" /></a>
            <?php
                if ($isMaster)
                    echo '<a href="manage_admins.php"><input type="button" value="Manage Admins" class="form_btn" style="display: block; margin-bottom: 10px; width: 200px; background-color: #3498db;" /></a>';
            ?>
            <a href="manage_elections.php"><input type="button" value="Manage Elections" class="form_btn" style="display: block; margin-bottom: 10px; width: 200px; background-color: #3498db;" /></a>
            <a href="manage_voters.php"><input type="button" value="Manage Voters" class="form_btn" style="display: block; margin-bottom: 10px; width: 200px; background-color: #3498db;" /></a>
            <a href="../processes/logout.php"><input type="button" value="Log Out" class="form_btn" style="display: block; margin-bottom: 10px; width: 200px; background-color: #e74c3c;" /></a>
        </center>
    </div>
</body>
</html>
