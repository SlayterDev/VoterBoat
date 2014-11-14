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
    <meta http-equiv="refresh" content="20;URL='<?php echo $_SERVER['PHP_SELF'].'?id='.$id; ?>'">
</head>
<body>
    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <div id="header">
        <a href="home.php"><input type="button" class="form_btn" style="height: 30px; width: 100px; margin-left: 10px; background-color: #3498db;" value="Menu" /></a>
        <a href="../processes/logout.php"><input type="button" class="form_btn" style="height: 30px; width: 100px; margin-left: 10px; background-color: #e74c3c;" value="Log Out" /></a>
    </div>
    <div id="container">
        <center>
            <?php
    $id = mysql_escape_string($_GET['id']);
    $getTotalVoteCount = mysql_query("SELECT * FROM votes WHERE election_id='".$id."'");
    $totalVoteCount = mysql_num_rows($getTotalVoteCount);
?>
            <script type="text/javascript">
                function flipCoin() {
                    var x = document.getElementById("coin")
                    var y = Math.floor((Math.random() * 2) + 0);
                    if (y == 0) {
                        x.innerHTML = "Candidate 1 Wins";
                    }
                    else {
                        x.innerHTML = "Candidate 2 Wins";
                    }
                }
            </script>
            <span style="display: block; margin-top: 20px; font-size: 18pt; margin-bottom: 30px;">Election Results (<?php echo $totalVoteCount; ?> <?php if ($totalVoteCount == 1) {echo 'Vote';}else{echo 'Votes';} ?>)</span>
            <input type="button" class="form_btn" onclick="flipCoin();" value="Flip a Coin" style="margin-bottom: 10px;" />
            <p id="coin" style="margin-bottom: 20px; font-weight: bold;">
            </p>
            <table style="width: 580px;" cellpadding="1" cellspacing="0" bgcolor="#F5F5F5" border="1" bordercolor="#E5E5E5">
                <tr style="border: 1px solid #E5E5E5;">
                    <th style="padding-top: 10px; padding-bottom: 10px;">User Name</th>
                    <th style="padding-top: 10px; padding-bottom: 10px;">Total Votes</th>
                    <th style="padding-top: 10px; padding-bottom: 10px;">Percentage</th>
                    <th style="padding-top: 10px; padding-bottom: 10px;">Male</th>
                    <th style="padding-top: 10px; padding-bottom: 10px;">Female</th>
                </tr>
                <?php
                    $getCandidates = mysql_query("SELECT * FROM candidates WHERE election_id='".$id."' AND status='Approved'");
                    // iterate through candidates
                    while ($results = mysql_fetch_array($getCandidates))
                    {
                        // clear variables
                        $maleCount = 0;
                        $femaleCount = 0;
                        $college1 = 0;
                        $college2 = 0;
                        $college3 = 0;
                        $college4 = 0;
                        $college5 = 0;
                        $college6 = 0;
                        $college7 = 0;
                        $college8 = 0;
                        $college9 = 0;
                        $college10 = 0;
                        $college11 = 0;
                        $college12 = 0;
                        $college13 = 0;
                        
                        // get vote counts
                        $getUserInfo = mysql_query("SELECT * FROM users WHERE user_id='".$results['user_id']."'");
                        $userInfo = mysql_fetch_array($getUserInfo);
                        $getVoteCount = mysql_query("SELECT * FROM votes WHERE election_id='".$id."' AND candidate_id='".$results['candidate_id']."' AND type='Standard'");
                        $voteCount = mysql_num_rows($getVoteCount);
                        $getTotalVoteCount = mysql_query("SELECT * FROM votes WHERE election_id='".$id."'");
                        $totalVoteCount = mysql_num_rows($getTotalVoteCount);
                        while ($demographics = mysql_fetch_array($getVoteCount))
                        {
                            // get gender vote counts
                            $getUserInfo1 = mysql_query("SELECT * FROM users WHERE user_id='".$demographics['user_id']."' AND gender='Male'");
                            $maleCount += mysql_num_rows($getUserInfo1);
                            $getUserInfo2 = mysql_query("SELECT * FROM users WHERE user_id='".$demographics['user_id']."' AND gender='Female'");
                            $femaleCount += mysql_num_rows($getUserInfo2);
                            
                            // get specific college vote counts
                            $getCollege1 = mysql_query("SELECT * FROM users WHERE user_id='".$demographics['user_id']."' AND college='College of Arts and Science'");
                            $college1 += mysql_num_rows($getCollege1);
                            $getCollege2 = mysql_query("SELECT * FROM users WHERE user_id='".$demographics['user_id']."' AND college='College of Business'");
                            $college2 += mysql_num_rows($getCollege2);
                            $getCollege3 = mysql_query("SELECT * FROM users WHERE user_id='".$demographics['user_id']."' AND college='College of Education'");
                            $college3 += mysql_num_rows($getCollege3);
                            $getCollege4 = mysql_query("SELECT * FROM users WHERE user_id='".$demographics['user_id']."' AND college='College of Engineering'");
                            $college4 += mysql_num_rows($getCollege4);
                            $getCollege5 = mysql_query("SELECT * FROM users WHERE user_id='".$demographics['user_id']."' AND college='College of Information'");
                            $college5 += mysql_num_rows($getCollege5);
                            $getCollege6 = mysql_query("SELECT * FROM users WHERE user_id='".$demographics['user_id']."' AND college='College of Merchandising'");
                            $college6 += mysql_num_rows($getCollege6);
                            $getCollege7 = mysql_query("SELECT * FROM users WHERE user_id='".$demographics['user_id']."' AND college='College of Music'");
                            $college7 += mysql_num_rows($getCollege7);
                            $getCollege8 = mysql_query("SELECT * FROM users WHERE user_id='".$demographics['user_id']."' AND college='College of Public Affairs'");
                            $college8 += mysql_num_rows($getCollege8);
                            $getCollege9 = mysql_query("SELECT * FROM users WHERE user_id='".$demographics['user_id']."' AND college='College of Visual Arts'");
                            $college9 += mysql_num_rows($getCollege9);
                            $getCollege10 = mysql_query("SELECT * FROM users WHERE user_id='".$demographics['user_id']."' AND college='School of Journalism'");
                            $college10 += mysql_num_rows($getCollege10);
                            $getCollege11 = mysql_query("SELECT * FROM users WHERE user_id='".$demographics['user_id']."' AND college='Honors College'");
                            $college11 += mysql_num_rows($getCollege11);
                            $getCollege12 = mysql_query("SELECT * FROM users WHERE user_id='".$demographics['user_id']."' AND college='TAMS'");
                            $college12 += mysql_num_rows($getCollege12);
                            $getCollege13 = mysql_query("SELECT * FROM users WHERE user_id='".$demographics['user_id']."' AND college='Toulouse Graduate School'");
                            $college13 += mysql_num_rows($getCollege13);
                        }
                        
                        // calculate percentages
                        $percentage = ((int)$voteCount / (int)$totalVoteCount) * 100;
                        $malepercentage = ((int)$maleCount / (int)$totalVoteCount) * 100;
                        $femalepercentage = ((int)$femaleCount / (int)$totalVoteCount) * 100;
                        
                        // create javascript api call to generate pie chart
                        echo '<script type="text/javascript">

                        // Load the Visualization API and the piechart package.
                        google.load(\'visualization\', \'1.0\', {\'packages\':[\'corechart\']});
                  
                        // Set a callback to run when the Google Visualization API is loaded.
                        google.setOnLoadCallback(drawChart);
                  
                        // Callback that creates and populates a data table,
                        // instantiates the pie chart, passes in the data and
                        // draws it.
                        function drawChart() {
                  
                          // Create the data table.
                          var data = new google.visualization.DataTable();
                          data.addColumn(\'string\', \'Gender\');
                          data.addColumn(\'number\', \'Votes\');
                          data.addRows([
                            [\'Males\', '.$maleCount.'],
                            [\'Females\', '.$femaleCount.'],
                          ]);
                  
                          // Set chart options
                          var options = {
                                         \'width\':300,
                                         \'height\':300,
                                         \'backgroundColor\':\'#F5F5F5\',
                                         \'legend\':{\'position\':\'bottom\'}};
                  
                          // Instantiate and draw our chart, passing in some options.
                          var chart = new google.visualization.PieChart(document.getElementById(\'chart_div_'.$results['user_id'].'\'));
                          chart.draw(data, options);
                        }
                      </script>';
                      
                      // create javascript api call to generate pie chart
                      echo '<script type="text/javascript">

                        // Load the Visualization API and the piechart package.
                        google.load(\'visualization\', \'1.0\', {\'packages\':[\'corechart\']});
                  
                        // Set a callback to run when the Google Visualization API is loaded.
                        google.setOnLoadCallback(drawChart);
                  
                        // Callback that creates and populates a data table,
                        // instantiates the pie chart, passes in the data and
                        // draws it.
                        function drawChart() {
                  
                          // Create the data table.
                          var data = new google.visualization.DataTable();
                          data.addColumn(\'string\', \'College\');
                          data.addColumn(\'number\', \'Votes\');
                          data.addRows([
                            [\'College of Arts and Science\', '.$college1.'],
                            [\'College of Business\', '.$college2.'],
                            [\'College of Education\', '.$college3.'],
                            [\'College of Engineering\', '.$college4.'],
                            [\'College of Information\', '.$college5.'],
                            [\'College of Merchandising\', '.$college6.'],
                            [\'College of Music\', '.$college7.'],
                            [\'College of Public Affairs\', '.$college8.'],
                            [\'College of Visual Arts\', '.$college9.'],
                            [\'School of Journalism\', '.$college10.'],
                            [\'Honors College\', '.$college11.'],
                            [\'TAMS\', '.$college12.'],
                            [\'Toulouse Graduate School\', '.$college13.'],
                          ]);
                  
                          // Set chart options
                          var options = {
                                         \'width\':300,
                                         \'height\':300,
                                         \'backgroundColor\':\'#F5F5F5\',
                                         \'legend\':{\'position\':\'bottom\'}};
                  
                          // Instantiate and draw our chart, passing in some options.
                          var chart = new google.visualization.PieChart(document.getElementById(\'college_chart_div_'.$results['user_id'].'\'));
                          chart.draw(data, options);
                        }
                      </script>';
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
                                    <td align="center">
                                        '.strval(floor($malepercentage)).'% 
                                    </td>
                                    <td align="center">
                                        '.strval(floor($femalepercentage)).'% 
                                    </td>
                                </tr>';
                    }
                    $getWriteCandidates = mysql_query("SELECT * FROM write_in_candidates WHERE election_id='".$id."'");
                    // iterate through candidates
                    while ($results = mysql_fetch_array($getWriteCandidates))
                    {
                        // clear variables
                        $maleCount = 0;
                        $femaleCount = 0;
                        $college1 = 0;
                        $college2 = 0;
                        $college3 = 0;
                        $college4 = 0;
                        $college5 = 0;
                        $college6 = 0;
                        $college7 = 0;
                        $college8 = 0;
                        $college9 = 0;
                        $college10 = 0;
                        $college11 = 0;
                        $college12 = 0;
                        $college13 = 0;
                        
                        // get vote counts
                        $getVoteCount = mysql_query("SELECT * FROM votes WHERE election_id='".$id."' AND candidate_id='".$results['candidate_id']."' AND type='Written'");
                        $voteCount = mysql_num_rows($getVoteCount);
                        $getTotalVoteCount = mysql_query("SELECT * FROM votes WHERE election_id='".$id."'");
                        $totalVoteCount = mysql_num_rows($getTotalVoteCount);
                        while ($demographics = mysql_fetch_array($getVoteCount))
                        {
                            // get gender vote counts
                            $getUserInfo1 = mysql_query("SELECT * FROM users WHERE user_id='".$demographics['user_id']."' AND gender='Male'");
                            $maleCount += mysql_num_rows($getUserInfo1);
                            $getUserInfo2 = mysql_query("SELECT * FROM users WHERE user_id='".$demographics['user_id']."' AND gender='Female'");
                            $femaleCount += mysql_num_rows($getUserInfo2);
                            
                            // get specific college vote counts
                            $getCollege1 = mysql_query("SELECT * FROM users WHERE user_id='".$demographics['user_id']."' AND college='College of Arts and Science'");
                            $college1 += mysql_num_rows($getCollege1);
                            $getCollege2 = mysql_query("SELECT * FROM users WHERE user_id='".$demographics['user_id']."' AND college='College of Business'");
                            $college2 += mysql_num_rows($getCollege2);
                            $getCollege3 = mysql_query("SELECT * FROM users WHERE user_id='".$demographics['user_id']."' AND college='College of Education'");
                            $college3 += mysql_num_rows($getCollege3);
                            $getCollege4 = mysql_query("SELECT * FROM users WHERE user_id='".$demographics['user_id']."' AND college='College of Engineering'");
                            $college4 += mysql_num_rows($getCollege4);
                            $getCollege5 = mysql_query("SELECT * FROM users WHERE user_id='".$demographics['user_id']."' AND college='College of Information'");
                            $college5 += mysql_num_rows($getCollege5);
                            $getCollege6 = mysql_query("SELECT * FROM users WHERE user_id='".$demographics['user_id']."' AND college='College of Merchandising'");
                            $college6 += mysql_num_rows($getCollege6);
                            $getCollege7 = mysql_query("SELECT * FROM users WHERE user_id='".$demographics['user_id']."' AND college='College of Music'");
                            $college7 += mysql_num_rows($getCollege7);
                            $getCollege8 = mysql_query("SELECT * FROM users WHERE user_id='".$demographics['user_id']."' AND college='College of Public Affairs'");
                            $college8 += mysql_num_rows($getCollege8);
                            $getCollege9 = mysql_query("SELECT * FROM users WHERE user_id='".$demographics['user_id']."' AND college='College of Visual Arts'");
                            $college9 += mysql_num_rows($getCollege9);
                            $getCollege10 = mysql_query("SELECT * FROM users WHERE user_id='".$demographics['user_id']."' AND college='School of Journalism'");
                            $college10 += mysql_num_rows($getCollege10);
                            $getCollege11 = mysql_query("SELECT * FROM users WHERE user_id='".$demographics['user_id']."' AND college='Honors College'");
                            $college11 += mysql_num_rows($getCollege11);
                            $getCollege12 = mysql_query("SELECT * FROM users WHERE user_id='".$demographics['user_id']."' AND college='TAMS'");
                            $college12 += mysql_num_rows($getCollege12);
                            $getCollege13 = mysql_query("SELECT * FROM users WHERE user_id='".$demographics['user_id']."' AND college='Toulouse Graduate School'");
                            $college13 += mysql_num_rows($getCollege13);
                        }
                        
                        // calculate percentages
                        $percentage = ((int)$voteCount / (int)$totalVoteCount) * 100;
                        $malepercentage = ((int)$maleCount / (int)$totalVoteCount) * 100;
                        $femalepercentage = ((int)$femaleCount / (int)$totalVoteCount) * 100;
                        
                        // create javascript api call to generate pie chart
                        echo '<script type="text/javascript">

                        // Load the Visualization API and the piechart package.
                        google.load(\'visualization\', \'1.0\', {\'packages\':[\'corechart\']});
                  
                        // Set a callback to run when the Google Visualization API is loaded.
                        google.setOnLoadCallback(drawChart);
                  
                        // Callback that creates and populates a data table,
                        // instantiates the pie chart, passes in the data and
                        // draws it.
                        function drawChart() {
                  
                          // Create the data table.
                          var data = new google.visualization.DataTable();
                          data.addColumn(\'string\', \'Gender\');
                          data.addColumn(\'number\', \'Votes\');
                          data.addRows([
                            [\'Males\', '.$maleCount.'],
                            [\'Females\', '.$femaleCount.'],
                          ]);
                  
                          // Set chart options
                          var options = {
                                         \'width\':300,
                                         \'height\':300,
                                         \'backgroundColor\':\'#F5F5F5\',
                                         \'legend\':{\'position\':\'bottom\'}};
                  
                          // Instantiate and draw our chart, passing in some options.
                          var chart = new google.visualization.PieChart(document.getElementById(\'chart_div2_'.$results['user_id'].'\'));
                          chart.draw(data, options);
                        }
                      </script>';
                      
                      // create javascript api call to generate pie chart
                      echo '<script type="text/javascript">

                        // Load the Visualization API and the piechart package.
                        google.load(\'visualization\', \'1.0\', {\'packages\':[\'corechart\']});
                  
                        // Set a callback to run when the Google Visualization API is loaded.
                        google.setOnLoadCallback(drawChart);
                  
                        // Callback that creates and populates a data table,
                        // instantiates the pie chart, passes in the data and
                        // draws it.
                        function drawChart() {
                  
                          // Create the data table.
                          var data = new google.visualization.DataTable();
                          data.addColumn(\'string\', \'College\');
                          data.addColumn(\'number\', \'Votes\');
                          data.addRows([
                            [\'College of Arts and Science\', '.$college1.'],
                            [\'College of Business\', '.$college2.'],
                            [\'College of Education\', '.$college3.'],
                            [\'College of Engineering\', '.$college4.'],
                            [\'College of Information\', '.$college5.'],
                            [\'College of Merchandising\', '.$college6.'],
                            [\'College of Music\', '.$college7.'],
                            [\'College of Public Affairs\', '.$college8.'],
                            [\'College of Visual Arts\', '.$college9.'],
                            [\'School of Journalism\', '.$college10.'],
                            [\'Honors College\', '.$college11.'],
                            [\'TAMS\', '.$college12.'],
                            [\'Toulouse Graduate School\', '.$college13.'],
                          ]);
                  
                          // Set chart options
                          var options = {
                                         \'width\':300,
                                         \'height\':300,
                                         \'backgroundColor\':\'#F5F5F5\',
                                         \'legend\':{\'position\':\'bottom\'}};
                  
                          // Instantiate and draw our chart, passing in some options.
                          var chart = new google.visualization.PieChart(document.getElementById(\'college_chart_div2_'.$results['user_id'].'\'));
                          chart.draw(data, options);
                        }
                      </script>';
                        echo    '<tr>
                                    <td style="height: 50px;" align="center">
                                        '.$results['name'].'
                                    </td>
                                    <td align="center">
                                        '.$voteCount.' 
                                    </td>
                                    <td align="center">
                                        '.strval(floor($percentage)).'% 
                                    </td>
                                    <td align="center">
                                        '.strval(floor($malepercentage)).'% 
                                    </td>
                                    <td align="center">
                                        '.strval(floor($femalepercentage)).'% 
                                    </td>
                                </tr>';
                    }
                    if (mysql_num_rows($getCandidates) == 0 && mysql_num_rows($getWriteCandidates) == 0)
                    {
                        echo '<tr>
                                <td align="center" colspan="5" style="height: 50px;">
                                    No Candidates Found
                                </td>
                              </tr>';
                    }
                ?>
            </table>
                    <?php
                        $getCandidates = mysql_query("SELECT * FROM candidates WHERE election_id='".$id."'");
                        
                        // iterate through candidates and display pie charts
                        while ($results = mysql_fetch_array($getCandidates))
                        {
                            $getVoteCount = mysql_query("SELECT * FROM votes WHERE election_id='".$id."' AND candidate_id='".$results['candidate_id']."' AND type='Standard'");
                            $voteCount = mysql_num_rows($getVoteCount);
                            if ($voteCount > 0)
                            {
                                echo '<br/>
                            <table style="width: 580px;" cellpadding="1" cellspacing="0" bgcolor="#F5F5F5" border="1" bordercolor="#E5E5E5">';
                            $getUserInfo = mysql_query("SELECT * FROM users WHERE user_id='".$results['user_id']."'");
                            $userInfo = mysql_fetch_array($getUserInfo);
                            echo    '<tr>
                                    <td style="height: 50px;" align="center">
                                        <a name="#'.$results['user_id'].'" />
                                        <span style="font-weight: bold; display: block; margin-top: 20px;">'.$userInfo['user_name'].'</span>
                                        <span style="display: block; color: #3498db; margin-top: 30px;">Gender Distribution</span>
                                        <div id="chart_div_'.$results['user_id'].'">
                                        </div>
                                        <span style="display: block; color: #3498db; margin-top: 30px;">College Distribution</span>
                                        <div id="college_chart_div_'.$results['user_id'].'">
                                        </div>
                                    </td>
                                </tr>
                                </table>';
                            }
                            else
                            {
                                echo '<br/>
                                <table style="width: 580px;" cellpadding="1" cellspacing="0" bgcolor="#F5F5F5" border="1" bordercolor="#E5E5E5">';
                            $getUserInfo = mysql_query("SELECT * FROM users WHERE user_id='".$results['user_id']."'");
                            $userInfo = mysql_fetch_array($getUserInfo);
                            echo    '<tr>
                                    <td style="height: 50px;" align="center">
                                        <a name="#'.$results['user_id'].'" />
                                        <span style="font-weight: bold; display: block; margin-top: 20px;">'.$userInfo['user_name'].'</span>
                                        <span style="display: block; color: #3498db; margin-top: 30px;">No Votes</span>
                                        <br/>
                                    </td>
                                </tr>
                                </table>';
                            }
                        }
                    ?>
            <?php
                        $getCandidates = mysql_query("SELECT * FROM write_in_candidates WHERE election_id='".$id."'");
                        
                        // iterate through candidates and display pie charts
                        while ($results = mysql_fetch_array($getCandidates))
                        {
                            $getVoteCount = mysql_query("SELECT * FROM votes WHERE election_id='".$id."' AND candidate_id='".$results['candidate_id']."' AND type='Written'");
                            $voteCount = mysql_num_rows($getVoteCount);
                            if ($voteCount > 0)
                            {
                                echo '<br/>
                            <table style="width: 580px;" cellpadding="1" cellspacing="0" bgcolor="#F5F5F5" border="1" bordercolor="#E5E5E5">';
                            echo    '<tr>
                                    <td style="height: 50px;" align="center">
                                        <a name="#'.$results['user_id'].'" />
                                        <span style="font-weight: bold; display: block; margin-top: 20px;">'.$results['name'].'</span>
                                        <span style="display: block; color: #3498db; margin-top: 30px;">Gender Distribution</span>
                                        <div id="chart_div2_'.$results['user_id'].'">
                                        </div>
                                        <span style="display: block; color: #3498db; margin-top: 30px;">College Distribution</span>
                                        <div id="college_chart_div2_'.$results['user_id'].'">
                                        </div>
                                    </td>
                                </tr>
                                </table>';
                            }
                            else
                            {
                                echo '<br/>
                                <table style="width: 580px;" cellpadding="1" cellspacing="0" bgcolor="#F5F5F5" border="1" bordercolor="#E5E5E5">';
                            echo    '<tr>
                                    <td style="height: 50px;" align="center">
                                        <a name="#'.$results['user_id'].'" />
                                        <span style="font-weight: bold; display: block; margin-top: 20px;">'.$results['name'].'</span>
                                        <span style="display: block; color: #3498db; margin-top: 30px;">No Votes</span>
                                        <br/>
                                    </td>
                                </tr>
                                </table>';
                            }
                        }
                    ?>
            </table>
        </center>
    </div>
</body>
</html>
