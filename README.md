# Hotel Reservation System on Scroll
Hotel Reservation System deployed on Scroll Sepolia Testnet.

Create an `.env` file in the home directory and add your Private Key into it without the leading 0x.

#### Install Dependencies
```
  npm install
```

#### Compile
```
  npx hardhat compile
```

#### Test
```
  npx hardhat test
```

#### Deploy on Scroll
```
  npx hardhat ignition deploy ./ignition/modules/HotelReservation.ts --network scrollSepolia
```

#### Live Contract Address
`0x3A8e426cBE63516E8240a6D445D6932d9fF1ae1d`
