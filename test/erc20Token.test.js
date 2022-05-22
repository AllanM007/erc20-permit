const { expect, use } = require('chai');
const { Contract } = require('ethers');
const { deployContract, MockProvider, solidity } = require('ethereum-waffle');
const ERC20 = require('../build/ERC20.json');

use(solidity);

describe('ERC20', () => {
  const [wallet, walletTo] = new MockProvider().getWallets();
  let token = Contract;

  beforeEach(async () => {
    token = await deployContract(wallet, ERC20, [1000]);
  });

  it('Assigns initial balance', async () => {
    expect(await token.balanceOf(wallet.address)).to.equal(1000);
  });

  it('Transfer adds amount to destination account', async () => {
    await token.transfer(walletTo.address, 254);
    expect(await token.balanceOf(walletTo.address)).to.equal(254);
  });

  it('Transfer emits event', async () => {
    await expect(token.transfer(walletTo.address, 7))
      .to.emit(token, 'Transfer')
      .withArgs(wallet.address, walletTo.address, 7);
  });

  it('Can not transfer above the amount', async () => {
    await expect(token.transfer(walletTo.address, 1007)).to.be.reverted;
  });

  it('Can not transfer from empty account', async () => {
    const tokenFromOtherWallet = token.connect(walletTo);
    await expect(tokenFromOtherWallet.transfer(wallet.address, 1))
      .to.be.reverted;
  });

  it('Calls totalSupply on ERC20 contract', async () => {
    await token.totalSupply();
    expect('totalSupply').to.be.calledOnContract(token);
  });

  it('Calls balanceOf with sender address on ERC20 contract', async () => {
    await token.balanceOf(wallet.address);
    expect('balanceOf').to.be.calledOnContractWith(token, [wallet.address]);
  });
});