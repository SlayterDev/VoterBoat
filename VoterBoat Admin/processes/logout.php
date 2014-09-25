<?php
    session_start();
    unset($_SESSION['logged_in']);
    unset($_SESSION['user_id']);
    header("Location: ../index.php");
?>