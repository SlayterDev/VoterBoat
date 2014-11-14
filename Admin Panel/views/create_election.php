
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
    if ($results['permissions'] != 'Master' && $results['permissions'] != 'Admin')
    {
        header("Location: home.php");
    }
    
    if (isset($_POST['submit']))
    {
        $election_name = mysql_escape_string($_POST['election_name']);
        $branch = mysql_escape_string($_POST['branch']);
        $time = mysql_escape_string($_POST['time']);
        
        // get time in seconds
        switch ($time)
        {
            case "1h":
                $secs = 60*60;
                break;
            case "1d":
                $secs = 60*60*24;
                break;
            case "3d":
                $secs = 60*60*24*3;
                break;
            case "1w":
                $secs = 60*60*24*7;
                break;
            case "1M":
                $secs = 60*60*24*30;
                break;
            case "3M":
                $secs = 60*60*24*30*3;
                break;
            case "1Y":
                $secs = 60*60*24*365;
                break;
        }
        
        if (empty($election_name))
            header("Location: add_admin.php?error=1");
        else
        {
            $createElection = mysql_query("INSERT INTO elections (name, type, delete_time) VALUES ('".$election_name."', '".$branch."', '".$secs."')");
            $getStudents = mysql_query("SELECT * FROM users WHERE permissions='Student'");
            while ($results = mysql_fetch_array($getStudents))
            {
                if ($results['email'] != null)
                {
                    // send email
                    $message = "An admin has created a new election on VoterBoat. Sign in to register for the election.";
                        $headers = 'From: noreply@voterboat.me' . "\r\n" .
                        'Reply-To: noreply@voterboat.me' . "\r\n" .
                        'X-Mailer: PHP/' . phpversion();
                        mail($results['email'], 'VoterBoat Alert', $message, $headers);
                }
            }
            header("Location: create_election.php?error=2");
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
        function focusElectionName()
        {
            if (document.getElementById("electionname").value == "Election Name")
            {
                document.getElementById("electionname").value = "";
            }
        }
        
        function blurElectionName()
        {
            if (document.getElementById("electionname").value == "")
            {
                document.getElementById("electionname").value = "Election Name";
            }
        }
    </script>
    <div id="header">
        <a href="home.php"><input type="button" class="form_btn" style="height: 30px; width: 100px; margin-left: 10px; background-color: #3498db;" value="Menu" /></a>
        <a href="../processes/logout.php"><input type="button" class="form_btn" style="height: 30px; width: 100px; margin-left: 10px; background-color: #e74c3c;" value="Log Out" /></a>
    </div>
    <div id="form">
        <center>
            <span style="display: block; margin-top: 20px; font-size: 18pt; margin-bottom: 30px;">Create Election</span>
            <form method="POST" action="">
                <input type="text" value="Election Name" onfocus="focusElectionName();" onblur="blurElectionName();" id="electionname" name="election_name" class="form_field" style="display: block; margin-bottom: 20px;" />
                <select name="branch" style="-webkit-appearance: none; width: 280px; height: 44px; border: 1px solid #DBDBDB; background-color: #FFFFFF; outline: none; margin-bottom: 20px; font-family: 'HelveticaNeue-Thin', 'Helvetica Neue Light', 'Helvetica Neue', Helvetica, Arial, 'Lucida Grande', sans-serif; border-radius: 6px; font-size: 14pt; padding-left: 10px; padding-right: 10px;">
                    <option value="Executive">Executive</option>
                    <option value="Legislative">Legislative</option>
                    <option value="Judicial">Judicial</option>
                </select>
                <select name="time" style="-webkit-appearance: none; width: 280px; height: 44px; border: 1px solid #DBDBDB; background-color: #FFFFFF; outline: none; margin-bottom: 20px; font-family: 'HelveticaNeue-Thin', 'Helvetica Neue Light', 'Helvetica Neue', Helvetica, Arial, 'Lucida Grande', sans-serif; border-radius: 6px; font-size: 14pt; padding-left: 10px; padding-right: 10px;">
                    <option value="1h">1 Hour</option>
                    <option value="1d">1 Day</option>
                    <option value="3d">3 Days</option>
                    <option value="1w">1 Week</option>
                    <option value="1M">1 Month</option>
                    <option value="3M">3 Months</option>
                    <option value="1Y">1 Year</option>
                </select>
                <input type="submit" name="submit" value="Submit" class="form_btn" style="display: block; margin-bottom: 20px; width: 140px;" />
                <?php
                    if (isset($_GET['error']))
                    {
                        if ($_GET['error'] == '1')
                        {
                            $color = "#e74c3c";
                            $message = "Please enter an election name.";
                        }
                        else if ($_GET['error'] == '2')
                        {
                            $color = "#2ecc71";
                            $message = "The election has been created successfully!";
                        }
                        echo '<span style="color: '.$color.'; display: block; margin-top: 10px; margin-bottom: 5px;">'.$message.'</span>';
                    }
                ?>
            </form>
        </center>
    </div>
</body>
</html>
