// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
// Days are Unix days (timestamp / 86400).
contract StayChain {
    struct Room { address hotel; string name; uint256 nightly; }
    struct Booking { uint256 room; address guest; uint256 startDay; uint256 nights; uint256 paid; bool checkedIn; bool cancelled; }
    Room[] public rooms; Booking[] public bookings;
    mapping(uint256 => mapping(uint256 => bool)) private taken;
    mapping(uint256 => uint256) public ratings;

    function addRoom(string calldata name, uint256 nightly) external returns (uint256) {
        rooms.push(Room(msg.sender, name, nightly)); return rooms.length - 1;
    }
    function book(uint256 rid, uint256 startDay, uint256 nights) external payable returns (uint256) {
        require(nights > 0 && msg.value == rooms[rid].nightly * nights, "bad payment");
        for (uint256 i; i < nights; i++) { require(!taken[rid][startDay + i], "taken"); taken[rid][startDay + i] = true; }
        bookings.push(Booking(rid, msg.sender, startDay, nights, msg.value, false, false));
        return bookings.length - 1;
    }
    function cancel(uint256 bid) external {
        Booking storage b = bookings[bid];
        require(msg.sender == b.guest && !b.checkedIn && !b.cancelled, "not allowed");
        b.cancelled = true;
        for (uint256 i; i < b.nights; i++) taken[b.room][b.startDay + i] = false;
        uint256 refund = b.startDay * 1 days > block.timestamp + 2 days ? b.paid : b.paid / 2;
        payable(msg.sender).transfer(refund);
        if (b.paid > refund) payable(rooms[b.room].hotel).transfer(b.paid - refund);
    }
    function checkIn(uint256 bid) external {
        Booking storage b = bookings[bid];
        require(msg.sender == rooms[b.room].hotel && !b.checkedIn && !b.cancelled, "not allowed");
        b.checkedIn = true; payable(msg.sender).transfer(b.paid);
    }
    function review(uint256 bid, uint8 rating) external {
        require(bookings[bid].guest == msg.sender && bookings[bid].checkedIn && rating >= 1 && rating <= 5, "not allowed");
        ratings[bid] = rating;
    }
}
