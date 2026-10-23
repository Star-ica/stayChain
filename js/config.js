// TODO: replace with your deployed contract address
const CHAIN={id:968,hex:"0x3c8",name:"BOT Chain Testnet",symbol:"BOT",rpc:"https://rpc.bohr.life",explorer:"https://scan.bohr.life",website:"https://botchain.ai"};
const CONFIG={
 "address":"0x4184683BE1071F76a5d4DFa38AEa3D3C2299Cb55",
 "name": "StayChain",
 "fns": [
  "function addRoom(string name,uint256 nightlyWei) returns (uint256)",
  "function book(uint256 roomId,uint256 startDay,uint256 nights) payable returns (uint256)",
  "function cancel(uint256 bookingId)",
  "function checkIn(uint256 bookingId)",
  "function review(uint256 bookingId,uint8 rating)",
  "function rooms(uint256 id) view returns (address,string,uint256)",
  "function bookings(uint256 id) view returns (uint256,address,uint256,uint256,uint256,bool,bool)",
  "function ratings(uint256 bookingId) view returns (uint256)"
 ]
};