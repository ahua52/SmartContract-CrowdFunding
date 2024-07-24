// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;
import "./context.sol";

contract MyToken is Context{
    // -1 token information
    // name
    string private _name;
    // symbol
    string private _symbol;
    // decimals
    uint8 private _decimals;
    // totalSupply
    uint256 private _totalSupply;
    // balance
    mapping(address => uint256) private _balance;
    //allowance
    mapping(address => mapping(address => uint256)) private _allowance;

    // -2 initiation
    constructor() {
        _name = "GuoyunCoin";
        _symbol = "GYC";
        _decimals = 18;
        //初始化货币池
        _mint(_msgSender(), 100 * 10000 * 10**_decimals);

    }

    // - 3 getter -

    // return the token name
    function name() public view returns(string memory) {
        return _name;
    }

    function symbol() public view returns(string memory) {
        return _symbol;
    }

    function decimals() public view returns(uint8) {
        return _decimals;
    }

    function totalSupply() public view returns(uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view returns(uint256) {
        return _balance[account];
    }

    //返回授权代币数值 allowanceOf()
    function allowanceOf(address owner,address spender) public view returns(uint256) {
        return _allowance[owner][spender];
    }

    // - 4. function -

    function transfer(address to, uint256 amount) public returns(bool) {
        address owner = _msgSender();
        //实现转账
        _transfer(owner,to,amount);
        return true;
    }
    //授权代币的转发
    function approve(address _spender, uint256 _amount) public  returns(bool) {
        // 一个账户授权给另外一个账户（一个账户借钱给另外一个账户）
        address owner = _msgSender();
        // owner 授权人   spender被授权人
        _approve(owner, _spender, _amount);
        return true;
    }

   
    // 授权代币转发
    function transferFrom(address _from, address _to, uint256 amount) public returns(bool) {
        address owner = _msgSender();
        // allowance账户做减少操作
        _spendAllowance(_from,owner,amount);
        //真正的转账操作
        //from:最初的放款人(银行)
        // to: 我自己，中介公司或者买房人
        _transfer(_from, _to, amount);

        return true;
    }

    // - 4. event -
    event Transfer(address from, address to, uint256 amount);
    event Approval(address owner, address spender, uint256 amount);

     // - the internal function of contract -
    function _mint(address account, uint256 amount) internal {
        // address(0) 发行此币初始地址
        require(account != address(0), "ERC20, mint to the zero address");
        // 初始化货币数量
        _totalSupply += amount;
        // 给某个账号注入起始资金 unchecked 不进行校验
        unchecked {
            _balance[account] += amount;
        }
    }

    function _transfer(address from, address to, uint256 amount) internal {
        //发行货币的账户（0账户）不能转钱出去或者不能给自己转钱
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");

        uint256 fromBalance = _balance[from];
        require(fromBalance >= amount, "ERC20: not sufficient funds");
        unchecked {
            _balance[from] = fromBalance - amount;
            _balance[to] += amount;
        }
        emit Transfer(from, to, amount);
    }

    function _approve(address owner, address spender, uint256 amount) internal {
        require(owner != address(0), "ERC20:approve from the zero address");
        require(spender != address(0), "ERC20:approve from the zero address");
        // 执行授权
        _allowance[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _spendAllowance(address from, address owner, uint256 amount) internal {
        uint256 currentAllowance = allowanceOf(from, owner);
        if(currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "ERC20: not sufficient funds");
            unchecked {
                _approve(from, owner, currentAllowance - amount);
            }
        }
    }
}
/*
        主体： 借款人，贷款人，中介公司，房屋出售者 account
        授权：贷款人（银行）借钱给我 approve 100w
        提款： 从银行贷款账户里提钱给自己 transferFrom 1w
        支付放款： 借款人转账给房屋出售者 transferFrom 90w
        支付佣金：借款人转账中介公司 transferFrom 9w
        0x03C6FcED478cBbC9a4FAB34eF9f40767739D1Ff7  中介

        0x5B38Da6a701c568545dCfcB03FcB875f56beddC4:{
            0x617F2E2fD72FD9D5503197092aC168c91465E7f2: 100
        }

    */