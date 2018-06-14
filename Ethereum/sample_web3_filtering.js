var Web3 = require('web3');
var web3 = new Web3();
web3.setProvider(new Web3.providers.HttpProvider("http://127.0.0.1:8547"));

var abi = /* abi however the compiler generates it */;
var Contract = web3.eth.contract(abi);
var CCProfile = Contract.at("0x1234...ab67" /* address */);

var createdEvent = CCProfile.NewRequest({reputationValue: [1,2,3]});
createdEvent.watch(function(err, result) {
  if (err) {
    console.log(err)
    return;
  }
  console.log("Found a new matching contract: ", result);
})
