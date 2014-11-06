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
        $isAdmin = false;
    else
        $isAdmin = true;
    
    if (isset($_POST['submit']))
    {
        $election_id = mysql_escape_string($_POST['election_id']);
        $removeAdmin = mysql_query("DELETE FROM elections WHERE election_id='".$election_id."'");
    }
    
    if (isset($_POST['open']))
    {
        $election_id = mysql_escape_string($_POST['election_id']);
        $openElection = mysql_query("UPDATE elections SET open='T' WHERE election_id='".$election_id."'");
    }
    
    if (isset($_POST['close']))
    {
        $election_id = mysql_escape_string($_POST['election_id']);
        $closeElection = mysql_query("UPDATE elections SET open='F' WHERE election_id='".$election_id."'");
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
            <span style="display: block; margin-top: 20px; font-size: 18pt; margin-bottom: 30px;">Manage Elections</span>
            <table style="width: 700px;" cellpadding="1" cellspacing="0" bgcolor="#F5F5F5" border="1" bordercolor="#E5E5E5">
                <tr style="border: 1px solid #E5E5E5;">
                    <th style="padding-top: 10px; padding-bottom: 10px;">User Name</th>
                    <th style="padding-top: 10px; padding-bottom: 10px;">Actions</th>
                </tr>
                <?php
                    $getElections = mysql_query("SELECT * FROM elections");
                    while ($results = mysql_fetch_array($getElections))
                    {
                        echo    '<tr>
                                    <td style="height: 50px;" align="center">
                                        '.$results['name'].'
                                    </td>
                                    <td align="center">';
                                    
                                        if ($isAdmin)
                                        {
                                        echo '<a href="manage_candidates.php?id='.$results['election_id'].'"><input type="button" class="form_btn" value="Candidates" style="width: 90px; height: 30px; font-size: 12pt; background-color: #3498db;" /></a>';
                                            if ($results['open'] == 'F')
                                            echo '
                                            <form method="POST" action="" style="display: inline;" onsubmit="return confirm(\'Are you sure you want to open this election?\')">
                                                    <input type="submit" name="open" class="form_btn" value="Open" style="width: 90px; height: 30px; font-size: 12pt;" />
                                                    <input type="hidden" value="'.$results['election_id'].'" name="election_id" />
                                            </form>';
                                        else
                                            echo '
                                            <form method="POST" action="" style="display: inline;" onsubmit="return confirm(\'Are you sure you want to close this election?\')">
                                                    <input type="submit" name="close" class="form_btn" value="Close" style="width: 90px; height: 30px; font-size: 12pt; background-color: #e74c3c;" />
                                                    <input type="hidden" value="'.$results['election_id'].'" name="election_id" />
                                            </form>';
                                        
                            
                                        
                                        echo '<form method="POST" action="" style="display: inline;" onsubmit="return confirm(\'Are you sure you want to delete this election?\')">
                                            <input type="submit" name="submit" class="form_btn" value="Delete" style="width: 90px; height: 30px; font-size: 12pt; background-color: #e74c3c;" />
                                            <input type="hidden" value="'.$results['election_id'].'" name="election_id" />
                                        </form>';
                                        }
                                    echo '
                                    <a href="election_results.php?id='.$results['election_id'].'"><input type="button" class="form_btn" value="Results" style="width: 80px; height: 30px; font-size: 12pt; background-color: #3498db;" /></a>
                                    </td>
                                </tr>';
                    }
                    if (mysql_num_rows($getElections) == 0)
                    {
                        echo '<tr>
                                <td align="center" colspan="2" style="height: 50px;">
                                    No Elections Found
                                </td>
                              </tr>';
                    }
                ?>
            </table>
        </center>
    </div>
</body>
</html>
