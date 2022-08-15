//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

// Deployed Address - 0x25960ABd573cb3646b302458492807EECa4536d9
// v2 Deployed Address - 0xB829A8dde3fD6bBA665cF74Efdd4eD7667f57bf6

contract BuyMeACoffee {
    // Event to emit when a Memo is created.
    event NewMemo(
        address indexed from,
        uint256 timestamp,
        string name,
        string message
    );

    // Memo struct
    struct Memo {
        address from;
        uint256 timestamp;
        string name;
        string message;
    }

    // List of all memos received from friends.
    Memo[] memos;

    // Address of contract deployer.
    address payable owner;

    // Address to receive the withdarw funds
    address payable withdrawalOwner;

    // Deploy logic.
    constructor() {
        owner = payable(msg.sender);
        withdrawalOwner = payable(msg.sender);
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner == msg.sender, "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev buy a coffee for contract owner
     * @param _name name of the coffee buyer
     * @param _message a nice message from the coffee buyer
     */
    function buyCoffee(string memory _name, string memory _message)
        public
        payable
    {
        require(msg.value > 0, "can't buy coffee with 0 eth");

        // Add the memo to storage.
        memos.push(Memo(msg.sender, block.timestamp, _name, _message));

        // Emiy a log event when a memo is created
        emit NewMemo(msg.sender, block.timestamp, _name, _message);
    }

    /**
     * @dev send the entire balance stored in this contract to the owner
     */
    function withdrawTips() public {
        require(withdrawalOwner.send(address(this).balance));
    }

    /**
     * @dev update the withdrawal address, can only be called by the owner
     */
    function updateWithdrawalOwner(address _withdrawalOwner) public onlyOwner {
        withdrawalOwner = payable(_withdrawalOwner);
    }

    /**
     * @dev retrieve all the memos received and stored on the blockchain
     */
    function getWithdrawalOwner() public view onlyOwner returns (address) {
        return withdrawalOwner;
    }

    /**
     * @dev retrieve all the memos received and stored on the blockchain
     */
    function getMemos() public view returns (Memo[] memory) {
        return memos;
    }
}
