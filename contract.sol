// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract WildlifeGuardian {
    struct Purchase {
        string characterName;
        address owner;
        uint256 timestamp;
    }

    Purchase[] public history;
    
    // เก็บเจ้าของสัตว์แต่ละตัว (ป้องกันสัตว์ซ้ำ)
    mapping(string => address) public animalOwner;

    // 1. เพิ่มตัวแปรเช็คว่า Address นี้เคยซื้อไปหรือยัง (ป้องกันคนซื้อซ้ำ)
    mapping(address => bool) public hasBought; // <-- เพิ่มใหม่

    event CharacterBought(address indexed owner, string characterName, uint256 timestamp);

    function buyCharacter(string memory _name) public payable {
        require(msg.value > 0, "Price must be greater than 0");
        
        // เช็คว่าสัตว์ตัวนี้มีเจ้าของหรือยัง (โค้ดเดิม)
        require(animalOwner[_name] == address(0), "This animal already has a guardian!");
        
        // 2. เพิ่มเงื่อนไขเช็คว่าคนซื้อ เคยซื้อไปหรือยัง? ถ้าเคยแล้วให้ Error
        require(!hasBought[msg.sender], "You can only adopt 1 animal per wallet!"); // <-- เพิ่มใหม่
        
        // บันทึกเจ้าของลงใน Mapping สัตว์
        animalOwner[_name] = msg.sender;

        // 3. บันทึกว่าคนนี้ซื้อไปแล้ว จะได้กลับมาซื้ออีกไม่ได้
        hasBought[msg.sender] = true; // <-- เพิ่มใหม่
        
        history.push(Purchase({
            characterName: _name,
            owner: msg.sender,
            timestamp: block.timestamp
        }));

        emit CharacterBought(msg.sender, _name, block.timestamp);
    }

    function getHistory() public view returns (Purchase[] memory) {
        return history;
    }
}