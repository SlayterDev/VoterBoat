<?php
include 'public_html/VB/backend/controllers/elections.php';

class ElectionsTest extends PHPUnit_Framework_TestCase
{
    public function testElectionsSameEqual()
    {
		$electType = "Test Type";
		$userId = "123456";
        $a = new Elections(array('type'=>$electType, 'user_id'=>$userId));
		$this->assertEquals($a, new Elections(array('type'=>$electType, 'user_id'=>$userId)));
		$this->assertEquals($a, new Elections(array('user_id'=>$userId, 'type'=>$electType)));
    }
	
    public function testElectionsTypeDiff()
    {
		$electType = "Test Type";
		$userId = "123456";
        $a = new Elections(array('type'=>$electType, 'user_id'=>$userId));
		$this->assertNotEquals($a, new Elections(array('type'=>"GARBAGE", 'user_id'=>$userId)));
		$this->assertNotEquals($a, new Elections(array('tpye'=>"GARBAGE", 'user_id'=>$userId)));
		$this->assertNotEquals($a, new Elections(array('tpye'=>$electType, 'user_id'=>$userId)));
    }
	
    public function testElectionsIdDiff()
    {
		$electType = "Test Type";
		$userId = "123456";
        $a = new Elections(array('type'=>$electType, 'user_id'=>$userId));
		$this->assertNotEquals($a, new Elections(array('type'=>$electType, 'user_id'=>"GARBAGE")));
		$this->assertNotEquals($a, new Elections(array('type'=>$electType, 'user_ia'=>"GARBAGE")));
		$this->assertNotEquals($a, new Elections(array('type'=>$electType, 'user_ia'=>$userId)));
    }
	
    public function testElectionsMissingVal()
    {
		$electType = "Test Type";
		$userId = "123456";
        $a = new Elections(array('type'=>$electType, 'user_id'=>$userId));
		$this->assertNotEquals($a, new Elections(array('type'=>$electType)));
		$this->assertNotEquals($a, new Elections(array('user_id'=>$userId)));
    }
	
    public function testElectionsExtraVal()
    {
		$electType = "Test Type";
		$userId = "123456";
        $a = new Elections(array('type'=>$electType, 'user_id'=>$userId));
		$this->assertNotEquals($a, new Elections(array('user_id'=>$userId, 'type'=>$electType, 'Extra'=>"GARBAGE")));
    }
	
    public function testElectionsBlankType()
    {
		$electType = "";
		$userId = "123456";
        $a = new Elections(array('type'=>$electType, 'user_id'=>$userId));
		$this->assertEquals($a, new Elections(array('type'=>$electType, 'user_id'=>$userId)));
		$this->assertNotEquals($a, new Elections(array('type'=>"Test Type", 'user_id'=>"123456")));
		//@depends testElectionsSameEqual
    }
	
    public function testElectionsBlankId()
    {
		$electType = "Test Type";
		$userId = "";
        $a = new Elections(array('type'=>$electType, 'user_id'=>$userId));
		$this->assertEquals($a, new Elections(array('type'=>$electType, 'user_id'=>$userId)));
		$this->assertNotEquals($a, new Elections(array('type'=>"Test Type", 'user_id'=>"123456")));
		//@depends testElectionsSameEqual
    }
	
    public function testElectionsBlankTypeId()
    {
		$electType = "";
		$userId = "";
        $a = new Elections(array('type'=>$electType, 'user_id'=>$userId));
		$this->assertEquals($a, new Elections(array('type'=>$electType, 'user_id'=>$userId)));
		$this->assertNotEquals($a, new Elections(array('type'=>"Test Type", 'user_id'=>"123456")));
		//@depends testElectionsSameEqual
    }
}
?>