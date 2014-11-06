<?php

    session_start();
    include '../config/dbconnect.php';
    if (isset($_SESSION['logged_in']))
    {
        if ($_SESSION['logged_in'] != true)
        {
            header("Location: home.php");
        }
    }
    
    // make sure user is admin
    $checkIfMaster = mysql_query("SELECT permissions FROM users WHERE user_id='".$_SESSION['user_id']."'");
    $results = mysql_fetch_array($checkIfMaster);
    if ($results['permissions'] != 'Master' || $results['permissions'] != 'Admin')
    {
        header("Location: home.php");
    }
    
    if (isset($_POST['submit']))
    {
        $user_name = mysql_escape_string($_POST['user_name']);
        $password = mysql_escape_string($_POST['password']);
        $hashed_password = sha1($password);
        
        if (empty($user_name) || $user_name == 'Username')
            header("Location: add_monitor.php?error=1");
        else if (empty($password))
            header("Location: add_monitor.php?error=2");
        else if (strlen($user_name) > 20)
            header("Location: add_monitor.php?error=5");
        else if (strlen($password) < 5 || strlen($password) > 20)
            header("Location: add_monitor.php?error=6");
        else
        {
            $checkUser = mysql_query("SELECT * FROM users WHERE user_name='".$user_name."'");
            if (mysql_num_rows($checkUser) == 0)
            {
                $addAdmin = mysql_query("INSERT INTO users (user_name, password, permissions) VALUES ('".$user_name."', '".$hashed_password."', 'Monitor')");
                header("Location: add_monitor.php?error=4");
            }
            else
            {
                header("Location: add_monitor.php?error=3");
            }
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
    <script type="text/javascript">
        function focusUsername()
        {
            if (document.getElementById("username").value == "Username")
            {
                document.getElementById("username").value = "";
            }
        }
        
        function blurUsername()
        {
            if (document.getElementById("username").value == "")
            {
                document.getElementById("username").value = "Username";
            }
        }
        
        function focusPassword()
        {
            if (document.getElementById("passwordFiller").value == "Password")
            {
                document.getElementById("passwordFiller").style.display = 'none';
                document.getElementById("password").style.display = 'block';
                document.getElementById("password").focus();
            }
        }
        
        function blurPassword()
        {
            if (document.getElementById("password").value == "")
            {
                document.getElementById("password").style.display = 'none';
                document.getElementById("passwordFiller").style.display = 'block';
            }
        }
    </script>
    <div id="header">
        <center><a href="home.php"><span>VoterBoat</span></a></center>
    </div>
    <div id="form">
        <center>
            <span style="display: block; margin-top: 20px; font-size: 18pt; margin-bottom: 30px;">Add Monitor</span>
            <form method="POST" action="">
                <input type="text" value="Username" onfocus="focusUsername();" onblur="blurUsername();" id="username" name="user_name" class="form_field" style="display: block; margin-bottom: 10px;" />
                <input type="text" value="Password" id="passwordFiller" onfocus="focusPassword();" class="form_field" style="display: block; margin-bottom: 20px;" />
                <input type="password" value="" name="password" onblur="blurPassword();" id="password" class="form_field" style="display: none; margin-bottom: 20px;" />
                <input type="submit" name="submit" value="Submit" class="form_btn" style="display: block; margin-bottom: 20px; width: 140px;" />
                <?php
                    if (isset($_GET['error']))
                    {
                        if ($_GET['error'] == '1')
                        {
                            $color = "#e74c3c";
                            $message = "Please enter a username.";
                        }
                        else if ($_GET['error'] == '2')
                        {
                            $color = "#e74c3c";
                            $message = "Please enter a password";
                        }
                        else if ($_GET['error'] == '3')
                        {
                            $color = "#e74c3c";
                            $message = "The username is already taken. Please choose another one.";
                        }
                        else if ($_GET['error'] == '4')
                        {
                            $color = "#2ecc71";
                            $message = "The monitor has been created successfully!";
                        }
                        else if ($_GET['error'] == '5')
                        {
                            $color = "#e74c3c";
                            $message = "Please choose a username that is less than 20 characters long.";
                        }
                        else if ($_GET['error'] == '6')
                        {
                            $color = "#e74c3c";
                            $message = "Please choose a password that is between 5 and 20 characters in length.";
                        }
                        echo '<span style="color: '.$color.'; display: block; margin-top: 10px; margin-bottom: 5px;">'.$message.'</span>';
                    }
                ?>
            </form>
        </center>
    </div>
</body>
</html>
