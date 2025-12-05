// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title Simple ERC-20 compatible token for learning
contract MyToken {
    // -------------------------
    //  Token metadata
    // -------------------------

    // Public variables so Remix and other contracts can read them directly
    string public name = "MyToken";      // e.g. "MyToken"
    string public symbol = "MTK";        // e.g. "MTK"
    uint8 public decimals = 18;          // Standard for ERC-20

    // Total supply of tokens (in smallest units, like wei for ETH)
    uint256 public totalSupply;

    // -------------------------
    //  Balances & Allowances
    // -------------------------

    // Mapping from address to token balance
    mapping(address => uint256) public balanceOf;

    // Nested mapping: owner => (spender => allowance)
    mapping(address => mapping(address => uint256)) public allowance;

    // -------------------------
    //  Events
    // -------------------------

    // Emitted when tokens are moved between addresses
    event Transfer(address indexed from, address indexed to, uint256 value);

    // Emitted when an allowance is set/changed
    event Approval(address indexed owner, address indexed spender, uint256 value);

    // -------------------------
    //  Constructor
    // -------------------------

    /// @notice Deploy the token with an initial supply given to the deployer
    /// @param _initialSupply Total supply in smallest units (e.g. 1,000,000 * 10**18)
    constructor(uint256 _initialSupply) {
        require(_initialSupply > 0, "Initial supply must be greater than 0");

        totalSupply = _initialSupply;

        // Give all tokens to the contract deployer (msg.sender)
        balanceOf[msg.sender] = _initialSupply;

        // Emit a Transfer from address(0) to show minting of initial supply
        emit Transfer(address(0), msg.sender, _initialSupply);
    }

    // -------------------------
    //  Core ERC-20 Functions
    // -------------------------

    /// @notice Transfer tokens from caller to another address
    /// @param _to Recipient address
    /// @param _value Amount to send (in smallest units)
    /// @return success True if transfer succeeded
    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(_to != address(0), "Cannot transfer to zero address");
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");

        // Subtract from sender
        balanceOf[msg.sender] -= _value;
        // Add to recipient
        balanceOf[_to] += __value;

        // Emit event AFTER state change
        emit Transfer(msg.sender, _to, _value);

        return true;
    }

    /// @notice Approve another address to spend tokens on your behalf
    /// @param _spender Address allowed to spend your tokens
    /// @param _value Allowance amount
    /// @return success True if approval succeeded
    function approve(address _spender, uint256 _value) public returns (bool success) {
        require(_spender != address(0), "Cannot approve zero address");

        // Set spender's allowance
        allowance[msg.sender][_spender] = _value;

        // Emit event AFTER state change
        emit Approval(msg.sender, _spender, _value);

        return true;
    }

    /// @notice Transfer tokens from one address to another using allowance
    /// @param _from Address to move tokens from
    /// @param _to Recipient address
    /// @param _value Amount to move
    /// @return success True if transfer succeeded
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_to != address(0), "Cannot transfer to zero address");
        require(balanceOf[_from] >= _value, "Insufficient balance");
        require(allowance[_from][msg.sender] >= __value, "Insufficient allowance");

        // Update balances
        balanceOf[_from] -= __value;
        balanceOf[_to] += __value;

        // Decrease allowance
        allowance[_from][msg.sender] -= __value;

        // Emit event AFTER state change
        emit Transfer(_from, _to, _value);

        return true;
    }

    // -------------------------
    //  Helper / Info Functions
    // -------------------------

    /// @notice Get total token supply
    function getTotalSupply() public view returns (uint256) {
        return totalSupply;
    }

    /// @notice Get token info in one call
    function getTokenInfo()
        public
        view
        returns (string memory, string memory, uint8, uint256)
    {
        return (name, symbol, decimals, totalSupply);
    }
}
