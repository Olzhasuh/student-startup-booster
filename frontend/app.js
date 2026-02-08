const connectBtn = document.getElementById("connectBtn");
const statusEl = document.getElementById("status");
const addressEl = document.getElementById("address");
const ethBalanceEl = document.getElementById("ethBalance");

const titleEl = document.getElementById("title");
const goalEthEl = document.getElementById("goalEth");
const durationEl = document.getElementById("duration");
const createBtn = document.getElementById("createBtn");

let provider;
let signer;
let userAddress;

// 🔴 АДРЕСА ИЗ deploy.js (У ТЕБЯ УЖЕ ПРАВИЛЬНЫЕ)
const boosterAddress = "0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512";

// ABI ТОЛЬКО ПОД СУЩЕСТВУЮЩИЙ КОНТРАКТ
const boosterAbi = [
  "function createCampaign(string title,uint256 goal,uint256 duration)"
];

async function refreshBalance() {
  if (!provider || !userAddress) return;

  const ethBal = await provider.getBalance(userAddress);
  ethBalanceEl.textContent = `ETH: ${ethers.formatEther(ethBal)}`;
}

async function connect() {
  if (!window.ethereum) {
    statusEl.textContent = "MetaMask is not installed";
    return;
  }

  const accounts = await window.ethereum.request({
    method: "eth_requestAccounts"
  });

  userAddress = accounts[0];
  provider = new ethers.BrowserProvider(window.ethereum);
  signer = await provider.getSigner();

  addressEl.textContent = userAddress;
  statusEl.textContent = "Connected";

  await refreshBalance();
}

async function createCampaign() {
  const title = titleEl.value;
  const goalWei = ethers.parseEther(goalEthEl.value);
  const duration = BigInt(durationEl.value);

  const booster = new ethers.Contract(
    boosterAddress,
    boosterAbi,
    signer
  );

  statusEl.textContent = "Creating campaign...";
  const tx = await booster.createCampaign(title, goalWei, duration);
  await tx.wait();

  statusEl.textContent = "Campaign created ✅";
  await refreshBalance();
}

connectBtn.onclick = connect;
createBtn.onclick = createCampaign;
