// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;
pragma abicoder v2;

import {IERC20} from "./IERC20.sol";


contract Staking{


    address public owner;
   IERC20 public _ROI;
    uint256 public userCount = 0;
    // bool isExist;

    address[] public tokenHolder;
    mapping(address=>bool) public isExist;

    mapping(address=>tokenholdersInfo) public TokenHolderInfo;
    mapping(address => uint256) public balanceOf;
    mapping(uint256 => tokenholdersInfo) public tokenholders;
    mapping(address=>userClaim) public _claimedUser;

    event Staked(address indexed  user,uint256 indexed amount);
    event Unstaked(address indexed user,uint256 indexed amount);
    event Claimed(address indexed user, uint rewardAmount);


 
    constructor(address ROI){

        _ROI = IERC20(ROI);
    }

    struct tokenholdersInfo{

        uint256 _userId;
        address _from;
        uint _refReward;
        address referrer;
        uint256 _stakeAmount;
        bool _istokenholder;
        uint256 _depositTime;
        uint256 _unStakeTime;
    }

    struct userClaim{
        address userClaim;
        uint256 _lastClaim;
        uint _claimedAmount;
        uint _totalAmount;
    }


    function deposit(address _user,uint256 _amount,   address _referrer) public{


       require(_ROI.balanceOf(msg.sender) >= _amount, "Insufficient balance");
           _ROI.transferFrom(msg.sender,address(this),_amount);


       balanceOf[_user] += _amount;

      TokenHolderInfo[msg.sender] = tokenholdersInfo({
            _userId: userCount,
            _from: msg.sender,
            _refReward: (_amount * 5) / 1000,
            referrer : _referrer,
            _stakeAmount: _amount -(_amount * 5) / 1000,
            _istokenholder: true,
            _depositTime: block.timestamp,
             _unStakeTime: block.timestamp + 15 days

        });


        _ROI.transfer(  TokenHolderInfo[msg.sender].referrer, TokenHolderInfo[msg.sender]._refReward);
   


        userCount++;
        tokenHolder.push(msg.sender);

        emit Staked(msg.sender, TokenHolderInfo[msg.sender]._stakeAmount);




    }

    function claimReward() public {

        require(!isExist[msg.sender],"Invalid user");

         uint256 timeElapsed = block.timestamp - _claimedUser[msg.sender]._lastClaim;

          uint256 reward = (TokenHolderInfo[msg.sender]._stakeAmount * timeElapsed) ;



         _claimedUser[msg.sender] =  userClaim({

            userClaim: msg.sender,
             _lastClaim: block.timestamp,
             _claimedAmount: reward,
             _totalAmount: reward+TokenHolderInfo[msg.sender]._stakeAmount


         });

        
          reward= 0;

         _ROI.transfer(msg.sender, reward);

         emit Claimed(msg.sender, _claimedUser[msg.sender]._claimedAmount);

    }

    function Unstake() public{

     require(!isExist[msg.sender],"Invalid user");
     require(block.timestamp > TokenHolderInfo[msg.sender]._unStakeTime,"Can't Unstake the amount");

     uint256 totalAmount = _claimedUser[msg.sender]. _totalAmount;
      
      totalAmount = 0;

     _ROI.transfer(msg.sender, totalAmount);

     emit Unstaked(msg.sender, totalAmount);
    


    }


    function rewrdcal(uint amount) public pure
    returns(uint256){

        uint reware = (amount * 5) / 1000;

        return reware;

    }
}