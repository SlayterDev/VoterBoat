
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
        $election_name = mysql_escape_string($_POST['election_name']);
        
        if (empty($election_name))
            header("Location: add_admin.php?error=1");
        else
        {
            $createElection = mysql_query("INSERT INTO elections (name) VALUES ('".$election_name."')");
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
        <center><a href="home.php"><span>VoterBoat</span></a></center>
    </div>
    <div id="form">
        <center>
            <span style="display: block; margin-top: 20px; font-size: 18pt; margin-bottom: 30px;">Create Election</span>
            <form method="POST" action="">
                <input type="text" value="Election Name" onfocus="focusElectionName();" onblur="blurElectionName();" id="electionname" name="election_name" class="form_field" style="display: block; margin-bottom: 20px;" />
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
