// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <0.9.0;

contract crowdfunding {

    struct donator{
        address donatorAddress;
        uint money;
    }

    struct donee {
        address doneeAddress;
        uint amount;
        uint maxAmount;
        uint donatorNum;  // donator id
        mapping( uint => donator) map; //The donator id is tied to the donor information
    }

    uint doneeNum; //donee id
    mapping( uint => donee) doneeMap;

    // @param _doneeAdress donee address
    // @param __maxAmount the maximum amount of money the donee needs to raise 
    function createDonee(address _doneeAddress, uint _maxAmount) public {
        doneeNum++;
        doneeMap[doneeNum].donatorNum = 0;
        doneeMap[doneeNum].maxAmount = _maxAmount;
        doneeMap[doneeNum].amount = 0;
        doneeMap[doneeNum].doneeAddress = _doneeAddress;
    }
    // @param _doneeAddress donee id
    function contribution(uint _doneeNum) public payable {
        donee storage _donee = doneeMap[_doneeNum];
        // increasing the number of donator
        _donee.donatorNum++;
        // increasing the amount of money
        _donee.amount += msg.value;
        // The donator id is tied to the donor information
       _donee.map[_donee.donatorNum] = donator(msg.sender, msg.value);
    }

    // @param _doneeNum donee id
    function isComplete(uint _doneeNum) public {
        donee storage _donee = doneeMap[_doneeNum];
        if(_donee.amount >= _donee.maxAmount) {
            payable(_donee.doneeAddress).transfer(_donee.amount);
        }
    }
    function test2() view public  returns(uint,uint,uint,address) {
        return(doneeMap[2].donatorNum,doneeMap[2].maxAmount,doneeMap[2].amount,doneeMap[2].doneeAddress);
    }
    function test1() view public  returns(uint,uint,uint,address) {
        return(doneeMap[1].donatorNum,doneeMap[1].maxAmount,doneeMap[1].amount,doneeMap[1].doneeAddress);
    }
    function test0() view public  returns(uint,uint,uint,address) {
        return(doneeMap[0].donatorNum,doneeMap[0].maxAmount,doneeMap[0].amount,doneeMap[0].doneeAddress);
    }
}