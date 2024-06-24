// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

/* import "@openzeppelin/contracts/utils/math/SafeMath.sol"; */

interface IRoomManager {
    function book(uint256 _roomNumber) external payable;
    function vacate(uint256 _roomNumber) external;
}

contract HotelRoom is IRoomManager {
   /*  using SafeMath for uint256; */

     //Variables
    uint256 public constant roomPrice = 2 wei;
    uint256 public constant bookingDuration = 1 days;
    address payable public owner;

    //Enums
    enum Statuses { Available, Rented }

    //Struct
    struct Room {
        uint256 roomNumber;
        string description;
        Statuses status;
        uint256 rentedUntil;
    }

    //Mappings
    mapping(uint256 => Room) public rooms;

    //Events
    event Rent(address indexed _client, uint256 _value, uint256 _roomNumber, uint256 _rentedUntil);
    event Release(uint256 _roomNumber);

    constructor() {
        owner = payable(msg.sender);
        rooms[1] = Room(1, "Deluxe Room", Statuses.Available, 0);
        rooms[2] = Room(2, "Suite Room", Statuses.Available, 0);
    }

    //Modifiersr
    modifier onlyWhileAvailable(uint256 _roomNumber) {
        require(rooms[_roomNumber].status == Statuses.Available, "Currently rented.");
        _;
    }

    modifier costs(uint256 _amount) {
        require(msg.value >= _amount, "Insufficient funds provided");
        _;
    }
    //Execute Functions
    function book(uint256 _roomNumber) external payable override onlyWhileAvailable(_roomNumber) costs(roomPrice) {
        rooms[_roomNumber].status = Statuses.Rented;
        rooms[_roomNumber].rentedUntil = block.timestamp + bookingDuration;

        emit Rent(msg.sender, msg.value, _roomNumber, rooms[_roomNumber].rentedUntil);
    }

    function vacate(uint256 _roomNumber) external override {
        require(block.timestamp >= rooms[_roomNumber].rentedUntil, "Room is still rented.");
        rooms[_roomNumber].status = Statuses.Available;
        rooms[_roomNumber].rentedUntil = 0;

        emit Release(_roomNumber);
    }

    function refund(uint256 _roomNumber) external {
        require(rooms[_roomNumber].status == Statuses.Rented, "Room is not rented.");
        require(block.timestamp < rooms[_roomNumber].rentedUntil, "Booking period has ended.");

        rooms[_roomNumber].status = Statuses.Available;
        rooms[_roomNumber].rentedUntil = 0;

        payable(msg.sender).transfer(roomPrice);

        emit Release(_roomNumber);
    }

    // Query Functions
    function getRoomStatus(uint256 _roomNumber) external view returns (Statuses) {
        return rooms[_roomNumber].status;
    }
}
