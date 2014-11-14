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
    
    if (isset($_POST['submit']))
    {
        $student_id = mysql_escape_string($_POST['student_id']);
        $election_id = mysql_escape_string($_POST['election_id']);
        
        if (empty($student_id) || $student_id == "Student ID")
        {
            header("Location: add_candidate.php?id=".$election_id."&error=1");
        }
        else
        {
            $checkValidUser = mysql_query("SELECT user_id FROM users WHERE student_id='".$student_id."' LIMIT 1");
            $results = mysql_fetch_array($checkValidUser);
            
            if (mysql_num_rows($checkValidUser) > 0)
            {
                $addCandidate = mysql_query("INSERT INTO candidates (user_id, election_id) VALUES ('".$results['user_id']."', $election_id)");
                header("Location: manage_candidates.php?id=".$election_id."");
            }
            else
            {
                header("Location: add_candidate.php?id=".$election_id."&error=2");
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
    <script src=".../javascript/jquery2.js"></script>
    <script src="../javascript/main.js"></script>
</head>
<body>
    <script type="text/javascript">
        function focusStudentID()
        {
            if (document.getElementById("studentID").value == "Student ID")
            {
                document.getElementById("studentID").value = "";
            }
        }
        
        function blurStudentID()
        {
            if (document.getElementById("studentID").value == "")
            {
                document.getElementById("studentID").value = "Student ID";
            }
        }
    </script>
    <div id="header">
        <center><a href="home.php"><span>VoterBoat</span></a></center>
    </div>
    <div id="form">
        <center>
            <span style="display: block; margin-top: 20px; font-size: 18pt; margin-bottom: 30px;">Add Candidate</span>
            <form method="POST" action="">
                <input type="text" value="Student ID" onfocus="focusStudentID();" onblur="blurStudentID();" id="studentID" name="student_id" class="form_field" style="display: block; margin-bottom: 20px;" />
                <input type="hidden" value="<?php echo $election_id; ?>" name="election_id" />
                <input type="submit" name="submit" value="Submit" class="form_btn" style="display: block; margin-bottom: 20px; width: 140px;" />
                <?php
                    if (isset($_GET['error']))
                    {
                        if ($_GET['error'] == '1')
                            $message = "Please enter a valid student ID.";
                        else if ($_GET['error'] == '2')
                            $message = "A student with that ID does not exist.";
                        echo '<span style="color: #e74c3c; display: block; margin-top: 10px; margin-bottom: 5px;">'.$message.'</span>';
                    }
                ?>
            </form>
        </center>
    </div>
</body>
</html>
