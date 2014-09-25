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
    
    if (isset($_GET['id']))
    {
        $election_id = mysql_escape_string($_GET['id']);
    }

    if (isset($_POST['remove']))
    {
        $user_id = mysql_escape_string($_POST['user_id']);
        $denyUser = mysql_query("DELETE FROM candidates WHERE user_id='".$user_id."' AND election_id='".$election_id."'");
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
    <div id="container">
        <center>
            <span style="display: block; margin-top: 20px; font-size: 18pt; margin-bottom: 30px;">Manage Candidates</span>
            <a href="add_candidate.php?id=<?php echo $election_id; ?>"><input type="button" class="form_btn" value="Add Candidate" style="margin-bottom: 30px;" /></a>
            <table style="width: 580px;" cellpadding="1" cellspacing="0" bgcolor="#F5F5F5" border="1" bordercolor="#E5E5E5">
                <tr style="border: 1px solid #E5E5E5;">
                    <th style="padding-top: 10px; padding-bottom: 10px;">User Name</th>
                    <th style="padding-top: 10px; padding-bottom: 10px;">Actions</th>
                </tr>
                <?php
                    $getCandidates = mysql_query("SELECT * FROM candidates WHERE election_id='".$election_id."'");
                    while ($results = mysql_fetch_array($getCandidates))
                    {
                        $getUserInfo = mysql_query("SELECT * FROM users WHERE user_id='".$results['user_id']."'");
                        $userInfo = mysql_fetch_array($getUserInfo);
                        echo    '<tr>
                                    <td style="height: 50px;" align="center">
                                        '.$userInfo['user_name'].'
                                    </td>
                                    <td align="center">
                                        <form method="POST" action="" style="display: inline;" onsubmit="return confirm(\'Are you sure you want to remove this candidate?\')">
                                            <input type="submit" name="remove" class="form_btn" value="Remove" style="width: 80px; height: 30px; font-size: 12pt; background-color: #e74c3c;" />
                                            <input type="hidden" value="'.$userInfo['user_id'].'" name="user_id" />
                                            <input type="hidden" value="'.$election_id.'" name="election_id" />
                                        </form>
                                    </td>
                                </tr>';
                    }
                    if (mysql_num_rows($getCandidates) == 0)
                    {
                        echo '<tr>
                                <td align="center" colspan="2" style="height: 50px;">
                                    No Candidates Found
                                </td>
                              </tr>';
                    }
                ?>
            </table>
        </center>
    </div>
</body>
</html>
