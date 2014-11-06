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
    
    $id = mysql_escape_string($_GET['id']);
    
    if (isset($_POST['submit']))
    {
        $election_id = mysql_escape_string($_POST['election_id']);
        $removeAdmin = mysql_query("DELETE FROM elections WHERE election_id='".$election_id."'");
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
            <?php
                $getTotalVoteCount = mysql_query("SELECT * FROM votes WHERE election_id='".$id."'");
                $totalVoteCount = mysql_num_rows($getTotalVoteCount);
            ?>
            <span style="display: block; margin-top: 20px; font-size: 18pt; margin-bottom: 30px;">Election Results (<?php echo $totalVoteCount; ?> <?php if ($totalVoteCount == 1) {echo 'Vote';}else{echo 'Votes';} ?>)</span>
            <table style="width: 580px;" cellpadding="1" cellspacing="0" bgcolor="#F5F5F5" border="1" bordercolor="#E5E5E5">
                <tr style="border: 1px solid #E5E5E5;">
                    <th style="padding-top: 10px; padding-bottom: 10px;">User Name</th>
                    <th style="padding-top: 10px; padding-bottom: 10px;">Total Votes</th>
                    <th style="padding-top: 10px; padding-bottom: 10px;">Percentage</th>
                </tr>
                <?php
                    $getCandidates = mysql_query("SELECT * FROM candidates WHERE election_id='".$id."'");
                    while ($results = mysql_fetch_array($getCandidates))
                    {
                        $getUserInfo = mysql_query("SELECT * FROM users WHERE user_id='".$results['user_id']."'");
                        $userInfo = mysql_fetch_array($getUserInfo);
                        $getVoteCount = mysql_query("SELECT * FROM votes WHERE election_id='".$id."' AND candidate_id='".$results['user_id']."'");
                        $voteCount = mysql_num_rows($getVoteCount);
                        $getTotalVoteCount = mysql_query("SELECT * FROM votes WHERE election_id='".$id."'");
                        $totalVoteCount = mysql_num_rows($getTotalVoteCount);
                        $percentage = ((int)$voteCount / (int)$totalVoteCount) * 100;
                        echo    '<tr>
                                    <td style="height: 50px;" align="center">
                                        '.$userInfo['user_name'].'
                                    </td>
                                    <td align="center">
                                        '.$voteCount.' 
                                    </td>
                                    <td align="center">
                                        '.strval(floor($percentage)).'% 
                                    </td>
                                </tr>';
                    }
                    if (mysql_num_rows($getCandidates) == 0)
                    {
                        echo '<tr>
                                <td align="center" colspan="3" style="height: 50px;">
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
