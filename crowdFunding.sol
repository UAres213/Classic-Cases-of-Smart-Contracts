// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract CrowdFunding {
    address public immutable beneficiary; // 受益人
    uint256 public immutable fundingGoal; // 筹资目标数量
    uint256 public fundingAmount;  // 当前的金额
    mapping(address => uint256) public funders;
    //可迭代的mapping
    mapping(address=>bool) private  fundersInserted;
    address[] public fundersKey; //length
    //不用自销毁方法，使用变量来控制
    bool public AVAILABLED = true; //状态
    // 部署的时候，写入受益人+筹资目标数量
    constructor(address beneficiary_, uint256 goal_) {
        beneficiary = beneficiary_;
        fundingGoal = goal_;
    }
    // 资助
    // 可用的时候才可以捐
    // 合约关闭之后，就不能在操作了
    function contribute() external payable {
        require(AVAILABLED,"CrowdFunding is closed");
        funders[msg.sender] += msg.value;
        fundingAmount += msg.value;
        //1.check
        if(!fundersInserted[msg.sender]){
            //2.modify
            fundersInserted[msg.sender] = true;
            //3.operate
            fundersKey.push(msg.sender);
        }
    }
    
    //close
    function close() external returns (bool) {
        //1.check
        if(fundingAmount<fundingGoal){
            return false;
        }
        uint256 amount = fundingAmount;
        //2.modify
        fundingAmount = 0;
        AVAILABLED = false;
        //3.operate
        payable (beneficiary).transfer(amount);
        return true;
    }
    function funderLength() public view returns(uint256) {
        return fundersKey.length;
    }
}