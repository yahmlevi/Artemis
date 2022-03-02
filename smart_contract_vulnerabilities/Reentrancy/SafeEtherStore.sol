contract EtherStore {
    
    // initialize the mutex
    bool reEnterancyMutex = false;
    uint256 public withdrawLimit = 1 ether;
    mapping(address => uint256) public lastWithdrawTime;
    mapping(address => uint256) public balances;

    function depositFunds() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdrawFunds(uint256 _weiToWithdraw) public {
        require(!reEnterancyMutex);
        require(balances[msg.sender] >= _weiToWithdraw);
        // limit the withdrawl
        require(_weiToWithdraw <= withdrawLimit);
        // limit the time allowed to withdraw
        require(now >= lastWithdrawTime[msg.sender] + 1 weeks);
        balances[msg.sender] -= _weiToWithdraw;
        lastWithdrawTime[msg.sender] = now;
        // set the reEnterancyMutex before the external call
        reEnterancyMutex = true;
        msg.sender.transfer(_weiToWithdraw);
        // release the mutex after the external call
        reEnterancyMutex = false;
    }
}