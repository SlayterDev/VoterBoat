<?php

    // Voterboat Elections Endpoint
    
    class Elections
    {
        private $_parameters;
        
        public function __construct($parameters)
        {
            $this->_parameters = $parameters;
        }
        
        // retrieve elections for specified type
        public function get_elections()
        {
            // get parameters
            $type = mysql_escape_string($this->_parameters['type']);
            $user_id = mysql_escape_string($this->_parameters['user_id']);
            
            // verify parameters
            if (empty($type))
                display_error(200);
            if (empty($user_id))
                display_error(201);
                
            // get elections
            $getElections = mysql_query("SELECT election_id, name, open FROM elections WHERE type='".$type."'");
            $tableData = array();
            while ($row = mysql_fetch_assoc($getElections))
            {
                $checkIfVoted = mysql_query("SELECT * FROM votes WHERE user_id='".$user_id."' AND election_id='".$row['election_id']."'");
                if (mysql_num_rows($checkIfVoted) > 0)
                    $voteInfo = array("did_vote" => true);
                else
                    $voteInfo = array("did_vote" => false);
                
                $checkIfRegistered = mysql_query("SELECT * FROM voters WHERE user_id='".$user_id."' AND election_id='".$row['election_id']."' AND status='Accepted'");
                $checkIfPending = mysql_query("SELECT * FROM voters WHERE user_id='".$user_id."' AND election_id='".$row['election_id']."' AND status='Pending'");
                if (mysql_num_rows($checkIfRegistered) > 0)
                    $registerInfo = array("is_registered" => 'T');
                else if (mysql_num_rows($checkIfPending) > 0)
                    $registerInfo = array("is_registered" => 'P');
                else
                    $registerInfo = array("is_registered" => 'F');
                
                $tableData[] = $row ***REMOVED*** $voteInfo ***REMOVED*** $registerInfo;
            }
            $data = array("data" => $tableData);
            display_success($data);
        }
        
        // retrieve election candidates
        public function get_candidates()
        {
            // get parameters
            $election_id = mysql_escape_string($this->_parameters['election_id']);
            $user_id = mysql_escape_string($this->_parameters['user_id']);
            
            // verify parameters
            if (empty($election_id))
                display_error(202);
            if (empty($user_id))
                display_error(201);
                
            // get candidates
            $getCandidates = mysql_query("SELECT user_id FROM candidates WHERE election_id='".$election_id."' AND status='Pending'");
            $tableData = array();
            while ($row = mysql_fetch_assoc($getCandidates))
            {
                // get user information
                $getUserInfo = mysql_query("SELECT user_name FROM users WHERE user_id='".$row['user_id']."'");
                $userInfo = mysql_fetch_array($getUserInfo);
                $userData = array("user_name" => $userInfo['user_name']);
                $tableData[] = $row ***REMOVED*** $userData;
            }
            $data = array("data" => $tableData);
            display_success($data);
        }
        
        // vote for candidate
        public function cast_vote()
        {
            // get parameters
            $election_id = mysql_escape_string($this->_parameters['election_id']);
            $user_id = mysql_escape_string($this->_parameters['user_id']);
            $candidate_id = mysql_escape_string($this->_parameters['candidate_id']);

            // verify parameters
            if (empty($election_id))
                display_error(202);
            if (empty($user_id))
                display_error(201);
            if (empty($candidate_id))
                display_error(203);
                
            // check if voted
            $checkVote = mysql_query("SELECT * FROM votes WHERE user_id='".$user_id."' AND election_id='".$election_id."'");
            if (mysql_num_rows($checkVote) > 0)
            {
                // update vote
                $updateVote = mysql_query("UPDATE votes SET candidate_id='".$candidate_id."' WHERE user_id='".$user_id."' AND election_id='".$election_id."'");   
                $data = array("msg" => "Your vote has been updated successfully!");
            }
            else
            {
                // create vote
                $vote = mysql_query("INSERT INTO votes (user_id, election_id, candidate_id) VALUES ('".$user_id."', '".$election_id."', '".$candidate_id."')");
                $data = array("msg" => "Your vote has been casted successfully!");
            }
            display_success($data);
        }
        
        // register for election
        public function register_election()
        {
            // get parameters
            $election_id = mysql_escape_string($this->_parameters['election_id']);
            $user_id = mysql_escape_string($this->_parameters['user_id']);
            
            if (empty($election_id))
                display_error(202);
            else if (empty($user_id))
                display_error(201);
                
            // remove duplicates
            $removeDuplicates = mysql_query("DELETE FROM voters WHERE election_id='".$election_id."' AND user_id='".$user_id."'");
                
            // register voter
            $registerVoter = mysql_query("INSERT INTO voters (election_id, user_id) VALUES ('".$election_id."', '".$user_id."')");
            display_success();   
        }
        
        // register as candidate
        public function register_candidate()
        {
            // get parameters
            $election_id = mysql_escape_string($this->_parameters['election_id']);
            $user_id = mysql_escape_string($this->_parameters['election_id']);
            
            if (empty($election_id))
                display_error(202);
            else if (empty($user_id))
                display_error(201);
                
            // remove duplicates
            $removeDuplicates = mysql_query("DELETE FROM candidates WHERE election_id='".$election_id."' AND user_id='".$user_id."'");
                
            // register candidate
            $registerCandidate = mysql_query("INSERT INTO candidates (election_id, user_id) VALUES ('".$election_id."', '".$user_id."')");
            display_success();
        }
        
        // vote for candidate
        public function vote_candidate()
        {
            // get parameters
            $election_id = mysql_escape_string($this->_parameters['election_id']);
            $user_id = mysql_escape_string($this->_parameters['user_id']);
            $candidate_id = mysql_escape_string($this->_parameters['candidate_id']);
            
            $checkIfVoted = mysql_query("SELECT * FROM votes WHERE election_id='".$election_id."' AND user_id='".$user_id."'");
            if (mysql_num_rows($checkIfVoted) > 0)
                display_error(204);
            
            // cast vote
            $castVote = mysql_query("INSERT INTO votes (election_id, candidate_id, user_id) VALUES ('".$election_id."', '".$candidate_id."', '".$user_id."')");
            display_success();
        }
    }
    
?>