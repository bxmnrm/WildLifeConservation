// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract WildlifeGuardian {
    struct Purchase {
        string characterName;
        address owner;
        uint256 timestamp;
    }

    // 1. เก็บประวัติทั้งหมด (รวมถึงการซื้อในอดีต)
    Purchase[] public history;
    
    // 2. เก็บสถานะเจ้าของปัจจุบัน (เพื่อเช็คว่าซ้ำไหม)
    mapping(string => address) public animalOwner;

    event CharacterBought(address indexed owner, string characterName, uint256 timestamp);

    // ยุบเหลือฟังก์ชันเดียว และเพิ่มเงื่อนไขตรวจสอบ
    function buyCharacter(string memory _name) public payable {
        // ตรวจสอบเงื่อนไข 1: ต้องจ่ายเงินมากกว่า 0
        require(msg.value > 0, "Price must be greater than 0");
        
        // ตรวจสอบเงื่อนไข 2: สัตว์ตัวนี้ต้องยังไม่มีเจ้าของ (Address ต้องเป็น 0x0...)
        require(animalOwner[_name] == address(0), "This animal already has a guardian!");
        
        // บันทึกเจ้าของลงใน Mapping
        animalOwner[_name] = msg.sender;
        
        // บันทึกข้อมูลลงใน History Array สำหรับแสดงในตาราง
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