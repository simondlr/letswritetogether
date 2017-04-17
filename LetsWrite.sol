pragma solidity ^0.4.10;

/*
Collectively write something together.
You can add 3 words, then you have to transfer ownership.

Pubished under: https://creativecommons.org/licenses/by-sa/4.0/
Inspired by "A Universe Explodes". 
https://medium.com/@teau/a-universe-explodes-a-blockchain-book-ab75be83f28
*/
contract letsWrite {
    
    mapping (address => Writer) writers;
    
    uint limit = 3; //3 words per go.
    
    struct Writer {
        bool current;
        uint256 wrote; 
    }
    
    //simply a giant mapping.
    //no restrictions atm.
    //can overwrite.
    mapping (uint256 => bytes32) corpus;
    
    //choose how many writers there can be at the start
    function letsWrite(address[] startingWriters) {
        for(uint i = 0; i<startingWriters.length; i+=1) {
            writers[startingWriters[i]] = Writer({
               current: true,
               wrote: 0
            });
        }
    }
    
    //"word" used loosely here, since it's bytes32
    function addWord(uint256 index, bytes32 word) {
        if(writers[msg.sender].current == true
        && writers[msg.sender].wrote <= limit) {
            corpus[index] = word;
            writers[msg.sender].wrote += 1;
            LogWrite(msg.sender, index, word, now);
        }
    }
    
    function transferOwner(address _newWriter) {
        if(writers[msg.sender].current == true //current writer
        && writers[msg.sender].wrote == limit //needs to have written before transferring
        && writers[_newWriter].current == false  //new writer is not a current writer
        && msg.sender != _newWriter) { //can't transfer to "yourself"
            delete writers[msg.sender];
            writers[_newWriter] = Writer({
                current: true,
                wrote: 0
            });
        }
    }
    
    event LogWrite(address writer, uint256 index, bytes32 word, uint256 timestamp);
}
