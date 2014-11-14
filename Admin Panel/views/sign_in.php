<?php

    session_start();
    include '../config/dbconnect.php';
    
    if (isset($_POST['submit']))
    {
        $user_name = mysql_escape_string($_POST['user_name']);
        $password = mysql_escape_string($_POST['password']);
        $hashed_password = sha1($password);
        
        if (empty($user_name) || $user_name == "Username")
            header("Location: sign_in.php?error=1");
        else if (empty($password))
            header("Location: sign_in.php?error=2");
        else
        {
            $checkCredentials = mysql_query("SELECT * FROM users WHERE user_name='".$user_name."' AND password='".$hashed_password."' LIMIT 1");
            if (mysql_num_rows($checkCredentials) == 1)
            {
                // authenticated
                $userInfo = mysql_fetch_array($checkCredentials);
                
                $_SESSION['logged_in'] = true;
                $_SESSION['user_id'] = $userInfo['user_id'];
                header("Location: admin_dashboard.php");
            }
            else
                header("Location: sign_in.php?error=3");
        }
    }

?>

<!doctype html>

<html lang="en">
<head>
    <title>VoterBoat</title>
    <link rel="stylesheet" tyep="text/css" href="../css/main.css" />
    <script src="../javascript/jquery1.js"></script>
    <script src=".../javascript/jquery2.js"></script>
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
        <a href="home.php"><input type="button" class="form_btn" style="height: 30px; width: 100px; margin-left: 10px; background-color: #3498db;" value="Home" /></a>
    </div>
    <div id="form">
        <center>
            <span style="display: block; margin-top: 20px; font-size: 18pt; margin-bottom: 30px;">Sign In</span>
            <form method="POST" action="">
                <input type="text" value="Username" onfocus="focusUsername();" onblur="blurUsername();" id="username" name="user_name" class="form_field" style="display: block; margin-bottom: 10px;" />
                <input type="text" value="Password" id="passwordFiller" onfocus="focusPassword();" class="form_field" style="display: block; margin-bottom: 20px;" />
                <input type="password" value="" name="password" onblur="blurPassword();" id="password" class="form_field" style="display: none; margin-bottom: 20px;" />
                <input type="submit" name="submit" value="Submit" class="form_btn" style="display: block; margin-bottom: 20px; width: 140px;" />
                <?php
                    if (isset($_GET['error']))
                    {
                        if ($_GET['error'] == '1')
                            $message = "Please enter your username.";
                        else if ($_GET['error'] == '2')
                            $message = "Please enter your password";
                        else if ($_GET['error'] == '3')
                            $message = "Your username or password is invalid. Please try again.";
                        echo '<span style="color: #e74c3c; display: block; margin-top: 10px; margin-bottom: 5px;">'.$message.'</span>';
                    }
                ?>
            </form>
        </center>
    </div>
</body>
</html>
