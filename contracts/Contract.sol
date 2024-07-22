pragma solidity ^0.8.24;

contract Mainbox {
    uint public totalLetters;
    struct Letter {
        string letter;
        address sender;
    }
    Letter[] public letters;
    function write(string memory letter) 
    public { 
        totalLetters++;
        letters.push(Letter(letter, msg.sender));
    }
    function read() public view returns (Letter[] memory) {
        return letters;
    }  
}