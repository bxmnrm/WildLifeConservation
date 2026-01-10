// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract WildlifeGuardian {
    struct Purchase {
        string characterName;
        address owner;
        uint256 timestamp;
    }

    Purchase[] public history;

    // Event สำหรับบอกหน้าเว็บว่ามีการซื้อสำเร็จ [cite: 33]
    event CharacterBought(address indexed owner, string characterName, uint256 timestamp);

    // ฟังก์ชันซื้อตัวละคร (ต้องจ่าย Ether ตามที่กำหนด) [cite: 3, 36]
    function buyCharacter(string memory _name) public payable {
        require(msg.value > 0, "Price must be greater than 0"); // ตรวจสอบการจ่ายเงิน [cite: 40]
        
        history.push(Purchase({
            characterName: _name,
            owner: msg.sender,
            timestamp: block.timestamp
        }));

        emit CharacterBought(msg.sender, _name, block.timestamp); // ส่ง Event [cite: 43]
    }

    // ฟังก์ชันดึงประวัติทั้งหมดมาแสดงในตาราง [cite: 51]
    function getHistory() public view returns (Purchase[] memory) {
        return history;
    }
}