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
        $user_id = mysql_escape_string($_POST['user_id']);
        $removeAdmin = mysql_query("DELETE FROM users WHERE user_id='".$user_id."'");
    }
    
    if (isset($_POST['approve']))
    {
        $user_id = mysql_escape_string($_POST['user_id']);
        $accept = mysql_query("UPDATE users SET status='Approved' WHERE user_id='".$user_id."'");
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
            <span style="display: block; margin-top: 20px; font-size: 18pt; margin-bottom: 30px;">Manage Pending Students
            </span>
            <table style="width: 580px;" cellpadding="1" cellspacing="0" bgcolor="#F5F5F5" border="1" bordercolor="#E5E5E5">
                <tr style="border: 1px solid #E5E5E5;">
                    <th style="padding-top: 10px; padding-bottom: 10px;">User Name</th>
                    <th style="padding-top: 10px; padding-bottom: 10px;">Actions</th>
                </tr>
                <?php
                    $getAdmins = mysql_query("SELECT * FROM users WHERE permissions='Student' AND status='Pending'");
                    while ($results = mysql_fetch_array($getAdmins))
                    {
                        echo    '<tr>
                                    <td style="height: 50px;" align="center">
                                        '.$results['user_name'].'
                                    </td>
                                    <td align="center">
                                        <form method="POST" action="" style="display: inline;" onsubmit="return confirm(\'Are you sure you want to approve this student?\')">
                                            <input type="submit" name="approve" class="form_btn" value="Approve" style="width: 80px; height: 30px; font-size: 12pt; background-color: #2ecc71;" />
                                            <input type="hidden" value="'.$results['user_id'].'" name="user_id" />
                                        </form>
                                        <form method="POST" action="" style="display: inline;" onsubmit="return confirm(\'Are you sure you want to deny this student?\')">
                                            <input type="submit" name="submit" class="form_btn" value="Deny" style="width: 80px; height: 30px; font-size: 12pt; background-color: #e74c3c;" />
                                            <input type="hidden" value="'.$results['user_id'].'" name="user_id" />
                                        </form>
                                    </td>
                                </tr>';
                    }
                    if (mysql_num_rows($getAdmins) == 0)
                    {
                        echo '<tr>
                                <td align="center" colspan="2" style="height: 50px;">
                                    No Students Found
                                </td>
                              </tr>';
                    }
                ?>
            </table>
        </center>
    </div>
</body>
</html>
