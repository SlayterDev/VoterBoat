<?php
    session_start();
    include '../config/dbconnect.php';
    
    // redirect to dashboard if logged in
    if (isset($_SESSION['logged_in']))
    {
        if ($_SESSION['logged_in'] == true)
        {
            header("Location: admin_dashboard.php");
        }
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
        <center><a href="home.php"><span>VoterBoat</span></a></center>
    </div>
    <div id="form">
        <center>
            <span style="display: block; margin-top: 20px; font-size: 18pt; margin-bottom: 30px;">Control Panel</span>
            <?php
                $checkForMaster = mysql_query("SELECT * FROM users WHERE permissions='Master'");
                if (mysql_num_rows($checkForMaster) == 0)
                {
                    echo '<a href="create_master_admin.php"><input type="button" value="Create Master Admin" class="form_btn" style="display: block; margin-bottom: 5px;" /></a>';
                }
            ?>
            <a href="sign_in.php"><input type="button" value="Sign In" class="form_btn" style="background-color: #3498db; display: block; margin-bottom: 30px;" /></a>
            <span style="font-size: 12pt;">If you were not supplied with an administrative password, please contact us.</span>
        </center>
    </div>
</body>
</html>
