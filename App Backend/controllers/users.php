<?php

    // Voterboat Users Endpoint
    
    class Users
    {
        private $_parameters;
        
        public function __construct($parameters)
        {
            $this->_parameters = $parameters;
        }
        
        // create account method
        public function create_account()
        {
            // retrieve local parameters
            $user_name = mysql_escape_string($this->_parameters['user_name']);
            $student_id = mysql_escape_string($this->_parameters['student_id']);
            $password = mysql_escape_string($this->_parameters['password']);
            $email = mysql_escape_string($this->_parameters['email']);
            $gender = mysql_escape_string($this->_parameters['gender']);
            $college = mysql_escape_string($this->_parameters['college']);
            
            if (empty($user_name))
                display_error(100);
            else if (empty($student_id))
                display_error(101);
            else if (empty($password))
                display_error(102);
            else if (strlen($user_name) > 20)
                display_error(103);
            else if (strlen($password) < 5 || strlen($password) > 20)
                display_error(104);
            
            // check username
            $checkUsername = mysql_query("SELECT user_id FROM users WHERE user_name='".$user_name."'");
            if (mysql_num_rows($checkUsername) > 0)
                display_error(105);
            
            // add student
            $addStudent = mysql_query("INSERT INTO users (student_id, user_name, password, email, gender, college) VALUES ('".$student_id."', '".$user_name."', '".sha1($password)."', '".$email."', '".$gender."', '".$college."')");
            $data = array("user_id" => mysql_insert_id());
            display_success($data);
        }
        
        // sign in method
        public function sign_in()
        {
            // retrieve local parameters
            $user_name = mysql_escape_string($this->_parameters['user_name']);
            $password = mysql_escape_string($this->_parameters['password']);
            
            if (empty($user_name))
                display_error(100);
            else if (empty($password))
                display_error(102);
            
            // check credentials
            $signIn = mysql_query("SELECT user_id FROM users WHERE user_name='".$user_name."' AND password='".sha1($password)."' AND status='Approved' LIMIT 1");
            $checkIfPending = mysql_query("SELECT user_id FROM users WHERE user_name='".$user_name."' AND password='".sha1($password)."' AND status='Pending' LIMIT 1");
            if (mysql_num_rows($checkIfPending) > 0)
                display_error(107);
            else if (mysql_num_rows($signIn) == 0)
                display_error(106);
            else
            {
                $userInfo = mysql_fetch_array($signIn);
                $data = array("user_id" => $userInfo['user_id']);
                display_success($data);
            }
        }
        
        // update bio
        public function update_bio()
        {
            // Retrieve Local Parameters
            $user_id = mysql_escape_string($_POST['user_id']);
            $bio = mysql_escape_string($_POST['bio']);
            $updateBio = mysql_query("UPDATE users SET bio='".$bio."' WHERE user_id='".$user_id."'");
            display_success();
        }
        
        // update profile photo
        public function update_profile_photo()
        {
            // Retrieve Local Parameters
            $user_id = mysql_escape_string($_POST['user_id']);
            if (is_uploaded_file($_FILES['file']['tmp_name']))
            {
                // Retrieve Photo
                $uploadDir = '/var/www/html/sweetspot/images/users/';
                $file = basename($_FILES['file']['name']);
                $filePath = $uploadDir.$user_id.'voterboat'.$file;
                
                $image = imagecreatefromjpeg($_FILES['file']['tmp_name']);
                $max_width = 120;
                $max_height = 120;
                $old_width = imagesx($image);
                $old_height = imagesy($image);
                
                $scale = min($max_width/$old_width, $max_height/$old_height);
                $new_width = ceil($scale*$old_width);
                $new_height = ceil($scale*$old_height);
                
                $new = imagecreatetruecolor($new_width, $new_height);
                imagecopyresampled($new, $image, 0, 0, 0, 0, $new_width, $new_height, $old_width, $old_height);
                imagejpeg($new, $_FILES['file']['tmp_name'], 90);
                move_uploaded_file($_FILES['file']['tmp_name'], $filePath) OR die("wahhh");
            }
        }
        
        // get user bio
        public function get_user_bio()
        {
            // Retrieve Local Parameters
            $user_id = mysql_escape_string($_POST['user_id']);
            $getbio = mysql_query("SELECT bio FROM users WHERE user_id='".$user_id."'");
            $results = mysql_fetch_array($getbio);
            $data = array("bio" => $results['bio']);
            display_success($data);
        }
        
        public function change()
        {
            $update = mysql_query("UPDATE elections SET open='U' WHERE election_id='1'");
            $update2 = mysql_query("UPDATE voters SET status='Accepted' WHERE user_id='1' AND election_id='1'");
        }
        
    }
    
?>