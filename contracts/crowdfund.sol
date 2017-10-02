//decypher CrowdFund
//specify amount of gas to whitelist for function..
//msg.gas   checsk in loop whether msg.gas remaining is higher than 100,000, 
//so when the gas is running low will cache current index of the refund and save to this variable

// instead of using array for funders, going to use a mapping..

//uint256 represents value of contribution. 
pragma solidity ^0.4.15;

contract CrowdFund {

address public beneficiary;
uint256 public goal;
uint256 public deadline;
mapping (address => uint256) funders;
address[] funderAddresses;

function CrowdFund(address _beneficiary, uint256 _goal, uint256 _duration) {
	beneficiary = _beneficiary;
	goal = _goal;
	deadline = now + _duration;
}

function getFunderContribution(address _addr) constant returns (uint) {
 return funders[_addr];
}

function getFunderAddress(uint _index) constant returns (address) {
	return funderAddresses[_index];
}

//function to get current account of funder addresses
function funderAddressLength() constant returns (uint) {
	return funderAddresses.length;
}

//now instead of pushing funder onto array, lets us aggregate different values from same person 
//0 checks it is the first time they are contributing, ten you can push to funderAddresses
function contribute() payable {
	if(funders[msg.sender] == 0) funderAddresses.push(msg.sender);
	funders[msg.sender] += msg.value;
}
	//funders.push(funder(msg.sender, msg.value));

//send to transfer changed
function payout() {
	if(this.balance >= goal && now > deadline) beneficiary.transfer(this.balance);
}
//changes way of call, instead of beneficiary calling refund function, we can have the user call for their own refund.
//instead of pushing, they can pull, better way to get around gas refunds.. additional guards, timeline etc..
//solidity mapping has all addresses.. will need helper functions 
//changed msg.sender.send(funders[msg.sender]);   transer is better
function refund() {
	if(now > deadline && this.balance <goal) {

		msg.sender.transfer(funders[msg.sender]);
		funders[msg.sender]= 0;
	}
  }
}
	
	
	/*
function refund() {
    if(msg.sender != beneficiary) throw;
	uint256 index = refundIndex;
	while(index < funders.length && msg.gas > 100000) {
		funders[index].addr.send(funders[index].contribution);
		index++;
	}
	refundIndex = index;
  }
}
*/