const API_KEY = process.env.ALCHEMY_KEY;
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const CONTRACT_ADDRESS = process.env.TokenContract;

const { ethers } = require("ethers");
const contract = require("../artifacts/contracts/Token.sol/ERC20.json");

// Provider
const alchemyProvider = new ethers.providers.AlchemyProvider(network="maticmum", API_KEY);

// Signer
const signer = new ethers.Wallet(PRIVATE_KEY, alchemyProvider);

// Contract
const tokenContract = new ethers.Contract(CONTRACT_ADDRESS, contract.abi, signer);
console.log(tokenContract.functions);

const mintFunc = async() => {

    const message = await tokenContract.functions.mint("100")
    console.log("The message is: " + message);
}
// mintFunc()

const permitFunc = async() => {

    const response = await tokenContract.functions.permit(signer)
    console.log("The response is: " + response);
}
// permitFunc()