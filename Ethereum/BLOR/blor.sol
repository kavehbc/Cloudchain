pragma solidity >=0.4.22 <0.7.0;
import "./math.sol";

contract BLOR {
    
    Math math;
    
    struct Oracle {
		string oracleName;
		uint8 SuccessCount;
		uint8 FailureCount;
		uint cost;
		bool isActive;
	}
	
    struct Variables {
	    int p_o_success;
        int p_o_fail;
        int p_teta;
        int gamma;
        int p_o_success_teta;
        int p_o_fail_teta;
        int x;
        int a;
        int a_prim;
        int b;
        int b_prim;
        int[] b_t_success;
        int[] b_t_fail;
        int[] part_1;
        int[] part_2;
        int[] part_3;
        
        int max_value;
        uint max_index;
        int max_value_2;
        uint max_index_2;
        int[] c_n;
        int[] k_g;
        int degree_value;
        int[] degree;
    }


	mapping (address => Oracle) internal Oracles;
	address[] OracleAddresses;
	
	constructor() public {
	    math = new Math();
	    
	    // TODO: initializing sample Oracles
	    // ...
	}
	
	function isActive(address providerAddress) public view returns(bool isIndeed) {
		return (Oracles[providerAddress].isActive);
	}
	
	function getCost(address providerAddress) public view returns(uint Cost) {
		require(Oracles[providerAddress].isActive);
		return (Oracles[providerAddress].cost);
	}
	
	function getSuccessCount(address providerAddress) public view returns(uint count) {
		require(Oracles[providerAddress].isActive);
		return (Oracles[providerAddress].SuccessCount);
	}

	function getFailureCount(address providerAddress) public view returns(uint count) {
		require(Oracles[providerAddress].isActive);
		return (Oracles[providerAddress].FailureCount);
	}
	
	function selectOracle() public returns(address){
	    uint number_of_oracles = Oracles.length;
	    address oracleAddress;
	    Oracle oracle;
	    
	    Variables vars;
        uint oracle_index;
        int degree_max = 0;
        uint oracle_index_max = 0;
        
	    int maximum;
	    uint maximum_index;
	    
	    int maximum_2;
	    uint maximum_2_index;


	    for (oracle_index = 0; oracle_index < number_of_oracles; oracle_index++){
	        oracleAddress = OracleAddresses[oracle_index];
	        oracle = Oracles[oracleAddress];
	        
	        
	        vars.p_o_success = oracle.SuccessCount;
	        vars.p_o_fail = oracle.FailureCount;
	        
	        vars.p_teta = vars.p_o_success; // 0.6 ~ reward rate
            vars.gamma = 0.7; // weight of prior
            
            vars.p_o_success_teta = ((1 * vars.p_o_success) / vars.p_teta) / 2 / oracle.cost;
            vars.p_o_fail_teta = ((1 * vars.p_o_fail) / vars.p_teta) / 2 / oracle.cost;
            
            vars.x = 0.7; //math.random() #0.7
            vars.a = vars.p_o_success;
            vars.a_prim = vars.a + 1;
            
            vars.b = vars.p_o_fail;
            vars.b_prim = vars.b + 1;
            
            vars.b_t_success[oracle_index] = vars.gamma * (vars.p_o_success_teta * vars.b_t_success[oracle_index]) + ((1 - vars.gamma) * math.beta_pdf(vars.x, vars.a_prim, vars.b_prim, 0, 100));
            vars.b_t_fail[oracle_index] = vars.gamma * (vars.p_o_fail_teta * vars.b_t_fail[oracle_index]) + ((1 - vars.gamma) * math.beta_pdf(vars.x, vars.a_prim, vars.b_prim, 0, 100));
	     
            vars.part_1[oracle_index] = (vars.a)/(vars.a + vars.b + 1);
            vars.part_2[oracle_index] = (vars.a)/(vars.a + vars.b);
            vars.part_3[oracle_index] = (vars.a + 1)/(vars.a + vars.b + 1);
	    }
	    
	    for (oracle_index = 0; oracle_index < number_of_oracles; oracle_index++){
	        racleAddress = OracleAddresses[oracle_index];
	        oracle = Oracles[oracleAddress];
	        
	        (vars.max_value, vars.max_index, vars.max_value_2, vars.max_index_2) = max(vars.part_2);
	        
	        if (vars.max_index != oracle_index){
	            vars.c_n[oracle_index] = vars.max_value;
	        }else{
	            // get the second maximum number
	            // max_value: get the second max_value
	            vars.c_n[oracle_index] = vars.max_value_2;
	        }
	        
	        if (vars.c_n[oracle_index] < vars.part_3[oracle_index] && vars.c_n[oracle_index] >= vars.part_2[oracle_index])
	        {
	            vars.k_g[oracle_index] = vars.b_t_success[oracle_index] * (vars.part_3[oracle_index] - vars.c_n[oracle_index]);
	        }
	        else if (vars.c_n[oracle_index] < vars.part_2[oracle_index] && vars.c_n[oracle_index] >= vars.part_1[oracle_index])
	        {
	            vars.k_g[oracle_index] = vars.b_t_fail[oracle_index] * (vars.c_n[oracle_index] - vars.part_1[oracle_index]);
	        }
	        else
	        {
	            vars.k_g[oracle_index] = 0;
	        }
	        
	        // calculating degree
            vars.degree_value = vars.b_t_success[oracle_index] + (vars.k_g[oracle_index]);
            vars.degree[oracle_index] = vars.degree_value;
            
            if (vars.degree_value > degree_max){
                degree_max = vars.degree_value;
                oracle_index_max = oracle_index;
            }
	    }
	    
	    // returning the oracle address with maximum degree
	    oracleAddress = OracleAddresses[oracle_index_max];
	    return(oracleAddress);
	}
	
	function max(int[] part) public returns (int, uint, int, uint){
	    uint i;
	    int maximum = part[0];
	    uint maximum_index = 0;
	    
	    int maximum_2 = part[0];
	    uint maximum_2_index = 0;
	    
	    for (i = 0; i < part.length; i++){

	        if (maximum < part[i]){
	            maximum = part[i];
	            maximum_index = i;
	        }
	        
	        if ((part[i] > maximum_2) && (part[i] < maximum)){
	            maximum_2 = part[i];
	            maximum_2_index = i;
	        }
	    }
	    
	    return(maximum, maximum_index, maximum_2, maximum_2_index);
	}
	
    
}
