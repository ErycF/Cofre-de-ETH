// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.30;

contract EthVault {
    struct Deposit {
        uint amount;
        uint unlockTime;
    }

    mapping (address => Deposit) public deposits;

    event Deposited(address indexed user, uint256 amount, uint256 unlockTime);
    event Withdraw(address indexed user, uint256 amount);

    //Deposito ETH com prazo de bloqueio em dias
    function deposit(uint lockMinutes) external payable{
        require (msg.value > 0, "Valor deve ser maior do que zero.");
        require (deposits[msg.sender].amount == 0, "Voce ja tem um deposito ativo.");
        require (lockMinutes > 0, "Prazo deve ser maior que zero.");

        uint unlockTime = block.timestamp + (lockMinutes * 1 minutes);

        deposits[msg.sender] = Deposit({
            amount: msg.value,
            unlockTime: unlockTime
        });

        emit Deposited(msg.sender, msg.value, unlockTime);
    }
    //Saca o ETH se o prazo já passou
    function withdraw() external{
        Deposit memory userDeposit = deposits[msg.sender];

        require(userDeposit.amount > 0, "Nenhum deposito encontrado.");
        require(block.timestamp >= userDeposit.unlockTime, "Prazo ainda nao acabou.");
    }
}