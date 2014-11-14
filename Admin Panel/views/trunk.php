<?php
    include '../config/dbconnect.php';
    $deleteVotes = mysql_query("TRUNCATE TABLE votes");
?>