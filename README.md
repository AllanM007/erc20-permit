<h1 align="center">Welcome to erc20permit-wrapper 👋</h1>
<p>
  <img alt="Version" src="https://img.shields.io/badge/version-1.0.0-blue.svg?cacheSeconds=2592000" />
  <a href="#" target="_blank">
    <img alt="License: ISC" src="https://img.shields.io/badge/License-ISC-yellow.svg" />
  </a>
  <a href="https://twitter.com/0xAllan" target="_blank">
    <img alt="Twitter: 0xAllan" src="https://img.shields.io/twitter/follow/0xAllan.svg?style=social" />
  </a>
</p>

> Currently ERC20 implementations require a user to approve a dapp to use their tokens by submitting a transaction which requires gas fees to be paid each time a user wants to approve a dapp to make a transaction on their behalf with their tokens which is an extra cost to the user that can be avoided. This project is an abstract implementation of the EIP2612 stardard allowing erc20 token gasless approvals using user's signature instead of approval transactions to the EVM network.

##  Reference Sources

Some sources that assisted me to understand EIP2612 standard and it's purpose and previous ERC20 limitations.
> i) https://eips.ethereum.org/EIPS/eip-2612 (eip2612 proposal)
ii) https://www.youtube.com/watch?v=S4vnFm5hI8A&t=966s. (MakerDAO DAI permit implementation)
iii) https://github.com/makerdao/developerguides/blob/master/dai/how-to-use-permit-function/how-to-use-permit-function.md (MakerDAO Permit Function Walkthrough)

## Install

```sh
npm install
```

## Usage

```sh
npx hardhat
```

## Run tests

```sh
npx hardhat test
```

## Author

👤 **Allan**

* Website: https://allanm007.github.io/
* Twitter: [@0xAllan](https://twitter.com/0xAllan)
* Github: [@AllanM007](https://github.com/AllanM007)

## Show your support

Give a ⭐️ if this project helped you!

***
_This README was generated with ❤️ by [readme-md-generator](https://github.com/kefranabg/readme-md-generator)_