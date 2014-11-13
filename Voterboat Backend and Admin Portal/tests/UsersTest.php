<?php
include 'public_html/VB/backend/users.php';

class UsersTest extends PHPUnit_Framework_TestCase
{
    public function testUsersSameEqual()
    {
		$usrName = "Test User";
		$sId = "123456";
		$pass = "a1S@D3f$";
        $a = new Users(array('user_name'=>$usrName, 'student_id'=>$sId, 'password'=>$pass));
		$this->assertEquals($a, new Users(array('student_id'=>$sId, 'user_name'=>$usrName, 'password'=>$pass)));
		$this->assertEquals($a, new Users(array('student_id'=>$sId, 'password'=>$pass, 'user_name'=>$usrName)));
		$this->assertEquals($a, new Users(array('user_name'=>$usrName, 'student_id'=>$sId, 'password'=>$pass)));
		$this->assertEquals($a, new Users(array('user_name'=>$usrName, 'password'=>$pass, 'student_id'=>$sId)));
		$this->assertEquals($a, new Users(array('password'=>$pass, 'user_name'=>$usrName, 'student_id'=>$sId)));
		$this->assertEquals($a, new Users(array('password'=>$pass, 'student_id'=>$sId, 'user_name'=>$usrName)));
    }
	
    public function testUsersNameDiff()
    {
		$usrName = "Test User";
		$sId = "123456";
		$pass = "a1S@D3f$";
        $a = new Users(array('user_name'=>$usrName, 'student_id'=>$sId, 'password'=>$pass));
		$this->assertNotEquals($a, new Users(array('user_name'=>"GARBAGE", 'student_id'=>$sId, 'password'=>$pass)));
		$this->assertNotEquals($a, new Users(array('used_name'=>"GARBAGE", 'student_id'=>$sId, 'password'=>$pass)));
		$this->assertNotEquals($a, new Users(array('used_name'=>$usrName, 'student_id'=>$sId, 'password'=>$pass)));
    }
	
    public function testUsersIdDiff()
    {
		$usrName = "Test User";
		$sId = "123456";
		$pass = "a1S@D3f$";
        $a = new Users(array('user_name'=>$usrName, 'student_id'=>$sId, 'password'=>$pass));
		$this->assertNotEquals($a, new Users(array('user_name'=>$usrName, 'student_id'=>"GARBAGE", 'password'=>$pass)));
		$this->assertNotEquals($a, new Users(array('user_name'=>$usrName, 'student_ic'=>"GARBAGE", 'password'=>$pass)));
		$this->assertNotEquals($a, new Users(array('user_name'=>$usrName, 'student_ic'=>$sId, 'password'=>$pass)));
    }
	
    public function testUsersPassDiff()
    {
		$usrName = "Test User";
		$sId = "123456";
		$pass = "a1S@D3f$";
        $a = new Users(array('user_name'=>$usrName, 'student_id'=>$sId, 'password'=>$pass));
		$this->assertNotEquals($a, new Users(array('user_name'=>$usrName, 'student_id'=>$sId, 'password'=>"GARBAGE")));
		$this->assertNotEquals($a, new Users(array('user_name'=>$usrName, 'student_id'=>$sId, 'passworf'=>"GARBAGE")));
		$this->assertNotEquals($a, new Users(array('user_name'=>$usrName, 'student_id'=>$sId, 'passworf'=>$pass)));
    }
	
    public function testUsersMissingVal()
    {
		$usrName = "Test User";
		$sId = "123456";
		$pass = "a1S@D3f$";
        $a = new Users(array('user_name'=>$usrName, 'student_id'=>$sId, 'password'=>$pass));
		$this->assertNotEquals($a, new Users(array('user_name'=>$usrName, 'student_id'=>$sId)));
		$this->assertNotEquals($a, new Users(array('user_name'=>$usrName,'password'=>$pass)));
		$this->assertNotEquals($a, new Users(array('student_id'=>$sId, 'password'=>$pass)));
    }
	
    public function testUsersExtraVal()
    {
		$usrName = "Test User";
		$sId = "123456";
		$pass = "a1S@D3f$";
        $a = new Users(array('user_name'=>$usrName, 'student_id'=>$sId, 'password'=>$pass));
		$this->assertNotEquals($a, new Users(array('student_id'=>$sId, 'user_name'=>$usrName, 'password'=>$pass, 'Extra'=>"GARBAGE")));
    }
	
    public function testUsersBlankName()
    {
		$usrName = "";
		$sId = "123456";
		$pass = "a1S@D3f$";
        $a = new Users(array('user_name'=>$usrName, 'student_id'=>$sId, 'password'=>$pass));
		$this->assertEquals($a, new Users(array('user_name'=>$usrName, 'student_id'=>$sId, 'password'=>$pass)));
		$this->assertNotEquals($a, new Users(array('user_name'=>"Test User", 'student_id'=>"123456", 'password'=>"a1S@D3f$")));
		//@depends testUsersSameEqual
    }
	
    public function testUsersBlankId()
    {
		$usrName = "Test User";
		$sId = "";
		$pass = "a1S@D3f$";
        $a = new Users(array('user_name'=>$usrName, 'student_id'=>$sId, 'password'=>$pass));
		$this->assertEquals($a, new Users(array('user_name'=>$usrName, 'student_id'=>$sId, 'password'=>$pass)));
		$this->assertNotEquals($a, new Users(array('user_name'=>"Test User", 'student_id'=>"123456", 'password'=>"a1S@D3f$")));
		//@depends testUsersSameEqual
    }
	
    public function testUsersBlankPass()
    {
		$usrName = "Test User";
		$sId = "123456";
		$pass = "";
        $a = new Users(array('user_name'=>$usrName, 'student_id'=>$sId, 'password'=>$pass));
		$this->assertEquals($a, new Users(array('user_name'=>$usrName, 'student_id'=>$sId, 'password'=>$pass)));
		$this->assertNotEquals($a, new Users(array('user_name'=>"Test User", 'student_id'=>"123456", 'password'=>"a1S@D3f$")));
		//@depends testUsersSameEqual
    }
	
    public function testUsersBlankNameId()
    {
		$usrName = "";
		$sId = "";
		$pass = "a1S@D3f$";
        $a = new Users(array('user_name'=>$usrName, 'student_id'=>$sId, 'password'=>$pass));
		$this->assertEquals($a, new Users(array('user_name'=>$usrName, 'student_id'=>$sId, 'password'=>$pass)));
		$this->assertNotEquals($a, new Users(array('user_name'=>"Test User", 'student_id'=>"123456", 'password'=>"a1S@D3f$")));
		//@depends testUsersSameEqual
    }
	
    public function testUsersBlankIdPass()
    {
		$usrName = "Test User";
		$sId = "";
		$pass = "";
        $a = new Users(array('user_name'=>$usrName, 'student_id'=>$sId, 'password'=>$pass));
		$this->assertEquals($a, new Users(array('user_name'=>$usrName, 'student_id'=>$sId, 'password'=>$pass)));
		$this->assertNotEquals($a, new Users(array('user_name'=>"Test User", 'student_id'=>"123456", 'password'=>"a1S@D3f$")));
		//@depends testUsersSameEqual
    }
	
    public function testUsersBlankNamePass()
    {
		$usrName = "";
		$sId = "123456";
		$pass = "";
        $a = new Users(array('user_name'=>$usrName, 'student_id'=>$sId, 'password'=>$pass));
		$this->assertEquals($a, new Users(array('user_name'=>$usrName, 'student_id'=>$sId, 'password'=>$pass)));
		$this->assertNotEquals($a, new Users(array('user_name'=>"Test User", 'student_id'=>"123456", 'password'=>"a1S@D3f$")));
		//@depends testUsersSameEqual
    }
	
    public function testUsersBlankNameIdPass()
    {
		$usrName = "";
		$sId = "";
		$pass = "";
        $a = new Users(array('user_name'=>$usrName, 'student_id'=>$sId, 'password'=>$pass));
		$this->assertEquals($a, new Users(array('user_name'=>$usrName, 'student_id'=>$sId, 'password'=>$pass)));
		$this->assertNotEquals($a, new Users(array('user_name'=>"Test User", 'student_id'=>"123456", 'password'=>"a1S@D3f$")));
		//@depends testUsersSameEqual
    }
}
?>