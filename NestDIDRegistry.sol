// SPDX-License-Identifier: GPLv3
pragma solidity 0.8.10;

contract NestDIDRegistry {
    // Address of the auther
    address public author;

    // Mapping to store DIDs of the addresses who own them
    mapping(string => address) private owners;

    // Mapping to store the number of times there has been a change in the identity
    mapping(string => uint) public changed;
   
    /**
    * @dev Constructor to assign the auther
     */
    constructor() {
        author = msg.sender;
    }

    // Modifier for only owner permissions
    modifier onlyOwner() {
        require(msg.sender == author, "Unauthorised Access"); 
        _;                              
    }

    event DIDIdentityAdded(
        string indexed identity,
        address owner
    );

    event DIDOwnerChanged(
        string indexed identity,
        address owner,
        uint previousChange
    );

    /**
    * @dev This function returns the owner of the identity you passed with it.
    * @param _identity String of the identity you want to know owner of
    * @return Owner of the identity entered
     */
    function identityOwner(string memory _identity) public view returns(address) {
        address owner = owners[_identity];
        if (owner != address(0x0)) {
            return owner;
        }
        return address(0x0);
    }

    /**
    * @dev This function adds your identity into the owners mapping.
    * @param _identity String of the identity you want to add
    * @param _owner Owner of the identity
     */

    function addIdentity(string memory _identity, address _owner) public onlyOwner {
        require(identityOwner(_identity) == address(0x0), "Identity Exists!");
        require(_owner != address(0x0) ,"null address cant be owner");
        owners[_identity] = _owner;
        emit DIDIdentityAdded(_identity, _owner);
    }

     /**
    * @dev This function changes the current owner of the identity to a new one
    * @param _identity String of the identity you want to change owner of
    * @param _newOwner New owner of the identity
     */

    function changeOwner(string memory _identity, address _newOwner) public onlyOwner {
        require(identityOwner(_identity) != address(0x0), "Identity Doesn't Exist!");
        require(_newOwner != address(0x0) ,"null address cant be owner");
        owners[_identity] = _newOwner;
        emit DIDOwnerChanged(_identity, _newOwner, changed[_identity]);
        changed[_identity]++;
    }

     /**
    * @dev Verifies if identity owner is the signer.
    * @param _identity String of the identity
    * @param _sig Signature 
    * @return True if the signer is the owner, False otherwise
     */
    function verifySigner(string memory _identity, bytes memory _sig) public view returns (bool) {
        require(identityOwner(_identity) != address(0x0), "Identity Doesn't Exist!");
        bytes32 message = keccak256(abi.encodePacked(_identity, owners[_identity]));
        return (recoverSigner(message, _sig) == owners[_identity]);
    }

     /**
    * @dev This function recovers/identifies the associated public key used to sign a message
    * @param message Message in bytes32
    * @param sig Signature
     */
    function recoverSigner(bytes32 message, bytes memory sig)  internal pure  returns(address) {
       uint8 v;
       bytes32 r;
       bytes32 s;
       (v, r, s) = splitSignature(sig);
       return ecrecover(message, v, r, s);
    }

     /**
    * @dev This function split the signatures into EDSCA scheame of v,r,s
    * @param sig Signature
    * @return v,r,s of the transaction
     */
    function splitSignature(bytes memory sig)   internal pure returns(uint8, bytes32, bytes32) {
       require(sig.length == 65);
       bytes32 r;
       bytes32 s;
       uint8 v;
       assembly {
           // first 32 bytes, after the length prefix
           r := mload(add(sig, 32))
           // second 32 bytes
           s := mload(add(sig, 64))
           // final byte (first byte of the next 32 bytes)
           v := byte(0, mload(add(sig, 96)))
       }
       return (v, r, s);
    }


}