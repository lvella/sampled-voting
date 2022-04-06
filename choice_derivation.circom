pragma circom 2.0.0;

include "./maci/circuits/circom/privToPubKey.circom";
include "./maci/circuits/node_modules/circomlib/circuits/poseidon.circom";

template ChoiceDerivation() {
    signal input privateKey;
    signal input publicKey[2];
    signal input lastSignupBlockHash[2];
    signal output hash;

    // Ensures the publicKey corresponds to the privateKey.
    component pubkeyDerivation = PrivToPubKey();
    pubkeyDerivation.privKey <== privateKey;

    pubkeyDerivation.pubKey[0] === publicKey[0];
    pubkeyDerivation.pubKey[1] === publicKey[1];

    // Hash together private key and block hash,
    // value is used externally to choose a candidate.
    component poseidon = Poseidon(3);
    poseidon.inputs[0] <== privateKey;
    poseidon.inputs[1] <== lastSignupBlockHash[0];
    poseidon.inputs[2] <== lastSignupBlockHash[1];

    hash <== poseidon.out;
}

component main {public [publicKey, lastSignupBlockHash]} = ChoiceDerivation();
