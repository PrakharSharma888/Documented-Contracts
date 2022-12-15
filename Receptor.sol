// SPDX-License-Identifier: MIT

pragma solidity 0.8.7;
import "@openzeppelin/contracts/access/Ownable.sol";

contract Receptor is Ownable {

    // Structure to store all the attributes of under deposit
    struct Deposit {
        string txHash; 
        bool claimed; 
        uint256 amount;
        bool set;
    }

    // mapping to store a key value pair of diffrent deposit ids 
    mapping(string => Deposit) public depositId;

    /**
    * @dev Used to deposit ether to the contract
    * @param _id id to uniquely store the deposite data
     */
    function depositEther(string memory _id) public payable {
        require(msg.value > 0,"cant deposit zero ether");
        require(depositId[_id].set == false, "Deposit Id already exists");
        depositId[_id].amount = msg.value;
        depositId[_id].set = true;
    }

    /**
    * @dev Used to claim the ether you deposited to be able to get it back when time
    * @param _id Unique id of the deposited data
    * @param _txHash Transaction hash of your ether deposit transaction
     */
    function claimDeposit(string memory _id, string memory _txHash) public {
        require(depositId[_id].amount != 0, "Deposit amount is empty");
        require(depositId[_id].set == true, "Deposit Id does not exist");
        require(depositId[_id].claimed == false, "Already claimed");
        depositId[_id].claimed = true;
        depositId[_id].txHash = _txHash;
    }

    /**
    * @dev Called by the owner to transfer deposited amount to the depositor
    * @param to Address of the depositor to transfer funds to
    * @param amount Amount of funds to transfer
    * @return Boolean if transfer done successfully or not
     */
    function withdrawDeposit(address payable to, uint256 amount) public payable onlyOwner returns (bool){
        (bool success,) = to.call { value:amount, gas: 30000 }(''); // amount in wei
        require(success, "Withdraw failed");
        return success;
    }

    // to receive ethers to the contract
    receive() external payable {}

     // Fallback function is called when msg.data is not empty
    fallback() external payable {}

    // To get the balance of the contract
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}