pragma solidity ^0.4.10;

contract EscherVoting {
    event onVote(address indexed voter, uint indexed candidate);

    mapping(address => uint) public votes;
    address[] public voters;
    uint public endBlock;
    uint public startBlock;

    function EscherVoting(uint _startBlock, uint _endBlock) public {
        startBlock = _startBlock;
        endBlock = _endBlock;
    }

    function vote(uint candidate) public {
        require(candidate != 0);
        require(endBlock == 0 || block.number <= endBlock);
        require(block.number >= startBlock);

        if (votes[msg.sender] == 0) {
            voters.push(msg.sender);
        }
        votes[msg.sender] = candidate;
        onVote(msg.sender, candidate);
    }

    function votersCount() constant public returns(uint) {
        return voters.length;
    }

    function getVoters(uint offset, uint limit) constant public returns(address[] _voters, uint[] _candidates)
    {
        if (offset < voters.length) {
            uint count = 0;
            uint resultLength = voters.length - offset > limit ? limit : voters.length - offset;
            _voters = new address[](resultLength);
            _candidates = new uint[](resultLength);
            for(uint i = offset; (i < voters.length) && (count < limit); i++) {
                _voters[count] = voters[i];
                _candidates[count] = votes[voters[i]];
                count++;
            }

            return(_voters, _candidates);
        }
    }
}
