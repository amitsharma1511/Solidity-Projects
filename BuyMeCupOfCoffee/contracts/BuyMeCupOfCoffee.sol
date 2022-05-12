//SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.0;

// Deployed at Goerli - 0x47310a4B53afcAfDd62A6a64EA7AC75e2560b76b

contract BuyMeCupOfCoffee {
    
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    
    // Event to emit when a memo is created
    event NewMemo(
        address indexed from,
        uint256 timestamp,
        string name,
        string message
    );

    // Memo Struct
    struct Memo {
        address from;
        uint256 timestamp;
        string name;
        string message;
    }

    // List of all memos received from friends
    Memo[] memos;

    // Address of contract deployer.
    address payable private _owner;

    constructor() {
        _owner = payable(msg.sender);
    }

    modifier onlyOwner() {
        require(_owner == msg.sender, "Caller is not the owner");
        _;
    }

    /**
     * @dev buy a coffee for contract owner
     * @param _name name of the coffee buyer
     * @param _message a nice message from the buyer
     */

    function buyCoffee(string memory _name, string memory _message) public payable {
        require(msg.value > 0, "Can't buy coffee with 0 ETH");

        // Add the memo to storage
        memos.push(Memo(
            msg.sender,
            block.timestamp,
            _name,
            _message
        ));

        // Emit a log event when a memo is created
        emit NewMemo(msg.sender, block.timestamp, _name, _message);
    }


    /**
     * @dev send the entire balance stored in this contract to the owner
     */
    function withdrawTips() public {
        require(_owner.send(address(this).balance));
    }

    /**
     * @dev retrieve all the memos received and stored on blockchain
     */
    function getMemos() public view returns(Memo[] memory) {
        return memos;
    }

    /**
     * @dev buy a coffee for contract owner
     * @param _newOwner name of the coffee buyer
     */

    function transferOwnership(address _newOwner) public onlyOwner {
        require(_newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(_newOwner);
    }

    function _transferOwnership(address _newOwner) private {
        address oldOwner = _owner;
        _owner = payable(_newOwner);
        emit OwnershipTransferred(oldOwner, _newOwner);
    }
}