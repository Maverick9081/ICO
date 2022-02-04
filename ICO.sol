pragma solidity ^0.8.0;

import "./NiceToken.sol";

contract ICO is NiceToken  {
    
    address public admin;
    uint public mintedTokens;
    uint public currentIcoPhase = 1;
    uint private preSaleTokens=3*10**16;
    uint private seedSaleTokens =5*10**16;
    uint private finalSaleTokens=2*10**16;
    uint private denominator =10**4;
   
    constructor () {
        admin = msg.sender;
    }

    modifier onlyadmin {
        require(msg.sender == admin);
        _;
    }

    
    

    function buyToken(address buyer)public payable  {
        uint weiAmount = msg.value;
        require(weiAmount >100000);
        uint amount = getTokenAmount(weiAmount);
        mintTokens(buyer,amount);
    }

    function tokensRemainsToBeSold() public view returns(uint) 
    {
        if(currentIcoPhase==1){
            return preSaleTokens - mintedTokens;
        }
        else if(currentIcoPhase==2){
            return preSaleTokens + seedSaleTokens - mintedTokens;
        } 
        else if(currentIcoPhase ==3){
            return totalSupply() - mintedTokens;
        }
    }

    function totalFundsRaised()public view returns (uint){
        uint balance = address(this).balance;
        return balance;
    }

    function tokenPrice() internal view returns(uint) {
        if(currentIcoPhase == 1) {
            return 3;
        }
        else if(currentIcoPhase == 2) {
            return 6;
        }
        else if(currentIcoPhase ==3) {
            return 9;
        }
    }
    
    function getTokenAmount(uint weiAmount) internal  returns (uint) {
        return weiAmount*tokenPrice()/denominator ;
    }

    function changePhase() internal{
        require(currentIcoPhase <3);
        currentIcoPhase ++;
    }

    
        
    function mintTokens(address buyer,uint amount)internal {
        uint tokens = mintedTokens + amount;
        require(
                    currentIcoPhase ==1 && tokens <= preSaleTokens ||
                    currentIcoPhase ==2 && tokens <= seedSaleTokens + preSaleTokens ||
                    currentIcoPhase ==3 && tokens <= finalSaleTokens + seedSaleTokens + preSaleTokens
                );
        _mint(buyer,amount);
        mintedTokens += amount;
        uint i = tokensRemainsToBeSold();
        if(i ==0   && currentIcoPhase <3){
            changePhase();
        }
    } 

}
