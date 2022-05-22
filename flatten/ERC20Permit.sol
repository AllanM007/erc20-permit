// Dependency file: contracts/IERC20.sol

// SPDX-License-Identifier: MIT
// pragma solidity ^0.8.0;

/**
 * Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {

    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * Initiates a permit transaction that approves tokens owned by user to be used by the contract without having to do multiple transactions.
     * Emits an {Approval} event.
     */

    /**
    * @dev Implementation of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
    * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
    *
    * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
    * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
    * need to send a transaction, and thus is not required to hold Ether at all.
    *
    * _Available since v3.4._
    */

    function permit(
        address owner,
        address spender,
        uint256 nonce,
        uint256 expiry,
        bool allowed,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    // function nonces(address owner) external view returns (uint256);

    function DOMAIN_SEPARATOR() external view returns (bytes32);


    /**
     * Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    /**
     * Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// Root file: contracts/ERC20Permit.sol

pragma solidity ^0.8.0;

// import "contracts/IERC20.sol";

contract ERC20Permit is IERC20 {
    mapping (address => uint) public override balanceOf;
    mapping (address => mapping(address=>uint)) public override allowance;
    mapping (address => uint) private nonces;
    
    uint256 public override totalSupply;

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
                    keccak256("Permit(address owner,address spender,uint256 nonce,uint256 expiry,bool allowed)"),
                    owner,
                    spender,
                    nonce,
                    expiry,
                    allowed
                    ))
        ));

        // token contract address can't initiate permit functions
        require(owner != address(0), "address cannot be token address");
        
        // verify permit signature hash
        require(owner == ecrecover(permitHash, v, r, s), "invalid permit hash");
        
        // set expiry of approval timestamp
        require(expiry == 0 || block.timestamp <= expiry, "permit timestamp expired");
        
        // nonce must be unique for each permit function call
        require(nonce == nonces[owner]++, "invalid nonce");
        
        // set maximum uint allowances for token approval by user
        uint maxAllowance = type(uint).max;

        // update spender token allowance value after permit is verified
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
        totalSupply += amount;

        emit Transfer(address(0), account, amount);
    }

    function burn(address account, uint amount) external {
        balanceOf[account] -= amount;
        totalSupply -= amount;

        emit Transfer(account, address(0), amount);
    }
}