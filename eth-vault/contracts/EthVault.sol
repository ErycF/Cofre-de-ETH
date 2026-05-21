// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.30;

contract EthVault {
    struct Deposit {
        uint amount;
        uint unlockTime;
    }

    mapping (address => Deposit) public deposits;

    //Deposito ETH com prazo de bloqueio em dias
    function deposit (uint lockMinutes) external payable{
        require (msg.value > 0, "Valor deve ser maior do que zero.");
        require (deposits[msg.sender].amount == 0, "Voce ja tem um deposito ativo.");
        require (lockMinutes > 0, "Prazo deve ser maior que zero.");

        uint unlockTime = block.timestamp + (lockMinutes * 1 minutes);

        deposits[msg.sender] = Deposit({
            amount: msg.value,
            unlockTime: unlockTime
        });
    }
}