// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

import { ERC20 } from "./ERC20.sol";
pragma abicoder v2;



contract Token is ERC20 {

    uint8 private _decimal; 
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only Owner Can Mint Tokens");
        _;
    }

    constructor(string memory _name, string memory _symbol, uint8 decimal) ERC20(_name, _symbol) {
        _decimal = decimal; // Fix assignment of _decimal
        owner = msg.sender;
    }
    
    
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount); // Use correct function for minting
    }

    function decimals() public view override returns (uint8) {
        return _decimal; // Return the correct decimal value
    }

    function burn(address to, uint amount) public onlyOwner{
        _burn(to, amount);
    }

    function _balanceOf(address account) public view  returns (uint256) {
        return balanceOf(account);
    }

   
}
