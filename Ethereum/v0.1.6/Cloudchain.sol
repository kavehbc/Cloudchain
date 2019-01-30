pragma solidity ^0.4.25;

/**
* Cloudchain v.0.1.6
* A blockchain based coopetition system in the cloud computing.
*
* Version History
*
* Version: 0.1.6 / 3 November 2018 / 0.4.25
* Introducing the role of a trusted verifier into Cloudchain
*
* Version: 0.1.5 / 1 June 2018 / 0.4.24
* DOI: https://doi.org/10.1007/978-3-030-03596-9_10
* Base Version
*/

//This is the registry contract, which stores the information of all cloud providers.
contract CCRegistry {

	struct CloudProvider {
		string providerName;
		uint8 reputationValue;
		uint computingCapacity;
		uint storageCapacity;
		uint totalVerifications;
		uint negativeVerifications;
		bool isRegistered;
	}

	mapping (address => CloudProvider) internal cloudProviders;

	/**
	* Registry event is consist of two parameters:
	* 1. providerAddress
	* 2. eventDetails:
	*	Registered: <ProviderName>
	*	Deactivated
	*	Reactivated
	*	Updated
	*	UpdatedReputation
	*/	
	event evRegistry(address indexed providerAddress, string eventDetails);

	//Checking if a cloud provider is registered.
	function isRegistered(address providerAddress) public view returns(bool isIndeed) {
		return (cloudProviders[providerAddress].isRegistered);
	}

	//Returning the reputation value of the given provider address.
	function getReputationValue(address providerAddress) public view returns(uint8 RV) {
		require(cloudProviders[providerAddress].isRegistered);
		return (cloudProviders[providerAddress].reputationValue);
	}
	
	//Returning the reputation value of the msg.sender.
	function getReputationValue() external view returns(uint8 ReputationValue) {
		require(cloudProviders[msg.sender].isRegistered);
		return (cloudProviders[msg.sender].reputationValue);
	}

	//Returning the verification status of the given provider address.
	function getVerifications(address providerAddress) public view returns(uint VerificationCount, uint NegativeVerifications) {
		require(cloudProviders[providerAddress].isRegistered);
		return (cloudProviders[providerAddress].totalVerifications, cloudProviders[providerAddress].negativeVerifications);
	}
	
	//Returning the verification status of the msg.sender
	function getVerifications() public view returns(uint VerificationCount, uint NegativeVerifications) {
		require(cloudProviders[msg.sender].isRegistered);
		return (cloudProviders[msg.sender].totalVerifications, cloudProviders[msg.sender].negativeVerifications);
	}
	

	//Registering a cloud provider in the registry data.
	function Register(string providerName, uint computingCapacity, uint storageCapacity) external {
		address providerAddress = msg.sender;
		require(!isRegistered(providerAddress) && computingCapacity > 0 && storageCapacity > 0); 
		cloudProviders[providerAddress].providerName = providerName;
		cloudProviders[providerAddress].reputationValue = 100;
		cloudProviders[providerAddress].computingCapacity = computingCapacity;
		cloudProviders[providerAddress].storageCapacity = storageCapacity;
		cloudProviders[providerAddress].totalVerifications = 0;
		cloudProviders[providerAddress].negativeVerifications = 0;
		cloudProviders[providerAddress].isRegistered = true;
		emit evRegistry(providerAddress, strConcat("Registered: ", providerName));
	}

	//Deactivating the provider.
	function Deactivate() external {
		address providerAddress = msg.sender;
		require(isRegistered(providerAddress));
		cloudProviders[providerAddress].isRegistered = false;
		emit evRegistry(providerAddress, "Deactivated");
	}

	//Reactivating the provider
	function Reactivate() external {
		address providerAddress = msg.sender;
		require(!isRegistered(providerAddress));
		cloudProviders[providerAddress].isRegistered = true;
		emit evRegistry(providerAddress, "Reactivated");
	}

	//Updating the provider details. Access is resitricted to the provider herself.
	function Update(string providerName, uint computingCapacity, uint storageCapacity) external {
		address providerAddress = msg.sender;
		require(isRegistered(providerAddress));
		cloudProviders[providerAddress].providerName = providerName;
		cloudProviders[providerAddress].computingCapacity = computingCapacity;
		cloudProviders[providerAddress].storageCapacity = storageCapacity;
		emit evRegistry(providerAddress, "Updated");
	}

	//Updating the provider verification count. Access is password protected.
	function UpdateVerificationCount(address providerAddress, int password) external {
		require(isRegistered(providerAddress) && password == 12345);
		cloudProviders[providerAddress].totalVerifications += 1;
		emit evRegistry(providerAddress, "VUpdated");
	}
		
	//Updating the provider negative verification count. Access is password protected.
	function UpdateNegativeVerification(address providerAddress, int password) external {
		require(isRegistered(providerAddress) && password == 12345);
		cloudProviders[providerAddress].negativeVerifications += 1;
		emit evRegistry(providerAddress, "NVUpdated");
	}

	//Updating supplier reputation value.
	//This function is used only from CCContract. To protected it from malicious calls, it requires an execution password. 
	function UpdateReputationValue(address providerAddress, uint8 reputationValue, int password) public {
		require(providerAddress != address(0) && password == 12345);
		cloudProviders[providerAddress].reputationValue = (cloudProviders[providerAddress].reputationValue + reputationValue)/2;
		emit evRegistry(providerAddress, "UpdatedReputation");
	}
	
	//These are string concatenate functions in Solidity.
	function strConcat(string _a, string _b) internal pure returns (string){
		bytes memory _ba = bytes(_a);
		bytes memory _bb = bytes(_b);
		//bytes memory _bc = bytes(_c);
		//bytes memory _bd = bytes(_d);
		//bytes memory _be = bytes(_e);
		string memory abcde = new string(_ba.length + _bb.length); // + _bc.length + _bd.length + _be.length
		bytes memory babcde = bytes(abcde);
		uint k = 0;
		for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
		for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
		//for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
		//for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
		//for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
		return (string(babcde));
	}
}

//All requests are registered in this contract.
contract CCProfile {

	struct Profile {
		address contractAddress;
		address requesterAddress;
	}

	Profile[] internal cloudProfiles;
		
	/**
	* Potential suppliers can track the new requests by filtering this event.
	* This event contains:
	*	the new contract address (new request),
	*	the address of requester,
	*	the minimum required reputation value to respond,
	*	proposed contract payoff.
	*/
	event NewRequest(address contractAddress, address indexed requesterAddress,
					uint8 indexed reputationValue, uint Deposit);
	
	/**
	* New contract requests are registered, and created.
	* This function is payable, and requester can pay her contract payoff when she creates a new request.
	* contractEnd is the time in unix timestamp.
	*/
	function Request(string SLA, string serviceData, uint8 reputationValue, uint64 contractEnd) payable external returns(address NewContract){
		address requesterAddress = msg.sender;
		Profile memory newProfile;
		newProfile.requesterAddress = requesterAddress;
		
		//New contract is created based on CCContract.
		address newContract = (new CCContract).value(msg.value)(requesterAddress, stringToBytes32(SLA), stringToBytes32(serviceData),
								contractEnd, reputationValue);

		//Newly created contract information is registered in this contract.
		newProfile.contractAddress = newContract;
		cloudProfiles.push(newProfile);
		emit NewRequest(newContract, requesterAddress, reputationValue, msg.value);
		return (newContract);
	}

	//Return the total number of registered contracts.
	function getNoContracts() external view returns (uint NoC){
		return (cloudProfiles.length);
	}
	
	//Read each profile detail by Index.
	function getContractByIndex(uint Index) external view
			returns (address contractAddress, address requesterAddress){
			
		require (Index <= (cloudProfiles.length - 1));
		return (cloudProfiles[Index].contractAddress, cloudProfiles[Index].requesterAddress);
	}
	
	function stringToBytes32(string memory source) internal pure returns (bytes32 result) {
		bytes memory tempEmptyStringTest = bytes(source);
		if (tempEmptyStringTest.length == 0) {
			return (0x0);
		}
		assembly {
			result := mload(add(source, 32))
		}
	}
}

//This is the contract between the beneficiaries.
contract CCContract {

	//Contract internal Data;
	//struct Contract {
		address _requesterAddress;
		address _supplierAddress;
		address _verifierAddress;
		
		/**
		0: Cancelled,
		1: Pending,
		2: Accepted - Inprocess,
		3: Completed,
		4: Updated Deposit,
		5: Updated Verification Deposit,
		6: Verification Requested,
		7: Verification Completed
		*/
		uint8 _contractStatus;
		
		/**
		0: Not-innitiated,
		1: In process,
		2: In favor of Supplier,
		3: In favor of Requester,
		*/
		uint8 _verificationResult;
		uint64 _contractEnd; //contractEnd is the time in blockchain timestamp
		string _SLA;
		string _serviceData;
		uint8 _minReputationValue; //The minimum reputation required for supplier to accept an offer.
		uint256 _Deposit; //Total deposited into the contract it may be equal or greater than the contract balance.
		uint256 _verSupplierDeposit; //Total deposited for verification by supplier.
		uint256 _verRequesterDeposit; //Total deposited for verification by requester.
	//}

	//To track the status of the contract
	event evContract(address indexed contractAddress, address indexed requesterAddress, uint8 indexed contractStatus);
	event evVerification(address indexed contractAddress, uint8 indexed verificationStatus);

	constructor(address requesterAddress, bytes32 SLA, bytes32 serviceData,
				uint64 contractEnd, uint8 minReputationValue) payable public {
		_requesterAddress = requesterAddress;

		// This is the trusted verifier address - a sample address
		_verifierAddress = 0x692a70D2e424a56D2C6C27aA97D1a86395877b3A;

		_contractStatus = 1;
		_verificationResult = 0;
		_contractEnd = contractEnd;
		_SLA = bytes32ToString(SLA);
		_serviceData = bytes32ToString(serviceData);
		_minReputationValue = minReputationValue;
		_Deposit = msg.value;
		_verSupplierDeposit = 0;
		_verRequesterDeposit = 0;
		emit evContract(this, requesterAddress, 1);
	}

	//Throws if called by any account other than the requester.
	modifier onlyRequester() {
		require(msg.sender == _requesterAddress);
		_;
	}

	//Throws if called by any account other than the supplier.
	modifier onlySupplier() {
		require(msg.sender == _supplierAddress);
		_;
	}

	//Throws if called by any account other than the verifier.
	modifier onlyVerifier() {
		require(msg.sender == _verifierAddress);
		_;
	}

	//Throws if called by any account other than the beneficiaries.
	modifier onlyBeneficiaries() {
		require(msg.sender == _supplierAddress || msg.sender == _requesterAddress);
		_;
	}

	//Returns the status of the contract.
	function getStatus() external view returns (uint8){
		return (_contractStatus);
	}

	function getVerficationResult() external view returns (uint8){
		return (_verificationResult);
	}

	//Returns the balance of the contract.
	function getBalance() external view returns (uint256 Deposit, uint256 VerificationDeposit, uint256 Balance){
		return (_Deposit, _verSupplierDeposit + _verRequesterDeposit, address(this).balance);
	}
	
	//Returns the details of the contract.
	function Read() external view
			returns (
			address Requester, address Supplier, uint8 Status,
			uint8 minReputationValue, uint64 EndTime, string SLA,
			string ServiceData, uint256 Deposit, uint8 VerificationStatus, uint256 VerificationDeposit){
			
		return (_requesterAddress, _supplierAddress, _contractStatus,
				_minReputationValue, _contractEnd, _SLA, _serviceData, _Deposit,
				_verificationResult, _verSupplierDeposit + _verRequesterDeposit);
	}

	//A provider with a reputation value more than minimum requested can accept the offer.
	function Accept(address registryAddress) payable external returns (bool){

		//1 Ether is set as the minimum deposit amount for the verification
		require(_requesterAddress != msg.sender && _contractStatus == 1 && msg.value >= 1 ether, "Conditions are not met.");
		
		//Checking if the reputation value of the supplier is match with the request.
		CCRegistry registry = CCRegistry(registryAddress);
		uint8 supplierReputationValue = registry.getReputationValue(msg.sender);

		if (_minReputationValue <= supplierReputationValue) {
			address supplierAddress = msg.sender;
			_supplierAddress = supplierAddress;
			_contractStatus = 2;
			_verSupplierDeposit = msg.value;
			emit evContract(this, msg.sender, 2);
			return (true);
		} else {
			revert("Conditions are not met.");
		}
	}

	/**
	* Requester can pay to this contract to increase the contract balance
	* This update is marked by status 4 in the log only.
	* This function does not update the status in the contract storage.
	*/
	function Pay() payable onlyRequester external{
		_Deposit += msg.value;
		emit evContract(this, msg.sender, 4);
	}

	function PayVerificationDeposit() payable onlyBeneficiaries external{
		if (msg.sender == _supplierAddress) {
			_verSupplierDeposit += msg.value;
		}else {
			_verRequesterDeposit += msg.value;		
		}
		emit evContract(this, msg.sender, 5);
	}
	
	/**
	* Requester completes/ends the contract after the contract time period is over,
	* requester sets the reputation value for the reposonder,
	* the offer payoff (Ether) would be transfered from the contract to the supplier.
	*/
	function Complete (uint8 reputationValue, address registryAddress) external onlyRequester {
		//Requester confirms the completion
		require (_contractEnd <= now && registryAddress != address(0));
		_contractStatus = 3;
		address supplierAddress = _supplierAddress;
		
		//Rating the supplier (reputationValue)
		CCRegistry registry = CCRegistry(registryAddress);
		registry.UpdateReputationValue(supplierAddress, reputationValue, 12345);

		//Deposit is transfered to supplier
		//uint GAS_LIMIT = 4000000;
		Withdraw();
		emit evContract(this, _requesterAddress, 3);
	}

	/**
	* There are two conditions that this function may be required:
	* 1. If for any reason the Complete function fails to transfer the contract balance to the supplier.
	* 2. Requester has increased the contract Deposit value after completing the contract.
	* This function can be called to withdraw any remaining balance to the supplier account.
	*/
	function Withdraw() public onlyBeneficiaries{
		require (_contractStatus == 3);
		
		if (address(this).balance > 0 && _verRequesterDeposit > 0){
			_requesterAddress.transfer(_verRequesterDeposit);
			_verRequesterDeposit = 0;
		}
		if (address(this).balance > 0){
    		_supplierAddress.transfer(address(this).balance);
			if (_verSupplierDeposit > 0)
				_verSupplierDeposit = 0;
		}
	}
	
	//Requester/Supplier can cancel the request if it has not been accepted/completed yet.
	function Cancel() external {
		require ((_requesterAddress == msg.sender && _contractStatus == 1)
				|| (_supplierAddress == msg.sender && _contractStatus == 2));
		_contractStatus = 0;
		
		//The paid deposit is refunded back to the requester.
		//uint GAS_LIMIT = 4000000;
		if (address(this).balance > 0){
    		_requesterAddress.transfer(_Deposit + _verRequesterDeposit);
			if (_verSupplierDeposit > 0)
				_supplierAddress.transfer(_verSupplierDeposit);
		}	
		emit evContract(this, msg.sender, 0);
	}

	//Verification request will be initiated by the service requester.
	function Verify(address registryAddress) payable onlyRequester external{
		require (_contractStatus == 2);
		_contractStatus == 6;
		_verificationResult = 1;
		_verRequesterDeposit += msg.value;

		CCRegistry registry = CCRegistry(registryAddress);
		registry.UpdateVerificationCount(_supplierAddress, 12345);

		emit evContract(this, msg.sender, 6);
		emit evVerification(this, 1);
	}

	//Verification request will be initiated by the service requester.
	function ReportVerification(bool Report, address registryAddress) external onlyVerifier{
		require (_contractStatus == 6 && _verificationResult == 1);
		_contractStatus == 2;
		_verificationResult = 0;
		
		if (Report) {
			//In favor of supplier
			_verRequesterDeposit = 0;
			_verifierAddress.transfer(_verRequesterDeposit);
			emit evVerification(this, 2);
		}else{
			//In favor of requester
			_verSupplierDeposit = 0;
			_verifierAddress.transfer(_verSupplierDeposit);

			CCRegistry registry = CCRegistry(registryAddress);
			registry.UpdateNegativeVerification(_supplierAddress, 12345);
			
			emit evVerification(this, 3);
		}
		emit evContract(this, msg.sender, 7);
	}
	
	function bytes32ToString(bytes32 x) internal pure returns (string) {
		bytes memory bytesString = new bytes(32);
		uint charCount = 0;
		for (uint j = 0; j < 32; j++) {
			byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
			if (char != 0) {
				bytesString[charCount] = char;
				charCount++;
			}
		}
		bytes memory bytesStringTrimmed = new bytes(charCount);
		for (j = 0; j < charCount; j++) {
			bytesStringTrimmed[j] = bytesString[j];
		}
		return (string(bytesStringTrimmed));
	}

	function bytes32ArrayToString(bytes32[] data) internal pure returns (string) {
		bytes memory bytesString = new bytes(data.length * 32);
		uint urlLength;
		for (uint i=0; i<data.length; i++) {
			for (uint j=0; j<32; j++) {
				byte char = byte(bytes32(uint(data[i]) * 2 ** (8 * j)));
				if (char != 0) {
					bytesString[urlLength] = char;
					urlLength += 1;
				}
			}
		}
		bytes memory bytesStringTrimmed = new bytes(urlLength);
		for (i=0; i<urlLength; i++) {
			bytesStringTrimmed[i] = bytesString[i];
		}
		return (string(bytesStringTrimmed));
	}
}
