// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./IERC20.sol";

contract ERC20Permit is IERC20 {
    mapping(address => uint) public override balanceOf;
    mapping(address => mapping(address=>uint)) public override allowance;
    mapping (address => uint) private nonces;
    
    uint256 public _totalSupply;

    string private _name;
    string private _symbol;

    bytes32 public override DOMAIN_SEPARATOR;

    constructor(string memory name_, string memory symbol_){
        _name = name_;
        _symbol = symbol_;
        uint256 chainId_ = 80001;

        // declare domain separator hash for our erc20 token based on eip712 standard
        DOMAIN_SEPARATOR = keccak256(abi.encode(
            keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
            keccak256(bytes(name())),
            keccak256(bytes("1")),
            chainId_,
            address(this)
        ));
    }

    function name() public view virtual returns (string memory) {
        return _name;
    }

    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }

    function decimals() public view virtual returns (uint8) {
        return 18;
    }

    function transfer(address recipient, uint amount) override external returns (bool) {
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;

        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint amount) override external returns (bool){
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function permit(
        address owner,
        address spender,
        uint256 nonce,
        uint256 expiry,
        bool allowed,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external virtual override
    {
        // permit signature hash for each individual approve function call starting with 0X1901 for an EIP191 compliant 712 hash
        bytes32 permitHash =
            keccak256(abi.encodePacked(
                uint16(0x1901),
                DOMAIN_SEPARATOR,
                keccak256(abi.encode(
                    keccak256("Permit(address owner,address spender,uint256 nonce,uint256 expiry)"),
                    owner,
                    spender,
                    nonce,
                    expiry,
                    allowed
                    ))
        ));

        // token owner address can't permit max alllowance permit for user
        require(owner != address(0), "address cannot be token address");
        
        // verify permit signature hash
        require(owner == ecrecover(permitHash, v, r, s), "invalid permit hash");
        
        // set expiry of approval timestamp
        require(expiry == 0 || block.timestamp <= expiry, "permit timestamp expired");
        
        // nonce must be unique for each permit function call
        require(nonce == nonces[owner]++, "invalid nonce");
        
        // set maximum uint allowances for token approval by user
        uint maxAllowance = type(uint).max;
        allowance[owner][spender] = maxAllowance;
        emit Approval(owner, spender, maxAllowance);
    }

    function transferFrom(
        address sender,
        address recipient,
        uint amount
        ) override external returns (bool){
        allowance[sender][msg.sender] -= amount;
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;

        emit Transfer(sender, recipient, amount);
        return true;
    }

    function mint(address account, uint amount) internal virtual {
        balanceOf[account] += amount;
        _totalSupply += amount;

        emit Transfer(address(0), account, amount);
    }

    function burn(address account, uint amount) external {
        balanceOf[account] -= amount;
        _totalSupply -= amount;

        emit Transfer(account, address(0), amount);
    }
}