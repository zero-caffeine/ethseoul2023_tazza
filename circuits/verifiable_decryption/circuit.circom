pragma circom 2.0.0;

include "../circomlib/babyjub.circom";
include "../lib/encode.circom";
include "../lib/babyjub.circom";

template VerifiableDecryption(players) {
    signal input M;
    signal input y[2];
    signal input c1[2];
    signal input c2[2];
    signal input d_others[players - 1][2];
    signal input x;
    signal output d[2];

    signal y_[2];
    (y_[0], y_[1]) <== BabyPbk()(in <== x);
    y === y_;

    signal m[2];
    m <== Encode()(in <== M);

    d <== BabyPower()(x <== x, g <== c1);

    signal sum[players + 1][2];
    sum[0] <== m;
    for(var i = 0; i < players - 1; i++) {
        (sum[i + 1][0], sum[i + 1][1]) <== BabyAdd()(x1 <== sum[i][0], y1 <== sum[i][1], x2 <== d_others[i][0], y2 <== d_others[i][1]);
    }
    (sum[players][0], sum[players][1]) <== BabyAdd()(x1 <== sum[players - 1][0], y1 <== sum[players - 1][1], x2 <== d[0], y2 <== d[1]);

    sum[players] === c2;
}

component main {public [M, y, c1, c2, d_others]} = VerifiableDecryption(2);
