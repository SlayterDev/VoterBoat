<?php

    // Voterboat Configuration File
    
    // Increase Memory Limit (Photo Uploads)
    ini_set("memory_limit", "1024M");
    
    // Connect to Database
    mysql_connect("bitzyserver.cmmxja26v5cc.us-west-2.rds.amazonaws.com", "jstauffer94", "J\$tauf34") OR DIE ("Unable to connect to database! Please try again later.");
    mysql_select_db("voterboat");
    
    // Handle Errors
    function display_error($err_code)
    {
        switch ($err_code)
        {
            case 1:
                $message = 'An invalid controller is being referenced.';
                break;
            case 2:
                $message = 'An invalid method is being referenced.';
                break;
            case 3:
                $message = 'The connection was unsuccessful.';
                break;
            case 100:
                $message = 'Provide a username.';
                break;
            case 101:
                $message = 'Provide a student ID.';
                break;
            case 102:
                $message = 'Provide a password.';
                break;
            case 103:
                $message = 'Provide a username that is less than 20 characters long.';
                break;
            case 104:
                $message = 'Provide a password that is between 5 and 20 characters in length';
                break;
            case 105:
                $message = 'This username is already taken.';
                break;
            case 106:
                $message = 'Your username/password is invalid. Please try again.';
                break;
            case 200:
                $message = 'Provide an election type.';
                break;
            case 201:
                $message = 'Provide a user ID.';
                break;
            case 202:
                $message = 'Provide an election ID.';
                break;
            case 203:
                $message = 'Provide a candidate ID.';
                break;
            case 204:
                $message = 'You have already voted in this election.';
                break;
        }
        
        $errorJSON = array("err_code" => $err_code, "err_msg" => $message);
        echo json_encode($errorJSON);
        
        exit(0);
    }
    
    // Show Success Message
    function display_success($data)
    {
        $successJSON = array("did_succeed" => true);
        if ($data)
            $successJSON = $successJSON + $data;
        echo json_encode($successJSON);
        exit(0);
    }
    
    
?>