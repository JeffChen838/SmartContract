pragma solidity ^0.4.24;

/*
Author : JeffDWChen

An Lottery Contract:
STEP:
1. buy_token(_token)
    Buy tokens to play.
    
2. bet(uint256 _money, uint256 _bet_number)
    Take a bet.
    
3. getBalance(address _player)
    Display balance of player. 
    
4. lottery()
    Lottery machine to generate rand bet_number.
    Judge player is win or lose.

*/

contract Casino {
    mapping(address => uint256) private balances;
    struct Bet {
      address cust;
      uint bet_money;
      uint bet_number;
    }
    Bet[] Bet_DB;
    event lotteryNum(uint256 _lNum);
    
    function bet(uint256 _money, uint256 _bet_number) public {
        require(balances[msg.sender]>=_money);
        balances[msg.sender]-=_money;
        addBet(_money,_bet_number);
    }  
    function addBet(uint256 _money, uint256 _bet_number) private returns (bool success) {
        Bet memory currentBet;
        
        currentBet.cust=msg.sender;
        currentBet.bet_money=_money;
        currentBet.bet_number=_bet_number;
        Bet_DB.push(currentBet);

        return true;
}

    
    function lottery() public  returns(uint){
        uint result=randHash();
        //result=123;
        uint re=0;
        for(uint i = 0; i < Bet_DB.length;  i++) {
            if(Bet_DB[i].bet_number==result)
                {
                 balances[Bet_DB[i].cust]=balances[Bet_DB[i].cust]+2*Bet_DB[i].bet_money;
                 re=Bet_DB[i].bet_money;
                }
        }
        Bet_DB.length=0;
        emit lotteryNum(result);
        return result;
    }    
    
    function randHash() private constant returns(uint){
        uint min =0;
        uint max=1000;
        bytes32 hash = keccak256(abi.encode(block.timestamp));
        return(uint(hash) % (max-min))+min;
    } 
    
    
    function getBalance(address _player) public constant returns (uint256){
        return balances[_player];
    }
    
    
   
    function buy_token(uint256 _token) public {
        balances[msg.sender]=_token;
    }
    
    
}