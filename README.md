
# 🪙 Staking Smart Contract (ROI Token)

### Overview

The **Staking** smart contract allows users to stake an ERC20 token (ROI) to earn rewards over time.
It supports referral bonuses, claimable staking rewards, and an unstaking period of **15 days**.

---

## 📜 Contract Details

* **Solidity Version:** ^0.7.0
* **Token Interface:** ERC20-compatible (`IERC20.sol`)
* **Key Feature:** Reward system with referral support

---

## ⚙️ Constructor

```solidity
constructor(address ROI)
```

* Initializes the staking contract with the address of the ROI token.
* Sets `_ROI` to interact with the ERC20 token.

---

## 🧩 Structs

### `tokenholdersInfo`

Holds information about each staker:

```solidity
struct tokenholdersInfo {
    uint256 _userId;
    address _from;
    uint _refReward;
    address referrer;
    uint256 _stakeAmount;
    bool _istokenholder;
    uint256 _depositTime;
    uint256 _unStakeTime;
}
```

### `userClaim`

Stores user claim and reward details:

```solidity
struct userClaim {
    address userClaim;
    uint256 _lastClaim;
    uint _claimedAmount;
    uint _totalAmount;
}
```

---

## 💰 Functions

### `deposit(address _user, uint256 _amount, address _referrer)`

* Allows users to deposit (stake) ROI tokens.
* Transfers tokens from the user to the contract.
* Allocates a **0.5% referral reward** to the provided `_referrer`.
* Records user staking info and emits a `Staked` event.

**Events emitted:**

```solidity
event Staked(address indexed user, uint256 indexed amount);
```

---

### `claimReward()`

* Allows users to claim accumulated staking rewards.
* Calculates rewards based on the time elapsed since the last claim.
* Transfers earned rewards to the user.

**Events emitted:**

```solidity
event Claimed(address indexed user, uint rewardAmount);
```

---

### `Unstake()`

* Enables users to withdraw their staked tokens after **15 days**.
* Checks that the unstake period has passed.
* Transfers the total staked amount back to the user.

**Events emitted:**

```solidity
event Unstaked(address indexed user, uint256 indexed amount);
```

---

### `rewrdcal(uint amount)`

* A pure utility function to calculate referral rewards.
  Returns `amount * 5 / 1000` (0.5%).

---

## 🧠 How the Reward Logic Works

1. When a user stakes tokens via `deposit()`,

   * 0.5% of the amount is sent to the referrer.
   * The remaining amount is locked for staking.
2. When `claimReward()` is called, rewards are calculated based on staking time.
3. After 15 days, users can withdraw via `Unstake()`.

---

## ⚠️ Notes & Limitations

* Reward formula currently lacks rate division (should be adjusted for realistic returns).
* The `isExist` mapping is used but never updated — may need refinement.
* Use caution on mainnet; test thoroughly on testnets first.

---


## 📚 Events Summary

| Event                                      | Description                          |
| ------------------------------------------ | ------------------------------------ |
| `Staked(address user, uint256 amount)`     | Triggered when a user stakes tokens. |
| `Claimed(address user, uint rewardAmount)` | Triggered when rewards are claimed.  |
| `Unstaked(address user, uint256 amount)`   | Triggered when tokens are withdrawn. |

---

## Deployed Addresses

## ROI : 0x88DDb966851C0bBf521508B2B3b6A5E852571BeE
## Staking: 0x37Ba5dC3a46732BEBC8c61e2E8eAbFf711b294Ea


---

